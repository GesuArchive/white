
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

	switch(SSviolence.theme)
		if(VIOLENCE_THEME_STD)
			switch(SSviolence.current_round)
				if(1 to 2)
					S = 'sound/music/violence/battle_small.ogg'
				if(3 to 5)
					S = 'sound/music/violence/battle_mid.ogg'
				if(6 to 8)
					S = 'sound/music/violence/battle_hi.ogg'
				if(9 to 10)
					S = 'sound/music/violence/battle_fuck.ogg'
		if(VIOLENCE_THEME_HOTLINE)
			switch(SSviolence.current_round)
				if(1)
					S = 'sound/music/violence/hotline1.ogg'
				if(2)
					S = 'sound/music/violence/hotline2.ogg'
				if(3)
					S = 'sound/music/violence/hotline3.ogg'
				if(4)
					S = 'sound/music/violence/hotline4.ogg'
				if(5)
					S = 'sound/music/violence/hotline5.ogg'
				if(6)
					S = 'sound/music/violence/hotline6.ogg'
				if(7)
					S = 'sound/music/violence/hotline7.ogg'
				if(8)
					S = 'sound/music/violence/hotline8.ogg'
				if(9)
					S = 'sound/music/violence/hotline9.ogg'
				if(10)
					S = 'sound/music/violence/hotline10.ogg'
		if(VIOLENCE_THEME_KATANA)
			switch(SSviolence.current_round)
				if(1)
					S = 'sound/music/violence/kat1.ogg'
				if(2)
					S = 'sound/music/violence/kat2.ogg'
				if(3)
					S = 'sound/music/violence/kat3.ogg'
				if(4)
					S = 'sound/music/violence/kat4.ogg'
				if(5)
					S = 'sound/music/violence/kat5.ogg'
				if(6)
					S = 'sound/music/violence/kat6.ogg'
				if(7)
					S = 'sound/music/violence/kat7.ogg'
				if(8)
					S = 'sound/music/violence/kat8.ogg'
				if(9)
					S = 'sound/music/violence/kat9.ogg'
				if(10)
					S = 'sound/music/violence/kat10.ogg'
		if(VIOLENCE_THEME_CYBER)
			switch(SSviolence.current_round)
				if(1 to 2)
					S = 'sound/music/violence/cyberjockey.ogg'
				if(3 to 4)
					S = 'sound/music/violence/hn1.ogg'
				if(5 to 6)
					S = 'sound/music/violence/hn2.ogg'
				if(7 to 8)
					S = 'sound/music/violence/hn3.ogg'
				if(9 to 10)
					S = 'sound/music/violence/hn4.ogg'
		if(VIOLENCE_THEME_WARFARE)
			switch(SSviolence.current_round)
				if(1 to 2)
					S = 'sound/music/violence/tar1.ogg'
				if(3 to 4)
					S = 'sound/music/violence/tar2.ogg'
				if(5 to 6)
					S = 'sound/music/violence/tar3.ogg'
				if(7 to 8)
					S = 'sound/music/violence/tar4.ogg'
				if(9 to 10)
					S = 'sound/music/violence/tar5.ogg'
		if(VIOLENCE_THEME_PORTAL)
			switch(SSviolence.current_round)
				if(1)
					S = 'sound/music/violence/por1.ogg'
				if(2)
					S = 'sound/music/violence/por2.ogg'
				if(3)
					S = 'sound/music/violence/por3.ogg'
				if(4 to 5)
					S = 'sound/music/violence/por4.ogg'
				if(6 to 7)
					S = 'sound/music/violence/por5.ogg'
				if(8 to 9)
					S = 'sound/music/violence/por6.ogg'
				if(10)
					S = 'sound/music/violence/por7.ogg'

	if(S)
		SEND_SOUND(L, sound(S, repeat = 1, wait = 0, volume = 10, channel = CHANNEL_VIOLENCE_MODE))
