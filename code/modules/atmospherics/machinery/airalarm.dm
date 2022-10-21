// A datum for dealing with threshold limit values
/datum/tlv
	var/warning_min
	var/warning_max
	var/hazard_min
	var/hazard_max

/datum/tlv/New(min2 as num, min1 as num, max1 as num, max2 as num)
	if(min2)
		hazard_min = min2
	if(min1)
		warning_min = min1
	if(max1)
		warning_max = max1
	if(max2)
		hazard_max = max2

/datum/tlv/proc/get_danger_level(val)
	if(hazard_max != TLV_DONT_CHECK && val >= hazard_max)
		return TLV_OUTSIDE_HAZARD_LIMIT
	if(hazard_min != TLV_DONT_CHECK && val <= hazard_min)
		return TLV_OUTSIDE_HAZARD_LIMIT
	if(warning_max != TLV_DONT_CHECK && val >= warning_max)
		return TLV_OUTSIDE_WARNING_LIMIT
	if(warning_min != TLV_DONT_CHECK && val <= warning_min)
		return TLV_OUTSIDE_WARNING_LIMIT

	return TLV_NO_DANGER

/datum/tlv/no_checks
	hazard_min = TLV_DONT_CHECK
	warning_min = TLV_DONT_CHECK
	warning_max = TLV_DONT_CHECK
	hazard_max = TLV_DONT_CHECK

/datum/tlv/dangerous
	hazard_min = TLV_DONT_CHECK
	warning_min = TLV_DONT_CHECK
	warning_max = 0.2
	hazard_max = 0.5

/obj/item/electronics/airalarm
	name = "плата контроллера воздуха"
	icon_state = "airalarm_electronics"

/obj/item/wallframe/airalarm
	name = "рамка контроллера воздуха"
	desc = "Используется для создания контроллера воздуха."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm_bitem"
	result_path = /obj/machinery/airalarm

#define AALARM_MODE_SCRUBBING 1
#define AALARM_MODE_VENTING 2 //makes draught
#define AALARM_MODE_PANIC 3 //like siphon, but stronger (enables widenet)
#define AALARM_MODE_REPLACEMENT 4 //sucks off all air, then refill and swithes to scrubbing
#define AALARM_MODE_OFF 5
#define AALARM_MODE_FLOOD 6 //Emagged mode; turns off scrubbers and pressure checks on vents
#define AALARM_MODE_SIPHON 7 //Scrubbers suck air
#define AALARM_MODE_CONTAMINATED 8 //Turns on all filtering and widenet scrubbing.
#define AALARM_MODE_REFILL 9 //just like normal, but with triple the air output

#define AALARM_REPORT_TIMEOUT 100

/obj/machinery/airalarm
	name = "контроллер воздуха"
	desc = "Устройство, которое управляет атмосферой в отсеке."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarmp"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.02
	power_channel = AREA_USAGE_ENVIRON
	req_access = list(ACCESS_ATMOSPHERICS)
	max_integrity = 250
	integrity_failure = 0.33
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 90, ACID = 30)
	resistance_flags = FIRE_PROOF

	var/danger_level = 0
	var/mode = AALARM_MODE_CONTAMINATED
	///A reference to the area we are in
	var/area/my_area

	var/locked = TRUE
	var/aidisabled = 0
	var/shorted = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone

	var/frequency = FREQ_ATMOS_CONTROL
	var/alarm_frequency = FREQ_ATMOS_ALARMS
	var/datum/radio_frequency/radio_connection
	///Represents a signel source of atmos alarms, complains to all the listeners if one of our thresholds is violated
	var/datum/alarm_handler/alarm_manager

	var/static/list/atmos_connections = list(COMSIG_TURF_EXPOSE = .proc/check_air_dangerlevel)

	var/list/TLV = list( // Breathable air.
		"pressure" = new/datum/tlv(HAZARD_LOW_PRESSURE, WARNING_LOW_PRESSURE, WARNING_HIGH_PRESSURE, HAZARD_HIGH_PRESSURE), // kPa. Values are hazard_min, warning_min, warning_max, hazard_max
		"temperature" = new/datum/tlv(BODYTEMP_COLD_WARNING_1, BODYTEMP_COLD_WARNING_1+10, BODYTEMP_HEAT_WARNING_1-27, BODYTEMP_HEAT_WARNING_1),
		GAS_O2 = new/datum/tlv(16, 19, 135, 140), // Partial pressure, kpa
		GAS_N2 = new/datum/tlv(-1, -1, 1000, 1000),
		GAS_CO2 = new/datum/tlv(-1, -1, 5, 10),
		GAS_MIASMA = new/datum/tlv/(-1, -1, 15, 30),
		GAS_PLASMA = new/datum/tlv/dangerous,
		GAS_NITROUS = new/datum/tlv/dangerous,
		GAS_BZ = new/datum/tlv/dangerous,
		GAS_HYPERNOB = new/datum/tlv(-1, -1, 1000, 1000), // Hyper-Noblium is inert and nontoxic
		GAS_H2O = new/datum/tlv/dangerous,
		GAS_TRITIUM = new/datum/tlv/dangerous,
		GAS_STIMULUM = new/datum/tlv/dangerous,
		GAS_NITRYL = new/datum/tlv/dangerous,
		GAS_PLUOXIUM = new/datum/tlv(-1, -1, 1000, 1000), // Unlike oxygen, pluoxium does not fuel plasma/tritium fires
		GAS_FREON = new/datum/tlv/dangerous,
		GAS_HYDROGEN = new/datum/tlv/dangerous,
		GAS_HEALIUM = new/datum/tlv/dangerous,
		GAS_PROTO_NITRATE = new/datum/tlv/dangerous,
		GAS_ZAUKER = new/datum/tlv/dangerous,
		GAS_HELIUM = new/datum/tlv/dangerous,
		GAS_ANTINOBLIUM = new/datum/tlv/dangerous,
		GAS_HALON = new/datum/tlv/dangerous
	)

