/turf/open/floor/plating/is12
	name = "грязь"
	icon = 'white/valtos/icons/is12/turfs.dmi'
	icon_state = "dirt"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/is12/dirt
	icon_state = "dirt"
	slowdown = 2

/turf/open/floor/plating/is12/dirt/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.alldirs)
	if(prob(50))
		icon_state = "dirt1"

/turf/open/floor/plating/is12/surface
	name = "светлая грязь"
	icon_state = "surface"
	slowdown = 1

/turf/open/floor/plating/is12/surface/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.alldirs)
	if(prob(50))
		icon_state = "surface1"

/turf/open/floor/plating/is12/mud
	name = "слякоть"
	icon_state = "mud"
	slowdown = 3

/turf/open/floor/plating/is12/mud/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.alldirs)

/turf/open/floor/plating/is12/rock
	name = "камень"
	icon_state = "greatrock"
	slowdown = 1

/turf/open/floor/plating/is12/wwidirt
	name = "старая грязь"
	icon_state = "wwidirt"
	slowdown = 2

/turf/open/floor/plating/is12/wwidirtplating
	name = "старая твёрдая грязь"
	icon_state = "wwidirtplating"
	slowdown = 1.5

/turf/open/floor/plating/is12/trenchcenter
	name = "старые доски"
	icon_state = "trenchcenter"
	slowdown = 1

/turf/open/floor/plating/is12/wood
	name = "доски"
	icon = 'white/valtos/icons/is12/wood.dmi'
	icon_state = "wood-0"
	base_icon_state = "wood"
	slowdown = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_STELLAR)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_STELLAR)
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
