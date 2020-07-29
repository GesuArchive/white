/obj/vehicle/ridden/space/speedbike/driftcar
	name = "Дрифткар"
	icon = 'white/valtos/icons/vehicles.dmi'
	icon_state = "car"

/obj/vehicle/ridden/space/speedbike/driftcar/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, -8), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-10, 5), TEXT_WEST = list( 10, 5)))
	D.vehicle_move_delay = 0
	D.set_vehicle_dir_offsets(NORTH, -16, -16)
	D.set_vehicle_dir_offsets(SOUTH, -16, -16)
	D.set_vehicle_dir_offsets(EAST, -18, 0)
	D.set_vehicle_dir_offsets(WEST, -18, 0)

/datum/supply_pack/misc/car
	name = "контейнер с дрифткаром"
	desc = "Содержит целую машину. Охуеть."
	cost = 50000
	contains = list(/obj/vehicle/ridden/space/speedbike/driftcar)
	crate_name = "блюспейс ящик"
	crate_type = /obj/structure/closet/crate
