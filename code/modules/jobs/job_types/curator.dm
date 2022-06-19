/datum/job/curator
	title = "Curator"
	ru_title = "Куратор"
	department_head = list("Head of Personnel")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "главе персонала"
	selection_color = "#bbe291"

	minimal_player_age = 15
	exp_requirements = 720
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/curator

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_CURATOR

	rpg_title = "Veteran Adventurer"
	rpg_title_ru = "Опытный искатель приключений"

/datum/outfit/job/curator
	name = "Curator"
	jobtype = /datum/job/curator

	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/modular_computer/tablet/pda/curator
	ears = /obj/item/radio/headset/headset_curator
	uniform = /obj/item/clothing/under/rank/civilian/curator
	l_hand = /obj/item/storage/bag/books
	r_pocket = /obj/item/key/displaycase
	l_pocket = /obj/item/laser_pointer
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/choice_beacon/hero = 1,
		/obj/item/soapstone = 1,
		/obj/item/barcodescanner = 1
	)

	id_trim = /datum/id_trim/job/curator

/datum/outfit/job/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	H.grant_all_languages(TRUE, TRUE, TRUE, LANGUAGE_CURATOR)
