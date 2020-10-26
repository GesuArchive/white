/client/verb/reset_hotkeys_please()
	set name = "❗ Починить управление"
	set category = "Особенное"
	set desc = "Даёт возможность выбрать какое управление ты больше предпочитаешь. Также чинит \"нерабочие\" хоткеи."

	var/choice = tgalert(usr, "ПЕРЕКЛЮЧИТЕСЬ НА АНГЛИЙСКУЮ РАСКЛАДКУ ПЕРЕД ВЫБОРОМ", "Настройка хоткеев", "Хоткеи", "Классика", "Отмена")
	if(choice == "Отмена")
		return
	prefs.hotkeys = (choice == "Хоткеи")
	prefs.key_bindings = (prefs.hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
	set_macros()
	prefs.save_preferences()

	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Resetted Keys")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
