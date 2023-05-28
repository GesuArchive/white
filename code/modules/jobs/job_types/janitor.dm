/datum/job/janitor
	title = JOB_JANITOR
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "главе персонала"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/janitor

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_JANITOR

	mail_goodies = list(
		/obj/item/grenade/chem_grenade/cleaner = 30,
		/obj/item/storage/box/lights/mixed = 20,
		/obj/item/lightreplacer = 10
	)

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Groundskeeper"
	rpg_title_ru = "Хранитель земель"

/datum/outfit/job/janitor
	name = JOB_JANITOR
	jobtype = /datum/job/janitor

	belt = /obj/item/modular_computer/tablet/pda/janitor
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/janitor

	id_trim = /datum/id_trim/job/janitor

/datum/outfit/job/janitor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(GARBAGEDAY in SSevents.holidays)
		backpack_contents += /obj/item/gun/ballistic/revolver
		r_pocket = /obj/item/ammo_box/a357

/datum/outfit/job/janitor/get_types_to_preload()
	. = ..()
	if(GARBAGEDAY in SSevents.holidays)
		. += /obj/item/gun/ballistic/revolver
		. += /obj/item/ammo_box/a357
