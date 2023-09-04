/mob/living/carbon/Life(delta_time = SSMOBS_DT, times_fired)

	if(notransform)
		return

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	if(IS_IN_STASIS(src))
		. = ..()
		reagents.handle_stasis_chems(src, delta_time, times_fired)
	else
		//Reagent processing needs to come before breathing, to prevent edge cases.
		handle_organs(delta_time, times_fired)

		. = ..()
		if(QDELETED(src))
			return

		if(.) //not dead
			handle_blood(delta_time, times_fired)
			handle_hydration(delta_time, times_fired)

		if(stat != DEAD)
			handle_brain_damage(delta_time, times_fired)

	if(stat == DEAD)
		stop_sound_channel(CHANNEL_HEARTBEAT)
	else
		var/bprv = handle_bodyparts(delta_time, times_fired)
		if(bprv & BODYPART_LIFE_UPDATE_HEALTH)
			update_stamina() //needs to go before updatehealth to remove stamcrit
			updatehealth()

	check_cremation(delta_time, times_fired)

	//Updates the number of stored chemicals for powers
	handle_changeling(delta_time, times_fired)

	if(. && mind) //. == not dead
		for(var/key in mind.addiction_points)
			var/datum/addiction/addiction = SSaddiction.all_addictions[key]
			addiction.process_addiction(src, delta_time, times_fired)
	if(stat != DEAD)
		return 1

///////////////
// BREATHING //
///////////////

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing(delta_time, times_fired)
	var/next_breath = 4
	var/obj/item/organ/lungs/L = get_organ_slot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/heart/H = get_organ_slot(ORGAN_SLOT_HEART)
	if(L)
		if(L.damage > L.high_threshold)
			next_breath--
	if(H)
		if(H.damage > H.high_threshold)
			next_breath--

	if((times_fired % next_breath) == 0 || failed_last_breath)
		breathe(delta_time, times_fired) //Breathe per 4 ticks if healthy, down to 2 if our lungs or heart are damaged, unless suffocating
		if(failed_last_breath)
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "suffocation", /datum/mood_event/suffocation)
		else
			SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "suffocation")
	else
		if(istype(loc, /obj/))
			var/obj/location_as_object = loc
			location_as_object.handle_internal_lifeform(src,0)

