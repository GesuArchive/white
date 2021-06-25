/datum/orbital_object/z_linked/lavaland
	name = "Лаваленд"
	mass = 10000
	radius = 150
	forced_docking = TRUE
	random_docking = TRUE
	orbital_map_color = "#d04319"

/datum/orbital_object/z_linked/lavaland/post_map_setup()
	//Orbit around the systems sun
	set_orbitting_around_body(SSorbits.orbital_map.center, 2800)
