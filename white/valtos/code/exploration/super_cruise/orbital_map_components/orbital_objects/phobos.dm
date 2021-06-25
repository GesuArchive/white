//Centcom Z-Level.
//Syndicate infiltrator level.
/datum/orbital_object/z_linked/phobos
	name = "Озон"
	mass = 50000
	radius = 300
	static_object = TRUE
	orbital_map_color = "#05a705"

/datum/orbital_object/z_linked/phobos/New()
	. = ..()
	SSorbits.orbital_map.center = src
