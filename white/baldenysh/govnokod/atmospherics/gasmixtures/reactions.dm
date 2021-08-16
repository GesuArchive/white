/*
/datum/gas_reaction/metalhydrogen
	priority = 20
	name = "Metal Hydrogen formation"
	id = "metalhydrogen"

/datum/gas_reaction/metalhydrogen/init_reqs()
	min_requirements = list(
		/datum/gas/hydrogen = 100,
		/datum/gas/bz = 5,
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
		cached_gases[/datum/gas/bz][MOLES] -= heat_efficency * 0.01
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
/datum/gas_reaction/gas_recipe
	priority = 20
	name = "Gas recipe reaction"
	id = "gas_recipe_reaction"

/datum/gas_reaction/gas_recipe/init_reqs()
	min_requirements = list(/datum/gas/pluoxium = 5)

/datum/gas_reaction/gas_recipe/react(datum/gas_mixture/air, datum/holder)
	if(!isturf(holder))
		return NO_REACTION

	for(var/datum/gas_recipe/recipe in GLOB.gas_recipe_meta)
		if(check_requirements(recipe, air))
			do_reaction(recipe, air, holder)
			. = REACTING

/datum/gas_reaction/gas_recipe/proc/check_requirements(datum/gas_recipe/recipe, datum/gas_mixture/air)
	for(var/gas_type in recipe.requirements)
		if(!air.get_moles(gas_type) || air.get_moles(gas_type) < recipe.requirements[gas_type])
			return FALSE
	if(air.return_temperature() >= recipe.min_temp && air.return_temperature() <= recipe.max_temp)
		return TRUE
	return FALSE

/datum/gas_reaction/gas_recipe/proc/do_reaction(datum/gas_recipe/recipe, datum/gas_mixture/air, datum/holder)
	var/turf/open/location = holder

	for(var/gas_type in recipe.requirements)
		var/amount_consumed = recipe.requirements[gas_type]
		air.remove_specific(gas_type, amount_consumed)

	var/temperature_change = recipe.energy_release / air.heat_capacity()
	if(recipe.reaction_type == ENDOTHERMIC_REACTION)
		temperature_change = -temperature_change
	air.set_temperature(max(air.return_temperature() + temperature_change, TCMB))

	for(var/path in recipe.products)
		var/amount_produced = recipe.products[path]
		for(var/i in 1 to amount_produced)
			var/obj/creation = new path(location)
			if(recipe.dangerous)
				creation.investigate_log("has been created as result of a gas recipe reaction.", INVESTIGATE_SUPERMATTER)
				message_admins("[creation] has been created as result of a gas recipe reaction [ADMIN_JMP(creation)].")
