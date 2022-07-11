/turf/open/floor/dune
	name = "дюны"
	icon = 'white/valtos/icons/dune/dune.dmi'
	icon_state = "dune-255"
	base_icon_state = "dune"

/turf/open/floor/dune/Initialize(mapload)
	. = ..()
	randomify()

/turf/open/floor/dune/proc/randomify()
	var/random_bit = (1 << 0)
	for(var/i in 1 to 7)
		if(prob(15))
			random_bit |= (1 << i)

	icon_state = "[base_icon_state]-[random_bit]"

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
