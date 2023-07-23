/turf/open/floor/plating/dirt
	gender = PLURAL
	name = "грязь"
	desc = "Даже если очень сильно присмотреться, это всё ещё земля."
	icon = DEFAULT_FLOORS_ICON
	icon_state = "dirt"
	base_icon_state = "dirt"
	baseturfs = /turf/open/chasm/jungle
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/plating/dirt/setup_broken_states()
	return list("dirt")

/turf/open/floor/plating/dirt/dark
	icon_state = "greenerdirt"
	base_icon_state = "greenerdirt"

/turf/open/floor/plating/dirt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/dirt/jungle
	slowdown = 0.5
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/floor/plating/dirt/jungle/dark
	icon_state = "greenerdirt"
	base_icon_state = "greenerdirt"

/turf/open/floor/plating/dirt/jungle/wasteland //Like a more fun version of living in Arizona.
	name = "засохшая грязь"
	desc = "Слишком сухая."
	icon = DEFAULT_FLOORS_ICON
	icon_state = "wasteland"
	base_icon_state = "wasteland"
	slowdown = 1
	var/floor_variance = 15

/turf/open/floor/plating/dirt/jungle/wasteland/setup_broken_states()
	return list("[initial(icon_state)]0")

/turf/open/floor/plating/dirt/jungle/wasteland/Initialize(mapload)
	. = ..()
	if(prob(floor_variance))
		icon_state = "[initial(icon_state)][rand(0,12)]"

/turf/open/floor/plating/grass/jungle
	name = "трава джунглей"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	baseturfs = /turf/open/floor/plating/dirt
	desc = "Зелёная как тот ассистент."
	icon_state = "junglegrass"
	base_icon_state = "junglegrass"
	damaged_dmi = 'icons/turf/floors/junglegrass.dmi'
	smooth_icon = 'icons/turf/floors/junglegrass.dmi'

/turf/open/floor/plating/grass/jungle/Initialize(mapload)
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		var/matrix/M = new
		M.Translate(-9, -9)
		transform = M
		icon = smooth_icon
		icon_state = "[icon_state]-[smoothing_junction]"

/turf/open/floor/plating/grass/jungle/setup_broken_states()
	return list("damaged")

/turf/closed/mineral/random/jungle
	mineralSpawnChanceList = list(/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 10,
		/obj/item/stack/ore/silver = 12, /obj/item/stack/ore/plasma = 20, /obj/item/stack/ore/iron = 40, /obj/item/stack/ore/titanium = 11,
		/obj/item/stack/ore/bluespace_crystal = 1)
	baseturfs = /turf/open/floor/plating/dirt/dark
