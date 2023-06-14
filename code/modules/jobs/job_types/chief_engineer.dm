/datum/job/chief_engineer
	title = JOB_CHIEF_ENGINEER
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "капитану"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 1200
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_ENGINEERING

	outfit = /datum/outfit/job/ce

	skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)
	minimal_skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM, TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CHIEF_ENGINEER
	bounty_types = CIV_JOB_ENG

	mail_goodies = list(
		/obj/item/food/cracker = 25, //you know. for poly
		/obj/item/stack/sheet/mineral/diamond = 15,
		/obj/item/stack/sheet/mineral/uranium/five = 15,
		/obj/item/stack/sheet/mineral/plasma/five = 15,
		/obj/item/stack/sheet/mineral/gold = 15,
		/obj/effect/spawner/lootdrop/space/fancytool/engineonly = 3
	)

	departments_list = list(
		/datum/job_department/engineering,
		/datum/job_department/command,
	)

	rpg_title = "Head Crystallomancer"
	rpg_title_ru = "Старший Кристалломант"

	allow_new_players = FALSE

/datum/job/chief_engineer/announce(mob/living/carbon/human/H, announce_captaincy = FALSE)
	..()
	if(announce_captaincy)
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "Учитывая нехватку экипажа, текущим капитаном станции теперь является [H.real_name]!"))

/datum/outfit/job/ce
	name = JOB_CHIEF_ENGINEER
	jobtype = /datum/job/chief_engineer

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/storage/belt/utility/chief/full
	l_pocket = /obj/item/modular_computer/tablet/pda/heads/ce
	ears = /obj/item/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/rank/engineering/chief_engineer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/color/chief_engineer
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/card/id/departmental_budget/eng=1)

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	chameleon_extras = /obj/item/stamp/ce

	skillchips = list(/obj/item/skillchip/job/engineer)

	id_trim = /datum/id_trim/job/chief_engineer

/datum/outfit/job/ce/rig
	name = "Chief Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine/elite
	shoes = /obj/item/clothing/shoes/magboots/advance
	suit_store = /obj/item/tank/internals/oxygen
	glasses = /obj/item/clothing/glasses/meson/engine
	gloves = /obj/item/clothing/gloves/color/chief_engineer
	head = null
	internals_slot = ITEM_SLOT_SUITSTORE
