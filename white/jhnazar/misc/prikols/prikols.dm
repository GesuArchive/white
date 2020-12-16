/*
 * Этот прок вызывается в проке призрака update_icon()
 * Если возвращает TRUE, то update_icon() у призрака не выполняется.
 */

/mob/dead/observer/proc/update_custom_icon()
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Это jhnazar"
		if(prob(50))
			to_chat(usr, "Вы чувствуете себя видимым всему живому")
			set_invisibility(0)
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
