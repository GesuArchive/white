/datum/blackmarket_item/medicine
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Медицина"

/datum/blackmarket_item/medicine/firstaid
	name = "Аптечка первой помощи"
	desc = "Всё то что нужно для оказания первой помощи"
	item = /obj/item/storage/firstaid/regular

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 100

/datum/blackmarket_item/medicine/firstaid/spawn_item(loc)
	var/firstaid = pick(list(/obj/item/storage/firstaid/regular,
				/obj/item/storage/firstaid/ancient))
	return new firstaid(loc)

/datum/blackmarket_item/medicine/brute
	name = "Аптечка от травм"
	desc = "Состоит из медикаментов лечащих ушибы и прочие схожие ранения"
	item = /obj/item/storage/firstaid/brute

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 100

/datum/blackmarket_item/medicine/fire
	name = "Аптечка от ожогов"
	desc = "Состоит из медикаментов лечащих ожоги"
	item = /obj/item/storage/firstaid/fire
	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 100

/datum/blackmarket_item/medicine/toxin
	name = "Аптечка от токсинов"
	desc = "Состоит из медикаментов лечащих от токсинов и радиации"
	item = /obj/item/storage/firstaid/toxin

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 100

/datum/blackmarket_item/medicine/o2
	name = "Аптечка от недостатка кислорода"
	desc = "Состоит из медикаментов лечащих недостаток кислорода"
	item = /obj/item/storage/firstaid/o2

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 100

/datum/blackmarket_item/medicine/adv
	name = "Премиум Аптечка"
	desc = "Аптечка состоящая из более лучших медикаментов. Иными словами четыре в одном"
	item = /obj/item/storage/firstaid/advanced

	stock_min = 1
	stock_max = 5
	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 1500
	availability_prob = 100

/datum/blackmarket_item/medicine/adv/spawn_item(loc)
	var/adv = pick(list(/obj/item/storage/firstaid/advanced,
				/obj/item/storage/firstaid/tactical))
	return new adv(loc)

/datum/blackmarket_item/medicine/surgery
	name = "Набор Хирурга"
	desc = "Сумка в которой есть предметы хирургии"
	item = /obj/item/storage/firstaid/advanced

	stock_min = 1
	stock_max = 3
	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 2000
	availability_prob = 100

/datum/blackmarket_item/medicine/suspicious_pills
	name = "Баночка подозрительных таблеток"
	desc = "Содержит случайную баночку с определённым типом таблеток. "
	item = /obj/item/storage/pill_bottle

	stock_min = 1
	stock_max = 20
	price_min = BLACKMARKET_CRATE_VALUE * 400
	price_max = BLACKMARKET_CRATE_VALUE * 700
	availability_prob = 100

/datum/blackmarket_item/medicine/suspicious_pills/spawn_item(loc)
	var/pillbottle = pick(list(/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/storage/pill_bottle/cyanide,
				/obj/item/storage/pill_bottle/crank,
				/obj/item/storage/pill_bottle/bath_salts,
				/obj/item/storage/pill_bottle/lsd,
				/obj/item/storage/pill_bottle/aranesp,
				/obj/item/storage/pill_bottle/krokodil,
				/obj/item/storage/pill_bottle/happinesspsych,
				/obj/item/storage/pill_bottle/modafinil,
				/obj/item/storage/pill_bottle/methamphetamine,
				/obj/item/storage/pill_bottle/maintenance_pill/full,
				/obj/item/storage/pill_bottle/psicodine,
				/obj/item/storage/pill_bottle/probital,
				/obj/item/storage/pill_bottle/stimulant))
	return new pillbottle(loc)

/datum/blackmarket_item/medicine/floor_pill
	name = "Странная таблетка"
	desc = "Таблетка с технических тоннелей"
	item = /obj/item/reagent_containers/pill/maintenance

	stock_min = 1
	stock_max = 100
	price_min = BLACKMARKET_CRATE_VALUE * 10
	price_max = BLACKMARKET_CRATE_VALUE * 60
	availability_prob = 100

/datum/blackmarket_item/medicine/pumpup
	name = "Технический заряд адреналина"
	desc = "Заряд адреналина найденный в техах. Помогает пережить пару ударов дубинки"
	item = /obj/item/reagent_containers/hypospray/medipen/pumpup

	stock_min = 1
	stock_max = 10
	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 500
	availability_prob = 100

/datum/blackmarket_item/medicine/labebium
	name = "Лабебиум"
	desc = "Заставит поглотившего это познать правду."
	item = /obj/item/storage/pill_bottle/labebium

	stock_min = 1
	stock_max = 5
	price_min = BLACKMARKET_CRATE_VALUE * 250
	price_max = BLACKMARKET_CRATE_VALUE * 550
	availability_prob = 30

/datum/blackmarket_item/medicine/sleeperboard
	name = "Плата Слипера"
	desc = "Плата слипера которого заменила крио-камера"
	item = /obj/item/circuitboard/machine/sleeper

	stock_min = 1
	stock_max = 3
	price_min = BLACKMARKET_CRATE_VALUE * 250
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 70

/datum/blackmarket_item/medicine/zvezdochka
	name = "Звёздочка"
	desc = "Советский медицинский препарат."
	item = /obj/item/storage/pill_bottle/zvezdochka

	stock_min = 1
	stock_max = 5
	price_min = BLACKMARKET_CRATE_VALUE * 150
	price_max = BLACKMARKET_CRATE_VALUE * 350
	availability_prob = 60

/datum/blackmarket_item/medicine/speedrun
	name = "Срочное погружение"
	desc = "Боевой стимулятор с небольшими побочными эффектами."
	item = /obj/item/reagent_containers/pill/speedrun

	stock_min = 1
	stock_max = 5
	price_min = BLACKMARKET_CRATE_VALUE * 350
	price_max = BLACKMARKET_CRATE_VALUE * 650
	availability_prob = 70
