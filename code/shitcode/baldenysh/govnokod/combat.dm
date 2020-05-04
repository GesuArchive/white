/datum/aoe_melee
	var/obj/item/master = null

/datum/aoe_melee/New(mstr)
	master = mstr

/datum/aoe_melee/swing
	var/cur_angle = 0

	var/attack_cone = 180
	var/deg_between_hits = 45

	var/clockwise = TRUE
	var/segments_per_action = 6
	var/speed_per_action = 1

	var/image/anim_img = null
	var/anim_size_mod = 0.75
	var/init_img_turn = -45
	var/radius = 26

	var/anim_flags = ANIMATION_PARALLEL

	var/hitproc_debug = TRUE

/datum/aoe_melee/swing/proc/pre_attack(atom/attacked, atom/movable/attacker)
	anim_img = image(icon = master, loc = attacker, layer = attacker.layer + 0.1)

	anim_img.plane = GAME_PLANE
	anim_img.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	//anim_img.transform = anim_img.transform.Turn(init_img_turn)

	var/direction = get_dir(attacked, attacker)
	var/offset_angle = dir2angle(direction)
	cur_angle = offset_angle

	anim_img.transform = anim_img.transform.Turn(init_img_turn + dir2angle(direction))

	anim_img.transform *= anim_size_mod

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

	var/rotations = attack_cone/deg_between_hits

	flick_overlay_view(anim_img, attacker, speed_per_action*rotations*segments_per_action)

	var/half_cone = attack_cone/2

	if(clockwise)
		half_cone = -half_cone

	anim_img.transform = anim_img.transform.Turn(half_cone)
	cur_angle += half_cone

	animate(anim_img, transform = matrix(anim_img.transform), time = speed_per_action, 1 , flags = anim_flags)
	hitproc(get_step(master, angle2dir(cur_angle)))

	for(var/i in 2 to rotations)
		rotate(deg_between_hits)
		hitproc(get_step(master, angle2dir(cur_angle)))

/datum/aoe_melee/swing/proc/hitproc(turf/loc)
	if(hitproc_debug)
		new /obj/item/wrench(loc)
		return
	return

/datum/aoe_melee/swing/proc/rotate(angle)
	if(clockwise)
		angle = -angle

	cur_angle += angle

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


