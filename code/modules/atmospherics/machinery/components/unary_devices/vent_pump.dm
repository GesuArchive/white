#define EXT_BOUND	1
#define INT_BOUND	2
#define NO_BOUND	3

#define SIPHONING	0
#define RELEASING	1

/obj/machinery/atmospherics/components/unary/vent_pump
	icon_state = "vent_map-3"

	name = "вентиляция"
	desc = "К нему прикручены вентиль и помпа."

	use_power = IDLE_POWER_USE
	can_unwrench = TRUE
	welded = FALSE
	layer = GAS_SCRUBBER_LAYER
	hide = TRUE
	shift_underlay_only = FALSE

	var/pump_direction = RELEASING

	var/pressure_checks = EXT_BOUND
	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0
	// EXT_BOUND: Do not pass external_pressure_bound
	// INT_BOUND: Do not pass internal_pressure_bound
	// NO_BOUND: Do not pass either

	var/fast_fill = TRUE
	var/space_detection = TRUE
	var/space_shutoff_ticks = 0
	var/last_moles
	var/last_moles_added

	var/frequency = FREQ_ATMOS_CONTROL
	var/datum/radio_frequency/radio_connection
	var/radio_filter_out
	var/radio_filter_in

	var/obj/machinery/advanced_airlock_controller/aac = null

	pipe_state = "uvent"

/obj/machinery/atmospherics/components/unary/vent_pump/New()
	if(!id_tag)
		id_tag = SSnetworks.assign_random_name()
	//var/datum/gas_mixture/N = airs[1]
	//N.set_volume(1000) // Increase the volume of the air vent's node.
	// Allows it to pump much faster.
	. = ..()

/obj/machinery/atmospherics/components/unary/vent_pump/Destroy()
	var/area/vent_area = get_area(src)
	if(vent_area)
		vent_area.air_vent_info -= id_tag
		GLOB.air_vent_names -= id_tag
	if(aac)
		aac.vents -= src

	SSradio.remove_object(src,frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/components/unary/vent_pump/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = getpipeimage(icon, "vent_cap", initialize_directions)
		add_overlay(cap)
	else
		PIPING_LAYER_SHIFT(src, PIPING_LAYER_DEFAULT)

	if(welded)
		icon_state = "vent_welded"
		return

	if(!nodes[1] || !on || !is_operational)
		if(icon_state == "vent_welded")
			icon_state = "vent_off"
			return

		if(pump_direction & RELEASING)
			icon_state = "vent_out-off"
		else // pump_direction == SIPHONING
			icon_state = "vent_in-off"
		return

	if(icon_state == ("vent_out-off" || "vent_in-off" || "vent_off"))
		if(pump_direction & RELEASING)
			icon_state = "vent_out"
			flick("vent_out-starting", src)
		else // pump_direction == SIPHONING
			icon_state = "vent_in"
			flick("vent_in-starting", src)
		return

	if(pump_direction & RELEASING)
		icon_state = "vent_out"
	else // pump_direction == SIPHONING
		icon_state = "vent_in"

/obj/machinery/atmospherics/components/unary/vent_pump/process_atmos()
	..()
	if(!is_operational)
		last_moles_added = 0
		return
	if(space_shutoff_ticks > 0)
		space_shutoff_ticks--
		if(space_shutoff_ticks <= 1 && !on)
			on = TRUE
			update_icon()
	if(!nodes[1])
		on = FALSE
	if(!on || welded)
		last_moles_added = 0
		return
	var/turf/open/us = loc
	if(!istype(us))
		return
	var/datum/gas_mixture/air_contents = airs[1]
	var/datum/gas_mixture/environment = us.return_air()
	var/environment_pressure = environment.return_pressure()
	var/environment_moles = environment.total_moles()
	var/last_moles_real_added = environment_moles - last_moles
	if(last_moles_added > 0 && environment_moles == 0 && space_detection)
		// looks like we have a S P A C E problem.
		last_moles_added = 0
		on = FALSE
		space_shutoff_ticks = 20 // shut off for about 20 seconds before trying again.
		update_icon()
		return

	if(pump_direction & RELEASING) // internal -> external
		var/pressure_delta = 10000

		if(pressure_checks&EXT_BOUND)
			var/multiplier = 1 // fast_fill multiplier
			if(fast_fill)
				if(last_moles_added > 0 && last_moles_real_added > 0)
					multiplier = clamp(last_moles_added / last_moles_real_added * 0.25, 1, 100)
				else if(last_moles_added > 0 && last_moles_real_added < 0 && environment_moles != 0)
					multiplier = 10 // pressure is going down, but let's fight it anyways
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure) * multiplier)
		if(pressure_checks&INT_BOUND)
			pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))
		if(space_shutoff_ticks > 0) // if we just came off a space-shutoff, only transfer a little bit.
			pressure_delta = min(pressure_delta, 10)

		if(pressure_delta > 0)
			if(air_contents.return_temperature() > 0)
				var/transfer_moles = pressure_delta*environment.return_volume()/(air_contents.return_temperature() * R_IDEAL_GAS_EQUATION)
				last_moles_added = transfer_moles

				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

				loc.assume_air(removed)
				air_update_turf(FALSE, FALSE)

	else // external -> internal
		last_moles_added = 0
		if(environment.return_pressure() > 0)
			var/our_multiplier = air_contents.return_volume() / (environment.return_temperature() * R_IDEAL_GAS_EQUATION)
			var/moles_delta = 10000 * our_multiplier
			if(pressure_checks&EXT_BOUND)
				moles_delta = min(moles_delta, (environment_pressure - external_pressure_bound) * environment.return_volume() / (environment.return_temperature() * R_IDEAL_GAS_EQUATION))
			if(pressure_checks&INT_BOUND)
				moles_delta = min(moles_delta, (internal_pressure_bound - air_contents.return_pressure()) * our_multiplier)

			if(moles_delta > 0)
				var/datum/gas_mixture/removed = loc.remove_air(moles_delta)
				if (isnull(removed)) // in space
					return

				air_contents.merge(removed)
				air_update_turf()
	last_moles = environment_moles
	update_parents()

