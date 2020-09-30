#define ui_emotes "EAST-1:44,SOUTH+2:8"

/datum/hud/proc/add_emote_panel(mob/owner)
	var/obj/screen/using

	using = new /obj/screen/emote_button()
	using.screen_loc = ui_emotes
	using.hud = src
	infodisplay += using

/obj/screen/emote_button
	name = "Действия"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "main"

/obj/screen/emote_button/Click()
	ui_interact(usr)

/obj/screen/emote_button/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmoteMenu", name)
		ui.open()

/obj/screen/emote_button/ui_status(mob/user)
	return UI_INTERACTIVE

/obj/screen/emote_button/ui_data(mob/user)
	var/list/keys = list()

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sortList(keys)

	var/list/data = list()
	data["emotes"] = keys

	return data

/obj/screen/emote_button/ui_act(action, params)
	. = ..()
	if(.)
		return
	usr.emote("[action]")
	. = TRUE
