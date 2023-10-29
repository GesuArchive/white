/**********************Mining Equipment Vendor**************************/

/obj/machinery/vendor
	name = "раздатчик"
	processing_flags = START_PROCESSING_MANUALLY
	subsystem_type = /datum/controller/subsystem/processing/fastprocess
	density = TRUE
	var/icon_deny
	var/obj/item/card/id/inserted_id
	var/list/prize_list = list()

/obj/machinery/vendor/Initialize(mapload)
	. = ..()
	build_inventory()

/obj/machinery/vendor/proc/build_inventory()
	for(var/p in prize_list)
		var/datum/data/vendor_equipment/M = p
		GLOB.vending_products[M.equipment_path] = 1

/obj/machinery/vendor/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", name)
		ui.open()

/obj/machinery/vendor/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/vendor_equipment/prize in prize_list)
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			price = prize.cost,
			ref = REF(prize)
		)
		.["product_records"] += list(product_data)

/obj/machinery/vendor/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/C
	if(isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)
	if(C)
		.["user"] = list()
		.["user"]["points"] = get_points(C)
		if(C.registered_account)
			.["user"]["name"] = C.registered_account.account_holder
			if(C.registered_account.account_job)
				.["user"]["job"] = C.registered_account.account_job.title
			else
				.["user"]["job"] = "Безработный"

/obj/machinery/vendor/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("purchase")
			var/obj/item/card/id/I
			if(isliving(usr))
				var/mob/living/L = usr
				I = L.get_idcard(TRUE)
			if(!istype(I))
				to_chat(usr, span_alert("Ошибка: Требуется ID!"))
				flick(icon_deny, src)
				return
			var/datum/data/vendor_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, span_alert("Ошибка: Неправильный выбор!"))
				flick(icon_deny, src)
				return
			if(prize.cost > get_points(I))
				to_chat(usr, span_alert("Ошибка: Недостаточно очков для [prize.equipment_name] в [I]!"))
				flick(icon_deny, src)
				return
			subtract_points(I, prize.cost)
			to_chat(usr, span_notice("[capitalize(src.name)] выплёвывает [prize.equipment_name]!"))
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "vendor_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE

/obj/machinery/vendor/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/vendor/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(prob(50 / severity) && severity < 3)
		qdel(src)

/obj/machinery/vendor/proc/subtract_points(obj/item/card/id/I, amount)
	I.mining_points -= amount

/obj/machinery/vendor/proc/get_points(obj/item/card/id/I)
	return I.mining_points

