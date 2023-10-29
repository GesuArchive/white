//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/settings/Ghost/chatterbox, toggle_ghost_ears)()

/datum/verbs/menu/settings
	name = "Настройки"

//override because we don't want to save preferences twice.
/datum/verbs/menu/settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")

/datum/verbs/menu/settings/verb/setup_character()
	set name = "Настройки"
	set category = "Настройки"
	set desc = "Основные настройки"
	usr.client.prefs.current_tab = 2
	usr.client.prefs.ShowChoices(usr)

/datum/verbs/menu/settings/verb/setup_sound()
	set name = "Звук"
	set category = "Настройки"
	set desc = "Настройки звука"
	new /datum/sound_panel(usr)

/datum/verbs/menu/settings/verb/setup_chat()
	set name = "Чат"
	set category = "Настройки"
	set desc = "Настройки чата"
	new /datum/chat_settings_panel(usr)

/datum/verbs/menu/settings/verb/stop_client_sounds()
	set name = "Починить звук"
	set category = "Особенное"
	set desc = "Остановить звуки"
	SEND_SOUND(usr, sound(null))
	var/client/C = usr.client
	C?.tgui_panel?.stop_music()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Stop Self Sounds")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_intent_style()
	set name = "🔄 Метод выбора интентов"
	set category = null
	set desc = "Toggle between directly clicking the desired intent or clicking to rotate through."
	prefs.toggles ^= INTENT_STYLE
	to_chat(src, "[(prefs.toggles & INTENT_STYLE) ? "Нажатие на тип взаимодействия теперь выбирает его." : "Нажатие на любой тип взаимодействия будет сменять их по часовой стрелке."]")
	prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Intent Selection", "[prefs.toggles & INTENT_STYLE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Admin Preferences
/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Настройки.Адм"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Adminhelp Sound", "[prefs.toggles & SOUND_ADMINHELP ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Настройки.Адм"
	set desc = "Toggle if you want an announcement to admins when you login during a round"
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Login Announcement", "[prefs.toggles & ANNOUNCE_LOGIN ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Настройки.Адм"
	set desc = "Toggle seeing radiochatter from nearby radios and speakers"
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.chat_toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Radio Chatter", "[prefs.chat_toggles & CHAT_RADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Настройки.Адм"
	set desc ="Toggles seeing deadchat"
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_DEAD
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Deadchat Visibility", "[prefs.chat_toggles & CHAT_DEAD ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Настройки.Адм"
	set desc = "Toggles seeing prayers"
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Visibility", "[prefs.chat_toggles & CHAT_PRAYER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_prayer_sound()
	set name = "Hear/Silence Prayer Sounds"
	set category = "Настройки.Адм"
	set desc = "Hear Prayer Sounds"
	if(!holder)
		return
	prefs.toggles ^= SOUND_PRAYERS
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_PRAYERS) ? "now" : "no longer"] hear a sound when prayers arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Sounds", "[usr.client.prefs.toggles & SOUND_PRAYERS ? "Enabled" : "Disabled"]"))

/client/proc/colorasay()
	set name = "Set Admin Say Color"
	set category = "Настройки.Адм"
	set desc = "Set the color of your ASAY messages"
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	var/new_asaycolor = input(src, "Please select your ASAY color.", "ASAY color", prefs.asaycolor) as color|null
	if(new_asaycolor)
		prefs.asaycolor = sanitize_ooccolor(new_asaycolor)
		prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set ASAY Color")
	return

/client/proc/resetasaycolor()
	set name = "Reset your Admin Say Color"
	set desc = "Returns your ASAY Color to default"
	set category = "Настройки.Адм"
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	prefs.asaycolor = initial(prefs.asaycolor)
	prefs.save_preferences()
