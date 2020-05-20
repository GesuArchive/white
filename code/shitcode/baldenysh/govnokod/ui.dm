#define ui_game "EAST-1:28,SOUTH+2:8"
#define ui_special "EAST-1:44,SOUTH+2:8"
#define ui_settings "EAST-1:44,SOUTH+2:24"
#define ui_admin "EAST-1:28,SOUTH+2:24"
/*
/datum/hud
	var/obj/screen/ooc_icon
	var/obj/screen/special_icon
	var/obj/screen/settings_icon
	//var/obj/screen/object
*/
/datum/hud/proc/extend(mob/owner)
	var/obj/screen/using

	if(owner.client.holder)
		using = new /obj/screen/admin()
		//using.icon = ui_style
		using.screen_loc = ui_admin
		using.hud = src
		infodisplay += using


	if(!using)
		return //потомушто недопилено

	using = new /obj/screen/game()
	//using.icon = ui_style
	using.screen_loc = ui_game
	using.hud = src
	infodisplay += using

	using = new /obj/screen/special()
	//using.icon = ui_style
	using.screen_loc = ui_special
	using.hud = src
	infodisplay += using

	using = new /obj/screen/settings()
	//using.icon = ui_style
	using.screen_loc = ui_settings
	using.hud = src
	infodisplay += using

/obj/screen/admin
	name = "secret"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "ooc"
	screen_loc = ui_admin

/obj/screen/admin/Click()
	if(!ismob(usr))
		return
	var/mob/M = usr
	if(M.client.holder)
		ui_interact(usr)

/obj/screen/admin/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.admin_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "AdminMenu", "Admin Menu", 700, 800, master_ui, state)
		ui.open()

/obj/screen/admin/ui_data(mob/user)
	var/list/data = list()

	data["rights"] = user.client.holder.rank.rights

	return data

/obj/screen/admin/ui_act(action, params)
	if(..())
		return
	var/client/C = usr.client
	switch(action)
		//default a/v
		if("deadmin")
			C.deadmin()
		if("cmd_asay")
			C.get_admin_say()

/obj/screen/game
	name = "ooc"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "ooc"
	screen_loc = ui_game

/obj/screen/game/Click()
	ui_interact(usr)

/obj/screen/game/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "GameMenu", "Игра", 400, 600, master_ui, state)
		ui.open()

/obj/screen/game/ui_status(mob/user)
	. = ..()
	. = UI_INTERACTIVE

/obj/screen/game/ui_data(mob/user)
	var/list/data = list()

	for(var/verb_to in user.verbs)
		if(verb_to:category)
			data[verb_to:category] += list(list(verb_to:name, verb_to))

	return data

/obj/screen/game/ui_act(action, params)
	if(..())
		return
	call(usr, action)()

/obj/screen/special
	name = "special"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "special"
	screen_loc = ui_special

/obj/screen/settings
	name = "settings"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "settings"
	screen_loc = ui_settings
