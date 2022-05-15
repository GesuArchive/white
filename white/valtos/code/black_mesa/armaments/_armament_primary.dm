/datum/armament_entry/hecu/primary
	category = ARMAMENT_CATEGORY_PRIMARY
	category_item_limit = 4
	slot_to_equip = ITEM_SLOT_SUITSTORE
	cost = 10

/datum/armament_entry/hecu/primary/submachinegun
	subcategory = ARMAMENT_SUBCATEGORY_SUBMACHINEGUN
	mags_to_spawn = 4

/datum/armament_entry/hecu/primary/submachinegun/smg9mm
	item_type = /obj/item/gun/ballistic/automatic/fallout/smg9mm
	max_purchase = 4
	cost = 7

/datum/armament_entry/hecu/primary/submachinegun/mp5
	item_type = /obj/item/gun/ballistic/automatic/mp5
	max_purchase = 2
	cost = 10

/datum/armament_entry/hecu/primary/assaultrifle
	subcategory = ARMAMENT_SUBCATEGORY_ASSAULTRIFLE
	mags_to_spawn = 3

/datum/armament_entry/hecu/primary/assaultrifle/ak47
	item_type = /obj/item/gun/ballistic/automatic/ak47
	max_purchase = 1
	cost = 14
	magazine = /obj/item/ammo_box/magazine/ak47mag

/datum/armament_entry/hecu/primary/shotgun
	subcategory = ARMAMENT_SUBCATEGORY_SHOTGUN
	mags_to_spawn = 1

/datum/armament_entry/hecu/primary/shotgun/shotgun_highcap
	item_type = /obj/item/gun/ballistic/shotgun/lethal
	max_purchase = 2
	cost = 5
	magazine = /obj/item/storage/box/ammo_box/shotgun_12g
	magazine_cost = 4

/datum/armament_entry/hecu/primary/shotgun/autoshotgun_pump
	item_type = /obj/item/gun/ballistic/shotgun/automatic/combat
	max_purchase = 1
	cost = 7
	magazine = /obj/item/storage/box/ammo_box/shotgun_12g
	magazine_cost = 4

/datum/armament_entry/hecu/primary/special
	subcategory = ARMAMENT_SUBCATEGORY_SPECIAL
	mags_to_spawn = 2

/datum/armament_entry/hecu/primary/special/sniper_rifle
	item_type = /obj/item/gun/ballistic/automatic/sniper_rifle
	max_purchase = 1
	cost = 16

/datum/armament_entry/hecu/primary/special/hmg
	item_type = /obj/item/deployable_turret_folded
	max_purchase = 1
	cost = 20
	mags_to_spawn = 1
	magazine_cost = 2

/obj/item/storage/box/ammo_box/shotgun_12g

/obj/item/storage/box/ammo_box/shotgun_12g/PopulateContents()
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)
