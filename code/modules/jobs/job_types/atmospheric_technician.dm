/datum/job/atmospheric_technician
	title = "Atmospheric Technician"
	ru_title = "Атмосферный Техник"
	department_head = list("Chief Engineer" = "Старший Инженер")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "старшему инженеру"
	selection_color = "#fff5cc"
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/atmos

	skills = list(/datum/skill/engineering = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/engineering = SKILL_EXP_APPRENTICE)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN
	bounty_types = CIV_JOB_ENG

	rpg_title = "Aeromancer"
	rpg_title_ru = "Аэромансер"

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmospheric_technician

	belt = /obj/item/storage/belt/utility/atmostech
	l_pocket = /obj/item/modular_computer/tablet/pda/atmos
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	r_pocket = /obj/item/analyzer

	backpack = /obj/item/storage/backpack/industrial
	backpack_contents = list(/obj/item/extinguisher/mini=1)
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET

	id_trim = /datum/id_trim/job/atmospheric_technician

/datum/outfit/job/atmos/rig
	name = "Atmospheric Technician (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/atmos
	suit = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
