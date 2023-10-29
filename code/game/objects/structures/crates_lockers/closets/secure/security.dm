/obj/structure/closet/secure_closet/captains
	name = "капитанский шкаф"
	req_access = list(ACCESS_CAPTAIN)
	icon_state = "cap"
	anchored = 1
	anchorable = 0
	anchored = TRUE

/obj/structure/closet/secure_closet/captains/PopulateContents()
	..()
	new /obj/item/storage/bag/garment/captain(src)
	new /obj/item/storage/backpack/captain(src)
	new /obj/item/storage/backpack/satchel/cap(src)
	new /obj/item/storage/backpack/duffelbag/captain(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/computer_disk/command/captain(src)
	new /obj/item/storage/box/silver_ids(src)
	new /obj/item/radio/headset/heads/captain/alt(src)
	new /obj/item/radio/headset/heads/captain(src)
	new /obj/item/storage/belt/sabre(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/door_remote/captain(src)
	new /obj/item/storage/photo_album/captain(src)

/obj/structure/closet/secure_closet/hop
	name = "шкаф главы персонала"
	req_access = list(ACCESS_HOP)
	icon_state = "hop"
	anchored = TRUE

/obj/structure/closet/secure_closet/hop/PopulateContents()
	..()
	new /obj/item/storage/bag/garment/hop(src)
	new /obj/item/key/forklift/service(src)
	new /obj/item/storage/lockbox/medal/service(src)
	new /obj/item/computer_disk/command/hop(src)
	new /obj/item/radio/headset/heads/hop(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/door_remote/civilian(src)
	new /obj/item/circuitboard/machine/mechfab/service(src)
	new /obj/item/storage/photo_album/hop(src)
	new /obj/item/storage/lockbox/medal/hop(src)
	new /obj/item/storage/backpack/duffelbag/mining_conscript(src)


/obj/structure/closet/secure_closet/hos
	name = "шкаф начальника охраны"
	req_access = list(ACCESS_HOS)
	icon_state = "hos"
	anchored = TRUE

/obj/structure/closet/secure_closet/hos/PopulateContents()
	..()
	new /obj/item/storage/bag/garment/hos(src)
	new /obj/item/key/forklift/security(src)
	new /obj/item/computer_disk/command/hos(src)
	new /obj/item/radio/headset/heads/hos(src)
	new /obj/item/storage/lockbox/medal/sec(src)
	new /obj/item/megaphone/sec(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/storage/lockbox/loyalty(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/circuitboard/machine/mechfab/sb(src)
	new /obj/item/storage/photo_album/hos(src)
	new /obj/item/inspector(src)
	new /obj/item/storage/box/firingpins/paywall(src)

/obj/structure/closet/secure_closet/hos/populate_contents_immediate()
	. = ..()

	// Traitor steal objectives
	new /obj/item/gun/energy/e_gun/hos(src)
	new /obj/item/pinpointer/nuke(src)

/obj/structure/closet/secure_closet/warden
	name = "шкаф надзирателя"
	req_access = list(ACCESS_ARMORY)
	icon_state = "warden"
	anchored = TRUE

/obj/structure/closet/secure_closet/warden/PopulateContents()
	..()
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	new /obj/item/clothing/head/warden(src)
	new /obj/item/clothing/head/warden/drill(src)
	new /obj/item/clothing/head/beret/sec/navywarden(src)
	new /obj/item/clothing/suit/armor/vest/warden/alt(src)
	new /obj/item/clothing/under/rank/security/warden/formal(src)
	new /obj/item/clothing/under/rank/security/warden/skirt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/storage/box/zipties(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/gloves/krav_maga/sec(src)
	new /obj/item/door_remote/head_of_security(src)
	new /obj/item/storage/box/firingpins/paywall(src)
	new /obj/item/gun/grenadelauncher(src)

/obj/structure/closet/secure_closet/security
	name = "шкаф офицера"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec"

/obj/structure/closet/secure_closet/security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)

/obj/structure/closet/secure_closet/security/sec

/obj/structure/closet/secure_closet/security/sec/PopulateContents()
	..()
	new /obj/item/storage/belt/security/full(src)

/obj/structure/closet/secure_closet/security/cargo

/obj/structure/closet/secure_closet/security/cargo/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/cargo(src)
	new /obj/item/encryptionkey/headset_cargo(src)

/obj/structure/closet/secure_closet/security/engine

/obj/structure/closet/secure_closet/security/engine/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/engine(src)
	new /obj/item/encryptionkey/headset_eng(src)

/obj/structure/closet/secure_closet/security/science

/obj/structure/closet/secure_closet/security/science/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/science(src)
	new /obj/item/encryptionkey/headset_sci(src)

/obj/structure/closet/secure_closet/security/med

/obj/structure/closet/secure_closet/security/med/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/medblue(src)
	new /obj/item/encryptionkey/headset_med(src)

/obj/structure/closet/secure_closet/detective
	name = "шкаф детектива"
	req_access = list(ACCESS_FORENSICS_LOCKERS)
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	door_anim_time = 0 // no animation
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'

/obj/structure/closet/secure_closet/detective/PopulateContents()
	..()
	new /obj/item/storage/box/evidence(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/detective_scanner(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/clothing/suit/armor/vest/det_suit(src)
	new /obj/item/storage/belt/holster/detective/full(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/binoculars(src)
	new /obj/item/storage/box/rxglasses/spyglasskit(src)
	new /obj/item/inspector(src)

/obj/structure/closet/secure_closet/injection
	name = "летальные инъекции"
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/injection/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/syringe/lethal/execution(src)

/obj/structure/closet/secure_closet/brig
	name = "шкаф брига"
	req_access = list(ACCESS_BRIG)
	anchored = TRUE
	var/id = null

/obj/structure/closet/secure_closet/evidence
	anchored = TRUE
	name = "шкаф с вещдоками"
	req_access_txt = "0"
	req_one_access_txt = list(ACCESS_ARMORY, ACCESS_FORENSICS_LOCKERS)

/obj/structure/closet/secure_closet/brig/PopulateContents()
	..()
	new /obj/item/clothing/under/rank/prisoner( src )
	new /obj/item/clothing/under/rank/prisoner/skirt( src )
	new /obj/item/clothing/shoes/sneakers/orange( src )

/obj/structure/closet/secure_closet/courtroom
	name = "шкаф суда"
	req_access = list(ACCESS_COURT)

/obj/structure/closet/secure_closet/courtroom/PopulateContents()
	..()
	new /obj/item/clothing/shoes/sneakers/brown(src)
	for(var/i in 1 to 3)
		new /obj/item/paper/fluff/jobs/security/court_judgement (src)
	new /obj/item/pen (src)
	new /obj/item/clothing/suit/judgerobe (src)
	new /obj/item/clothing/head/powdered_wig (src)
	new /obj/item/storage/briefcase(src)

/obj/structure/closet/secure_closet/contraband/armory
	anchored = TRUE
	name = "шкаф для контрабанды"
	req_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/contraband/heads
	anchored = TRUE
	name = "шкаф для контрабанды"
	req_access = list(ACCESS_HEADS)

/obj/structure/closet/secure_closet/armory1
	name = "оружейный шкаф"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"

/obj/structure/closet/secure_closet/armory1/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/shield/riot(src)

/obj/structure/closet/secure_closet/armory1/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/clothing/suit/hooded/ablative(src)

/obj/structure/closet/secure_closet/armory2
	name = "шкаф с огнестрелом"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"

/obj/structure/closet/secure_closet/armory2/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/rubbershot(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/ballistic/shotgun/riot(src)

/obj/structure/closet/secure_closet/armory3
	name = "шкаф с лазерами"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"

/obj/structure/closet/secure_closet/armory3/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	new /obj/item/gun/energy/ionrifle(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/e_gun(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/thermal(src)

/obj/structure/closet/secure_closet/tac
	name = "тактический шкаф"
	desc = "Прячется..."
	req_access = list(ACCESS_ARMORY)
	icon_state = "tac"

/obj/structure/closet/secure_closet/tac/PopulateContents()
	..()
	new /obj/item/storage/belt/holster/thermal(src)
	new /obj/item/clothing/head/helmet/alt(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)

/obj/structure/closet/secure_closet/labor_camp_security
	name = "шкаф трудового лагеря"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec"

/obj/structure/closet/secure_closet/labor_camp_security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/clothing/under/rank/security/officer(src)
	new /obj/item/clothing/under/rank/security/officer/skirt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
