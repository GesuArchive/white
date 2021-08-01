/datum/component/funny_movement //отрезано от спейсподов
	var/velocity_x = 0 // tiles per second.
	var/velocity_y = 0
	var/offset_x = 0 // like pixel_x/y but in tiles
	var/offset_y = 0

	var/angle = 0 // degrees, clockwise
	var/angular_velocity = 0 // degrees per second
	var/max_angular_acceleration = 360 // in degrees per second per second

	var/last_thrust_forward = 0
	var/last_thrust_right = 0
	var/last_rotate = 0

	var/brakes = FALSE//TRUE
	var/desired_thrust_dir = 0
	var/desired_angle = null

	var/maxthrust_forward = 1
	var/maxthrust_backward = 1
	var/maxthrust_sides = 1

	var/bump_impulse = 0.6
	var/bounce_factor = 0.2 // how much of our velocity to keep on collision
	var/lateral_bounce_factor = 0.95 // mostly there to slow you down when you drive (pilot?) down a 2x2 corridor

	var/default_dir = SOUTH
	var/icon_dir_num = 0 //отвечает за вращение на спрайте/трансформом. 0 - отсутствие вращения на спрайте
	var/original_animate_movement

/datum/component/funny_movement/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/funny_movement/RegisterWithParent()
	var/atom/movable/AM = parent
	original_animate_movement = AM.animate_movement
	AM.animate_movement = NO_STEPS // we do our own gliding here
	START_PROCESSING(SSfastprocess, src)
	//RegisterSignal(parent, COMSIG_MOVABLE_BUMP, .proc/on_bump)

/datum/component/funny_movement/UnregisterFromParent()
	var/atom/movable/AM = parent
	AM.animate_movement = original_animate_movement
	STOP_PROCESSING(SSfastprocess, src)
	//UnregisterSignal(parent, COMSIG_MOVABLE_BUMP)

/datum/component/funny_movement/proc/on_bump(datum/source, atom/A)
	var/atom/movable/AM = parent
	var/bump_velocity = 0
	if(AM.dir & (NORTH|SOUTH))
		bump_velocity = abs(velocity_y) + (abs(velocity_x) / 15)
	else
		bump_velocity = abs(velocity_x) + (abs(velocity_y) / 15)
	var/atom/movable/bumped = A
	if(istype(bumped) && !bumped.anchored && bump_velocity > 1)
		step(bumped, AM.dir)

