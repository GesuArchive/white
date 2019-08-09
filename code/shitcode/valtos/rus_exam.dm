/atom/proc/ru_get_examine_name(mob/user)
	switch (rand(0, 100))
		if (1)
			. = "непримечательный [src]"
		if (2)
			. = "обычный [src]"
		if (3)
			. = "невероятный [src]"
		else
			. = "[src]"
	. = "[src]"
	var/list/override = list(gender == PLURAL ? " " : " ", " ", "[ru_name]")
	if(article)
		. = "[src]"
		override[EXAMINE_POSITION_ARTICLE] = article
	if(SEND_SIGNAL(src, COMSIG_ATOM_GET_EXAMINE_NAME, user, override) & COMPONENT_EXNAME_CHANGED)
		. = override.Join("")

///Generate the full examine string of this atom (including icon for goonchat)
/atom/proc/ru_get_examine_string(mob/user)
	return "[icon2html(src, user)] [ru_get_examine_name(user)]"