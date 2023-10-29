/datum/armament_entry/yohei/primary
	category = YOHEI_CATEGORY_PRIMARY
	category_item_limit = 4
	slot_to_equip = ITEM_SLOT_SUITSTORE
	cost = 10

/datum/armament_entry/yohei/primary/submachinegun
	subcategory = YOHEI_SUBCATEGORY_SUBMACHINEGUN
	mags_to_spawn = 4

/datum/armament_entry/yohei/primary/submachinegun/mp5
	item_type = /obj/item/gun/ballistic/automatic/mp5
	max_purchase = 2
	cost = 20

/datum/armament_entry/yohei/primary/assaultrifle
	subcategory = YOHEI_SUBCATEGORY_ASSAULTRIFLE
	mags_to_spawn = 3

/datum/armament_entry/yohei/primary/assaultrifle/infiltrator
	item_type = /obj/item/gun/ballistic/automatic/fallout/assaultrifle/infiltrator
	max_purchase = 1
	cost = 25
	magazine = /obj/item/ammo_box/magazine/fallout/r20

/datum/armament_entry/yohei/primary/shotgun
	subcategory = YOHEI_SUBCATEGORY_SHOTGUN
	mags_to_spawn = 1

/datum/armament_entry/yohei/primary/shotgun/shotgun_highcap
	item_type = /obj/item/gun/ballistic/shotgun/lethal
	max_purchase = 2
	cost = 12
	magazine = /obj/item/storage/box/ammo_box/shotgun_12g
	magazine_cost = 4

/datum/armament_entry/yohei/primary/shotgun/autoshotgun_pump
	item_type = /obj/item/gun/ballistic/shotgun/automatic/combat
	max_purchase = 1
	cost = 17
	magazine = /obj/item/storage/box/ammo_box/shotgun_12g
	magazine_cost = 4

/datum/armament_entry/yohei/primary/special
	subcategory = YOHEI_SUBCATEGORY_SPECIAL
	mags_to_spawn = 2

/datum/armament_entry/yohei/primary/special/sniper_rifle
	item_type = /obj/item/gun/ballistic/automatic/sniper_rifle
	max_purchase = 1
	cost = 30

/datum/armament_entry/yohei/primary/special/hmg
	item_type = /obj/item/deployable_turret_folded
	max_purchase = 1
	cost = 10
	mags_to_spawn = 1
	magazine_cost = 2

/datum/armament_entry/yohei/primary/special/crossbow
	item_type = /obj/item/gun/ballistic/crossbow/energy
	cost = 14
	magazine = /obj/item/stack/rods/twentyfive
	mags_to_spawn = 1