/datum/component/funny_movement/process(delta_time)
	SEND_SIGNAL(src, COMSIG_FUNNY_MOVEMENT_PROCESSING_START)
	var/atom/movable/AM = parent
	var/last_offset_x = offset_x
	var/last_offset_y = offset_y
	var/last_angle = angle
	var/desired_angular_velocity = 0

	if(isnum(desired_angle))
		// do some finagling to make sure that our angles end up rotating the short way
		while(angle > desired_angle + 180)
			angle -= 360
			last_angle -= 360
		while(angle < desired_angle - 180)
			angle += 360
			last_angle += 360
		if(abs(desired_angle - angle) < (max_angular_acceleration * delta_time))
			desired_angular_velocity = (desired_angle - angle) / delta_time
		else if(desired_angle > angle)
			desired_angular_velocity = 2 * sqrt((desired_angle - angle) * max_angular_acceleration * 0.25)
		else
			desired_angular_velocity = -2 * sqrt((angle - desired_angle) * max_angular_acceleration * 0.25)

	var/angular_velocity_adjustment = clamp(desired_angular_velocity - angular_velocity, -max_angular_acceleration*delta_time, max_angular_acceleration*delta_time)
	if(angular_velocity_adjustment && !(SEND_SIGNAL(src, COMSIG_FUNNY_MOVEMENT_AVADJ, angular_velocity_adjustment) & COMPONENT_FUNNY_MOVEMENT_BLOCK_AVADJ))
		last_rotate = angular_velocity_adjustment / delta_time
		angular_velocity += angular_velocity_adjustment
	else
		last_rotate = 0
	angle += angular_velocity * delta_time

	// calculate drag and shit
	var/velocity_mag = sqrt(velocity_x*velocity_x+velocity_y*velocity_y) // magnitude
	if(velocity_mag || angular_velocity)
		var/drag = 0
		for(var/turf/T in AM.locs)
			if(isspaceturf(T))
				continue

			//ground drag
			if(AM.movement_type & GROUND)
				drag += 0.001
				if((T.has_gravity()) || brakes) // brakes are a kind of magboots okay?
					drag += is_mining_level(AM.z) ? 0.1 : 0.5 // some serious drag. Damn. Except lavaland, it has less gravity or something
					/*
					if(velocity_mag > 5 && prob(velocity_mag * 4) && istype(T, /turf/open/floor))
						var/turf/open/floor/TF = T
						TF.make_plating() // pull up some floor tiles. Stop going so fast, ree.
						//take_damage(3, BRUTE, "melee", FALSE)
					*/


			//air drag
			if(!(AM.movement_type & PHASING))
				var/datum/gas_mixture/env = T.return_air()
				if(env)
					var/pressure = env.return_pressure()
					drag += velocity_mag * pressure * 0.0001 // 1 atmosphere should shave off 1% of velocity per tile

		if(velocity_mag > 20)
			drag = max(drag, (velocity_mag - 20) / delta_time)
		if(drag)
			if(velocity_mag)
				var/drag_factor = 1 - clamp(drag * delta_time / velocity_mag, 0, 1)
				velocity_x *= drag_factor
				velocity_y *= drag_factor
			if(angular_velocity != 0)
				var/drag_factor_spin = 1 - clamp(drag * 30 * delta_time / abs(angular_velocity), 0, 1)
				angular_velocity *= drag_factor_spin

	// Alright now calculate the THRUST
	var/thrust_x
	var/thrust_y
	var/fx = cos(90 - angle)
	var/fy = sin(90 - angle)
	var/sx = fy
	var/sy = -fx
	last_thrust_forward = 0
	last_thrust_right = 0
	if(brakes)
		// basically calculates how much we can brake using the thrust
		var/forward_thrust = -((fx * velocity_x) + (fy * velocity_y)) / delta_time
		var/right_thrust = -((sx * velocity_x) + (sy * velocity_y)) / delta_time
		forward_thrust = clamp(forward_thrust, -maxthrust_backward, maxthrust_forward)
		right_thrust = clamp(right_thrust, -maxthrust_sides, maxthrust_sides)
		thrust_x += forward_thrust * fx + right_thrust * sx;
		thrust_y += forward_thrust * fy + right_thrust * sy;
		last_thrust_forward = forward_thrust
		last_thrust_right = right_thrust
	else // want some sort of help piloting the ship? Haha no fuck you do it yourself
		if(desired_thrust_dir & NORTH)
			thrust_x += fx * maxthrust_forward
			thrust_y += fy * maxthrust_forward
			last_thrust_forward = maxthrust_forward
		if(desired_thrust_dir & SOUTH)
			thrust_x -= fx * maxthrust_backward
			thrust_y -= fy * maxthrust_backward
			last_thrust_forward = -maxthrust_backward
		if(desired_thrust_dir & EAST)
			thrust_x += sx * maxthrust_sides
			thrust_y += sy * maxthrust_sides
			last_thrust_right = maxthrust_sides
		if(desired_thrust_dir & WEST)
			thrust_x -= sx * maxthrust_sides
			thrust_y -= sy * maxthrust_sides
			last_thrust_right = -maxthrust_sides

	if(!(SEND_SIGNAL(src, COMSIG_FUNNY_MOVEMENT_ACCELERATION) & COMPONENT_FUNNY_MOVEMENT_BLOCK_ACCELERATION))
		velocity_x += thrust_x * delta_time
		velocity_y += thrust_y * delta_time
	else
		last_thrust_forward = 0
		last_thrust_right = 0

	offset_x += velocity_x * delta_time
	offset_y += velocity_y * delta_time
	// alright so now we reconcile the offsets with the in-world position.
	while((offset_x > 0 && velocity_x > 0) || (offset_y > 0 && velocity_y > 0) || (offset_x < 0 && velocity_x < 0) || (offset_y < 0 && velocity_y < 0))
		var/failed_x = FALSE
		var/failed_y = FALSE
		if(offset_x > 0 && velocity_x > 0)
			AM.dir = EAST
			if(!AM.Move(get_step(AM, EAST)))
				offset_x = 0
				failed_x = TRUE
				velocity_x *= -bounce_factor
				velocity_y *= lateral_bounce_factor
			else
				offset_x--
				last_offset_x--
		else if(offset_x < 0 && velocity_x < 0)
			AM.dir = WEST
			if(!AM.Move(get_step(AM, WEST)))
				offset_x = 0
				failed_x = TRUE
				velocity_x *= -bounce_factor
				velocity_y *= lateral_bounce_factor
			else
				offset_x++
				last_offset_x++
		else
			failed_x = TRUE
		if(offset_y > 0 && velocity_y > 0)
			AM.dir = NORTH
			if(!AM.Move(get_step(AM, NORTH)))
				offset_y = 0
				failed_y = TRUE
				velocity_y *= -bounce_factor
				velocity_x *= lateral_bounce_factor
			else
				offset_y--
				last_offset_y--
		else if(offset_y < 0 && velocity_y < 0)
			AM.dir = SOUTH
			if(!AM.Move(get_step(AM, SOUTH)))
				offset_y = 0
				failed_y = TRUE
				velocity_y *= -bounce_factor
				velocity_x *= lateral_bounce_factor
			else
				offset_y++
				last_offset_y++
		else
			failed_y = TRUE
		if(failed_x && failed_y)
			break
	// prevents situations where you go "wtf I'm clearly right next to it" as you enter a stationary spacepod
	if(velocity_x == 0)
		if(offset_x > 0.5)
			if(AM.Move(get_step(AM, EAST)))
				offset_x--
				last_offset_x--
			else
				offset_x = 0
		if(offset_x < -0.5)
			if(AM.Move(get_step(AM, WEST)))
				offset_x++
				last_offset_x++
			else
				offset_x = 0
	if(velocity_y == 0)
		if(offset_y > 0.5)
			if(AM.Move(get_step(AM, NORTH)))
				offset_y--
				last_offset_y--
			else
				offset_y = 0
		if(offset_y < -0.5)
			if(AM.Move(get_step(AM, SOUTH)))
				offset_y++
				last_offset_y++
			else
				offset_y = 0

	var/matrix/mat_from = new()
	var/matrix/mat_to = new()
	if(icon_dir_num < 4)
		if(icon_dir_num != 0)
			AM.dir = default_dir
		mat_from.Turn(last_angle)
		mat_to.Turn(angle)
	else
		AM.dir = angle2dir(angle)

	AM.transform = mat_from
	AM.pixel_x = AM.base_pixel_x + last_offset_x*32
	AM.pixel_y = AM.base_pixel_y + last_offset_y*32
	animate(AM, transform=mat_to, pixel_x = AM.base_pixel_x + offset_x*32, pixel_y = AM.base_pixel_y + offset_y*32, time = delta_time*10, flags=ANIMATION_END_NOW)

	var/list/smooth_viewers = AM.contents | AM
	if(AM.orbiters && AM.orbiters.orbiter_list)
		smooth_viewers |= AM.orbiters.orbiter_list
	for(var/mob/M in smooth_viewers)
		var/client/C = M.client
		if(!C)
			continue
		C.pixel_x = AM.base_pixel_x + last_offset_x*32
		C.pixel_y = AM.base_pixel_y + last_offset_y*32
		animate(C, pixel_x = AM.base_pixel_x + offset_x*32, pixel_y = AM.base_pixel_y + offset_y*32, time = delta_time*10, flags=ANIMATION_END_NOW)

	SEND_SIGNAL(src, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH)
