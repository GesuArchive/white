/datum/blackmarket_item/stc
	markets = list(/datum/blackmarket_market/syndiemarket)
	category = "ТС"

/datum/blackmarket_item/stc/tc1
	name = "1 TC"
	desc = "Информация Удалена"
	item = /obj/item/stack/telecrystal

	price_min = BLACKMARKET_CRATE_VALUE * 25000
	price_max = BLACKMARKET_CRATE_VALUE * 50000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/stc/tc5
	name = "5 TC"
	desc = "Информация Удалена"
	item = /obj/item/stack/telecrystal/five

	price_min = BLACKMARKET_CRATE_VALUE * 125000
	price_max = BLACKMARKET_CRATE_VALUE * 250000
	stock_min = 1
	stock_max = 4
	availability_prob = 100

/datum/blackmarket_item/stc/tc20
	name = "20 TC"
	desc = "Информация Удалена"
	item = /obj/item/stack/telecrystal/twenty

	price_min = BLACKMARKET_CRATE_VALUE * 500000
	price_max = BLACKMARKET_CRATE_VALUE * 1000000
	stock_min = 1
	stock_max = 2
	availability_prob = 100
