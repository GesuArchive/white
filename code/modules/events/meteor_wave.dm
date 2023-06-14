// Normal strength

/datum/round_event_control/meteor_wave
	name = "Метеоритная волна: Стандарт"
	typepath = /datum/round_event/meteor_wave
	weight = 25
	min_players = 20
	max_occurrences = 100
	earliest_start = 25 MINUTES

/datum/round_event/meteor_wave
	startWhen = 6
	endWhen = 66
	announceWhen = 1
	var/list/wave_type
	var/wave_name = "normal"
	var/start_x
	var/start_y
	var/datum/orbital_object/station_target
	var/meteor_time = 15 MINUTES

/datum/round_event/meteor_wave/New()
	..()
	if(!wave_type)
		determine_wave_type()
	start_x = sin(rand(0, 360)) * 9000
	start_y = cos(rand(0, 360)) * 9000
	station_target = SSorbits.station_instance
	if(!station_target)
		CRASH("Meteor failed to locate a target.")

/datum/round_event/meteor_wave/Destroy(force, ...)
	station_target = null
	. = ..()

/datum/round_event/meteor_wave/tick()
	if(ISMULTIPLE(activeFor, 3) && activeFor < 61 && station_target)
		var/datum/orbital_object/meteor/meteor = new()
		meteor.name = "Метеорит ([wave_name])"
		meteor.meteor_types = wave_type
		meteor.start_x = start_x + rand(-600, 600)
		meteor.start_y = start_y + rand(-600, 600)
		MOVE_ORBITAL_BODY(meteor, meteor.start_x, meteor.start_y)
		//Calculate velocity
		meteor.velocity.Set(((station_target.position.GetX() - meteor.start_x) * 10) / meteor_time, ((station_target.position.GetY() - meteor.start_y) * 10) / meteor_time)
		meteor.end_tick = world.time + meteor_time
		meteor.target = station_target

/datum/round_event/meteor_wave/on_admin_trigger()
	if(alert(usr, "Запускать метеориты прямо сейчас? (Это не изменит оповещение, просто отправит их быстрее! Риск лишения кнопок увеличен!)", "Запуск метеоритов", "Да", "Нет") == "Да")
		announceWhen = 1
		meteor_time = 1 MINUTES

/datum/round_event/meteor_wave/proc/determine_wave_type()
	if(!wave_name)
		wave_name = pick_weight(list(
			"normal" = 50,
			"threatening" = 40,
			"catastrophic" = 10))
	switch(wave_name)
		if("normal")
			wave_type = GLOB.meteors_normal
		if("threatening")
			wave_type = GLOB.meteors_threatening
		if("catastrophic")
			if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
				wave_type = GLOB.meteorsSPOOKY
			else
				wave_type = GLOB.meteors_catastrophic
		if("meaty")
			wave_type = GLOB.meteorsB
		if("space dust")
			wave_type = GLOB.meteorsC
		if("halloween")
			wave_type = GLOB.meteorsSPOOKY
		if("bluespace")
			wave_type = GLOB.meteors_bluespace
		else
			WARNING("Wave name of [wave_name] not recognised.")
			kill()

/datum/round_event/meteor_wave/announce(fake)
	priority_announce("Метеоры были обнаружены на пути столкновения со станцией.", "Метеоритная тревога", ANNOUNCER_METEORS)

/datum/round_event_control/meteor_wave/threatening
	name = "Метеоритная волна: Сильная"
	typepath = /datum/round_event/meteor_wave/threatening
	weight = 20
	min_players = 20
	max_occurrences = 60
	earliest_start = 35 MINUTES

/datum/round_event/meteor_wave/threatening
	wave_name = "threatening"

/datum/round_event_control/meteor_wave/catastrophic
	name = "Метеоритная волна: Катастрофическая"
	typepath = /datum/round_event/meteor_wave/catastrophic
	weight = 30
	min_players = 20
	max_occurrences = 60
	earliest_start = 45 MINUTES

/datum/round_event/meteor_wave/catastrophic
	wave_name = "catastrophic"

/datum/round_event_control/meteor_wave/bluespace
	name = "Метеоритная волна: Блюспейс"
	typepath = /datum/round_event/meteor_wave/bluespace
	weight = 20
	min_players = 20
	max_occurrences = 60
	earliest_start = 35 MINUTES

/datum/round_event/meteor_wave/bluespace
	wave_name = "bluespace"
