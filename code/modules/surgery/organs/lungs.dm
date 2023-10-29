/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "лёгкие"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY * 0.9 // fails around 16.5 minutes, lungs are one of the last organs to die (of the ones we have)

	low_threshold_passed = span_warning("Трудно дышать...")
	high_threshold_passed = span_warning("Ощущаю какое-то сжатие вокруг груди, моё дыхание становится поверхностным и быстрым.")
	now_fixed = span_warning("Моим лёгким, похоже, стало легче.")
	low_threshold_cleared = span_info("Воздух начинает поступать в мои лёгкие. Благодать.")
	high_threshold_cleared = span_info("Давление вокруг моей груди ослабевает, дышать стало легче.")


	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/salbutamol = 5)

	//Breath damage

	var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
	var/safe_oxygen_max = 0
	var/safe_nitro_min = 0
	var/safe_nitro_max = 0
	var/safe_co2_min = 0
	var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
	var/safe_toxins_min = 0
	///How much breath partial pressure is a safe amount of toxins. 0 means that we are immune to toxins.
	var/safe_toxins_max = 0.05
	var/SA_para_min = 1 //Sleeping agent
	var/SA_sleep_min = 5 //Sleeping agent
	var/BZ_trip_balls_min = 1 //BZ gas
	var/gas_stimulation_min = 0.002 //nitrium, Stimulum and Freon
	///Minimum amount of healium to make you unconscious for 4 seconds
	var/healium_para_min = 3
	///Minimum amount of healium to knock you down for good
	var/healium_sleep_min = 6
	///Minimum amount of hexane needed to start having effect
	var/hexane_min = 2

	var/oxy_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/oxy_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/oxy_damage_type = OXY
	var/nitro_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/nitro_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/nitro_damage_type = OXY
	var/co2_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/co2_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/co2_damage_type = OXY
	var/tox_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/tox_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/tox_damage_type = TOX

	var/cold_message = "как моё лицо мёрзнет и ледяной воздух поступает"
	var/cold_level_1_threshold = 260
	var/cold_level_2_threshold = 200
	var/cold_level_3_threshold = 120
	var/cold_level_1_damage = COLD_GAS_DAMAGE_LEVEL_1 //Keep in mind with gas damage levels, you can set these to be negative, if you want someone to heal, instead.
	var/cold_level_2_damage = COLD_GAS_DAMAGE_LEVEL_2
	var/cold_level_3_damage = COLD_GAS_DAMAGE_LEVEL_3
	var/cold_damage_type = BURN

	var/hot_message = "как моё лицо горит и горячий воздух поступает"
	var/heat_level_1_threshold = 360
	var/heat_level_2_threshold = 400
	var/heat_level_3_threshold = 1000
	var/heat_level_1_damage = HEAT_GAS_DAMAGE_LEVEL_1
	var/heat_level_2_damage = HEAT_GAS_DAMAGE_LEVEL_2
	var/heat_level_3_damage = HEAT_GAS_DAMAGE_LEVEL_3
	var/heat_damage_type = BURN

	var/crit_stabilizing_reagent = /datum/reagent/medicine/epinephrine

