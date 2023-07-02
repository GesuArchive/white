/obj/machinery/computer/shuttle_flight
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list()
	var/shuttleId

	//Time it takes to recharge after interdiction
	var/interdiction_time = 3 MINUTES

	//For recall consoles
	//If not set to an empty string, will display only the option to call the shuttle to that dock.
	//Once pressed the shuttle will engage autopilot and return to the dock.
	var/recall_docking_port_id = ""

	var/request_shuttle_message = "Запросить шаттл"

	//Admin controlled shuttles
	var/admin_controlled = FALSE

	//Used for mapping mainly
	var/possible_destinations = ""
	var/list/valid_docks = list("")

	//The current orbital map we are observing
	var/orbital_map_index = PRIMARY_ORBITAL_MAP

	//Our orbital body.
	var/datum/orbital_object/shuttle/shuttleObject

	var/list/banned_types = list(
		/mob/living/carbon/alien,
		/obj/item/clothing/mask/facehugger,
		/obj/item/organ/body_egg,
		/obj/item/organ/zombie_infection
	)

	var/registered = FALSE

/obj/machinery/computer/shuttle_flight/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	valid_docks = params2list(possible_destinations)
	if(shuttleId)
		shuttlePortId = "[shuttleId]_custom"
		set_shuttle_id(shuttleId)
	else
		var/static/i = 0
		shuttlePortId = "unlinked_shuttle_console_[i++]"
	RegisterSignal(SSorbits, COMSIG_ORBITAL_BODY_CREATED, PROC_REF(register_shuttle_object))

/obj/machinery/computer/shuttle_flight/proc/set_shuttle_id(new_id, stack_depth = 0)
	if (stack_depth > 5)
		log_runtime("Failed to set shuttle ID after 5 attempts, shuttle does still not exist. Shuttle ID: [new_id]")
		return // lmao i don't care
	//Unregister if we need
	if (registered)
		if (shuttleObject)
			unregister_shuttle_object(null, FALSE)
		registered = FALSE
	//Set the shuttle ID
	shuttleId = new_id
	//Set to null shuttle
	if (!shuttleId)
		return
	//Get the shuttle data
	var/datum/shuttle_data/new_shuttle = SSorbits.get_shuttle_data(shuttleId)
	if (new_shuttle)
		register_shuttle_object(null, SSorbits.assoc_shuttles[shuttleId])
		registered = TRUE
	else
		addtimer(CALLBACK(src, PROC_REF(set_shuttle_id), new_id, stack_depth + 1), 5 SECONDS)

/obj/machinery/computer/shuttle_flight/Destroy()
	. = ..()
	SSorbits.open_orbital_maps -= SStgui.get_all_open_uis(src)
	unregister_shuttle_object(shuttleObject, FALSE)
	UnregisterSignal(SSorbits, COMSIG_ORBITAL_BODY_CREATED)
	//De-link the port
	if(my_port)
		my_port.delete_after = TRUE
		my_port.id = null
		my_port.name = "Old [my_port.name]"
		my_port = null

/obj/machinery/computer/shuttle_flight/examine(mob/user)
	. = ..()
	var/obj/item/circuitboard/computer/shuttle/circuit_board = circuit
	if(istype(circuit_board))
		if(circuit_board.hacked)
			. += "<hr>Доступ разрешён."
		else
			. += "<hr>Можно вырубить проверку доступа используя мультитул на плате."

/obj/machinery/computer/shuttle_flight/proc/register_shuttle_object(datum/source, datum/orbital_object/body, datum/orbital_map/map)
	var/datum/orbital_object/shuttle/shuttle = body
	if(!istype(shuttle))
		return
	if(shuttle.shuttle_port_id != shuttleId)
		return
	if(shuttleObject)
		return
	shuttleObject = body
	RegisterSignal(shuttleObject, COMSIG_PARENT_QDELETING, PROC_REF(unregister_shuttle_object))

