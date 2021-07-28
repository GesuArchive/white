/obj/machinery/computer/shuttle_flight/exploration
	name = "управление шаттлом рейнджеров"
	desc = "Для сам знаешь чего."
	circuit = /obj/item/circuitboard/computer/exploration_shuttle
	shuttleId = "exploration"
	possible_destinations = "exploration_home"

/obj/machinery/computer/shuttle_flight/exploration/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	return

/obj/machinery/computer/shuttle_flight/exploration/ui_interact(mob/user, datum/tgui/ui)
	if(isliving(user))
		var/obj/docking_port/mobile/port = SSshuttle.getShuttle(shuttleId)
		for(var/area/A in port.shuttle_areas)
			for(var/mob/carbon/alien/pidor in A.contents)
				say("Пидарас, ты ксенохуйню с шаттла выкинь, тогда побазарим.")
				return
			for(var/obj/item/clothing/mask/facehugger/pidar in A.contents)
				say("Пидарас, ты ксенохуйню с шаттла выкинь, тогда побазарим.")
				return
	. = ..()
