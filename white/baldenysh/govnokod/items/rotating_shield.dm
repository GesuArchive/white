/obj/item/rotating_shield
	name = "RS controller"
	icon = 'white/baldenysh/icons/obj/rshield.dmi'
	icon_state = "layer1"
	var/atom/shielded_atom
	var/list/plate_layers = list(list())
	var/angle = 0
	var/angular_velocity = 30
	var/radius = 32
	var/plate_layer_radius_diff = 12
	var/active = FALSE

/obj/item/rotating_shield/Initialize()
	shielded_atom = src

/obj/item/rotating_shield/Destroy(force, silent)
	. = ..()
	QDEL_LIST(plate_layers)

/obj/item/rotating_shield/process(delta_time)
	angle += angular_velocity * delta_time
	angle %= 360

/obj/item/rotating_shield/proc/activate()
	var/i = 0
	for(var/list/plate_layer in plate_layers)
		if(!plate_layer.len)
			continue
		var/j = 0
		for(var/obj/structure/rs_plate/plate in plate_layer)
			var/matrix/mtrx = new()
			mtrx.Translate(0, radius + plate_layer_radius_diff*i)
			mtrx.Turn(angle + j*360/plate_layer.len)
			plate.transform = mtrx
			plate.orbit(src, 0, i%2, 360 - angular_velocity, 12, FALSE)
			j++
		i++

	START_PROCESSING(SSfastprocess, src)
	active = TRUE

/obj/item/rotating_shield/proc/deactivate()
	for(var/list/plate_layer in plate_layers)
		for(var/obj/structure/rs_plate/plate in plate_layer)
			plate.forceMove(src)

	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE

/obj/item/rotating_shield/proc/add_plating_to_layer(obj/structure/rs_plate/plate, plate_layer)
	if(plate_layers.len < plate_layer)
		for(var/i in plate_layers.len to plate_layer)
			plate_layers.Add(list(list()))
	plate_layers[plate_layer].Add(plate)

/obj/item/rotating_shield/proc/on_loc_change()

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
	max_integrity = 50
	var/def_degrees = 90
