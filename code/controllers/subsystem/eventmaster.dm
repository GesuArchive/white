#define EVENT_TYPE_NONE 0
#define EVENT_TYPE_OPENWORLD 1
#define EVENT_TYPE_SPAWN_EVERYONE 2
#define EVENT_READJUST_TO_WARFARE 3
#define EVENT_TYPE_NATIONS 4
#define EVENT_SPAWN_EVERYONE 5

GLOBAL_VAR_INIT(disable_fucking_station_shit_please, FALSE)

SUBSYSTEM_DEF(eventmaster)
	name = "Eventmaster"
	wait = 5 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_EVENTMASTER
	// По дефолту ничего
	var/target_event = EVENT_TYPE_NONE

	// Ведро заданий с таймингами
	var/list/tasks_bucket = list()
	// Активные господа
	var/list/luckers = list()
	// Проигравшие господа
	var/list/suckers = list()
	// Антажные господа
	var/list/fuckers = list()
	// Основная зона, где происходит весь замес. На данный момент это открытое пространство
	var/area/action_area = null
	// Вторичная зона. Вероятнее всего зона помещений
	var/area/second_area = null
	// Вероятные абстрактные объекты освещения. Мб
	var/list/light_abstract_objects = list()
	// Переменная для времени. Для цикла времени
	var/current_time = "рассвет"

/datum/controller/subsystem/eventmaster/stat_entry(msg)
	msg += "| Ж: [luckers.len] | И: [suckers.len] | З: [fuckers.len]"
	return ..()

/datum/controller/subsystem/eventmaster/proc/execute_ignition_rules()
	switch(target_event)
		if(EVENT_TYPE_OPENWORLD)
			to_chat(world, span_heavy_brass("Активация правил режима OpenWorld..."))
			GLOB.disable_fucking_station_shit_please = TRUE
			SSair.flags |= SS_NO_FIRE
			SSevents.flags |= SS_NO_FIRE
			SSnightshift.flags |= SS_NO_FIRE
			SSorbits.flags |= SS_NO_FIRE
			SSweather.flags |= SS_NO_FIRE
			SSeconomy.flags |= SS_NO_FIRE
			SSeconomy.flags |= SS_NO_FIRE
			SSjob.DisableJobsButThis(/datum/job/assistant)
			to_chat(world, span_heavy_brass("Остановка лишних контроллеров успешна!"))
			action_area = GLOB.areas_by_type[/area/partyhard/outdoors]
			second_area = GLOB.areas_by_type[/area/partyhard/indoors]
			action_area?.luminosity = 1
			second_area?.luminosity = 1
			//adjust_areas_light()
			to_chat(world, span_heavy_brass("Свет готов!"))
			to_chat(world, span_heavy_brass("Готово!"))
			return TRUE
		if(EVENT_TYPE_SPAWN_EVERYONE)
			to_chat(world, span_heavy_brass("Активация правил режима перемещения всех в игру..."))
			if(SSticker.current_state == GAME_STATE_PREGAME)
				for(var/mob/dead/new_player/player in GLOB.player_list)
					to_chat(player, "<span class=greenannounce>Ты призрак. Скоро предоставят возможность вступить в схватку за одну из сторон.</span>")
					player.ready = FALSE
					player.make_me_an_observer(TRUE)
				SSticker.start_immediately = TRUE
			to_chat(world, span_heavy_brass("Готово!"))
			target_event = EVENT_TYPE_OPENWORLD
			return TRUE
		if(EVENT_READJUST_TO_WARFARE)
			to_chat(world, span_heavy_brass("Отключение всех ролей..."))
			SSjob.DisableAllJobs()
			to_chat(world, span_heavy_brass("Перестройка под боевые действия..."))
			action_area = GLOB.areas_by_type[/area/ctf/warfare]
			second_area = GLOB.areas_by_type[/area/ctf/warfare/indoors]
			action_area?.luminosity = 1
			second_area?.luminosity = 1
			//adjust_areas_light()
			to_chat(world, span_heavy_brass("Готово!"))
			target_event = EVENT_TYPE_OPENWORLD
			return TRUE
		if(EVENT_TYPE_NATIONS)
			to_chat(world, span_heavy_brass("Активация режима Nations v9.851..."))
			for(var/i in GLOB.start_landmarks_list)
				var/obj/effect/landmark/start/S = i
				if(istype(S))
					S.delete_after_roundstart = FALSE
			to_chat(world, span_heavy_brass("Готово!"))
			return TRUE
		if(EVENT_SPAWN_EVERYONE)
			var/name_of_pitlord = tgui_input_text(usr, "Имя", "КАК")
			var/posttransformoutfit = usr.client.robust_dress_shop()
			if(!name_of_pitlord)
				name_of_pitlord = "Боец"
			if(!posttransformoutfit)
				return FALSE
			to_chat(world, span_heavy_brass("Перемещение всех призраков в одну точку..."))
			var/num_spawned = 0
			for(var/mob/dead/observer/O in GLOB.player_list)
				num_spawned++
				var/mob/living/carbon/human/newmob = O.change_mob_type(/mob/living/carbon/human, get_turf(usr), "[name_of_pitlord] #[num_spawned]", TRUE)
				if(posttransformoutfit && istype(newmob))
					newmob.equipOutfit(posttransformoutfit)
			to_chat(world, span_heavy_brass("Создано [num_spawned] тел..."))
			to_chat(world, span_heavy_brass("Готово!"))
			return TRUE
		else
			return FALSE

