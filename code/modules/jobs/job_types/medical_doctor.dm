/datum/job/doctor
	title = JOB_MEDICAL_DOCTOR
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "главному врачу"
	selection_color = "#ffeef0"

	exp_type = EXP_TYPE_CREW
	exp_requirements = 120

	outfit = /datum/outfit/job/doctor

	skills = list(/datum/skill/surgery = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/surgery = SKILL_EXP_NOVICE)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	bounty_types = CIV_JOB_MED

	mail_goodies = list(
		/obj/item/healthanalyzer/advanced = 15,
		/obj/item/scalpel/advanced = 6,
		/obj/item/retractor/advanced = 6,
		/obj/item/cautery/advanced = 6,
		/datum/reagent/toxin/formaldehyde = 6,
		/obj/effect/spawner/lootdrop/organ_spawner = 5,
		/obj/effect/spawner/lootdrop/memeorgans = 1
	)

	departments_list = list(
		/datum/job_department/medical,
	)

	rpg_title = "Cleric"
	rpg_title_ru = "Клерик"

/datum/outfit/job/doctor
	name = JOB_MEDICAL_DOCTOR
	jobtype = /datum/job/doctor

	belt = /obj/item/modular_computer/tablet/pda/medical
	ears = /obj/item/radio/headset/headset_med
	head = /obj/item/clothing/head/surgerycap
	uniform = /obj/item/clothing/under/rank/medical/doctor
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/medical/surg
	suit_store = /obj/item/flashlight/pen
	r_pocket = /obj/item/storage/pill_bottle/ultra/doc

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/job/medic/advanced)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/medical_doctor
