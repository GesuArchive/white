/datum/map_generator/station_maints_generator
	var/name = "Генератор техтоннелей"
	var/list/turf_types = list(/turf/open/floor/plating = 90, /turf/open/floor/plasteel = 1, /turf/open/floor/plasteel/dark = 1, /turf/closed/wall = 1)
	var/list/garbage_types = list(
		/obj/effect/spawner/lootdrop/grille_or_trash = 50,
		/obj/structure/grille = 80,
		/obj/structure/girder = 25,
		/obj/structure/grille/broken = 10,
		/obj/item/shard = 10,
		/obj/effect/spawner/lootdrop/maint_drugs = 1,
		/obj/effect/spawner/lootdrop/refreshing_beverage = 1,
		/obj/effect/spawner/lootdrop/botanical_waste = 1,
		/obj/effect/spawner/lootdrop/cigbutt = 1,
		/obj/effect/spawner/lootdrop/garbage_spawner = 1,
		/obj/effect/spawner/lootdrop/gambling = 1,
		/obj/effect/spawner/lootdrop/prison_contraband = 1,
		/obj/effect/spawner/lootdrop/maintenance = 1,
		/obj/effect/spawner/lootdrop/maintenance/two = 1,
		/obj/effect/spawner/lootdrop/maintenance/three = 1,
		/obj/effect/spawner/lootdrop/maintenance/four = 1,
		/obj/effect/spawner/lootdrop/maintenance/five = 1,
		/obj/effect/spawner/lootdrop/maintenance/six = 1,
		/obj/effect/spawner/lootdrop/maintenance/seven = 1,
		/obj/effect/spawner/lootdrop/maintenance/eight = 1,
		/obj/effect/spawner/lootdrop/two_percent_xeno_egg_spawner = 1,
		/obj/effect/spawner/lootdrop/costume = 1,
		/obj/effect/spawner/trap = 1,
		/obj/effect/gibspawner/generic = 1,
		/obj/effect/spawner/structure/window/hollow = 5,
		/obj/effect/spawner/lootdrop/gross_decal_spawner = 5,
		/mob/living/simple_animal/hostile/poison/giant_spider = 1,
		/mob/living/simple_animal/hostile/cockroach = 1,
		/mob/living/simple_animal/hostile/mimic = 1,
		/mob/living/simple_animal/hostile/regalrat = 1,
		/obj/effect/decal/cleanable/cum = 1,
		/obj/effect/decal/cleanable/poo = 1
	)

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
	name = "Центральные техтоннели"
	icon_state = "amaint"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/station_maints_generator

/area/maintenance/bottom_station_maints/north
	name = "Северные техтоннели"

/area/maintenance/bottom_station_maints/east
	name = "Восточные техтоннели"

/area/maintenance/bottom_station_maints/west
	name = "Западные техтоннели"

/area/maintenance/bottom_station_maints/south
	name = "Южные техтоннели"

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

		var/turf/new_turf = pickweight(turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		if(garbage_turf)
			var/atom/picked_garbage = pickweight(garbage_types)
			new picked_garbage(new_turf)

		CHECK_TICK

	var/message = "[name] завершает работу за [(REALTIMEOFDAY - start_time)/10] секунд!"
	to_chat(world, "<span class='boldannounce'>[message]</span>")
	log_world(message)
