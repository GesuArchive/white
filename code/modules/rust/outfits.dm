/datum/outfit/job/rust_enjoyer
	name = "Rusty"
	jobtype = /datum/job/rust_enjoyer
	l_hand = /obj/item/flashlight/flare/torch
	r_hand = /obj/item/multifunctional_rust_rock
	uniform = null
	shoes = null
	l_pocket = null
	r_pocket = null
	id = null
	belt = null
	ears = null
	box = null
	back = null
	backpack = null

/datum/outfit/job/rust_enjoyer/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_CORPSELOCKED, "rust")

/datum/outfit/job/rust_enjoyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return

/datum/outfit/job/rust_enjoyer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return
