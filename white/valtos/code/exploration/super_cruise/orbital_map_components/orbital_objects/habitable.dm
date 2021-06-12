/datum/orbital_object/z_linked/habitable
	name = "Дружественная станция"
	mass = 0
	radius = 30
	maintain_orbit = TRUE
	can_dock_anywhere = TRUE

/datum/orbital_object/z_linked/habitable/New()
	. = ..()
	name = "[initial(name)] #[rand(1, 9)][SSorbits.orbital_map.bodies.len][rand(1, 9)]"

/datum/orbital_object/z_linked/habitable/post_map_setup()

	var/datum/space_level/assigned_space_level = SSmapping.add_new_zlevel("Dynamic habitable level", ZTRAITS_SPACE, orbital_body_type = null)
	linked_z_level = assigned_space_level
	assigned_space_level.orbital_body = src
	generate_space_ruin(world.maxx / 2, world.maxy / 2, assigned_space_level.z_value, 150, 150, allowed_flags = (RUIN_PART_DEFAULT | RUIN_PART_HABITABLE))

	set_orbitting_around_body(SSorbits.orbital_map.center, 6800 + 250 * rand(4, 20))
