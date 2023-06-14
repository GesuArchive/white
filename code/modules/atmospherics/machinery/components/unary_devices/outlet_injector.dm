/obj/machinery/atmospherics/components/unary/outlet_injector
	icon_state = "inje_map-3"

	name = "инжектор"
	desc = "Вентиляционное отверстие совмещенное с объемным насосом. Позволяет нагнетать газ в помещение вне зависимости от внешнего давления."

	use_power = NO_POWER_USE
	can_unwrench = TRUE
	shift_underlay_only = FALSE
	hide = TRUE

	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF //really helpful in building gas chambers for xenomorphs

	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.25

	var/injecting = 0

	var/volume_rate = 100

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	layer = GAS_SCRUBBER_LAYER

	pipe_state = "injector"

/obj/machinery/atmospherics/components/unary/outlet_injector/CtrlClick(mob/user)
	if(can_interact(user))
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_icon()
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/AltClick(mob/user)
	if(can_interact(user))
		volume_rate = MAX_TRANSFER_RATE
		investigate_log("was set to [volume_rate] L/s by [key_name(user)]", INVESTIGATE_ATMOS)
		to_chat(user, span_notice("Выкручиваю выход инжектора к максимальному значению в [volume_rate] Л/с."))
		update_icon()
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		// everything is already shifted so don't shift the cap
		add_overlay(getpipeimage(icon, "inje_cap", initialize_directions, pipe_color))

	if(!nodes[1] || !on || !is_operational)
		icon_state = "inje_off"
	else
		icon_state = "inje_on"

/obj/machinery/atmospherics/components/unary/outlet_injector/process_atmos()
	..()

	injecting = 0

	if(!on || !is_operational || !isopenturf(loc))
		return

	var/datum/gas_mixture/air_contents = airs[1]

	if(air_contents != null)
		if(air_contents.return_temperature() > 0)
			loc.assume_air_ratio(air_contents, volume_rate / air_contents.return_volume())
			air_update_turf()

			update_parents()

/obj/machinery/atmospherics/components/unary/outlet_injector/inject()

	if(on || injecting || !is_operational)
		return

	var/datum/gas_mixture/air_contents = airs[1]

	injecting = 1

	if(air_contents.return_temperature() > 0)
		loc.assume_air_ratio(air_contents, volume_rate / air_contents.return_volume())
		update_parents()

	flick("inje_inject", src)

/obj/machinery/atmospherics/components/unary/outlet_injector/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency)

/obj/machinery/atmospherics/components/unary/outlet_injector/broadcast_status()

	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id,
		"device" = "AO",
		"power" = on,
		"volume_rate" = volume_rate,
		//"timestamp" = world.time,
		"sigtype" = "status"
	))
	radio_connection.post_signal(src, signal)

/obj/machinery/atmospherics/components/unary/outlet_injector/atmosinit()
	set_frequency(frequency)
	broadcast_status()
	..()

/obj/machinery/atmospherics/components/unary/outlet_injector/receive_signal(datum/signal/signal)

	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("inject" in signal.data)
		INVOKE_ASYNC(src, PROC_REF(inject))
		return

	if("set_volume_rate" in signal.data)
		var/number = text2num(signal.data["set_volume_rate"])
		var/datum/gas_mixture/air_contents = airs[1]
		volume_rate = clamp(number, 0, air_contents.return_volume())

	addtimer(CALLBACK(src, PROC_REF(broadcast_status)), 2)

	if(!("status" in signal.data)) //do not update_icon
		update_icon()


/obj/machinery/atmospherics/components/unary/outlet_injector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/components/unary/outlet_injector/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(volume_rate)
	data["max_rate"] = round(MAX_TRANSFER_RATE)
	return data

/obj/machinery/atmospherics/components/unary/outlet_injector/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = MAX_TRANSFER_RATE
				. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				volume_rate = clamp(rate, 0, MAX_TRANSFER_RATE)
				investigate_log("was set to [volume_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()
	broadcast_status()

/obj/machinery/atmospherics/components/unary/outlet_injector/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("Не могу открутить [src.name], сначала нужно выключить это!"))
		return FALSE

// mapping

/obj/machinery/atmospherics/components/unary/outlet_injector/layer2
	piping_layer = 2
	icon_state = "inje_map-2"

/obj/machinery/atmospherics/components/unary/outlet_injector/layer4
	piping_layer = 4
	icon_state = "inje_map-4"

