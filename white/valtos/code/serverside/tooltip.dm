/client/MouseEntered(object, location)
	..()
	if(istype(object, /atom) && !isnewplayer(mob) && (prefs.w_toggles & TOOLTIP_USER_UP) && !(prefs.w_toggles & TOOLTIP_USER_RETRO))
		var/atom/A = object
		if(mob?.hud_used?.tooltip)
			var/obj_name = A.name
			if(mob.hud_used.tooltip.last_word == obj_name)
				return
			mob.hud_used.tooltip.maptext = "<span class='maptext reallybig yell' style='text-align: center; color: [isliving(A) ? "lime" : "white"];'>[uppertext(obj_name)]</span>"
	else if(mob?.hud_used?.tooltip)
		mob.hud_used.tooltip.maptext = ""

/atom/movable/screen/tooltip
	name = ""
	screen_loc = "NORTH,CENTER-4:16"
	maptext_width = 480
	maptext_x = -112
	maptext_y = 18
	layer = 23
