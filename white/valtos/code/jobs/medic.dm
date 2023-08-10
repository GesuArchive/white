/datum/job/doctor/field_medic
	title = JOB_FIELD_MEDIC
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY

	outfit = /datum/outfit/job/field_medic

	skills = list(/datum/skill/surgery = SKILL_EXP_EXPERT)
	minimal_skills = list(/datum/skill/surgery = SKILL_EXP_EXPERT)

	paycheck = PAYCHECK_HARD
	metalocked = TRUE

/datum/id_trim/job/field_medic
	assignment = JOB_FIELD_MEDIC
	trim_state = "trim_fieldmedic"
	full_access = list(ACCESS_BRIG_MED, ACCESS_FORENSICS_LOCKERS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_WEAPONS)
	minimal_access = list(ACCESS_BRIG_MED, ACCESS_FORENSICS_LOCKERS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY, ACCESS_WEAPONS)
	config_job = "field_medic"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CMO, ACCESS_CHANGE_IDS)

/datum/outfit/job/field_medic
	name = "Полевой медик"
	jobtype = /datum/job/doctor/field_medic

	head = /obj/item/clothing/head/helmet/field_med/beret
	belt = /obj/item/defibrillator/compact/fieldmed/loaded
	ears = /obj/item/radio/headset/headset_medsec/alt
	uniform = /obj/item/clothing/under/rank/medical/brigphys
	gloves = /obj/item/clothing/gloves/color/latex/nitrile/polymer
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/fieldmedic
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(/obj/item/storage/firstaid/medical/field_surgery = 1, /obj/item/optable = 1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	pda_slot = ITEM_SLOT_LPOCKET

	r_pocket = /obj/item/storage/belt/medipenal/field_med
	l_pocket = /obj/item/modular_computer/tablet/pda/field_medic

	implants = list(/obj/item/implant/mindshield)

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/job/medic/super)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/field_medic

/datum/outfit/job/field_medic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	hud.show_to(H)
	ADD_TRAIT(H, TRAIT_MEDICAL_HUD, ORGAN_TRAIT)
