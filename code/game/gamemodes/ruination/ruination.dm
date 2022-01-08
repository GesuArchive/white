#define HEIGHT_OPTIMAL 	480000
#define HEIGHT_DANGER 	350000
#define HEIGHT_CRITICAL 200000
#define HEIGHT_DEADEND 	100000
#define HEIGHT_CRASH 	0

GLOBAL_LIST_EMPTY(pulse_engines)
GLOBAL_VAR_INIT(station_orbit_height, HEIGHT_OPTIMAL)
GLOBAL_VAR_INIT(station_orbit_parallax_resize, 1)

/datum/game_mode/ruination
	name = "ruination"
	config_tag = "ruination"
	report_type = "ruination"
	false_report_weight = 1
	required_players = 30
	required_enemies = 4
	recommended_enemies = 4
	reroll_friendly = 1
	enemy_minimum_age = 0

	restricted_jobs = list("Cyborg", "AI")
	protected_jobs = list("Prisoner", "Russian Officer", "Trader", "Hacker","Veteran", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Field Medic")

	announce_span = "danger"
	announce_text = "Синдикат решил уронить станцию прямиком на ПЛАНЕТУ!"

	var/list/datum/mind/ruiners = list()

	var/datum/team/ruiners/ruiners_team

	traitor_name = "Террорист Синдиката"

	var/win_time = 15 MINUTES
	var/result = 0
	var/started_at = 0
	var/finale = FALSE

/datum/game_mode/ruination/pre_setup()
	for(var/j = 0, j < max(1, min(num_players(), 4)), j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/traitor = antag_pick(antag_candidates)
		ruiners += traitor
		traitor.special_role = traitor_name
		traitor.restricted_roles = restricted_jobs
		log_game("[key_name(traitor)] has been selected as a [traitor_name]")
		antag_candidates.Remove(traitor)

	var/enough_tators = 4 || ruiners.len > 0

	if(!enough_tators)
		setup_error = "Требуется 4 кандидата"
		return FALSE
	else
		for(var/antag in ruiners)
			GLOB.pre_setup_antags += antag
		return TRUE

/datum/game_mode/ruination/post_setup()

	var/datum/mind/leader_mind = ruiners[1]
	var/datum/antagonist/traitor/ruiner/L = leader_mind.add_antag_datum(/datum/antagonist/traitor/ruiner)
	ruiners_team = L.ruiners_team

	for(var/i = 2 to ruiners.len)
		var/datum/mind/ruiner_mind = ruiners[i]
		ruiner_mind.add_antag_datum(/datum/antagonist/traitor/ruiner)
		GLOB.pre_setup_antags -= ruiners[i]

	..()

	gamemode_ready = FALSE
	addtimer(VARSET_CALLBACK(src, gamemode_ready, TRUE), 101)
	return TRUE

/datum/game_mode/ruination/process()
	if(!started_at && GLOB.pulse_engines.len)
		for(var/obj/structure/pulse_engine/PE in GLOB.pulse_engines)
			if(PE.engine_active)
				started_at = world.time
				sound_to_playing_players('white/valtos/sounds/rp0.ogg', 15, FALSE, channel = CHANNEL_RUINATION_OST)
				priority_announce("На вашей станции был обнаружен запуск одного или нескольких импульсных двигателей. Вам необходимо найти и постараться помешать их работе любым доступным способом. Как сообщают наши инженеры: \"Хоть эта хуёвина и крепкая, однако, внутри этой поеботины блевотина равно болтается, что создаёт тяговую силу данного агрегата\". Вероятнее всего это дело рук агентов Синдиката, постарайтесь продержаться 15 минут до прилёта гравитационного тягача.", null, 'sound/misc/announce_dig.ogg', "Priority")
				for(var/m in GLOB.player_list)
					if(ismob(m) && !isnewplayer(m))
						var/mob/M = m
						if(M.hud_used)
							var/datum/hud/H = M.hud_used
							var/atom/movable/screen/station_height/sh = new /atom/movable/screen/station_height()
							var/atom/movable/screen/station_height_bg/shbg = new /atom/movable/screen/station_height_bg()
							H.station_height = sh
							H.station_height_bg = shbg
							sh.hud = H
							shbg.hud = H
							H.infodisplay += sh
							H.infodisplay += shbg
							H.mymob.client.screen += sh
							H.mymob.client.screen += shbg
				break
	if(started_at)
		if((started_at + (win_time - 3 MINUTES)) < world.time && !finale)
			finale = TRUE
			sound_to_playing_players('white/valtos/sounds/rf.ogg', 55, FALSE, channel = CHANNEL_RUINATION_OST)
			priority_announce("Осталось 3 минуты до прибытия тягача.", null, 'sound/misc/announce_dig.ogg', "Priority")
		var/total_speed = 0
		for(var/obj/structure/pulse_engine/PE in GLOB.pulse_engines)
			total_speed += PE.engine_power * 5
		GLOB.station_orbit_height -= total_speed
		for(var/i in GLOB.player_list)
			var/mob/M = i
			if(!M.hud_used?.station_height)
				continue
			var/datum/hud/H = M.hud_used
			H.station_height.update_height()

	var/cur_height = GLOB.station_orbit_parallax_resize

	switch(GLOB.station_orbit_height)
		if(HEIGHT_OPTIMAL to INFINITY)
			GLOB.station_orbit_parallax_resize = 0
		if(HEIGHT_DANGER to HEIGHT_OPTIMAL)
			GLOB.station_orbit_parallax_resize = 2
		if(HEIGHT_CRITICAL to HEIGHT_DANGER)
			GLOB.station_orbit_parallax_resize = 3
		if(HEIGHT_DEADEND to HEIGHT_CRITICAL)
			GLOB.station_orbit_parallax_resize = 4
		if(HEIGHT_CRASH to HEIGHT_DEADEND)
			GLOB.station_orbit_parallax_resize = 5

	if(cur_height != GLOB.station_orbit_parallax_resize)
		for(var/m in GLOB.player_list)
			if(ismob(m) && !isnewplayer(m))
				var/mob/M = m
				if(M.hud_used)
					M?.hud_used?.update_parallax_pref(M, GLOB.station_orbit_parallax_resize)

/datum/game_mode/ruination/check_finished()
	if(!started_at)
		return ..()
	if(GLOB.station_orbit_height < HEIGHT_CRASH)
		if(SSticker && SSticker.mode && SSticker.mode.station_was_nuked)
			SSticker.mode.station_was_nuked = TRUE
		result = 1
		Cinematic(CINEMATIC_NUKE_WIN, world, CALLBACK(SSticker, /datum/controller/subsystem/ticker/proc/station_explosion_detonation, src))
	else if ((started_at + win_time) < world.time)
		result = 2
	if(result)
		return TRUE
	else
		return ..()

/datum/game_mode/ruination/special_report()
	if(result == 1)
		return "<div class='panel redborder'><span class='redtext big'>СТАНЦИЯ БЫЛА СБРОШЕНА НА ПЛАНЕТУ! ВЫЖИВШИХ ОБНАРУЖЕНО НЕ БЫЛО...</span></div>"
	else if(result == 2)
		return "<div class='panel redborder'><span class='redtext big'>Экипаж станции смог продержаться до прибытия гравитационного тягача!</span></div>"

/datum/game_mode/ruination/set_round_result()
	..()
	if(result == 1)
		SSticker.mode_result = "станция уничтожена"
	else if(result == 2)
		SSticker.mode_result = "станция стабилизирована"

/datum/game_mode/ruination/generate_report()
	return "Синдикат недавно выкрал несколько импульсных двигателей, которые предназначены для выведения объектов с орбит. \
	Система защиты данных устройств невероятно крутая, что можно говорить и об их удивительно высокой цене производства! \
	Обязательно сообщите нам, если случайно найдёте парочку таких."

/atom/movable/screen/station_height
	icon = 'white/valtos/icons/line.png'
	screen_loc = "SOUTH:420, EAST-3:48"
	maptext_y = -4
	maptext_width = 96
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/station_height/Initialize()
	. = ..()
	flicker_animation()
	overlays += icon('white/valtos/icons/station.png')
	maptext = "<span style='color: #A35D5B; font-size: 8px;'>[GLOB.station_orbit_height]M</span>"

/atom/movable/screen/station_height/proc/update_height()
	screen_loc = "SOUTH:[min(round((GLOB.station_orbit_height * 0.001), 1) + 20, 440)], EAST-3:48"
	maptext = "<span style='color: #A35D5B; font-size: 8px;'>[GLOB.station_orbit_height]M</span>"

/atom/movable/screen/station_height_bg
	icon = 'white/valtos/icons/graph.png'
	screen_loc = ui_station_height
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/proc/flicker_animation(anim_len = 50)
	var/haste = 0.1
	alpha = 0
	animate(src, alpha = 0, time = 1, easing = JUMP_EASING)
	for(var/i in 1 to anim_len)
		animate(alpha = 255, time = 1 - haste, easing = JUMP_EASING)
		animate(alpha = 0,   time = 1 - haste, easing = JUMP_EASING)
		haste += 0.1
		if(prob(25))
			haste -= 0.2
	animate(alpha = 255, time = 1, easing = JUMP_EASING)

/datum/team/ruiners
	name = "Террористы Синдиката"

/datum/antagonist/traitor/ruiner
	name = "Смертник Синдиката"
	give_objectives = FALSE
	greentext_reward = 150
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	job_rank = ROLE_OPERATIVE
	var/datum/team/ruiners/ruiners_team

/datum/antagonist/traitor/ruiner/get_team()
	return ruiners_team

/datum/antagonist/traitor/ruiner/on_gain()
	. = ..()
	var/datum/objective/ruiner/ruiner_objective = new
	ruiner_objective.owner = owner
	add_objective(ruiner_objective)
	owner.announce_objectives()

	var/mob/living/carbon/H = owner.current
	if(!istype(H))
		return

	to_chat(H, span_userdanger("ДАВАЙ! ДАВАЙ! ДАВАЙ!"))

	H.hallucination = 500

	var/list/slots = list(
		"сумку" = ITEM_SLOT_BACKPACK,
		"левый карман" = ITEM_SLOT_LPOCKET,
		"правый карман" = ITEM_SLOT_RPOCKET
	)

	var/T = new /obj/item/sbeacondrop/pulse_engine(H)
	var/where = H.equip_in_one_of_slots(T, slots)
	if(!where)
		return
	else
		to_chat(H, span_danger("Мне подкинули маяк в [where]."))
		if(where == "сумку")
			SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)


#undef HEIGHT_OPTIMAL
#undef HEIGHT_DANGER
#undef HEIGHT_CRITICAL
#undef HEIGHT_DEADEND
#undef HEIGHT_CRASH
