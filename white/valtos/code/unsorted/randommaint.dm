/datum/map_generator_module/border/maint_walls
	spawnableAtoms = list()
	spawnableTurfs = list(/turf/closed/wall = 80, /turf/closed/wall/r_wall = 15, /obj/effect/spawner/structure/window/reinforced/with_plating = 5)

/obj/effect/spawner/structure/window/reinforced/with_plating
	name = "reinforced window spawner with plating"
	icon_state = "rwindow_spawner"
	spawn_list = list(/turf/open/floor/plating, /obj/structure/grille, /obj/structure/window/reinforced/fulltile)

/datum/map_generator_module/splatter_layer/maint_walls
	clusterCheckFlags = CLUSTER_CHECK_SAME_TURFS
	spawnableAtoms = list()
	spawnableTurfs = list(/turf/closed/wall = 5, /turf/closed/wall/r_wall = 1)

/datum/map_generator_module/splatter_layer/main_spawn
	spawnableTurfs = list()
	clusterCheckFlags = CLUSTER_CHECK_NONE
	spawnableAtoms = list(/obj/structure/grille/broken = 5,
						  /obj/structure/grille = 15,
						  /obj/structure/girder = 5,
						  /obj/effect/spawner/structure/window = 5,
						  /obj/effect/spawner/lootdrop/maintenance/two = 5,
						  /obj/effect/spawner/lootdrop/maintenance/three = 3,
						  /obj/effect/spawner/lootdrop/maintenance/eight = 1,
						  /obj/effect/spawner/lootdrop/crate_spawner = 5,
						  /mob/living/simple_animal/hostile/cockroach = 5,
						  /mob/living/simple_animal/hostile/rat = 5,
						  /obj/structure/table = 20,
						  /obj/structure/chair = 15,
						  /obj/structure/chair/stool = 10)

/datum/map_generator_module/bottom_layer/maint_turfs
	spawnableTurfs = list(/turf/open/floor/plating = 100)

/datum/map_generator/station_maints_generator
	var/name = "Генератор техтоннелей"
	var/list/open_turf_types   = list(/turf/open/floor/plating = 1)
	var/list/closed_turf_types = list(/turf/closed/wall = 2, /turf/closed/wall/r_wall = 1)

	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_closed_chance = 45

	///Amount of smoothing iterations
	var/smoothing_iterations = 20

	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4

	///How little neighbours does a alive cell need to die
	var/death_limit = 3

	/*
	modules = list(/datum/map_generator_module/bottom_layer/maint_turfs, \
		/datum/map_generator_module/splatter_layer/maint_walls, \
		/datum/map_generator_module/splatter_layer/main_spawn, \
		/datum/map_generator_module/border/maint_walls, \
		/datum/map_generator_module/bottom_layer/repressurize)
	buildmode_name = "Pattern: Station Maintenance Level"
	*/

/area/maintenance/bottom_station_maints
	name = "Технические тоннели"
	icon_state = "amaint"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/station_maints_generator

/datum/map_generator/station_maints_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	for(var/i in turfs) //Go through all the turfs and generate them
		var/turf/gen_turf = i

		var/area/A = gen_turf.loc
		if(!(A.area_flags & CAVES_ALLOWED))
			continue

		var/closed = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/stored_flags
		if(gen_turf.flags_1 & NO_RUINS_1)
			stored_flags |= NO_RUINS_1

		var/turf/new_turf = pickweight(closed ? closed_turf_types : open_turf_types)

		for(var/turf/open/space/S in range(1, gen_turf))
			new_turf = /turf/closed/wall

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		new_turf.flags_1 |= stored_flags

		if(!closed)//Open turfs have some special behavior related to spawning flora and mobs.
			continue
		CHECK_TICK

	var/message = "[name] завершает работу за [(REALTIMEOFDAY - start_time)/10] секунд!"
	to_chat(world, "<span class='boldannounce'>[message]</span>")
	log_world(message)
