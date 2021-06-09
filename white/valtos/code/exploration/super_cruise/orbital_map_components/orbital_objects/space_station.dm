/datum/orbital_object/z_linked/station
	name = "Космическая Станция 13"
	mass = 0
	radius = 30
	//The station maintains its orbit around lavaland by adjustment thrusters.
	maintain_orbit = TRUE
	//Sure, why not?
	can_dock_anywhere = TRUE

/datum/orbital_object/z_linked/station/Destroy()
	. = ..()
	SSticker.force_ending = TRUE

/datum/orbital_object/z_linked/station/post_map_setup()
	//Orbit around the system center
	var/datum/orbital_object/z_linked/station/station = locate() in SSorbits.orbital_map.bodies
	if(station)
		set_orbitting_around_body(station, 150)
	else
		set_orbitting_around_body(SSorbits.orbital_map.center, 1000)
