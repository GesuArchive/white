
/area/violence
	name = "Насилие"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_LIGHT_GRAYISH_RED
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

// оверрайт прока для правильного вывода темы
/area/violence/Entered(atom/movable/arrived, area/old_area)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, arrived, old_area)
	if(!LAZYACCESS(arrived.important_recursive_contents, RECURSIVE_CONTENTS_AREA_SENSITIVE))
		return
	for(var/atom/movable/recipient as anything in arrived.important_recursive_contents[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		SEND_SIGNAL(recipient, COMSIG_ENTER_AREA, src)

	if(!isliving(arrived))
		return

	var/mob/living/L = arrived
	if(!L.ckey)
		return

	L?.hud_used?.update_parallax_pref(L)

	if(L?.client && !(L.client.prefs.toggles & SOUND_COPYRIGHTED))
		return

	var/S

	switch(GLOB.violence_theme)
		if("std")
			switch(GLOB.violence_current_round)
				if(1 to 2)
					S = 'white/valtos/sounds/battle_small.ogg'
				if(3 to 5)
					S = 'white/valtos/sounds/battle_mid.ogg'
				if(6 to 8)
					S = 'white/valtos/sounds/battle_hi.ogg'
				if(9 to 10)
					S = 'white/valtos/sounds/battle_fuck.ogg'
		if("hotline")
			switch(GLOB.violence_current_round)
				if(1)
					S = 'white/valtos/sounds/hotline1.ogg'
				if(2)
					S = 'white/valtos/sounds/hotline2.ogg'
				if(3)
					S = 'white/valtos/sounds/hotline3.ogg'
				if(4)
					S = 'white/valtos/sounds/hotline4.ogg'
				if(5)
					S = 'white/valtos/sounds/hotline5.ogg'
				if(6)
					S = 'white/valtos/sounds/hotline6.ogg'
				if(7)
					S = 'white/valtos/sounds/hotline7.ogg'
				if(8)
					S = 'white/valtos/sounds/hotline8.ogg'
				if(9)
					S = 'white/valtos/sounds/hotline9.ogg'
				if(10)
					S = 'white/valtos/sounds/hotline10.ogg'
		if("katana")
			switch(GLOB.violence_current_round)
				if(1)
					S = 'white/valtos/sounds/kat1.ogg'
				if(2)
					S = 'white/valtos/sounds/kat2.ogg'
				if(3)
					S = 'white/valtos/sounds/kat3.ogg'
				if(4)
					S = 'white/valtos/sounds/kat4.ogg'
				if(5)
					S = 'white/valtos/sounds/kat5.ogg'
				if(6)
					S = 'white/valtos/sounds/kat6.ogg'
				if(7)
					S = 'white/valtos/sounds/kat7.ogg'
				if(8)
					S = 'white/valtos/sounds/kat8.ogg'
				if(9)
					S = 'white/valtos/sounds/kat9.ogg'
				if(10)
					S = 'white/valtos/sounds/kat10.ogg'
		if("cyber")
			switch(GLOB.violence_current_round)
				if(1 to 2)
					S = 'white/valtos/sounds/cyberjockey.ogg'
				if(3 to 4)
					S = 'white/valtos/sounds/hn1.ogg'
				if(5 to 6)
					S = 'white/valtos/sounds/hn2.ogg'
				if(7 to 8)
					S = 'white/valtos/sounds/hn3.ogg'
				if(9 to 10)
					S = 'white/valtos/sounds/hn4.ogg'
		if("warfare")
			switch(GLOB.violence_current_round)
				if(1 to 2)
					S = 'white/valtos/sounds/tar1.ogg'
				if(3 to 4)
					S = 'white/valtos/sounds/tar2.ogg'
				if(5 to 6)
					S = 'white/valtos/sounds/tar3.ogg'
				if(7 to 8)
					S = 'white/valtos/sounds/tar4.ogg'
				if(9 to 10)
					S = 'white/valtos/sounds/tar5.ogg'
		if("portal")
			switch(GLOB.violence_current_round)
				if(1)
					S = 'white/valtos/sounds/por1.ogg'
				if(2)
					S = 'white/valtos/sounds/por2.ogg'
				if(3)
					S = 'white/valtos/sounds/por3.ogg'
				if(4 to 5)
					S = 'white/valtos/sounds/por4.ogg'
				if(6 to 7)
					S = 'white/valtos/sounds/por5.ogg'
				if(8 to 9)
					S = 'white/valtos/sounds/por6.ogg'
				if(10)
					S = 'white/valtos/sounds/por7.ogg'

	if(S)
		SEND_SOUND(L, sound(S, repeat = 1, wait = 0, volume = 10, channel = CHANNEL_VIOLENCE_MODE))
