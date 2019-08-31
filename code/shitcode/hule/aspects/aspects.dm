/datum/round_aspect
	var/name = "Nothing"
	var/weight = 10

/datum/round_aspect/proc/run_aspect()
	SSblackbox.record_feedback("tally", "aspect", 1, name) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/round_aspect/random_appearance
	name = "Random appearance"
	weight = 3

/datum/round_aspect/random_appearance/run_aspect()
	CONFIG_SET(flag/force_random_names, TRUE)
	..()

/datum/round_aspect/bom_bass
	name = "Bombass"
	weight = 7

/datum/round_aspect/bom_bass/run_aspect()
	var/expcount = rand(2,4)

	var/list/possible_spawns = list()
	for(var/turf/X in GLOB.xeno_spawn)
		if(istype(X.loc, /area/maintenance))
			possible_spawns += X

	var/i
	for(i=0, i<expcount, i++)
		explosion(pick_n_take(possible_spawns), 5, 7, 14)
	..()

/datum/round_aspect/power_failure
	name = "Power Failure"
	weight = 4

/datum/round_aspect/power_failure/run_aspect()
	for(var/obj/machinery/power/smes/S in GLOB.machines)
		if(istype(get_area(S), /area/ai_monitored/turret_protected) || !is_station_level(S.z) || istype(get_area(S), /area/tcommsat/server))
			continue
		S.charge = 0
		S.output_level = 0
		S.output_attempt = FALSE
		S.update_icon()
		S.power_change()

	for(var/area/A in GLOB.the_station_areas)
		if(!A.requires_power || A.always_unpowered || istype(get_area(S), /area/tcommsat/server))
			continue
		if(GLOB.typecache_powerfailure_safe_areas[A.type])
			continue

		A.power_light = FALSE
		A.power_equip = FALSE
		A.power_environ = FALSE
		A.power_change()

	for(var/obj/machinery/power/apc/C in GLOB.apcs_list)
		if(istype(get_area(C), /area/ai_monitored/turret_protected) || istype(get_area(C), /area/tcommsat/server))
			continue
		if(C.cell && is_station_level(C.z))
			var/area/A = C.area
			if(GLOB.typecache_powerfailure_safe_areas[A.type])
				continue

			C.cell.charge = 0

	..()
