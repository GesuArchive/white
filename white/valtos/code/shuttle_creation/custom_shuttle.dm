/obj/machinery/computer/shuttle_flight/custom_shuttle
	name = "nanotrasen shuttle flight controller"
	desc = "A terminal used to fly shuttles defined by the Shuttle Zoning Designator"
	circuit = /obj/item/circuitboard/computer/shuttle/flight_control
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list( )
	possible_destinations = "whiteship_home"

	var/list/obj/machinery/shuttle/engine/shuttle_engines = list()
	var/calculated_mass = 0
	var/calculated_dforce = 0
	var/calculated_acceleration = 0
	var/calculated_engine_count = 0
	var/calculated_consumption = 0
	var/calculated_cooldown = 0
	var/calculated_non_operational_thrusters = 0
	var/calculated_fuel_less_thrusters = 0

/obj/machinery/computer/shuttle_flight/custom_shuttle/ui_static_data(mob/user)
	var/list/data = ..()
	calculateStats()
	data["display_fuel"] = TRUE
	return data

/obj/machinery/computer/shuttle_flight/custom_shuttle/ui_data(mob/user)
	var/list/data = ..()
	data["fuel"] = get_fuel()
	data["display_stats"] = list(
		"Масса" = "[calculated_mass/10] тонн",
		"Сила двигателей" = "[calculated_dforce]кН ([calculated_engine_count] двигателей)",
		"Ускорение" = "[calculated_acceleration] мс^-2",
		"Потребление топлива" = "[calculated_consumption] молей в секунду",
		"Охлаждение двигателей" = "[calculated_cooldown] секунд"
	)
	if(calculated_acceleration < 1)
		data["thrust_alert"] = "Недостаточно энергии было записано с последнего запуска. Запустите шаттл для перекалибровки."
	else
		data["thrust_alert"] = 0
	if(calculated_non_operational_thrusters > 0)
		data["damage_alert"] = "[calculated_non_operational_thrusters] двигатели оффлайн."
	else
		data["thrust_alert"] = 0
	return data

/obj/machinery/computer/shuttle_flight/custom_shuttle/launch_shuttle()
	calculateStats()
	if(calculated_acceleration < 1)
		say("Недостаточная сила двигателей.")
		return
	var/datum/orbital_object/shuttle/custom_shuttle/shuttle = ..()
	if(shuttle)
		shuttle.attached_console = src
	return shuttle

//Consumes fuel and reduces thrust of engines that run out of fuel
/obj/machinery/computer/shuttle_flight/custom_shuttle/proc/consume_fuel(var/multiplier = 1)
	//Reset stats
	calculated_dforce = 0
	calculated_acceleration = 0
	calculated_engine_count = 0
	calculated_consumption = 0
	//Consume fuel
	for(var/obj/machinery/shuttle/engine/E as() in shuttle_engines)
		var/valid_thruster = FALSE
		//Void thrusters don't need heaters
		if(E.needs_heater)
			//Check for inop engines
			if(!E.attached_heater)
				continue
			var/obj/machinery/atmospherics/components/unary/shuttle/heater/shuttle_heater = E.attached_heater.resolve()
			if(!shuttle_heater)
				continue
			if(shuttle_heater.dir != E.dir)
				continue
			if(shuttle_heater.panel_open)
				continue
			if(!shuttle_heater.anchored)
				continue
			//Setup correct, check fuel.
			if(shuttle_heater.hasFuel(E.fuel_use * multiplier / shuttle_heater.efficiency_multiplier))
				shuttle_heater.consumeFuel(E.fuel_use * multiplier / shuttle_heater.efficiency_multiplier)
				valid_thruster = TRUE
		else
			valid_thruster = TRUE
		if(valid_thruster)
			calculated_consumption += E.fuel_use
			calculated_dforce += E.thrust
			calculated_engine_count ++
	calculated_acceleration = (calculated_dforce*1000) / (calculated_mass*100)

