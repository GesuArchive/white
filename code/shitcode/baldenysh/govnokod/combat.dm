/atom/movable/proc/do_item_swing_animation(atom/A, obj/item/used_item, radius = 26, initial_turn = 0, conedeg = 180, speed = 10, clockwise = 1, segments = 9, parallel = TRUE)
	var/image/I
	if(!used_item)
		return
	I = image(icon = used_item, loc = A, layer = A.layer + 0.1)
	I.plane = GAME_PLANE

	I.transform *= 0.75
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/direction = get_dir(src, A)
	var/offset_angle = 0

	switch(direction)
		if(NORTHEAST)
			offset_angle = 45
		if(EAST)
			offset_angle = 90
		if(SOUTHEAST)
			offset_angle = 135
		if(SOUTH)
			offset_angle = 180
		if(SOUTHWEST)
			offset_angle = 225
		if(WEST)
			offset_angle = 270
		if(NORTHWEST)
			offset_angle = 315

	I.transform = I.transform.Turn(initial_turn + offset_angle)

	var/matrix/init = matrix(I.transform)
	var/matrix/shift = matrix(I.transform)

	if(direction & NORTH)
		shift.Translate(0, radius)
	else if(direction & SOUTH)
		shift.Translate(0, -radius)
	if(direction & EAST)
		shift.Translate(radius, 0)
	else if(direction & WEST)
		shift.Translate(-radius, 0)

	I.transform = shift

	if(!I)
		return

	flick_overlay_view(I, src, speed)

	if(!segments)
		return

	var/segment = conedeg/segments
	var/startdeg = (360-conedeg/2) + offset_angle

	if(!clockwise)
		segment = -segment
		startdeg = conedeg/2 + offset_angle

	var/list/matrices = list()
	matrices += init

	for(var/i in 1 to segments)
		var/matrix/M = matrix(I.transform)
		M.Turn(startdeg + segment*i)
		matrices += M

	speed /= segments

	if(parallel)
		animate(I, transform = matrices[1], time = speed, 1 , flags = ANIMATION_PARALLEL)
	else
		animate(I, transform = matrices[1], time = speed, 1)

	for(var/i in 2 to segments)
		I.loc = loc
		animate(transform = matrices[i], time = speed)

/datum/aoe_melee
	var/obj/item/master = null

/datum/aoe_melee/New(mstr)
	master = mstr

/datum/aoe_melee/swing
	var/cur_angle = 0
	var/attack_cone = 180
	var/clockwise = TRUE
	var/segments_per_action = 6
	var/speed_per_action = 1
	var/anim_flags = ANIMATION_PARALLEL
	var/radius = 26
	var/init_turn = -45
	var/image/anim_img = null

	var/hitproc_debug = TRUE

/datum/aoe_melee/swing/proc/pre_attack(atom/attacked, atom/movable/attacker)
	anim_img = image(icon = master, loc = attacker, layer = attacker.layer + 0.1)

	anim_img.plane = GAME_PLANE
	anim_img.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/direction = get_dir(attacker, attacked)
	var/offset_angle = dir2angle(direction)
	cur_angle = offset_angle

	anim_img.transform = anim_img.transform.Turn(init_turn + dir2angle(direction))

	anim_img.transform *= 0.75

	var/matrix/shift = matrix(anim_img.transform)

	if(direction & NORTH)
		shift.Translate(0, radius)
	else if(direction & SOUTH)
		shift.Translate(0, -radius)
	if(direction & EAST)
		shift.Translate(radius, 0)
	else if(direction & WEST)
		shift.Translate(-radius, 0)

	anim_img.transform = shift

/datum/aoe_melee/swing/proc/start_attack(atom/attacked, atom/movable/attacker)
	pre_attack(attacked, attacker)

	flick_overlay_view(anim_img, attacker, speed_per_action*10)

	var/half_cone = attack_cone/2

	if(clockwise)
		half_cone = -half_cone

	anim_img.transform = anim_img.transform.Turn(half_cone)
	cur_angle += half_cone

	animate(anim_img, transform = matrix(anim_img.transform), time = speed_per_action, 1 , flags = anim_flags)
	hitproc(get_step(master, angle2dir(cur_angle)))
	rotate(45)
	hitproc(get_step(master, angle2dir(cur_angle)))
	rotate(45)
	hitproc(get_step(master, angle2dir(cur_angle)))

/datum/aoe_melee/swing/proc/hitproc(turf/loc)
	if(hitproc_debug)
		new /obj/item/wrench(loc)
	return

/datum/aoe_melee/swing/proc/rotate(angle)
	if(clockwise)
		angle = -angle

	var/list/matrices = generate_turn_matrices(anim_img, angle)
	for(var/matrix/mtrx in matrices)
		animate(transform = mtrx, time = speed_per_action)

/datum/aoe_melee/swing/proc/generate_turn_matrices(image/img, angle)
	var/list/matrices = list()
	var/segment = angle/segments_per_action

	for(var/i in 1 to segments_per_action)
		var/matrix/M = img.transform
		M.Turn(segment*i)
		matrices += M

	return matrices


/obj/item/claymore/aoetest
	name = "anime sord"
	var/datum/aoe_melee/swing/SW = null

/obj/item/claymore/aoetest/Initialize()
	. = ..()
	SW = new(src)

/obj/item/claymore/aoetest/afterattack(atom/movable/AM, mob/living/user, proximity)
	. = ..()
	SW.start_attack(AM, user)


