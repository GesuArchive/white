/datum/blackmarket_item/food
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Еда"

/datum/blackmarket_item/food/donk_pocket_box
	name = "Коробка Донк-Покетов"
	desc = "Хорошо упакованная коробка с самой любимой закуской любого космонавтика"
	item = /obj/item/storage/box/donkpockets

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 10
	price_max = BLACKMARKET_CRATE_VALUE * 50
	availability_prob = 100

/datum/blackmarket_item/food/donk_pocket_box/spawn_item(loc)
	var/donkpockets = pick(list(/obj/item/storage/box/donkpockets,
			/obj/item/storage/box/donkpockets/donkpocketspicy,
			/obj/item/storage/box/donkpockets/donkpocketteriyaki,
			/obj/item/storage/box/donkpockets/donkpocketpizza,
			/obj/item/storage/box/donkpockets/donkpocketgondola, //Превращает в гондолу
			/obj/item/storage/box/donkpockets/donkpocketberry,
			/obj/item/storage/box/donkpockets/donkpockethonk))
	return new donkpockets(loc)

/datum/blackmarket_item/food/donut
	name = "Коробка с пончиками"
	desc = "Пахнет вкусно!"
	item = /obj/item/storage/fancy/donut_box

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 10
	price_max = BLACKMARKET_CRATE_VALUE * 50
	availability_prob = 100

/datum/blackmarket_item/food/pizza
	name = "Пицца"
	desc =  "Что может быть вкуснее кусочка пиццы?"
	item = /obj/item/food/pizza

	stock_min = 1
	stock_max = 20
	price_min = BLACKMARKET_CRATE_VALUE * 50
	price_max = BLACKMARKET_CRATE_VALUE * 300
	availability_prob = 100

/datum/blackmarket_item/food/pizza/spawn_item(loc)
	var/pizza = pick(list(/obj/item/food/pizza/margherita,
			/obj/item/food/pizza/meat,
			/obj/item/food/pizza/mushroom,
			/obj/item/food/pizza/vegetable,
			/obj/item/food/pizza/donkpocket,
			/obj/item/food/pizza/dank,
			/obj/item/food/pizza/sassysage,
			/obj/item/food/pizza/pineapple,
			/obj/item/food/pizza/arnold))
	return new pizza(loc)

/datum/blackmarket_item/food/snack
	name = "Закуска"
	desc = "Жрака"
	item = /obj/item/food/candy

	stock_min = 10
	stock_max = 50
	price_min = BLACKMARKET_CRATE_VALUE * 10
	price_max = BLACKMARKET_CRATE_VALUE * 50
	availability_prob = 100

/datum/blackmarket_item/food/snack/spawn_item(loc)
	var/snack = pick(list(/obj/item/food/candy/bronx,
			/obj/item/food/sosjerky,
			/obj/item/food/chips,
			/obj/item/food/no_raisin,
			/obj/item/food/no_raisin/healthy,
			/obj/item/food/spacetwinkie,
			/obj/item/food/syndicake,
			/obj/item/food/energybar))
	return new snack(loc)
