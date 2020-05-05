/turf/open/openspace/bluespace
	name = "голубое пространство"
	desc = "голубое"
	icon_state = "transparent"
	baseturfs = /turf/open/openspace/bluespace
	CanAtmosPassVertical = ATMOS_PASS_YES
	can_cover_up = FALSE
	can_build_on = FALSE
/*
/turf/open/openspace/bluespace/Initialize(turf/above_orr = null, turf/below_orr = null)
	if(above_orr)
		above_override = above_orr

	if(below_orr)
		below_override = below_orr

	..()

/turf/open/openspace/bluespace/above()
	return above_override

/turf/open/openspace/bluespace/below()
	return below_override
*/
/turf/open/openspace/bluespace/proc/rift(turf/below)
	below.above_override = src
	below.update_multiz(TRUE, TRUE)
	below_override = below
	update_multiz(TRUE, TRUE)

/turf/open/openspace/bluespace/debug
	name = "прикольное голубое пространство"

/turf/open/openspace/bluespace/debug/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, NORTH), NORTH))
	rift(below)

