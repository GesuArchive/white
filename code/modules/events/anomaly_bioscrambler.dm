/datum/round_event_control/anomaly/anomaly_bioscrambler
	name = "Аномалия: Биоконверсионная"
	typepath = /datum/round_event/anomaly/anomaly_bioscrambler

	min_players = 10
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_bioscrambler
	startWhen = 10
	announceWhen = 3
	anomaly_path = /obj/effect/anomaly/bioscrambler

/datum/round_event/anomaly/anomaly_bioscrambler/announce(fake)
	priority_announce("Обнаружена биоконверсионная аномалия. Ожидаемое место появления: [impact_area.name]. Нахождение рядом без средств биозащиты крайне не рекомендовано. Прогнозируемый период полураспада %9£$T$%F3 лет", "Аномальная тревога")