/obj/machinery/airalarm/New(loc, ndir, nbuild)
	..()
	wires = new /datum/wires/airalarm(src)
	if(ndir)
		setDir(ndir)

	if(nbuild)
		buildstage = 0
		panel_open = TRUE
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir == 1 ? -24 : 24) : 0

	update_appearance()

	alarm_manager = new(src)
	my_area = get_area(src)
	update_appearance()

/obj/machinery/airalarm/Destroy()
	if(my_area)
		my_area = null
	SSradio.remove_object(src, frequency)
	QDEL_NULL(wires)
	QDEL_NULL(alarm_manager)
	return ..()

/obj/machinery/airalarm/Initialize(mapload)
	. = ..()
	set_frequency(frequency)
	AddElement(/datum/element/connect_loc, atmos_connections)
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/air_alarm,
	))

/obj/machinery/airalarm/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "Отвечает за зону: <i>[get_area_name(src)]</i>"
	. += "<hr>"
	switch(buildstage)
		if(0)
			. += span_notice("Отсутствует плата.")
		if(1)
			. += span_notice("Не хватает проводов")
		if(2)
			. += span_notice("ПКМ, чтобы [locked ? "разблокировать" : "заблокировать"] интерфейс.")

/obj/machinery/airalarm/ui_status(mob/user)
	if(user.has_unlimited_silicon_privilege && aidisabled)
		to_chat(user, "Управление для ИИ отключено.")
	else if(!shorted)
		return ..()
	return UI_CLOSE


/obj/machinery/airalarm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirAlarm", name)
		ui.open()

