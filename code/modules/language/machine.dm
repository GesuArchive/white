/datum/language/machine
	name = "Закодированный язык аудио"
	desc = "Эффективный язык кодированных тонов, разработанный синтетиками и киборгами."
	spans = list(SPAN_ROBOT)
	key = "6"
	flags = NO_STUTTER
	syllables = list("бип","бип","бип","бип","бип","буп","буп","буп","боп","боп","ди","ди","ду","ду","хисс","хсс","бзз","бзз","бзз","кссш","кееы","вурр","вахх","тззз")
	space_chance = 10
	default_priority = 90

	icon_state = "eal"

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return pick(GLOB.ai_names)
