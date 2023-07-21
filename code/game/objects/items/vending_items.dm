/*
	Vending machine refills can be found at /code/modules/vending/ within each vending machine's respective file
*/
/obj/item/vending_refill
	name = "картридж торгмата"
	var/machine_name = "Generic"

	icon = 'icons/obj/vending_restock.dmi'
	icon_state = "refill_snack"
	inhand_icon_state = "restock_unit"
	desc = "Заменяемый картридж торгового автомата с припасами"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 7
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 30)

	// Built automatically from the corresponding vending machine.
	// If null, considered to be full. Otherwise, is list(/typepath = amount).
	var/list/products
	var/list/product_categories
	var/list/contraband
	var/list/premium

/obj/item/vending_refill/Initialize(mapload)
	. = ..()
	name = "картридж торгмата \"[machine_name]\""

/obj/item/vending_refill/examine(mob/user)
	. = ..()
	var/num = get_part_rating()
	. += "<hr>"
	if (num == INFINITY)
		. += "Он плотно запечатан, полностью набит припасами."
	else if (num == 0)
		. += "Он пуст!"
	else
		. += "В нем еще около [num] предметов."

/obj/item/vending_refill/get_part_rating()
	if (!products || !product_categories || !contraband || !premium)
		return INFINITY
	. = 0
	for(var/key in products)
		. += products[key]
	for(var/key in contraband)
		. += contraband[key]
	for(var/key in premium)
		. += premium[key]

	for (var/list/category as anything in product_categories)
		var/list/products = category["products"]
		for (var/product_key in products)
			. += products[product_key]

	return .
