/mob/dead/observer/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //observers do not respect these FLOORS you speak so much of.
	return ..()
