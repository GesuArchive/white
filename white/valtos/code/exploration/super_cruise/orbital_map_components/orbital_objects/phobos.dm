//Centcom Z-Level.
//Syndicate infiltrator level.
/datum/orbital_object/z_linked/phobos
	name = "Озон"
	mass = 50000
	radius = 800

/datum/orbital_object/z_linked/phobos/New()
	. = ..()
	SSorbits.orbital_map.center = src
