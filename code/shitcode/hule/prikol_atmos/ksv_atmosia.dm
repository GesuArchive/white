/datum/map_template/shuttle/atmosia
	name = "KSV Atmosia"
	prefix = "code/shitcode/hule/prikol_atmos/"
	port_id = "ksv_atmosia"
	suffix = "a"

///////////////////////////////////////////////////////

/area/shuttle/atmosia
	name = "KSV Atmosia Bridge"
	ambientsounds = ENGINEERING
	requires_power = TRUE
	valid_territory = FALSE
	flags_1 = NONE

/area/shuttle/atmosia/atmos
	name = "KSV Atmosia Atmospherics"
	icon_state = "atmos"


/area/shuttle/atmosia/engine
	name = "KSV Atmosia Engine"
	icon_state = "atmos_engine"

//////////////////////////////////////////////////////

/obj/machinery/computer/camera_advanced/shuttle_docker/adv/atmosia
	name = "CSV Bearcat navigation computer"
	desc = "Used to designate a precise transit location for the ship."
	shuttleId = "ksv_atmosia"
	shuttlePortId = "ksv_atmosia_custom"
	shuttlePortName = "custom location"
	view_range = 20
	y_offset = -17
	z_lock = list(3,4,7,8,9,10,12)

/obj/machinery/computer/shuttle/bearcat
	name = "CSV Bearcat console"
	shuttleId = "ksv_atmosia"
	possible_destinations = "ksv_atmosia_custom;ksv_atmosia_home"

/obj/docking_port/mobile/bearcat
	name = "CSV Bearcat"
	id = "ksv_atmosia"

	port_direction = 2
	width = 29
	dwidth = 6
	height = 44
	dheight = 30
	//movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	engine_coeff = 30

/obj/docking_port/stationaty/bearcat
	name = "CSV Bearcat Away"
	id = "ksv_atmosia_home"
	dir = 2
	width = 29
	dwidth = 6
	height = 44
	dheight = 30
