/datum/hud/proc/add_emote_panel(mob/owner)
	var/atom/movable/screen/using

	using = new /atom/movable/screen/emote_button()
	using.screen_loc = ui_emotes
	using.hud = src
	infodisplay += using

/atom/movable/screen/emote_button
	name = "Действия"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "emotes"
	var/cooldown = 0

/atom/movable/screen/emote_button/Click()
	ui_interact(usr)

/atom/movable/screen/emote_button/MouseEntered()
	flick(icon_state + "_anim", src)

/atom/movable/screen/emote_button/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmoteMenu", name)
		ui.open()

/atom/movable/screen/emote_button/ui_status(mob/user)
	return UI_INTERACTIVE

/atom/movable/screen/emote_button/ui_data(mob/user)
	var/list/L = list()
	var/list/keys = list()

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key
				L.Add(list(list("name" = P.key, "ru_name" = capitalize(P.ru_name))))

	var/list/data = list()
	data["emotes"] = L

	return data

/atom/movable/screen/emote_button/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(cooldown <= world.time)
		cooldown = world.time + 1 SECONDS
		usr.emote("[action]")
		. = TRUE
