#define ARMAMENT_CATEGORY_UTILITY "Utility Supplies"
#define ARMAMENT_CATEGORY_UTILITY_LIMIT 8
#define ARMAMENT_SUBCATEGORY_UTILITY_ARMOR "Armor"

/datum/armament_entry/hecu/utility
	category = ARMAMENT_CATEGORY_UTILITY
	category_item_limit = 20

/datum/armament_entry/hecu/utility/survival_pack
	item_type = /obj/item/storage/box/nri_survival_pack
	max_purchase = 4
	cost = 3

/datum/armament_entry/hecu/utility/basic_tools
	item_type = /obj/item/storage/toolbox/mechanical
	max_purchase = 2
	cost = 1

/datum/armament_entry/hecu/utility/advanced_tools
	name = "Powertoolbelt"
	description = "Tool belt full of power-ful tools."
	item_type = /obj/item/storage/belt/utility/full/engi
	max_purchase = 1
	cost = 4

/datum/armament_entry/hecu/utility/light_device
	item_type = /obj/item/construction/rld/mini
	max_purchase = 2
	cost = 3

/datum/armament_entry/hecu/utility/compact_shield
	item_type = /obj/item/shield/riot/tele
	max_purchase = 1
	cost = 5

/datum/armament_entry/hecu/utility/flash_shield
	item_type = /obj/item/shield/riot/flash
	max_purchase = 1
	cost = 10

/datum/armament_entry/hecu/utility/combat_shield
	item_type = /obj/item/shield/riot/kevlar
	max_purchase = 1
	cost = 20

/datum/armament_entry/hecu/utility/zipties
	item_type = /obj/item/storage/box/zipties
	max_purchase = 2
	cost = 1

/datum/armament_entry/hecu/utility/jammer
	name = "Radio Jammer"
	description = "When activated, this cell powered device will block all outgoing radio communication."
	item_type = /obj/item/jammer
	max_purchase = 1
	cost = 4

/datum/armament_entry/hecu/utility/suppressor
	item_type = /obj/item/suppressor
	max_purchase = 4
	cost = 2
