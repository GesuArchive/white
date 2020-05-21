#define ui_main "EAST-1:28,SOUTH+2:8"
#define ui_special "EAST-1:44,SOUTH+2:8"
#define ui_settings "EAST-1:44,SOUTH+2:24"
#define ui_admin "EAST-1:28,SOUTH+2:24"

/datum/hud/proc/extend(mob/owner)
	var/obj/screen/using

	if(owner.client.holder)
		using = new /obj/screen/verbbutton/admin()
		//using.icon = ui_style
		using.screen_loc = ui_admin
		using.hud = src
		infodisplay += using

	using = new /obj/screen/verbbutton/special()
	//using.icon = ui_style
	using.screen_loc = ui_special
	using.hud = src
	infodisplay += using

	using = new /obj/screen/verbbutton/settings()
	//using.icon = ui_style
	using.screen_loc = ui_settings
	using.hud = src
	infodisplay += using

	using = new /obj/screen/verbbutton/main()
	//using.icon = ui_style
	using.screen_loc = ui_main
	using.hud = src
	infodisplay += using

////////////////////////////////////////////////////////////

/mob/proc/get_all_verbs()
	var/list/verblist = list()
	for(var/verb_M in verbs)
		if(verb_M in verblist)
			continue
		verblist += verb_M
	if(client)
		for(var/verb_C in client.verbs)
			if(verb_C in verblist)
				continue
			verblist += verb_C
	return verblist

/mob/proc/get_verb_categories()
	var/list/categories = list()
	for(var/verb_item in get_all_verbs())
		if(verb_item:category && !(verb_item:category in categories))
			categories += verb_item:category
	return categories

///////////////////////////////////////////////////////////////////

/obj/screen/verbbutton
	name = "Верб кнопка прикол"
	var/list/allowed_categories = list(
								"IC", "OOC", "ОБЪЕКТ", "ПРИЗРАК", "ОСОБЕННОЕ", "НАСТРОЙКИ",
								"АДМИН", "АС", "ДЕБАГ", "СЕРВЕР", "ФАН"
							)
	var/ui_x = 450
	var/ui_y = 600

/obj/screen/verbbutton/Click()
	ui_interact(usr)

/obj/screen/verbbutton/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "VerbMenu", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/screen/verbbutton/ui_status(mob/user)
	return UI_INTERACTIVE

/obj/screen/verbbutton/ui_data(mob/user)
	var/list/data = list()
	data["verbs"] = list()

	for(var/verb_item in user.get_all_verbs())
		if(!verb_item:hidden && verb_item:category && (verb_item:category in allowed_categories))
			var/list/L = splittext("[verb_item]", "/")
			var/verbpath = L[L.len]
			data["verbs"][verb_item:category] += list(list(verb_item:name, verbpath))
	return data

/obj/screen/verbbutton/ui_act(action, params)
	if(..())
		return
	//регекс для поиска пидорасов: proc\/[\w\s]+\([\w\s]+as[\w\s]+\)[\w\s="]+set category
	if(hascall(usr, action))
		call(usr, action)()
	else if (hascall(usr.client, action))
		call(usr.client, action)()

////////////////////////////////////////////////////

/obj/screen/verbbutton/admin
	name = "Админ"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "admin"
	screen_loc = ui_admin
	allowed_categories = list("АДМИН", "АС", "ДЕБАГ", "СЕРВЕР", "ФАН", "Mapping", "Profile")

/obj/screen/verbbutton/admin/Click()
	if(usr.client.holder)
		ui_interact(usr)

/obj/screen/verbbutton/main
	name = "Действия"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "main"
	screen_loc = ui_main
	allowed_categories = list("IC", "OOC", "ОБЪЕКТ", "ПРИЗРАК")

/obj/screen/verbbutton/special
	name = "Особое"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "special"
	screen_loc = ui_special
	allowed_categories = list("ОСОБЕННОЕ")

/obj/screen/verbbutton/settings
	name = "Настройки"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "settings"
	screen_loc = ui_settings
	allowed_categories = list("НАСТРОЙКИ")

/obj/screen/verbbutton/settings/ui_data(mob/user)
	var/list/data = list()
	data["verbs"] = list()
	data["verbs"]["Основное"] = list()

	for(var/verb_item in user.get_all_verbs())
		if(verb_item:category && (verb_item:category in allowed_categories))
			var/list/L = splittext("[verb_item]", "/")
			var/verbpath = L[L.len]
			if(findtext(verb_item:name, "🔄"))
				data["verbs"]["Предпочтения"] += list(list(verb_item:name, verbpath))
			else
				data["verbs"]["Основное"] += list(list(verb_item:name, verbpath))
	return data
