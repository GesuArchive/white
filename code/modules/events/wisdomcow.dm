/datum/round_event_control/wisdomcow
	name = "Событие: Мудрая корова"
	typepath = /datum/round_event/wisdomcow
	max_occurrences = 1
	weight = 20

/datum/round_event/wisdomcow/announce(fake)
	priority_announce("В этом районе была замечена мудрая корова. Обязательно спросите у нее совета.", "Агентство NanoTrasen по разведению коров")

/datum/round_event/wisdomcow/start()
	var/turf/targetloc = get_random_station_turf()
	new /mob/living/simple_animal/cow/wisdom(targetloc)
	do_smoke(1, targetloc)

