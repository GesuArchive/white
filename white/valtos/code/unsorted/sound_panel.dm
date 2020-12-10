////////////////////////////////////////////////
//
//
// Панелька для управления звуками в игре. Прикол.
//
//
////////////////////////////////////////////////

/datum/sound_panel/New(user)
	ui_interact(user)

/datum/sound_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SoundPanelSettings")
		ui.open()

/datum/sound_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/sound_panel/ui_data(mob/user)

	if(!usr?.client)
		return

	var/client/C = usr.client

	var/list/data = list()

	data["adminhelp"] 		= C.prefs.toggles & SOUND_ADMINHELP
	data["midi"] 			= C.prefs.toggles & SOUND_MIDI
	data["ambience"] 		= C.prefs.toggles & SOUND_AMBIENCE
	data["lobby"] 			= C.prefs.toggles & SOUND_LOBBY
	data["instruments"] 	= C.prefs.toggles & SOUND_INSTRUMENTS
	data["ship_ambience"] 	= C.prefs.toggles & SOUND_SHIP_AMBIENCE
	data["prayers"] 		= C.prefs.toggles & SOUND_PRAYERS
	data["announcements"] 	= C.prefs.toggles & SOUND_ANNOUNCEMENTS
	data["endofround"] 		= C.prefs.toggles & SOUND_ENDOFROUND
	data["jukebox"] 		= C.prefs.w_toggles & SOUND_JUKEBOX

	return data

/datum/sound_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!usr?.client?.prefs)
		return

	var/client/C = usr.client

	switch(action)
		if("bt_customize")
			C.customize_battletension()
			return
		if("adminhelp")
			C.prefs.toggles ^= SOUND_ADMINHELP
		if("midi")
			C.prefs.toggles ^= SOUND_MIDI
			C?.tgui_panel?.stop_music()
			usr.stop_sound_channel(CHANNEL_ADMIN)
		if("ambience")
			C.prefs.toggles ^= SOUND_AMBIENCE
			usr.stop_sound_channel(CHANNEL_AMBIENCE)
			usr.stop_sound_channel(CHANNEL_BUZZ)
		if("lobby")
			C.prefs.toggles ^= SOUND_LOBBY
			usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			if(isnewplayer(usr))
				C.playtitlemusic()
		if("instruments")
			C.prefs.toggles ^= SOUND_INSTRUMENTS
		if("ship_ambience")
			C.prefs.toggles ^= SOUND_SHIP_AMBIENCE
			usr.stop_sound_channel(CHANNEL_BUZZ)
			C.ambience_playing = 0
		if("prayers")
			C.prefs.toggles ^= SOUND_PRAYERS
		if("announcements")
			C.prefs.toggles ^= SOUND_ANNOUNCEMENTS
		if("endofround")
			C.prefs.toggles ^= SOUND_ENDOFROUND
		if("jukebox")
			C.prefs.w_toggles ^= SOUND_JUKEBOX
			usr.stop_sound_channel(CHANNEL_JUKEBOX)

	C.prefs.save_preferences()
	. = TRUE
