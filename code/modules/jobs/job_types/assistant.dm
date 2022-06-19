/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	ru_title = "Ассистент"
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "практически всем"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	mail_goodies = list(
		/obj/effect/spawner/lootdrop/donkpockets = 10,
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/gloves/color/fyellow = 7,
		/obj/item/choice_beacon/music = 5,
		/obj/item/toy/sprayoncan = 3,
		/obj/item/crowbar/large = 1
	)

	rpg_title = "Lout"
	rpg_title_ru = "Деревенщина"

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant
	id_trim = /datum/id_trim/job/assistant

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/grey // ASS WEEK
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/grey // ASS WEEK
	else
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/random
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/random

	if(GLOB.disable_fucking_station_shit_please)
		uniform = pick(/obj/item/clothing/under/switer/tracksuit, /obj/item/clothing/under/switer/lolg, /obj/item/clothing/under/switer/dark, /obj/item/clothing/under/switer)
		shoes = /obj/item/clothing/shoes/jackboots
		l_pocket = /obj/item/kitchen/knife/hunting
		r_pocket = /obj/item/storage/box/matches
		id = null
		belt = null
		ears = null