//Radio remote control

/obj/machinery/atmospherics/components/unary/vent_pump/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency,radio_filter_in)

/obj/machinery/atmospherics/components/unary/vent_pump/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"frequency" = frequency,
		"device" = "VP",
		"timestamp" = world.time,
		"power" = on,
		"direction" = pump_direction,
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"sigtype" = "status"
	))

	var/area/vent_area = get_area(src)
	if(!GLOB.air_vent_names[id_tag])
		// If we do not have a name, assign one.
		// Produces names like "Port Quarter Solar vent pump hZ2l6".
		name = "вентиляция [id_tag]"
		GLOB.air_vent_names[id_tag] = name

	vent_area.air_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)


/obj/machinery/atmospherics/components/unary/vent_pump/atmosinit()
	//some vents work his own spesial way
	radio_filter_in = frequency==FREQ_ATMOS_CONTROL?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==FREQ_ATMOS_CONTROL?(RADIO_TO_AIRALARM):null
	if(frequency)
		set_frequency(frequency)
	broadcast_status()
	..()

/obj/machinery/atmospherics/components/unary/vent_pump/receive_signal(datum/signal/signal)
	if(!is_operational)
		return
	// log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/components/unary/vent_pump/receive_signal([signal.debug_print()])")
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return

	var/atom/signal_sender = signal.data["user"]

	if("purge" in signal.data)
		pressure_checks &= ~EXT_BOUND
		pump_direction = SIPHONING

	if("stabilize" in signal.data)
		pressure_checks |= EXT_BOUND
		pump_direction = RELEASING

	if("power" in signal.data)
		on = text2num(signal.data["power"])
		space_shutoff_ticks = 0

	if("power_toggle" in signal.data)
		on = !on
		space_shutoff_ticks = 0

	if("checks" in signal.data)
		var/old_checks = pressure_checks
		pressure_checks = text2num(signal.data["checks"])
		if(pressure_checks != old_checks)
			investigate_log(" pressure checks were set to [pressure_checks] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("checks_toggle" in signal.data)
		pressure_checks = (pressure_checks?0:NO_BOUND)

	if("direction" in signal.data)
		pump_direction = text2num(signal.data["direction"])

	if("set_internal_pressure" in signal.data)
		var/old_pressure = internal_pressure_bound
		internal_pressure_bound = clamp(text2num(signal.data["set_internal_pressure"]),0,ONE_ATMOSPHERE*50)
		if(old_pressure != internal_pressure_bound)
			investigate_log(" internal pressure was set to [internal_pressure_bound] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("set_external_pressure" in signal.data)
		var/old_pressure = external_pressure_bound
		external_pressure_bound = clamp(text2num(signal.data["set_external_pressure"]),0,ONE_ATMOSPHERE*50)
		if(old_pressure != external_pressure_bound)
			investigate_log(" external pressure was set to [external_pressure_bound] by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("reset_external_pressure" in signal.data)
		external_pressure_bound = ONE_ATMOSPHERE

	if("reset_internal_pressure" in signal.data)
		internal_pressure_bound = 0

	if("adjust_internal_pressure" in signal.data)
		internal_pressure_bound = clamp(internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),0,ONE_ATMOSPHERE*50)

	if("adjust_external_pressure" in signal.data)
		external_pressure_bound = clamp(external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),0,ONE_ATMOSPHERE*50)

	if("init" in signal.data)
		name = signal.data["init"]
		return

	if("status" in signal.data)
		broadcast_status()
		return // do not update_icon

		// log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	broadcast_status()
	update_icon()

/obj/machinery/atmospherics/components/unary/vent_pump/welder_act(mob/living/user, obj/item/I)
	..()
	if(!I.tool_start_check(user, amount=0))
		return TRUE
	to_chat(user, span_notice("Начинаю заваривать вентиляцию..."))
	if(I.use_tool(src, user, 20, volume=50))
		if(!welded)
			user.visible_message(span_notice("[user] заваривает вентиляцию намертво.") , span_notice("Завариваю ветиляцию намертво.") , span_hear("Слышу сварку."))
			welded = TRUE
		else
			user.visible_message(span_notice("[user] разваривает вентиляцию.") , span_notice("Развариваю вентиляцию.") , span_hear("Слышу сварку."))
			welded = FALSE
		update_icon()
		pipe_vision_img = image(src, loc, layer = ABOVE_HUD_LAYER, dir = dir)
		pipe_vision_img.plane = ABOVE_HUD_PLANE
		investigate_log("was [welded ? "welded shut" : "unwelded"] by [key_name(user)]", INVESTIGATE_ATMOS)
		add_fingerprint(user)
	return TRUE

/obj/machinery/atmospherics/components/unary/vent_pump/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("Не могу открутить [src.name], сначала нужно выключить это!"))
		return FALSE