//Second link in a breath chain, calls check_breath()
/mob/living/carbon/proc/breathe()
	var/obj/item/organ/lungs = get_organ_slot(ORGAN_SLOT_LUNGS)
	if(reagents.has_reagent(/datum/reagent/toxin/lexorin, needs_metabolizing = TRUE))
		return
	if(istype(loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	var/datum/gas_mixture/environment
	if(loc)
		environment = loc.return_air()

	var/datum/gas_mixture/breath

	if(!get_organ_slot(ORGAN_SLOT_BREATHING_TUBE))
		if(health <= HEALTH_THRESHOLD_FULLCRIT || (pulledby && pulledby.grab_state >= GRAB_KILL) || HAS_TRAIT(src, TRAIT_MAGIC_CHOKE) || !lungs || lungs.organ_flags & ORGAN_FAILING)
			losebreath++  //You can't breath at all when in critical or when being choked, so you're going to miss a breath

		else if(health <= crit_threshold)
			losebreath += 0.25 //You're having trouble breathing in soft crit, so you'll miss a breath one in four times

	//Suffocate
	if(losebreath >= 1) //You've missed a breath, take oxy damage
		losebreath--
		if(prob(10))
			INVOKE_ASYNC(src, PROC_REF(emote), "gasp")
		if(isobj(loc))
			var/obj/loc_as_obj = loc
			loc_as_obj.handle_internal_lifeform(src,0)
	else
		//Breathe from internal
		breath = get_breath_from_internal(BREATH_VOLUME)

		if(isnull(breath)) //in case of 0 pressure internals

			if(isobj(loc)) //Breathe from loc as object
				var/obj/loc_as_obj = loc
				breath = loc_as_obj.handle_internal_lifeform(src, BREATH_VOLUME)

			else if(isturf(loc)) //Breathe from loc as turf
				var/breath_moles = 0
				if(environment)
					breath_moles = environment.total_moles()*BREATH_PERCENTAGE

				breath = loc.remove_air(breath_moles)
		else //Breathe from loc as obj again
			if(isobj(loc))
				var/obj/loc_as_obj = loc
				loc_as_obj.handle_internal_lifeform(src,0)

	check_breath(breath)

	if(breath)
		loc.assume_air(breath)
		air_update_turf()

/mob/living/carbon/proc/has_smoke_protection()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	return FALSE


//Third link in a breath chain, calls handle_breath_temperature()
/mob/living/carbon/proc/check_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return

	var/obj/item/organ/lungs = get_organ_slot(ORGAN_SLOT_LUNGS)
	if(!lungs)
		adjustOxyLoss(2)

	//CRIT
	if(!breath || (breath.total_moles() == 0) || !lungs)
		if(reagents.has_reagent(/datum/reagent/medicine/epinephrine, needs_metabolizing = TRUE) && lungs)
			return
		adjustOxyLoss(1)

		failed_last_breath = 1
		throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)
		return 0

	var/safe_oxy_min = 16
	var/safe_co2_max = 10
	var/safe_tox_max = 0.05
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/oxygen_used = 0
	var/moles = breath.total_moles()
	var/breath_pressure = (moles*R_IDEAL_GAS_EQUATION*breath.return_temperature())/BREATH_VOLUME
	var/O2_partialpressure = ((breath.get_moles(GAS_O2)/moles)*breath_pressure) + (((breath.get_moles(GAS_PLUOXIUM)*8)/moles)*breath_pressure)
	var/Toxins_partialpressure = (breath.get_moles(GAS_PLASMA)/moles)*breath_pressure
	var/CO2_partialpressure = (breath.get_moles(GAS_CO2)/moles)*breath_pressure


	//OXYGEN
	if(O2_partialpressure < safe_oxy_min) //Not enough oxygen
		if(prob(20))
			emote("gasp")
		if(O2_partialpressure > 0)
			var/ratio = 1 - O2_partialpressure/safe_oxy_min
			adjustOxyLoss(min(5*ratio, 3))
			failed_last_breath = 1
			oxygen_used = breath.get_moles(GAS_O2)*ratio
		else
			adjustOxyLoss(3)
			failed_last_breath = 1
		throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)

	else //Enough oxygen
		failed_last_breath = 0
		if(health >= crit_threshold)
			adjustOxyLoss(-5)
		oxygen_used = breath.get_moles(GAS_O2)
		clear_alert("not_enough_oxy")

	breath.adjust_moles(GAS_O2, -oxygen_used)
	breath.adjust_moles(GAS_CO2, oxygen_used)

	//CARBON DIOXIDE
	if(CO2_partialpressure > safe_co2_max)
		if(!co2overloadtime)
			co2overloadtime = world.time
		else if(world.time - co2overloadtime > 120)
			Unconscious(60)
			adjustOxyLoss(3)
			if(world.time - co2overloadtime > 300)
				adjustOxyLoss(8)
		if(prob(20))
			emote("cough")

	else
		co2overloadtime = 0

	//TOXINS/PLASMA
	if(Toxins_partialpressure > safe_tox_max)
		var/ratio = (breath.get_moles(GAS_PLASMA)/safe_tox_max) * 10
		adjustToxLoss(clamp(ratio, MIN_TOXIC_GAS_DAMAGE, MAX_TOXIC_GAS_DAMAGE))
		throw_alert("too_much_tox", /atom/movable/screen/alert/too_much_tox)
	else
		clear_alert("too_much_tox")

	//NITROUS OXIDE
	if(breath.get_moles(GAS_N2O))
		var/SA_partialpressure = (breath.get_moles(GAS_N2O)/breath.total_moles())*breath_pressure
		if(SA_partialpressure > SA_para_min)
			Unconscious(60)
			if(SA_partialpressure > SA_sleep_min)
				Sleeping(max(AmountSleeping() + 40, 200))
		else if(SA_partialpressure > 0.01)
			if(prob(20))
				emote(pick("giggle","laugh"))
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")

	//BZ (Facepunch port of their Agent B)
	if(breath.get_moles(GAS_BZ))
		var/bz_partialpressure = (breath.get_moles(GAS_BZ)/breath.total_moles())*breath_pressure
		if(bz_partialpressure > 1)
			hallucination += 10
		else if(bz_partialpressure > 0.01)
			hallucination += 5

	//TRITIUM
	if(breath.get_moles(GAS_TRITIUM))
		var/tritium_partialpressure = (breath.get_moles(GAS_TRITIUM)/breath.total_moles())*breath_pressure
		radiation += tritium_partialpressure/10

	//nitrium
	if(breath.get_moles(GAS_NITRIUM))
		var/nitrium_partialpressure = (breath.get_moles(GAS_NITRIUM)/breath.total_moles())*breath_pressure
		adjustFireLoss(nitrium_partialpressure/4)

	//MIASMA
	if(breath.get_moles(GAS_MIASMA))
		var/miasma_partialpressure = (breath.get_moles(GAS_MIASMA)/breath.total_moles())*breath_pressure

		if(prob(1 * miasma_partialpressure))
			var/datum/disease/advance/miasma_disease = new /datum/disease/advance/random(2,3)
			miasma_disease.name = "Unknown"
			ForceContractDisease(miasma_disease, TRUE, TRUE)

		//Miasma side effects
		switch(miasma_partialpressure)
			if(0.25 to 5)
				// At lower pp, give out a little warning
				SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "smell")
				if(prob(5))
					to_chat(src, span_notice("Здесь неприятно пахнет."))
			if(5 to 20)
				//At somewhat higher pp, warning becomes more obvious
				if(prob(15))
					to_chat(src, span_warning("Здесь точно что-то гниёт и неплохо так отдаёт запахом."))
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/bad_smell)
			if(15 to 30)
				//Small chance to vomit. By now, people have internals on anyway
				if(prob(5))
					to_chat(src, span_warning("Запах гниющей плоти бьёт мне прямо в нос!"))
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
					vomit()
			if(30 to INFINITY)
				//Higher chance to vomit. Let the horror start
				if(prob(25))
					to_chat(src, span_warning("Запашок непередаваемый!"))
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
					vomit()
			else
				SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "smell")


	//Clear all moods if no miasma at all
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "smell")


	//BREATH TEMPERATURE
	handle_breath_temperature(breath)

	return 1

