/obj/machinery/recharger
	name = "оружейный зарядник"
	desc = "Заряжает энергетическое оружие и энергозависимую экипировку."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger"
	base_icon_state = "recharger"
	circuit = /obj/item/circuitboard/machine/recharger
	pass_flags = PASSTABLE
	var/obj/item/charging = null
	var/obj/item/charging_port2 = null
	var/recharge_coeff = 1
	var/using_power = FALSE //Did we put power into "charging" last process()?
	var/using_power2 = FALSE

	var/obj/item/stock_parts/cell/port_cell
	var/portable = FALSE

	var/static/list/allowed_devices = typecacheof(list(
		/obj/item/gun/energy,
		/obj/item/melee/baton,
		/obj/item/melee/sabre/security,
		/obj/item/ammo_box/magazine/recharge,
		/obj/item/modular_computer,
		/obj/item/kinetic_shield,
		/obj/item/tactical_recharger))


/obj/machinery/recharger/Initialize(mapload)
	. = ..()
	if(portable)
		for(var/obj/item/stock_parts/cell/Ce in component_parts)
			port_cell = Ce
	START_PROCESSING(SSmachines, src)

/obj/machinery/recharger/Destroy()
	. = ..()
//	if(port_cell)
//		QDEL_NULL(port_cell)
	return PROCESS_KILL

/obj/machinery/recharger/RefreshParts()
	. = ..()
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		recharge_coeff = C.rating

	if(portable)
		for(var/obj/item/stock_parts/cell/Ce in component_parts)
			port_cell = Ce

/obj/machinery/recharger/examine(mob/user)	// Осмотр
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += "<hr><span class='warning'>Слишком далеко, чтобы рассмотреть дисплей зарядника!</span>"
		return

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "<hr><span class='notice'>Дисплей:</span>"
		var/area/a = get_area(src)
		if(portable)	// Осмотр уровня заряда внутренней батареи если она есть
			if(!isarea(a) || a.power_equip == 0)
				. += "</br><span class='notice'>- Питание производится <b>от батареи</b>.</span>"
			else
				. += "</br><span class='notice'>- Питание производится <b>от станционной сети</b>.</span>"
			. += "</br><span class='notice'>- Уроверь батареи <b>[port_cell.percent()]%</b>.</span>"

		. += "</br><span class='notice'>- Зарядка <b>[recharge_coeff*10]%</b> за цикл.</span>"
		if(charging)	// Осмотр уровня заряда первого и единственного слота если это обычный зарядник
			if(istype(charging, /obj/item/tactical_recharger))
				var/obj/item/tactical_recharger/CI1 = charging
				. += "</br><span class='notice'>- [portable ? "Первый порт: " : ""]<b>[charging]</b> заряжен на <b>[CI1.cell_imitator_lvl*100/CI1.cell_imitator_max]%</b>.</span>"
			else
				var/obj/item/stock_parts/cell/C = charging.get_cell()
				. += "</br><span class='notice'>- [portable ? "Первый порт: " : ""]<b>[charging]</b> заряжен на <b>[C.percent()]%</b>.</span>"
		if(portable)	// Осмотр уровня заряда второго слота
			if(charging_port2)
				if(istype(charging, /obj/item/tactical_recharger))
					var/obj/item/tactical_recharger/CI2 = charging_port2
					. += "</br><span class='notice'>- Второй порт: <b>[charging_port2]</b> заряжен на <b>[CI2.cell_imitator_lvl*100/CI2.cell_imitator_max]%</b>.</span>"
				else
					var/obj/item/stock_parts/cell/C = charging_port2.get_cell()
					. += "</br><span class='notice'>- Второй порт: <b>[charging_port2]</b> заряжен на <b>[C.percent()]%</b>.</span>"

/obj/machinery/recharger/proc/setCharging(new_charging)		// Прок постановки на зарядку, нужен для оверлеев и изменения энергопотребления
	charging = new_charging
	if (new_charging)
		if(!portable)
			update_use_power(ACTIVE_POWER_USE)
		using_power = TRUE
		update_icon()
	else
		if(!portable)
			update_use_power(IDLE_POWER_USE)
		using_power = FALSE
		update_icon()

/obj/machinery/recharger/proc/setCharging2(new_charging)	// Дубль для слота 2
	charging_port2 = new_charging
	if (new_charging)
//		START_PROCESSING(SSmachines, src)
		if(!portable)
			update_use_power(ACTIVE_POWER_USE)
		//finished_recharging = FALSE
		using_power2 = TRUE
		update_icon()
	else
		if(!portable)
			update_use_power(IDLE_POWER_USE)
		using_power2 = FALSE
		update_icon()

