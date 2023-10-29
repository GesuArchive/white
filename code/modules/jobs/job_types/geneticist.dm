/datum/job/geneticist
	title = JOB_GENETICIST
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "научному руководителю"
	selection_color = "#ffeef0"
	exp_type = EXP_TYPE_CREW
	minimal_player_age = 14
	exp_requirements = 300

	outfit = /datum/outfit/job/geneticist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_GENETICIST
	bounty_types = CIV_JOB_SCI

	mail_goodies = list(
		/obj/item/storage/box/monkeycubes = 10
	)

	departments_list = list(
		/datum/job_department/science,
	)

	rpg_title = "Genemancer"
	rpg_title_ru = "Геномансер"

/datum/outfit/job/geneticist
	name = JOB_GENETICIST
	jobtype = /datum/job/geneticist

	belt = /obj/item/modular_computer/tablet/pda/geneticist
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/rnd/geneticist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/genetics
	suit_store =  /obj/item/flashlight/pen
	l_pocket = /obj/item/sequence_scanner

	backpack = /obj/item/storage/backpack/genetics
	satchel = /obj/item/storage/backpack/satchel/gen

	id_trim = /datum/id_trim/job/geneticist
