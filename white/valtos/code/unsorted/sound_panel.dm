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

	var/datum/sound_panel/S = new
	if(S)
		S.ui_interact(src.mob)

/datum/sound_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SoundPanelSettings")
		ui.open()

/datum/sound_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/sound_panel/ui_data(mob/user)
	var/list/data = list()

	data["adminhelp"] 		= usr.client.prefs.toggles & SOUND_ADMINHELP
	data["midi"] 			= usr.client.prefs.toggles & SOUND_MIDI
	data["ambience"] 		= usr.client.prefs.toggles & SOUND_AMBIENCE
	data["lobby"] 			= usr.client.prefs.toggles & SOUND_LOBBY
	data["instruments"] 	= usr.client.prefs.toggles & SOUND_INSTRUMENTS
	data["ship_ambience"] 	= usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE
	data["prayers"] 		= usr.client.prefs.toggles & SOUND_PRAYERS
	data["announcements"] 	= usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS
	data["endofround"] 		= usr.client.prefs.toggles & SOUND_ENDOFROUND
	data["jukebox"] 		= usr.client.prefs.w_toggles & SOUND_JUKEBOX

	return data

/datum/sound_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	. = TRUE
