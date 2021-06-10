/datum/orbital_object/z_linked/habitable
	name = "Сильный сигнал"
	mass = 0
	radius = 25
	maintain_orbit = TRUE
	can_dock_anywhere = TRUE

/datum/orbital_object/z_linked/habitable/New()
	. = ..()
	name = "[initial(name)] #[rand(1, 9)][SSorbits.orbital_map.bodies.len][rand(1, 9)]"

/datum/orbital_object/z_linked/habitable/post_map_setup()

	var/datum/space_level/assigned_space_level = SSzclear.get_free_z_level()
	linked_z_level = assigned_space_level
	assigned_space_level.orbital_body = src
	generate_space_ruin(world.maxx / 2, world.maxy / 2, assigned_space_level.z_value, 200, 200)

	set_orbitting_around_body(SSorbits.orbital_map.center, 6800 + 250 * rand(4, 20))
