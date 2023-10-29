/datum/crafting_recipe
	var/name //in-game display name
	var/list/reqs = list() //type paths of items consumed associated with how many are needed
	var/list/blacklist = list() //type paths of items explicitly not allowed as an ingredient
	var/result //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed. Lazy list.
	var/list/tool_paths
	var/time = 30 //time in deciseconds
	var/list/parts = list() //type paths of items that will be placed in the result
	var/list/chem_catalysts = list() //like tool_behaviors but for reagents
	var/category
	var/always_available = TRUE //Set to FALSE if it needs to be learned first.
	/// Additonal requirements text shown in UI
	var/additional_req_text
	///Required machines for the craft, set the assigned value of the typepath to CRAFTING_MACHINERY_CONSUME or CRAFTING_MACHINERY_USE. Lazy associative list: type_path key -> flag value.
	var/list/machinery
	///Required structures for the craft, set the assigned value of the typepath to CRAFTING_STRUCTURE_CONSUME or CRAFTING_STRUCTURE_USE. Lazy associative list: type_path key -> flag value.
	var/list/structures
	///Should only one object exist on the same turf?
	var/one_per_turf = FALSE
	/// Steps needed to achieve the result
	var/list/steps
	/// Whether the result can be crafted with a crafting menu button
	var/non_craftable
	/// Chemical reaction described in the recipe
	var/datum/chemical_reaction/reaction
	/// Resulting amount (for stacks only)
	var/result_amount

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	if(tool_behaviors)
		tool_behaviors = string_list(tool_behaviors)
	if(tool_paths)
		tool_paths = string_list(tool_paths)

/datum/crafting_recipe/stack/New(obj/item/stack/material, datum/stack_recipe/stack_recipe)
	if(!material || !stack_recipe || !stack_recipe.result_type)
		stack_trace("Invalid stack recipe [stack_recipe]")
		return
	..()

	src.name = stack_recipe.title
	src.time = stack_recipe.time
	src.result = stack_recipe.result_type
	src.result_amount = stack_recipe.res_amount
	src.reqs[material] = stack_recipe.req_amount
	src.category = stack_recipe.category || CAT_MISC

/**
 * Run custom pre-craft checks for this recipe
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	if(istype(result, /obj/structure/mineral_door))
		result.dir = user.dir
		result.update_icon()
	return

/**************************************************************
Все рецепты были раскиданы по своим категориям, пользуйтесь ими.
А так же убедитесь что у добавляемых рецептов будет точно icon и icon_state(у составных спрайтов как правило их нет)
В противном случае добавляйте отдельно icon_preview icon_state_preview, иначе иконки в крафт меню сьедут
**************************************************************/
