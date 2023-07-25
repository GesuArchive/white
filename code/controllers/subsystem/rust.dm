
SUBSYSTEM_DEF(rust_mode)
	name = "Rust"

	flags = SS_NO_INIT
	can_fire = FALSE
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 1 SECONDS
	var/active = FALSE
	var/list/resource_rocks = list()
	var/list/hostile_mobs = list()
	var/max_hostile_mobs = 64
	var/area/main_area
	// Переменная для времени. Для цикла времени
	var/current_time = "рассвет"
	var/list/possible_hostile_mobs = list(
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/giant_spider,
		/mob/living/simple_animal/hostile/asteroid/wolf,
		/mob/living/simple_animal/hostile/jungle/mook,
		/mob/living/simple_animal/hostile/pig
	)

/datum/controller/subsystem/rust_mode/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rust_mode/proc/seed_initial_resources()
	// 260100 турфов для 510x510
	// 65025 турфов для 255x255
	var/seed_count = 0
	for(var/turf/T in main_area)
		if(seed_count % pick(100, 150) == 0 && prob(66) && isopenturf(T))
			var/random_type = pick(subtypesof(/obj/structure/flora/resource_rock) - list(/obj/structure/flora/resource_rock/random))
			var/obj/structure/flora/resource_rock/RR = new random_type(T)
			RR.resource_amount = rand(6, 10)
			resource_rocks += RR
		seed_count++

/datum/controller/subsystem/rust_mode/proc/handle_hostile_mobs()
	if(LAZYLEN(hostile_mobs) >= max_hostile_mobs)
		return

	for(var/iteration in 1 to max_hostile_mobs - LAZYLEN(hostile_mobs))
		var/turf/T = pick(get_area_turfs(main_area))
		if(T && isopenturf(T))
			var/random_mob_type = pick(possible_hostile_mobs)
			var/mob/M = new random_mob_type(T)
			hostile_mobs += M

/datum/controller/subsystem/rust_mode/fire(resumed = FALSE)
	// удаляем хотспоты
	for(var/obj/effect/hotspot/H in SSair.hotspots)
		qdel(H)

	adjust_areas_light()
	handle_hostile_mobs()
	return

/datum/controller/subsystem/rust_mode/proc/setup_everything()
	// ставим музыку
	SSticker.login_music = sound('sound/music/rusty.ogg')
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()
	// ставим картинку
	var/icon/great_title_icon = icon('icons/rusty.png')
	SStitle.autorotate = FALSE
	SStitle.icon = great_title_icon
	SEND_SIGNAL(SStitle, COMSIG_TITLE_UPDATE_BACKGROUND, FALSE)
	// создаём карту
	to_chat(world, span_boldnotice("Происходит генерация карты. Это займёт некоторое время."))
	load_rust_map()
	// выбираем зону
	main_area = GLOB.areas_by_type[/area/rust_zone]
	// запускаем генерацию
	main_area.RunGeneration()
	// фиксим свет
	main_area.luminosity = TRUE
	// заполняем камнями с ресурсами
	seed_initial_resources()
	// заполняем карту генераторными штуками
	SSmapping.seedStation()
	// отключаем ивенты станции
	GLOB.disable_fucking_station_shit_please = TRUE
	// отключаем лишние подсистемы
	SSair.flags |= SS_NO_FIRE
	SSevents.flags |= SS_NO_FIRE
	SSnightshift.flags |= SS_NO_FIRE
	SSorbits.flags |= SS_NO_FIRE
	SSeconomy.flags |= SS_NO_FIRE
	// чёрный ящик будет пуст
	SSblackbox.Seal()
	// отключаем все станционные джобки и создаём специальные
	GLOB.position_categories = list(
		EXP_TYPE_RUST_SURVIVOR = list("jobs" = GLOB.rust_survivor_position, "color" = "#22aa88", "runame" = "Выживший")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_RUST_SURVIVOR = list("titles" = GLOB.rust_survivor_position),
	)
	// удаляем все CTF из мира
	for(var/obj/machinery/capture_the_flag/CTF in GLOB.machines)
		qdel(CTF)
	// отменяем готовность и тут на всякий случай
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	// выключаем рандомные ивенты наверняка
	CONFIG_SET(flag/allow_random_events, FALSE)
	// удаляем все спаунеры из мира, дополнительно
	for(var/list/spawner in GLOB.mob_spawners)
		QDEL_LIST_ASSOC(spawner)
	// включаем перерождение
	CONFIG_SET(flag/norespawn, FALSE)

	SSjob.ResetOccupations("Rust")
	SSjob.SetJobPositions(/datum/job/rust_enjoyer, 999, 999, TRUE)


#define CYCLE_SUNRISE 	6    HOURS // рассвет
#define CYCLE_MORNING 	6.5  HOURS // утро
#define CYCLE_DAYTIME 	12   HOURS // день
#define CYCLE_AFTERNOON 17   HOURS // вечер
#define CYCLE_SUNSET 	21 	 HOURS // закат
#define CYCLE_NIGHTTIME 22.5 HOURS // ночь

/datum/controller/subsystem/rust_mode/proc/adjust_areas_light()
	var/new_time = station_time()
	var/new_color
	var/new_alpha

	switch(new_time)
		if(CYCLE_SUNRISE 	to CYCLE_MORNING   - 1)
			new_time  = "рассвет"
			new_color = "#ffd1b3"
			new_alpha = 55
		if (CYCLE_MORNING 	to CYCLE_DAYTIME   - 1)
			new_time = "утро"
			new_color = "#fff2e6"
			new_alpha = 125
		if (CYCLE_DAYTIME 	to CYCLE_AFTERNOON - 1)
			new_time = "день"
			new_color = "#FFFFFF"
			new_alpha = 225
		if (CYCLE_AFTERNOON to CYCLE_SUNSET    - 1)
			new_time = "вечер"
			new_color = "#fff2e6"
			new_alpha = 150
		if (CYCLE_SUNSET 	to CYCLE_NIGHTTIME - 1)
			new_time = "закат"
			new_color = "#ffcccc"
			new_alpha = 90
		else
			new_time = "ночь"
			new_color = "#00111a"
			new_alpha = 3

	if(new_time != current_time)
		if(prob(25))
			SSweather.run_weather(/datum/weather/just_rain)
		current_time = new_time
		if(main_area)
			main_area.set_base_lighting(new_color, new_alpha)
		to_chat(world, span_greenannounce("<b>[station_time_timestamp()]</b> - [new_time]."))

#undef CYCLE_SUNRISE
#undef CYCLE_MORNING
#undef CYCLE_DAYTIME
#undef CYCLE_AFTERNOON
#undef CYCLE_SUNSET
#undef CYCLE_NIGHTTIME
