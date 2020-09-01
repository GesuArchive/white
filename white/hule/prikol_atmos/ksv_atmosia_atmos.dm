/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos
	frequency = FREQ_ATMOS_STORAGE
	volume_rate = 200

/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/toxin_input
	name = "plasma tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_TOX
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/oxygen_input
	name = "oxygen tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_O2
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/nitrogen_input
	name = "nitrogen tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_N2
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/mix_input
	name = "mix tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_MIX
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/nitrous_input
	name = "nitrous oxide tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_N2O
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/air_input
	name = "air mix tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_AIR
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/carbon_input
	name = "carbon dioxide tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_CO2

/*
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/incinerator_input
	name = "incinerator chamber input injector"
	id = ATMOS_GAS_MONITOR_INPUT_INCINERATOR
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/toxins_mixing_input
	name = "toxins mixing input injector"
	id = ATMOS_GAS_MONITOR_INPUT_TOXINS_LAB
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/atmos_waste
	name = "atmos waste outlet injector"
	id =  ATMOS_GAS_MONITOR_WASTE_ATMOS
/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4/atmos/engine_waste
	name = "engine outlet injector"
	id = ATMOS_GAS_MONITOR_WASTE_ENGINE
*/

/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos
	piping_layer = 3
	icon_state = "filter_on_map-3"

/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos/n2
	name = "nitrogen filter"
	filter_type = "n2"
/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos/o2
	name = "oxygen filter"
	filter_type = "o2"
/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos/co2
	name = "carbon dioxide filter"
	filter_type = "co2"
/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos/n2o
	name = "nitrous oxide filter"
	filter_type = "n2o"
/obj/machinery/atmospherics/components/trinary/filter/on/layer4/atmos/plasma
	name = "plasma filter"
	filter_type = "plasma"