/obj/machinery/recharger/attackby(obj/item/G, mob/user, params)		// Помещение предмета на зарядку с проверкой допустимости этого ЛКМ
	if(!portable)
		if(G.tool_behaviour == TOOL_WRENCH)
			if(charging)
				to_chat(user, span_notice("Там уже что-то есть!"))
				return
			set_anchored(!anchored)
			power_change()
			to_chat(user, span_notice("[anchored ? "Прикручиваю" : "Откручиваю"] [src.name]."))
			G.play_tool_sound(src)
			return

	var/allowed = is_type_in_typecache(G, allowed_devices)

	if(allowed)
		if(anchored)
			if(charging || panel_open)
				return 1

			//Checks to make sure he's not in space doing it, and that the area got proper power.
			var/area/a = get_area(src)
			if(!isarea(a) || a.power_equip == 0)	// Работа от аккумулятора
				if(portable)
					to_chat(user, span_notice("Зарядная станция мигает индикатором зарядки от батареи."))

				else
					to_chat(user, span_notice("[src.name] мигает красным, когда я пытаюсь вставить [G.name]."))
					return 1

			if (istype(G, /obj/item/gun/energy))
				var/obj/item/gun/energy/E = G
				if(!E.can_charge)
					to_chat(user, span_notice("Пушка не имеет внешнего коннектора для зарядки."))
					return 1

			if(!user.transferItemToLoc(G, src))
				return 1
			setCharging(G)

		else
			to_chat(user, span_notice("[src.name] не подключён ни к чему!"))
		return 1

	if(anchored && !charging)
		if(default_deconstruction_screwdriver(user, base_icon_state, base_icon_state, G))
			update_icon()
			return

		if(panel_open && G.tool_behaviour == TOOL_CROWBAR)
			default_deconstruction_crowbar(G)
			return

	return ..()

