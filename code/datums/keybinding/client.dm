/datum/keybinding/client
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST


/datum/keybinding/client/admin_help
	hotkey_keys = list("F1")
	name = "admin_help"
	full_name = "Admin Help"
	description = "Ask an admin for help."
	keybind_signal = COMSIG_KB_CLIENT_GETHELP_DOWN

/datum/keybinding/client/admin_help/down(client/user)
	. = ..()
	if(.)
		return
	user.adminhelp()
	return TRUE


/datum/keybinding/client/screenshot
	hotkey_keys = list("F2")
	name = "screenshot"
	full_name = "Screenshot"
	description = "Take a screenshot."
	keybind_signal = COMSIG_KB_CLIENT_SCREENSHOT_DOWN

/datum/keybinding/client/screenshot/down(client/user)
	. = ..()
	if(.)
		return
	winset(user, null, "command=.screenshot [!user.keys_held["shift"] ? "auto" : ""]")
	return TRUE

/datum/keybinding/client/minimal_hud
	hotkey_keys = list("F12")
	name = "minimal_hud"
	full_name = "Minimal HUD"
	description = "Hide most HUD features"
	keybind_signal = COMSIG_KB_CLIENT_MINIMALHUD_DOWN

/datum/keybinding/client/minimal_hud/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.button_pressed_F12()
	return TRUE


/datum/keybinding/client/multiz_up_hotkeys
	hotkey_keys = list("Northeast") // PAGEUP
	name = "multiz_up_hotkeys"
	full_name = "Вверх"
	description = "Подняться/взлететь вверх"
	keybind_signal = COMSIG_KB_CLIENT_MULTIZ_UP

/datum/keybinding/client/multiz_up_hotkeys/down(client/user)
	. = ..()
	if(.)
		return
	usr.up()
	return TRUE

/datum/keybinding/client/multiz_down_hotkeys
	hotkey_keys = list("Southeast") // PAGEDOWN
	name = "multiz_down_hotkeys"
	full_name = "Вниз"
	description = "Опуститься/полететь вниз"
	keybind_signal = COMSIG_KB_CLIENT_MULTIZ_DOWN

/datum/keybinding/client/multiz_down_hotkeys/down(client/user)
	. = ..()
	if(.)
		return
	usr.down()
	return TRUE
