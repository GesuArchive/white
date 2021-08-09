/obj/item/rotating_shield
	name = "RS controller"
	icon = 'white/baldenysh/icons/obj/rshield.dmi'
	icon_state = "type0"

	var/atom/movable/shielded_atom
	var/list/datum/rs_plate_layer/plate_layers = list()
	var/angular_velocity = 30
	var/active = FALSE

/obj/item/rotating_shield/Initialize()
	. = ..()
	RegisterShielded(ismovable(loc) ? loc : src)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, .proc/on_moved)

/obj/item/rotating_shield/Destroy()
	. = ..()
	UnregisterShielded()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)

/obj/item/rotating_shield/proc/on_moved(datum/source, newloc, dir)
	UnregisterShielded()
	RegisterShielded(ismovable(loc) ? loc : src)

/obj/item/rotating_shield/proc/RegisterShielded(atom/movable/A)
	if(!istype(A))
		return
	shielded_atom = A
	RegisterSignal(A, COMSIG_MOVABLE_MOVED, .proc/on_shielded_moved)
	RegisterSignal(A, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, .proc/on_shielded_glide_size_update)
	on_shielded_moved()

	RegisterSignal(A, COMSIG_PARENT_ATTACKBY, .proc/on_shielded_attackby)
	RegisterSignal(A, COMSIG_ATOM_BULLET_ACT, .proc/on_shielded_bullet_act)
	RegisterSignal(A, COMSIG_ATOM_HITBY, .proc/on_shielded_hitby)

/obj/item/rotating_shield/proc/UnregisterShielded()
	UnregisterSignal(shielded_atom, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(shielded_atom, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE)

	UnregisterSignal(shielded_atom, COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(shielded_atom, COMSIG_ATOM_BULLET_ACT)
	UnregisterSignal(shielded_atom, COMSIG_ATOM_HITBY)

////////////////////////////////////////////////////////////////////////перемещение/анимация

/obj/item/rotating_shield/proc/on_shielded_moved(datum/source, newloc, dir)
	if(!active)
		return
	var/turf/T = get_turf(loc)
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.forceMove(T)

/obj/item/rotating_shield/proc/on_shielded_glide_size_update(datum/source, new_glide_size)
	set_glide_size(new_glide_size)
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.set_glide_size(new_glide_size)

/obj/item/rotating_shield/Destroy(force, silent)
	deactivate()
	QDEL_LIST(plate_layers)
	. = ..()

/obj/item/rotating_shield/process(delta_time)
	rotate(angular_velocity, delta_time)

/obj/item/rotating_shield/proc/rotate(degrees, delta_time)
	var/base_rotation = degrees * delta_time
	for(var/i in 1 to plate_layers.len)
		var/cur_rotation = base_rotation/i
		var/datum/rs_plate_layer/rspl = plate_layers[i]
		rspl.rotate(i%2 ? cur_rotation : -cur_rotation, delta_time)

/obj/item/rotating_shield/proc/activate()
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.forceMove(get_turf(shielded_atom))
		plate.control = src

	START_PROCESSING(SSfastprocess, src)
	active = TRUE

/obj/item/rotating_shield/proc/deactivate()
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.forceMove(src)
		plate.control = null

	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE

////////////////////////////////////////////////////////////////////////защита

/obj/item/rotating_shield/proc/on_shielded_attackby(datum/source, obj/item/I, mob/user)

/obj/item/rotating_shield/proc/on_shielded_bullet_act(datum/source, obj/projectile/P, def_zone)

/obj/item/rotating_shield/proc/on_shielded_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
/*
/obj/item/rotating_shield/proc/find_plate_by_angle(angle)
	for(var/l in plate_layers.len to 1)
		for(var/obj/structure/rs_plate/plate in plate_layers[l])
*/
////////////////////////////////////////////////////////////////////////

/obj/item/rotating_shield/proc/get_plates()
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

/datum/rs_plate_layer/proc/rotate(degrees, delta_time)
	var/last_angle = angle
	angle += degrees
	angle %= 360
	for(var/obj/structure/rs_plate/plate in plates)
		var/matrix/p_mtrx_to = new()
		p_mtrx_to = plate.transform
		p_mtrx_to.Turn(angle-last_angle)
		animate(plate, transform = p_mtrx_to, time = delta_time*10, flags = ANIMATION_END_NOW)

/datum/rs_plate_layer/proc/get_total_plates_angle(r)
	. = 0
	for(var/obj/structure/rs_plate/plate in plates)
		. += CHORD2CANGLE(plate.chord_length, r)

/datum/rs_plate_layer/proc/set_radius(newradius)
	if(get_total_plates_angle(newradius) >= 360)
		return
	radius = newradius
	regen_visuals()

/datum/rs_plate_layer/proc/add_plate(obj/structure/rs_plate/plate)
	if(plate.chord_length > radius * 2)
		stack_trace("Попытка вставить пластину длиной больше диаметра. Хорда: [plate.chord_length], Радиус: [radius]")
		return
	if(get_total_plates_angle(radius) + CHORD2CANGLE(plate.chord_length, radius) >= 360)
		stack_trace("Попытка вставить пластину сверх 360 . Радиус: [radius], Хорда: [plate.chord_length], Угол: [get_total_plates_angle(radius)], Угол пл: [CHORD2CANGLE(plate.chord_length, radius)]")
		return
	plates.Add(plate)
	regen_visuals()

/datum/rs_plate_layer/proc/regen_visuals()
	if(!plates.len)
		return
	var/angle_between_plates = (360 - get_total_plates_angle(radius))/plates.len
	var/cur_angle = angle
	for(var/obj/structure/rs_plate/plate in plates)
		var/plate_angle = CHORD2CANGLE(plate.chord_length, radius)
		animate(plate)
		var/matrix/p_mtrx = new()
		p_mtrx.Translate(0, CHORDDIST(plate.chord_length, radius))
		p_mtrx.Turn(cur_angle)
		plate.transform = p_mtrx
		cur_angle += plate_angle + angle_between_plates

/datum/rs_plate_layer/proc/check_hit(hitangle)
	if(!plates.len)
		return
	var/angle_between_plates = (360 - get_total_plates_angle(radius))/plates.len
	var/cur_angle = angle
	for(var/obj/structure/rs_plate/plate in plates)
		var/plate_angle = CHORD2CANGLE(plate.chord_length, radius)
		if(cur_angle <= hitangle && hitangle <= cur_angle + plate_angle)
			return plate
		cur_angle += plate_angle + angle_between_plates

#undef CHORDDIST
#undef CHORD2CANGLE

////////////////////////////////////////////////////////////////////////хрень для дебага хз че ето

/obj/item/rotating_shield/test
	name = "RSE-00"

/obj/item/rotating_shield/test/Initialize()
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
	var/obj/item/rotating_shield/control
	var/chord_length = 64
