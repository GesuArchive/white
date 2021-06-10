GLOBAL_VAR_INIT(shuttle_docking_jammed, FALSE)

/obj/machinery/computer/shuttle_flight
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list( )
	var/shuttleId

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

	//Our orbital body.
	var/datum/orbital_object/shuttle/shuttleObject

/obj/machinery/computer/shuttle_flight/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	valid_docks = params2list(possible_destinations)
	shuttleId = shuttleId
	shuttlePortId = "[shuttleId]_custom"

/obj/machinery/computer/shuttle_flight/Destroy()
	. = ..()
	shuttleObject = null

/obj/machinery/computer/shuttle_flight/process()
	. = ..()

	//Check to see if the shuttleobject was launched by another console.
	if(QDELETED(shuttleObject) && SSorbits.assoc_shuttles.Find(shuttleId))
		shuttleObject = SSorbits.assoc_shuttles[shuttleId]

	if(recall_docking_port_id && shuttleObject?.docking_target && shuttleObject.autopilot && shuttleObject.shuttleTarget == shuttleObject.docking_target && shuttleObject.controlling_computer == src)
		//We are at destination, dock.
		shuttleObject.controlling_computer = null
		switch(SSshuttle.moveShuttle(shuttleId, recall_docking_port_id, 1))
			if(0)
				say("Шаттл прибыл в точку назначения.")
				QDEL_NULL(shuttleObject)
			if(1)
				to_chat(usr, "<span class='warning'>Неправильный шаттл запрошен.</span>")
			else
				to_chat(usr, "<span class='notice'>БЛЯТЬ!</span>")

/obj/machinery/computer/shuttle_flight/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/shuttle_flight/ui_interact(mob/user, datum/tgui/ui)
	//Ash walkers cannot use the console because they are unga bungas
	if(user.mind?.has_antag_datum(/datum/antagonist/ashwalker))
		to_chat(user, "<span class='warning'>Пошёл на хуй, ящер ёбаный.</span>")
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrbitalMap")
		ui.open()
	ui.set_autoupdate(TRUE)

/obj/machinery/computer/shuttle_flight/ui_static_data(mob/user)
	var/list/data = list()
	//The docks we can dock with never really changes
	//This is used for the forced autopilot mode where it goes to a set port.
	data["destination_docks"] = list()
	for(var/dock in valid_docks)
		data["valid_dock"] += list(list(
			"id" = dock,
		))
	//If we are a recall console.
	data["recall_docking_port_id"] = recall_docking_port_id
	data["request_shuttle_message"] = request_shuttle_message
	return data

/obj/machinery/computer/shuttle_flight/ui_data(mob/user)
	var/list/data = list()
	//Add orbital bodies
	data["map_objects"] = list()
	for(var/datum/orbital_object/object in SSorbits.orbital_map.bodies)
		if(!object)
			continue
		//we can't see it, unless we are stealth too
		if(shuttleObject)
			if(object != shuttleObject && (object.stealth && !shuttleObject.stealth))
				continue
		else
			if(object.stealth)
				continue
		//Send to be rendered on the UI
		data["map_objects"] += list(list(
			"name" = object.name,
			"position_x" = object.position.x,
			"position_y" = object.position.y,
			"velocity_x" = object.velocity.x,
			"velocity_y" = object.velocity.y,
			"radius" = object.radius
		))
	if(!SSshuttle.getShuttle(shuttleId))
		data["linkedToShuttle"] = FALSE
		return data
	data["canLaunch"] = TRUE
	if(QDELETED(shuttleObject))
		data["linkedToShuttle"] = FALSE
		return data
	data["autopilot"] = shuttleObject.autopilot
	data["linkedToShuttle"] = TRUE
	data["shuttleTarget"] = shuttleObject.shuttleTarget?.name
	data["shuttleName"] = shuttleObject.name
	data["shuttleAngle"] = shuttleObject.angle
	data["shuttleThrust"] = shuttleObject.thrust
	data["autopilot_enabled"] = shuttleObject.autopilot
	data["desired_vel_x"] = shuttleObject.desired_vel_x
	data["desired_vel_y"] = shuttleObject.desired_vel_y
	if(shuttleObject?.shuttleTarget)
		data["shuttleVelX"] = shuttleObject.velocity.x - shuttleObject.shuttleTarget.velocity.x
		data["shuttleVelY"] = shuttleObject.velocity.y - shuttleObject.shuttleTarget.velocity.y
	else
		data["shuttleVelX"] = shuttleObject.velocity.x
		data["shuttleVelY"] = shuttleObject.velocity.y
	//Docking data
	data["canDock"] = shuttleObject.can_dock_with != null
	data["isDocking"] = shuttleObject.docking_target != null
	data["validDockingPorts"] = list()
	if(shuttleObject.docking_target)
		if(shuttleObject.docking_target.can_dock_anywhere && !GLOB.shuttle_docking_jammed)
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
			if(shuttleObject.docking_target.linked_z_level)
				if(stationary_port.z == shuttleObject.docking_target.linked_z_level.z_value && (stationary_port.id in valid_docks))
					data["validDockingPorts"] += list(list(
						"name" = stationary_port.name,
						"id" = stationary_port.id,
					))
	return data

