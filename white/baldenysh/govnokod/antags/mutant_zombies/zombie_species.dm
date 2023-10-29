/datum/component/zombie_weapon/mutant
	possible_tumors = list(/obj/item/organ/zombie_infection/mutant)
	infection_chance = 20

/obj/item/organ/zombie_infection/mutant
	zombie_species = /datum/species/zombie/infectious/mutant

/obj/item/organ/zombie_infection/mutant/Insert(mob/living/carbon/M, special)
	. = ..()
	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.add_infected_to_hud(M)

/obj/item/organ/zombie_infection/mutant/Remove(mob/living/carbon/M, special)
	. = ..()
	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.remove_infected_from_hud(M)





/datum/species/zombie/infectious/mutant
	name = "Mutant Zombie"
	id = "mutantzombies"
	mutanteyes = /obj/item/organ/eyes/night_vision/alien
	mutanthands = /obj/item/mutant_zombie_hand
	mutanttongue = /obj/item/organ/tongue/zombie/mutant
	armor = 0
	speedmod = 0.5

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

	C.faction = list("skeleton")

	C.throw_alert("zombiesense", /atom/movable/screen/alert/zombiesense/rebolutious)

/datum/species/zombie/infectious/mutant/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	if(C.mind)
		C.mind.remove_antag_datum(/datum/antagonist/mutant_zombie)

	for(var/obj/item/I in C.held_items)
		var/datum/component/zombie_weapon/mutant/ZW = I.GetComponent(/datum/component/zombie_weapon/mutant)
		if(ZW)
			qdel(ZW)

	var/datum/team/mutant_zombies/zombs = locate(/datum/team/mutant_zombies) in GLOB.antagonist_teams
	zombs?.remove_zombie_from_hud(C)

	C.clear_alert("zombiesense")

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
				armor += 20
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

///////////////////////////////////////////////////////////////искатор чоловиков

/atom/movable/screen/alert/zombiesense
	name = "Чоловеколокатор"
	desc = "Мозги-и-и-и-и-и."
	icon = 'icons/hud/screen_alert.dmi' //мб перерисовать нада
	icon_state = "cult_sense"
	alerttooltipstyle = "cult"
	var/angle = 0

/atom/movable/screen/alert/zombiesense/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/zombiesense/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/zombiesense/process()
	var/atom/nearest_target
	var/min_dist = 999
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != owner.z)
			continue
		if(!is_infectable(H))
			continue
		var/cur_dist = get_dist_euclidian(H, owner)
		if(cur_dist < min_dist)
			nearest_target = H
			min_dist = cur_dist

	var/turf/P = get_turf(nearest_target)
	var/turf/Q = get_turf(owner)
	if(!P || !Q || (P.z != Q.z))
		icon_state = "runed_sense2"
		desc = "Тута нету."
		return

	var/target_angle = get_angle(Q, P)
	cut_overlays()
	desc = "Тама..."
	switch(min_dist)
		if(0 to 1)
			icon_state = "runed_sense2"
			desc = "Пряма тута."
		if(2 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"

	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)

/proc/is_infectable(mob/living/carbon/human/H)
	if(!H.ckey)
		return FALSE
	if(!H.get_bodypart(BODY_ZONE_HEAD))
		return FALSE
	if(H.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		return FALSE
	CHECK_DNA_AND_SPECIES(H)
	if(istype(H.dna.species, /datum/species/zombie))
		return FALSE
	return TRUE

////////////////////

/atom/movable/screen/alert/zombiesense/rebolutious
	icon = 'white/baldenysh/icons/obj/rebolutious_radar.dmi'
	icon_state = "zradar0"

/atom/movable/screen/alert/zombiesense/rebolutious/process()
	var/atom/nearest_target
	var/min_dist = 999
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != owner.z)
			continue
		if(!is_infectable(H))
			continue
		var/cur_dist = get_dist_euclidian(H, owner)
		if(cur_dist < min_dist)
			nearest_target = H
			min_dist = cur_dist

	var/turf/P = get_turf(nearest_target)
	var/turf/Q = get_turf(owner)
	if(!P || !Q || (P.z != Q.z))
		icon_state = "zradar0"
		return

	cut_overlays()
	switch(min_dist)
		if(0 to 1) icon_state = "zradarcenter"
		if(2 to 8) icon_state = "zradar"
		if(9 to 15)	icon_state = "zradar2"
		if(15 to INFINITY) icon_state = "zradar3"

	dir = get_dir(Q, P)