/obj/machinery/airalarm/ui_data(mob/user)
	var/data = list(
		"locked" = locked,
		"siliconUser" = user.has_unlimited_silicon_privilege,
		"emagged" = (obj_flags & EMAGGED ? 1 : 0),
		"danger_level" = danger_level,
	)

	data["atmos_alarm"] = !!my_area.active_alarms[ALARM_ATMOS]
	data["fire_alarm"] = my_area.fire

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	var/datum/tlv/cur_tlv

	data["environment_data"] = list()
	var/pressure = environment.return_pressure()
	cur_tlv = TLV["pressure"]
	data["environment_data"] += list(list(
		"name" = "Давление",
		"value" = pressure,
		"unit" = "кПа",
		"danger_level" = cur_tlv.get_danger_level(pressure)
	))
	var/temperature = environment.return_temperature()
	cur_tlv = TLV["temperature"]
	data["environment_data"] += list(list(
		"name" = "Температура",
		"value" = temperature,
		"unit" = "K ([round(temperature - T0C, 0.1)]C)",
		"danger_level" = cur_tlv.get_danger_level(temperature)
	))
	var/total_moles = environment.total_moles()
	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.return_temperature() / environment.return_volume()
	for(var/gas_id in environment.get_gases())
		if(!(gas_id in TLV)) // We're not interested in this gas, it seems.
			continue
		cur_tlv = TLV[gas_id]
		data["environment_data"] += list(list(
			"name" = GLOB.gas_data.names[gas_id],
			"value" = environment.get_moles(gas_id) / total_moles * 100,
			"unit" = "%",
			"danger_level" = cur_tlv.get_danger_level(environment.get_moles(gas_id) * partial_pressure)
		))

	if(!locked || user.has_unlimited_silicon_privilege)
		data["vents"] = list()
		for(var/id_tag in my_area.air_vent_info)
			var/long_name = GLOB.air_vent_names[id_tag]
			var/list/info = my_area.air_vent_info[id_tag]
			if(!info || info["frequency"] != frequency)
				continue
			data["vents"] += list(list(
					"id_tag"	= id_tag,
					"long_name" = sanitize(long_name),
					"power"		= info["power"],
					"checks"	= info["checks"],
					"excheck"	= info["checks"]&1,
					"incheck"	= info["checks"]&2,
					"direction"	= info["direction"],
					"external"	= info["external"],
					"internal"	= info["internal"],
					"extdefault"= (info["external"] == ONE_ATMOSPHERE),
					"intdefault"= (info["internal"] == 0)
				))
		data["scrubbers"] = list()
		for(var/id_tag in my_area.air_scrub_info)
			var/long_name = GLOB.air_scrub_names[id_tag]
			var/list/info = my_area.air_scrub_info[id_tag]
			if(!info || info["frequency"] != frequency)
				continue
			data["scrubbers"] += list(list(
					"id_tag"				= id_tag,
					"long_name" 			= sanitize(long_name),
					"power"					= info["power"],
					"scrubbing"				= info["scrubbing"],
					"widenet"				= info["widenet"],
					"filter_types"			= info["filter_types"]
				))
		data["mode"] = mode
		data["modes"] = list()
		data["modes"] += list(list("name" = "Фильтрация - откачивает все вредные газы", 		"mode" = AALARM_MODE_SCRUBBING,		"selected" = mode == AALARM_MODE_SCRUBBING, 	"danger" = 0))
		data["modes"] += list(list("name" = "Чистка - откачивает все вредные газы БЫСТРО",		"mode" = AALARM_MODE_CONTAMINATED,	"selected" = mode == AALARM_MODE_CONTAMINATED,	"danger" = 0))
		data["modes"] += list(list("name" = "Перекачка - откачивает воздух, пока вкачивает новый","mode" = AALARM_MODE_VENTING,		"selected" = mode == AALARM_MODE_VENTING,		"danger" = 0))
		data["modes"] += list(list("name" = "Закачка х3 - тройная скорость наполнения",			"mode" = AALARM_MODE_REFILL,		"selected" = mode == AALARM_MODE_REFILL,		"danger" = 1))
		data["modes"] += list(list("name" = "Цикл - откачивает весь воздух и потом наполняет", 	"mode" = AALARM_MODE_REPLACEMENT,	"selected" = mode == AALARM_MODE_REPLACEMENT, 	"danger" = 1))
		data["modes"] += list(list("name" = "Откачка - откачивает воздух из помещения", 		"mode" = AALARM_MODE_SIPHON,		"selected" = mode == AALARM_MODE_SIPHON, 		"danger" = 1))
		data["modes"] += list(list("name" = "Быстрая откачка - откачивает воздух быстро",		"mode" = AALARM_MODE_PANIC,		"selected" = mode == AALARM_MODE_PANIC, 		"danger" = 1))
		data["modes"] += list(list("name" = "Выключить - отключает вентиляцию полностью", 		"mode" = AALARM_MODE_OFF,			"selected" = mode == AALARM_MODE_OFF, 			"danger" = 0))
		if(obj_flags & EMAGGED)
			data["modes"] += list(list("name" = "Наполнение - вырубает откачку и начинает наполнение",	"mode" = AALARM_MODE_FLOOD,			"selected" = mode == AALARM_MODE_FLOOD, 		"danger" = 1))

		var/datum/tlv/selected
		var/list/thresholds = list()

		selected = TLV["pressure"]
		thresholds += list(list("name" = "Давление", "settings" = list()))
		thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = "hazard_min", "selected" = selected.hazard_min))
		thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = "warning_min", "selected" = selected.warning_min))
		thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = "warning_max", "selected" = selected.warning_max))
		thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = "hazard_max", "selected" = selected.hazard_max))

		selected = TLV["temperature"]
		thresholds += list(list("name" = "Температура", "settings" = list()))
		thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = "hazard_min", "selected" = selected.hazard_min))
		thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = "warning_min", "selected" = selected.warning_min))
		thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = "warning_max", "selected" = selected.warning_max))
		thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = "hazard_max", "selected" = selected.hazard_max))

		for(var/gas_id in GLOB.gas_data.names)
			if(!(gas_id in TLV)) // We're not interested in this gas, it seems.
				continue
			selected = TLV[gas_id]
			thresholds += list(list("name" = GLOB.gas_data.names[gas_id], "settings" = list()))
			thresholds[thresholds.len]["settings"] += list(list("env" = gas_id, "val" = "hazard_min", "selected" = selected.hazard_min))
			thresholds[thresholds.len]["settings"] += list(list("env" = gas_id, "val" = "warning_min", "selected" = selected.warning_min))
			thresholds[thresholds.len]["settings"] += list(list("env" = gas_id, "val" = "warning_max", "selected" = selected.warning_max))
			thresholds[thresholds.len]["settings"] += list(list("env" = gas_id, "val" = "hazard_max", "selected" = selected.hazard_max))

		data["thresholds"] = thresholds
	return data

