#define ui_ooc "EAST-1:28,SOUTH+2:8"
#define ui_special "EAST-1:44,SOUTH+2:8"
#define ui_settings "EAST-1:44,SOUTH+2:24"

/datum/hud
	var/obj/screen/ooc_icon
	var/obj/screen/special_icon
	var/obj/screen/settings_icon
	//var/obj/screen/object

/datum/hud/proc/extend(mob/owner)
	var/obj/screen/using

	if(!using)
		return //потомушто недопилено

	using = new /obj/screen/ooc()
	//using.icon = ui_style
	using.screen_loc = ui_ooc
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


/obj/screen/ooc
	name = "ooc"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "ooc"
	screen_loc = ui_ooc

/obj/screen/ooc/Click()
	ui_interact(usr)

/obj/screen/ooc/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.not_incapacitated_turf_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "OOCMenu", "OOC", 700, 800, master_ui, state)
		ui.open()
/*
/obj/screen/ooc/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("prikl")
*/
/obj/screen/special
	name = "special"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "special"
	screen_loc = ui_special

/obj/screen/settings
	name = "special"
	icon = 'code/shitcode/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "settings"
	screen_loc = ui_settings
