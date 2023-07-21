// Экипировка СБ

//	Переносной зарядник - предмет для переноски
/obj/item/recharger_item
	name = "портативная зарядная станция"
	desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. Для начала работы необходимо разложить в любом подходящем месте."
	icon = 'white/Feline/icons/sec_recharger.dmi'
	icon_state = "case"
	inhand_icon_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	force = 15
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = 500)
	attack_verb_continuous = list("робастит")
	attack_verb_simple = list("робастит")
	hitsound = 'sound/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbox_pickup.ogg'
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = 5
	var/cell_charge = 10000
	var/cell_maxcharge = 10000
	var/cond_tier = 1

//	Разворачивание станции
/obj/item/recharger_item/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(user.a_intent == INTENT_HELP)
		if(isopenturf(target))
			deploy_recharger(user, target)

/obj/item/recharger_item/proc/deploy_recharger(mob/user, atom/location)
	var/obj/machinery/recharger/portable/R = new /obj/machinery/recharger/portable(location)
	R.port_cell.maxcharge = cell_maxcharge
	R.port_cell.charge = cell_charge
	R.recharge_coeff = cond_tier
	R.add_fingerprint(user)
	user.visible_message(span_notice("[user] разворачивает зарядную станцию.") , span_notice("Разворачиваю зарядную станцию."))
	flick("sec-deploy", R)
	playsound(R,'white/Feline/sounds/recharger_deploy.ogg', 60, FALSE)
	qdel(src)

//	Осмотр чемоданчика
/obj/item/recharger_item/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += "<hr><span class='warning'>Слишком далеко, чтобы рассмотреть дисплей зарядной станции!</span>"
		return
	. += "<hr><span class='notice'>Дисплей:</span>"
	. += "</br><span class='notice'>- Уроверь батареи <b>[cell_charge*100/cell_maxcharge]%</b>.</span>"

//	Переносной зарядник - развернутая машина
/obj/machinery/recharger/portable
	name = "портативная зарядная станция"
	desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. При необходимости может быть свернут для транспортировки."
	icon = 'white/Feline/icons/sec_recharger.dmi'
	icon_state = "sec"
	base_icon_state = "sec"
	circuit = /obj/item/circuitboard/machine/portable_recharger
	portable = TRUE
	use_power = NO_POWER_USE

//  Микросхема
/obj/item/circuitboard/machine/portable_recharger
	name = "портативная зарядная станция"
	desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. Для начала работы необходимо разложить в любом подходящем месте."
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/recharger/portable
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE

// 	Сворачивание станции

/obj/machinery/recharger/portable/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return FALSE
		if(charging || charging_port2)
			to_chat(usr, span_warning("Невозможно свернуть зарядную станцию в процессе зарядки!"))
			return FALSE
		usr.visible_message(span_notice("[usr] сворачивает зарядную станцию.") , span_notice("Сворачиваю зарядную станцию."))
		var/obj/item/recharger_item/B = new /obj/item/recharger_item(src.drop_location())
		flick("sec-move", B)
		playsound(B, 'white/Feline/sounds/recharger_go.ogg', 60, FALSE)
		B.cell_maxcharge = port_cell.maxcharge
		B.cell_charge = port_cell.charge
		B.cond_tier = recharge_coeff
		qdel(src)