/obj/machinery/airalarm/ui_act(action, params)
	. = ..()

	if(. || buildstage != 2)
		return
	if((locked && !usr.has_unlimited_silicon_privilege) || (usr.has_unlimited_silicon_privilege && aidisabled))
		return
	var/device_id = params["id_tag"]
	switch(action)
		if("lock")
			if(usr.has_unlimited_silicon_privilege && !wires.is_cut(WIRE_IDSCAN))
				locked = !locked
				. = TRUE
		if("power", "toggle_filter", "widenet", "scrubbing", "direction")
			send_signal(device_id, list("[action]" = params["val"]), usr)
			. = TRUE
		if("excheck")
			send_signal(device_id, list("checks" = text2num(params["val"])^1), usr)
			. = TRUE
		if("incheck")
			send_signal(device_id, list("checks" = text2num(params["val"])^2), usr)
			. = TRUE
		if("set_external_pressure", "set_internal_pressure")
			var/target = params["value"]
			if(!isnull(target))
				send_signal(device_id, list("[action]" = target), usr)
				. = TRUE
		if("reset_external_pressure")
			send_signal(device_id, list("reset_external_pressure"), usr)
			. = TRUE
		if("reset_internal_pressure")
			send_signal(device_id, list("reset_internal_pressure"), usr)
			. = TRUE
		if("threshold")
			var/env = params["env"]
			if(text2path(env))
				env = text2path(env)

			var/name = params["var"]
			var/datum/tlv/tlv = TLV[env]
			if(isnull(tlv))
				return
			var/value = input("Новое [name] для [env]:", name, tlv.vars[name]) as num|null
			if(!isnull(value) && !..())
				if(value < 0)
					tlv.vars[name] = -1
				else
					tlv.vars[name] = round(value, 0.01)
				investigate_log(" treshold value for [env]:[name] was set to [value] by [key_name(usr)]",INVESTIGATE_ATMOS)
				var/turf/our_turf = get_turf(src)
				var/datum/gas_mixture/environment = our_turf.return_air()
				check_air_dangerlevel(our_turf, environment, environment.return_temperature())
				. = TRUE
		if("mode")
			mode = text2num(params["mode"])
			investigate_log("was turned to [get_mode_name(mode)] mode by [key_name(usr)]",INVESTIGATE_ATMOS)
			apply_mode(usr)
			. = TRUE
		if("alarm")
			if(alarm_manager.send_alarm(ALARM_ATMOS))
				post_alert(2)
			. = TRUE
		if("reset")
			if(alarm_manager.clear_alarm(ALARM_ATMOS))
				post_alert(0)
			. = TRUE
	update_appearance()


/obj/machinery/airalarm/proc/reset(wire)
	switch(wire)
		if(WIRE_POWER)
			if(!wires.is_cut(WIRE_POWER))
				shorted = FALSE
				update_appearance()
		if(WIRE_AI)
			if(!wires.is_cut(WIRE_AI))
				aidisabled = FALSE


