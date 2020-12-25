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

/datum/map_generator/station_maints
	modules = list(/datum/map_generator_module/bottom_layer/maint_turfs, \
		/datum/map_generator_module/splatter_layer/maint_walls, \
		/datum/map_generator_module/splatter_layer/main_spawn, \
		/datum/map_generator_module/border/maint_walls, \
		/datum/map_generator_module/bottom_layer/repressurize)
	buildmode_name = "Pattern: Station Maintenance Level"

/area/maintenance/bottom_station_maints
	name = "Технические тоннели"
	icon_state = "amaint"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/station_maints
