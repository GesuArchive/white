// !скины на всякое
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

		var/icon/temp_left = icon(lefthand_file, icon_state, , 1)
		temp_left = temp_left.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)
		temp_left = fcopy_rsc(temp_left)
		lefthand_file = temp_left

		var/icon/temp_right = icon(righthand_file, icon_state, , 1)
		temp_right = temp_right.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)
		temp_right = fcopy_rsc(temp_right)
		righthand_file = temp_right

		var/icon/temp_worn = icon(worn_icon, icon_state, , 1)
		temp_worn = temp_worn.Blend(icon('white/valtos/icons/custom_guns.dmi', custom_skin_name), ICON_ADD)
		temp_worn = fcopy_rsc(temp_worn)
		worn_icon = temp_worn

		name = "[name] \"[uppertext(custom_skin_name)]\""


