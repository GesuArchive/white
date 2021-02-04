/obj/vehicle/ridden/forklift
	name = "вилочный погрузчик"
	desc = "Для детей от 18-ти лет."
	icon = 'white/valtos/icons/forklift.dmi'
	icon_state = "pog"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay = mutable_appearance(icon, "pog_overlay", ABOVE_MOB_LAYER)
	max_drivers = 1
	max_occupants = 1
	max_buckled_mobs = 1
	var/fork_on = FALSE

/datum/component/riding/vehicle/forklift
	vehicle_move_delay = 2
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/forklift/handle_specials()
	. = ..()
	for(var/i in GLOB.cardinals)
		set_vehicle_dir_layer(i, BELOW_MOB_LAYER)
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, -8), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-10, 5), TEXT_WEST = list( 10, 5)))
	set_vehicle_dir_offsets(NORTH, 0, -4)
	set_vehicle_dir_offsets(SOUTH, 0, -12)
	set_vehicle_dir_offsets(EAST, -11, -12)
	set_vehicle_dir_offsets(WEST, -28, -12)

/obj/vehicle/ridden/forklift/Initialize()
	. = ..()
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/forklift)
	initialize_controller_action_type(/datum/action/vehicle/forkmove, VEHICLE_CONTROL_PERMISSION)

/obj/vehicle/ridden/forklift/Bump(atom/A)
	. = ..()
	var/turf/target = loc
	if (!isturf(target))
		return
	if (locate(/obj/structure/table) in target.contents)
		return
	var/i = 1
	var/turf/target_turf = get_step(target, dir)
	for(var/obj/garbage in target.contents)
		if(!garbage.anchored && garbage != src)
			garbage.Move(target_turf, dir)
			i++
		if(i > BROOM_PUSH_LIMIT)
			break
	if(i > 1)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 30, TRUE, -1)

/obj/vehicle/ridden/forklift/Moved()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/atom/A in range(1, src))
		if(!(A in buckled_mobs))
			Bump(A)

/datum/action/vehicle/forkmove
	name = "Переключить вилку"
	desc = "Вжжжжжжжжжжжжжжжжжжжж!"
	button_icon_state = "skateboard_ollie"

/datum/action/vehicle/forkmove/Trigger()
	var/obj/vehicle/ridden/forklift/FL = vehicle_target
	if(!FL.fork_on)
		flick("pog_lift_anim", FL)
		FL.icon_state = "pog_lift"
		FL.overlay = mutable_appearance(FL.icon, "pog_lift_overlay", ABOVE_MOB_LAYER)
		FL.fork_on = TRUE
	else
		flick("pog_anim", FL)
		FL.icon_state = "pog"
		FL.overlay = mutable_appearance(FL.icon, "pog_overlay", ABOVE_MOB_LAYER)
		FL.fork_on = FALSE
