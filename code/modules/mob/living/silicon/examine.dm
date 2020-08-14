/mob/living/silicon/examine(mob/user) //Displays a silicon's laws to ghosts
	. = ..()
	. += "<hr>"
	if(laws && isobserver(user))
		. += "<b>[src] он следует следующим законам:</b>"
		for(var/law in laws.get_law_list(include_zeroth = TRUE))
			. += law
