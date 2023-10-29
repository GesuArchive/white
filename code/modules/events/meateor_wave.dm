/datum/round_event_control/meteor_wave/meaty
	name = "Метеоритная волна: Мясные"
	typepath = /datum/round_event/meteor_wave/meaty
	weight = 2
	max_occurrences = 1

/datum/round_event/meteor_wave/meaty
	wave_name = "meaty"

/datum/round_event/meteor_wave/meaty/announce(fake)
	priority_announce("\"Митиоры\" были обнаружены на пути столкновения со станцией.", "Тащи швабру!", ANNOUNCER_METEORS)
