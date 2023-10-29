/mob/living/carbon/human/get_movespeed_modifiers()
	var/list/considering = ..()
	if(HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
		. = list()
		for(var/id in considering)
			var/datum/movespeed_modifier/M = considering[id]
			if(M.flags & IGNORE_NOSLOW || M.multiplicative_slowdown < 0)
				.[id] = M
		return
	return considering

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube, paralyze, forcedrop)
	if(HAS_TRAIT(src, TRAIT_NOSLIPALL))
		return FALSE
	if (!(lube & GALOSHES_DONT_HELP))
		if(HAS_TRAIT(src, TRAIT_NOSLIPWATER))
			return FALSE
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP)
				return FALSE
	if (lube & SLIDE_ICE)
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP_ICE)
				return FALSE
	return ..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/effects/space_wind.ogg', 50, TRUE, channel = open_sound_channel_for_wind())
	if(HAS_TRAIT(src, TRAIT_NEGATES_GRAVITY))
		return FALSE
	return ..()

/mob/living/carbon/human/mob_negates_gravity()
	return dna.species.negates_gravity(src) || ..()

/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	if(shoes && body_position == STANDING_UP && loc == NewLoc && has_gravity(loc))
		SEND_SIGNAL(shoes, COMSIG_SHOES_STEP_ACTION)

	var/turf/T = get_turf(src)

	//Snow footprints
	if(istype(T, /turf/open/floor/grass/snow) || istype(T, /turf/open/floor/plating/snowed))
		if(!buckled && !(movement_type & FLYING))
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/effect/decal/cleanable/snow_footprints/oldFP = locate(/obj/effect/decal/cleanable/snow_footprints) in T
				if(oldFP)
					oldFP.entered_dirs |= dir
					oldFP.update_icon()
				else
					var/obj/effect/decal/cleanable/snow_footprints/FP = new /obj/effect/decal/cleanable/snow_footprints(T)
					FP.entered_dirs |= dir
					FP.update_icon()

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0, continuous_move = FALSE) //Temporary laziness thing. Will change to handles by species reee.
	if(dna.species.space_move(src))
		return TRUE
	return ..()
