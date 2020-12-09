////////////////////////////////////////////////
//
//
// Переключатели чатиков. Да...
//
//
////////////////////////////////////////////////

GLOBAL_LIST_INIT(chat_settings_list_desc, list(
	CHAT_OOC 		  = "OOC",
	CHAT_LOOC 		  = "LOOC",
	CHAT_DEAD 		  = "Дедчат",
	CHAT_GHOSTEARS 	  = "Разговоры",
	CHAT_GHOSTSIGHT   = "Эмоуты",
	CHAT_GHOSTWHISPER = "Шепот",
	CHAT_GHOSTPDA 	  = "Сообщения ПДА",
	CHAT_GHOSTRADIO   = "Радиопереговоры",
	CHAT_BANKCARD 	  = "Зарплата",
	CHAT_GHOSTLAWS 	  = "Смена законов ИИ"
))

/client/verb/chat_settings_panel()
	set name = " ! Настройка чата"
	set category = "Настройки"

	new /datum/chat_settings_panel(usr)

/datum/chat_settings_panel/New(user)
	ui_interact(user)

/datum/chat_settings_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChatSettingsPanel")
		ui.open()

/datum/chat_settings_panel/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/chat_settings_panel/ui_data(mob/user)
	. = list()
	.["ignore"] = list()
	for(var/key in GLOB.chat_settings_list_desc)
		.["ignore"] += list(list(
			"key" = key,
			"enabled" = (user.client.prefs.chat_toggles & key),
			"desc" = GLOB.chat_settings_list_desc[key]
		))

/datum/chat_settings_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch (action)
		if ("toggle_ignore")
			var/key = params["key"]
			if (key)
				user.client.prefs.chat_toggles ^= key
	. = TRUE
