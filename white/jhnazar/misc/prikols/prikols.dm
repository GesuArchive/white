/*
 * Этот прок вызывается в проке призрака update_icon()
 * Если возвращает TRUE, то update_icon() у призрака не выполняется.
 */

/mob/dead/observer/proc/update_custom_icon()
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Самая лучшая пчола на диком Вайте"
		return TRUE

	if(ckey == "kachyuorkin")
		icon = 'white/kacherkin/icons/gooost.dmi'
		icon_state = "ghost"
		name = "Слизнекот"
		deadchat_name = "Слизнекот"
		desc = "Кота слизь. Ты думал что-то здесь будет?"
		return TRUE
	
	if(ckey == "xrenoid")
		icon = 'white/kacherkin/icons/xrenoid.dmi'
		icon_state = "project_xrenoid"
		name = "PROJECT XRENOID"
		deadchat_name = "PROJECT XRENOID"
		desc = " "
		return TRUE

	if(ckey == "biomechanicmann")
		icon = 'white/jhnazar/misc/prikols/bee.dmi'
		icon_state = "syndiebee_wings"

		if(prob(50))
			icon_state = "syndiebee_wings"
		else
			if(prob(50))
				icon_state = "tophatbee_wings"
			else
				icon_state = "lichbee_wings"
		return TRUE

	return FALSE
