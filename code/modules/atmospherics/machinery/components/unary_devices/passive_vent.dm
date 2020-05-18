/obj/machinery/atmospherics/components/unary/passive_vent
	icon_state = "passive_vent_map-2"

	name = "passive vent"
	desc = "Это вентиляция без помпы."

	can_unwrench = TRUE
	hide = TRUE
	layer = GAS_SCRUBBER_LAYER

	pipe_state = "pvent"

/obj/machinery/atmospherics/components/unary/passive_vent/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = getpipeimage(icon, "vent_cap", initialize_directions, piping_layer = piping_layer)
		add_overlay(cap)
	icon_state = "passive_vent"

/obj/machinery/atmospherics/components/unary/passive_vent/process_atmos()
	..()

	var/datum/gas_mixture/air_contents = airs[1]
	var/datum/gas_mixture/environment = loc.return_air()
	var/pressure_delta = 10000

	if(air_contents.return_temperature() > 0 && environment.return_temperature() > 0)
		var/transfer_moles_1 = pressure_delta*environment.return_volume()/(air_contents.return_temperature() * R_IDEAL_GAS_EQUATION)

		var/datum/gas_mixture/removed_1 = air_contents.remove(transfer_moles_1)

		loc.assume_air(removed_1)
		air_update_turf()

		var/transfer_moles_2 = pressure_delta * air_contents.return_volume() / (environment.return_temperature() * R_IDEAL_GAS_EQUATION)
		var/datum/gas_mixture/removed_2 = loc.remove_air(transfer_moles_2)
		if (isnull(removed_2)) // in space
			return

		air_contents.merge(removed_2)
		air_update_turf()
	update_parents()

/obj/machinery/atmospherics/components/unary/passive_vent/can_crawl_through()
	return TRUE

/obj/machinery/atmospherics/components/unary/passive_vent/layer1
	piping_layer = 1
	icon_state = "passive_vent_map-1"

/obj/machinery/atmospherics/components/unary/passive_vent/layer3
	piping_layer = 3
	icon_state = "passive_vent_map-3"