/obj/item/organ/lungs/proc/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
	if(H.status_flags & GODMODE)
		H.failed_last_breath = FALSE //clear oxy issues
		H.clear_alert("not_enough_oxy")
		return
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return

	if(!breath || (breath.total_moles() == 0))
		if(H.reagents.has_reagent(crit_stabilizing_reagent, needs_metabolizing = TRUE))
			return
		if(H.health >= H.crit_threshold)
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else if(!HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
			H.adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		H.failed_last_breath = TRUE
		if(safe_oxygen_min)
			H.throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)
		else if(safe_toxins_min)
			H.throw_alert("not_enough_tox", /atom/movable/screen/alert/not_enough_tox)
		else if(safe_co2_min)
			H.throw_alert("not_enough_co2", /atom/movable/screen/alert/not_enough_co2)
		else if(safe_nitro_min)
			H.throw_alert("not_enough_nitro", /atom/movable/screen/alert/not_enough_nitro)
		return FALSE

	if(H.wear_mask && isclothing(H.wear_mask) && H.wear_mask.clothing_flags & GAS_FILTERING && H.wear_mask.has_filter == TRUE)
		breath = H.wear_mask.consume_filter(breath)

	var/gas_breathed = 0

	var/O2_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_O2))+(8*breath.get_breath_partial_pressure(breath.get_moles(GAS_PLUOXIUM)))
	var/N2_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_N2))
	var/Toxins_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_PLASMA))
	var/CO2_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_CO2))


	//-- OXY --//

	//Too much oxygen! //Yes, some species may not like it.
	if(safe_oxygen_max)
		if(O2_pp > safe_oxygen_max)
			var/ratio = (breath.get_moles(GAS_O2)/safe_oxygen_max) * 10
			H.apply_damage_type(clamp(ratio, oxy_breath_dam_min, oxy_breath_dam_max), oxy_damage_type)
			H.throw_alert("too_much_oxy", /atom/movable/screen/alert/too_much_oxy)
		else
			H.clear_alert("too_much_oxy")

	//Too little oxygen!
	if(safe_oxygen_min)
		if(O2_pp < safe_oxygen_min)
			gas_breathed = handle_too_little_breath(H, O2_pp, safe_oxygen_min, breath.get_moles(GAS_O2))
			H.throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-5)
			gas_breathed = breath.get_moles(GAS_O2)
			H.clear_alert("not_enough_oxy")

	//Exhale
	breath.adjust_moles(GAS_O2, -gas_breathed)
	breath.adjust_moles(GAS_CO2, gas_breathed)
	gas_breathed = 0

	//-- Nitrogen --//

	//Too much nitrogen!
	if(safe_nitro_max)
		if(N2_pp > safe_nitro_max)
			var/ratio = (breath.get_moles(GAS_N2)/safe_nitro_max) * 10
			H.apply_damage_type(clamp(ratio, nitro_breath_dam_min, nitro_breath_dam_max), nitro_damage_type)
			H.throw_alert("too_much_nitro", /atom/movable/screen/alert/too_much_nitro)
		else
			H.clear_alert("too_much_nitro")

	//Too little nitrogen!
	if(safe_nitro_min)
		if(N2_pp < safe_nitro_min)
			gas_breathed = handle_too_little_breath(H, N2_pp, safe_nitro_min, breath.get_moles(GAS_N2))
			H.throw_alert("nitro", /atom/movable/screen/alert/not_enough_nitro)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-5)
			gas_breathed = breath.get_moles(GAS_N2)
			H.clear_alert("nitro")

	//Exhale
	breath.adjust_moles(GAS_N2, -gas_breathed)
	breath.adjust_moles(GAS_CO2, gas_breathed)
	gas_breathed = 0

	//-- CO2 --//

	//CO2 does not affect failed_last_breath. So if there was enough oxygen in the air but too much co2, this will hurt you, but only once per 4 ticks, instead of once per tick.
	if(safe_co2_max)
		if(CO2_pp > safe_co2_max)
			if(!H.co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
				H.co2overloadtime = world.time
			else if(world.time - H.co2overloadtime > 120)
				H.Unconscious(60)
				H.apply_damage_type(3, co2_damage_type) // Lets hurt em a little, let them know we mean business
				if(world.time - H.co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
					H.apply_damage_type(8, co2_damage_type)
				H.throw_alert("too_much_co2", /atom/movable/screen/alert/too_much_co2)
			if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
				H.emote("cough")

		else
			H.co2overloadtime = 0
			H.clear_alert("too_much_co2")

	//Too little CO2!
	if(safe_co2_min)
		if(CO2_pp < safe_co2_min)
			gas_breathed = handle_too_little_breath(H, CO2_pp, safe_co2_min, breath.get_moles(GAS_CO2))
			H.throw_alert("not_enough_co2", /atom/movable/screen/alert/not_enough_co2)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-5)
			gas_breathed = breath.get_moles(GAS_CO2)
			H.clear_alert("not_enough_co2")

	//Exhale
	breath.adjust_moles(GAS_CO2, -gas_breathed)
	breath.adjust_moles(GAS_O2, gas_breathed)
	gas_breathed = 0


	//-- TOX --//

	//Too much toxins!
	if(safe_toxins_max)
		if(Toxins_pp > safe_toxins_max)
			var/ratio = (breath.get_moles(GAS_PLASMA)/safe_toxins_max) * 10
			H.apply_damage_type(clamp(ratio, tox_breath_dam_min, tox_breath_dam_max), tox_damage_type)
			H.throw_alert("too_much_tox", /atom/movable/screen/alert/too_much_tox)
		else
			H.clear_alert("too_much_tox")


	//Too little toxins!
	if(safe_toxins_min)
		if(Toxins_pp < safe_toxins_min)
			gas_breathed = handle_too_little_breath(H, Toxins_pp, safe_toxins_min, breath.get_moles(GAS_PLASMA))
			H.throw_alert("not_enough_tox", /atom/movable/screen/alert/not_enough_tox)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-5)
			gas_breathed = breath.get_moles(GAS_PLASMA)
			H.clear_alert("not_enough_tox")

	//Exhale
	breath.adjust_moles(GAS_PLASMA, -gas_breathed)
	breath.adjust_moles(GAS_CO2, gas_breathed)
	gas_breathed = 0


	//-- TRACES --//

	if(breath)	// If there's some other shit in the air lets deal with it here.

	// N2O

		var/SA_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_N2O))
		if(SA_pp > SA_para_min) // Enough to make us stunned for a bit
			H.Unconscious(60) // 60 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				H.Sleeping(min(H.AmountSleeping() + 100, 200))
		else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				H.emote(pick("giggle", "laugh"))
				SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")
		if(safe_toxins_max && SA_pp > safe_toxins_max*3)
			var/ratio = (breath.get_moles(GAS_N2O)/safe_toxins_max)
			H.apply_damage_type(clamp(ratio, tox_breath_dam_min, tox_breath_dam_max), tox_damage_type)
			H.throw_alert("too_much_n2o", /atom/movable/screen/alert/too_much_n2o)
		else
			H.clear_alert("too_much_n2o")


	// BZ

		var/bz_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_BZ))
		if(bz_pp > BZ_trip_balls_min)
			H.hallucination += 10
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,5)
			if(prob(33))
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)

		else if(bz_pp > 0.01)
			H.hallucination += 5
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,1)


	// Tritium
		var/trit_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_TRITIUM))
		if (trit_pp > 50)
			H.radiation += trit_pp/2 //If you're breathing in half an atmosphere of radioactive gas, you fucked up.
		else
			H.radiation += trit_pp/10

	// nitrium
		var/nitrium_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_NITRIUM))
		if (prob(nitrium_pp))
			H.emote("burp")
		if (prob(nitrium_pp) && nitrium_pp>10)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, nitrium_pp/2)
			to_chat(H, span_notice("Мои лёгкие горят!"))
		gas_breathed = breath.get_moles(GAS_NITRIUM)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/nitrium,1)

		breath.adjust_moles(GAS_NITRIUM, -gas_breathed)

	// Freon
		var/freon_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_FREON))
		if (prob(freon_pp))
			to_chat(H, span_alert("Мои лёгкие горят!"))
		if (freon_pp >40)
			H.emote("gasp")
			H.adjustFireLoss(15)
			if (prob(freon_pp/2))
				to_chat(H, span_alert("Моя глотка смыкается!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustFireLoss(freon_pp/4)
		gas_breathed = breath.get_moles(GAS_FREON)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/freon,1)

		breath.adjust_moles(GAS_FREON, -gas_breathed)

	// Healium
		var/healium_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_HEALIUM))
		if(healium_pp > gas_stimulation_min)
			if(prob(15))
				to_chat(H, span_alert("Голова кружится и лёгкие горят!"))
				SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
				H.emote("gasp")
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")
		if(healium_pp > healium_para_min)
			H.Unconscious(rand(30, 50))//not in seconds to have a much higher variation
			if(healium_pp > healium_sleep_min)
				var/existing = H.reagents.get_reagent_amount(/datum/reagent/healium)
				H.reagents.add_reagent(/datum/reagent/healium,max(0, 1 - existing))
		gas_breathed = breath.get_moles(GAS_HEALIUM)
		breath.get_moles(GAS_HEALIUM, -gas_breathed)

	// Proto Nitrate
		// Inert
	// Zauker
		var/zauker_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_ZAUKER))
		if(zauker_pp > gas_stimulation_min)
			H.adjustBruteLoss(25)
			H.adjustOxyLoss(5)
			H.adjustFireLoss(8)
			H.adjustToxLoss(8)
		gas_breathed = breath.get_moles(GAS_ZAUKER)
		breath.get_moles(GAS_ZAUKER, -gas_breathed)

	// Halon
		var/halon_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_HALON))
		if(halon_pp > gas_stimulation_min)
			H.adjustOxyLoss(5)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/halon)
			H.reagents.add_reagent(/datum/reagent/halon,max(0, 1 - existing))
		gas_breathed = breath.get_moles(GAS_HALON)
		breath.get_moles(GAS_HALON, -gas_breathed)

	// Hyper-Nob
		gas_breathed = breath.get_moles(GAS_HYPER_NOBLIUM)
		if (gas_breathed > gas_stimulation_min)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/hypernoblium)
			H.reagents.add_reagent(/datum/reagent/hypernoblium,max(0, 1 - existing))
		breath.adjust_moles(GAS_HYPER_NOBLIUM, -gas_breathed)

	// Miasma
		if (breath.get_moles(GAS_MIASMA))
			var/miasma_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_MIASMA))

			//Miasma sickness
			if(prob(0.5 * miasma_pp))
				var/datum/disease/advance/miasma_disease = new /datum/disease/advance/random(min(round(max(miasma_pp/2, 1), 1), 6), min(round(max(miasma_pp, 1), 1), 8))
				//tl;dr the first argument chooses the smaller of miasma_pp/2 or 6(typical max virus symptoms), the second chooses the smaller of miasma_pp or 8(max virus symptom level) //
				miasma_disease.name = "Неизвестный"//^each argument has a minimum of 1 and rounds to the nearest value. Feel free to change the pp scaling I couldn't decide on good numbers for it.
				miasma_disease.try_infect(owner)

			// Miasma side effects
			switch(miasma_pp)
				if(0.25 to 5)
					// At lower pp, give out a little warning
					SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")
					if(prob(5))
						to_chat(owner, span_notice("Тошнотворный запах."))
				if(5 to 15)
					//At somewhat higher pp, warning becomes more obvious
					if(prob(15))
						to_chat(owner, span_warning("Здесь кто-то умер? Воняет ужасно..."))
						SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/bad_smell)
				if(15 to 30)
					//Small chance to vomit. By now, people have internals on anyway
					if(prob(5))
						to_chat(owner, span_warning("Вонь гниющих туш невыносима! Тошнит..."))
						SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
						owner.vomit()
				if(30 to INFINITY)
					//Higher chance to vomit. Let the horror start
					if(prob(15))
						to_chat(owner, span_warning("Вонь гниющих туш невыносима! Сейчас блевану..."))
						SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
						owner.vomit()
				else
					SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

			// In a full miasma atmosphere with 101.34 pKa, about 10 disgust per breath, is pretty low compared to threshholds
			// Then again, this is a purely hypothetical scenario and hardly reachable
			owner.adjust_disgust(0.1 * miasma_pp)

			breath.adjust_moles(GAS_MIASMA, -gas_breathed)

		// Clear out moods when no miasma at all
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

		handle_breath_temperature(breath, H)
	return TRUE

