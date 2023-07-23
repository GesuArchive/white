/datum/round_event_control/anomaly
	name = "Аномалия: Energetic Flux"
	typepath = /datum/round_event/anomaly

	min_players = 1
	max_occurrences = 0 //This one probably shouldn't occur! It'd work, but it wouldn't be very fun.
	weight = 15

/datum/round_event/anomaly
	var/area/impact_area
	var/datum/anomaly_placer/placer = new()
	var/obj/effect/anomaly/anomaly_path = /obj/effect/anomaly/flux
	announceWhen	= 1

/datum/round_event/anomaly/setup()
	impact_area = placer.findValidArea()

/datum/round_event/anomaly/announce(fake)
	priority_announce("Обнаружена волна энергетических потоков на сканерах большой дальности. Ожидаемое место столкновения: [impact_area.name].", "Аномальная тревога")

/datum/round_event/anomaly/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	var/newAnomaly
	if(T)
		newAnomaly = new anomaly_path(T)
	if (newAnomaly)
		announce_to_ghosts(newAnomaly)