/obj/machinery/computer/shuttle_flight/proc/unregister_shuttle_object(datum/source, force)
	UnregisterSignal(shuttleObject, COMSIG_PARENT_QDELETING)
	shuttleObject = null
	if(current_user)
		remove_eye_control(current_user)

/obj/machinery/computer/shuttle_flight/proc/on_shuttle_messaged(datum/source, message)
	say(message)

/obj/machinery/computer/shuttle_flight/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/shuttle_flight/ui_interact(mob/user, datum/tgui/ui)
	if(!allowed(user) && !isobserver(user))
		say("Недостаточно прав.")
		return
	//Ash walkers cannot use the console because they are unga bungas
	if(user.mind?.has_antag_datum(/datum/antagonist/ashwalker))
		say("Пошёл нахуй, ящер ёбаный.")
		//to_chat(user, span_warning("Пошёл на хуй, ящер ёбаный."))
		return
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrbitalMap")
		ui.open()
	SSorbits.open_orbital_maps |= ui
	ui.set_autoupdate(FALSE)

/obj/machinery/computer/shuttle_flight/ui_close(mob/user, datum/tgui/tgui)
	. = ..()
	SSorbits.open_orbital_maps -= tgui

/obj/machinery/computer/shuttle_flight/ui_static_data(mob/user)
	var/list/data = list()
	//The docks we can dock with never really changes
	//This is used for the forced autopilot mode where it goes to a set port.
	data["destination_docks"] = list()
	for(var/dock in valid_docks)
		data["valid_dock"] += list(list(
			"id" = dock,
		))
	//Get the shuttle data
	var/datum/shuttle_data/shuttle_data = SSorbits.get_shuttle_data(shuttleId)
	//If we are a recall console.
	data["recall_docking_port_id"] = recall_docking_port_id
	data["request_shuttle_message"] = request_shuttle_message
	if(shuttle_data)
		data["interdiction_range"] = shuttle_data.interdiction_range
	return data

