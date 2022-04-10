GLOBAL_VAR(violence_landmark)

/obj/effect/landmark/violence
	name = "Violence Map Spawner"

/obj/effect/landmark/violence/Initialize(mapload)
	. = ..()
	GLOB.violence_landmark = src

/obj/effect/landmark/violence/proc/load_map()

	var/turf/spawn_area = get_turf(src)
	var/datum/map_template/violence/current_map
	var/list/maplist = list()

	for(var/item in subtypesof(/datum/map_template/violence))
		var/datum/map_template/violence/C = new item()
		if(C.max_players < GLOB.player_list.len || C.min_players > GLOB.player_list.len)
			message_admins("[C.name]: максимум [C.max_players] игроков, минимум [C.min_players] игроков, пропускаем...")
			qdel(C)
			continue
		maplist[C] = C.weight

	if(GLOB.violence_forced_map)
		current_map = new GLOB.violence_forced_map
	else
		current_map = pickweight(maplist)

	GLOB.violence_theme = current_map.theme

	// меняем тему в лобби на задорную
	switch(GLOB.violence_theme)
		if("std")
			SSticker.login_music = sound('white/valtos/sounds/menue.ogg')
		if("hotline")
			SSticker.login_music = sound('white/valtos/sounds/hotlinemenu.ogg')
		if("katana")
			SSticker.login_music = sound('white/valtos/sounds/katmenu.ogg')
		if("warfare")
			SSticker.login_music = sound('white/valtos/sounds/cd.ogg')
		if("cyber")
			SSticker.login_music = sound('white/valtos/sounds/hexgrips.ogg')

	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()

	if(!spawn_area)
		CRASH("No spawn area detected for Violence!")
	else if(!current_map)
		CRASH("No map prepared")
	var/list/bounds = current_map.load(spawn_area, TRUE)
	spawn(3 SECONDS)
		to_chat(world, leader_brass("[current_map.name]! [current_map.description]"))
	if(!bounds)
		CRASH("Loading Violence map failed!")
