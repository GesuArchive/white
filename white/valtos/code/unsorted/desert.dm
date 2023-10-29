/turf/open/floor/dune
	name = "дюны"
	icon = 'white/valtos/icons/dune/dune.dmi'
	icon_state = "dune-255"
	base_icon_state = "dune"
	var/static/list/random_bits = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 21, 23, 29, 31, 38, 39, 46, 47, 55, 63, 74, 75, 78, 95, 110, 111, 127, 137, 139, 141, 143, 157, 159, 175, 191, 203, 207, 223, 239, 255)
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	baseturfs = /turf/open/floor/dune

/turf/open/floor/dune/setup_broken_states()
	return list("[base_icon_state]-[pick(random_bits)]")

/turf/open/floor/dune/setup_burnt_states()
	return list("[base_icon_state]-[pick(random_bits)]")

/turf/open/floor/dune/Initialize(mapload)
	. = ..()
	randomify()

/turf/open/floor/dune/proc/randomify()
	icon_state = "[base_icon_state]-[pick(random_bits)]"

/turf/open/floor/dune/desert
	icon = 'white/valtos/icons/dune/desert.dmi'
	icon_state = "desert-255"
	base_icon_state = "desert"

/turf/open/floor/dune/grass
	icon = 'white/valtos/icons/dune/dune_grass.dmi'
	icon_state = "dune_grass-255"
	base_icon_state = "dune_grass"

/turf/open/floor/dune/sandstone
	icon = 'white/valtos/icons/dune/sandstone.dmi'
	icon_state = "sandstone-255"
	base_icon_state = "sandstone"

/turf/open/floor/dune/sandy
	icon = 'white/valtos/icons/dune/sandy.dmi'
	icon_state = "sandy-255"
	base_icon_state = "sandy"

/turf/open/floor/dune/scorched_sand
	icon = 'white/valtos/icons/dune/scorched_sand.dmi'
	icon_state = "scorched_sand-255"
	base_icon_state = "scorched_sand"

/turf/open/floor/dune/desertrocks
	icon = 'white/valtos/icons/dune/desertrocks.dmi'
	icon_state = "desertrocks-255"
	base_icon_state = "desertrocks"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_DESERT_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_DESERT_FLOOR)

/turf/open/floor/dune/desertrocks/randomify()
	return
