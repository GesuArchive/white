#define GAS_RECIPE_REACTIONS_EXCLUDED_RECIPE_TYPES list(/datum/gas_recipe/crystallizer)

/proc/get_gas_recipe_reactions()
	. = list()
	var/list/recipes_list = gas_recipes_list()
	for(var/recipe_id in recipes_list)
		var/datum/gas_recipe/recipe = recipes_list[recipe_id]
		if(recipe.type in GAS_RECIPE_REACTIONS_EXCLUDED_RECIPE_TYPES || !recipe.requirements)
			continue
		var/datum/gas_reaction/recipe/reaction = new
		reaction.name += " ([recipe.name])"
		reaction.id += "_[recipe.id]"
		reaction.energy_release = recipe.energy_release
		reaction.products = recipe.products
		reaction.dangerous = recipe.dangerous
		reaction.reaction_type = recipe.reaction_type

		reaction.min_requirements = recipe.requirements
		reaction.min_requirements["TEMP"] = recipe.min_temp
		reaction.min_requirements["MAX_TEMP"] = recipe.max_temp

		var/datum/gas/reaction_key
		for (var/req in reaction.min_requirements)
			if (ispath(req))
				var/datum/gas/req_gas = req
				if (!reaction_key || initial(reaction_key.rarity) > initial(req_gas.rarity))
					reaction_key = req_gas
		reaction.major_gas = reaction_key

		. += reaction

/datum/gas_reaction/recipe
	priority = 20
	name = "Gas recipe reaction"
	id = "gas_recipe_reaction"
	exclude = TRUE
	var/energy_release = 0
	var/reaction_type = ""
	var/dangerous = FALSE
	var/list/products

/datum/gas_reaction/recipe/react(datum/gas_mixture/air, datum/holder, reaction_id)
	if(!isturf(holder))
		return NO_REACTION

	//ебнутая хуйня потомушто цпп атмос
	var/true_reaction_id = copytext(reaction_id, 2, 0)
	if(!src)
		for(var/datum/gas_reaction/recipe/recipe_reaction in SSair.gas_reactions)
			if(recipe_reaction.id == true_reaction_id)
				src = recipe_reaction
	if(!src)
		return NO_REACTION

	if(!air.heat_capacity())
		return NO_REACTION

	var/turf/open/location = holder

	for(var/gas_type in min_requirements)
		var/amount_consumed = min_requirements[gas_type]
		air.remove_specific(gas_type, amount_consumed)

	var/temperature_change = energy_release / air.heat_capacity()
	if(reaction_type == ENDOTHERMIC_REACTION)
		temperature_change = -temperature_change
	air.set_temperature(max(air.return_temperature() + temperature_change, TCMB))

	for(var/result_path in products)
		var/amount_produced = products[result_path]
		for(var/i in 1 to amount_produced)
			var/obj/creation = new result_path(location)
			if(dangerous)
				creation.investigate_log("has been created as result of a gas recipe reaction.", INVESTIGATE_SUPERMATTER)
				message_admins("[creation] has been created as result of a gas recipe reaction [ADMIN_JMP(creation)].")

	return REACTING


/obj/machinery/portable_atmospherics/canister/tier_3/felinid_fusion
	name = "Cumjar canister"
	max_integrity = 1

/obj/machinery/portable_atmospherics/canister/tier_3/felinid_fusion/create_gas()
	air_contents.set_moles(/datum/gas/miasma, 500)
	air_contents.set_moles(/datum/gas/bz, 5000)
	air_contents.set_moles(/datum/gas/carbon_dioxide, 50000)

/obj/machinery/portable_atmospherics/canister/tier_1/pellet_test
	name = "abobus"
	max_integrity = 1

/obj/machinery/portable_atmospherics/canister/tier_1/pellet_test/create_gas()
	air_contents.set_moles(/datum/gas/plasma, 1000)
	air_contents.set_moles(/datum/gas/oxygen, 1000)