//Fourth and final link in a breath chain
/mob/living/carbon/proc/handle_breath_temperature(datum/gas_mixture/breath)
	// The air you breathe out should match your body temperature
	breath.set_temperature(bodytemperature)

/mob/living/carbon/proc/get_breath_from_internal(volume_needed)
	if(invalid_internals())
		// Unexpectely lost breathing apparatus and ability to breathe from the internal air tank.
		cutoff_internals()
		return
	if (external)
		. = external.remove_air_volume(volume_needed)
	else if (internal)
		. = internal.remove_air_volume(volume_needed)
	else
		// Return without taking a breath if there is no air tank.
		return
	// To differentiate between no internals and active, but empty internals.
	return . || FALSE

/mob/living/carbon/proc/handle_blood(delta_time, times_fired)
	return

/mob/living/carbon/proc/handle_hydration(delta_time, times_fired)
	return

/mob/living/carbon/human/handle_hydration(delta_time, times_fired)

	if(HAS_TRAIT(src, TRAIT_NOHYDRATION))
		hydration = HYDRATION_LEVEL_START_MIN
		return
	if(hydration < HYDRATION_LEVEL_MIN_CAP)
		hydration = HYDRATION_LEVEL_MIN_CAP
	hydration -= HYDRATION_LOSS_PER_LIFE

/mob/living/carbon/proc/handle_bodyparts(delta_time, times_fired)
	var/stam_regen = FALSE
	if(stam_regen_start_time <= world.time)
		stam_regen = TRUE
		if(HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA))
			. |= BODYPART_LIFE_UPDATE_HEALTH //make sure we remove the stamcrit
	for(var/I in bodyparts)
		var/obj/item/bodypart/BP = I
		if(BP.needs_processing)
			. |= BP.on_life(delta_time, times_fired, stam_regen)

