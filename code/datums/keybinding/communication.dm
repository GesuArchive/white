/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("F3", "T", "Е")
	name = "Сказать"
	full_name = "IC Say"
	keybind_signal = COMSIG_KB_CLIENT_SAY_DOWN

/datum/keybinding/client/communication/ooc
	hotkey_keys = list("O", "Щ")
	name = "OOC"
	full_name = "Out Of Character Say (OOC)"
	keybind_signal = COMSIG_KB_CLIENT_OOC_DOWN

/datum/keybinding/client/communication/me
	hotkey_keys = list("F4", "M", "Ь")
	name = "Действия"
	full_name = "Custom Emote (/Действия)"
	keybind_signal = COMSIG_KB_CLIENT_ME_DOWN
