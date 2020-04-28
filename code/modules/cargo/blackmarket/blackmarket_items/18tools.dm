/datum/blackmarket_item/tool
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Инструменты"

/datum/blackmarket_item/tool/caravan_wrench
	name = "Экспериментальный гаечный ключ"
	desc = "Очень быстрый и удобный гаечный ключ"
	item = /obj/item/wrench/caravan
	stock = 1

	price_min = 400
	price_max = 800
	availability_prob = 20

/datum/blackmarket_item/tool/caravan_wirecutters
	name = "Экспериментальные кусачки"
	desc = "Очень быстрые и удобные кусачки"
	item = /obj/item/wirecutters/caravan
	stock = 1

	price_min = 400
	price_max = 800
	availability_prob = 20

/datum/blackmarket_item/tool/caravan_screwdriver
	name = "Экспериментальная отвёртка"
	desc = "Очень быстрая и удобная отвёртка"
	item = /obj/item/screwdriver/caravan
	stock = 1

	price_min = 400
	price_max = 800
	availability_prob = 20

/datum/blackmarket_item/tool/caravan_crowbar
	name = "Экспериментальный ломик"
	desc = "Очень быстрый и удобный ломик"
	item = /obj/item/crowbar/red/caravan
	stock = 1

	price_min = 400
	price_max = 800
	availability_prob = 20

/datum/blackmarket_item/tool/binoculars
	name = "Бинокли"
	desc = "С помощью биноклей можно видеть дальше чем может видеть обычный глаз человека"
	item = /obj/item/binoculars
	stock = 1

	price_min = 400
	price_max = 960
	availability_prob = 30

/datum/blackmarket_item/tool/riot_shield
	name = "Щит спецназа"
	desc = "Для защиты от бунта"
	item = /obj/item/shield/riot

	price_min = 450
	price_max = 650
	stock_max = 2
	availability_prob = 50

/datum/blackmarket_item/tool/thermite_bottle
	name = "Бцтылочка с термитом"
	desc = "Дыроёб"
	item = /obj/item/reagent_containers/glass/bottle/thermite

	price_min = 500
	price_max = 1500
	stock_max = 3
	availability_prob = 30
