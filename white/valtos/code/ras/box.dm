GLOBAL_LIST_EMPTY(recursive_projections)

/atom/movable/recursive_projection
	plane = RECURSIVE_PLANE
	layer = RECURSIVE_LAYER
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	density = TRUE

	var/box_width = 3 // 3 * 32
	var/box_height = 3 // 3 * 32

	var/angle = 0 // по часовой

	var/linkage_id = null
	var/atom/movable/recursive_projection/buddy_projector = null

	bound_height = 96
	bound_width = 96

/atom/movable/recursive_projection/Initialize(mapload)
	. = ..()
	GLOB.recursive_projections += src
	link_projectors()

/atom/movable/recursive_projection/proc/link_projectors()
	for(var/atom/movable/recursive_projection/RP in GLOB.recursive_projections)
		if(RP.linkage_id == linkage_id)
			buddy_projector = RP
			RP.buddy_projector = src
			buddy_projector.activate_projections()
			activate_projections()

/atom/movable/recursive_projection/proc/activate_projections()
	START_PROCESSING(SSfastprocess, src)

/atom/movable/recursive_projection/process(delta_time)
	var/matrix/M = matrix()
	M.Turn(buddy_projector.angle)

	transform = M
	vis_contents = buddy_projector.get_visible_surroundings()

/atom/movable/recursive_projection/proc/get_visible_surroundings()
	return RANGE_TURFS(15, src)

/atom/movable/recursive_projection/background
	bound_height = 32
	bound_width = 32

	density = FALSE

/atom/movable/recursive_projection/background/get_visible_surroundings()
	return RANGE_TURFS(max(box_width, box_height), src)
