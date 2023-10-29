/datum/round_event_control/radiation_storm
	name = "Событие: Рад-шторм"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	startWhen = 3
	endWhen = startWhen + 1
	announceWhen	= 1

/datum/round_event/radiation_storm/announce(fake)
	priority_announce("Вблизи станции обнаружены высокие уровни радиации. Технические тоннели лучше всего защищены от излучения.", "Аномальная тревога", ANNOUNCER_RADIATION)
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather(/datum/weather/rad_storm)
