///This datum handles the transitioning from a turf to a specific biome, and handles spawning decorative structures and mobs.
/datum/biome
	///Type of turf this biome creates
	var/turf_type
	///Chance of having a structure from the flora types list spawn
	var/flora_density = 0
	///Chance of having a mob from the fauna types list spawn
	var/fauna_density = 0
	///list of type paths of objects that can be spawned when the turf spawns flora
	var/list/flora_types = list(/obj/structure/flora/grass/jungle)
	///list of type paths of mobs that can be spawned when the turf spawns fauna
	var/list/fauna_types = list()

///This proc handles the creation of a turf of a specific biome type
/datum/biome/proc/generate_turf(turf/gen_turf)
	gen_turf.ChangeTurf(turf_type, null, CHANGETURF_DEFER_CHANGE)
	if(length(fauna_types) && prob(fauna_density))
		var/mob/fauna = pick(fauna_types)
		new fauna(gen_turf)

	if(length(flora_types) && prob(flora_density))
		var/obj/structure/flora = pick(flora_types)
		new flora(gen_turf)

/datum/biome/mudlands
	turf_type = /turf/open/floor/plating/dirt/jungle/dark
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/rock/jungle, /obj/structure/flora/rock/pile/largejungle)
	flora_density = 3

/datum/biome/mudlands/normal
	turf_type = /turf/open/floor/grass/gensgrass/dirty
	flora_types = list(/obj/structure/flora/tree/cataclysmdda/el/small, /obj/structure/flora/tree/cataclysmdda/ht)
	flora_density = 3

/datum/biome/plains
	turf_type = /turf/open/floor/plating/grass/jungle
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/jungle, /obj/structure/flora/rock/jungle, /obj/structure/flora/junglebush, /obj/structure/flora/junglebush/b, /obj/structure/flora/junglebush/c, /obj/structure/flora/junglebush/large, /obj/structure/flora/rock/pile/largejungle)
	flora_density = 15

/datum/biome/plains/normal
	turf_type = /turf/open/floor/grass/rospilovo
	flora_types = list(/obj/structure/flora/tree/cataclysmdda/iva,
					/obj/structure/flora/tree/cataclysmdda/cash,
					/obj/structure/flora/tree/cataclysmdda/dub,
					/obj/structure/flora/tree/cataclysmdda/ht,
					/obj/structure/flora/tree/cataclysmdda/mt)
	flora_density = 5

/datum/biome/jungle
	turf_type = /turf/open/floor/plating/grass/jungle
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/jungle, /obj/structure/flora/rock/jungle, /obj/structure/flora/junglebush, /obj/structure/flora/junglebush/b, /obj/structure/flora/junglebush/c, /obj/structure/flora/junglebush/large, /obj/structure/flora/rock/pile/largejungle)
	flora_density = 40

/datum/biome/jungle/normal
	turf_type = /turf/open/floor/grass/rospilovo
	flora_types = list(/obj/structure/flora/tree/cataclysmdda/yabl,
					/obj/structure/flora/tree/cataclysmdda/topol,
					/obj/structure/flora/tree/cataclysmdda/el,
					/obj/structure/flora/tree/cataclysmdda/oreh,
					/obj/structure/flora/tree/cataclysmdda/kedr,
					/obj/structure/flora/tree/cataclysmdda/sosna,
					/obj/structure/flora/tree/cataclysmdda/ht,
					/obj/structure/flora/tree/cataclysmdda/mt)
	flora_density = 10

/datum/biome/jungle/deep
	flora_density = 65

/datum/biome/jungle/normal/deep
	flora_density = 20

/datum/biome/wasteland
	turf_type = /turf/open/floor/plating/dirt/jungle/wasteland

/datum/biome/wasteland/normal
	turf_type = /turf/open/floor/plating/dirt

/datum/biome/water
	turf_type = /turf/open/water/jungle

/datum/biome/water/normal
	turf_type = /turf/open/water/jungle
	flora_density = 3

/datum/biome/mountain
	turf_type = /turf/closed/mineral/random/vietnam

/datum/biome/snows
	turf_type = /turf/open/floor/grass/snow/safe
	flora_types = list(/obj/structure/flora/grass/both, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green, /obj/structure/flora/rock/icy, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/dead, /obj/structure/flora/rock/pile/icy)
	flora_density = 10

/datum/biome/icelands
	turf_type = /turf/open/floor/plating/ice/smooth/safe
	flora_types = list(/obj/structure/flora/grass/both, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green, /obj/structure/flora/rock/icy, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/dead, /obj/structure/flora/rock/pile/icy)
	flora_density = 1

/datum/biome/ice
	turf_type = /turf/open/floor/plating/ice/smooth/safe

/datum/biome/snowforest
	turf_type = /turf/open/floor/grass/snow/safe
	flora_types = list(/obj/structure/flora/grass/both, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/dead)
	flora_density = 40

/datum/biome/snowforest/deep
	flora_density = 65

/datum/biome/mountain/ice
	turf_type = /turf/closed/mineral/snowmountain/cavern/safe