/obj/machinery/computer/shuttle_flight/ui_data(mob/user)
	//Fetch data
	var/user_ref = "[REF(user)]"
	var/datum/shuttle_data/shuttle_data = SSorbits.get_shuttle_data(shuttleId)

	//If we have no shuttle object, locate the object we are docked at
	var/datum/orbital_object/map_reference_object = shuttleObject
	if(!map_reference_object)
		//Locate the port
		var/obj/docking_port/mobile/mobile_port = SSshuttle.getShuttle(shuttleId)
		if(mobile_port)
			map_reference_object = SSorbits.assoc_z_levels["[mobile_port.z]"]

	//Get the base map data
	var/list/data = SSorbits.get_orbital_map_base_data(
		SSorbits.orbital_maps[orbital_map_index],
		user_ref,
		shuttle_data?.stealth,
		map_reference_object,
		shuttle_data
	)

	data["shuttleName"] = map_reference_object?.name

	//Send shuttle data
	if(!SSshuttle.getShuttle(shuttleId))
		data["linkedToShuttle"] = FALSE
		return data

	//Get shuttle data object
	if(length(shuttle_data.registered_engines))
		data["display_fuel"] = TRUE
		data["fuel"] = shuttle_data.get_fuel()

	//Display stats
	data["display_stats"] = list(
		"Состояние щита" = "[shuttle_data.shield_health]",
		"Масса" = "[shuttle_data.mass] тонн",
		"Мощность двигателей" = "[shuttle_data.thrust] кН",
		"Ускорение" = "[shuttle_data.get_thrust_force()] бкнт^-2",
		"Потребление" = "[shuttle_data.fuel_consumption] моль/с"
	)

	//Interdicted shuttles
	data["interdictedShuttles"] = list()
	if(SSorbits.interdicted_shuttles[shuttleId] > world.time)
		data["interdictionTime"] = SSorbits.interdicted_shuttles[shuttleId] - world.time
	else
		data["interdictionTime"] = 0
	// Display local shuttles
	var/obj/docking_port/mobile/our_port = SSshuttle.getShuttle(shuttleId)
	if (our_port.mode == SHUTTLE_IDLE)
		for(var/shuttle_id in SSorbits.assoc_shuttle_data)
			var/datum/shuttle_data/target_data = SSorbits.assoc_shuttle_data[shuttle_id]
			var/obj/docking_port/mobile/port = SSshuttle.getShuttle(shuttle_id)
			if (target_data.stealth)
				continue
			if(port && port.mode == SHUTTLE_IDLE && port.z == our_port.z)
				data["interdictedShuttles"] += list(list(
					"shuttleName" = port.name,
					"x" = port.x - our_port.x,
					"y" = port.y - our_port.y,
				))

	data["canLaunch"] = TRUE
	if(QDELETED(shuttleObject))
		data["linkedToShuttle"] = FALSE
		return data
	data["linkedToShuttle"] = TRUE
	data["shuttleTarget"] = shuttleObject.shuttle_data.ai_pilot?.get_target_name()
	data["shuttleName"] = shuttleObject.name
	data["shuttleAngle"] = shuttleObject.angle
	data["shuttleThrust"] = shuttleObject.thrust
	data["autopilot_enabled"] = shuttleObject.shuttle_data.ai_pilot?.is_active()
	data["shuttleVelX"] = shuttleObject.velocity.GetX()
	data["shuttleVelY"] = shuttleObject.velocity.GetY()
	data["breaking"] = shuttleObject.breaking
	//Docking data
	data["canDock"] = shuttleObject.can_dock_with != null && !shuttleObject.docking_frozen
	data["isDocking"] = shuttleObject.docking_target != null && !shuttleObject.docking_frozen && !shuttleObject.docking_target.is_generating
	data["shuttleTargetX"] = shuttleObject.shuttleTargetPos?.GetX()
	data["shuttleTargetY"] = shuttleObject.shuttleTargetPos?.GetY()
	data["validDockingPorts"] = list()
	if(shuttleObject.docking_target && !shuttleObject.docking_frozen)
		//Undock option
		data["validDockingPorts"] += list(list(
			"name" = "Отстыковаться",
			"id" = "undock"
		))
		//Stealth shuttles bypass shuttle jamming.
		if(shuttleObject.docking_target.can_dock_anywhere && (!GLOB.shuttle_docking_jammed || shuttle_data.stealth || !istype(shuttleObject.docking_target, /datum/orbital_object/z_linked/station)))
			data["validDockingPorts"] += list(list(
				"name" = "Выбрать место стыковки",
				"id" = "custom_location"
			))
		else if(shuttleObject.docking_target.random_docking)
			data["validDockingPorts"] += list(list(
				"name" = "Случайно",
				"id" = "custom_location"
			))
		for(var/obj/docking_port/stationary/stationary_port as() in SSshuttle.stationary)
			if(LAZYLEN(shuttleObject.docking_target.linked_z_level))
				for(var/datum/space_level/level in shuttleObject.docking_target.linked_z_level)
					if(stationary_port.z == level.z_value && (stationary_port.id in valid_docks))
						data["validDockingPorts"] += list(list(
							"name" = stationary_port.name,
							"id" = stationary_port.id,
						))
	return data