/obj/machinery/airalarm/proc/shock(mob/user, prb)
	if((machine_stat & (NOPOWER)))		// unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE //you lucked out, no shock for you
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start() //sparks always.
	if (electrocute_mob(user, get_area(src), src, 1, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/airalarm/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/machinery/airalarm/proc/send_signal(target, list/command, atom/user)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return FALSE

	var/datum/signal/signal = new(command)
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"
	signal.data["user"] = user
	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)

	return TRUE

/obj/machinery/airalarm/proc/get_mode_name(mode_value)
	switch(mode_value)
		if(AALARM_MODE_SCRUBBING)
			return "Filtering"
		if(AALARM_MODE_CONTAMINATED)
			return "Contaminated"
		if(AALARM_MODE_VENTING)
			return "Draught"
		if(AALARM_MODE_REFILL)
			return "Refill"
		if(AALARM_MODE_PANIC)
			return "Panic Siphon"
		if(AALARM_MODE_REPLACEMENT)
			return "Cycle"
		if(AALARM_MODE_SIPHON)
			return "Siphon"
		if(AALARM_MODE_OFF)
			return "Off"
		if(AALARM_MODE_FLOOD)
			return "Flood"

/obj/machinery/airalarm/proc/apply_mode(atom/signal_source)
	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"set_filters" = list(GAS_CO2, GAS_BZ),
					"scrubbing" = 1,
					"widenet" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 1,
					"checks" = 1,
					"set_external_pressure" = ONE_ATMOSPHERE
				), signal_source)
		if(AALARM_MODE_CONTAMINATED)
			var/list/all_gases = GLOB.gas_data.get_by_flag(GAS_FLAG_DANGEROUS)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"set_filters" = all_gases,
					"scrubbing" = 1,
					"widenet" = 1
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 1,
					"checks" = 1,
					"set_external_pressure" = ONE_ATMOSPHERE
				), signal_source)
		if(AALARM_MODE_VENTING)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"widenet" = 0,
					"scrubbing" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 1,
					"checks" = 1,
					"set_external_pressure" = ONE_ATMOSPHERE*2
				), signal_source)
		if(AALARM_MODE_REFILL)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"set_filters" = list(GAS_CO2),
					"scrubbing" = 1,
					"widenet" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 1,
					"checks" = 1,
					"set_external_pressure" = ONE_ATMOSPHERE * 3
				), signal_source)
		if(AALARM_MODE_PANIC,
			AALARM_MODE_REPLACEMENT)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"widenet" = 1,
					"scrubbing" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 0
				), signal_source)
		if(AALARM_MODE_SIPHON)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 1,
					"widenet" = 0,
					"scrubbing" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 0
				), signal_source)

		if(AALARM_MODE_OFF)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 0
				), signal_source)
		if(AALARM_MODE_FLOOD)
			for(var/device_id in my_area.air_scrub_info)
				send_signal(device_id, list(
					"power" = 0
				), signal_source)
			for(var/device_id in my_area.air_vent_info)
				send_signal(device_id, list(
					"power" = 1,
					"checks" = 2,
					"set_internal_pressure" = 0
				), signal_source)

/obj/machinery/airalarm/update_icon_state()
	if(panel_open)
		switch(buildstage)
			if(AIRALARM_BUILD_COMPLETE)
				icon_state = "alarmx"
			if(AIRALARM_BUILD_NO_WIRES)
				icon_state = "alarm_b2"
			if(AIRALARM_BUILD_NO_CIRCUIT)
				icon_state = "alarm_b1"
		return ..()

	icon_state = "alarmp"
	return ..()

/obj/machinery/airalarm/update_overlays()
	. = ..()

	if(panel_open || (machine_stat & (NOPOWER|BROKEN)) || shorted)
		return

	var/area/our_area = get_area(src)
	var/state
	switch(max(danger_level, !!our_area.active_alarms[ALARM_ATMOS]))
		if(0)
			state = "alarm0"
		if(1)
			state = "alarm2" //yes, alarm2 is yellow alarm
		if(2)
			state = "alarm1"

	. += mutable_appearance(icon, state)
	. += emissive_appearance(icon, state, src, alpha = src.alpha)

/**
 * main proc for throwing a shitfit if the air isnt right.
 * goes into warning mode if gas parameters are beyond the tlv warning bounds, goes into hazard mode if gas parameters are beyond tlv hazard bounds
 *
 */
/obj/machinery/airalarm/proc/check_air_dangerlevel(turf/location, datum/gas_mixture/environment, exposed_temperature)
	SIGNAL_HANDLER
	if((machine_stat & (NOPOWER|BROKEN)) || shorted)
		return

	var/datum/tlv/current_tlv
	//cache for sanic speed (lists are references anyways)
	var/list/cached_tlv = TLV

	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.return_temperature() / environment.return_volume()

	current_tlv = cached_tlv["pressure"]
	var/environment_pressure = environment.return_pressure()
	var/pressure_dangerlevel = current_tlv.get_danger_level(environment_pressure)

	current_tlv = cached_tlv["temperature"]
	var/temperature_dangerlevel = current_tlv.get_danger_level(exposed_temperature)

	var/gas_dangerlevel = 0
	for(var/gas_id in environment.get_gases())
		if(!(gas_id in cached_tlv)) // We're not interested in this gas, it seems.
			continue
		current_tlv = cached_tlv[gas_id]
		gas_dangerlevel = max(gas_dangerlevel, current_tlv.get_danger_level(environment.get_moles(gas_id) * partial_pressure))

	var/old_danger_level = danger_level
	danger_level = max(pressure_dangerlevel, temperature_dangerlevel, gas_dangerlevel)

	if(old_danger_level != danger_level)
		INVOKE_ASYNC(src, .proc/apply_danger_level)
	if(mode == AALARM_MODE_REPLACEMENT && environment_pressure < ONE_ATMOSPHERE * 0.05)
		mode = AALARM_MODE_SCRUBBING
		INVOKE_ASYNC(src, .proc/apply_mode, src)


