SUBSYSTEM_DEF(title)
	name = "Заставки"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/ctt = ""
	var/loader_pos = 25
	var/enabled_shit = TRUE
	var/game_loaded = FALSE
	var/current_lobby_screen = 'icons/ts.png'

/datum/controller/subsystem/title/Initialize()

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()
	var/use_rare_screens = prob(1)

	SSmapping.HACK_LoadMapConfig()

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if((L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png"))|| (L.len > 1 && ((use_rare_screens && lowertext(L[1]) == "rare") || (lowertext(L[1]) == lowertext(SSmapping.config.map_name)))))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/ts.png"

	ASSERT(fexists(file_path))

	current_lobby_screen = fcopy_rsc(file_path)

	update_lobby_screen()

	if(enabled_shit)
		set_load_state("init1")

	return ..()

/datum/controller/subsystem/title/proc/set_load_state(state)
	if(enabled_shit)
		switch(state)
			if("init1")
				set_load_pos(5, "инициализация")
			if("init2")
				set_load_pos(10, "инициализация?")
			if("atoms1")
				set_load_pos(20, "атомы")
			if("atoms2")
				set_load_pos(30, "атомы обработаны")
			if("diseases")
				set_load_pos(40, "система болезней")
			if("air")
				set_load_pos(50, "атмосфера")
			if("assets")
				set_load_pos(60, "ассеты")
			if("smoothing")
				set_load_pos(70, "сглаживание")
			if("overlays")
				set_load_pos(80, "оверлеи")
			if("light")
				set_load_pos(95, "свет")
			if("shuttle")
				set_load_pos(97, "шаттлы")
			if("end")
				set_load_pos(100, "готово")
				sleep(10)
				cls()

/datum/controller/subsystem/title/proc/set_load_pos(val_to, text_to)
	if(enabled_shit)
		loader_pos = val_to
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.send_to_lobby_load_pos(val_to, text_to)

/datum/controller/subsystem/title/proc/sm(msg, newline = TRUE)
	if(enabled_shit)
		if(newline)
			ctt += "[msg]</br>"
		else
			ctt += "[msg]"

/datum/controller/subsystem/title/proc/us()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/cls()
	if(enabled_shit)
		game_loaded = TRUE
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.stop_sound_channel(CHANNEL_LOBBYMUSIC)
				D.client.playtitlemusic()
		ctt = ""
		spawn(5)
			uplayers()

/datum/controller/subsystem/title/proc/update_lobby_screen()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.reload_lobby()

/datum/controller/subsystem/title/proc/uplayers()
	if(enabled_shit && game_loaded)
		var/list/caa = list()
		var/list/cum = list()
		ctt = ""
		var/tcc = ""
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(player.ready == PLAYER_READY_TO_PLAY)
				caa += "<b>[player.key]</b>"
			else
				cum += "[player.key]"
		for(var/line in GLOB.whitelist)
			cum += "[line]"
		if(SSticker.current_state == GAME_STATE_PREGAME)
			tcc += "<big>Готовы:</big></br>"
			for(var/line in sortList(caa))
				tcc += " - [line]</br>"
			tcc += "</br></br><big>Не готовы:</big></br>"
		else
			tcc += "</br></br><big>Чат-боты:</big></br>"
		for(var/line in sortList(cum))
			tcc += " - [line]</br>"
		ctt = tcc
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/afterload()
	// do nothing

/datum/controller/subsystem/title/Shutdown()

	for(var/client/thing in GLOB.clients)
		if(!thing)
			continue
		thing.fit_viewport()
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)
