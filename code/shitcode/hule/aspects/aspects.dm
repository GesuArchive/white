/datum/round_aspect
	var/name = "Nothing"
	var/weight = 10

/datum/round_aspect/proc/run_aspect()
	SSblackbox.record_feedback("tally", "aspect", 1, name) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/round_aspect/random_appearance
	name = "Случайная внешность"
	weight = 3

/datum/round_aspect/random_appearance/run_aspect()
	CONFIG_SET(flag/force_random_names, TRUE)
	..()

/datum/round_aspect/bom_bass
	name = "Свершение Прикола"
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

/datum/round_aspect/unpower
	name = "Свет не завезли"
	weight = 4

/datum/round_aspect/unpower/run_aspect()
	power_failure()
	..()
