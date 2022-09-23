/datum/job/chemist
	title = JOB_CHEMIST
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "главному врачу"
	selection_color = "#ffeef0"
	exp_type = EXP_TYPE_CREW
	exp_requirements = 300

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

	departments_list = list(
		/datum/job_department/medical,
	)

	rpg_title = "Alchemist"
	rpg_title_ru = "Алхимик"

/datum/outfit/job/chemist
	name = JOB_CHEMIST
	jobtype = /datum/job/chemist

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/modular_computer/tablet/pda/chemist
	l_pocket = /obj/item/reagent_containers/glass/bottle/basic_buffer
	r_pocket = /obj/item/reagent_containers/glass/bottle/acidic_buffer
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist
	suit_store = /obj/item/reagent_containers/dropper
	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chem
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/chemist