/obj/machinery/recharger/attackby_secondary(obj/item/G, mob/user, params)	// Дубль для второго слота ПКМ

	if(portable)
		var/allowed = is_type_in_typecache(G, allowed_devices)
		if(allowed)
			if(anchored)
				if(charging_port2 || panel_open)
					return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

				//Checks to make sure he's not in space doing it, and that the area got proper power.
				var/area/a = get_area(src)	// Работа от аккумулятора
				if(!isarea(a) || a.power_equip == 0)
					if(portable)
						to_chat(user, span_notice("Зарядная станция мигает индикатором зарядки от батареи."))

					else
						to_chat(user, span_notice("[src.name] мигает красным, когда я пытаюсь вставить [G.name]."))
						return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

				if (istype(G, /obj/item/gun/energy))
					var/obj/item/gun/energy/E = G
					if(!E.can_charge)
						to_chat(user, span_notice("Пушка не имеет внешнего коннектора для зарядки."))
						return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

				if(!user.transferItemToLoc(G, src))
					return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
				setCharging2(G)

			else
				to_chat(user, span_notice("[src.name] не подключён ни к чему!"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/recharger/attack_hand(mob/user)		// Извлечение оружия из зарядника ЛКМ

	add_fingerprint(user)
	if(charging)
		charging.update_icon()
		charging.forceMove(drop_location())
		user.put_in_hands(charging)
		setCharging(null)

/obj/machinery/recharger/attack_hand_secondary(mob/user)	// Дубль для второго порта ПКМ

	add_fingerprint(user)
	if(charging_port2)
		charging_port2.update_icon()
		charging_port2.forceMove(drop_location())
		user.put_in_hands(charging_port2)
		setCharging2(null)

/obj/machinery/recharger/attack_tk(mob/user)	// Телекинез
	if(!charging)
		return
	charging.update_icon()
	charging.forceMove(drop_location())
	setCharging(null)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/machinery/recharger/process(delta_time)	// Процессинг
	using_power = FALSE
	using_power2 = FALSE
	var/area/a = get_area(src)

	if(portable)
		if(port_cell.charge < port_cell.maxcharge)	//	Подзарядка батареи от сети
			if(isarea(a) && a.power_equip != 0)
				port_cell.give(port_cell.chargerate * recharge_coeff * delta_time / 12)
				update_icon()

	if(charging)												// Работа первого порта
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		if(C)													// Батарея стандартного типа
			if(C.charge < C.maxcharge)
				if(portable)
					if(!isarea(a) || a.power_equip == 0)		// Аккумулятор или сеть
						if(port_cell.charge > 0)
							port_cell.use(C.chargerate * recharge_coeff * delta_time / 2)
							C.give(C.chargerate * recharge_coeff * delta_time / 2)
					else
						use_power(active_power_usage * recharge_coeff * delta_time)
						C.give(C.chargerate * recharge_coeff * delta_time / 2)
				else
					use_power(active_power_usage * recharge_coeff * delta_time)
					C.give(C.chargerate * recharge_coeff * delta_time / 2)
				using_power = TRUE
			update_icon()

		if(istype(charging, /obj/item/ammo_box/magazine/recharge)) // Батарея магазинного типа
			var/obj/item/ammo_box/magazine/recharge/R = charging
			if(R.stored_ammo.len < R.max_ammo)
				R.stored_ammo += new R.ammo_type(R)
				use_power(active_power_usage * recharge_coeff * delta_time)
				using_power = TRUE
			update_icon()
			return

		if(istype(charging, /obj/item/tactical_recharger))			// Батарея имитаторного типа
			var/obj/item/tactical_recharger/CI1 = charging
			if(CI1.cell_imitator_lvl < CI1.cell_imitator_max)
				if(portable)
					if(!isarea(a) || a.power_equip == 0)		// Аккумулятор или сеть
						if(port_cell.charge > 0)
							port_cell.use(CI1.chargerate * recharge_coeff * delta_time / 2)
							CI1.cell_imitator_lvl = CI1.cell_imitator_lvl + (CI1.chargerate * recharge_coeff * delta_time / 2)
					else
						use_power(active_power_usage * recharge_coeff * delta_time)
						CI1.cell_imitator_lvl = CI1.cell_imitator_lvl + (CI1.chargerate * recharge_coeff * delta_time / 2)
				else
					use_power(active_power_usage * recharge_coeff * delta_time)
					CI1.cell_imitator_lvl = CI1.cell_imitator_lvl + (CI1.chargerate * recharge_coeff * delta_time / 2)
				using_power = TRUE
			if(CI1.cell_imitator_lvl > CI1.cell_imitator_max)
				CI1.cell_imitator_lvl = CI1.cell_imitator_max
			update_icon()
			return

	if(charging_port2)												// Работа второго порта
		var/obj/item/stock_parts/cell/C2 = charging_port2.get_cell()
		if(C2)													// Батарея стандартного типа
			if(C2.charge < C2.maxcharge)
				if(portable)
					if(!isarea(a) || a.power_equip == 0)		// Аккумулятор или сеть
						if(port_cell.charge > 0)
							port_cell.use(C2.chargerate * recharge_coeff * delta_time / 2)
							C2.give(C2.chargerate * recharge_coeff * delta_time / 2)
					else
						use_power(active_power_usage * recharge_coeff * delta_time)
						C2.give(C2.chargerate * recharge_coeff * delta_time / 2)
				else
					use_power(active_power_usage * recharge_coeff * delta_time)
					C2.give(C2.chargerate * recharge_coeff * delta_time / 2)
				using_power2 = TRUE
			update_icon()

		if(istype(charging_port2, /obj/item/ammo_box/magazine/recharge)) 	// Батарея магазинного типа
			var/obj/item/ammo_box/magazine/recharge/R2 = charging_port2
			if(R2.stored_ammo.len < R2.max_ammo)
				R2.stored_ammo += new R2.ammo_type(R2)
				use_power(active_power_usage * recharge_coeff * delta_time)
				using_power2 = TRUE
			update_icon()
			return

		if(istype(charging_port2, /obj/item/tactical_recharger))			// Батарея имитаторного типа
			var/obj/item/tactical_recharger/CI2 = charging_port2
			if(CI2.cell_imitator_lvl < CI2.cell_imitator_max)
				if(portable)
					if(!isarea(a) || a.power_equip == 0)		// Аккумулятор или сеть
						if(port_cell.charge > 0)
							port_cell.use(CI2.chargerate * recharge_coeff * delta_time / 2)
							CI2.cell_imitator_lvl = CI2.cell_imitator_lvl + (CI2.chargerate * recharge_coeff * delta_time / 2)
					else
						use_power(active_power_usage * recharge_coeff * delta_time)
						CI2.cell_imitator_lvl = CI2.cell_imitator_lvl + (CI2.chargerate * recharge_coeff * delta_time / 2)
				else
					use_power(active_power_usage * recharge_coeff * delta_time)
					CI2.cell_imitator_lvl = CI2.cell_imitator_lvl + (CI2.chargerate * recharge_coeff * delta_time / 2)
				using_power = TRUE
			if(CI2.cell_imitator_lvl > CI2.cell_imitator_max)
				CI2.cell_imitator_lvl = CI2.cell_imitator_max
			update_icon()
			return

//	if(!charging_port2 && !charging)
//		return PROCESS_KILL

/obj/machinery/recharger/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_CONTENTS)
		return
	if(!(machine_stat & (NOPOWER|BROKEN)) && anchored)
		if(istype(charging,  /obj/item/gun/energy))
			var/obj/item/gun/energy/E = charging
			if(E.cell)
				E.cell.emp_act(severity)

		else if(istype(charging, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = charging
			if(B.cell)
				B.cell.charge = 0

// Для портативной зарядной станции используется другой прок который находится по адресу /obj/machinery/recharger/portable/update_overlays()
/obj/machinery/recharger/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		return
	if(panel_open)	// Крышка открыта
		. += mutable_appearance(icon, "[base_icon_state]-open", layer)
		return

	if(!charging)	// Зарядник пуст
		. += mutable_appearance(icon, "[base_icon_state]-empty", layer)
		. += emissive_appearance(icon, "[base_icon_state]-empty", src, alpha = src.alpha)
		return
	if(using_power)	// Процесс зарядки
		. += mutable_appearance(icon, "[base_icon_state]-charging", layer)
		. += emissive_appearance(icon, "[base_icon_state]-charging", src, alpha = src.alpha)
		return
					// Зарядник содержит предмет
	. += mutable_appearance(icon, "[base_icon_state]-full", layer)
	. += emissive_appearance(icon, "[base_icon_state]-full", src, alpha = src.alpha)
