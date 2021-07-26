/datum/component/zombie_weapon/mutant
	possible_tumors = list(/obj/item/organ/zombie_infection/mutant)
	infection_chance = 20

/obj/item/organ/zombie_infection/mutant
	zombie_species = /datum/species/zombie/infectious/mutant

/obj/item/organ/zombie_infection/mutant/Insert(mob/living/carbon/M, special)
	. = ..()
	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.add_infected_to_hud(M)
	/*
		for(var/datum/antagonist/mutant_zombie/Z in GLOB.antagonists)
			if(!Z.owner)
				continue
			if(Z.zombs)
				Z.zombs.add_infected_to_hud(M)
				break
				*/

/obj/item/organ/zombie_infection/mutant/Remove(mob/living/carbon/M, special)
	. = ..()
	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.remove_infected_from_hud(M)
	/*
		for(var/datum/antagonist/mutant_zombie/Z in GLOB.antagonists)
			if(!Z.owner)
				continue
			if(Z.zombs)
				Z.zombs.remove_infected_from_hud(M)
				break
	*/

/datum/species/zombie/infectious/mutant
	name = "Mutant Zombie"
	id = "mutantzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien
	mutanthands = /obj/item/mutant_zombie_hand
	armor = 50
	speedmod = 1

/datum/species/zombie/infectious/mutant/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	if(ishuman(C))
		mutate_hands(C)
	//	mutate_body(C)

	if(C.mind)
		var/datum/antagonist/mutant_zombie/zomb = new
		C.mind.add_antag_datum(zomb)
		message_admins("[ADMIN_LOOKUPFLW(C)] стал зомби.")
		log_game("[key_name(C)] стал зомби.")

	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.add_zombie_to_hud(C)

/datum/species/zombie/infectious/mutant/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	if(C.mind)
		C.mind.remove_antag_datum(/datum/antagonist/mutant_zombie)

	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.remove_zombie_from_hud(C)

/datum/species/zombie/infectious/mutant/proc/mutate_hands(mob/living/carbon/human/H)
	var/cur_speed_mod = speedmod
	for(var/index in 1 to H.held_items.len)
		if(!H.has_hand_for_held_index(index))
			cur_speed_mod -= 0.5
			armor += 10
			continue
		if(prob(10) && H.usable_hands > 1)
			var/which_hand = BODY_ZONE_L_ARM
			if(!(index % 2))
				which_hand = BODY_ZONE_R_ARM
			var/obj/item/bodypart/chopchop = H.get_bodypart(which_hand)
			chopchop.dismember()
			continue

		var/obj/item/newhand
		switch(rand(1,4))
			if(1)
				newhand = new /obj/item/melee/arm_blade()
				armor += 15
				cur_speed_mod += 0.4
			if(2)
				newhand = new /obj/item/gun/magic/tentacle/mutantzombie()
				armor += 10
				cur_speed_mod += 0.1
			if(3)
				newhand = new /obj/item/shield/mutantzombie()
				armor += 25
				cur_speed_mod += 0.2
			if(4)
				newhand = new /obj/item/mutant_zombie_hand()
				cur_speed_mod -= 0.3

		newhand.AddComponent(/datum/component/zombie_weapon/mutant)
		ADD_TRAIT(newhand, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

		H.put_in_hand(newhand, index, TRUE)
		if(!(index % 2))
			var/matrix/M = matrix()
			M.Scale(-1,1)
			newhand.transform = M

	speedmod = cur_speed_mod
	H.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/species, multiplicative_slowdown=speedmod)

/datum/species/zombie/infectious/mutant/proc/mutate_body(mob/living/carbon/human/H)
	var/cur_speed_mod = speedmod

	switch(rand(1,3))
		if(1)
			H.dropItemToGround(H.wear_suit, TRUE)
			H.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/changeling(H), ITEM_SLOT_OCLOTHING, 1, 1, 1)
			cur_speed_mod += 0.2
		if(2)
			H.dropItemToGround(H.wear_suit, TRUE)
			H.equip_to_slot_if_possible(new /obj/item/clothing/suit/space/changeling(H), ITEM_SLOT_OCLOTHING, 1, 1, 1)
			cur_speed_mod += 0.1
		if(3)
			cur_speed_mod -= 0.2

	switch(rand(1,3))
		if(1)
			H.dropItemToGround(H.head, TRUE)
			H.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/space/changeling(H), ITEM_SLOT_OCLOTHING, 1, 1, 1)
			cur_speed_mod += 0.2
		if(2)
			H.dropItemToGround(H.head, TRUE)
			H.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/changeling(H), ITEM_SLOT_OCLOTHING, 1, 1, 1)
			cur_speed_mod += 0.1
		if(3)
			cur_speed_mod -= 0.2

	speedmod = cur_speed_mod
	H.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/species, multiplicative_slowdown=speedmod)


