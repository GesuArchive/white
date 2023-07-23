/datum/round_event_control/anomaly/anomaly_dimensional
	name = "Аномалия: Пространственная"
	typepath = /datum/round_event/anomaly/anomaly_dimensional

	min_players = 10
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_dimensional
	startWhen = 10
	announceWhen = 3
	anomaly_path = /obj/effect/anomaly/dimensional

/datum/round_event/anomaly/anomaly_dimensional/announce(fake)
	priority_announce("Обнаружена пространственная нестабильность, на сканерах дальнего действия. Предполагаемое местоположение: [impact_area.name].", "Аномальная тревога")
