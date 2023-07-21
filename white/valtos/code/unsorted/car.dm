/obj/vehicle/sealed/car/driftcar
	name = "Дрифткар"
	icon = 'white/valtos/icons/vehicles.dmi'
	icon_state = "car"
	movedelay = 1
	pixel_x = -17

/obj/vehicle/sealed/car/driftcar/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/driftcar)

/datum/component/riding/vehicle/driftcar
	vehicle_move_delay = 1
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/driftcar/handle_specials()
	. = ..()
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, -8), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-10, 5), TEXT_WEST = list( 10, 5)))
	set_vehicle_dir_offsets(NORTH, -16, -16)
	set_vehicle_dir_offsets(SOUTH, -16, -16)
	set_vehicle_dir_offsets(EAST, -18, 0)
	set_vehicle_dir_offsets(WEST, -18, 0)
