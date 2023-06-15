
/datum/element/phantom
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY
	var/ghost_timer = 1 SECONDS
	var/dir_last = 0

/datum/element/phantom/Attach(datum/target, _ghost_timer)
	. = ..()
	if(!isatom(target))
		return COMPONENT_INCOMPATIBLE
	ghost_timer = _ghost_timer
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(create_phantom))

/datum/element/phantom/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/datum/element/phantom/proc/create_phantom(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	new /obj/effect/temp_visual/phantom(oldloc, mover, ghost_timer, dir_last)
	dir_last = direction

/obj/effect/temp_visual/phantom
	name = "тень"
	duration = 1 SECONDS
	alpha = 200

/obj/effect/temp_visual/phantom/Initialize(mapload, atom/movable/copywhat, ghost_timer = 1 SECONDS, dir_last)
	duration = ghost_timer
	. = ..()
	appearance = copywhat.appearance
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	setDir(copywhat.dir)
	animate(src, duration, alpha = 0, flags = ANIMATION_PARALLEL)
	var/to_pixel_x = 0
	var/to_pixel_y = 0
	switch(dir_last|dir)
		if(NORTH)
			to_pixel_x = 0
			to_pixel_y = 16
		if(NORTHEAST)
			to_pixel_x = 16
			to_pixel_y = 16
		if(EAST)
			to_pixel_x = 16
			to_pixel_y = 0
		if(SOUTHEAST)
			to_pixel_x = 16
			to_pixel_y = -16
		if(SOUTH)
			to_pixel_x = 0
			to_pixel_y = -16
		if(SOUTHWEST)
			to_pixel_x = -16
			to_pixel_y = -16
		if(WEST)
			to_pixel_x = -16
			to_pixel_y = 0
		if(NORTHWEST)
			to_pixel_x = -16
			to_pixel_y = 16
	animate(src, duration, pixel_x = to_pixel_x, pixel_y = to_pixel_y, flags = ANIMATION_PARALLEL)
