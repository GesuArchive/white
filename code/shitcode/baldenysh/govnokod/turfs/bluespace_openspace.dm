/turf/open/openspace/bluespace
	name = "голубое пространство"
	desc = "голубое"
	icon_state = "transparent"
	baseturfs = /turf/open/openspace
	CanAtmosPassVertical = ATMOS_PASS_YES
	can_cover_up = FALSE
	can_build_on = FALSE
	requires_activation = TRUE

	var/list/fall_proctected = list()
/*
/turf/open/openspace/bluespace/Initialize(turf/rift_to = null)
	if(rift_to)
		rift(rift_to)

	..()
*/
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

/turf/open/openspace/bluespace/debug
	name = "прикольное голубое пространство"

/turf/open/openspace/bluespace/debug/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, NORTH), NORTH))
	rift(below)

/turf/open/openspace/bluespace/crossprikol
	name = "прикольное голубое пространство"

/turf/open/openspace/bluespace/crossprikol/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, NORTH), NORTH))
	rift(below)

	var/turf/open/openspace/bluespace/prikol = below.ChangeTurf(/turf/open/openspace/bluespace)
	prikol.rift(src)

