/datum/job/doctor/field_medic
	title = "Field Medic"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/field_medic

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)

	paycheck = PAYCHECK_HARD
	metalocked = TRUE

/datum/outfit/job/field_medic
	name = "Полевой медик"
	jobtype = /datum/job/doctor/field_medic

	head = /obj/item/clothing/head/helmet/wzzzz/helmet_tac/helmet_allya1
	belt = /obj/item/defibrillator/compact/combat/loaded/nanotrasen
	ears = /obj/item/radio/headset/headset_medsec
	uniform = /obj/item/clothing/under/rank/medical/doctor/wzzzz/brig_phys
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/wzzzz/german/webvest/m_vest
	l_hand = /obj/item/storage/backpack/duffelbag/med/surgery
	backpack_contents = list(/obj/item/storage/box/trackimp = 1, /obj/item/storage/firstaid/medical = 1, /obj/item/optable = 1, /obj/item/modular_computer/tablet/preset/cheap = 1, /obj/item/flashlight = 1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	r_pocket = /obj/item/storage/pill_bottle/wzzzz/soldier
	l_pocket = /obj/item/pda/medical

	skillchips = list(/obj/item/skillchip/entrails_reader)

	chameleon_extras = /obj/item/gun/syringe
