/obj/vehicle/sealed/car/fucking_tank
	name = "ТАНК"
	desc = "<big>БЛЯТЬ!</big>"
	icon = 'icons/obj/car.dmi'
	icon_state = "tank"
	engine_sound = 'white/valtos/sounds/tonkloop.ogg'
	engine_sound_length = 5 SECONDS
	layer = ABOVE_MOB_LAYER
	max_buckled_mobs = 1
	pixel_y = -48
	pixel_x = -48
	max_integrity = 2000

/obj/vehicle/sealed/car/fucking_tank/Initialize()
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/tank)

/obj/vehicle/sealed/car/fucking_tank/Bump(atom/A)
	. = ..()
	if(!A.density || !has_buckled_mobs())
		return

	visible_message("<span class='danger'>[src] давит [A]!</span>")
	if(ishuman(A))
		var/mob/living/carbon/human/rammed = A
		rammed.gib()

	if(isturf(A))
		SSexplosions.lowturf += A
		return ..()

	if(isobj(A))
		var/obj/dead_obj = A
		dead_obj.take_damage(INFINITY, BRUTE, NONE, TRUE, dir, INFINITY)
		return ..()

/obj/vehicle/sealed/car/fucking_tank/Moved()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/atom/A in range(2, src))
		if(!(A in buckled_mobs))
			Bump(A)

/datum/component/riding/vehicle/tank
	vehicle_move_delay = 2

/datum/component/riding/vehicle/tank/handle_specials()
	. = ..()
	set_riding_offsets(1, list(TEXT_NORTH = list(-10, -4), TEXT_SOUTH = list(16, 3), TEXT_EAST = list(-4, 30), TEXT_WEST = list(4, -3)))
	set_riding_offsets(2, list(TEXT_NORTH = list(19, -5, 4), TEXT_SOUTH = list(-13, 3, 4), TEXT_EAST = list(-4, -3, 4.1), TEXT_WEST = list(4, 28, 3.9)))
	set_riding_offsets(3, list(TEXT_NORTH = list(-10, -18, 4.2), TEXT_SOUTH = list(16, 25, 3.9), TEXT_EAST = list(-22, 30), TEXT_WEST = list(22, -3, 4.1)))
	set_riding_offsets(4, list(TEXT_NORTH = list(19, -18, 4.2), TEXT_SOUTH = list(-13, 25, 3.9), TEXT_EAST = list(-22, 3, 3.9), TEXT_WEST = list(22, 28)))
	set_vehicle_dir_offsets(NORTH, -48, -48)
	set_vehicle_dir_offsets(SOUTH, -48, -48)
	set_vehicle_dir_offsets(EAST, -48, -48)
	set_vehicle_dir_offsets(WEST, -48, -48)
