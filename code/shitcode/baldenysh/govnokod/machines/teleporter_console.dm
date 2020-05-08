/obj/machinery/computer/bs_emitter
	name = "прикольная консоль телепортера"
	desc = "Необходима для телепортации всяких штук."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	//circuit = /obj/item/circuitboard/computer/turbine_computer
	ui_x = 310
	ui_y = 150
	var/obj/machinery/power/bs_emitter/BSE


/obj/machinery/computer/bs_emitter/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/bs_emitter/LateInitialize()
	locate_machinery()

/obj/machinery/computer/bs_emitter/locate_machinery()
		BSE = locate(/obj/machinery/power/bs_emitter) in range(7, src)


/*
/obj/machinery/computer/bs_emitter/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "TurbineComputer", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/computer/bs_emitter/ui_data(mob/user)
	var/list/data = list()
	data["compressor"] = compressor ? TRUE : FALSE
	data["compressor_broke"] = (!compressor || (compressor.machine_stat & BROKEN)) ? TRUE : FALSE
	data["turbine"] = compressor?.turbine ? TRUE : FALSE
	data["turbine_broke"] = (!compressor || !compressor.turbine || (compressor.turbine.machine_stat & BROKEN)) ? TRUE : FALSE
	data["online"] = compressor?.starter
	data["power"] = DisplayPower(compressor?.turbine?.lastgen)
	data["rpm"] = compressor?.rpm
	data["temp"] = compressor?.gas_contained.return_temperature()
	return data

/obj/machinery/computer/bs_emitter/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("toggle_power")
			if(compressor && compressor.turbine)
				compressor.starter = !compressor.starter
				. = TRUE
		if("reconnect")
			locate_machinery()
			. = TRUE
*/
