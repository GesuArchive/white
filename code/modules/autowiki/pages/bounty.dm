/datum/autowiki/bounty
	page = "Template:Autowiki/Content/Bounty"

/datum/autowiki/bounty/generate()
	var/output = ""

	for (var/bounty_type in sort_list(subtypesof(/datum/bounty), GLOBAL_PROC_REF(cmp_typepaths_asc)))
		var/datum/bounty/bounty = new bounty_type(src)

		if(!bounty?.name)
			continue

		output += "\n\n" + include_template("Autowiki/BountyEntry", list(
			"name" = escape_value(capitalize(bounty.name)),
			"description" = escape_value(bounty.description),
			"wanted" = generate_wanted(bounty),
		))

	return output

/datum/autowiki/bounty/proc/generate_wanted(datum/bounty/bounty)
	var/output = ""

	if(istype(bounty, /datum/bounty/item/botany))
		var/datum/bounty/item/botany/botany_item = bounty

		output += include_template("Autowiki/BountyEntryBotany", list(
			"required_count" = escape_value(botany_item.required_count),
			"wanted_types" = format_item_list(botany_item.wanted_types),
			"exclude_types" = format_item_list(botany_item.exclude_types),
			"special_include_types" = format_item_list(botany_item.special_include_types),
			"bonus_desc" = escape_value(botany_item.bonus_desc),
			"foodtype" = escape_value(botany_item.foodtype),
		))
/* TODO: починить
	else if(istype(bounty, /datum/bounty/item/engineering/gas))
		var/datum/bounty/item/engineering/gas/gas_item = bounty

		output += include_template("Autowiki/BountyEntryGas", list(
			"required_count" = escape_value(gas_item.required_count),
			"wanted_types" = format_item_list(gas_item.wanted_types),
			"exclude_types" = format_item_list(gas_item.exclude_types),
			"special_include_types" = format_item_list(gas_item.special_include_types),
			"gas_type" = escape_value(gases[gas_id][MOLES] * gas_id.base_value),
		))
*/
	else if(istype(bounty, /datum/bounty/item))
		var/datum/bounty/item/bounty_item = bounty

		output += include_template("Autowiki/BountyEntryItem", list(
			"required_count" = escape_value(bounty_item.required_count),
			"wanted_types" = format_item_list(bounty_item.wanted_types),
			"exclude_types" = format_item_list(bounty_item.exclude_types),
			"special_include_types" = format_item_list(bounty_item.special_include_types),
		))

	return output

/datum/autowiki/bounty/proc/format_item_list(list/item_list)
	var/output = ""

	for (var/obj/item_path as anything in item_list)
		output += include_template("Autowiki/BountyEntryItemName", list(
			"name" = escape_value(capitalize(format_text(initial(item_path.name)))),
		))

	return output
