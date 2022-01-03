

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_CHEST		0.15
#define THERMAL_PROTECTION_GROIN		0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025

/mob/living/carbon/human/Life(delta_time = SSMOBS_DT, times_fired)
	if(notransform)
		return

	. = ..()
	if(QDELETED(src))
		return FALSE

	//Body temperature stability and damage
	dna.species.handle_body_temperature(src, delta_time, times_fired)

	if(!IS_IN_STASIS(src))
		if(.) //not dead

			for(var/datum/mutation/human/HM in dna.mutations) // Handle active genes
				HM.on_life(delta_time, times_fired)

		if(stat != DEAD)
			//heart attack stuff
			handle_heart(delta_time, times_fired)
			handle_liver(delta_time, times_fired)

		dna.species.spec_life(src, delta_time, times_fired) // for mutantraces
	else
		for(var/i in all_wounds)
			var/datum/wound/iter_wound = i
			iter_wound.on_stasis(delta_time, times_fired)

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(stat != DEAD)
		if(prob(2))
			if(nutrition < NUTRITION_LEVEL_STARVING)
				to_chat(src, span_warning("[pick("Голодно...", "Кушать хочу...", "Вот бы что-нибудь съесть...", "Мой живот урчит...")]"))
				take_overall_damage(stamina = 60)
			var/obj/item/organ/O = internal_organs_slot[ORGAN_SLOT_KIDNEYS]
			if(O?.reagents.total_volume)
				var/urine_amount = O.reagents.get_reagent_amount(/datum/reagent/toxin/urine)
				switch(urine_amount)
					if(260 to 269)
						to_chat(src, span_warning("[pick("Где тут уборная?", "Хочу в туалет.", "Надо в туалет.")]"))
					if(270 to 289)
						to_chat(src, span_warning("[pick("СРОЧНО В ТУАЛЕТ!", "Я СЕЙЧАС ОПИСАЮСЬ!", "ХОЧУ В ТУАЛЕТ!")]"))
					if(290 to INFINITY)
						try_pee()
			var/obj/item/organ/G = internal_organs_slot[ORGAN_SLOT_GUTS]
			if(G?.reagents.total_volume)
				var/poo_amount = G.reagents.get_reagent_amount(/datum/reagent/toxin/poo)
				switch(poo_amount)
					if(260 to 269)
						to_chat(src, span_warning("[pick("Где тут уборная?", "Хочу в туалет.", "Надо в туалет.")]"))
					if(270 to 289)
						to_chat(src, span_warning("[pick("СРОЧНО В ТУАЛЕТ!", "ЖОПНЫЙ КЛАПАН НА ПРЕДЕЛЕ!", "ХОЧУ В ТУАЛЕТ!")]"))
					if(290 to INFINITY)
						try_poo()
		return TRUE


/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	var/chest_covered = FALSE
	var/head_covered = FALSE
	for(var/obj/item/clothing/equipped in get_equipped_items())
		if((equipped.body_parts_covered & CHEST) && (equipped.clothing_flags & STOPSPRESSUREDAMAGE))
			chest_covered = TRUE
		if((equipped.body_parts_covered & HEAD) && (equipped.clothing_flags & STOPSPRESSUREDAMAGE))
			head_covered = TRUE

	if(chest_covered && head_covered)
		return ONE_ATMOSPHERE
	if(ismovable(loc))
		/// If we're in a space with 0.5 content pressure protection, it averages the values, for example.
		var/atom/movable/occupied_space = loc
		return (occupied_space.contents_pressure_protection * ONE_ATMOSPHERE + (1 - occupied_space.contents_pressure_protection) * pressure)
	return pressure


/mob/living/carbon/human/handle_traits(delta_time, times_fired)
	if (getOrganLoss(ORGAN_SLOT_BRAIN) >= 60)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "brain_damage", /datum/mood_event/brain_damage)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "brain_damage")
	return ..()

/mob/living/carbon/human/handle_mutations_and_radiation(delta_time, times_fired)
	if(!dna || !dna.species.handle_mutations_and_radiation(src, delta_time, times_fired))
		..()

/mob/living/carbon/human/breathe()
	if(!dna.species.breathe(src))
		..()

