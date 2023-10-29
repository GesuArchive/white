/datum/job/botanist
	title = JOB_BOTANIST
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "главе персонала"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/botanist

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BOTANIST
	bounty_types = CIV_JOB_GROW

	mail_goodies = list(
		/datum/reagent/toxin/mutagen = 20,
		/datum/reagent/saltpetre = 20,
		/datum/reagent/diethylamine = 20,
		/obj/item/gun/energy/floragun = 10,
		/obj/effect/spawner/lootdrop/space/rareseed = 5,// These are strong, rare seeds, so use sparingly.
		/obj/item/food/monkeycube/bee = 2
	)

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Gardener"
	rpg_title_ru = "Садовник"

/datum/outfit/job/botanist
	name = JOB_BOTANIST
	jobtype = /datum/job/botanist

	belt = /obj/item/modular_computer/tablet/pda/botanist
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves  =/obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/plant_analyzer

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd


	id_trim = /datum/id_trim/job/botanist