/obj/machinery/computer/shuttle_flight/ui_act(action, params)
	. = ..()

	if(.)
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
				for(var/datum/orbital_object/z_linked/z_linked in SSorbits.orbital_map.bodies)
					if(z_linked.linked_z_level?.z_value == target_port.z)
						if(!SSorbits.assoc_shuttles.Find(shuttleId))
							//Launch the shuttle
							if(!launch_shuttle())
								return
						if(shuttleObject.shuttleTarget == z_linked && shuttleObject.controlling_computer == src)
							return
						shuttleObject = SSorbits.assoc_shuttles[shuttleId]
						shuttleObject.shuttleTarget = z_linked
						shuttleObject.autopilot = TRUE
						shuttleObject.controlling_computer = src
						say("Shuttle requested.")
						return
				say("Место стыковки в жопе. Свяжитесь с техниками Нанотрейзен.")
		return

	switch(action)
		if("setTarget")
			var/desiredTarget = params["target"]
			if(shuttleObject.name == desiredTarget)
				return
			for(var/datum/orbital_object/object in SSorbits.orbital_map.bodies)
				if(object.name == desiredTarget)
					shuttleObject.shuttleTarget = object
					return
		if("setThrust")
			if(shuttleObject.autopilot)
				to_chat(usr, "<span class='warning'>Работает автопилот.</span>")
				return
			if(QDELETED(shuttleObject))
				return
			shuttleObject.thrust = clamp(params["thrust"], 0, 100)
		if("setAngle")
			if(shuttleObject.autopilot)
				to_chat(usr, "<span class='warning'>Работает автопилот.</span>")
				return
			if(QDELETED(shuttleObject))
				return
			shuttleObject.angle = params["angle"]
		if("nautopilot")
			if(QDELETED(shuttleObject) || !shuttleObject.shuttleTarget)
				return
			shuttleObject.autopilot = !shuttleObject.autopilot
		//Launch the shuttle. Lets do this.
		if("launch")
			launch_shuttle()
		//Dock at location.
		if("dock")
			if(QDELETED(shuttleObject))
				return
			if(!shuttleObject.can_dock_with)
				return
			//Force dock with the thing we are colliding with.
			shuttleObject.commence_docking(shuttleObject.can_dock_with, TRUE)
		//Go to valid port
		if("gotoPort")
			if(QDELETED(shuttleObject))
				return
			if(QDELETED(shuttleObject.docking_target))
				return
			//Get our port
			var/obj/docking_port/mobile/mobile_port = SSshuttle.getShuttle(shuttleId)
			if(!mobile_port || mobile_port.destination != null)
				return
			//Check ready
			if(mobile_port.mode == SHUTTLE_RECHARGING)
				say("Круиз: Двигатели не готовы.")
				return
			if(mobile_port.mode != SHUTTLE_CALL || mobile_port.destination)
				say("Круиз: Уже замедляем шаттл.")
				return
			//Special check
			if(params["port"] == "custom_location")
				//Open up internal docking computer if any location is allowed.
				if(shuttleObject.docking_target.can_dock_anywhere)
					if(GLOB.shuttle_docking_jammed)
						say("Консоль блокирована.")
						return
					if(current_user)
						to_chat(usr, "<span class='warning'>Кто-то уже стыкуется.</span>")
						return
					view_range = max(mobile_port.width, mobile_port.height) + 4
					give_eye_control(usr)
					eyeobj.forceMove(locate(world.maxx * 0.5, world.maxy * 0.5, shuttleObject.docking_target.linked_z_level.z_value))
					return
				//If random dropping is allowed, random drop.
				if(shuttleObject.docking_target.random_docking)
					random_drop()
					return
				//Report exploit
				log_admin("[usr] attempted to forge a target location through a tgui exploit on [src]")
				message_admins("[ADMIN_FULLMONTY(usr)] attempted to forge a target location through a tgui exploit on [src]")
				return
			//Find the target port
			var/obj/docking_port/stationary/target_port = SSshuttle.getDock(params["port"])
			if(!target_port)
				return
			if(!(target_port.id in valid_docks))
				log_admin("[usr] attempted to forge a target location through a tgui exploit on [src]")
				message_admins("[ADMIN_FULLMONTY(usr)] attempted to forge a target location through a tgui exploit on [src]")
				return
			//Dont wipe z level while we are going
			//Dont wipe z of where we are leaving for a bit, in case we come back.
			SSzclear.temp_keep_z(z)
			SSzclear.temp_keep_z(target_port.z)
			switch(SSshuttle.moveShuttle(shuttleId, target_port.id, 1))
				if(0)
					say("Инициируем замедление скорости, готовимся к сближению.")
					QDEL_NULL(shuttleObject)
				if(1)
					to_chat(usr, "<span class='warning'>Неправильный шаттл запрошен.</span>")
				else
					to_chat(usr, "<span class='notice'>Не понимаю. Иди на хуй.</span>")

