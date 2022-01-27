/obj/item/closet_hacker
	name = "взломщик кодов"
	desc = "Устройство для подбора паролей к электронным замкам."
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "multitool_yellow"
	inhand_icon_state = "multitool"
	var/hack_time = 1 MINUTES //how long it takes to crack one digit

/datum/crafting_recipe/closet_hacker
	name = "Взломщик кодов"
	result = /obj/item/closet_hacker
	time = 30
	tool_behaviors = list(TOOL_SCREWDRIVER)
	reqs = list(/obj/item/multitool = 1, /obj/item/stock_parts/subspace/filter = 1)
	category = CAT_MISC
