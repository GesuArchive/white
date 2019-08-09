/obj/machinery/vending/terminal
	name = "Trading Terminal MK1"
	desc = "Вещи возврату не подлежат."
	icon = 'code/shitcode/valtos/trading/vending.dmi'
	icon_state = "trading"
	product_ads = "Лучшее только у нас!;Купи-купи-купи!"
	default_price = 500
	extra_price = 5000
	max_integrity = 300000
	var/last_rebuild = 0
	payment_department = NO_FREEBIES

/obj/machinery/vending/terminal/Initialize(mapload)
	. = ..()
	last_rebuild = world.time + rand(600, 900)
	rebuild_inventory(GLOB.terminal_products, product_records)

/obj/machinery/vending/terminal/proc/rebuild_inventory(list/productlist, list/recordlist)
	product_records = list()
	for(var/typepath in productlist)
		if (prob(23))
			var/amount = rand(1, 30)
			var/atom/temp = typepath
			var/datum/data/vending_product/R = new /datum/data/vending_product()
			GLOB.vending_products[typepath] = 1
			R.name = initial(temp.name)
			R.product_path = typepath
			R.amount = amount
			R.max_amount = amount
			R.custom_price = rand(100, 10000) //best prices
			R.custom_premium_price = rand(100, 10000) //best prices
			recordlist += R

/obj/machinery/vending/terminal/process()
	. = ..()
	if(last_rebuild + 900 <= world.time && prob(99))
		last_rebuild = world.time
		speak("Новые продукты в наличии!")
		rebuild_inventory(GLOB.terminal_products, product_records)

/obj/machinery/vending/terminal/emag_act(mob/user)
	if(shock(user, 100))
		return

/obj/machinery/vending/terminal/attackby(obj/item/I, mob/user, params)
	if(shock(user, 100))
		return

/obj/machinery/vending/terminal/crowbar_act(mob/living/user, obj/item/I)
	if(shock(user, 100))
		return FALSE

/obj/machinery/vending/terminal/wrench_act(mob/living/user, obj/item/I)
	if(shock(user, 100))
		return FALSE

/obj/machinery/vending/terminal/screwdriver_act(mob/living/user, obj/item/I)
	if(shock(user, 100))
		return FALSE