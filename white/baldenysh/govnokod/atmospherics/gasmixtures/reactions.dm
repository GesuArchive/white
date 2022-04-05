/*
/datum/gas_reaction/metalhydrogen
	priority = 20
	name = "Metal Hydrogen formation"
	id = "metalhydrogen"

/datum/gas_reaction/metalhydrogen/init_reqs()
	min_requirements = list(
		/datum/gas/hydrogen = 100,
		GAS_BZ = 5,
		"TEMP" = METAL_HYDROGEN_MINIMUM_HEAT
		)

/datum/gas_reaction/metalhydrogen/react(datum/gas_mixture/air, datum/holder)
	var/list/cached_gases = air.gases
	var/temperature = air.temperature
	var/old_heat_capacity = air.heat_capacity()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	///the more heat you use the higher is this factor
	var/increase_factor = min((temperature / METAL_HYDROGEN_MINIMUM_HEAT), 5)
	///the more moles you use and the higher the heat, the higher is the efficiency
	var/heat_efficency = cached_gases[/datum/gas/hydrogen][MOLES] * 0.01 * increase_factor
	var/pressure = air.return_pressure()
	var/energy_used = heat_efficency * METAL_HYDROGEN_FORMATION_ENERGY

	if(pressure >= METAL_HYDROGEN_MINIMUM_PRESSURE && temperature >= METAL_HYDROGEN_MINIMUM_HEAT)
		cached_gases[GAS_BZ][MOLES] -= heat_efficency * 0.01
		if (prob(20 * increase_factor))
			cached_gases[/datum/gas/hydrogen][MOLES] -= heat_efficency * 3.5
			if (prob(100 / increase_factor))
				new /obj/item/stack/sheet/mineral/metal_hydrogen(location)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.temperature = max(((temperature * old_heat_capacity - energy_used) / new_heat_capacity), TCMB)
		return REACTING
*/
