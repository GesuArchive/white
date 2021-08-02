
/////////////////////////////////////////////////////////////

/obj/vehicle/sealed/test_tank
	name = "among"
	icon = 'icons/obj/car.dmi'
	icon_state = "tank"
	bound_width = 32 * 3
	bound_height = 32 * 3
	base_pixel_y = -16
	var/datum/component/funny_movement/movement

/obj/vehicle/sealed/test_tank/ComponentInitialize()
	. = ..()
	movement = AddComponent(/datum/component/funny_movement)
	movement.icon_dir_num = 4
	movement.maxthrust_forward = 2
	RegisterSignal(movement, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH, .proc/funny_movement_moved)

/obj/vehicle/sealed/test_tank/proc/funny_movement_moved()
	movement.desired_thrust_dir = 0

/obj/vehicle/sealed/test_tank/vehicle_move(direction)
	var/rotation = 5
	if(direction & NORTH)
		movement.desired_thrust_dir |= NORTH
	if(direction & SOUTH)
		movement.desired_thrust_dir |= SOUTH
	if(direction & WEST)
		movement.desired_angle -= rotation
	if(direction & EAST)
		movement.desired_angle += rotation

/obj/vehicle/sealed/test_tank/Bump(atom/A)
	. = ..()
	if(A == src || (A in occupants))
		return ..()

	if(ishuman(A))
		var/mob/living/carbon/human/rammed = A
		visible_message("<span class='danger'><b>[src]</b> давит <b>[A]</b>!</span>")
		rammed.gib()
		return ..()

	if(isclosedturf(A))
		SSexplosions.lowturf += A
		return ..()

	if(isobj(A))
		var/obj/dead_obj = A
		dead_obj.take_damage(INFINITY, BRUTE, NONE, TRUE, dir, INFINITY)
		return ..()