/obj/machinery/atmospherics/components/unary/vent_pump/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "Отвечает за зону: <i>[get_area_name(get_area(src), TRUE)]</i>"
	if(welded)
		. += "<hr>Она заварена намертво."

/obj/machinery/atmospherics/components/unary/vent_pump/power_change()
	. = ..()
	update_icon_nopipes()

/obj/machinery/atmospherics/components/unary/vent_pump/can_crawl_through()
	return !welded

/obj/machinery/atmospherics/components/unary/vent_pump/attack_alien(mob/user)
	if(!welded || !(do_after(user, 20, target = src)))
		return
	user.visible_message(span_warning("[user] яростно разрывает вентиляцию!") , span_notice("Удалось разблокировать доступ к вентиляции.") , span_hear("Слышу громкий лязг металла."))
	welded = FALSE
	update_icon()
	pipe_vision_img = image(src, loc, layer = ABOVE_HUD_LAYER, dir = dir)
	pipe_vision_img.plane = ABOVE_HUD_PLANE
	playsound(loc, 'sound/weapons/bladeslice.ogg', 100, TRUE)

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume
	name = "мощная вентиляция"
	power_channel = AREA_USAGE_EQUIP

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/New()
	..()
	var/datum/gas_mixture/air_contents = airs[1]
	air_contents.set_volume(1000)

// mapping

/obj/machinery/atmospherics/components/unary/vent_pump/layer2
	piping_layer = 2
	icon_state = "vent_map-2"

/obj/machinery/atmospherics/components/unary/vent_pump/layer4
	piping_layer = 4
	icon_state = "vent_map-4"

/obj/machinery/atmospherics/components/unary/vent_pump/on
	on = TRUE
	icon_state = "vent_map_on-3"

/obj/machinery/atmospherics/components/unary/vent_pump/on/layer2
	piping_layer = 2
	icon_state = "vent_map_on-2"

