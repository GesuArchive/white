/datum/blackmarket_item/consumable
	category = "Расходники"

/datum/blackmarket_item/consumable/donk_pocket_box
	name = "Коробка Донк-Покетов"
	desc = "Хорошо упакованная коробка с самой любимой закуской любого космонавтика"
	item = /obj/item/storage/box/donkpockets

	stock_min = 1
	stock_max = 10
	price_min = 100
	price_max = 500
	availability_prob = 100

	/datum/blackmarket_item/consumable/donk_pocket_box/spawn_item(loc)
		var/donkpockets = pick(list(/obj/item/storage/box/donkpockets,
				/obj/item/storage/box/donkpockets/donkpocketspicy,
				/obj/item/storage/box/donkpockets/donkpocketteriyaki,
				/obj/item/storage/box/donkpockets/donkpocketpizza,
				/obj/item/storage/box/donkpockets/donkpocketgondola, //Превращает в гондолу
				/obj/item/storage/box/donkpockets/donkpocketberry,
				/obj/item/storage/box/donkpockets/donkpockethonk))
		return new donkpockets(loc)

/datum/blackmarket_item/consumable/suspicious_pills
	name = "Баночка подозрительных таблеток"
	desc = "Содержит случайную баночку с определённым типом таблеток. "
	item = /obj/item/storage/pill_bottle

	stock_min = 1
	stock_max = 20
	price_min = 400
	price_max = 700
	availability_prob = 100

/datum/blackmarket_item/consumable/suspicious_pills/spawn_item(loc)
	var/pillbottle = pick(list(/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/storage/pill_bottle/cyanide,
				/obj/item/storage/pill_bottle/crank,
				/obj/item/storage/pill_bottle/bath_salts,
				/obj/item/storage/pill_bottle/lsd,
				/obj/item/storage/pill_bottle/aranesp,
				/obj/item/storage/pill_bottle/krokodil,
				/obj/item/storage/pill_bottle/happiness,
				/obj/item/storage/pill_bottle/modafinil,
				/obj/item/storage/pill_bottle/methamphetamine,
				/obj/item/storage/pill_bottle/floorpill/full,
				/obj/item/storage/pill_bottle/psicodine,
				/obj/item/storage/pill_bottle/C2/probital,
				/obj/item/storage/pill_bottle/stimulant))
	return new pillbottle(loc)

/datum/blackmarket_item/consumable/floor_pill
	name = "Страннная таблетка"
	desc = "Таблетка с технических тоннелей"
	item = /obj/item/reagent_containers/pill/floorpill

	stock_min = 1
	stock_max = 100
	price_min = 10
	price_max = 60
	availability_prob = 100

/datum/blackmarket_item/consumable/pumpup
	name = "Технический заряд адреналина"
	desc = "Заряд адреналина найденный в техах. Помогает пережить пару ударов дубинки"
	item = /obj/item/reagent_containers/hypospray/medipen/pumpup

	stock_min = 1
	stock_max = 10
	price_min = 100
	price_max = 500
	availability_prob = 100

/datum/blackmarket_item/consumable/labebium
	name = "Бутылочка правды"
	desc = "Заставит поглотившего это познать правду."
	item = /obj/item/storage/pill_bottle/labebium

	stock_min = 1
	stock_max = 5
	price_min = 250
	price_max = 550
	availability_prob = 30