/obj/machinery/airalarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(alarm_frequency)

	if(!frequency)
		return

	var/datum/signal/alert_signal = new(list(
		"zone" = get_area_name(src, TRUE),
		"type" = "Atmospheric"
	))
	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if (alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if (alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal, range = -1)

/obj/machinery/airalarm/proc/apply_danger_level()
	var/new_area_danger_level = 0
	for(var/obj/machinery/airalarm/AA in my_area)
		if (!(AA.machine_stat & (NOPOWER|BROKEN)) && !AA.shorted)
			new_area_danger_level = clamp(max(new_area_danger_level, AA.danger_level), 0, 1)

	var/did_anything_happen
	if(new_area_danger_level)
		did_anything_happen = alarm_manager.send_alarm(ALARM_ATMOS)
	else
		did_anything_happen = alarm_manager.clear_alarm(ALARM_ATMOS)
	if(did_anything_happen) //if something actually changed
		post_alert(new_area_danger_level)

	update_appearance()

/obj/machinery/airalarm/attackby(obj/item/W, mob/user, params)
	switch(buildstage)
		if(2)
			if(W.tool_behaviour == TOOL_WIRECUTTER && panel_open && wires.is_all_cut())
				W.play_tool_sound(src)
				to_chat(user, span_notice("Откусываю последние провода."))
				new /obj/item/stack/cable_coil(loc, 5)
				buildstage = 1
				update_appearance()
				return
			else if(W.tool_behaviour == TOOL_SCREWDRIVER)  // Opening that Air Alarm up.
				W.play_tool_sound(src)
				panel_open = !panel_open
				to_chat(user, span_notice("Провода теперь [panel_open ? "открыты" : "закрыты"]."))
				update_appearance()
				return
			else if(W.GetID())// trying to unlock the interface with an ID card
				togglelock(user)
				return
			else if(panel_open && is_wire_tool(W))
				wires.interact(user)
				return
		if(1)
			if(W.tool_behaviour == TOOL_CROWBAR)
				user.visible_message(span_notice("[user.name] вынимает плату из [src.name].") , \
									span_notice("Начинаю вытаскивать плату..."))
				W.play_tool_sound(src)
				if (W.use_tool(src, user, 20))
					if (buildstage == 1)
						to_chat(user, span_notice("Вынимаю плату."))
						new /obj/item/electronics/airalarm( src.loc )
						playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
						buildstage = 0
						update_appearance()
				return

			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/cable = W
				if(cable.get_amount() < 5)
					to_chat(user, span_warning("Надо бы чуть больше кабеля!"))
					return
				user.visible_message(span_notice("[user.name] подключает провода к контроллеру.") , \
									span_notice("Начинаю подключать провода к контролеру..."))
				if (do_after(user, 20, target = src))
					if (cable.get_amount() >= 5 && buildstage == 1)
						cable.use(5)
						to_chat(user, span_notice("Подключаю провода к контроллеру."))
						wires.repair()
						aidisabled = 0
						locked = FALSE
						mode = 1
						shorted = 0
						post_alert(0)
						buildstage = 2
						update_appearance()
				return
		if(0)
			if(istype(W, /obj/item/electronics/airalarm))
				if(user.temporarilyRemoveItemFromInventory(W))
					to_chat(user, span_notice("Вставляю плату."))
					buildstage = 1
					update_appearance()
					qdel(W)
				return

			if(istype(W, /obj/item/electroadaptive_pseudocircuit))
				var/obj/item/electroadaptive_pseudocircuit/P = W
				if(!P.adapt_circuit(user, 25))
					return
				user.visible_message(span_notice("[user] адаптирует плату и вставляет её в [src].") , \
				span_notice("Адаптирую плату и вставляю её внутрь."))
				buildstage = 1
				update_appearance()
				return

			if(W.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("Отсоединяю [src] от стены."))
				W.play_tool_sound(src)
				new /obj/item/wallframe/airalarm( user.loc )
				qdel(src)
				return

	return ..()

/obj/machinery/airalarm/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if((buildstage == 0) && (the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)
	return FALSE

/obj/machinery/airalarm/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_UPGRADE_SIMPLE_CIRCUITS)
			user.visible_message(span_notice("[user] адаптирует плату и вставляет её в [src].") , \
			span_notice("Адаптирую плату и вставляю её внутрь."))
			buildstage = 1
			update_appearance()
			return TRUE
	return FALSE

/obj/machinery/airalarm/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, !issilicon(user)) || !isturf(loc))
		return
	else
		togglelock(user)

