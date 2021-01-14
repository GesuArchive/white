/obj/vehicle/ridden/forklift
	name = "вилочный погрузчик"
	desc = "Для детей от 18-ти лет."
	icon = 'white/valtos/icons/forklift.dmi'
	icon_state = "forklift"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay = mutable_appearance(icon, "forklift_cover", ABOVE_MOB_LAYER)
	max_drivers = 1
	max_occupants = 1
	max_buckled_mobs = 1
	pixel_y = 0
	pixel_x = -24
	var/picking_up = FALSE

/datum/component/riding/vehicle/forklift
	vehicle_move_delay = 2
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/forklift/handle_specials()
	. = ..()
	for(var/i in GLOB.cardinals)
		set_vehicle_dir_layer(i, BELOW_MOB_LAYER)

/obj/vehicle/ridden/forklift/Initialize()
	. = ..()
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/forklift)

/obj/vehicle/ridden/forklift/Bump(atom/A)
	. = ..()
	if(!A.density || !has_buckled_mobs())
		return

	var/atom/movable/AM = get_edge_target_turf(A, dir)
	var/t = get_dir(src, AM)
	if(isobj(AM) && !AM.anchored)
		if(AM.Move(get_step(AM.loc, t), t, glide_size))
			Move(get_step(loc, t), t)

/obj/vehicle/ridden/forklift/Moved()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/atom/A in range(1, src))
		if(!(A in buckled_mobs))
			Bump(A)
