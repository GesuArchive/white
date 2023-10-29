GLOBAL_VAR_INIT(diy_shuttle_count, 0)

/area/shuttle/diy
	name = "Do-It-Yourself shuttle"
	requires_power = TRUE

//////////////////////////////////////////////////

/obj/machinery/computer/shuttle_flight/diy
	name = "Do-It-Yourself shuttle movement console"
	shuttleId = "diy_autism"
	possible_destinations = ""
	dir = 2

/obj/machinery/computer/shuttle_flight/diy/Initialize(mapload)
	shuttleId += "[GLOB.diy_shuttle_count]"
	possible_destinations += "diy_autism[GLOB.diy_shuttle_count]_home;"
	possible_destinations += "diy_autism[GLOB.diy_shuttle_count]_custom"
	. = ..()

//////////////////////////////////////////////////////

/obj/docking_port/mobile/diy
	name = "DIY-шаттл"
	id = "diy_autism"
	port_direction = 2

/obj/docking_port/mobile/diy/Initialize(mapload)
	. = ..()
	register()

/obj/docking_port/stationary/diy
	name = "DIY-порт"
	id = "diy_autism_home"
	dir = 2
	width = 9
	height = 13
	dwidth = 4
	dheight = 14

///////////////////////////////////////////////////////////////////////

/datum/map_template/shuttle/capsule/diyshuttle
	name = "Autism Shuttle"
	description = "Priv"

	port_id = "diy_autism"
	suffix = "normal"
	prefix = "white/hule/shuttles/diy/"


/obj/item/shuttlespawner/diyshuttle
	name = "bluespace shuttle capsule"
	desc = "Priva."
	template = new /datum/map_template/shuttle/capsule/diyshuttle


/obj/item/shuttlespawner/diyshuttle/attack_self()
	. = ..()
	if(used)
		GLOB.diy_shuttle_count++

/obj/item/shuttlespawner/explorer_mini
	name = "bluespace shuttle capsule"
	desc = "Zopa."
	template = new /datum/map_template/shuttle/ruin/explorer_mini

///////////////////////////////////////

/obj/docking_port/mobile/diy/big
	dir = 2

/obj/docking_port/stationary/diy/big
	width = 13
	height = 20
	dwidth = 6
	dheight = 19

/datum/map_template/shuttle/capsule/diyshuttle/big
	name = "Big Autism Shuttle"
	description = "Priv"
	suffix = "big"

/obj/item/shuttlespawner/diyshuttle/big
	template = new /datum/map_template/shuttle/capsule/diyshuttle/big