//  Оверлеи зарядки
/obj/machinery/recharger/portable/update_overlays()
	. = ..()
	var/area/a = get_area(src)
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		return
	if(panel_open)						// панель снята
		. += mutable_appearance(icon, "[base_icon_state]-open", layer)
		. += emissive_appearance(icon, "[base_icon_state]-open", src, alpha = src.alpha)
		return

	if(port_cell)						// уровень батареи
		var/cell_percent
		switch(port_cell.percent())
			if(0 to 14)
				cell_percent = "1"
			if(15 to 28)
				cell_percent = "2"
			if(29 to 42)
				cell_percent = "3"
			if(43 to 56)
				cell_percent = "4"
			if(57 to 70)
				cell_percent = "5"
			if(71 to 84)
				cell_percent = "6"
			if(85 to 100)
				cell_percent = "7"

		. += mutable_appearance(icon, "[base_icon_state]-charge-[cell_percent]", layer)
		. += emissive_appearance(icon, "[base_icon_state]-charge-[cell_percent]", src, alpha = src.alpha)

		var/power_net
		if(port_cell.percent() != 0)	// рабочая сеть
			if(!isarea(a) || a.power_equip == 0)
				power_net = "cell"
			else
				if(port_cell.percent() < 100)
					power_net = "rech"
				else
					power_net = "net"
		else
			power_net = "dead"
		. += mutable_appearance(icon, "[base_icon_state]-power-[power_net]", layer)
		. += emissive_appearance(icon, "[base_icon_state]-power-[power_net]", src, alpha = src.alpha)

	if(charging)							// порт 1
		if(port_cell.percent() != 0)
			var/port_1_cell_percent
			var/port_1_cell_percent_num
			if(istype(charging, /obj/item/tactical_recharger))	// вычисление % заряда имитатора
				var/obj/item/tactical_recharger/CI = charging
				port_1_cell_percent_num = CI.cell_imitator_lvl*100/CI.cell_imitator_max
			else
				var/obj/item/stock_parts/cell/C = charging.get_cell()	// запрос к реальной батарее
				port_1_cell_percent_num = C.percent()
			switch(port_1_cell_percent_num)		// процент заряда оружия
				if(0 to 14)
					port_1_cell_percent = "1"
				if(15 to 28)
					port_1_cell_percent = "2"
				if(29 to 42)
					port_1_cell_percent = "3"
				if(43 to 56)
					port_1_cell_percent = "4"
				if(57 to 70)
					port_1_cell_percent = "5"
				if(71 to 84)
					port_1_cell_percent = "6"
				if(85 to 100)
					port_1_cell_percent = "7"
			. += mutable_appearance(icon, "[base_icon_state]-p1-cell-[port_1_cell_percent]", layer)
			. += emissive_appearance(icon, "[base_icon_state]-p1-cell-[port_1_cell_percent]", src, alpha = src.alpha)

			if(using_power)						// в процессе
				. += mutable_appearance(icon, "[base_icon_state]-p1-charging", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p1-charging", src, alpha = src.alpha)
			else								// завершен
				. += mutable_appearance(icon, "[base_icon_state]-p1-full", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p1-full", src, alpha = src.alpha)
		else
			if(!isarea(a) || a.power_equip == 0)	// питания нет, внутренняя батарея пуста
				. += mutable_appearance(icon, "[base_icon_state]-p1-cell-fail", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p1-cell-fail", src, alpha = src.alpha)


	if(charging_port2)						// порт 2
		if(port_cell.percent() != 0)
			var/port_2_cell_percent
			var/port_2_cell_percent_num
			if(istype(charging_port2, /obj/item/tactical_recharger))	// вычисление % заряда имитатора
				var/obj/item/tactical_recharger/CI2 = charging_port2
				port_2_cell_percent_num = CI2.cell_imitator_lvl*100/CI2.cell_imitator_max
			else
				var/obj/item/stock_parts/cell/C2 = charging_port2.get_cell()	// запрос к реальной батарее
				port_2_cell_percent_num = C2.percent()
			switch(port_2_cell_percent_num)			// процент заряда оружия
				if(0 to 14)
					port_2_cell_percent = "1"
				if(15 to 28)
					port_2_cell_percent = "2"
				if(29 to 42)
					port_2_cell_percent = "3"
				if(43 to 56)
					port_2_cell_percent = "4"
				if(57 to 70)
					port_2_cell_percent = "5"
				if(71 to 84)
					port_2_cell_percent = "6"
				if(85 to 100)
					port_2_cell_percent = "7"
			. += mutable_appearance(icon, "[base_icon_state]-p2-cell-[port_2_cell_percent]", layer)
			. += emissive_appearance(icon, "[base_icon_state]-p2-cell-[port_2_cell_percent]", src, alpha = src.alpha)

			if(using_power2)					// в процессе
				. += mutable_appearance(icon, "[base_icon_state]-p2-charging", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p2-charging", src, alpha = src.alpha)
			else								// завершен
				. += mutable_appearance(icon, "[base_icon_state]-p2-full", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p2-full", src, alpha = src.alpha)
		else
			if(!isarea(a) || a.power_equip == 0)	// питания нет, внутренняя батарея пуста
				. += mutable_appearance(icon, "[base_icon_state]-p2-cell-fail", layer)
				. += emissive_appearance(icon, "[base_icon_state]-p2-cell-fail", src, alpha = src.alpha)


//  Тактический наспинный зарядник
/obj/item/tactical_recharger
	name = "тактический оружейный зарядник"
	desc = "Продвинутая переносная зарядная станция для энергетического оружия. Скорость зарядки немного ниже по сравнению с более крупными образцами, однако ее использование все равно значительно расширяет общую потенциальную емкость энергетического оружия."
	icon = 'white/Feline/icons/tactical_recharger.dmi'
	icon_state = "toz"
	worn_icon = 'white/Feline/icons/tactical_recharger_body.dmi'
	worn_icon_state = "toz"
	force = 15
	dog_fashion = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'

	var/cell_imitator_lvl = 2500
	var/cell_imitator_max = 2500
	var/chargerate = 100

	var/obj/item/charging = null
	var/using_power = FALSE
	var/recharge_coeff = 0.5

	var/overlay_state
	var/mutable_appearance/gun_overlay
//	var/pocket_storage_component_path = /datum/storage/pockets/tactical_recharger
	var/static/list/holdable_weapons_list = list(
		/obj/item/gun/energy/disabler = "disabler",
		/obj/item/gun/energy/laser = "laser",
		/obj/item/gun/energy/laser/rangers = "rangerlaser",
		/obj/item/gun/energy/laser/captain = "cap",
		/obj/item/gun/energy/e_gun = "egun",
		/obj/item/gun/energy/e_gun/nuclear = "nuke",
		/obj/item/gun/energy/e_gun/hos = "hos",
		/obj/item/gun/energy/e_gun/stun = "egun_taser",
		/obj/item/gun/energy/xray = "xray",
		/obj/item/gun/energy/e_gun/mini = "pistol",
		/obj/item/gun/energy/pulse = "pulse",
		/obj/item/gun/energy/pulse/pistol = "pistol",
	)

/obj/item/tactical_recharger/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Дисплей:</span>"
	. += "</br><span class='notice'>- Уроверь батареи: <b>[cell_imitator_lvl*100/cell_imitator_max]%</b>.</span>"
	if(charging)
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		. += "</br><span class='notice'>- Заряд оружия: <b>[charging]</b> - <b>[C.percent()]%</b>.</span>"
/*
//Параметры кармана
/datum/component/storage/concrete/pockets/tactical_recharger
	max_items = 1
	max_w_class = WEIGHT_CLASS_BULKY
	rustle_sound = FALSE
	attack_hand_interact = TRUE

//Тип хранимого
/datum/component/storage/concrete/pockets/tactical_recharger/Initialize(mapload)
	. = ..()
	set_holdable(list(/obj/item/gun/energy))
*/

//Параметры кармана
/datum/storage/pockets/tactical_recharger
	max_slots = 1
	max_specific_storage = WEIGHT_CLASS_BULKY
	rustle_sound = FALSE
	attack_hand_interact = TRUE

//Тип хранимого
/datum/storage/pockets/tactical_recharger/New(atom/parent, max_slots, max_specific_storage, max_total_storage, numerical_stacking, allow_quick_gather, allow_quick_empty, collection_mode, attack_hand_interact)
	. = ..()
	set_holdable(list(
		/obj/item/gun/energy
	))

// Инициализация обработки и кармана
/obj/item/tactical_recharger/Initialize(mapload)
	. = ..()
	create_storage(type = /datum/storage/pockets/tactical_recharger)
	START_PROCESSING(SSmachines, src)
	update_icon()
	update_appearance()

// Остановка обработки
/obj/item/tactical_recharger/Destroy()
	. = ..()
	return PROCESS_KILL

//Спавн оружия в чехле, пресеты
/obj/item/tactical_recharger/pulse/Initialize(mapload)
	. = ..()
	new /obj/item/gun/energy/pulse(src)
	update_appearance()

/obj/item/tactical_recharger/disabler/Initialize(mapload)	// Подавитель - Специалист
	. = ..()
	new /obj/item/gun/energy/e_gun/suppressor(src)
	update_appearance()

//Быстрое извлечение через ЛКМ, быстрое разоружение через "E" тут code\modules\mob\inventory.dm
/obj/item/tactical_recharger/attack_hand(mob/user)
	if(loc != user || user.get_item_by_slot(ITEM_SLOT_SUITSTORE) != src || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return ..()

	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] достаёт из тактического зарядника [I]."), span_notice("Достаю из тактического зарядника [I]."))
		I.forceMove(get_turf(loc))
		user.put_in_hands(I)
		update_appearance()
		update_icon()
		user.update_inv_s_store()
	else
		to_chat(user, span_warning("Крепления расстегнуты, [capitalize(src.name)] пуст."))

	return ..()

//Изменение картинки в зависимости от содержания
/obj/item/tactical_recharger/update_icon_state()
	icon_state = initial(icon_state)
//	worn_icon_state = initial(worn_icon_state)
	cut_overlay(gun_overlay)
	if(length(contents))
		var/obj/item/I = contents[1]
//		worn_icon_state = "full"
		charging = I
		if(I.type in holdable_weapons_list)
			overlay_state = holdable_weapons_list[I.type]
			gun_overlay = mutable_appearance(icon, overlay_state)
			add_overlay(gun_overlay)
		else
			overlay_state = "box"
			gun_overlay = mutable_appearance(icon, overlay_state)
			add_overlay(gun_overlay)

//			var/overlay_state = holdable_weapons_list[I.type]
//			. += mutable_appearance(icon, overlay_state, layer, plane, alpha)
//			icon_state = holdable_weapons_list[I.type]
	else
		charging = null
	return ..()

// Процесс зарядки
/obj/item/tactical_recharger/process(delta_time)
	using_power = FALSE
	if(length(contents))
		var/obj/item/I = contents[1]
		charging = I
	else
		charging = null

	if(charging)
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		if(C)
			if(C.charge < C.maxcharge)
				using_power = TRUE
				if(cell_imitator_lvl > 0)
					cell_imitator_lvl = cell_imitator_lvl - (C.chargerate * recharge_coeff * delta_time / 2)
					C.give(C.chargerate * recharge_coeff * delta_time / 2)
					charging.update_icon()
				else
					if(cell_imitator_lvl < 0)	// защита от отрицательных значений
						cell_imitator_lvl = 0
	update_icon()

//  Оверлеи зарядки
/obj/item/tactical_recharger/update_overlays()
	. = ..()

	if(charging)
		if(using_power)
			. += mutable_appearance(icon, "toz-charge", layer)
			. += emissive_appearance(icon, "toz-charge", src, alpha = src.alpha)
		else
			. += mutable_appearance(icon, "toz-full", layer)
			. += emissive_appearance(icon, "toz-full", src, alpha = src.alpha)

		var/w_cell_percent
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		switch(C.percent())
			if(0 to 10)
				w_cell_percent = "1"
			if(11 to 20)
				w_cell_percent = "2"
			if(21 to 30)
				w_cell_percent = "3"
			if(31 to 40)
				w_cell_percent = "4"
			if(41 to 50)
				w_cell_percent = "5"
			if(51 to 60)
				w_cell_percent = "6"
			if(61 to 70)
				w_cell_percent = "7"
			if(71 to 80)
				w_cell_percent = "8"
			if(81 to 90)
				w_cell_percent = "9"
			if(91 to 100)
				w_cell_percent = "10"

		. += mutable_appearance(icon, "toz-w_lvl-[w_cell_percent]", layer)
		. += emissive_appearance(icon, "toz-w_lvl-[w_cell_percent]", src, alpha = src.alpha)

	var/cell_percent
	switch(cell_imitator_lvl*100/cell_imitator_max)
		if(0 to 14)
			cell_percent = "1"
		if(15 to 28)
			cell_percent = "2"
		if(29 to 42)
			cell_percent = "3"
		if(43 to 56)
			cell_percent = "4"
		if(57 to 70)
			cell_percent = "5"
		if(71 to 84)
			cell_percent = "6"
		if(85 to 100)
			cell_percent = "7"

	. += mutable_appearance(icon, "toz-c_lvl-[cell_percent]", layer)
	. += emissive_appearance(icon, "toz-c_lvl-[cell_percent]", src, alpha = src.alpha)
