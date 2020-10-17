/mob/dead/observer/update_icon(new_form)
	if(ckey == "jhnazar")
		icon = 'white/jhnazar/misc/prikols/ghost_icon.dmi'
		icon_state = "ghost_bee"
		desc = "Это jhnazar"
		if(prob(50))
			to_chat("Вы чувствуете себя видимым всему живому")
			set_invisibility(0)
		return

	if(ckey == "rebolution228")
		icon = 'white/jhnazar/icons/hohol.dmi'
		icon_state = "hohol"
		name = "Пидорас из Хохляндии"
		desc = "Это Ребалюшин, который несправедливо забанил невинную педаль Джахназера. Земля пухом"
		return
