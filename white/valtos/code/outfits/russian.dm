/datum/outfit/job/security/omon
	name = "Russian Officer"
	jobtype = /datum/job/security_officer/omon

	belt = /obj/item/gun/ballistic/automatic/pistol/traumatic
	mask = /obj/item/clothing/mask/gas/heavy/gp7vm
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/omon/green
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/pda/security
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cheap=1,\
							/obj/item/ammo_box/magazine/traumatic=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield)

	id_trim = /datum/id_trim/job/omon

	chameleon_extras = list(/obj/item/gun/ballistic/automatic/pistol/traumatic, \
							/obj/item/clothing/glasses/hud/security/sunglasses, \
							/obj/item/clothing/head/helmet)

/datum/outfit/job/security/omon/pre_equip()
	return

/datum/outfit/job/security/veteran
	name = "Veteran"
	jobtype = /datum/job/security_officer/veteran

	mask = /obj/item/clothing/mask/gas/heavy/gp7vm
	belt = /obj/item/gun/ballistic/automatic/pistol/makarov
	ears = /obj/item/radio/headset/headset_sec/alt/department/engi
	uniform = /obj/item/clothing/under/rank/security/veteran
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/pirate/captain/veteran
	suit = /obj/item/clothing/suit/security/officer/veteran
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/pda/security
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1,\
							/obj/item/ammo_box/magazine/m9mm=2,\
							/obj/item/clothing/accessory/medal/veteran = 1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield,\
					/obj/item/implant/krav_maga)

	id_trim = /datum/id_trim/job/veteran

	chameleon_extras = list(/obj/item/gun/ballistic/automatic/pistol/tanner,\
							/obj/item/clothing/glasses/hud/security/sunglasses,\
							/obj/item/clothing/head/helmet)

/datum/outfit/job/security/veteran/pre_equip()
	return