/obj/machinery/vendor/mining
	name = "Торговый автомат шахтеров"
	desc = "Различное оборудование для бригады шахтеров. Очки добываются за сдачу руды в шахтерскую печь и начисляются на персональный счет шахтера."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor

	icon_deny = "mining-deny"
	prize_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		new /datum/data/vendor_equipment("1 Маркерный маячок",								/obj/item/stack/marker_beacon,										10),
		new /datum/data/vendor_equipment("10 Маркерных маячков",							/obj/item/stack/marker_beacon/ten,									100),
		new /datum/data/vendor_equipment("30 Маркерных маячков",							/obj/item/stack/marker_beacon/thirty,								300),
		new /datum/data/vendor_equipment("Виски",											/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100),
		new /datum/data/vendor_equipment("Абсент",											/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100),
		new /datum/data/vendor_equipment("Упаковка жевательной резинки",					/obj/item/storage/box/gum/bubblegum,								100),
		new /datum/data/vendor_equipment("Сигара",											/obj/item/clothing/mask/cigarette/cigar/havana,						150),
		new /datum/data/vendor_equipment("Мыло",											/obj/item/soap/nanotrasen,											200),
		new /datum/data/vendor_equipment("ИРП-4",											/obj/item/storage/mre,												215),
		new /datum/data/vendor_equipment("ИРП-6",											/obj/item/storage/mre/protein,										235),
		new /datum/data/vendor_equipment("ИРП-47",											/obj/item/storage/mre/vegan,										290),
		new /datum/data/vendor_equipment("Лазерная указка",									/obj/item/laser_pointer,											300),
		new /datum/data/vendor_equipment("Игрушечный лицехват",								/obj/item/clothing/mask/facehugger/toy,								300),
		new /datum/data/vendor_equipment("Стабилизирующая сыворотка",						/obj/item/hivelordstabilizer,										400),
		new /datum/data/vendor_equipment("Маяк Фултона",									/obj/item/fulton_core,												400),
		new /datum/data/vendor_equipment("Блюспейс капсула-убежище",						/obj/item/survivalcapsule,											400),
		new /datum/data/vendor_equipment("Шахтёрский заряд",								/obj/item/grenade/c4/miningcharge,									500),
		new /datum/data/vendor_equipment("GAR мезоны",										/obj/item/clothing/glasses/meson/gar,								500),
		new /datum/data/vendor_equipment("Разгрузка исследователя",							/obj/item/storage/belt/mining,										500),
		new /datum/data/vendor_equipment("Карта для перевода очков",						/obj/item/card/mining_point_card,									500),
		new /datum/data/vendor_equipment("Чрезвычайный медипен",							/obj/item/reagent_containers/hypospray/medipen/survival,			500),
		new /datum/data/vendor_equipment("Аптечка для физических ран",						/obj/item/storage/firstaid/brute,									600),
		new /datum/data/vendor_equipment("Комплект отслеживающих имплантов",				/obj/item/storage/box/minertracker,									600),
		new /datum/data/vendor_equipment("Генератор Червоточин",							/obj/item/wormhole_jaunter,											750),
		new /datum/data/vendor_equipment("Прото-кинетический крашер",						/obj/item/kinetic_crusher,											750),
		new /datum/data/vendor_equipment("Протокинетический ускоритель",					/obj/item/gun/energy/kinetic_accelerator,							750),
		new /datum/data/vendor_equipment("продвинутый автоматический шахтёрский сканер",	/obj/item/t_scanner/adv_mining_scanner,								800),
		new /datum/data/vendor_equipment("Глубинный пинпоинтер",							/obj/item/pinpointer/deepcore,										200),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Продвинутый пинпоинтер",							/obj/item/pinpointer/deepcore/advanced,								800),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Капсула бура глубинного погружения",				/obj/item/deepcorecapsule,											2000),		// WS edit - Deepcore
		new /datum/data/vendor_equipment("Резонатор",										/obj/item/resonator,												800),
		new /datum/data/vendor_equipment("Элитный медипен",									/obj/item/reagent_containers/hypospray/medipen/survival/luxury,		1000),
		new /datum/data/vendor_equipment("Фултон пак",										/obj/item/extraction_pack,											1000),
		new /datum/data/vendor_equipment("Инъектор Лазаря",									/obj/item/lazarus_injector,											1000),
		new /datum/data/vendor_equipment("Посеребренная кирка",								/obj/item/pickaxe/silver,											1000),
		new /datum/data/vendor_equipment("Комлпект шахтёра",								/obj/item/storage/backpack/duffelbag/mining_conscript,				1500),
		new /datum/data/vendor_equipment("Улучшение джетпака",								/obj/item/tank/jetpack/suit,										2000),
		new /datum/data/vendor_equipment("Улучшенные ремни сумок",							/obj/item/duffel_anti_slow,											2000),
		new /datum/data/vendor_equipment("Имплант биомонитора",								/obj/item/autosurgeon/organ/biomonitor,								2000),
		new /datum/data/vendor_equipment("Космоденьги",										/obj/item/stack/spacecash/c1000,									2000),
		new /datum/data/vendor_equipment("Шахтёрский скафандр",								/obj/item/clothing/suit/space/hardsuit/mining,						2000),
		new /datum/data/vendor_equipment("Кирка с алмазным наконечником",					/obj/item/pickaxe/diamond,											2000),
		new /datum/data/vendor_equipment("Продвинутый резонатор",							/obj/item/resonator/upgraded,										2500),
		new /datum/data/vendor_equipment("Прыжковые ботинки",								/obj/item/clothing/shoes/bhop,										2500),
		new /datum/data/vendor_equipment("Шахтёрский МОД скафандр", 						/obj/item/mod/control/pre_equipped/mining, 							3000),
		new /datum/data/vendor_equipment("Роскошная капсула-убежище",						/obj/item/survivalcapsule/luxury,									3000),
		new /datum/data/vendor_equipment("Супер протокинетический ускоритель",				/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator,	4000),
		new /datum/data/vendor_equipment("Элитная капсула-бар класса люкс",					/obj/item/survivalcapsule/luxuryelite,								10000),
		new /datum/data/vendor_equipment("Имплант боевого ассистента",						/obj/item/storage/box/aimbot,										20000),
		new /datum/data/vendor_equipment("Шахтерский дрон",									/mob/living/simple_animal/hostile/mining_drone,						800),
		new /datum/data/vendor_equipment("Дрон: Улучшение ближнего боя",					/obj/item/mine_bot_upgrade,											400),
		new /datum/data/vendor_equipment("Дрон: Улучшение здоровья",						/obj/item/mine_bot_upgrade/health,									400),
		new /datum/data/vendor_equipment("Дрон: Ускорение перезарядки",						/obj/item/borg/upgrade/modkit/cooldown/minebot,						600),
		new /datum/data/vendor_equipment("Дрон: Улучшение ИИ",								/obj/item/slimepotion/slime/sentience/mining,						1000),
		new /datum/data/vendor_equipment("КУ Игнорирование шахтерских дронов",				/obj/item/borg/upgrade/modkit/minebot_passthrough,					100),
		new /datum/data/vendor_equipment("КУ Белые трассеры",								/obj/item/borg/upgrade/modkit/tracer,								100),
		new /datum/data/vendor_equipment("КУ Настраиваемые трассеры",						/obj/item/borg/upgrade/modkit/tracer/adjustable,					150),
		new /datum/data/vendor_equipment("КУ Супер корпус",									/obj/item/borg/upgrade/modkit/chassis_mod,							250),
		new /datum/data/vendor_equipment("КУ Гипер корпус",									/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300),
		new /datum/data/vendor_equipment("КУ Увеличение дальнобойности",					/obj/item/borg/upgrade/modkit/range,								1000),
		new /datum/data/vendor_equipment("КУ Увеличение урона",								/obj/item/borg/upgrade/modkit/damage,								1000),
		new /datum/data/vendor_equipment("КУ Ускорение перезарядки",						/obj/item/borg/upgrade/modkit/cooldown,								1000),
		new /datum/data/vendor_equipment("КУ Улучшение бронебойности",						/obj/item/borg/upgrade/modkit/hardness,								1200),
		new /datum/data/vendor_equipment("КУ Наступательный взрыв",							/obj/item/borg/upgrade/modkit/aoe/mobs,								2000)
	)
