/datum/bounty/item
	///How many items have to be shipped to complete the bounty
	var/required_count = 1
	///How many items have been shipped for the bounty so far
	var/shipped_count = 0
	///Types accepted by the bounty (including all subtypes, unless include_subtypes is set to FALSE)
	var/list/wanted_types
	///Set to FALSE to make the bounty not accept subtypes of the wanted_types
	var/include_subtypes = TRUE
	///Types that should not be accepted by the bounty, also excluding all their subtypes
	var/list/exclude_types
	///Individual types that should be accepted even if their supertypes are excluded (yes, apparently this is necessary)
	var/list/special_include_types

/datum/bounty/item/New()
	..()
	wanted_types = typecacheof(wanted_types, only_root_path = !include_subtypes)
	if (exclude_types)
		exclude_types = string_assoc_list(typecacheof(exclude_types))
		for (var/e_type in exclude_types)
			wanted_types[e_type] = FALSE
	if (special_include_types)
		for (var/i_type in special_include_types)
			wanted_types[i_type] = TRUE
	wanted_types = string_assoc_list(wanted_types)

/datum/bounty/item/can_claim()
	return ..() && shipped_count >= required_count

/datum/bounty/item/applies_to(obj/O)
	if(!is_type_in_typecache(O, wanted_types))
		return FALSE
	if(O.flags_1 & HOLOGRAM_1)
		return FALSE
	return shipped_count < required_count

/datum/bounty/item/ship(obj/O)
	if(!applies_to(O))
		return
	if(istype(O,/obj/item/stack))
		var/obj/item/stack/O_is_a_stack = O
		shipped_count += O_is_a_stack.amount
	else
		shipped_count += 1

/datum/bounty/item/completion_string()
	return {"[shipped_count]/[required_count]"}

/datum/bounty/item/compatible_with(datum/other_bounty)
	return type != other_bounty.type

/datum/bounty/item/mech/mark_high_priority(scale_reward)
	return ..(max(scale_reward * 0.7, 1.2))

/datum/bounty/reagent/completion_string()
	return {"[round(shipped_volume)]/[required_volume] юнитов"}

/datum/bounty/reagent/compatible_with(other_bounty)
	if(!istype(other_bounty, /datum/bounty/reagent))
		return TRUE
	var/datum/bounty/reagent/R = other_bounty
	return wanted_reagent.type != R.wanted_reagent.type

/datum/bounty/pill/completion_string()
	return {"[shipped_ammount]/[required_ammount] pills"}

/datum/bounty/pill/compatible_with(other_bounty)
	if(!istype(other_bounty, /datum/bounty/pill/simple_pill))
		return TRUE
	var/datum/bounty/pill/simple_pill/P = other_bounty
	return (wanted_reagent.type == P.wanted_reagent.type) && (wanted_vol == P.wanted_vol)

/datum/bounty/virus/completion_string()
	return shipped ? "Отправлено" : "Не отправлено"

/datum/bounty/virus/compatible_with(datum/other_bounty)
	if(!istype(other_bounty, /datum/bounty/virus))
		return TRUE
	var/datum/bounty/virus/V = other_bounty
	return type != V.type || stat_value != V.stat_value
