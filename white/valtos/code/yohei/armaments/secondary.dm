/datum/armament_entry/yohei/secondary
	category = YOHEI_CATEGORY_SECONDARY
	category_item_limit = 4
	cost = 5
	mags_to_spawn = 2

/datum/armament_entry/yohei/secondary/pistol
	subcategory = YOHEI_SUBCATEGORY_PISTOL

/datum/armament_entry/yohei/secondary/pistol/m1911
	item_type = /obj/item/gun/ballistic/automatic/pistol/m1911
	max_purchase = 4

/datum/armament_entry/yohei/secondary/pistol/glock
	item_type = /obj/item/gun/ballistic/automatic/pistol/tanner
	max_purchase = 4
	mags_to_spawn = 3

/datum/armament_entry/yohei/secondary/pistol/revolver
	item_type = /obj/item/gun/ballistic/revolver/detective
	max_purchase = 4
	cost = 4
	mags_to_spawn = 0
	magazine = /obj/item/storage/box/ammo_box/revolver
	magazine_cost = 4

/datum/armament_entry/yohei/secondary/pistol/yohei9mm
	item_type = /obj/item/gun/ballistic/automatic/pistol/fallout/yohei9mm
	max_purchase = 1
	cost = 7