/datum/data/vendor_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/vendor_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/vendor/mining/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_voucher))
		RedeemVoucher(I, user)
		return
	return ..()

/obj/machinery/vendor/proc/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list(
		"Комплект для добычи астероидов",
		"Спасательная капсула и разгрузка исследователя",
		"Комплект резонатора",
		"Шахтерский дрон",
		"Набор для эвакуации и спасения",
		"Комплект Крашера",
		"Комплект шахтера-призывника")

	var/selection = tgui_input_list(redeemer, "Выбери снаряжение", "Погашение шахтерского ваучера", sort_list(items))
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	var/drop_location = drop_location()
	switch(selection)
		if("Комплект для добычи астероидов")
			new /obj/item/clothing/suit/space/hardsuit/mining(drop_location)
			new /obj/item/tank/internals/oxygen(drop_location)
			new /obj/item/gps/mining(drop_location)
			new /obj/item/wormhole_jaunter(drop_location)
		if("Спасательная капсула и разгрузка исследователя")
			new /obj/item/storage/belt/mining/vendor(drop_location)
		if("Комплект резонатора")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/resonator(drop_location)
		if("Шахтерский дрон")
			new /mob/living/simple_animal/hostile/mining_drone(drop_location)
			new /obj/item/weldingtool/hugetank(drop_location)
			new /obj/item/clothing/head/welding(drop_location)
			new /obj/item/borg/upgrade/modkit/minebot_passthrough(drop_location)
		if("Набор для эвакуации и спасения")
			new /obj/item/extraction_pack(drop_location)
			new /obj/item/fulton_core(drop_location)
			new /obj/item/stack/marker_beacon/thirty(drop_location)
		if("Комплект Крашера")
			new /obj/item/extinguisher/mini(drop_location)
			new /obj/item/kinetic_crusher(drop_location)
		if("Комплект шахтера-призывника")
			new /obj/item/storage/backpack/duffelbag/mining_conscript(drop_location)

	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)

/****************Golem Point Vendor**************************/

/obj/machinery/vendor/golem
	name = "торговый автомат големов"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/mining_equipment_vendor/golem

/obj/machinery/vendor/golem/Initialize(mapload)
	desc += "\nКажется, было добавлено несколько вариантов."
	prize_list += list(
		new /datum/data/vendor_equipment("Допольнительная ID-карта",       				/obj/item/card/id/advanced/mining, 				           		250),
		new /datum/data/vendor_equipment("Научные очки",       		/obj/item/clothing/glasses/science,								250),
		new /datum/data/vendor_equipment("Обезьяний кубик",					/obj/item/food/monkeycube,        								300),
		new /datum/data/vendor_equipment("Пояс для инструментов",					/obj/item/storage/belt/utility,	    							350),
		new /datum/data/vendor_equipment("Королевский Плащ Освободителя", /obj/item/bedsheet/rd/royal_cape, 								500),
		new /datum/data/vendor_equipment("Экстракт серой слизи",			/obj/item/slime_extract/grey,									1000),
		new /datum/data/vendor_equipment("Модифицированный курок",    		/obj/item/borg/upgrade/modkit/trigger_guard,					1700),
		new /datum/data/vendor_equipment("Наследие освободителя",  	/obj/item/storage/box/rndboards,								2000)
		)
	return ..()

/**********************Mining Equipment Vendor Items**************************/

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "шахтерский ваучер"
	desc = "Талончик, который вы можете обменять на согласованные с ЦК наборы снаряжения. Для использования вставьте его в приемник шахтерского торгового автомата."
	icon = 'white/Feline/icons/voucher_duffelbag.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

/obj/item/card/mining_point_card
	name = "карта очков шахтёра"
	desc = "Небольшая карточка, на которую начислены очки. Проведите по ней ID-картой, чтобы перевести очки, а затем выбросьте."
	icon_state = "data_1"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, span_info("You transfer [points] points to [C]."))
			points = 0
		else
			to_chat(user, span_alert("There's no points left on [src]."))
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	..()
	to_chat(user, span_alert("There's [points] point\s on the card."))

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "набор шахтера-призывника"
	desc = "Комплект, содержащий все необходимое для поддержки шахтера в полевых условиях."

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/id/advanced/mining(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)
	new /obj/item/kitchen/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)