/mob/living/carbon/proc/handle_organs(delta_time, times_fired)
	if(stat == DEAD)
		if(reagents.has_reagent(/datum/reagent/toxin/formaldehyde, 1) || reagents.has_reagent(/datum/reagent/cryostylane)) // No organ decay if the body contains formaldehyde.
			return
		for(var/obj/item/organ/organ as anything in internal_organs)
			organ.on_death(delta_time, times_fired) //Needed so organs decay while inside the body.
		return

	// NOTE: internal_organs_slot is sorted by GLOB.organ_process_order on insertion
	for(var/slot in internal_organs_slot)
		// We don't use get_organ_slot here because we know we have the organ we want, since we're iterating the list containing em already
		// This code is hot enough that it's just not worth the time
		var/obj/item/organ/organ = internal_organs_slot[slot]
		if(organ?.owner) // This exist mostly because reagent metabolization can cause organ reshuffling
			organ.on_life(delta_time, times_fired)

/mob/living/carbon/handle_diseases(delta_time, times_fired)
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(DT_PROB(D.infectivity, delta_time))
			D.spread()

		if(stat != DEAD || D.process_dead)
			D.stage_act(delta_time, times_fired)

/mob/living/carbon/handle_wounds(delta_time, times_fired)
	for(var/thing in all_wounds)
		var/datum/wound/W = thing
		if(W.processes) // meh
			W.handle_process(delta_time, times_fired)

//todo generalize this and move hud out
/mob/living/carbon/proc/handle_changeling(delta_time, times_fired)
	if(mind && hud_used?.lingchemdisplay)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			changeling.regenerate(delta_time, times_fired)
			hud_used.lingchemdisplay.invisibility = 0
			hud_used.lingchemdisplay.maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(changeling.chem_charges)]</font></div>")
		else
			hud_used.lingchemdisplay.invisibility = INVISIBILITY_ABSTRACT


/mob/living/carbon/handle_mutations_and_radiation(delta_time, times_fired)

	radiation = max(radiation - (RAD_LOSS_PER_SECOND * delta_time), 0)
	if(radiation > RAD_MOB_SAFE)
		adjustToxLoss(log(radiation-RAD_MOB_SAFE)*RAD_TOX_COEFFICIENT*delta_time)

	if(!dna?.temporary_mutations.len)
		return

	for(var/mut in dna.temporary_mutations)
		if(dna.temporary_mutations[mut] < world.time)
			if(mut == UI_CHANGED)
				if(dna.previous["UI"])
					dna.unique_identity = merge_text(dna.unique_identity,dna.previous["UI"])
					updateappearance(mutations_overlay_update=1)
					dna.previous.Remove("UI")
				dna.temporary_mutations.Remove(mut)
				continue
			if(mut == UE_CHANGED)
				if(dna.previous["name"])
					real_name = dna.previous["name"]
					name = real_name
					dna.previous.Remove("name")
				if(dna.previous["UE"])
					dna.unique_enzymes = dna.previous["UE"]
					dna.previous.Remove("UE")
				if(dna.previous["blood_type"])
					dna.blood_type = dna.previous["blood_type"]
					dna.previous.Remove("blood_type")
				dna.temporary_mutations.Remove(mut)
				continue
	for(var/datum/mutation/human/HM in dna.mutations)
		if(HM?.timeout)
			dna.remove_mutation(HM.type)

/*
Alcohol Poisoning Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - light brain damage, passing out
91-100: Dangerously toxic - swift death
*/
#define BALLMER_POINTS 500

