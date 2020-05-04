/atom/movable/proc/do_item_swing_animation(atom/A, visual_effect_icon, obj/item/used_item, startdeg = 0, stopdeg = 180, rotspeed = 10, clockwise = 1, segments = 9, parallel = TRUE)
	var/image/I
	if(visual_effect_icon)
		I = image('icons/effects/effects.dmi', A, visual_effect_icon, A.layer + 0.1)
	else if(used_item)
		I = image(icon = used_item, loc = A, layer = A.layer + 0.1)
		I.plane = GAME_PLANE

		// Scale the icon.
		I.transform *= 0.75
		// The icon should not rotate.
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

		// Set the direction of the icon animation.
		var/direction = get_dir(src, A)
		if(direction & NORTH)
			I.pixel_y = -16
		else if(direction & SOUTH)
			I.pixel_y = 16

		if(direction & EAST)
			I.pixel_x = -16
		else if(direction & WEST)
			I.pixel_x = 16

		if(!direction) // Attacked self?!
			I.pixel_z = 16

	if(!I)
		return

	flick_overlay(I, GLOB.clients, 5) // 5 ticks/half a second

	// And animate the attack!
	//animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
	TurnAnimation(I, startdeg, stopdeg, rotspeed, -1, clockwise, segments, parallel)

/proc/TurnAnimation(image/I, startdeg = 0, stopdeg = 180, speed = 10, loops = -1, clockwise = 1, segments = 9, parallel = TRUE)
	if(!segments)
		return
	var/segment = (stopdeg - startdeg)/segments
	if(!clockwise)
		segment = -segment
	var/list/matrices = list()
	for(var/i in 1 to segments-1)
		var/matrix/M = matrix(I.transform)
		M.Turn(startdeg + segment*i)
		matrices += M
	var/matrix/last = matrix(I.transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(I, transform = matrices[1], time = speed, loops , flags = ANIMATION_PARALLEL)
	else
		animate(I, transform = matrices[1], time = speed, loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

/obj/item/wrench/combat/aoetest
	name = "anime wrench"
	var/sstartdeg = 0
	var/sstopdeg = 180
	var/sspeed = 10
	var/sclockwise = 1
	var/ssegments = 9
	var/sparallel = FALSE

/obj/item/wrench/combat/aoetest/afterattack(atom/movable/AM, mob/living/user, proximity)
	. = ..()
	user.do_item_swing_animation(AM, null, src, sstartdeg, sstopdeg, sspeed, sclockwise, ssegments, sparallel)

