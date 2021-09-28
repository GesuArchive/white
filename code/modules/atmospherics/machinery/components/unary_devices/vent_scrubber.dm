#define SIPHONING	0
#define SCRUBBING	1

/obj/machinery/atmospherics/components/unary/vent_scrubber
	icon_state = "scrub_map-3"

	name = "фильтр"
	desc = "К нему прикручены вентиль и помпа."
	use_power = IDLE_POWER_USE
	idle_power_usage = 100
	active_power_usage = 600
	can_unwrench = TRUE
	welded = FALSE
	layer = GAS_SCRUBBER_LAYER
	hide = TRUE
	shift_underlay_only = FALSE

	var/scrubbing = SCRUBBING //0 = siphoning, 1 = scrubbing

	var/filter_types = list(/datum/gas/carbon_dioxide)
	var/volume_rate = 200
	var/widenet = FALSE //is this scrubber acting on the 3x3 area around it.
	var/list/turf/adjacent_turfs = list()

	var/frequency = FREQ_ATMOS_CONTROL
	var/datum/radio_frequency/radio_connection
	var/radio_filter_out
	var/radio_filter_in

	pipe_state = "scrubber"

/obj/machinery/atmospherics/components/unary/vent_scrubber/New()
	if(!id_tag)
		id_tag = SSnetworks.assign_random_name()
	. = ..()
	for(var/f in filter_types)
		if(istext(f))
			filter_types -= f
			filter_types += gas_id2path(f)

/obj/machinery/atmospherics/components/unary/vent_scrubber/Destroy()
	var/area/scrub_area = get_area(src)
	if(scrub_area)
		scrub_area.air_scrub_info -= id_tag
		GLOB.air_scrub_names -= id_tag

	SSradio.remove_object(src,frequency)
	radio_connection = null
	adjacent_turfs.Cut()
	return ..()

/obj/machinery/atmospherics/components/unary/vent_scrubber/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = getpipeimage(icon, "scrub_cap", initialize_directions)
		add_overlay(cap)
	else
		PIPING_LAYER_SHIFT(src, PIPING_LAYER_DEFAULT)

	if(welded)
		icon_state = "scrub_welded"
		return

	if(!nodes[1] || !on || !is_operational)
		icon_state = "scrub_off"
		return

	if(scrubbing & SCRUBBING)
		if(widenet)
			icon_state = "scrub_wide"
		else
			icon_state = "scrub_on"
	else //scrubbing == SIPHONING
		icon_state = "scrub_purge"

/obj/machinery/atmospherics/components/unary/vent_scrubber/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/components/unary/vent_scrubber/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/list/f_types = list()
	for(var/path in GLOB.meta_gas_info)
		var/list/gas = GLOB.meta_gas_info[path]
		f_types += list(list("gas_id" = gas[META_GAS_ID], "gas_name" = gas[META_GAS_NAME], "enabled" = (path in filter_types)))

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"frequency" = frequency,
		"device" = "VS",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = scrubbing,
		"widenet" = widenet,
		"filter_types" = f_types,
		"sigtype" = "status"
	))

	var/area/scrub_area = get_area(src)
	if(!GLOB.air_scrub_names[id_tag])
		// If we do not have a name, assign one
		name = "фильтр [id_tag]"
		GLOB.air_scrub_names[id_tag] = name

	scrub_area.air_scrub_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)

	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/atmosinit()
	radio_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
	if(frequency)
		set_frequency(frequency)
	broadcast_status()
	check_turfs()
	..()

/obj/machinery/atmospherics/components/unary/vent_scrubber/process_atmos(delta_time)
	..()
	if(welded || !is_operational)
		return FALSE
	if(!nodes[1] || !on)
		on = FALSE
		return FALSE
	scrub(loc, delta_time)
	if(widenet)
		for(var/turf/tile in adjacent_turfs)
			scrub(tile, delta_time)
	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/scrub(turf/tile, delta_time = 0.5)
	if(!istype(tile))
		return FALSE
	var/datum/gas_mixture/environment = tile.return_air()
	var/datum/gas_mixture/air_contents = airs[1]

	if(air_contents?.return_pressure() >= 50 * ONE_ATMOSPHERE)
		return FALSE

	if(scrubbing & SCRUBBING)
		var/transfer_moles = min(1, volume_rate/environment.return_volume())*environment.total_moles()
		//Take a gas sample
		var/datum/gas_mixture/removed = tile.remove_air(transfer_moles)
		//Nothing left to remove from the tile
		if(isnull(removed))
			return FALSE

		removed.scrub_into(air_contents, filter_types)

		//Remix the resulting gases
		tile.assume_air(removed)
		tile.air_update_turf()

	else //Just siphoning all air

		var/transfer_moles = environment.total_moles()*(volume_rate/environment.return_volume())

		var/datum/gas_mixture/removed = tile.remove_air(transfer_moles)
		if(!air_contents)
			stack_trace("Блядь! Скраббер пытается сифонить несуществующий воздух. Скраббер: [src], тайл: [tile], координаты: [COORD(src)].")
		air_contents.merge(removed)
		tile.air_update_turf(FALSE, FALSE)

	update_parents()

	return TRUE

//There is no easy way for an object to be notified of changes to atmos can pass flags
//	So we check every machinery process (2 seconds)
/obj/machinery/atmospherics/components/unary/vent_scrubber/process()
	if(widenet)
		check_turfs()

//we populate a list of turfs with nonatmos-blocked cardinal turfs AND
//	diagonal turfs that can share atmos with *both* of the cardinal turfs

