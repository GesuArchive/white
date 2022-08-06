/datum/job/station_engineer
	title = "Station Engineer"
	ru_title = "Инженер"
	department_head = list("Chief Engineer")
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "старшему инженеру"
	selection_color = "#fff5cc"
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/engineer

	skills = list(/datum/skill/engineering = SKILL_EXP_JOURNEYMAN)
	minimal_skills = list(/datum/skill/engineering = SKILL_EXP_JOURNEYMAN)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_STATION_ENGINEER
	bounty_types = CIV_JOB_ENG

	mail_goodies = list(
		/obj/item/storage/box/lights/mixed = 20,
		/obj/item/lightreplacer = 10,
		/obj/item/holosign_creator/engineering = 8,
	)

	rpg_title = "Crystallomancer"
	rpg_title_ru = "Кристалломант"

/datum/outfit/job/engineer
	name = "Station Engineer"
	jobtype = /datum/job/station_engineer

	belt = /obj/item/storage/belt/utility/full/engi
	l_pocket = /obj/item/modular_computer/tablet/pda/engineering
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/hardhat
	r_pocket = /obj/item/t_scanner

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced/engineering=1)

	skillchips = list(/obj/item/skillchip/job/engineer)

	id_trim = /datum/id_trim/job/station_engineer

/datum/outfit/job/engineer/gloved
	name = "Station Engineer (Gloves)"
	gloves = /obj/item/clothing/gloves/color/yellow

/datum/outfit/job/engineer/gloved/rig
	name = "Station Engineer (Hardsuit)"
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine
	suit_store = /obj/item/tank/internals/oxygen
	head = null
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/job/engineer/gloved/gunner
	id_trim = /datum/id_trim/job/station_engineer/gunner

/datum/outfit/job/engineer/gloved/rig/gunner
	id_trim = /datum/id_trim/job/station_engineer/gunner
