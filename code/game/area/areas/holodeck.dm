/area/holodeck
	name = "Голодек"
	icon_state = "Holodeck"
	static_lighting = TRUE
	requires_power = FALSE
	luminosity = 1
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA
	sound_environment = SOUND_ENVIRONMENT_PADDED_CELL

	var/obj/machinery/computer/holodeck/linked
	var/restricted = FALSE // if true, program goes on emag list
	network_root_id = "HOLODECK"
/*
	Power tracking: Use the holodeck computer's power grid
	Asserts are to avoid the inevitable infinite loops
*/

/area/holodeck/powered(chan)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return A.powered(chan)

/area/holodeck/addStaticPower(value, powerchannel)
	if(!linked)
		return
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return ..()

/area/holodeck/use_power(amount, chan)
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return ..()


/*
	This is the standard holodeck.  It is intended to allow you to
	blow off steam by doing stupid things like laying down, throwing
	spheres at holes, or bludgeoning people.
*/
/area/holodeck/rec_center
	name = "Голодек: Центр"

/area/holodeck/rec_center/offstation_one
	name = "Голодек"