/obj/item/organ/lungs/proc/handle_too_little_breath(mob/living/carbon/human/H = null, breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!H || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return FALSE

	if(prob(20))
		H.emote("gasp")
	if(breath_pp > 0)
		var/ratio = safe_breath_min/breath_pp
		H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!
		H.failed_last_breath = TRUE
		. = true_pp*ratio/6
	else
		H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		H.failed_last_breath = TRUE


/obj/item/organ/lungs/proc/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/H) // called by human/life, handles temperatures
	var/breath_temperature = breath.return_temperature()

	if(!HAS_TRAIT(H, TRAIT_RESISTCOLD)) // COLD DAMAGE
		var/cold_modifier = H.dna.species.coldmod
		if(breath_temperature < cold_level_3_threshold)
			H.apply_damage_type(cold_level_3_damage*cold_modifier, cold_damage_type)
		if(breath_temperature > cold_level_3_threshold && breath_temperature < cold_level_2_threshold)
			H.apply_damage_type(cold_level_2_damage*cold_modifier, cold_damage_type)
		if(breath_temperature > cold_level_2_threshold && breath_temperature < cold_level_1_threshold)
			H.apply_damage_type(cold_level_1_damage*cold_modifier, cold_damage_type)
		if(breath_temperature < cold_level_1_threshold)
			if(prob(20))
				to_chat(H, span_warning("Ощущаю [cold_message] в мои лёгкие!"))

	if(!HAS_TRAIT(H, TRAIT_RESISTHEAT)) // HEAT DAMAGE
		var/heat_modifier = H.dna.species.heatmod
		if(breath_temperature > heat_level_1_threshold && breath_temperature < heat_level_2_threshold)
			H.apply_damage_type(heat_level_1_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_2_threshold && breath_temperature < heat_level_3_threshold)
			H.apply_damage_type(heat_level_2_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_3_threshold)
			H.apply_damage_type(heat_level_3_damage*heat_modifier, heat_damage_type)
		if(breath_temperature > heat_level_1_threshold)
			if(prob(20))
				to_chat(H, span_warning("Ощущаю [hot_message] в мои лёгкие!"))

	// The air you breathe out should match your body temperature
	breath.set_temperature(H.bodytemperature)

