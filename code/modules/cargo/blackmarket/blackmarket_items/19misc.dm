/datum/blackmarket_item/misc
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Прочее"

/datum/blackmarket_item/misc/allresources
	name = "Шкаф со всеми ресурсами"
	desc = "Все возможные ресурсы только для вас!"

	price_min = 50000
	price_max = 200000
	stock_min = 3
	stock_max = 1
	availability_prob = 100

/datum/blackmarket_item/misc/holywater
	name = "Склянка священной воды"
	desc = "Собственная марка отца Лотия."
	item = /obj/item/reagent_containers/food/drinks/bottle/holywater

	price_min = 400
	price_max = 600
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

	price_min = 100
	price_max = 10000
	stock_min = 1
	stock_max = 10
	availability_prob = 70

/datum/blackmarket_item/misc/smugglers_satchel
	name = "Ранец контрабандиста"
	desc = "Легко спрятать"
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = 750
	price_max = 1000
	stock_max = 2
	availability_prob = 30

/datum/blackmarket_item/misc/emag
	name = "Криптографическая хуйня"
	desc = "Чё это блять?"
	item = /obj/item/card/emag 

	price_min = 10000
	price_max = 25000
	stock_min = 1
	stock_max = 2
	availability_prob = 50