//this updates all special effects: stun, sleeping, knockdown, druggy, stuttering, etc..
/mob/living/carbon/handle_status_effects(delta_time, times_fired)
	..()

	var/restingpwr = 0.5 + 2 * resting

	//Dizziness
	if(dizziness)
		if(client)
			var/pixel_x_diff = 0
			var/pixel_y_diff = 0

			var/amplitude = dizziness * (sin(dizziness * world.time) + 1)

			var/list/view_range_list = getviewsize(client.view)
			var/view_range = view_range_list[1]
			var/amp_x = clamp(amplitude * sin(dizziness * world.time), -view_range, view_range)
			var/amp_y = clamp(amplitude * cos(dizziness * world.time), -view_range, view_range)

			pixel_x_diff += amp_x
			pixel_y_diff += amp_y

			animate(src.client, pixel_x = amp_x, pixel_y = amp_y, time = 7, easing = EASE_OUT, flags = ANIMATION_RELATIVE)

			amp_x = clamp(amplitude * sin(dizziness * (world.time + 7)), -view_range, view_range)
			amp_y = clamp(amplitude * cos(dizziness * (world.time + 7)), -view_range, view_range)

			pixel_x_diff += amp_x
			pixel_y_diff += amp_y

			animate(pixel_x = amp_x, pixel_y = amp_y, time = 7, easing = EASE_OUT, flags = ANIMATION_RELATIVE)

			animate(pixel_x = -pixel_x_diff, pixel_y = -pixel_y_diff, time = 6, easing = EASE_OUT, flags = ANIMATION_RELATIVE)
		dizziness = max(dizziness - (restingpwr * delta_time), 0)

	if(drowsyness)
		adjust_drowsyness(-1 * restingpwr * delta_time)
		blur_eyes(1 * delta_time)
		if(DT_PROB(2.5, delta_time))
			AdjustSleeping(10 SECONDS)

	//Jitteriness
	if(jitteriness)
		do_jitter_animation(jitteriness)
		jitteriness = max(jitteriness - (restingpwr * delta_time), 0)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "jittery", /datum/mood_event/jittery)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "jittery")

	if(stuttering)
		stuttering = max(stuttering - (0.5 * delta_time), 0)

	if(slurring)
		slurring = max(slurring - (0.5 * delta_time),0)

	if(cultslurring)
		cultslurring = max(cultslurring - (0.5 * delta_time), 0)

	if(silent)
		silent = max(silent - (0.5 * delta_time), 0)

	if(druggy)
		adjust_drugginess(-0.5 * delta_time)

	if(hallucination)
		handle_hallucinations(delta_time, times_fired)

	if(drunkenness)
		drunkenness = max(drunkenness - ((0.005 + (drunkenness * 0.02)) * delta_time), 0)
		if(drunkenness >= 6)
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "drunk", /datum/mood_event/drunk)
			if(DT_PROB(16, delta_time))
				slurring += 2
			jitteriness = max(jitteriness - (1.5 * delta_time), 0)
			throw_alert("drunk", /atom/movable/screen/alert/drunk)
			sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC
		else
			SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "drunk")
			clear_alert("drunk")
			sound_environment_override = SOUND_ENVIRONMENT_NONE

		if(drunkenness >= 11 && slurring < 5)
			slurring += 0.6 * delta_time

		if(mind && (mind.assigned_role == JOB_SCIENTIST || mind.assigned_role == JOB_RESEARCH_DIRECTOR))
			if(SSresearch.science_tech)
				if(drunkenness >= 12.9 && drunkenness <= 13.8)
					drunkenness = round(drunkenness, 0.01)
					if(DT_PROB(2.5, delta_time))
						SSresearch.science_tech.add_point_list(list(TECHWEB_POINT_TYPE_DEFAULT = BALLMER_POINTS))
						say(pick_list_replacements(VISTA_FILE, "ballmer_good_msg"), forced = "ballmer")
				if(drunkenness > 26) // by this point you're into windows ME territory
					if(DT_PROB(2.5, delta_time))
						SSresearch.science_tech.remove_point_list(list(TECHWEB_POINT_TYPE_DEFAULT = BALLMER_POINTS))
						say(pick_list_replacements(VISTA_FILE, "ballmer_windows_me_msg"), forced = "ballmer")

		if(drunkenness >= 41)
			if(DT_PROB(16, delta_time))
				add_confusion(2)
			Dizzy(5 * delta_time)

		if(drunkenness >= 51)
			if(DT_PROB(1.5, delta_time))
				add_confusion(15)
				vomit() // vomiting clears toxloss, consider this a blessing
			Dizzy(12.5 * delta_time)

		if(drunkenness >= 61)
			if(DT_PROB(30, delta_time))
				blur_eyes(5)

		if(drunkenness >= 71)
			blur_eyes(2.5 * delta_time)

		if(drunkenness >= 81)
			adjustToxLoss(0.5 * delta_time)
			if(!stat && DT_PROB(2.5, delta_time))
				to_chat(src, span_warning("Надо полежать..."))

		if(drunkenness >= 91)
			adjustToxLoss(0.5 * delta_time)
			adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * delta_time)
			if(DT_PROB(10, delta_time) && !stat)
				if(SSshuttle.emergency.mode == SHUTTLE_DOCKED && is_station_level(z)) //QoL mainly
					to_chat(src, span_warning("Уф, надо бы поспать... но я не могу упустить этот шаттл..."))
				else
					to_chat(src, span_warning("Немного вздремнём..."))
					Sleeping(900)

		if(drunkenness >= 101)
			adjustToxLoss(1 * delta_time) //Let's be honest you shouldn't be alive by now

