/obj/machinery/computer/shuttle_flight/tramstation
	name = "консоль управления трамваем"
	desc = "Управляет."
	shuttleId = "tramstation_tram"
	possible_destinations = "tramstation_left;tramstation_center;tramstation_right"

/obj/docking_port/mobile/tram
	name = "трамвайный док"
	id = "tramstation_tram"
	callTime = 0
	ignitionTime = 30
	rechargeTime = 50
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
