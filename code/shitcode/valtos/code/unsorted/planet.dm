/obj/machinery/computer/shuttle/unit_shuttle
	name = "unit shuttle console"
	desc = "Used to control the unit shuttle."
	circuit = /obj/item/circuitboard/computer/unit_shuttle
	shuttleId = "podunit"
	possible_destinations = "space_station;planet_station;"
	no_destination_swap = TRUE

/obj/item/circuitboard/computer/unit_shuttle
	name = "Unit Shuttle (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/shuttle/unit_shuttle

/datum/map_template/shuttle/escape_pod/unit
	suffix = "unit"
	name = "transport pod (Unit)"

/datum/map_template/shuttle/arrival/unit
	suffix = "unit"
	name = "arrival shuttle (Unit)"
