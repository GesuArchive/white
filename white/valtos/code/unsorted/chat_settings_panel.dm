////////////////////////////////////////////////
//
//
// Переключатели чатиков. Да...
//
//
////////////////////////////////////////////////

GLOBAL_LIST_INIT(ghost_chat_settings_list_desc, list(
	"Разговоры" 	  	= CHAT_GHOSTEARS,
	"Эмоуты"   			= CHAT_GHOSTSIGHT,
	"Шепот" 			= CHAT_GHOSTWHISPER,
	"Сообщения ПДА" 	= CHAT_GHOSTPDA,
	"Радиопереговоры"   = CHAT_GHOSTRADIO,
	"Смена законов ИИ" 	= CHAT_GHOSTLAWS
))

GLOBAL_LIST_INIT(ic_settings_list_desc, list(
	"Зарплата" 	  		= CHAT_BANKCARD
))

GLOBAL_LIST_INIT(chat_settings_list_desc, list(
	"OOC" 		  		= CHAT_OOC,
	"LOOC" 		  		= CHAT_LOOC
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
	.["ghost"] = list()
	for(var/key in GLOB.chat_settings_list_desc)
		.["ghost"] += list(list(
			"key" = GLOB.chat_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.chat_settings_list_desc[key]),
			"desc" = key
		))
	.["ic"] = list()
	for(var/key in GLOB.ic_settings_list_desc)
		.["ic"] += list(list(
			"key" = GLOB.ic_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.ic_settings_list_desc[key]),
			"desc" = key
		))
	.["chat"] = list()
	for(var/key in GLOB.chat_settings_list_desc)
		.["chat"] += list(list(
			"key" = GLOB.chat_settings_list_desc[key],
			"enabled" = !(user.client.prefs.chat_toggles & GLOB.chat_settings_list_desc[key]),
			"desc" = key
		))

/datum/chat_settings_panel/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch (action)
		if ("toggle_ignore")
			var/key = params["key"]
			if (key)
				usr.client.prefs.chat_toggles ^= key
	. = TRUE
