/datum/blackmarket_item/implants
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Импланты"

/datum/blackmarket_item/implants/autosurgeon/thermal_eyes
	name = "Термальные глаза"
	desc = "Термальные глаза в комплекте с АвтоХирургом"
	item = /obj/item/autosurgeon/organ/syndicate/thermal_eyes
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/xray_eyes
	name = "Х-рей Глаза"
	desc = "Х-рей глаза в комплекте с Автохирургом"
	item = /obj/item/autosurgeon/organ/syndicate/xray_eyes
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 5000
	price_max = BLACKMARKET_CRATE_VALUE * 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/anti_stun
	name = "Имплант Анти-Оглушения"
	desc = "При доставке на станции будет находится в АвтоХирурге"
	item = /obj/item/autosurgeon/organ/syndicate/anti_stun
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 1500
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/reviver
	name = "Имплант возрождения"
	desc = "В комплекте с АвтоХирургом"
	item = /obj/item/autosurgeon/organ/syndicate/reviver
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 5000
	price_max = BLACKMARKET_CRATE_VALUE * 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/breathing_tube
	name = "Дыхательная трубка"
	desc = "Не забудьте нажать на кнопочку в АвтоХирурге чтобы применить"
	item = /obj/item/autosurgeon/organ/breathing_tube
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/medical
	name = "Медицинский ХУД"
	desc = "Медицинский ХУД для глаз. К сожалению не помогает видеть людей голыми..."
	item = /obj/item/autosurgeon/organ/hud/medical
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/security
	name = "ХУД Службы Безопастности"
	desc = "Худ Службы Безопасности для нахождения потенциальных нарушителей"
	item = /obj/item/autosurgeon/organ/hud/security
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/hud/diagnostic
	name = "Диагностирующий ХУД"
	desc = "С помощью него можно с лёгкостью узнать какую дрянь ты пьёшь"
	item = /obj/item/autosurgeon/organ/hud/diagnostic
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 500
	price_max = BLACKMARKET_CRATE_VALUE * 1000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/nutriment
	name = "Питательная трубка"
	desc = "Для замены желудка. Кому он нужен?"
	item = /obj/item/autosurgeon/organ/nutriment
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/nutriment/plus
	name = "Питательная трубка ПЛЮС"
	desc = "Более улучшенная версия питательной трубки"
	item = /obj/item/autosurgeon/organ/nutriment/plus
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 5000
	price_max = BLACKMARKET_CRATE_VALUE * 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/thrusters
	name = "Thrusters Implant" //хз как переводить. пускай так и будет
	desc = "This autosurgeon contains Thrusters Implant"
	item = /obj/item/autosurgeon/organ/thrusters
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/toolset
	name = "Инженерный набор инструментов"
	desc = "Не требует пояса для инструментов ведь все инструменты теперь в твоей руке"
	item = /obj/item/autosurgeon/organ/arm/toolset
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 500
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/medibeam
	name = "Медицинский луч"
	desc = "Рука стреляющая лазерами. КРУТО!"
	item = /obj/item/autosurgeon/organ/arm/medibeam
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 5000
	price_max = BLACKMARKET_CRATE_VALUE * 10000
	availability_prob = 50

/datum/blackmarket_item/implants/autosurgeon/surgery
	name = "Набор инструментов для Хирургии"
	desc = "Содержит базовые инструменты для хирургии, но в руке"
	item = /obj/item/autosurgeon/organ/arm/surgery
	stock_min = 1
	stock_max = 5

	price_min = BLACKMARKET_CRATE_VALUE * 100
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	availability_prob = 50




