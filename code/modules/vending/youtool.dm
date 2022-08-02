/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Инструменты для инструментов."
	icon_state = "tool"
	icon_deny = "tool-deny"
	light_mask = "tool-light-mask"
	products = list(/obj/item/stack/cable_coil = 10,
					/obj/item/crowbar = 5,
					/obj/item/weldingtool = 3,
					/obj/item/wirecutters = 5,
					/obj/item/wrench = 5,
					/obj/item/analyzer = 5,
					/obj/item/t_scanner = 5,
					/obj/item/screwdriver = 5,
					/obj/item/flashlight/glowstick = 3,
					/obj/item/flashlight/glowstick/red = 3,
					/obj/item/flashlight = 5,
					/obj/item/clothing/ears/earmuffs = 1)
	contraband = list(/obj/item/clothing/gloves/color/fyellow = 2)
	premium = list(/obj/item/storage/belt/utility = 2,
					/obj/item/multitool = 2,
					/obj/item/weldingtool/hugetank = 2,
					/obj/item/clothing/head/welding = 2,
					/obj/item/clothing/gloves/color/yellow = 1)
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 70)
	resistance_flags = FIRE_PROOF
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_ENG

/obj/machinery/vending/tool/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)

/obj/item/vending_refill/tool
	machine_name = "YouTool"
	icon_state = "refill_costume"
