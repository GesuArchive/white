SUBSYSTEM_DEF(title)
	name = "Заставки"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/ctt = ""
	var/loader_pos = 0
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

	return ..()

/datum/controller/subsystem/title/proc/adjust_load_pos(val_to, text_to)
	if(enabled_shit)
		loader_pos += val_to
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.send_to_lobby_load_pos(loader_pos, text_to)

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
				var/role_thing = "Неизвестно"
				if(player.client.prefs.job_preferences["Assistant"])
					role_thing = "Ассистент"
				else
					for(var/j in player.client.prefs.job_preferences)
						if(player.client.prefs.job_preferences[j] == JP_HIGH)
							role_thing = j
							break
				if(!caa[role_thing])
					caa[role_thing] = list(player.key)
				else
					caa[role_thing] += "[player.key]"
			else
				cum += "[player.key]"
		for(var/line in GLOB.whitelist)
			cum += "[line]"
		tcc += "<table>"
		if(SSticker.current_state == GAME_STATE_PREGAME)
			for(var/line in sortList(caa))
				tcc += "<tr><td class='role'>[line]</td><td class='victims'>[english_list(caa[line])]</td></tr>"
			tcc += "<tr><td class='role'>Не готовы:</td><td class='victims'>"
		else
			tcc += "<tr><td class='role'>Чат-боты:</td><td class='victims'>"
		tcc += "[english_list(cum)]"
		tcc += "</td></tr></table>"
		ctt = tcc
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/afterload()
	cls()

/datum/controller/subsystem/title/Shutdown()

	for(var/client/thing in GLOB.clients)
		if(!thing)
			continue
		thing.fit_viewport()
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)
