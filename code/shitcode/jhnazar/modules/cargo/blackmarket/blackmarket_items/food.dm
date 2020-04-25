/datum/blackmarket_item/food
	category = "Еда"

/datum/blackmarket_item/food/donk_pocket_box
	name = "Коробка Донк-Покетов"
	desc = "Хорошо упакованная коробка с самой любимой закуской любого космонавтика"
	item = /obj/item/storage/box/donkpockets

	stock_min = 1
	stock_max = 10
	price_min = 100
	price_max = 500
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
