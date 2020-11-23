/mob/dead/observer/update_icon(new_form)
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Это jhnazar"
		if(prob(50))
			to_chat(usr, "Вы чувствуете себя видимым всему живому")
			set_invisibility(0)
			return
		return

	if(ckey == "biomechanicmann")
		icon = 'white/jhnazar/misc/prikols/bee.dmi'
		icon_state = "syndiebee-wings"

		if(prob(50))
			icon_state = "syndiebee-wings"
		else
			if(prob(50))
				icon_state = "tophatbee-wings"
			else
				icon_state = "lichbee-wings"
		return
	return
