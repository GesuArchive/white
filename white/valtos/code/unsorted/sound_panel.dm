////////////////////////////////////////////////
//
//
// Панелька для управления звуками в игре. Прикол.
//
//
////////////////////////////////////////////////

/client/verb/sound_panel()
	set name = " ! Настройка звука"
	set category = "Настройки"

	new /datum/sound_panel(usr)

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
		if("ambience")
			C.prefs.toggles ^= SOUND_AMBIENCE
		if("lobby")
			C.prefs.toggles ^= SOUND_LOBBY
		if("instruments")
			C.prefs.toggles ^= SOUND_INSTRUMENTS
		if("ship_ambience")
			C.prefs.toggles ^= SOUND_SHIP_AMBIENCE
		if("prayers")
			C.prefs.toggles ^= SOUND_PRAYERS
		if("announcements")
			C.prefs.toggles ^= SOUND_ANNOUNCEMENTS
		if("endofround")
			C.prefs.toggles ^= SOUND_ENDOFROUND
		if("jukebox")
			C.prefs.w_toggles ^= SOUND_JUKEBOX

	DIRECT_OUTPUT(usr, sound(null))
	C?.tgui_panel?.stop_music()

	C.prefs.save_preferences()
	. = TRUE