/obj/machinery/computer/shuttle_flight/ui_act(action, params)
	. = ..()

	if(.)
		return

	if(!allowed(usr))
		say("Недостаточно прав.")
		return

	if(admin_controlled)
		say("Этот шаттл только для авторизованного персонала.")
		return

	if(recall_docking_port_id)
		switch(action)
			if("callShuttle")
				//Find the z-level that the dock is on
				var/obj/docking_port/stationary/target_port = SSshuttle.getDock(recall_docking_port_id)
				if(!target_port)
					say("Невозможно найти порт.")
					return
				//Locate linked shuttle
				var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
				if(!shuttle)
					say("Невозможно найти нужный шаттл.")
					return
				if(target_port in shuttle.loc)
					say("Шаттл уже в месте назначения.")
					return
				//Locate the orbital object
				var/datum/orbital_map/viewing_map = SSorbits.orbital_maps[orbital_map_index]
				for(var/datum/orbital_object/z_linked/z_linked as() in viewing_map.get_all_bodies())
					if(!istype(z_linked))
						continue
					if(z_linked.z_in_contents(target_port.z))
						if(!SSorbits.assoc_shuttles.Find(shuttleId))
							//Launch the shuttle
							if(!launch_shuttle())
								return
						if(shuttleObject.shuttle_data.try_override_pilot())
							shuttleObject.shuttle_data.set_pilot(new /datum/shuttle_ai_pilot/autopilot/request(
								z_linked, recall_docking_port_id
							))
							say("Шаттл запрошен.")
						else
							say("Нет ответа.")
						return
				say("Место стыковки в жопе. Свяжитесь с техниками NanoTrasen.")
		return

	switch(action)
		if("toggleBreaking")
			if(QDELETED(shuttleObject))
				say("Шаттл не в полёте.")
				return
			shuttleObject.breaking = params["enabled"] != "false"
		if("setTarget")
			if(QDELETED(shuttleObject))
				say("Шаттл не в полёте.")
				return
			var/desiredTarget = params["target"]
			if(shuttleObject.name == desiredTarget)
				return
			var/datum/orbital_map/showing_map = SSorbits.orbital_maps[orbital_map_index]
			for(var/datum/orbital_object/object as() in showing_map.get_all_bodies())
				if(object.name == desiredTarget)
					var/is_autopilot_active = shuttleObject.shuttle_data.ai_pilot?.is_active()
					if(shuttleObject.shuttle_data.try_override_pilot())
						shuttleObject.shuttle_data.set_pilot(new /datum/shuttle_ai_pilot/autopilot(object))
						if(is_autopilot_active)
							shuttleObject.shuttle_data.ai_pilot?.try_toggle()
					else
						say("Шаттл не хочет управляться")
					return
		if("nautopilot")
			if(QDELETED(shuttleObject))
				return
			if(!shuttleObject.shuttle_data.ai_pilot?.try_toggle())
				shuttleObject.shuttle_data.try_override_pilot()
		//Launch the shuttle. Lets do this.
		if("launch")
			launch_shuttle()
		//Dock at location.
		if("dock")
			if(QDELETED(shuttleObject))
				say("Стыковочный модуль оффлайн.")
				return
			if(!shuttleObject.can_dock_with)
				say("Стыковочный модуль не может найти цель.")
				return
			//Force dock with the thing we are colliding with.
			shuttleObject.commence_docking(shuttleObject.can_dock_with, TRUE)
		if("setTargetCoords")
			if(QDELETED(shuttleObject))
				return
			if(shuttleObject.shuttle_data.ai_pilot?.is_active())
				if(!shuttleObject.shuttle_data.ai_pilot?.try_toggle() && !shuttleObject.shuttle_data.try_override_pilot())
					say("Шаттл управляется извне.")
					return
			var/x = text2num(params["x"])
			var/y = text2num(params["y"])
			if(!shuttleObject.shuttleTargetPos)
				shuttleObject.shuttleTargetPos = new(x, y)
			else
				shuttleObject.shuttleTargetPos.Set(x, y)
			. = TRUE
		if("interdict")
			if(QDELETED(shuttleObject))
				say("Перехват не готов.")
				return
			shuttleObject.perform_interdiction()
		//Go to valid port
		if("gotoPort")
			if(!shuttleObject)
				say("Шаттл уже пристыкован.")
				return
			//Undock
			if(params["port"] == "undock")
				shuttleObject.undock()
				return
			//Special check
			if(params["port"] == "custom_location")
				//Open up internal docking computer if any location is allowed.
				if(shuttleObject?.docking_target?.can_dock_anywhere)
					var/obj/docking_port/mobile/mobile_port = SSshuttle.getShuttle(shuttleId)
					if(!mobile_port)
						say("Не обнаружен шаттл.")
						return
					if(GLOB.shuttle_docking_jammed && !shuttleObject.is_stealth() && istype(shuttleObject.docking_target, /datum/orbital_object/z_linked/station))
						say("Компьютер заблокирован.")
						return
					if(current_user)
						to_chat(usr, span_warning("Кто-то уже стыкуется."))
						return
					view_range = max(mobile_port.width, mobile_port.height, mobile_port.dwidth, mobile_port.dheight) * 0.5 - 4
					give_eye_control(usr)
					eyeobj.forceMove(locate(world.maxx * 0.5, world.maxy * 0.5, shuttleObject.docking_target.linked_z_level[1].z_value))
					return
				//If random dropping is allowed, random drop.
				if(shuttleObject?.docking_target?.random_docking)
					shuttleObject.random_drop()
					return
				//Report exploit
				log_admin("[usr] attempted to forge a target location through a tgui exploit on [src]")
				message_admins("[ADMIN_FULLMONTY(usr)] attempted to forge a target location through a tgui exploit on [src]")
				return
			//Go to the specified docking port
			shuttleObject.goto_port(params["port"])