/obj/machinery/airalarm/proc/togglelock(mob/living/user)
	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(user, span_warning("Ниче не пойму!"))
	else
		if(src.allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user, span_notice("[ locked ? "блокирую" : "разблокирую"] интерфейс контроллера воздуха."))
			updateUsrDialog()
		else
			to_chat(user, span_danger("Доступ запрещён."))
	return

/obj/machinery/airalarm/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	visible_message(span_warning("Искры вылетают из [src]!") , span_notice("Взламываю [src], вырубая его протоколы безопасности."))
	playsound(src, "zap", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/machinery/airalarm/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, 2)
		var/obj/item/I = new /obj/item/electronics/airalarm(loc)
		if(!disassembled)
			I.obj_integrity = I.max_integrity * 0.5
		new /obj/item/stack/cable_coil(loc, 3)
	qdel(src)

/obj/machinery/airalarm/server // No checks here.
	TLV = list(
		"pressure" = new/datum/tlv/no_checks,
		"temperature" = new/datum/tlv/no_checks,
		GAS_O2 = new/datum/tlv/no_checks,
		GAS_N2 = new/datum/tlv/no_checks,
		GAS_CO2 = new/datum/tlv/no_checks,
		GAS_MIASMA = new/datum/tlv/no_checks,
		GAS_PLASMA = new/datum/tlv/no_checks,
		GAS_NITROUS = new/datum/tlv/no_checks,
		GAS_BZ = new/datum/tlv/no_checks,
		GAS_HYPERNOB = new/datum/tlv/no_checks,
		GAS_H2O = new/datum/tlv/no_checks,
		GAS_TRITIUM = new/datum/tlv/no_checks,
		GAS_STIMULUM = new/datum/tlv/no_checks,
		GAS_NITRYL = new/datum/tlv/no_checks,
		GAS_PLUOXIUM = new/datum/tlv/no_checks,
		GAS_FREON = new/datum/tlv/no_checks,
		GAS_HYDROGEN = new/datum/tlv/no_checks,
		GAS_HEALIUM = new/datum/tlv/dangerous,
		GAS_PROTO_NITRATE = new/datum/tlv/dangerous,
		GAS_ZAUKER = new/datum/tlv/dangerous,
		GAS_HELIUM = new/datum/tlv/dangerous,
		GAS_ANTINOBLIUM = new/datum/tlv/dangerous,
		GAS_HALON = new/datum/tlv/dangerous
	)

/obj/machinery/airalarm/kitchen_cold_room // Kitchen cold rooms start off at -14°C or 259.15K.
	TLV = list(
		"pressure" = new/datum/tlv(ONE_ATMOSPHERE * 0.8, ONE_ATMOSPHERE *  0.9, ONE_ATMOSPHERE * 1.1, ONE_ATMOSPHERE * 1.2), // kPa
		"temperature" = new/datum/tlv(COLD_ROOM_TEMP-40, COLD_ROOM_TEMP-20, COLD_ROOM_TEMP+20, COLD_ROOM_TEMP+40),
		GAS_O2 = new/datum/tlv(16, 19, 135, 140), // Partial pressure, kpa
		GAS_N2 = new/datum/tlv(-1, -1, 1000, 1000),
		GAS_CO2 = new/datum/tlv(-1, -1, 5, 10),
		GAS_MIASMA = new/datum/tlv/(-1, -1, 2, 5),
		GAS_PLASMA = new/datum/tlv/dangerous,
		GAS_NITROUS = new/datum/tlv/dangerous,
		GAS_BZ = new/datum/tlv/dangerous,
		GAS_HYPERNOB = new/datum/tlv(-1, -1, 1000, 1000), // Hyper-Noblium is inert and nontoxic
		GAS_H2O = new/datum/tlv/dangerous,
		GAS_TRITIUM = new/datum/tlv/dangerous,
		GAS_STIMULUM = new/datum/tlv/dangerous,
		GAS_NITRYL = new/datum/tlv/dangerous,
		GAS_PLUOXIUM = new/datum/tlv(-1, -1, 1000, 1000), // Unlike oxygen, pluoxium does not fuel plasma/tritium fires
		GAS_FREON = new/datum/tlv/dangerous,
		GAS_HYDROGEN = new/datum/tlv/dangerous,
		GAS_HEALIUM = new/datum/tlv/dangerous,
		GAS_PROTO_NITRATE = new/datum/tlv/dangerous,
		GAS_ZAUKER = new/datum/tlv/dangerous,
		GAS_HELIUM = new/datum/tlv/dangerous,
		GAS_ANTINOBLIUM = new/datum/tlv/dangerous,
		GAS_HALON = new/datum/tlv/dangerous
	)

