
/datum/element/phantom
	element_flags = ELEMENT_DETACH

/datum/element/phantom/Attach(datum/target)
	. = ..()
	if(!isatom(target))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/create_phantom)

/datum/element/phantom/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/datum/element/phantom/proc/create_phantom(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	new /obj/effect/temp_visual/phantom(oldloc, mover)

/obj/effect/temp_visual/phantom
	name = "тень"
	duration = 1 SECONDS
	alpha = 200

/obj/effect/temp_visual/phantom/Initialize(mapload, atom/movable/copywhat)
	. = ..()
	appearance = copywhat.appearance
	setDir(copywhat.dir)
	animate(src, 1 SECONDS, alpha = 0, flags = ANIMATION_PARALLEL)
	if(dir == NORTH || dir == SOUTH)
		animate(src, 1 SECONDS, pixel_y = (dir == NORTH ? 16 : -16), flags = ANIMATION_PARALLEL)
	else if (dir == EAST || dir == WEST)
		animate(src, 1 SECONDS, pixel_x = (dir == EAST ? 16 : -16), flags = ANIMATION_PARALLEL)
