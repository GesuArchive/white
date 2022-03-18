/datum/map_generator/labyrinth
	buildmode_name = "Pattern: Labygen"

/datum/map_generator/labyrinth/generate_terrain(list/turfs)
	// not so necessary, but for future
	. = ..()

	var/turf/cur_turf = pick(turfs)

	for(var/i in 1 to (turfs.len / 2))
		LAZYREMOVE(turfs, cur_turf)
		cur_turf = cur_turf.ChangeTurf(/turf/closed/wall, list(/turf/open/floor/plasteel), CHANGETURF_DEFER_CHANGE)
		for(var/turf/T in RANGE_TURFS(2, cur_turf))
			if(T != cur_turf && isopenturf(T))
				cur_turf = pick(turfs)
		cur_turf = get_step(cur_turf, pick(GLOB.cardinals))
