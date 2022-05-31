/datum/job/head_of_security
	title = "Head of Security"
	ru_title = "Начальник Охраны"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Captain")
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "капитану"
	selection_color = "#ffdddd"
	req_admin_notify = 1
	minimal_player_age = 45
	exp_requirements = 9100
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/hos

	skills = list(/datum/skill/ranged = SKILL_EXP_MASTER, /datum/skill/parry = SKILL_EXP_MASTER)
	minimal_skills = list(/datum/skill/ranged = SKILL_EXP_EXPERT, /datum/skill/parry = SKILL_EXP_MASTER)

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY
	bounty_types = CIV_JOB_SEC

	rpg_title = "Начальник стражи"

/datum/job/head_of_security/announce(mob/living/carbon/human/H, announce_captaincy = FALSE)
	..()
	if(announce_captaincy)
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Учитывая нехватку экипажа, текущим капитаном станции теперь является [H.real_name]!"))

/datum/outfit/job/hos
	name = "Head of Security"
	jobtype = /datum/job/head_of_security

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/melee/baseball_bat/hos
	ears = /obj/item/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/rank/security/head_of_security
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/hos/trenchcoat
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/hos/beret
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	suit_store = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/modular_computer/tablet/pda/heads/hos
	l_pocket = /obj/item/restraints/handcuffs
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced/command=1, /obj/item/card/id/departmental_budget/sec=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield, /obj/item/implant/krav_maga)

	chameleon_extras = list(/obj/item/gun/energy/e_gun/hos, /obj/item/stamp/hos)

	id_trim = /datum/id_trim/job/head_of_security

/datum/outfit/job/hos/hardsuit
	name = "Head of Security (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/security/hos
	suit_store = /obj/item/tank/internals/oxygen

