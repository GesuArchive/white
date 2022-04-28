/datum/job/doctor/field_medic
	title = "Field Medic"
	ru_title = "Полевой Врач"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 1200
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/field_medic

	paycheck = PAYCHECK_HARD
	metalocked = TRUE

/datum/id_trim/job/field_medic
	assignment = "Field Medic"
	trim_state = "trim_fieldmedic"
	full_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_WEAPONS)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY, ACCESS_WEAPONS)
	config_job = "field_medic"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CMO, ACCESS_CHANGE_IDS)
	trim_icon = 'white/valtos/icons/card.dmi'

/datum/outfit/job/field_medic
	name = "Полевой медик"
	jobtype = /datum/job/doctor/field_medic

	head = /obj/item/clothing/head/helmet
	belt = /obj/item/defibrillator/compact/loaded
	ears = /obj/item/radio/headset/headset_medsec
	uniform = /obj/item/clothing/under/rank/medical/brigphys
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor
	l_hand = /obj/item/storage/backpack/duffelbag/med/surgery
	backpack_contents = list(/obj/item/storage/box/trackimp = 1, /obj/item/storage/firstaid/medical = 1, /obj/item/optable = 1, /obj/item/modular_computer/laptop/preset/medical = 1, /obj/item/storage/pill_bottle/soldier = 1, /obj/item/flashlight = 1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	r_pocket = /obj/item/storage/belt/medipenal/field_med
	l_pocket = /obj/item/modular_computer/tablet/pda/medical

	implants = list(/obj/item/implant/mindshield)

	skillchips = list(/obj/item/skillchip/entrails_reader)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/field_medic

/datum/outfit/job/field_medic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	hud.add_hud_to(H)
	ADD_TRAIT(H, TRAIT_MEDICAL_HUD, ORGAN_TRAIT)
