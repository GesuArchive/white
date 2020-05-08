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