/mob/living/carbon/human/check_breath(datum/gas_mixture/breath)

	var/L = getorganslot(ORGAN_SLOT_LUNGS)

	if(!L)
		if(health >= crit_threshold)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS + 1)
		else if(!HAS_TRAIT(src, TRAIT_NOCRITDAMAGE))
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		failed_last_breath = TRUE

		var/datum/species/S = dna.species

		if(S.breathid == "o2")
			throw_alert("not_enough_oxy", /atom/movable/screen/alert/not_enough_oxy)
		else if(S.breathid == "tox")
			throw_alert("not_enough_tox", /atom/movable/screen/alert/not_enough_tox)
		else if(S.breathid == "co2")
			throw_alert("not_enough_co2", /atom/movable/screen/alert/not_enough_co2)
		else if(S.breathid == "n2")
			throw_alert("not_enough_nitro", /atom/movable/screen/alert/not_enough_nitro)

		return FALSE
	else
		if(istype(L, /obj/item/organ/lungs))
			var/obj/item/organ/lungs/lun = L
			lun.check_breath(breath,src)

/// Environment handlers for species
/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment, delta_time, times_fired)
	// If we are in a cryo bed do not process life functions
	if(istype(loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	dna.species.handle_environment(src, environment, delta_time, times_fired)

/**
 * Adjust the core temperature of a mob
 *
 * vars:
 * * amount The amount of degrees to change body temperature by
 * * min_temp (optional) The minimum body temperature after adjustment
 * * max_temp (optional) The maximum body temperature after adjustment
 */
/mob/living/carbon/human/proc/adjust_coretemperature(amount, min_temp=0, max_temp=INFINITY)
	coretemperature = clamp(coretemperature + amount, min_temp, max_temp)

/**
 * get_body_temperature Returns the body temperature with any modifications applied
 *
 * This applies the result from proc/get_body_temp_normal_change() against the bodytemp_normal
 * for the species and returns the result
 *
 * arguments:
 * * apply_change (optional) Default True This applies the changes to body temperature normal
 */
/mob/living/carbon/human/get_body_temp_normal(apply_change=TRUE)
	if(!apply_change)
		return dna.species.bodytemp_normal
	return dna.species.bodytemp_normal + get_body_temp_normal_change()

///FIRE CODE
/mob/living/carbon/human/handle_fire(delta_time, times_fired)
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return

	if(dna)
		. = dna.species.handle_fire(src, delta_time, times_fired) //do special handling based on the mob's species. TRUE = they are immune to the effects of the fire.

	if(!last_fire_update)
		last_fire_update = fire_stacks
	if((fire_stacks > HUMAN_FIRE_STACK_ICON_NUM && last_fire_update <= HUMAN_FIRE_STACK_ICON_NUM) || (fire_stacks <= HUMAN_FIRE_STACK_ICON_NUM && last_fire_update > HUMAN_FIRE_STACK_ICON_NUM))
		last_fire_update = fire_stacks
		update_fire()


/mob/living/carbon/human/proc/get_thermal_protection()
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
			thermal_protection += (wear_suit.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	return thermal_protection

/mob/living/carbon/human/IgniteMob()
	//If have no DNA or can be Ignited, call parent handling to light user
	//If firestacks are high enough
	if(!dna || dna.species.CanIgniteMob(src))
		return ..()
	. = FALSE //No ignition

/mob/living/carbon/human/extinguish_mob()
	if(!dna || !dna.species.extinguish_mob(src))
		last_fire_update = null
		..()
//END FIRE CODE


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/get_heat_protection(temperature)
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	var/thermal_protection = heat_protection

	// Apply clothing items protection
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1, thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/get_cold_protection(temperature)
	// There is an occasional bug where the temperature is miscalculated in areas with small amounts of gas.
	// This is necessary to ensure that does not affect this calculation.
	// Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	temperature = max(temperature, 2.7)
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	var/thermal_protection = cold_protection

	// Apply clothing items protection
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1, thermal_protection)

/mob/living/carbon/human/handle_random_events(delta_time, times_fired)
	//Puke if toxloss is too high
	if(stat)
		return
	if(getToxLoss() < 45 || nutrition <= 20)
		return

	lastpuke += DT_PROB(30, delta_time)
	if(lastpuke >= 50) // about 25 second delay I guess // This is actually closer to 150 seconds
		vomit(20)
		lastpuke = 0


/mob/living/carbon/human/has_smoke_protection()
	if(isclothing(wear_mask))
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(glasses))
		if(glasses.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(head))
		var/obj/item/clothing/CH = head
		if(CH.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	return ..()

/mob/living/carbon/human/proc/handle_heart(delta_time, times_fired)
	var/we_breath = !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT)

	if(!undergoing_cardiac_arrest())
		return

	if(we_breath)
		adjustOxyLoss(4 * delta_time)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(1 * delta_time)

/mob/living/carbon/human/handle_hydration(delta_time, times_fired)
	..()
	if(hydration >= HYDRATION_LEVEL_OVERHYDRATED)
		if(DT_PROB(5, delta_time))
			try_pee()

/mob/living/proc/try_pee(forced_pee = FALSE)
	return

/mob/living/carbon/human/try_pee(forced_pee = FALSE)
	var/obj/item/organ/O = internal_organs_slot[ORGAN_SLOT_KIDNEYS]
	var/bloody = FALSE
	var/peeed = FALSE // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	if(O.damage > 51)
		bloody = TRUE
	var/turf/T = get_turf(src)
	var/atom/target = null
	var/obj/effect/decal/cleanable/mocha = bloody ?  new /obj/effect/decal/cleanable/blood(get_turf(src)) : new /obj/effect/decal/cleanable/urine(get_turf(src))
	for(var/atom/A in T)
		if(istype(A, /obj/effect/decal/cleanable/urine))
			mocha = A
			break
		if(istype(A, /obj/structure/toilet) || istype(A, /obj/item/reagent_containers))
			target = A
			break
	if(target)
		if(O.reagents.trans_to(target, 50, transfered_by = src) && !bloody)
			peeed = TRUE
		else if(forced_pee)
			peeed = TRUE
			O.setOrganDamage(1)
			blood_volume -= 10
		if(peeed)
			visible_message(span_notice("<b>[src]</b> писает[bloody ? " кровью" : ""] в [target]!"), span_notice("Писаю[bloody ? " кровью" : ""] в [target]."))
			playsound(src, 'sound/effects/splat.ogg', 50, 1)
			qdel(mocha)
	else
		if(w_uniform)
			if(O.reagents.trans_to(mocha, 25, transfered_by = src) && !bloody)
				peeed = TRUE
			else if(forced_pee)
				peeed = TRUE
				Stun(4 SECONDS)
				add_blood_DNA(return_blood_DNA())
				O.setOrganDamage(1)
				blood_volume -= 50
				mocha.reagents.add_reagent(/datum/reagent/blood, 50)
			if(peeed)
				extinguish_mob()
				visible_message("<b>[capitalize(src.name)]</b> мочится себе в трусы[bloody ? " кровью" : ""]!")
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
				if(!bloody)
					for(var/mob/M in viewers(src, 7))
						if(ishuman(M) && M != src)
							M.emote("laugh")
		else
			if(O.reagents.trans_to(mocha, 50, transfered_by = src) && !bloody)
				peeed = TRUE
			else if(forced_pee)
				Stun(2 SECONDS)
				O.setOrganDamage(1)
				blood_volume -= 50
				mocha.reagents.add_reagent(/datum/reagent/blood, 50)
			if(peeed)
				visible_message("<b>[capitalize(src.name)]</b> обильно ссыт[bloody ? " кровью" : ""] на пол!")
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
		if(!peeed)
			qdel(mocha)
	if(!peeed)
		qdel(mocha) // this is how we deal bussines
		to_chat(src, span_notice("Нечем мочиться!"))

#undef THERMAL_PROTECTION_HEAD
#undef THERMAL_PROTECTION_CHEST
#undef THERMAL_PROTECTION_GROIN
#undef THERMAL_PROTECTION_LEG_LEFT
#undef THERMAL_PROTECTION_LEG_RIGHT
#undef THERMAL_PROTECTION_FOOT_LEFT
#undef THERMAL_PROTECTION_FOOT_RIGHT
#undef THERMAL_PROTECTION_ARM_LEFT
#undef THERMAL_PROTECTION_ARM_RIGHT
#undef THERMAL_PROTECTION_HAND_LEFT
#undef THERMAL_PROTECTION_HAND_RIGHT
