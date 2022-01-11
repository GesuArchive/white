/obj/vehicle/ridden/forklift
	name = "вилочный погрузчик"
	desc = "Для детей от 18-ти лет."
	icon = 'white/valtos/icons/forklift.dmi'
	icon_state = "pog"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay = mutable_appearance(icon, "pog_overlay", ABOVE_MOB_LAYER)
	var/mutable_appearance/load_overlay
	max_drivers = 1
	max_occupants = 1
	max_buckled_mobs = 1
	var/fork_on = FALSE
	var/forkbusy = FALSE
	var/motherfucker = FALSE

	var/atom/movable/THING

/datum/component/riding/vehicle/forklift
	vehicle_move_delay = 2
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/forklift/handle_specials()
	. = ..()
	for(var/i in GLOB.cardinals)
		set_vehicle_dir_layer(i, BELOW_MOB_LAYER)
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 4), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-2, 11), TEXT_WEST = list(2, 11)))
	set_vehicle_dir_offsets(NORTH, 0, 0)
	set_vehicle_dir_offsets(SOUTH, 0, -10)
	set_vehicle_dir_offsets(EAST, -13, 0)
	set_vehicle_dir_offsets(WEST, -26, 0)

/obj/vehicle/ridden/forklift/Initialize()
	. = ..()
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/forklift)
	initialize_controller_action_type(/datum/action/vehicle/forkmove)

/obj/vehicle/ridden/forklift/Bump(atom/A)
	. = ..()
	if(.)
		return
	if(!A.density || !has_buckled_mobs())
		return
	if(isobj(A))
		var/obj/obj_obstacle = A
		if(!obj_obstacle.anchored && obj_obstacle.move_resist <= move_force)
			step(A, dir)
	else if(ismob(A))
		var/mob/mob_obstacle = A
		if(mob_obstacle.move_resist <= move_force)
			step(A, dir)

/obj/vehicle/ridden/forklift/proc/toggle_fork()
	if(forkbusy)
		return
	canmove = FALSE
	forkbusy = TRUE
	if(!fork_on)
		flick("pog_lift_anim", src)
		icon_state = "pog_lift"
		overlay = mutable_appearance(icon, "pog_lift_overlay", ABOVE_MOB_LAYER)
		addtimer(CALLBACK(src, .proc/toggle_busy), 20)
		playsound(src, 'sound/vehicles/clowncar_cannonmode2.ogg', 75)
		visible_message(span_danger("[capitalize(src.name)] поднимает вилку."))
		fork_on = TRUE
		pick_front()
	else
		flick("pog_anim", src)
		icon_state = "pog"
		overlay = mutable_appearance(src, "pog_overlay", ABOVE_MOB_LAYER)
		addtimer(CALLBACK(src, .proc/toggle_busy), 20)
		playsound(src, 'sound/vehicles/clowncar_cannonmode1.ogg', 75)
		visible_message(span_danger("[capitalize(src.name)] опускает вилку."))
		fork_on = FALSE
		drop_front()

/obj/vehicle/ridden/forklift/proc/toggle_busy()
	canmove = TRUE
	forkbusy = FALSE

/obj/vehicle/ridden/forklift/proc/pick_front()
	if(THING)
		return
	var/turf/T = get_step(get_turf(src), dir)
	if(motherfucker)
		for(var/mob/M in T)
			THING = M
			break
	else
		for(var/obj/structure/closet/S in T)
			THING = S
			break
	if(THING)
		THING.forceMove(src)
		load_overlay = mutable_appearance(THING.icon, THING.icon_state, layer + 0.01)
		add_overlay(load_overlay)
		RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, .proc/update_visuals)

/obj/vehicle/ridden/forklift/proc/drop_front()
	if(THING)
		THING.forceMove(get_step(get_turf(src), dir))
		THING.pixel_y = initial(THING.pixel_y)
		THING.layer = initial(THING.layer)
		THING.plane = initial(THING.plane)
		THING = null
		cut_overlay(load_overlay)
		UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/obj/vehicle/ridden/forklift/proc/update_visuals()
	SIGNAL_HANDLER
	if(THING)
		switch(dir)
			if(NORTH)
				load_overlay.pixel_y = initial(THING.pixel_y) + 48
				load_overlay.pixel_y = initial(THING.pixel_x)
			if(SOUTH)
				load_overlay.pixel_y = initial(THING.pixel_y) - 16
				load_overlay.pixel_y = initial(THING.pixel_x)
			if(WEST)
				load_overlay.pixel_y = initial(THING.pixel_y) + 32
				load_overlay.pixel_y = initial(THING.pixel_x) + 32
			if(EAST)
				load_overlay.pixel_y = initial(THING.pixel_y) + 32
				load_overlay.pixel_y = initial(THING.pixel_x) - 32

/datum/action/vehicle/forkmove
	name = "Переключить вилку"
	desc = "Вжжжжжжжжжжжжжжжжжжжж!"
	button_icon_state = "skateboard_ollie"

/datum/action/vehicle/forkmove/Trigger()
	var/obj/vehicle/ridden/forklift/FL = vehicle_target
	FL.toggle_fork()
