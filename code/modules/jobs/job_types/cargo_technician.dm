/datum/job/cargo_technician
	title = JOB_CARGO_TECHNICIAN
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "завхозу и главе персонала"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/cargo_tech

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_CARGO_TECHNICIAN
	bounty_types = CIV_JOB_RANDOM

	mail_goodies = list(
		/obj/item/pizzabox = 10,
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stack/sheet/mineral/uranium = 4,
		/obj/item/stack/sheet/mineral/diamond = 3,
		/obj/item/gun/ballistic/rifle/boltaction = 1
	)

	departments_list = list(
		/datum/job_department/cargo,
	)

	rpg_title = "Merchantman"
	rpg_title_ru = "Купец"

/datum/outfit/job/cargo_tech
	name = JOB_CARGO_TECHNICIAN
	jobtype = /datum/job/cargo_technician

	belt = /obj/item/modular_computer/tablet/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo/tech
	l_hand = /obj/item/export_scanner
	id_trim = /datum/id_trim/job/cargo_technician
