/obj/item/rotating_shield
	name = "RS controller"
	icon = 'white/baldenysh/icons/obj/rshield.dmi'
	icon_state = "type0"

	var/atom/movable/shielded_atom
	var/list/plate_layers = list(list())
	var/angle = 0
	var/angular_velocity = 120
	var/radius = 32
	var/plate_layer_radius_diff = 12
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

/obj/item/rotating_shield/proc/UnregisterShielded()
	UnregisterSignal(shielded_atom, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(shielded_atom, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE)

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
	. = ..()
	QDEL_LIST(plate_layers)

/obj/item/rotating_shield/process(delta_time)
	var/last_angle = angle
	angle += angular_velocity * delta_time
	angle %= 360
	var/matrix/mtrx_from = new()
	var/matrix/mtrx_to = new()
	mtrx_from.Turn(last_angle)
	mtrx_to.Turn(angle)
	transform = mtrx_from
	animate(src, transform = mtrx_to, time = delta_time*10, flags = ANIMATION_END_NOW)
	var/i = 0
	for(var/list/plate_layer in plate_layers)
		if(!plate_layer.len)
			continue
		for(var/obj/structure/rs_plate/plate in plate_layer)
			var/matrix/p_mtrx_to = plate.transform
			p_mtrx_to.Turn((i%2? 1 : -1)*(angle - last_angle))
			animate(plate, transform = p_mtrx_to, time = delta_time*10, flags = ANIMATION_END_NOW)
		i++

/obj/item/rotating_shield/proc/activate()
	var/i = 0
	for(var/list/plate_layer in plate_layers)
		if(!plate_layer.len)
			continue
		var/j = 0
		for(var/obj/structure/rs_plate/plate in plate_layer)
			animate(plate)
			var/matrix/p_mtrx = new()
			p_mtrx.Translate(0, radius + plate_layer_radius_diff*i)
			p_mtrx.Turn((i%2? 1 : -1)*(angle) + j*360/plate_layer.len)
			plate.transform = p_mtrx
			plate.forceMove(get_turf(shielded_atom))
			plate.control = src
			j++
		i++

	START_PROCESSING(SSfastprocess, src)
	active = TRUE

/obj/item/rotating_shield/proc/deactivate()
	for(var/obj/structure/rs_plate/plate in get_plates())
		plate.forceMove(src)
		plate.control = null

	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE

/obj/item/rotating_shield/proc/get_plates()
	. = list()
	for(var/list/plate_layer in plate_layers)
		for(var/obj/structure/rs_plate/plate in plate_layer)
			. += plate

/obj/item/rotating_shield/proc/add_plating_to_layer(obj/structure/rs_plate/plate, plate_layer)
	if(plate_layers.len < plate_layer)
		for(var/i in plate_layers.len to plate_layer)
			plate_layers.Add(list(list()))
	plate_layers[plate_layer] += plate

/////////////////

/obj/item/rotating_shield/test
	name = "RSE-01"

/obj/item/rotating_shield/test/Initialize()
	. = ..()
	add_plating_to_layer(new /obj/structure/rs_plate(src), 1)
	add_plating_to_layer(new /obj/structure/rs_plate(src), 1)
	add_plating_to_layer(new /obj/structure/rs_plate(src), 2)
	add_plating_to_layer(new /obj/structure/rs_plate(src), 2)
	add_plating_to_layer(new /obj/structure/rs_plate(src), 2)
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
	var/def_degrees = 90