/obj/machinery/computer/shuttle_flight/proc/launch_shuttle()
	var/datum/shuttle_data/shuttle_data = SSorbits.get_shuttle_data(shuttleId)
	if(check_banned_contents())
		say("ВНИМАНИЕ! На борту обнаружен ксенопаразит! Активирован протокол сдерживания! В случае заражения экипажа вколите пострадавшему антипаразитный препарат из чрезвычайного хранилища!")
		return
	if(shuttle_data && !shuttle_data.check_can_launch())
		say("Недостаточная сила двигателей для запуска.")
		shuttle_data.recalculate_stats()
		return
	if(SSorbits.interdicted_shuttles.Find(shuttleId))
		if(world.time < SSorbits.interdicted_shuttles[shuttleId])
			var/time_left = (SSorbits.interdicted_shuttles[shuttleId] - world.time) * 0.1
			say("Круиз: Двигатели были перехвачены и будут перезагружены через [time_left] секунд.")
			return
	var/obj/docking_port/mobile/mobile_port = SSshuttle.getShuttle(shuttleId)
	if(!mobile_port)
		return
	if(!mobile_port.canMove())
		say("Круиз: Невозможно двигаться.")
		return
	if(mobile_port.mode == SHUTTLE_RECHARGING)
		say("Круиз: Двигатели остывают.")
		return
	if(mobile_port.mode != SHUTTLE_IDLE)
		say("Круиз: Уже летим.")
		return
	if(SSorbits.assoc_shuttles.Find(shuttleId))
		say("Перехват управления из внешнего ПУ, обновление телеметрии.")
		shuttleObject = SSorbits.assoc_shuttles[shuttleId]
		return shuttleObject
	shuttleObject = mobile_port.enter_supercruise()
	if(!shuttleObject)
		say("БЛЯТЬ?")
		return
	shuttleObject.valid_docks = valid_docks
	return shuttleObject

/obj/machinery/computer/shuttle_flight/proc/check_banned_contents()
	var/obj/docking_port/mobile/port = SSshuttle.getShuttle(shuttleId)
	for(var/area/A in port.shuttle_areas)
		for(var/atom/movable/AM in A.get_all_contents())
			for(var/type in banned_types)
				if(istype(AM, type))
					return TRUE
			if(iscarbon(AM))
				var/mob/living/carbon/C = AM
				for(var/obj/O in C.internal_organs)
					for(var/type in banned_types)
						if(istype(O, type))
							return TRUE

/obj/machinery/computer/shuttle_flight/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	req_access = list()
	obj_flags |= EMAGGED
	to_chat(user, span_notice("Сжигаю консоль."))

/obj/machinery/computer/shuttle_flight/allowed(mob/M)
	var/obj/item/circuitboard/computer/shuttle/circuit_board = circuit
	if(istype(circuit_board) && circuit_board.hacked)
		return TRUE
	return ..()
