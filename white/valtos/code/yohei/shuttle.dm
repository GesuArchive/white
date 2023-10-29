/obj/item/circuitboard/computer/yohei
	build_path = /obj/machinery/computer/shuttle_flight/yohei

/obj/machinery/computer/shuttle_flight/yohei
	name = "Консоль Управления Сборщиком Йохеев"
	desc = "Используется для управления данным кораблём."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list() // hijack moment
	circuit = /obj/item/circuitboard/computer/yohei
	shuttleId = "yohei_harverster"
	possible_destinations = "yohei_harverster_custom"

/obj/machinery/computer/shuttle_flight/yohei/LateInitialize()
	. = ..()
	var/datum/orbital_object/O = launch_shuttle()

	var/datum/orbital_map/linked_map = SSorbits.orbital_maps[orbital_map_index]
	O.set_orbitting_around_body(linked_map.center, 1300 + 25 * rand(40, 20))

/area/shuttle/yohei
	name = "Сборщик Йохеев"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = YOHEI
	area_limited_icon_smoothing = /area/shuttle/yohei

/obj/docking_port/mobile/yohei
	name = "Сборщик Йохеев"
	id = "yohei_harverster"
	ignitionTime = 25
	callTime = 50
	port_direction = 2
	preferred_direction = 1
