/obj/item/clothing/gloves/combat/maggloves
	name = "mag-pulse gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "black"
	inhand_icon_state = "blackgloves"
	var/active = 0
	var/list/stored_items = list()
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/gloves/combat/maggloves/ui_action_click(mob/usr, action)
	active = !active
	if(active)
		for(var/obj/item/I in usr.held_items)
			if(!(HAS_TRAIT(I,TRAIT_NODROP)))
				stored_items += I

		var/list/L = usr.get_empty_held_indexes()
		if(LAZYLEN(L) == usr.held_items.len)
			to_chat(usr, span_notice("You are not holding any items, your hands relax..."))
			active = 0
			stored_items = list()
		else
			for(var/obj/item/I in stored_items)
				to_chat(usr, span_notice("Your [usr.get_held_index_name(usr.get_held_index_of_item(I))] grip tightens."))
				ADD_TRAIT(I,TRAIT_NODROP, "mag-grip")

	else
		release_items()
		to_chat(usr, span_notice("Your hands relax..."))

/obj/item/clothing/gloves/combat/maggloves/proc/release_items()
	for(var/obj/item/I in stored_items)
		REMOVE_TRAIT(I,TRAIT_NODROP, "mag-grip")
	stored_items = list()

/obj/item/clothing/gloves/combat/maggloves/dropped(mob/user)
	if(active)
		ui_action_click()
	..()

/datum/crafting_recipe/maggloves
	name = "Mag-pulse Gloves"
	result = /obj/item/clothing/gloves/combat/maggloves
	time = 300
	reqs = list(/obj/item/clothing/gloves/combat = 1, /obj/item/stock_parts/cell/high/empty = 2,
				/obj/item/stack/rods = 5, /obj/item/stack/cable_coil = 30)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	category = CAT_CLOTHING
