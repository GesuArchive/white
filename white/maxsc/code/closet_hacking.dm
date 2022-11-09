/obj/item/closet_hacker
	name = "взломщик кодов"
	desc = "Устройство для подбора паролей к электронным замкам."
	icon = 'icons/obj/device.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "multitool"
	inhand_icon_state = "multitool"
	w_class = WEIGHT_CLASS_SMALL
	var/hack_time = 1 MINUTES //how long it takes to crack one digit

/obj/item/closet_hacker/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "[icon_state]_yellow", src)
	. += emissive_appearance(icon, "[icon_state]_yellow", src, alpha = src.alpha)

/datum/crafting_recipe/closet_hacker
	name = "Взломщик кодов"
	result = /obj/item/closet_hacker
	time = 30
	tool_behaviors = list(TOOL_MULTITOOL)
	reqs = list(/obj/item/multitool = 1, /obj/item/stock_parts/subspace/filter = 1)
	category = CAT_MISC
