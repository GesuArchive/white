#define EVENT_TYPE_NONE 0
#define EVENT_TYPE_ZOMBIE 1

SUBSYSTEM_DEF(eventmaster)
	name = "! Ивентовод"
	wait = 1 MINUTES
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
	// Основная зона, где происходит весь замес. На данный момент это открытое пространство
	var/area/action_area = null
	// Вторичная зона. Вероятнее всего зона помещений
	var/area/second_area = null
	// Вероятные абстрактные объекты освещения. Мб
	var/list/light_abstract_objects = list()
	// Переменная для времени. Для цикла времени
	var/current_time = "рассвет"

/datum/controller/subsystem/eventmaster/stat_entry(msg)
	msg += "Живые: [luckers.len] | Зомби: [suckers.len]"
	return ..()

/datum/controller/subsystem/eventmaster/proc/execute_ignition_rules()
	switch(target_event)
		if(EVENT_TYPE_ZOMBIE)
			message_admins("Активация правил режима Zombie Event...")
			SSair.pause()
			SSevents.pause()
			SSnightshift.pause()
			SSorbits.pause()
			SSweather.pause()
			SSeconomy.pause()
			SSjob.DisableJobsButThis(/datum/job/assistant)
			message_admins("Остановка лишних контроллеров успешна!")
			action_area = GLOB.areas_by_type[/area/partyhard/outdoors]
			second_area = GLOB.areas_by_type[/area/partyhard/indoors]
			action_area.set_dynamic_lighting(DYNAMIC_LIGHTING_FORCED)
			message_admins("Свет готов!")
			message_admins("Готово!")
			return TRUE
		else
			return FALSE

/datum/controller/subsystem/eventmaster/fire(resumed)
	switch(target_event)
		if(EVENT_TYPE_ZOMBIE)
			adjust_areas_light()
		else
			return

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
		current_time = new_time
		action_area.cut_overlay(action_area.lighting_overlay)
		//action_area.lighting_overlay = new /obj/effect/fullbright
		action_area.lighting_overlay_colour = new_color
		action_area.lighting_overlay_opacity = new_alpha
		action_area.add_overlay(action_area.lighting_overlay)
		to_chat(world, "<span class='greenannounce'><b>[station_time_timestamp("hh:mm")]</b> - [new_time].</span>")

/client/proc/force_evenmaster_rules()
	set name = "? Force Eventmaster Rules"
	set category = "Дбг"

	if(!holder || !check_rights(R_DEBUG))
		return

	var/list/possible_options = list("ZOMBIES EVENT", "NONE")

	var/what_the_fuck = input("SHIT YES?", "Cum") as null|anything in possible_options

	switch(what_the_fuck)
		if("ZOMBIES EVENT")
			SSeventmaster.target_event = EVENT_TYPE_ZOMBIE
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
#undef EVENT_TYPE_ZOMBIE
