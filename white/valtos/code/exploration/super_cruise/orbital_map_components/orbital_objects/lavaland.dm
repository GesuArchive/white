/datum/orbital_object/z_linked/lavaland
	name = "Лаваленд"
	mass = 10000
	radius = 50
	forced_docking = FALSE
	random_docking = TRUE
	render_mode = RENDER_MODE_PLANET
	priority = 90
	signal_range = 10000
	//Important that this doesn't fly away
	maintain_orbit = TRUE
	//If you manage to go fast enough, you can crash
	min_collision_velocity = 100

/datum/orbital_object/z_linked/lavaland/post_map_setup()
	//Orbit around ozon
	var/datum/orbital_map/linked_map = SSorbits.orbital_maps[orbital_map_index]
	set_orbitting_around_body(linked_map.center, 1800)
