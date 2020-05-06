/turf/open/openspace/bluespace
	name = "голубое пространство"
	desc = "голубое"
	icon = 'code/shitcode/baldenysh/icons/turf/bluespace_openspace.dmi'
	icon_state = "buruespess"
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_MORE
	canSmoothWith = list(/turf/open/openspace/bluespace)
	baseturfs = /turf/open/openspace
	CanAtmosPassVertical = ATMOS_PASS_YES
	can_cover_up = FALSE
	can_build_on = FALSE
	requires_activation = TRUE

	var/tunnel_icon_state = "tunnel"
	var/list/fall_proctected = list()
/*
/turf/open/openspace/bluespace/Initialize(turf/rift_to = null)
	if(rift_to)
		rift(rift_to)

	..()
*/
/turf/open/openspace/bluespace/Destroy()
	close_rift()
	return ..()

/turf/open/openspace/bluespace/proc/rift(turf/below)
	below.above_override = src
	below_override = below
	below_override.CanAtmosPassVertical = ATMOS_PASS_YES

	below.update_multiz(TRUE, TRUE)
	update_multiz(TRUE, TRUE)

/turf/open/openspace/bluespace/proc/close_rift()
	if(!below_override)
		return

	below_override.above_override = null
	below_override.CanAtmosPassVertical = initial(below_override.CanAtmosPassVertical)
	below_override.update_multiz()

	below_override = null
	update_multiz()

/turf/open/openspace/bluespace/zPassOut(atom/movable/A, direction, turf/destination)
	. = ..()
	if(A.type in fall_proctected)
		return FALSE

/turf/open/openspace/bluespace/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return TRUE



/turf/open/openspace/bluespace/debug
	name = "прикольное голубое пространство"

/turf/open/openspace/bluespace/debug/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, NORTH), NORTH))
	rift(below)


/turf/open/openspace/bluespace/reverse
	name = "реверсивное прикольное голубое пространство"

/turf/open/openspace/bluespace/reverse/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, SOUTH), SOUTH))
	rift(below)
