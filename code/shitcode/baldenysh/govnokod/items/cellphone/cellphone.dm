/obj/item/cellphone
	name = "Мобилка"
	desc = "Алло, вам звонит Лёха."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "suspiciousphone"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("звонит")
	var/ui_x = 264
	var/ui_y = 600

	var/list/screens = list()
	var/curscreen = "main"

/obj/item/cellphone/Initialize()
	. = ..()
	for(var/PStype in subtypesof(/datum/phonescreen))
		var/datum/phonescreen/PS = new PStype
		screens[PS.name] = PS
		PS.myphone = src

/obj/item/cellphone/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Cellphone", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/item/cellphone/ui_data(mob/user)
	var/list/data = list()

	var/datum/phonescreen/PS = screens[curscreen]

	data["lf_menu"] = PS.lf_menu
	data["rf_menu"] = PS.rf_menu

	return data

/obj/item/cellphone/ui_act(action, params)
	if(..())
		return
	if(!screens[curscreen])
		return
	var/datum/phonescreen/PS = screens[curscreen]
	. = TRUE
	switch(action)
		if("call")
			PS.call_act()
		if("hang")
			PS.call_act()
		if("leftfunc")
			PS.lf_act()
		if("rightfunc")
			PS.rf_act()
		if("dpad")
			PS.dpad_act(params["button"])
		if("numpad")
			PS.numpad_act(params["button"])

/obj/item/cellphone/proc/set_screen(name)
	if(!screens[name])
		return
	curscreen = name
	if(ismob(loc))
		var/mob/user = loc
		ui_interact(user)
