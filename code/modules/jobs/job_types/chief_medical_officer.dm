/datum/job/chief_medical_officer
	title = JOB_CHIEF_MEDICAL_OFFICER
	department_head = list(JOB_CAPTAIN)
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	head_announce = list(RADIO_CHANNEL_MEDICAL)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "капитану"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 1200
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/cmo

	skills = list(/datum/skill/surgery = SKILL_EXP_MASTER, /datum/skill/ranged = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/surgery = SKILL_EXP_MASTER, /datum/skill/ranged = SKILL_EXP_APPRENTICE)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM, TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER
	bounty_types = CIV_JOB_MED

	mail_goodies = list(
		/obj/effect/spawner/lootdrop/organ_spawner = 10,
		/obj/effect/spawner/lootdrop/memeorgans = 8,
		/obj/effect/spawner/lootdrop/space/fancytool/advmedicalonly = 4,
		/obj/effect/spawner/lootdrop/space/fancytool/raremedicalonly = 1
	)

	departments_list = list(
		/datum/job_department/medical,
		/datum/job_department/command,
	)

	rpg_title = "High Cleric"
	rpg_title_ru = "Высший Клерик"

/datum/job/chief_medical_officer/announce(mob/living/carbon/human/H, announce_captaincy = FALSE)
	..()
	if(announce_captaincy)
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Учитывая нехватку экипажа, текущим капитаном станции теперь является [H.real_name]!"))

/obj/item/storage/belt/medical/cmo
	name = "пояс главного врача"
	desc = "Медицинский пояс с продвинутыми хирургическими инструментами."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "belt_cmo"

/obj/item/storage/belt/medical/cmo/PopulateContents()
	new /obj/item/surgical_drapes(src)
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/bonesetter/advanced(src)
	new /obj/item/reagent_containers/medigel/sal_acid_oxandrolone(src)
	new /obj/item/reagent_containers/medigel/pen_acid(src)
	new /obj/item/sensor_device(src)

/datum/outfit/job/cmo
	name = JOB_CHIEF_MEDICAL_OFFICER
	jobtype = /datum/job/chief_medical_officer

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/storage/belt/medical/cmo
	r_pocket = /obj/item/modular_computer/tablet/pda/heads/cmo
	l_pocket = /obj/item/pinpointer/crew
	ears = /obj/item/radio/headset/heads/cmo
	head = /obj/item/clothing/head/surgerycap/cmo
	uniform = /obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen/paramedic
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/card/id/departmental_budget/med=1)

	skillchips = list(/obj/item/skillchip/entrails_reader)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	chameleon_extras = list(/obj/item/gun/syringe, /obj/item/stamp/cmo)

	id_trim = /datum/id_trim/job/chief_medical_officer
	pda_slot = ITEM_SLOT_RPOCKET

/datum/outfit/job/cmo/hardsuit
	name = "Chief Medical Officer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath/medical
	suit = /obj/item/clothing/suit/space/hardsuit/medical
	suit_store = /obj/item/tank/internals/oxygen
	r_pocket = /obj/item/flashlight/pen/paramedic

