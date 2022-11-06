/datum/job/research_director
	title = JOB_RESEARCH_DIRECTOR
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	head_announce = list("Science")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "капитану"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 1200
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/rd

	skills = list(/datum/skill/ranged = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/ranged = SKILL_EXP_APPRENTICE)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR
	bounty_types = CIV_JOB_SCI

	mail_goodies = list(
		/obj/item/storage/box/monkeycubes = 30,
		/obj/item/circuitboard/machine/sleeper = 3,
		/obj/item/borg/upgrade/ai = 2
	)

	departments_list = list(
		/datum/job_department/science,
		/datum/job_department/command,
	)

	rpg_title = "Archmagister"
	rpg_title_ru = "Архимагистр"

/datum/job/research_director/announce(mob/living/carbon/human/H, announce_captaincy = FALSE)
	..()
	if(announce_captaincy)
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Учитывая нехватку экипажа, текущим капитаном станции теперь является [H.real_name]!"))

/datum/outfit/job/rd
	name = JOB_RESEARCH_DIRECTOR
	jobtype = /datum/job/research_director

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/modular_computer/tablet/pda/heads/rd
	ears = /obj/item/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/rnd/research_director
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/laser_pointer
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/card/id/departmental_budget/sci=1)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

	skillchips = list(/obj/item/skillchip/job/research_director)

	chameleon_extras = /obj/item/stamp/rd

	id_trim = /datum/id_trim/job/research_director

/datum/outfit/job/rd/rig
	name = "Research Director (Hardsuit)"

	l_hand = null
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/rd
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
