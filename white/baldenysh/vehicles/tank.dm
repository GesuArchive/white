
/////////////////////////////////////////////////////////////

/obj/vehicle/sealed/tank
	name = "A M O N G"
	icon = 'icons/obj/car.dmi'
	icon_state = "tank"
	bound_width = 32 * 3
	bound_height = 32 * 3
	base_pixel_x = -16
	base_pixel_y = -16
	max_integrity = 2000
	var/datum/component/funny_movement/movement

/obj/vehicle/sealed/tank/ComponentInitialize()
	. = ..()
	movement = AddComponent(/datum/component/funny_movement)
	movement.icon_dir_num = 4
	movement.maxthrust_forward = 5
	RegisterSignal(movement, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH, .proc/funny_movement_moved)

/obj/vehicle/sealed/tank/proc/funny_movement_moved()
	movement.desired_thrust_dir = 0

/obj/vehicle/sealed/tank/vehicle_move(direction)
	var/rotation = 15
	if(direction & NORTH)
		movement.desired_thrust_dir |= NORTH
	if(direction & SOUTH)
		movement.desired_thrust_dir |= SOUTH
	if(direction & WEST)
		movement.desired_angle = movement.angle - rotation
	if(direction & EAST)
		movement.desired_angle = movement.angle + rotation

/obj/vehicle/sealed/tank/Move(atom/newloc, direct, glide_size_override)
	var/list/newlocs = isturf(newloc) ? block(locate(newloc.x+(-bound_x)/world.icon_size,newloc.y+(-bound_y)/world.icon_size,newloc.z),locate(newloc.x+(-bound_x+bound_width)/world.icon_size-1,newloc.y+(-bound_y+bound_height)/world.icon_size-1,newloc.z)) : list(newloc)
	if(newlocs)
		for(var/atom/A in (newlocs - locs))
			if(A == src || (A in occupants))
				continue
			if(isclosedturf(A))
				SSexplosions.lowturf += A
				continue
			if(!isopenturf(A))
				continue
			for(var/atom/ded in A.contents)
				if(isliving(ded))
					var/mob/living/rammed = ded
					visible_message("<span class='danger'><b>[src]</b> давит <b>[ded]</b>!</span>")
					rammed.gib()
					continue
				if(isobj(ded) && ded.density)
					var/obj/dead_obj = ded
					dead_obj.take_damage(INFINITY, BRUTE, NONE, TRUE, dir, INFINITY)
					continue
	. = ..()
