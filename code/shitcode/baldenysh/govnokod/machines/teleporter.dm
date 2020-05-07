/obj/machinery/prikol_teleporter
	name = "списанный военный блюспейс эмиттер"
	desc = "Остался еще от распила космосовка."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"

	idle_power_usage = 10
	active_power_usage = 1000
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE

	var/active = FALSE

	var/list/active_tiles = list()
	var/turf/pointer = null
	var/max_range = 6
	var/expansion_time = 5

	var/target_x = 100
	var/target_y = 100
	var/target_z = 2

/obj/machinery/prikol_teleporter/Destroy()
	start_collapse()
	return ..()

/obj/machinery/prikol_teleporter/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, .proc/can_be_rotated))

/obj/machinery/prikol_teleporter/proc/can_be_rotated(mob/user,rotation_type)
	if (anchored)
		to_chat(user, "<span class='warning'>Он прикручен к полу!</span>")
		return FALSE
	return TRUE

/obj/machinery/prikol_teleporter/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		if(!silent)
			to_chat(user, "<span class='warning'>Надо бы выключить <b>[src]</b> сначала!</span>")
		return FAILED_UNFASTEN

	return ..()

/obj/machinery/prikol_teleporter/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TRUE

////////////////////////////////////////////////////////////

/obj/machinery/prikol_teleporter/proc/get_pointer()
	if(!pointer)
		pointer_reset()
	return pointer

/obj/machinery/prikol_teleporter/proc/pointer_reset()
	pointer = get_step(src, dir)

/obj/machinery/prikol_teleporter/proc/pointer_step()

	var/turf/cur = get_step(get_pointer(), dir)

	if(!istype(cur, /turf/open))
		return FALSE
	if(get_dist_euclidian(src, cur) > max_range)
		return	FALSE
	pointer = cur
	return TRUE

/obj/machinery/prikol_teleporter/proc/start_collapse()
	for(var/turf/open/transparent/openspace/bluespace/BT in active_tiles)
		BT.start_collapse()

/obj/machinery/prikol_teleporter/proc/recursive_meksumportools()
	if(!active)
		start_collapse()
		return FALSE

	var/list/radius = circlerangeturfs(pointer, get_dist_euclidian(get_step(src, dir), get_pointer()))

	for(var/turf/open/T in radius)
		var/turf/open/transparent/openspace/bluespace/BS
		if(istype(T, /turf/open/transparent/openspace/bluespace))
			BS = T
			BS.stop_collapse()
		else
			BS = T.PlaceOnTop(/turf/open/transparent/openspace/bluespace, flags = CHANGETURF_INHERIT_AIR)

		if(!BS)
			return

		var/dx = BS.x - x
		var/dy = BS.y - y

		if(BS.rift(locate(target_x+dx, target_y+dy, target_z)))
			active_tiles += BS

	if(!pointer_step())
		return

	spawn(expansion_time)
		recursive_meksumportools()

/obj/machinery/prikol_teleporter/proc/toggle()
	active = !active
	if(!active)
		start_collapse()
	else
		pointer_reset()
		recursive_meksumportools()

/////////////////////////////////////////////////////////////////


