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
	var/list/open_turf_types = list(/turf/open/floor/plating = 1)
	var/list/garbage_types = list(/obj/effect/spawner/lootdrop/grille_or_trash = 10,
								  /obj/structure/grille = 30,
								  /obj/structure/girder = 5,
								  /obj/structure/grille/broken = 10,
								  /obj/effect/spawner/lootdrop/maint_drugs = 4,
								  /obj/effect/spawner/lootdrop/refreshing_beverage = 3,
								  /obj/effect/spawner/lootdrop/botanical_waste = 1,
								  /obj/effect/spawner/lootdrop/food_packaging = 1,
								  /obj/effect/spawner/lootdrop/cigbutt = 1,
								  /obj/effect/spawner/lootdrop/garbage_spawner = 5,
								  /obj/effect/spawner/lootdrop/gambling = 1,
								  /obj/effect/spawner/lootdrop/prison_contraband = 1,
								  /obj/effect/spawner/lootdrop/donkpockets = 1,
								  /obj/effect/spawner/lootdrop/three_course_meal = 1,
								  /obj/effect/spawner/lootdrop/maintenance = 1,
								  /obj/effect/spawner/lootdrop/maintenance/two = 1,
								  /obj/effect/spawner/lootdrop/maintenance/three = 1,
								  /obj/effect/spawner/lootdrop/maintenance/four = 1,
								  /obj/effect/spawner/lootdrop/maintenance/five = 1,
								  /obj/effect/spawner/lootdrop/maintenance/six = 1,
								  /obj/effect/spawner/lootdrop/maintenance/seven = 1,
								  /obj/effect/spawner/lootdrop/maintenance/eight = 1,
								  /obj/effect/spawner/lootdrop/organ_spawner = 1,
								  /obj/effect/spawner/lootdrop/memeorgans = 1,
								  /obj/effect/spawner/lootdrop/two_percent_xeno_egg_spawner = 1,
								  /obj/effect/spawner/lootdrop/costume = 1,
								  /obj/effect/spawner/lootdrop/minor/beret_or_rabbitears = 1,
								  /obj/effect/spawner/lootdrop/minor/bowler_or_that = 1,
								  /obj/effect/spawner/lootdrop/minor/kittyears_or_rabbitears = 1,
								  /obj/effect/spawner/trap = 1,
								  /obj/effect/gibspawner/generic = 1,
								  /obj/effect/spawner/structure/window/hollow = 1,
								  /obj/effect/spawner/randomarcade = 1,
								  /mob/living/simple_animal/hostile/poison/giant_spider = 1,
								  /mob/living/simple_animal/hostile/cockroach = 1,
								  /mob/living/simple_animal/hostile/mimic = 1,
								  /mob/living/simple_animal/hostile/regalrat = 1)

	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_garbage_chance = 45

	///Amount of smoothing iterations
	var/smoothing_iterations = 20

	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4

	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/area/maintenance/bottom_station_maints
	name = "Технические тоннели"
	icon_state = "amaint"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/station_maints_generator

/datum/map_generator/station_maints_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_garbage_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	// double iterations

	for(var/i in turfs)

		if(!istype(i, /turf/open/genturf))
			continue

		var/turf/gen_turf = i

		var/garbage_turf = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/turf/new_turf = pickweight(open_turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		if(garbage_turf)
			var/atom/picked_garbage = pickweight(garbage_types)
			new picked_garbage(new_turf)

		CHECK_TICK

	var/message = "[name] завершает работу за [(REALTIMEOFDAY - start_time)/10] секунд!"
	to_chat(world, "<span class='boldannounce'>[message]</span>")
	log_world(message)
