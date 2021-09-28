/datum/orbital_object/z_linked/lavaland
	name = "Лаваленд"
	mass = 10000
	radius = 150
	forced_docking = TRUE
	random_docking = TRUE

/datum/orbital_object/z_linked/lavaland/post_map_setup()
	//Orbit around the systems sun
	var/datum/orbital_map/linked_map = SSorbits.orbital_maps[orbital_map_index]
	set_orbitting_around_body(linked_map.center, 2800)
