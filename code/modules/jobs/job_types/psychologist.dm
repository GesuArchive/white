/datum/job/psychologist
	title = JOB_PSYCHOLOGIST
	department_head = list(JOB_HEAD_OF_PERSONNEL, JOB_CHIEF_MEDICAL_OFFICER)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel and the chief medical officer"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/psychologist

	exp_type = EXP_TYPE_CREW
	exp_requirements = 300

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PSYCHOLOGIST

	mail_goodies =  list(
		/obj/item/storage/pill_bottle/mannitol = 30,
		/obj/item/storage/pill_bottle/happy = 5,
		/obj/item/gun/syringe = 1
	)

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Snake Oil Salesman"
	rpg_title_ru = "Продавец змеиного яда"

/datum/outfit/job/psychologist
	name = JOB_PSYCHOLOGIST
	jobtype = /datum/job/psychologist

	ears = /obj/item/radio/headset/headset_srvmed
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/advanced
	belt = /obj/item/modular_computer/tablet/pda/medical
	pda_slot = ITEM_SLOT_BELT
	l_hand = /obj/item/clipboard
	r_pocket = /obj/item/hypno_watch

	backpack_contents = list(/obj/item/storage/pill_bottle/ultra/psih)

	skillchips = list(/obj/item/skillchip/job/psychology)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	id_trim = /datum/id_trim/job/psychologist
