/datum/job/chemist
	title = "Chemist"
	ru_title = "Химик"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "главному врачу"
	selection_color = "#ffeef0"
	exp_type = EXP_TYPE_CREW
	exp_requirements = 900

	outfit = /datum/outfit/job/chemist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CHEMIST
	bounty_types = CIV_JOB_CHEM

	mail_goodies = list(
		/datum/reagent/flash_powder = 15,
		/datum/reagent/exotic_stabilizer = 5,
		/datum/reagent/toxin/leadacetate = 5,
		/obj/item/paper/secretrecipe = 1
	)
	rpg_title = "Алхимик"


/datum/outfit/job/chemist
	name = "Chemist"
	jobtype = /datum/job/chemist

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/pda/chemist
	l_pocket = /obj/item/reagent_containers/glass/bottle/random_buffer
	r_pocket = /obj/item/reagent_containers/dropper
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist
	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chem
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cheap=1)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/chemist

