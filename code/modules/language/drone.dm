/datum/language/drone
	name = "Дроний"
	desc = "Сильно закодированный поток координации управления повреждениями со специальными флагами для шляп."
	spans = list(SPAN_ROBOT)
	key = "d"
	flags = NO_STUTTER
	syllables = list(".", "|")
	// ...|..||.||||.|.||.|.|.|||.|||
	space_chance = 0
	sentence_chance = 0
	default_priority = 20

	icon_state = "drone"
