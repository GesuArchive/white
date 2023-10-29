
/datum/armament_entry/hecu/bodyarmor
	category = "коробка с комплектом брони"
	category_item_limit = 4

/datum/armament_entry/hecu/bodyarmor/normal
	name = "стандартный комплект брони"
	description = "Содержит набор из двух основных элементов брони, предназначенных для умеренной защиты вашего тела от всего."
	item_type = /obj/item/storage/box/armor_set/normal
	max_purchase = 4
	cost = 6

/datum/armament_entry/hecu/bodyarmor/bulletproof
	name = "комплект пулестойкой брони"
	description = "Содержит набор из двух пуленепробиваемых элементов брони, предназначенных для надежной защиты вашего тела от пуль и взрывов."
	item_type = /obj/item/storage/box/armor_set/bulletproof
	max_purchase = 4
	cost = 10

/datum/armament_entry/hecu/bodyarmor/pcv
	name = "комплект ЭБЖ"
	description = "Содержит набор из двух частей брони для защиты от опасных условий окружающей среды. Эта броня обеспечит надежную защиту, а также регенерацию."
	item_type = /obj/item/storage/box/armor_set/pcv
	max_purchase = 4
	cost = 20

/obj/item/storage/box/armor_set
	name = "комплект брони"
	desc = "Коробка с бронёй. Ого."
	icon_state = "box"
	illustration = null

/obj/item/storage/box/armor_set/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/clothing/suit/armor,/obj/item/clothing/suit/space/hev_suit/pcv,/obj/item/clothing/head/helmet))
	atom_storage.max_slots = 2

/obj/item/storage/box/armor_set/normal
	name = "стандартный комплект брони"
	desc = "Содержит шлем и жилет."

/obj/item/storage/box/armor_set/normal/PopulateContents()
	new /obj/item/clothing/suit/armor/vest/hecu(src)
	new /obj/item/clothing/head/helmet/hecu(src)

/obj/item/storage/box/armor_set/bulletproof
	name = "пуленепробиваемый комплект брони"
	desc = "Содержит бронежилет и шлем."

/obj/item/storage/box/armor_set/bulletproof/PopulateContents()
	new /obj/item/clothing/suit/armor/bulletproof/hecu(src)
	new /obj/item/clothing/head/helmet/alt/hecu(src)

/obj/item/storage/box/armor_set/pcv
	name = "комплект ЭБЖ марк II"
	desc = "Содержит комплект ЭБЖ марк II"

/obj/item/storage/box/armor_set/pcv/PopulateContents()
	new /obj/item/clothing/suit/space/hev_suit/pcv(src)
	new /obj/item/clothing/head/helmet/space/hev_suit/pcv(src)