/obj/item/organ/lungs/on_life(delta_time, times_fired)
	. = ..()
	if(failed && !(organ_flags & ORGAN_FAILING))
		failed = FALSE
		return
	if(damage >= low_threshold)
		var/do_i_cough = DT_PROB((damage < high_threshold) ? 2.5 : 5, delta_time) // between : past high
		if(do_i_cough)
			owner.emote("cough")
	if(organ_flags & ORGAN_FAILING && owner.stat == CONSCIOUS)
		owner.visible_message(span_danger("[owner] grabs [owner.ru_ego()] throat, struggling for breath!") , span_userdanger("You suddenly feel like you can't breathe!"))
		failed = TRUE

/obj/item/organ/lungs/get_availability(datum/species/S)
	return !(TRAIT_NOBREATH in S.inherent_traits)

/obj/item/organ/lungs/plasmaman
	name = "плазма-фильтр"
	desc = "Губчатая масса в форме ребра для фильтрации плазмы из дыхания."
	icon_state = "lungs-plasma"
	safe_oxygen_min = 0 //We don't breath this
	safe_toxins_min = 16 //We breath THIS!
	safe_toxins_max = 0

/obj/item/organ/lungs/slime
	name = "вакуоль"
	desc = "Большая органелла, предназначенная для хранения кислорода и других важных газов."

	safe_toxins_max = 0 //We breathe this to gain POWER.