/obj/machinery/computer/shuttle_flight/custom_shuttle/proc/check_stranded()
	if(!calculated_engine_count && shuttleObject)
		say("Топливо закончилось. Экстренный сброс!")
		if(!shuttleObject.docking_target)
			if(shuttleObject.can_dock_with)
				shuttleObject.commence_docking(shuttleObject.can_dock_with, TRUE)
			else
				//Send shuttle object to random location
				var/datum/orbital_object/z_linked/beacon/z_linked = new /datum/orbital_object/z_linked/beacon/ruin/stranded_shuttle(new /datum/orbital_vector(shuttleObject.position.x, shuttleObject.position.y))
				z_linked.name = "Заблудший [shuttleObject]"
				if(!z_linked)
					say("Невозможно остановить шаттл, свяжитесь с Нанотрейзен.")
					return
				shuttleObject.commence_docking(z_linked, TRUE)
		shuttleObject.docking_frozen = TRUE
		//Dock
		if(!random_drop())
			say("Невозможно выбрать место приземления. Выберите локацию.")
			shuttleObject.docking_frozen = FALSE
		return TRUE
	return FALSE

/obj/machinery/computer/shuttle_flight/custom_shuttle/proc/get_fuel()
	var/amount = 0
	for(var/obj/machinery/shuttle/engine/E as() in shuttle_engines)
		var/obj/machinery/atmospherics/components/unary/shuttle/heater/shuttle_heater = E.attached_heater?.resolve()
		if(!shuttle_heater)
			continue
		var/datum/gas_mixture/air_contents = shuttle_heater.airs[1]
		var/moles = air_contents.total_moles()
		amount += moles
	return amount

/obj/machinery/computer/shuttle_flight/custom_shuttle/proc/linkShuttle(var/new_id)
	shuttleId = new_id
	shuttlePortId = "[shuttleId]_custom_dock"

/obj/machinery/computer/shuttle_flight/custom_shuttle/proc/calculateStats(var/useFuel = FALSE)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(!M)
		return FALSE
	//Reset data
	calculated_mass = 0
	calculated_dforce = 0
	calculated_acceleration = 0
	calculated_engine_count = 0
	calculated_consumption = 0
	calculated_cooldown = 0
	calculated_fuel_less_thrusters = 0
	calculated_non_operational_thrusters = 0
	shuttle_engines = list()
	//Calculate all the data
	var/list/areas = M.shuttle_areas
	for(var/shuttleArea in areas)
		for(var/turf/T in shuttleArea)
			calculated_mass += 1
	for(var/obj/machinery/shuttle/engine/E in GLOB.custom_shuttle_machines)
		if(!(get_area(E) in areas))
			continue
		E.check_setup()
		if(!E.thruster_active)	//Skipover thrusters with no valid heater
			calculated_non_operational_thrusters ++
			continue
		calculated_engine_count++
		calculated_dforce += E.thrust
		calculated_consumption += E.fuel_use
		calculated_cooldown = max(calculated_cooldown, E.cooldown)
		shuttle_engines += E
	//This should really be accelleration, but its a 2d spessman game so who cares
	if(calculated_mass == 0)
		return FALSE
	calculated_acceleration = (calculated_dforce*1000) / (calculated_mass*100)
	return TRUE

/obj/machinery/computer/shuttle_flight/custom_shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(port && (shuttleId == initial(shuttleId) || override))
		linkShuttle(port.id)

/obj/machinery/shuttle
	name = "shuttle component"
	desc = "Something for shuttles."
	density = TRUE
	obj_integrity = 250
	max_integrity = 250
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "burst_plasma"
	idle_power_usage = 150
	circuit = /obj/item/circuitboard/machine/shuttle/engine
	var/icon_state_closed = "burst_plasma"
	var/icon_state_open = "burst_plasma_open"
	var/icon_state_off = "burst_plasma_off"

/obj/machinery/shuttle/Initialize()
	. = ..()
	GLOB.custom_shuttle_machines += src

/obj/machinery/shuttle/Destroy()
	. = ..()
	GLOB.custom_shuttle_machines -= src

/obj/machinery/shuttle/attackby(obj/item/I, mob/living/user, params)
	if(default_deconstruction_screwdriver(user, icon_state_open, icon_state_closed, I))
		return
	if(default_pry_open(I))
		return
	if(panel_open)
		if(default_change_direction_wrench(user, I))
			return
	if(default_deconstruction_crowbar(I))
		return
	return ..()
