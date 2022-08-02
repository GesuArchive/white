/obj/machinery/vendor/exploration
	name = "Торговый автомат рейнджеров"
	desc = "Различное оборудование для команды исследователей глубин космоса. Очки добываются за выполнение миссий и разделяются между исследователями."
	icon = 'white/Feline/icons/rangers_vendor.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/exploration_equipment_vendor

	icon_deny = "mining-deny"
	prize_list = list(
		new /datum/data/vendor_equipment("Световой маячок 1 шт.",		/obj/item/stack/marker_beacon,										50),
		new /datum/data/vendor_equipment("Световой маячок 10 шт.",		/obj/item/stack/marker_beacon/ten,									300),
		new /datum/data/vendor_equipment("Световой маячок 30 шт.",		/obj/item/stack/marker_beacon/thirty,								500),
		new /datum/data/vendor_equipment("Чрезвычайный медипен",		/obj/item/reagent_containers/hypospray/medipen/survival,			1000),
		new /datum/data/vendor_equipment("Элитный медипен",				/obj/item/reagent_containers/hypospray/medipen/survival/luxury,		2000),
		new /datum/data/vendor_equipment("Препарат Спасатель",			/obj/item/storage/pill_bottle/saver,								2500),
		new /datum/data/vendor_equipment("Препарат Сенс-2",				/obj/item/storage/pill_bottle/sens,									1500),
	//	new /datum/data/vendor_equipment("Препарат Раккун-2",			/obj/item/reagent_containers/hypospray/medipen/raccoon,				2000),
	//	new /datum/data/vendor_equipment("Препарат Ностромо-7",			/obj/item/reagent_containers/hypospray/medipen/nostromo,			2000),
	//	new /datum/data/vendor_equipment("Препарат Спутник Лайт",		/obj/item/reagent_containers/hypospray/medipen/sputnik_lite,		5000),
		new /datum/data/vendor_equipment("Аптечка стандартная",			/obj/item/storage/firstaid/regular,									1000),
		new /datum/data/vendor_equipment("Аптечка травматологическая",	/obj/item/storage/firstaid/brute,									2000),
		new /datum/data/vendor_equipment("Аптечка противоожоговая",		/obj/item/storage/firstaid/fire,									2000),
		new /datum/data/vendor_equipment("Продвинутая аптечка",			/obj/item/storage/firstaid/advanced,								3000),
		new /datum/data/vendor_equipment("Разгрузка исследователя",		/obj/item/storage/belt/mining,										2000),
		new /datum/data/vendor_equipment("Бандольер",					/obj/item/storage/belt/bandolier,									2000),
		new /datum/data/vendor_equipment("Улучшенные ремни сумок",		/obj/item/duffel_anti_slow,											2000),
		new /datum/data/vendor_equipment("Пробивной заряд",				/obj/item/grenade/exploration,										1000),
		new /datum/data/vendor_equipment("Радио-детонатор",				/obj/item/exploration_detonator,									5000),
		new /datum/data/vendor_equipment("Блюспейс-маяк",				/obj/item/sbeacondrop/exploration,									3000),
		new /datum/data/vendor_equipment("Энергопистолет рейнджера",	/obj/item/gun/energy/e_gun/mini/exploration,						5000),
		new /datum/data/vendor_equipment("Расширенный баллон",			/obj/item/tank/internals/emergency_oxygen/engi,						1000),
		new /datum/data/vendor_equipment("Реактивные двигатели РИГа",	/obj/item/tank/jetpack/suit,										2000),
		new /datum/data/vendor_equipment("Военные магнитки",			/obj/item/clothing/shoes/magboots/ranger,							2000),
		new /datum/data/vendor_equipment("Имплант биомонитора",			/obj/item/autosurgeon/organ/biomonitor,								2000),
		new /datum/data/vendor_equipment("Нож выживальщика",			/obj/item/kitchen/knife/combat/survival,							1000),
		new /datum/data/vendor_equipment("Пицца Маргарита",				/obj/item/pizzabox/margherita,										200),
		new /datum/data/vendor_equipment("ИРП-4",						/obj/item/storage/mre,												215),
		new /datum/data/vendor_equipment("ИРП-6",						/obj/item/storage/mre/protein,										235),
		new /datum/data/vendor_equipment("ИРП-47",						/obj/item/storage/mre/vegan,										290),
		new /datum/data/vendor_equipment("Виски",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,			1000),
		new /datum/data/vendor_equipment("Абсцент",						/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	1000),
		new /datum/data/vendor_equipment("Сигара",						/obj/item/clothing/mask/cigarette/cigar/havana,						1500),
		new /datum/data/vendor_equipment("Мыло",						/obj/item/soap/nanotrasen,											2000),
		new /datum/data/vendor_equipment("Лазерная указка",				/obj/item/laser_pointer,											3000),
		new /datum/data/vendor_equipment("Игрушечный лицехват",			/obj/item/clothing/mask/facehugger/toy,								3000),
		new /datum/data/vendor_equipment("Набор рейнджера-медика",		/obj/item/storage/backpack/duffelbag/rangers/med,					10000),
		new /datum/data/vendor_equipment("Набор рейнджера-инженера",	/obj/item/storage/backpack/duffelbag/rangers/engi,					10000),
		new /datum/data/vendor_equipment("Набор рейнджера-боевика",		/obj/item/storage/backpack/duffelbag/rangers/gunner,				10000)
	)

/obj/machinery/vendor/exploration/subtract_points(obj/item/card/id/I, amount)
	GLOB.exploration_points -= amount

/obj/machinery/vendor/exploration/get_points(obj/item/card/id/I)
	if(!(ACCESS_EXPLORATION in I.access))
		return 0
	return GLOB.exploration_points

/*
/obj/machinery/vendor/exploration/subtract_points(obj/item/card/id/I, amount)
	I.exploration_points -= amount

/obj/machinery/vendor/exploration/get_points(obj/item/card/id/I)
	return I.exploration_points
*/
