/obj/machinery/computer/shuttle_flight/exploration
	name = "управление шаттлом рейнджеров"
	desc = "Для сам знаешь чего."
	circuit = /obj/item/circuitboard/computer/exploration_shuttle
	shuttleId = "exploration"
	possible_destinations = "exploration_home;exploration_away"
	req_access = list(ACCESS_EXPLORATION)

/obj/machinery/computer/shuttle_flight/exploration/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	return
