//obj/item/storage/belt



/obj/item/storage/belt/utility
	icon_state = "utility"
	inhand_icon_state = "utility"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security/holster
	name = "holster"
	desc = "One belt - one gun."
	icon_state = "holster"
	inhand_icon_state = "holster"

/obj/item/storage/belt/security/holster/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(/obj/item/gun/energy/pulse/pistol,/obj/item/gun/ballistic/revolver,/obj/item/gun/ballistic/automatic/pistol/toy,/obj/item/gun/ballistic/automatic/pistol))

/obj/item/storage/belt/medical
	icon_state = "medicalbelt"
	inhand_icon_state = "medicalbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/medical/ems
	icon_state = "emsbelta"
	inhand_icon_state = "emsbelta"

/obj/item/storage/belt/military
	icon_state = "emsbelt"
	inhand_icon_state = "emsbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/janitor
	icon_state = "janibelt"
	inhand_icon_state = "janibelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security
	icon_state = "gearbelt"
	inhand_icon_state = "gearbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security/forensic
	icon_state = "forensic"
	inhand_icon_state = "forensic"

/obj/item/storage/belt/security/forensic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 10

/obj/item/storage/belt/security/forensic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 7

/obj/item/storage/belt/hol
	name = "leather belt"
	desc = "Classic."
	icon_state = "belt_holster"
	inhand_icon_state = "belt_holster"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/hol/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_combined_w_class = 9

/obj/item/storage/belt/hol/sa
	name = "satchel belt"
	icon_state = "belt_satchel"
	desc = "Little satchel."
	inhand_icon_state = "belt_satchel"

/obj/item/storage/belt/hol/sa/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 7

/obj/item/storage/backpack
	max_integrity = 325
	obj_integrity = 325
	icon = 'white/Wzzzz/clothing/backpag.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/backpag.dmi'

/obj/item/storage/belt/military/vest
	name = "german black vest"
	desc = "Armor, storage, stilysh"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10,"energy" = 10, "bomb" = 25, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "vest_black"
	inhand_icon_state = "vest_black"

/obj/item/storage/belt/military/vest/brown
	name = "german brown vest"
	icon_state = "vest_brown"
	inhand_icon_state = "vest_brown"

/obj/item/storage/belt/military/vest/white
	name = "german white vest"
	icon_state = "vest_white"
	inhand_icon_state = "vest_white"

/obj/item/storage/belt/mining/large
	icon_state = "webbing_large"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	inhand_icon_state = "webbing_large"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/mining/large/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/resonator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/kitchen/knife,
		/obj/item/reagent_containers/hypospray,
		/obj/item/gps,
		/obj/item/storage/bag/ore,
		/obj/item/survivalcapsule,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/organ/regenerative_core,
		/obj/item/wormhole_jaunter,
		/obj/item/storage/bag/plants,
		/obj/item/stack/marker_beacon
		))

/obj/item/storage/belt/mining/alt
	icon_state = "webbing"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	inhand_icon_state = "webbing"

/obj/item/storage/belt/military/swat/alt
	name = "swat webbing"
	desc = "Portable storage."
	armor = list("melee" = 5, "bullet" = 0, "laser" = 5, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	icon_state = "swatbelt"
	inhand_icon_state = "swatbelt"

/obj/item/storage/belt/military/swat/alt/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 8

/obj/item/storage/belt/military/swat
	name = "swat belt"
	desc = "Belt for special forces."
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'
	icon_state = "swatbeltc"
	inhand_icon_state = "swatbeltc"

/obj/item/storage/belt/military/swat/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 6

/obj/item/storage/belt/machete
	name = "machete belt"
	desc = "Belt for machete."
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 5, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	icon_state = "machetebelt"
	inhand_icon_state = "machetebelt"

/obj/item/storage/belt/machete/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 4
	STR.set_holdable(list(/obj/item/kitchen/knife/butcher/machete))

/obj/item/storage/belt/military/vest

//obj/item/storage/belt/military/vest/PopulateContents()
//	new /obj/item/melee/classic_baton/telescopic(src)
//	new /obj/item/ammo_box/magazine/stg(src)
//	new /obj/item/ammo_box/magazine/stg(src)
//  new /obj/item/ammo_box/magazine/stg(src)
//	new /obj/item/ammo_box/magazine/stg(src)
//	new /obj/item/ammo_box/magazine/mauser/battle(src)
//	new /obj/item/ammo_box/magazine/mauser/battle(src)