/datum/controller/subsystem/eventmaster/fire(resumed)
	switch(target_event)
		if(EVENT_TYPE_OPENWORLD)
			//adjust_areas_light()
			calc_alive_and_zombies()
		else
			return

/datum/controller/subsystem/eventmaster/proc/calc_alive_and_zombies()
	luckers.Cut()
	suckers.Cut()
	fuckers.Cut()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(iszombie(H))
			fuckers += H
			continue
		if(H.getorganslot(ORGAN_SLOT_ZOMBIE))
			suckers += H
			continue
		else
			luckers += H
			continue

#define CYCLE_SUNRISE 	6    HOURS // рассвет
#define CYCLE_MORNING 	6.5  HOURS // утро
#define CYCLE_DAYTIME 	12   HOURS // день
#define CYCLE_AFTERNOON 17   HOURS // вечер
#define CYCLE_SUNSET 	21 	 HOURS // закат
#define CYCLE_NIGHTTIME 22.5 HOURS // ночь

/datum/controller/subsystem/eventmaster/proc/adjust_areas_light()
	var/new_time = station_time()
	var/new_color
	var/new_alpha
	var/new_temp

	switch(new_time)
		if(CYCLE_SUNRISE 	to CYCLE_MORNING   - 1)
			new_time  = "рассвет"
			new_color = "#ffd1b3"
			new_alpha = 55
			new_temp = -2
		if (CYCLE_MORNING 	to CYCLE_DAYTIME   - 1)
			new_time = "утро"
			new_color = "#fff2e6"
			new_alpha = 125
			new_temp = 10
		if (CYCLE_DAYTIME 	to CYCLE_AFTERNOON - 1)
			new_time = "день"
			new_color = "#FFFFFF"
			new_alpha = 225
			new_temp = 15
		if (CYCLE_AFTERNOON to CYCLE_SUNSET    - 1)
			new_time = "вечер"
			new_color = "#fff2e6"
			new_alpha = 150
			new_temp = 10
		if (CYCLE_SUNSET 	to CYCLE_NIGHTTIME - 1)
			new_time = "закат"
			new_color = "#ffcccc"
			new_alpha = 90
			new_temp = -5
		else
			new_time = "ночь"
			new_color = "#00111a"
			new_alpha = 3
			new_temp = -5

	if(new_time != current_time)
		if(prob(25))
			SSweather.run_weather(/datum/weather/just_rain)
		current_time = new_time
		if(action_area)
			action_area.set_base_lighting(new_color, new_alpha)
			action_area.env_temp_relative = new_temp
		if(second_area)
			second_area.set_base_lighting(new_color, second_area.base_lighting_alpha)
		to_chat(world, span_greenannounce("<b>[station_time_timestamp()]</b> - [new_time]."))

/client/proc/force_evenmaster_rules()
	set name = "? Force Eventmaster Rules"
	set category = "Дбг"

	if(!holder || !check_rights(R_DEBUG))
		return

	var/list/possible_options = list("OPENWORLD EVENT", "GHOSTIZE EVERYONE", "SET WARFARE", "NATIONS EVENT", "SPAWN EVERYONE HERE", "NONE")

	var/what_the_fuck = tgui_input_list(usr, "SHIT YES?", "Cum", possible_options)

	switch(what_the_fuck)
		if("OPENWORLD EVENT")
			SSeventmaster.target_event = EVENT_TYPE_OPENWORLD
		if("GHOSTIZE EVERYONE")
			SSeventmaster.target_event = EVENT_TYPE_SPAWN_EVERYONE
		if("SET WARFARE")
			SSeventmaster.target_event = EVENT_READJUST_TO_WARFARE
		if("NATIONS EVENT")
			SSeventmaster.target_event = EVENT_TYPE_NATIONS
		if("SPAWN EVERYONE HERE")
			SSeventmaster.target_event = EVENT_SPAWN_EVERYONE
		else
			SSeventmaster.target_event = EVENT_TYPE_NONE

	SSeventmaster.execute_ignition_rules()

#undef CYCLE_SUNRISE
#undef CYCLE_MORNING
#undef CYCLE_DAYTIME
#undef CYCLE_AFTERNOON
#undef CYCLE_SUNSET
#undef CYCLE_NIGHTTIME

#undef EVENT_TYPE_NONE
#undef EVENT_TYPE_OPENWORLD
#undef EVENT_TYPE_SPAWN_EVERYONE
#undef EVENT_READJUST_TO_WARFARE
#undef EVENT_TYPE_NATIONS
#undef EVENT_SPAWN_EVERYONE
