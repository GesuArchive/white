/datum/component/impaled
	var/obj/impaled_by
	var/atom/impaled_to

/datum/component/impaled/Initialize(obj/imp_by, atom/imp_to)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	impaled_by = imp_by
	impaled_to = imp_to

/datum/component/impaled/RegisterWithParent()
	var/mob/living/carbon/C = parent
	var/imp_dir = get_dir(impaled_to, C)
	C.dir = imp_dir
	if(imp_dir & NORTH) //эти условия не работают ваще тупа паебать
		C.base_pixel_y += 6
	if(imp_dir & SOUTH)
		C.base_pixel_y -= 6
	if(imp_dir & EAST)
		C.base_pixel_x += 6
	if(imp_dir & WEST)
		C.base_pixel_x -= 6
	//чето надо прикрутить штоб моб стоял неебу как похуй
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)

/datum/component/impaled/UnregisterFromParent()
	var/mob/living/carbon/C = parent
	C.base_pixel_x = initial(C.base_pixel_x)
	C.base_pixel_y = initial(C.base_pixel_y)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/impaled/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	if(oldloc == mover.loc)
		return

	//чето тут травмы смешные может
	qdel(src)
