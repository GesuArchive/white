/mob/dead/observer/update_icon(new_form)
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Это jhnazar"
		if(prob(50))
			to_chat("Вы чувствуете себя видимым всему живому")
			set_invisibility(0)
		return

