/datum/mapGeneratorModule/bottomLayer/prikolwoodsTurfs
	spawnableTurfs = list(/turf/open/floor/plating/grass/planetary = 100)

/datum/mapGeneratorModule/bottomLayer/prikolwoodsWalls
	spawnableTurfs = list(/turf/closed/mineral = 100)

//Border walls
/datum/mapGeneratorModule/border/prikolwoodsWalls
	spawnableAtoms = list()
	spawnableTurfs = list(/turf/closed/mineral = 100)

//Random walls
/datum/mapGeneratorModule/splatterLayer/prikolwoodsWalls
	clusterCheckFlags = CLUSTER_CHECK_NONE
	spawnableAtoms = list()
	spawnableTurfs = list(/turf/closed/mineral = 30)


/datum/mapGeneratorModule/splatterLayer/prikolwoodsMonsters
	spawnableTurfs = list()
	spawnableAtoms = list(/mob/living/simple_animal/hostile/asteroid/basilisk = 10, \
		/mob/living/simple_animal/hostile/asteroid/hivelord = 10, \
		/mob/living/simple_animal/hostile/asteroid/goliath = 10)

//Pine Trees
/datum/mapGeneratorModule/prikolwoodsTrees
	spawnableAtoms = list(/obj/structure/flora/tree/jungle/prikol = 3, /obj/structure/flora/tree/jungle/small/prikol = 7)

//Dead Trees
/datum/mapGeneratorModule/deadTreesLess
	spawnableAtoms = list(/obj/structure/flora/tree/dead = 2)

//Random assortment of bushes
/datum/mapGeneratorModule/randBushesLess
	spawnableAtoms = list()

/datum/mapGeneratorModule/randBushesLess/New()
	..()
	spawnableAtoms = typesof(/obj/structure/flora/ausbushes)
	for(var/i in spawnableAtoms)
		spawnableAtoms[i] = 10

//Random assortment of rocks and rockpiles
/datum/mapGeneratorModule/randRocksLess
	spawnableAtoms = list(/obj/structure/flora/rock = 10, /obj/structure/flora/rock/pile = 5)




/datum/mapGenerator/prikolwoods/hollow/random/monsters
	modules = list(/datum/mapGeneratorModule/bottomLayer/prikolwoodsTurfs,
		/datum/mapGeneratorModule/border/prikolwoodsWalls,
		/datum/mapGeneratorModule/splatterLayer/prikolwoodsWalls,
		/datum/mapGeneratorModule/splatterLayer/prikolwoodsTrees,
		/datum/mapGeneratorModule/randRocksLess,
		/datum/mapGeneratorModule/randBushesLess

		)
	buildmode_name = "Pattern: Prikolwoods test"