/client/verb/reset_hotkeys_please()
	set name = " ❗ Починить управление"
	set category = "Special Verbs"
	set desc = "Даёт возможность выбрать какое управление ты больше предпочитаешь. Также чинит \"нерабочие\" хоткеи."

	var/choice = tgalert(usr, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", "Hotkey", "Classic", "Cancel")
	if(choice == "Cancel")
		return
	hotkeys = (choice == "Hotkey")
	key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
	update_movement_keys()

	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Resetted Keys")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
