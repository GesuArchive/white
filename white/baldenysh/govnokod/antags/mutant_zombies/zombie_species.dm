/datum/component/zombie_weapon/mutant
	possible_tumors = list(/obj/item/organ/zombie_infection/mutant)

/obj/item/organ/zombie_infection/mutant
	zombie_species = /datum/species/zombie/infectious/mutant

/datum/species/zombie/infectious/mutant
	name = "Mutant Zombie"
	id = "mutantzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien
	mutanthands = null
	armor = 0
	speedmod = 1.7

/datum/species/zombie/infectious/mutant/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	if(ishuman(C))
		mutate_hands(C)
		mutate_body(C)

/datum/species/zombie/infectious/mutant/proc/mutate_hands(mob/living/carbon/human/H)
	var/speed_mod = 0
	var/hand_removed = FALSE
	for(var/index in 1 to H.held_items.len)
		if(!H.has_hand_for_held_index(index))
			hand_removed = TRUE
			continue
		if(prob(10) && !hand_removed)
			var/which_hand = BODY_ZONE_L_ARM
			if(!(index % 2))
				which_hand = BODY_ZONE_R_ARM
			var/obj/item/bodypart/chopchop = H.get_bodypart(which_hand)
			chopchop.dismember()
			hand_removed = TRUE
			continue

		var/obj/item/newhand
		switch(rand(1,12))
			if(1 to 3)
				newhand = new /obj/item/melee/arm_blade()
				armor += 5
				speed_mod += 1.7
			if(4 to 6)
				newhand = new /obj/item/gun/magic/tentacle/mutantzombie()
				speed_mod += 1.4
			if(7 to 9)
				newhand = new /obj/item/shield/mutantzombie()
				armor += 10
				speed_mod += 1.5
			if(10 to 12)
				newhand = new /obj/item/mutant_zombie_hand()
				speed_mod -= 0.5
				armor -= 10

		newhand.AddComponent(/datum/component/zombie_weapon/mutant)

		H.put_in_hand(newhand, index, TRUE)

		if(!(index % 2))
			var/matrix/M = matrix()
			M.Scale(-1,1)
			newhand.transform = M

	H.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/species, multiplicative_slowdown=speed_mod/H.held_items.len)

/datum/species/zombie/infectious/mutant/proc/mutate_body(mob/living/carbon/human/H)
	//пох
