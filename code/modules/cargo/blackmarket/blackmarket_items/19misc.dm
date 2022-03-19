/datum/blackmarket_item/misc
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Прочее"

/datum/blackmarket_item/misc/allresources
	name = "Шкаф со всеми ресурсами"
	desc = "Все возможные ресурсы только для вас!"
	item = /obj/structure/closet/syndicate/resources/everything

	price_min = BLACKMARKET_CRATE_VALUE * 5000
	price_max = BLACKMARKET_CRATE_VALUE * 20000
	stock_min = 3
	stock_max = 1
	availability_prob = 100

/datum/blackmarket_item/misc/holywater
	name = "Склянка священной воды"
	desc = "Собственная марка отца Лотия."
	item = /obj/item/reagent_containers/food/drinks/bottle/holywater

	price_min = BLACKMARKET_CRATE_VALUE * 40
	price_max = BLACKMARKET_CRATE_VALUE * 60
	stock_max = 3
	availability_prob = 40

/datum/blackmarket_item/misc/holywater/spawn_item(loc)
	if (prob(6.66))
		return new /obj/item/reagent_containers/glass/beaker/unholywater(loc)
	return ..()

/datum/blackmarket_item/misc/strange_seed
	name = "Странные семена"
	desc = "An Exotic Variety of seed that can contain anything from glow to acid."
	item = /obj/item/seeds/random

	price_min = BLACKMARKET_CRATE_VALUE * 10
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	stock_min = 1
	stock_max = 10
	availability_prob = 70

/datum/blackmarket_item/misc/smugglers_satchel
	name = "Ранец контрабандиста"
	desc = "Легко спрятать"
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = BLACKMARKET_CRATE_VALUE * 75
	price_max = BLACKMARKET_CRATE_VALUE * 100
	stock_max = 2
	availability_prob = 30

/datum/blackmarket_item/misc/amude
	name = "видеокарта"
	desc = "Случайная видеокарта со склада NTS."
	item = /obj/item/mining_thing/amd

	price_min = BLACKMARKET_CRATE_VALUE * 200
	price_max = BLACKMARKET_CRATE_VALUE * 300
	stock_max = 5
	availability_prob = 25

/datum/blackmarket_item/misc/amude/spawn_item(loc)
	var/obj/item/mining_thing/amd/A = pick(subtypesof(/obj/item/mining_thing/amd))
	return new A(loc)