/// Base carbon environment handler, adds natural stabilization
/mob/living/carbon/handle_environment(datum/gas_mixture/environment, delta_time, times_fired)
	var/areatemp = get_temperature(environment)

	if(client)
		handle_temp_color(areatemp)

	if(stat != DEAD) // If you are dead your body does not stabilize naturally
		natural_bodytemperature_stabilization(environment, delta_time, times_fired)

	if(!on_fire || areatemp > bodytemperature) // If we are not on fire or the area is hotter
		adjust_bodytemperature((areatemp - bodytemperature), use_insulation=TRUE, use_steps=TRUE)

/**
 * Used to stabilize the body temperature back to normal on living mobs
 *
 * Arguments:
 * - [environemnt][/datum/gas_mixture]: The environment gas mix
 * - delta_time: The amount of time that has elapsed since the last tick
 * - times_fired: The number of times SSmobs has ticked
 */
/mob/living/carbon/proc/natural_bodytemperature_stabilization(datum/gas_mixture/environment, delta_time, times_fired)
	var/areatemp = get_temperature(environment)
	var/body_temperature_difference = get_body_temp_normal() - bodytemperature
	var/natural_change = 0

	// We are very cold, increase body temperature
	if(bodytemperature <= BODYTEMP_COLD_DAMAGE_LIMIT)
		natural_change = max((body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR), \
			BODYTEMP_AUTORECOVERY_MINIMUM)

	// we are cold, reduce the minimum increment and do not jump over the difference
	else if(bodytemperature > BODYTEMP_COLD_DAMAGE_LIMIT && bodytemperature < get_body_temp_normal())
		natural_change = max(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, \
			min(body_temperature_difference, BODYTEMP_AUTORECOVERY_MINIMUM / 4))

	// We are hot, reduce the minimum increment and do not jump below the difference
	else if(bodytemperature > get_body_temp_normal() && bodytemperature <= BODYTEMP_HEAT_DAMAGE_LIMIT)
		natural_change = min(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, \
			max(body_temperature_difference, -(BODYTEMP_AUTORECOVERY_MINIMUM / 4)))

	// We are very hot, reduce the body temperature
	else if(bodytemperature >= BODYTEMP_HEAT_DAMAGE_LIMIT)
		natural_change = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)

	var/thermal_protection = 1 - get_insulation_protection(areatemp) // invert the protection
	if(areatemp > bodytemperature) // It is hot here
		if(bodytemperature < get_body_temp_normal())
			// Our bodytemp is below normal we are cold, insulation helps us retain body heat
			// and will reduce the heat we lose to the environment
			natural_change = (thermal_protection + 1) * natural_change
		else
			// Our bodytemp is above normal and sweating, insulation hinders out ability to reduce heat
			// but will reduce the amount of heat we get from the environment
			natural_change = (1 / (thermal_protection + 1)) * natural_change
	else // It is cold here
		if(!on_fire) // If on fire ignore ignore local temperature in cold areas
			if(bodytemperature < get_body_temp_normal())
				// Our bodytemp is below normal, insulation helps us retain body heat
				// and will reduce the heat we lose to the environment
				natural_change = (thermal_protection + 1) * natural_change
			else
				// Our bodytemp is above normal and sweating, insulation hinders out ability to reduce heat
				// but will reduce the amount of heat we get from the environment
				natural_change = (1 / (thermal_protection + 1)) * natural_change

	// Apply the natural stabilization changes
	adjust_bodytemperature(natural_change * delta_time)