/obj/machinery/atmospherics/components/unary/outlet_injector/on
	on = TRUE

/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer2
	piping_layer = 2
	icon_state = "inje_map-2"

/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4
	piping_layer = 4
	icon_state = "inje_map-4"

/obj/machinery/atmospherics/components/unary/outlet_injector/atmos
	frequency = FREQ_ATMOS_STORAGE
	on = TRUE
	volume_rate = MAX_TRANSFER_RATE

/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/atmos_waste
	name = "инжектор отстойника"
	id =  ATMOS_GAS_MONITOR_WASTE_ATMOS
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/engine_waste
	name = "инжектор двигателя"
	id = ATMOS_GAS_MONITOR_WASTE_ENGINE
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/toxin_input
	name = "инжектор в бак плазмы"
	id = ATMOS_GAS_MONITOR_INPUT_PLAS
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/oxygen_input
	name = "инжектор в кислородный бак"
	id = ATMOS_GAS_MONITOR_INPUT_O2
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/nitrogen_input
	name = "инжектор в бак азота"
	id = ATMOS_GAS_MONITOR_INPUT_N2
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/mix_input
	name = "инжектор в камеру смешивания"
	id = ATMOS_GAS_MONITOR_INPUT_MIX
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/nitrous_input
	name = "инжектор в камеру закиси азота"
	id = ATMOS_GAS_MONITOR_INPUT_N2O
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/air_input
	name = "инжектор в камеру воздушного микса"
	id = ATMOS_GAS_MONITOR_INPUT_AIR
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/carbon_input
	name = "инжектор в камеру угарного газа"
	id = ATMOS_GAS_MONITOR_INPUT_CO2
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/bz_input
	name = "инжектор в камеру с газом БЗ"
	id = ATMOS_GAS_MONITOR_INPUT_BZ
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/freon_input
	name = "инжектор в камеру с фреоном"
	id = ATMOS_GAS_MONITOR_INPUT_FREON
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/halon_input
	name = "инжектор в камеру с галоном"
	id = ATMOS_GAS_MONITOR_INPUT_HALON
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/healium_input
	name = "инжектор в камеру с хилиумом"
	id = ATMOS_GAS_MONITOR_INPUT_HEALIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/hydrogen_input
	name = "инжектор в камеру с водородом"
	id = ATMOS_GAS_MONITOR_INPUT_H2
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/hypernoblium_input
	name = "инжектор в камеру с гипер-ноблием"
	id = ATMOS_GAS_MONITOR_INPUT_HYPERNOBLIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/miasma_input
	name = "инжектор в камеру с миазмой"
	id = ATMOS_GAS_MONITOR_INPUT_MIASMA
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/nitryl_input
	name = "инжектор в камеру с нитрилом"
	id = ATMOS_GAS_MONITOR_INPUT_NO2
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/pluoxium_input
	name = "инжектор в камеру с плюоксием"
	id = ATMOS_GAS_MONITOR_INPUT_PLUOXIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/proto_nitrate_input
	name = "инжектор в камеру с протонитратом"
	id = ATMOS_GAS_MONITOR_INPUT_PROTO_NITRATE
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/stimulum_input
	name = "инжектор в камеру с стимулумом"
	id = ATMOS_GAS_MONITOR_INPUT_STIMULUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/tritium_input
	name = "инжектор в камеру с тритием"
	id = ATMOS_GAS_MONITOR_INPUT_TRITIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/water_vapor_input
	name = "инжектор в камеру с паром"
	id = ATMOS_GAS_MONITOR_INPUT_H2O
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/zauker_input
	name = "инжектор в камеру с циклоном Б"
	id = ATMOS_GAS_MONITOR_INPUT_ZAUKER
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/helium_input
	name = "инжектор в камеру с гелием"
	id = ATMOS_GAS_MONITOR_INPUT_HELIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/antinoblium_input
	name = "инжектор в камеру с антиноблием"
	id = ATMOS_GAS_MONITOR_INPUT_ANTINOBLIUM
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/incinerator_input
	name = "инжектор в камеру сжигателя"
	id = ATMOS_GAS_MONITOR_INPUT_INCINERATOR
/obj/machinery/atmospherics/components/unary/outlet_injector/atmos/toxins_mixing_input
	name = "инжектор в камеру смешивания токсинов"
	id = ATMOS_GAS_MONITOR_INPUT_ORDNANCE_LAB