/obj/machinery/computer/shuttle_flight/proc/launch_shuttle()
	var/obj/docking_port/mobile/mobile_port = SSshuttle.getShuttle(shuttleId)
	if(!mobile_port)
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

/obj/machinery/computer/shuttle_flight/proc/random_drop()
	//Find a random place to drop in at.
	if(!shuttleObject?.docking_target?.linked_z_level)
		return
	//Get shuttle dock
	var/obj/docking_port/mobile/shuttle_dock = SSshuttle.getShuttle(shuttleId)
	if(!shuttle_dock)
		return
	//Create temporary port
	var/obj/docking_port/stationary/random_port = new
	random_port.delete_after = TRUE
	random_port.width = shuttle_dock.width
	random_port.height = shuttle_dock.height
	random_port.dwidth = shuttle_dock.dwidth
	random_port.dheight = shuttle_dock.dheight
	var/sanity = 20
	var/square_length = max(shuttle_dock.width, shuttle_dock.height)
	var/border_distance = 10 + square_length
	//20 attempts to find a random port
	while(sanity > 0)
		sanity --
		//Place the port in a random valid area.
		var/x = rand(border_distance, world.maxx - border_distance)
		var/y = rand(border_distance, world.maxy - border_distance)
		//Check to make sure there are no indestructible turfs in the way
		random_port.setDir(pick(NORTH, SOUTH, EAST, WEST))
		random_port.forceMove(locate(x, y, shuttleObject.docking_target.linked_z_level.z_value))
		var/list/turfs = random_port.return_turfs()
		var/valid = TRUE
		for(var/turf/T as() in turfs)
			if(istype(T, /turf/open/indestructible) || istype(T, /turf/closed/indestructible))
				valid = FALSE
				break
		if(!valid)
			continue
		//Dont wipe z level while we are going
		//Dont wipe z of where we are leaving for a bit, in case we come back.
		SSzclear.temp_keep_z(z)
		SSzclear.temp_keep_z(shuttleObject.docking_target.linked_z_level.z_value)
		//Ok lets go there
		switch(SSshuttle.moveShuttle(shuttleId, random_port.id, 1))
			if(0)
				say("Инициируем замедление скорости, готовимся к посадке.")
				QDEL_NULL(shuttleObject)
			if(1)
				to_chat(usr, "<span class='warning'>Неправильный шаттл запрошен.</span>")
				qdel(random_port)
			else
				to_chat(usr, "<span class='notice'>Иди на хуй.</span>")
				qdel(random_port)
	qdel(random_port)

/obj/machinery/computer/shuttle_flight/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	req_access = list()
	obj_flags |= EMAGGED
	to_chat(user, "<span class='notice'>Сжигаю консоль.</span>")

/obj/machinery/computer/shuttle_flight/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(port && (shuttleId == initial(shuttleId) || override))
		shuttleId = port.id