/**
 * Get the insulation that is appropriate to the temperature you're being exposed to.
 * All clothing, natural insulation, and traits are combined returning a single value.
 *
 * required temperature The Temperature that you're being exposed to
 *
 * return the percentage of protection as a value from 0 - 1
**/
/mob/living/carbon/proc/get_insulation_protection(temperature)
	return (temperature > bodytemperature) ? get_heat_protection(temperature) : get_cold_protection(temperature)

/// This returns the percentage of protection from heat as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/carbon/proc/get_heat_protection(temperature)
	return heat_protection

/// This returns the percentage of protection from cold as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/carbon/proc/get_cold_protection(temperature)
	return cold_protection

/**
 * Have two mobs share body heat between each other.
 * Account for the insulation and max temperature change range for the mob
 *
 * vars:
 * * M The mob/living/carbon that is sharing body heat
 */
/mob/living/carbon/proc/share_bodytemperature(mob/living/carbon/M)
	var/temp_diff = bodytemperature - M.bodytemperature
	if(temp_diff > 0) // you are warm share the heat of life
		M.adjust_bodytemperature((temp_diff * 0.5), use_insulation=TRUE, use_steps=TRUE) // warm up the giver
		adjust_bodytemperature((temp_diff * -0.5), use_insulation=TRUE, use_steps=TRUE) // cool down the reciver

	else // they are warmer leech from them
		adjust_bodytemperature((temp_diff * -0.5) , use_insulation=TRUE, use_steps=TRUE) // warm up the reciver
		M.adjust_bodytemperature((temp_diff * 0.5), use_insulation=TRUE, use_steps=TRUE) // cool down the giver

/**
 * Adjust the body temperature of a mob
 * expanded for carbon mobs allowing the use of insulation and change steps
 *
 * vars:
 * * amount The amount of degrees to change body temperature by
 * * min_temp (optional) The minimum body temperature after adjustment
 * * max_temp (optional) The maximum body temperature after adjustment
 * * use_insulation (optional) modifies the amount based on the amount of insulation the mob has
 * * use_steps (optional) Use the body temp divisors and max change rates
 * * capped (optional) default True used to cap step mode
 */
/mob/living/carbon/adjust_bodytemperature(amount, min_temp=0, max_temp=INFINITY, use_insulation=FALSE, use_steps=FALSE, capped=TRUE)
	// apply insulation to the amount of change
	if(use_insulation)
		amount *= (1 - get_insulation_protection(bodytemperature + amount))

	// Use the bodytemp divisors to get the change step, with max step size
	if(use_steps)
		amount = (amount > 0) ? (amount / BODYTEMP_HEAT_DIVISOR) : (amount / BODYTEMP_COLD_DIVISOR)
		// Clamp the results to the min and max step size
		if(capped)
			amount = (amount > 0) ? min(amount, BODYTEMP_HEATING_MAX) : max(amount, BODYTEMP_COOLING_MAX)

	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = clamp(bodytemperature + amount, min_temp, max_temp)


///////////
//Stomach//
///////////

/mob/living/carbon/get_fullness()
	var/fullness = nutrition

	var/obj/item/organ/stomach/belly = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!belly) //nothing to see here if we do not have a stomach
		return fullness

	for(var/bile in belly.reagents.reagent_list)
		var/datum/reagent/bits = bile
		if(istype(bits, /datum/reagent/consumable))
			var/datum/reagent/consumable/goodbit = bile
			fullness += goodbit.nutriment_factor * goodbit.volume / goodbit.metabolization_rate
			continue
		fullness += 0.6 * bits.volume / bits.metabolization_rate //not food takes up space

	return fullness

/mob/living/carbon/has_reagent(reagent, amount = -1, needs_metabolizing = FALSE)
	. = ..()
	if(.)
		return
	var/obj/item/organ/stomach/belly = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!belly)
		return FALSE
	return belly.reagents.has_reagent(reagent, amount, needs_metabolizing)

/////////
//LIVER//
/////////

///Check to see if we have the liver, if not automatically gives you last-stage effects of lacking a liver.

