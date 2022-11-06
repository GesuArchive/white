/datum/job/roboticist
	title = JOB_ROBOTICIST
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "научному руководителю"
	selection_color = "#ffeeff"
	exp_requirements = 500
	exp_type = EXP_TYPE_CREW
	bounty_types = CIV_JOB_ROBO

	outfit = /datum/outfit/job/roboticist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_ROBOTICIST

	mail_goodies = list(
		/obj/item/storage/box/flashes = 20,
		/obj/item/stack/sheet/iron/twenty = 15,
	)

	departments_list = list(
		/datum/job_department/science,
	)

	rpg_title = "Necromancer"
	rpg_title_ru = "Некромант"

/datum/outfit/job/roboticist
	name = JOB_ROBOTICIST
	jobtype = /datum/job/roboticist

	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/modular_computer/tablet/pda/roboticist
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/rnd/roboticist
	suit = /obj/item/clothing/suit/toggle/labcoat/roboticist

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

	pda_slot = ITEM_SLOT_LPOCKET

	skillchips = list(/obj/item/skillchip/job/roboticist)

	id_trim = /datum/id_trim/job/roboticist