/obj/item/organ/lungs/slime/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
	. = ..()
	if (breath)
		var/plasma_pp = breath.get_breath_partial_pressure(breath.get_moles(GAS_PLASMA))
		owner.blood_volume += (0.2 * plasma_pp) // 10/s when breathing literally nothing but plasma, which will suffocate you.

/obj/item/organ/lungs/cybernetic
	name = "базовые кибернетические лёгкие"
	desc = "Базовая кибернетическая версия легких, встречающаяся у традиционных гуманоидных существ."
	icon_state = "lungs-c"
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5

	var/emp_vulnerability = 80	//Chance of permanent effects if emp-ed.

/obj/item/organ/lungs/cybernetic/tier2
	name = "кибернетические лёгкие"
	desc = "Кибернетическая версия легких традиционных гуманоидных существ. Позволяет потреблять больше кислорода, чем органические легкие, требуя немного меньшего давления."
	icon_state = "lungs-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	safe_oxygen_min = 13
	safe_oxygen_max = 100

/obj/item/organ/lungs/cybernetic/tier3
	name = "продвинутые кибернетические лёгкие"
	desc = "Более продвинутая версия штатных кибернетических легких. Отличается способностью отфильтровывать более низкие уровни токсинов и углекислого газа."
	icon_state = "lungs-c-u2"
	safe_toxins_max = 20
	safe_co2_max = 20
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	safe_oxygen_min = 13
	emp_vulnerability = 20

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100

/obj/item/organ/lungs/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.losebreath += 20
		COOLDOWN_START(src, severe_cooldown, 30 SECONDS)
	if(prob(emp_vulnerability/severity))	//Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.
