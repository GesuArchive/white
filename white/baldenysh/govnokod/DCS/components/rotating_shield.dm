/datum/component/rotating_shield
	var/list/atom/movable/shielded_stack = list()
	var/list/datum/rs_plate_layer/plate_layers = list()
	var/angular_velocity = 30
	var/active = FALSE

/datum/component/rotating_shield/Initialize(mapload)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/rotating_shield/RegisterWithParent()
	SetShielded(parent)

/datum/component/rotating_shield/proc/SetShielded(atom/movable/movable_to_shield)
	if(!istype(movable_to_shield))
		return
	if(shielded_stack.len)
		var/atom/movable/last_shielded_movable = shielded_stack[shielded_stack.len]
		if(last_shielded_movable)
			UnregisterSignal(last_shielded_movable, COMSIG_ATOM_EXITED)
			UnregisterSignal(last_shielded_movable, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(last_shielded_movable, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE)
			UnregisterSignal(last_shielded_movable, COMSIG_PARENT_ATTACKBY)
			UnregisterSignal(last_shielded_movable, COMSIG_ATOM_BULLET_ACT)
			UnregisterSignal(last_shielded_movable, COMSIG_ATOM_HITBY)
	if(movable_to_shield in shielded_stack)
		var/atom/movable/last_shielded_movable = shielded_stack[shielded_stack.len]
		LAZYREMOVE(shielded_stack, last_shielded_movable)
	else
		LAZYADD(shielded_stack, movable_to_shield)
	RegisterSignal(movable_to_shield, COMSIG_ATOM_EXITED, .proc/on_exited)
	RegisterSignal(movable_to_shield, COMSIG_MOVABLE_MOVED, .proc/on_shielded_moved)
	RegisterSignal(movable_to_shield, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, .proc/on_shielded_glide_size_update)
	RegisterSignal(movable_to_shield, COMSIG_PARENT_ATTACKBY, .proc/on_shielded_attackby)
	RegisterSignal(movable_to_shield, COMSIG_ATOM_BULLET_ACT, .proc/on_shielded_bullet_act)
	RegisterSignal(movable_to_shield, COMSIG_ATOM_HITBY, .proc/on_shielded_hitby)
	on_shielded_moved()

////////////////////////////////////////////////////////////////////////перемещение/анимация

/datum/component/rotating_shield/proc/on_exited(datum/source, atom/movable/gone)
	SIGNAL_HANDLER
	if(shielded_stack.len < 2)
		return
	if(gone == shielded_stack[shielded_stack.len - 1])
		SetShielded(gone)

/datum/component/rotating_shield/proc/on_shielded_moved(datum/source, atom/old_loc, movement_dir, forced = FALSE, list/old_locs)
	SIGNAL_HANDLER
	if(!active)
		return
	var/atom/movable/shielded_movable = shielded_stack[shielded_stack.len]
	if(!shielded_movable)
		return
	if(isturf(shielded_movable.loc))
		for(var/obj/structure/rs_plate/plate in get_plates())
			plate.forceMove(shielded_movable.loc)
	else
		SetShielded(shielded_movable.loc)

/datum/component/rotating_shield/proc/on_shielded_glide_size_update(datum/source, new_glide_size)
	SIGNAL_HANDLER
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.set_glide_size(new_glide_size)

/datum/component/rotating_shield/Destroy(force, silent)
	deactivate()
	QDEL_LIST(plate_layers)
	. = ..()

/datum/component/rotating_shield/process(delta_time)
	rotate(angular_velocity, delta_time)

/datum/component/rotating_shield/proc/rotate(degrees, delta_time)
	var/base_rotation = degrees * delta_time
	for(var/i in 1 to plate_layers.len)
		var/cur_rotation = base_rotation/i
		var/datum/rs_plate_layer/rspl = plate_layers[i]
		rspl.rotate(i%2 ? cur_rotation : -cur_rotation, delta_time)

/datum/component/rotating_shield/proc/activate()
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.forceMove(get_turf(parent))

	START_PROCESSING(SSfastprocess, src)
	active = TRUE

/datum/component/rotating_shield/proc/deactivate()
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.moveToNullspace()

	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE

////////////////////////////////////////////////////////////////////////защита

/datum/component/rotating_shield/proc/find_hit_plate(angle)
	for(var/datum/rs_plate_layer/rspl in reverseList(plate_layers))
		. = rspl.find_hit_plate(angle)
		if(.)
			break

/datum/component/rotating_shield/proc/on_shielded_attackby(atom/movable/shielded_source, obj/item/I, mob/user, params)
	SIGNAL_HANDLER
	var/obj/structure/rs_plate/hit_plate = find_hit_plate(dir2angle(get_dir(shielded_source, user)))
	if(!hit_plate)
		return
	INVOKE_ASYNC(hit_plate, /atom.proc/attackby, I, user, params)
	return COMPONENT_NO_AFTERATTACK

/datum/component/rotating_shield/proc/on_shielded_bullet_act(datum/source, obj/projectile/P, def_zone)
	SIGNAL_HANDLER

/datum/component/rotating_shield/proc/on_shielded_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER

////////////////////////////////////////////////////////////////////////

/datum/component/rotating_shield/proc/get_plates()
	. = list()
	for(var/datum/rs_plate_layer/rspl in plate_layers)
		for(var/obj/structure/rs_plate/plate in rspl.plates)
			. += plate

////////////////////////////////////////////////////////////////////////

#define CHORD2CANGLE(c, r)		(2*arcsin(c/(2*r)))
#define CHORDDIST(c, r)			(sqrt(r**2 - (c/2)**2))

/datum/rs_plate_layer
	var/list/obj/structure/rs_plate/plates = list()
	var/angle = 0
	var/radius = 48

/datum/rs_plate_layer/Destroy(force, ...)
	QDEL_LIST(plates)
	. = ..()

/datum/rs_plate_layer/proc/rotate(degrees, delta_time)
	if(!plates.len)
		return
	angle += degrees
	angle %= 360
	var/angle_between_plates = (360 - get_total_plates_angle(radius))/plates.len
	var/cur_angle = angle
	for(var/obj/structure/rs_plate/plate in plates)
		var/plate_angle = CHORD2CANGLE(plate.chord_length, radius)
		var/plate_dist = CHORDDIST(plate.chord_length, radius)
		var/matrix/p_mtrx_to = new()
		p_mtrx_to.Turn(cur_angle)
		animate(plate, transform = p_mtrx_to, pixel_x = sin(cur_angle)*plate_dist, pixel_y = cos(cur_angle)*plate_dist, time = delta_time*10, flags = ANIMATION_END_NOW)
		cur_angle += plate_angle + angle_between_plates

/datum/rs_plate_layer/proc/get_total_plates_angle(r)
	. = 0
	for(var/obj/structure/rs_plate/plate in plates)
		. += CHORD2CANGLE(plate.chord_length, r)

/datum/rs_plate_layer/proc/set_radius(newradius)
	if(get_total_plates_angle(newradius) >= 360)
		return
	radius = newradius

/datum/rs_plate_layer/proc/add_plate(obj/structure/rs_plate/plate)
	if(plate.chord_length > radius * 2)
		stack_trace("Попытка вставить пластину длиной больше диаметра. Хорда: [plate.chord_length], Радиус: [radius]")
		return
	if(get_total_plates_angle(radius) + CHORD2CANGLE(plate.chord_length, radius) >= 360)
		stack_trace("Попытка вставить пластину сверх 360 градусов. Радиус: [radius], Хорда: [plate.chord_length], Угол: [get_total_plates_angle(radius)], Угол пл: [CHORD2CANGLE(plate.chord_length, radius)]")
		return
	plates.Add(plate)

/datum/rs_plate_layer/proc/find_hit_plate(hitangle)
	if(!plates.len)
		return
	var/angle_between_plates = (360 - get_total_plates_angle(radius))/plates.len
	var/cur_angle = angle
	for(var/obj/structure/rs_plate/plate in plates)
		var/plate_angle = CHORD2CANGLE(plate.chord_length, radius)
		if(cur_angle - plate_angle/2 <= hitangle && hitangle <= cur_angle + plate_angle/2)
			return plate
		cur_angle += plate_angle + angle_between_plates

#undef CHORDDIST
#undef CHORD2CANGLE

////////////////////////////////////////////////////////////////////////хрень для дебага хз че ето

/datum/component/rotating_shield/test
	angular_velocity = 30

/datum/component/rotating_shield/test/Initialize(mapload)
	. = ..()
	var/datum/rs_plate_layer/rspl1 = new
	rspl1.add_plate(new /obj/structure/rs_plate(src))
	rspl1.add_plate(new /obj/structure/rs_plate(src))

	var/datum/rs_plate_layer/rspl2 = new
	rspl2.radius = 56
	rspl2.add_plate(new /obj/structure/rs_plate(src))
	rspl2.add_plate(new /obj/structure/rs_plate(src))
	rspl2.add_plate(new /obj/structure/rs_plate(src))

	var/datum/rs_plate_layer/rspl3 = new
	rspl3.radius = 64
	rspl3.add_plate(new /obj/structure/rs_plate(src))
	rspl3.add_plate(new /obj/structure/rs_plate(src))
	rspl3.add_plate(new /obj/structure/rs_plate(src))
	rspl3.add_plate(new /obj/structure/rs_plate(src))
	rspl3.add_plate(new /obj/structure/rs_plate(src))

	plate_layers.Add(rspl1)
	plate_layers.Add(rspl2)
	plate_layers.Add(rspl3)

	activate()

/////////////////

/obj/structure/rs_plate
	name = "impact plating"
	icon = 'white/baldenysh/icons/obj/rshield.dmi'
	icon_state = "type0"
	move_resist = INFINITY
	layer = ABOVE_ALL_MOB_LAYER
	appearance_flags = LONG_GLIDE
	max_integrity = 50
	var/chord_length = 64
