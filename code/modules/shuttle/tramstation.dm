/obj/machinery/computer/shuttle/tramstation
	name = "консоль управления трамваем"
	desc = "Управляет."
	locked = FALSE
	no_destination_swap = TRUE
	shuttleId = "tramstation_tram"
	possible_destinations = "tramstation_left;tramstation_center;tramstation_right"

/obj/docking_port/mobile/tram
	name = "трамвайный док"
	id = "tramstation_tram"
	callTime = 0
	ignitionTime = 30
	rechargeTime = 50
	dwidth = 4
	dheight = 0
	width = 11
	height = 5
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
