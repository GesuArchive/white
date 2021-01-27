/datum/outfit/job/bomj
	name = "Бомж"
	jobtype = /datum/job/bomj
	uniform = /obj/item/clothing/under/shorts/black
	backpack = null
	satchel = null
	duffelbag = null
	id = null
	ears = null
	belt = null
	back = null
	shoes = null
	box = null
	l_pocket = /obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	r_pocket = /obj/item/reagent_containers/food/drinks/boyarka

/datum/outfit/job/bomj/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjustOxyLoss(rand(1, 20))
	H.adjustFireLoss(rand(1, 10))
	H.adjustBruteLoss(rand(1, 10))
	H.dna.add_mutation(WACKY)
	if(prob(15))
		H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