/obj/machinery/atmospherics/components/unary/vent_pump/on/layer4
	piping_layer = 4
	icon_state = "vent_map_on-4"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon
	pump_direction = SIPHONING
	pressure_checks = INT_BOUND
	internal_pressure_bound = 4000
	external_pressure_bound = 0

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/layer2
	piping_layer = 2
	icon_state = "vent_map-2"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/layer4
	piping_layer = 4
	icon_state = "vent_map-4"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/on
	on = TRUE
	icon_state = "vent_map_siphon_on-3"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/on/layer2
	piping_layer = 2
	icon_state = "vent_map_siphon_on-2"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/on/layer4
	piping_layer = 4
	icon_state = "vent_map_siphon_on-4"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos
	frequency = FREQ_ATMOS_STORAGE
	on = TRUE
	icon_state = "vent_map_siphon_on-3"

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/toxin_output
	name = "вентиляция из камеры с плазмой"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_PLAS
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/oxygen_output
	name = "вентиляция из камеры с кислородом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_O2
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/nitrogen_output
	name = "вентиляция из камеры с азотом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_N2
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/mix_output
	name = "вентиляция из камеры смешивания"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_MIX
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/nitrous_output
	name = "вентиляция из камеры с закисью азота"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_N2O
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/carbon_output
	name = "вентиляция из камеры с угарным газом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_CO2
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/bz_output
	name = "вентиляция из камеры с БЗ"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_BZ
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/freon_output
	name = "вентиляция из камеры с фреоном"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_FREON
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/halon_output
	name = "вентиляция из камеры с галоном"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_HALON
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/healium_output
	name = "вентиляция из камеры с хилиумом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_HEALIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/hydrogen_output
	name = "вентиляция из камеры с водородом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_H2
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/hypernoblium_output
	name = "вентиляция из камеры с гипер-ноблием"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_HYPERNOBLIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/miasma_output
	name = "вентиляция из камеры с миазмой"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_MIASMA
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/nitryl_output
	name = "вентиляция из камеры с нитрилом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_NO2
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/pluoxium_output
	name = "вентиляция из камеры с плюоксием"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_PLUOXIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/proto_nitrate_output
	name = "вентиляция из камеры с протонитратом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_PROTO_NITRATE
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/stimulum_output
	name = "вентиляция из камеры с стимулумом"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_STIMULUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/tritium_output
	name = "вентиляция из камеры с тритием"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_TRITIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/water_vapor_output
	name = "вентиляция из камеры с паром"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_H2O
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/zauker_output
	name = "вентиляция из камеры с циклоном Б"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_ZAUKER
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/helium_output
	name = "вентиляция из камеры с гелием"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_HELIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/antinoblium_output
	name = "вентиляция из камеры с антиноблием"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_ANTINOBLIUM
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/incinerator_output
	name = "вентиляция из камеры сжигателя"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_INCINERATOR
	frequency = FREQ_ATMOS_CONTROL
/obj/machinery/atmospherics/components/unary/vent_pump/siphon/atmos/toxins_mixing_output
	name = "вентиляция из камеры смешивания токсинов"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_ORDNANCE_LAB
	frequency = FREQ_ATMOS_CONTROL

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/layer2
	piping_layer = 2
	icon_state = "vent_map-2"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/layer4
	piping_layer = 4
	icon_state = "map_vent-4"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/on
	on = TRUE
	icon_state = "vent_map_on-3"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/on/layer2
	piping_layer = 2
	icon_state = "vent_map_on-2"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/on/layer4
	piping_layer = 4
	icon_state = "map_vent_on-4"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon
	pump_direction = SIPHONING
	pressure_checks = INT_BOUND
	internal_pressure_bound = 2000
	external_pressure_bound = 0

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/layer2
	piping_layer = 2
	icon_state = "vent_map-2"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/layer4
	piping_layer = 4
	icon_state = "map_vent-4"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/on
	on = TRUE
	icon_state = "vent_map_siphon_on-3"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/on/layer2
	piping_layer = 2
	icon_state = "vent_map_siphon_on-2"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/on/layer4
	piping_layer = 4
	icon_state = "vent_map_siphon_on-4"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/atmos
	frequency = FREQ_ATMOS_STORAGE
	on = TRUE
	icon_state = "vent_map_siphon_on-2"

/obj/machinery/atmospherics/components/unary/vent_pump/high_volume/siphon/atmos/air_output
	name = "вентиляция из камеры микса воздуха"
	id_tag = ATMOS_GAS_MONITOR_OUTPUT_AIR

#undef INT_BOUND
#undef EXT_BOUND
#undef NO_BOUND

#undef SIPHONING
#undef RELEASING
