/datum/outfit/job/bomj
	name = JOB_BOMJ
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
	r_pocket = /obj/item/reagent_containers/food/drinks/boyarka

/datum/outfit/job/bomj/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return

/datum/outfit/job/bomj/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjustOxyLoss(rand(1, 30))
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 99))
	H.adjustFireLoss(rand(1, 30))
	H.adjustBruteLoss(rand(1, 30))
	H.dna.add_mutation(WACKY)
	if(prob(55))
		H.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
	if(prob(25))
		var/datum/disease/P = new /datum/disease/parasite()
		H.ForceContractDisease(P, FALSE, TRUE)
