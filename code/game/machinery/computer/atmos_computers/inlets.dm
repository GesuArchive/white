/obj/machinery/atmospherics/components/unary/outlet_injector/monitored
	on = TRUE
	volume_rate = MAX_TRANSFER_RATE
	/// The air sensor type this injector is linked to
	var/chamber_id

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/Initialize(mapload)
	id_tag = CHAMBER_INPUT_FROM_ID(chamber_id)
	return ..()

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/plasma_input
	name = "plasma tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PLAS

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/oxygen_input
	name = "oxygen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_O2

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/nitrogen_input
	name = "nitrogen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_N2

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/mix_input
	name = "mix tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_MIX

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/nitrous_input
	name = "nitrous oxide tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_N2O

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/air_input
	name = "air mix tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_AIR

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/carbon_input
	name = "carbon dioxide tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_CO2

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/bz_input
	name = "bz tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_BZ

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/freon_input
	name = "freon tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_FREON

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/halon_input
	name = "halon tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HALON

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/healium_input
	name = "healium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HEALIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/hydrogen_input
	name = "hydrogen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_H2

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/hypernoblium_input
	name = "hypernoblium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HYPERNOBLIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/miasma_input
	name = "miasma tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_MIASMA

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/nitrium_input
	name = "nitrium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_NITRIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/pluoxium_input
	name = "pluoxium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PLUOXIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/proto_nitrate_input
	name = "proto-nitrate tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PROTO_NITRATE

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/tritium_input
	name = "tritium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_TRITIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/water_vapor_input
	name = "water vapor tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_H2O

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/zauker_input
	name = "zauker tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_ZAUKER

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/helium_input
	name = "helium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HELIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/antinoblium_input
	name = "antinoblium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_ANTINOBLIUM

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/incinerator_input
	name = "incinerator chamber input injector"
	chamber_id = ATMOS_GAS_MONITOR_INCINERATOR

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/ordnance_burn_chamber_input
	on = FALSE
	name = "ordnance burn chamber input injector"
	chamber_id = ATMOS_GAS_MONITOR_ORDNANCE_BURN

/obj/machinery/atmospherics/components/unary/vent_pump/siphon/monitored/ordnance_freezer_chamber_input
	on = FALSE
	name = "ordnance freezer chamber input injector"
	chamber_id = ATMOS_GAS_MONITOR_ORDNANCE_FREEZER
