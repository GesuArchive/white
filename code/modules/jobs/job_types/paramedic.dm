/datum/job/paramedic
	title = JOB_PARAMEDIC
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "главному врачу"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/paramedic

	skills = list(/datum/skill/surgery = SKILL_EXP_NOVICE)
	minimal_skills = list(/datum/skill/surgery = SKILL_EXP_NOVICE)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PARAMEDIC
	bounty_types = CIV_JOB_MED

	mail_goodies = list(
		/obj/item/reagent_containers/hypospray/medipen = 20,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 10,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 10,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = 10,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 10,
		/obj/item/reagent_containers/hypospray/medipen/survival/luxury = 5
	)

	departments_list = list(
		/datum/job_department/medical,
	)

	rpg_title = "Corpse Runner"
	rpg_title_ru = "Могильщик"

/obj/item/storage/belt/medical/paramedic
	preload = TRUE

/obj/item/storage/belt/medical/paramedic/PopulateContents()
	new /obj/item/pinpointer/crew/prox(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/reagent_containers/medigel/libital(src)
	new /obj/item/reagent_containers/medigel/aiuri(src)
	update_appearance()

/obj/item/storage/belt/medical/paramedic/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/pinpointer/crew/prox
	to_preload += /obj/item/surgical_drapes
	to_preload += /obj/item/scalpel
	to_preload += /obj/item/hemostat
	to_preload += /obj/item/cautery
	to_preload += /obj/item/bonesetter
	to_preload += /obj/item/reagent_containers/medigel/libital
	to_preload += /obj/item/reagent_containers/medigel/aiuri
	return to_preload

/datum/outfit/job/paramedic
	name = JOB_PARAMEDIC
	jobtype = /datum/job/paramedic

	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	head = /obj/item/clothing/head/soft/paramedic
	shoes = /obj/item/clothing/shoes/sneakers/blue
	suit =  /obj/item/clothing/suit/toggle/labcoat/paramedic
	gloves = /obj/item/clothing/gloves/color/latex/nitrile/polymer
	belt = /obj/item/storage/belt/medical/paramedic
	id = /obj/item/card/id/advanced
	r_pocket = /obj/item/storage/belt/medipenal/paramed
	l_pocket = /obj/item/modular_computer/tablet/pda/medical/paramedic
	suit_store = /obj/item/flashlight/pen/paramedic
	backpack_contents = list(/obj/item/roller=1, /obj/item/storage/firstaid/regular=1, /obj/item/sensor_device=1)
	pda_slot = ITEM_SLOT_LPOCKET

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	skillchips = list(/obj/item/skillchip/job/medic)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/paramedic
