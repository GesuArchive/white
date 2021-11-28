// !скины на всякое
GLOBAL_LIST_INIT(custom_skin_donators, list("valtosss" = list("bullshit", "asiimov")))

/obj/item/gun/proc/change_skin(datum/source, mob/user)
	if(ishuman(user) && (user?.ckey in GLOB.custom_skin_donators) && !custom_skin_name)
		var/list/possible_skins = GLOB.custom_skin_donators[user.ckey]
		var/list/choices = list()
		for(var/skin in possible_skins)
			choices[skin] = image(icon = 'white/valtos/icons/custom_guns.dmi', icon_state = skin)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			return
		custom_skin_name = choice

		var/icon/temp_icon = icon(icon, icon_state, , 1)
		temp_icon.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)
		overlays |= mutable_appearance(temp_icon, icon_state)

		temp_icon = icon(lefthand_file, icon_state, , 1)
		lefthand_file = temp_icon.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)

		temp_icon = icon(righthand_file, icon_state, , 1)
		righthand_file = temp_icon.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)

		temp_icon = icon(worn_icon, icon_state, , 1)
		worn_icon = temp_icon.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)

		name = "[name] \"[uppertext(custom_skin_name)]\""


