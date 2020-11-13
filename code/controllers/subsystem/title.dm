SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/ctt = ""
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
				sm("-------------------------------------------------------------------------------------------------")
				sm("")
				sm("\[BI-[rand(1000, 9999)]\]:    ONLINE    \[9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08\]")
				sm("\[EY-[rand(1000, 9999)]\]:    ONLINE    \[7c7d31f4816deb275fc4101b94fdf7841037df407e062d4e897a42fd975e3a11\]")
				sm("\[AO-[rand(1000, 9999)]\]:    ONLINE    \[c7962f8eddec633e32eb7a3c800c851df1551edc6664a60f2b665c8b82be0cb8\]")
				sm("\[RW-[rand(1000, 9999)]\]:    ONLINE    \[53ae23b3ab3992a580ecd3ef63302212a359f6441cd1fdc9bef4156eaa0173f5\]")
				sm("\[BN-[rand(1000, 9999)]\]:    ONLINE    \[7d1fc9ead962730d880e9f1047842017710f5b7f165778724ea638f13c93aa3c\]")
				sm("\[SI-[rand(1000, 9999)]\]:    ONLINE    \[404cdd7bc109c432f8cc2443b45bcfe95980f5107215c645236e577929ac3e52\]")
				sm("\[ND-[rand(1000, 9999)]\]:    ONLINE    \[aa6691c624dbe6c95e68c9fc565476b9e1e62a04c6a86edbfec37487ecce011d\]")
				sm("")
				sm("-------------------------------------------------------------------------------------------------")
			if("init2")
				sm("")
				sm("@> NODE RECREATION PROCESS STARTED:")
				sm("")
				sm("        > BIOS                - STABLE -                \[0[rand(1, 5)]% CORRUPTION\]")
				sm("        > CPU                 - STABLE -                \[[rand(22, 77)]% FREE\]")
				sm("        > MEM                 - STABLE -                \[[rand(11, 33)]% FREE\]")
				sm("        > MB                  - STABLE -                \[[rand(95, 99)]% INTEGRITY\]")
				sm("        > TEMP                - STABLE -                \[-[rand(30, 50)] C\]")
				sm("")
				sm("")
			if("atoms1")
				sm("@> INFRASTRUCTURE ROUTES DEGRADATION STARTED:")
				sm("")
				sm("        > 127.0.0.1           - READY -                 \[f528764d624db129b32c21fbca0cb8d6\]")
				sm("        > 77.88.8.8           - READY -                 \[ec5b16d37efebb673356702a72ef4635\]")
				sm("        > STATION13.RU        - READY -                 \[dec20fe05cd8bcbfae7db11a2995f85c\]")
				sm("        > FUNCLUB.PRO         - READY -                 \[59c3d89ad1367804e9deab7b931e18a7\]")
				sm("")
				sm("")
				sm("@> PROCESSING LAZYFRAME RECREATION...")
				sm("")
				sm("        > CORRUPTED WORLD     - DONE -")
				sm("        > LAZY ATOMS          ", FALSE)
			if("atoms2")
				sm("- DONE -")
				sm("        > NOBLE DISEASES      ", FALSE)
			if("diseases")
				sm("- DONE -")
				sm("        > TURBO AIR           ", FALSE)
			if("air")
				sm("- DONE -")
				sm("        > LOSING ASSETS       ", FALSE)
			if("assets")
				sm("- DONE -")
				sm("        > EDGY SMOOTHING      ", FALSE)
			if("smoothing")
				sm("- DONE -")
				sm("        > LAGGY OVERLAYS      ", FALSE)
			if("overlays")
				sm("- DONE -")
				sm("        > CURSED LIGHT        ", FALSE)
			if("light")
				sm("- DONE -")
				sm("        > BROKEN SHUTTLE      ", FALSE)
			if("shuttle")
				sm("- DONE -")
				sm("")
			if("end")
				sm("@> world.execute(white)")
				sm("")
				sm("        > ぷろとこう_はかい")
				sm("</br></br></br></br>")
				var/nn = 0
				while(nn != 5)
					sleep(1)
					sm("</br></br></br></br>")
					nn++
				cls()

/datum/controller/subsystem/title/proc/sm(msg, newline = TRUE)
	if(enabled_shit)
		if(newline)
			ctt += "[msg]</br>"
		else
			ctt += "[msg]"

		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/cls()
	if(enabled_shit)
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
		ctt = ""
		game_loaded = TRUE
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
			tcc += "</br></br><big>Лобби:</big></br>"
		for(var/line in sortList(cum))
			tcc += " - [line]</br>"
		ctt = tcc
		for(var/mob/dead/new_player/D in GLOB.new_player_list)
			if(D?.client?.lobbyscreen_image)
				D.client.clear_lobby()
				D.client.send_to_lobby_console_now(ctt)

/datum/controller/subsystem/title/proc/afterload()
	// do nothing

/obj/rs_rs_rs
	name = "странная штука"
	layer = 24
	plane = 24
	blend_mode = 3
	alpha = 125
	icon = 'white/valtos/icons/d.dmi'
	icon_state = "star"
	color = "#aaaaaa"
	pixel_x = 240
	pixel_y = 176

/obj/rs_rs_rs/Initialize()
	. = ..()
	var/lor = 120
	if (prob(50))
		lor = -lor
		color = "#222222"

	var/soe = rand(2, 4)
	var/zof = rand(0.1, 0.5)

	animate(src, transform = matrix().Scale(soe,soe), pixel_x = rand(92, 508), time = rand(25, 50), loop = -1, flags = ANIMATION_PARALLEL)
	animate(	 transform = matrix().Scale(zof,zof), pixel_x = rand(92, 508), time = rand(100, 200))
	animate(	 transform = matrix().Scale(soe,soe), pixel_x = rand(92, 508), time = rand(25, 50))

	animate(src, transform = turn(matrix(), lor),   pixel_y = rand(150, 202),   time = rand(25, 50), loop = -1, flags = ANIMATION_PARALLEL)
	animate(	 transform = turn(matrix(), lor*2), pixel_y = rand(150, 202),   time = rand(100, 200))
	animate(	 transform = turn(matrix(), lor*3), pixel_y = rand(150, 202),   time = rand(25, 50))

/datum/controller/subsystem/title/Shutdown()

	for(var/client/thing in GLOB.clients)
		if(!thing)
			continue
		thing.fit_viewport()
		var/obj/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)
