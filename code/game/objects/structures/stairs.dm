#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

// dir determines the direction of travel to go upwards
// stairs require /turf/open/openspace as the tile above them to work, unless your stairs have 'force_open_above' set to TRUE
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "лестница"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	anchored = TRUE

	var/force_open_above = FALSE // replaces the turf above this stair obj with /turf/open/openspace
	var/terminator_mode = STAIR_TERMINATOR_AUTOMATIC
	var/turf/listeningTo

/obj/structure/stairs/welder_act(mob/living/user, obj/item/I)

	var/obj/item/weldingtool/WT = I

	if(!WT.isOn())
		return FALSE

	if(!anchored)
		anchored = TRUE
		to_chat(user, span_notice("Намертво привариваю лестницу."))
		playsound(loc, 'sound/items/welder2.ogg', 25, TRUE)
		return TRUE


	if(obj_integrity == max_integrity)
		to_chat(user, span_warning("[src] не нуждается в ремонте."))
		return TRUE

	user.visible_message(span_notice("[user] начинает заваривать пробоины в лестнице."),
	span_notice("Начинаю заваривать пробоины в лестнице."))
	playsound(loc, 'sound/items/welder2.ogg', 25, TRUE)

	if(!do_after(user, 5 SECONDS, src))
		return TRUE

	if(obj_integrity <= max_integrity * 0.3 || obj_integrity == max_integrity)
		return TRUE

	if(!WT.use(2))
		to_chat(user, span_warning("Вам не хватает сварочного топлива для ремонта."))
		return TRUE

	user.visible_message(span_notice("[user] заварил пробоины в лестнице."),
	span_notice("Вы заварили пробоины в лестнице."))
	repair_damage(max_integrity)
	playsound(loc, 'sound/items/welder2.ogg', 25, TRUE)

	return TRUE
/obj/structure/stairs/examine(mob/user)
	. = ..()
	if(!anchored)
		. += "<hr>"
		. += span_smallnotice("Можно приварить к полу сваркой.")

/obj/structure/stairs/unanchored
	anchored =  FALSE

/obj/structure/stairs/north
	dir = NORTH

/obj/structure/stairs/south
	dir = SOUTH

/obj/structure/stairs/east
	dir = EAST

/obj/structure/stairs/west
	dir = WEST

/obj/structure/stairs/Initialize(mapload)
	GLOB.stairs += src
	if(force_open_above)
		force_open_above()
		build_signal_listener()
	update_surrounding()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddComponent(/datum/component/connect_loc_behalf, src, loc_connections)
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))

	return ..()
/obj/structure/stairs/proc/can_be_rotated(mob/user,rotation_type)
	return !anchored

/obj/structure/stairs/Destroy()
	listeningTo = null
	GLOB.stairs -= src
	return ..()

/obj/structure/stairs/Move() //Look this should never happen but...
	. = ..()
	if(force_open_above)
		build_signal_listener()
	update_surrounding()

/obj/structure/stairs/proc/update_surrounding()
	update_icon()
	for(var/i in GLOB.cardinals)
		var/turf/T = get_step(get_turf(src), i)
		var/obj/structure/stairs/S = locate() in T
		if(S)
			S.update_icon()

/obj/structure/stairs/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!isobserver(leaving) && isTerminator() && direction == dir)
		leaving.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		INVOKE_ASYNC(src, PROC_REF(stair_ascend), leaving)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/stairs/Cross(atom/movable/AM)
	if(isTerminator() && (get_dir(src, AM) == dir))
		return FALSE
	return ..()

/obj/structure/stairs/update_icon_state()
	icon_state = "stairs[isTerminator() ? "_t" : null]"
	return ..()

/obj/structure/stairs/proc/stair_ascend(atom/movable/climber)
	var/turf/checking = get_step_multiz(get_turf(src), UP)
	if(!istype(checking))
		return
	if(!checking.zPassIn(climber, UP, get_turf(src)))
		return
	var/turf/target = get_step_multiz(get_turf(src), (dir|UP))
	if(!istype(target))
		return
	for(var/obj/O in target.contents)
		climber.Bump(O)
		if(!O.CanPass(climber))
			return
	if(!climber.can_z_move(DOWN, target, z_move_flags = ZMOVE_FALL_FLAGS)) //Don't throw them into a tile that will just dump them back down.
		climber.zMove(target = target, z_move_flags = ZMOVE_STAIRS_FLAGS)
		/// Moves anything that's being dragged by src or anything buckled to it to the stairs turf.
		climber.pulling?.move_from_pull(climber, loc, climber.glide_size)
		for(var/mob/living/buckled as anything in climber.buckled_mobs)
			buckled.pulling?.move_from_pull(buckled, loc, buckled.glide_size)

/obj/structure/stairs/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	if(var_name != NAMEOF(src, force_open_above))
		return
	if(!var_value)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_TURF_MULTIZ_NEW)
			listeningTo = null
	else
		build_signal_listener()
		force_open_above()

/obj/structure/stairs/proc/build_signal_listener()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_TURF_MULTIZ_NEW)
	var/turf/open/openspace/T = get_step_multiz(get_turf(src), UP)
	RegisterSignal(T, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_new))
	listeningTo = T

/obj/structure/stairs/proc/force_open_above()
	var/turf/open/openspace/T = get_step_multiz(get_turf(src), UP)
	if(T && !istype(T))
		T.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_INHERIT_AIR)

/obj/structure/stairs/proc/on_multiz_new(turf/source, dir)
	SIGNAL_HANDLER

	if(dir == UP)
		var/turf/open/openspace/T = get_step_multiz(get_turf(src), UP)
		if(T && !istype(T))
			T.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_INHERIT_AIR)

/obj/structure/stairs/intercept_zImpact(list/falling_movables, levels = 1)
	. = ..()
	if(levels == 1 && isTerminator()) // Stairs won't save you from a steep fall.
		. |= FALL_INTERCEPTED | FALL_NO_MESSAGE | FALL_RETAIN_PULL

/obj/structure/stairs/proc/isTerminator() //If this is the last stair in a chain and should move mobs up
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return (terminator_mode == STAIR_TERMINATOR_YES)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/turf/them = get_step(T, dir)
	if(!them)
		return FALSE
	for(var/obj/structure/stairs/S in them)
		if(S.dir == dir)
			return FALSE
	return TRUE