/obj/machinery/atmospherics/components/unary/vent_scrubber/check_turfs()
	adjacent_turfs.Cut()
	var/turf/T = get_turf(src)
	adjacent_turfs = T.GetAtmosAdjacentTurfs(alldir = TRUE)

/obj/machinery/atmospherics/components/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(!is_operational || !signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return

	var/old_widenet = widenet
	var/old_scrubbing = scrubbing
	var/old_filter_length = length(filter_types)

	var/atom/signal_sender = signal.data["user"]

	if("power" in signal.data)
		on = text2num(signal.data["power"])
	if("power_toggle" in signal.data)
		on = !on

	if("widenet" in signal.data)
		widenet = text2num(signal.data["widenet"])
	if("toggle_widenet" in signal.data)
		widenet = !widenet

	if("scrubbing" in signal.data)
		scrubbing = text2num(signal.data["scrubbing"])
	if("toggle_scrubbing" in signal.data)
		scrubbing = !scrubbing
	if(scrubbing != old_scrubbing)
		investigate_log(" was toggled to [scrubbing ? "scrubbing" : "siphon"] mode by [key_name(signal_sender)]",INVESTIGATE_ATMOS)

	if("toggle_filter" in signal.data)
		filter_types ^= gas_id2path(signal.data["toggle_filter"])

	if("set_filters" in signal.data)
		filter_types = list()
		for(var/gas in signal.data["set_filters"])
			filter_types += gas_id2path(gas)

	if("init" in signal.data)
		name = signal.data["init"]
		return

	if("status" in signal.data)
		broadcast_status()
		return //do not update_icon

	broadcast_status()
	update_appearance()

	if(length(filter_types) == old_filter_length && old_scrubbing == scrubbing && old_widenet == widenet)
		return

	idle_power_usage = initial(idle_power_usage)
	active_power_usage = initial(idle_power_usage)

	var/new_power_usage = 0
	if(scrubbing == SCRUBBING)
		new_power_usage = idle_power_usage + idle_power_usage * length(filter_types)
		update_use_power(IDLE_POWER_USE)
	else
		new_power_usage = active_power_usage
		update_use_power(ACTIVE_POWER_USE)

	if(widenet)
		new_power_usage += new_power_usage * (length(adjacent_turfs) * (length(adjacent_turfs) / 2))

	update_mode_power_usage(scrubbing == SCRUBBING ? IDLE_POWER_USE : ACTIVE_POWER_USE, new_power_usage)

/obj/machinery/atmospherics/components/unary/vent_scrubber/power_change()
	. = ..()
	update_icon_nopipes()

/obj/machinery/atmospherics/components/unary/vent_scrubber/welder_act(mob/living/user, obj/item/I)
	..()
	if(!I.tool_start_check(user, amount=0))
		return TRUE
	to_chat(user, span_notice("Завариваю фильтр."))
	if(I.use_tool(src, user, 20, volume=50))
		if(!welded)
			user.visible_message(span_notice("[user] заваривает фильтр намертво.") ,span_notice("Завариваю фильтр намертво.") , span_hear("Слышу сварку."))
			welded = TRUE
		else
			user.visible_message(span_notice("[user] разваривает фильтр.") , span_notice("Развариваю фильтр.") , span_hear("Слышу сварку."))
			welded = FALSE
		update_icon()
		pipe_vision_img = image(src, loc, layer = ABOVE_HUD_LAYER, dir = dir)
		pipe_vision_img.plane = ABOVE_HUD_PLANE
		investigate_log("was [welded ? "welded shut" : "unwelded"] by [key_name(user)]", INVESTIGATE_ATMOS)
		add_fingerprint(user)
	return TRUE

/obj/machinery/atmospherics/components/unary/vent_scrubber/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("Не могу открутить [src.name], сначала нужно выключить это!"))
		return FALSE

/obj/machinery/atmospherics/components/unary/vent_scrubber/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += "Отвечает за зону: <i>[get_area_name(get_area(src), TRUE)]</i>"
	if(welded)
		. += "<hr>Заварен!"

/obj/machinery/atmospherics/components/unary/vent_scrubber/can_crawl_through()
	return !welded

/obj/machinery/atmospherics/components/unary/vent_scrubber/attack_alien(mob/user)
	if(!welded || !(do_after(user, 20, target = src)))
		return
	user.visible_message(span_warning("[user] яростно разрывает фильтр!") , span_notice("Удалось разблокировать доступ к фильтру.") , span_hear("Слышу громкий лязг металла."))
	welded = FALSE
	update_icon()
	pipe_vision_img = image(src, loc, layer = ABOVE_HUD_LAYER, dir = dir)
	pipe_vision_img.plane = ABOVE_HUD_PLANE
	playsound(loc, 'sound/weapons/bladeslice.ogg', 100, TRUE)


/obj/machinery/atmospherics/components/unary/vent_scrubber/layer2
	piping_layer = 2
	icon_state = "scrub_map-2"

/obj/machinery/atmospherics/components/unary/vent_scrubber/layer4
	piping_layer = 4
	icon_state = "scrub_map-4"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on
	on = TRUE
	icon_state = "scrub_map_on-3"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on/layer2
	piping_layer = 2
	icon_state = "scrub_map_on-2"

/obj/machinery/atmospherics/components/unary/vent_scrubber/on/layer4
	piping_layer = 4
	icon_state = "scrub_map_on-4"

#undef SIPHONING
#undef SCRUBBING