/mob/living/carbon/proc/handle_liver(delta_time, times_fired)
	if(!dna)
		return

	var/obj/item/organ/liver/liver = get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		return

	reagents.end_metabolization(src, keep_liverless = TRUE) //Stops trait-based effects on reagents, to prevent permanent buffs
	reagents.metabolize(src, delta_time, times_fired, can_overdose=FALSE, liverless = TRUE)

	if(HAS_TRAIT(src, TRAIT_STABLELIVER) || HAS_TRAIT(src, TRAIT_NOMETABOLISM))
		return

	adjustToxLoss(0.6 * delta_time, TRUE,  TRUE)
	adjustOrganLoss(pick(ORGAN_SLOT_HEART, ORGAN_SLOT_LUNGS, ORGAN_SLOT_STOMACH, ORGAN_SLOT_EYES, ORGAN_SLOT_EARS), 0.5* delta_time)

/mob/living/carbon/proc/undergoing_liver_failure()
	var/obj/item/organ/liver/liver = get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver?.organ_flags & ORGAN_FAILING)
		return TRUE

/////////////
//CREMATION//
/////////////
/mob/living/carbon/proc/check_cremation(delta_time, times_fired)
	//Only cremate while actively on fire
	if(!on_fire)
		return

	//Only starts when the chest has taken full damage
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!(chest.get_damage() >= chest.max_damage))
		return

	//Burn off limbs one by one
	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/still_has_limbs = FALSE
	for(var/zone in limb_list)
		limb = get_bodypart(zone)
		if(limb)
			still_has_limbs = TRUE
			if(limb.get_damage() >= limb.max_damage)
				limb.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
				if(limb.cremation_progress >= 100)
					if(limb.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
						limb.drop_limb()
						limb.visible_message(span_warning("[capitalize(limb.name)] <b>[src]</b> обращается в пепел!"))
						qdel(limb)
					else
						limb.drop_limb()
						limb.visible_message(span_warning("[capitalize(limb.name)] <b>[src]</b> отлетает от тела!"))
	if(still_has_limbs)
		return

	//Burn the head last
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		if(head.get_damage() >= head.max_damage)
			head.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
			if(head.cremation_progress >= 100)
				if(head.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
					head.drop_limb()
					head.visible_message(span_warning("Голова <b>[src]</b> обращается в пепел!"))
					qdel(head)
				else
					head.drop_limb()
					head.visible_message(span_warning("Голова <b>[src]</b> отлетает от тела!"))
		return

	//Nothing left: dust the body, drop the items (if they're flammable they'll burn on their own)
	chest.cremation_progress += rand(1 * delta_time, 2.5 * delta_time)
	if(chest.cremation_progress >= 100)
		visible_message(span_warning("<b>[capitalize(src)]</b> обращается в пепел!"))
		dust(TRUE, TRUE)

////////////////
//BRAIN DAMAGE//
////////////////

/mob/living/carbon/proc/handle_brain_damage(delta_time, times_fired)
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life(delta_time, times_fired)

/////////////////////////////////////
//MONKEYS WITH TOO MUCH CHOLOESTROL//
/////////////////////////////////////

/mob/living/carbon/proc/can_heartattack()
	if(!needs_heart())
		return FALSE
	var/obj/item/organ/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart || (heart.organ_flags & ORGAN_SYNTHETIC))
		return FALSE
	return TRUE

/mob/living/carbon/proc/needs_heart()
	if(HAS_TRAIT(src, TRAIT_STABLEHEART))
		return FALSE
	if(dna && dna.species && (NOBLOOD in dna.species.species_traits)) //not all carbons have species!
		return FALSE
	return TRUE

/*
 * The mob is having a heart attack
 *
 * NOTE: this is true if the mob has no heart and needs one, which can be suprising,
 * you are meant to use it in combination with can_heartattack for heart attack
 * related situations (i.e not just cardiac arrest)
 */
/mob/living/carbon/proc/undergoing_cardiac_arrest()
	var/obj/item/organ/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	if(istype(heart) && heart.beating)
		return FALSE
	else if(!needs_heart())
		return FALSE
	return TRUE

/mob/living/carbon/proc/set_heartattack(status)
	if(!can_heartattack())
		return FALSE

	var/obj/item/organ/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	if(!istype(heart))
		return

	heart.beating = !status
