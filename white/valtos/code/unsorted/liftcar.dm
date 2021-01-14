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
	var/turf/target = loc
	if (!isturf(target))
		return
	if (locate(/obj/structure/table) in target.contents)
		return
	var/i = 1
	var/turf/target_turf = get_step(target, dir)
	var/obj/machinery/disposal/bin/target_bin = locate(/obj/machinery/disposal/bin) in target_turf.contents
	for(var/obj/garbage in target.contents)
		if(!garbage.anchored)
			if (target_bin)
				garbage.forceMove(target_bin)
			else
				garbage.Move(target_turf, dir)
			i++
		if(i > BROOM_PUSH_LIMIT)
			break
	if(i > 1)
		if (target_bin)
			target_bin.update_icon()
			to_chat(occupants, "<span class='notice'>Заталкиваю всё в мусорку.</span>")
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 30, TRUE, -1)

/obj/vehicle/ridden/forklift/Moved()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/atom/A in range(1, src))
		if(!(A in buckled_mobs))
			Bump(A)
