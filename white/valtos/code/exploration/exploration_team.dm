/datum/job/exploration
	title = "Exploration Crew"
	ru_title = "Рейнджер"
	department_head = list("Head of Personnel", "Research Director")
	exp_type = EXP_TYPE_CREW
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "завхозу, главе персонала и научному руководителю"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/exploration

	skills = list(/datum/skill/ranged = SKILL_EXP_EXPERT, /datum/skill/surgery = SKILL_EXP_JOURNEYMAN, /datum/skill/parry = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/ranged = SKILL_EXP_JOURNEYMAN, /datum/skill/surgery = SKILL_EXP_APPRENTICE, /datum/skill/parry = SKILL_EXP_APPRENTICE)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SHAFT_MINER
	bounty_types = CIV_JOB_MINE

	metalocked = TRUE

/datum/outfit/job/exploration
	name = "Exploration Crew"
	jobtype = /datum/job/exploration

	belt = /obj/item/modular_computer/tablet/pda/exploration
	ears = /obj/item/radio/headset/headset_exploration
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/cargo/exploration
	backpack_contents = list(
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/discovery_scanner=1,
		/obj/item/rangers_voucher=1,
		/obj/item/stack/marker_beacon/thirty=1)
	l_pocket = /obj/item/gps/mining/exploration
	r_pocket = /obj/item/gun/energy/e_gun/mini/exploration

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag/rangers

	id_trim = /datum/id_trim/job/exploration
	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = /obj/item/gun/energy/e_gun/mini/exploration

/datum/outfit/job/exploration/hardsuit
	name = "Exploration Crew (Hardsuit)"
	suit = /obj/item/clothing/suit/space/hardsuit/exploration
	suit_store = /obj/item/tank/internals/tactical
	mask = /obj/item/clothing/mask/breath
