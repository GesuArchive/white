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

	if(SSviolence.forced_map)
		current_map = new SSviolence.forced_map
	else
		current_map = pick_weight(maplist)

	SSviolence.default_color = current_map.map_color
	SSviolence.default_alpha = current_map.map_alpha
	SSviolence.theme = current_map.theme

	// меняем тему в лобби на задорную и устанавливаем флаг если потребуется
	switch(SSviolence.theme)
		if(VIOLENCE_THEME_STD)
			SSticker.login_music = sound('sound/music/violence/menue.ogg')
		if(VIOLENCE_THEME_HOTLINE)
			SSticker.login_music = sound('sound/music/violence/hotlinemenu.ogg')
		if(VIOLENCE_THEME_KATANA)
			SSticker.login_music = sound('sound/music/violence/katmenu.ogg')
		if(VIOLENCE_THEME_WARFARE)
			SSticker.login_music = sound('sound/music/violence/cd.ogg')
		if(VIOLENCE_THEME_CYBER)
			SSviolence.special_theme_process = TRUE
			SSticker.login_music = sound('sound/music/violence/hexgrips.ogg')
		if(VIOLENCE_THEME_PORTAL)
			SSviolence.special_theme_process = TRUE
			SSticker.login_music = sound('sound/music/violence/portalgrips.ogg')

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
