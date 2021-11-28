// !скины на всякое
GLOBAL_LIST_INIT(custom_skin_donators, list("valtosss" = list("bullshit", "asiimov")))

/obj/item/gun/worn_overlays(isinhands, icon_file)
	. = list()
	if(custom_skin_name)
		. += mutable_appearance('white/valtos/icons/custom_guns.dmi', custom_skin_name)

/obj/item/gun/proc/change_skin(datum/source, mob/user)
	if(ishuman(user) && (user?.ckey in GLOB.custom_skin_donators))
		var/list/possible_skins = GLOB.custom_skin_donators[user.ckey]
		var/list/choices = list()
		for(var/skin in possible_skins)
			choices[skin] = image(icon = 'white/valtos/icons/custom_guns.dmi', icon_state = skin)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			return
		custom_skin_name = choice