/obj/machinery/airalarm/unlocked
	locked = FALSE

/obj/machinery/airalarm/engine
	name = "котроллер воздуха в двигателе"
	locked = FALSE
	req_access = null
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE)

/obj/machinery/airalarm/mixingchamber
	name = "контроллер воздуха в смешивателе"
	locked = FALSE
	req_access = null
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_TOXINS)

/obj/machinery/airalarm/all_access
	name = "вседоступный контроллер воздуха"
	desc = "Похоже этот контроллер может использовать любой."
	locked = FALSE
	req_access = null
	req_one_access = null

/obj/machinery/airalarm/syndicate //general syndicate access
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/airalarm/away //general away mission access
	req_access = list(ACCESS_AWAY_GENERAL)

/obj/machinery/airalarm/directional/north //Pixel offsets get overwritten on New()
	dir = SOUTH
	pixel_y = 24

/obj/machinery/airalarm/directional/south
	dir = NORTH
	pixel_y = -24

/obj/machinery/airalarm/directional/east
	dir = WEST
	pixel_x = 24

/obj/machinery/airalarm/directional/west
	dir = EAST
	pixel_x = -24

/obj/item/circuit_component/air_alarm
	display_name = "Контроллер воздуха"
	desc = "Controls levels of gases and their temperature as well as all vents and scrubbers in the room."

	var/datum/port/input/option/air_alarm_options

	var/datum/port/input/min_2
	var/datum/port/input/min_1
	var/datum/port/input/max_1
	var/datum/port/input/max_2

	var/datum/port/input/request_data

	var/datum/port/output/pressure
	var/datum/port/output/temperature
	var/datum/port/output/gas_amount

	var/obj/machinery/airalarm/connected_alarm
	var/list/options_map

/obj/item/circuit_component/air_alarm/populate_ports()
	min_2 = add_input_port("Min 2", PORT_TYPE_NUMBER)
	min_1 = add_input_port("Min 1", PORT_TYPE_NUMBER)
	max_1 = add_input_port("Max 1", PORT_TYPE_NUMBER)
	max_2 = add_input_port("Max 2", PORT_TYPE_NUMBER)
	request_data = add_input_port("Request Atmosphere Data", PORT_TYPE_SIGNAL)

	pressure = add_output_port("Pressure", PORT_TYPE_NUMBER)
	temperature = add_output_port("Temperature", PORT_TYPE_NUMBER)
	gas_amount = add_output_port("Chosen Gas Amount", PORT_TYPE_NUMBER)

/obj/item/circuit_component/air_alarm/populate_options()
	var/static/list/component_options

	if(!component_options)
		component_options = list(
			"Pressure" = "pressure",
			"Temperature" = "temperature"
		)

		for(var/gas_id in GLOB.gas_data.ids)
			component_options[GLOB.gas_data.names[gas_id]] = gas_id

	air_alarm_options = add_option_port("Air Alarm Options", component_options)
	options_map = component_options

/obj/item/circuit_component/air_alarm/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/airalarm))
		connected_alarm = shell

/obj/item/circuit_component/air_alarm/unregister_usb_parent(atom/movable/shell)
	connected_alarm = null
	return ..()

/obj/item/circuit_component/air_alarm/input_received(datum/port/input/port)
	if(!connected_alarm || connected_alarm.locked)
		return

	var/current_option = air_alarm_options.value

	if(COMPONENT_TRIGGERED_BY(request_data, port))
		var/turf/alarm_turf = get_turf(connected_alarm)
		var/datum/gas_mixture/environment = alarm_turf.return_air()
		pressure.set_output(round(environment.return_pressure()))
		temperature.set_output(round(environment.return_temperature()))
		if(ispath(options_map[current_option]))
			gas_amount.set_output(round(environment.get_moles(options_map[current_option])))
		return

	var/datum/tlv/settings = connected_alarm.TLV[options_map[current_option]]
	settings.hazard_min = min_2
	settings.warning_min = min_1
	settings.warning_max = max_1
	settings.hazard_max = max_2

#undef AALARM_MODE_SCRUBBING
#undef AALARM_MODE_VENTING
#undef AALARM_MODE_PANIC
#undef AALARM_MODE_REPLACEMENT
#undef AALARM_MODE_OFF
#undef AALARM_MODE_FLOOD
#undef AALARM_MODE_SIPHON
#undef AALARM_MODE_CONTAMINATED
#undef AALARM_MODE_REFILL
#undef AALARM_REPORT_TIMEOUT
