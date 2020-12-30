/datum/language/narsie
	name = "Нар'Сийский"
	desc = "Древний, пропитанный кровью, невероятно сложный язык культистов Нар'Си."
	key = "n"
	sentence_chance = 8
	space_chance = 95 //very high due to the potential length of each syllable
	var/static/list/base_syllables = list(
		"х", "в", "ц", "е", "г", "д", "р", "н", "х", "о", "п",
		"ра", "со", "ат", "ил", "та", "гх", "ш", "я", "те", "ш", "ол", "ма", "ом", "иг", "ни", "ин",
		"ша", "мир", "сас", "мах", "зар", "ток", "лыр", "нqа", "нап", "олт", "вал", "qха",
		"фве", "атх", "ыро", "етх", "гал", "гиб", "бар", "йин", "кла", "ату", "кал", "лиг",
		"ёка", "драк", "лосо", "арта", "веых", "инес", "тотх", "фара", "амар", "няг", "еске", "ретх", "дедо", "бтох", "никт", "нетх",
		"канас", "гарис", "улофт", "тарат", "хари", "тхнор", "рекка", "рагга", "рфикк", "харфр", "андид", "етхра", "дедол", "тотум",
		"нтратх", "кериам"
	) //the list of syllables we'll combine with itself to get a larger list of syllables
	syllables = list(
		"ша", "мир", "сас", "мах", "хра", "зар", "ток", "лыр", "нqа", "нап", "олт", "вал",
		"ям", "qха", "фел", "дет", "фве", "мах", "ерл", "атх", "ыро", "етх", "гал", "муд",
		"гиб", "бар", "теа", "фуу", "йин", "кла", "ату", "кал", "лиг",
		"ёка", "драк", "лосо", "арта", "веых", "инес", "тотх", "фара", "амар", "няг", "еске", "ретх", "дедо", "бтох", "никт", "нетх", "абис",
		"канас", "гарис", "улофт", "тарат", "хари", "тхнор", "рекка", "рагга", "рфикк", "харфр", "андид", "етхра", "дедол", "тотум",
		"вербот", "плеггх", "нтратх", "бархах", "паснар", "кериам", "усинар", "саврае", "амутан", "таннин", "ремиум", "барада",
		"форбици"
	) //the base syllables, which include a few rare ones that won't appear in the mixed syllables
	icon_state = "narsie"
	default_priority = 10

/datum/language/narsie/New()
	for(var/syllable in base_syllables) //we only do this once, since there's only ever a single one of each language datum.
		for(var/target_syllable in base_syllables)
			if(syllable != target_syllable) //don't combine with yourself
				if(length(syllable) + length(target_syllable) > 8) //if the resulting syllable would be very long, don't put anything between it
					syllables += "[syllable][target_syllable]"
				else if(prob(80)) //we'll be minutely different each round.
					syllables += "[syllable]'[target_syllable]"
				else if(prob(25)) //5% chance of - instead of '
					syllables += "[syllable]-[target_syllable]"
				else //15% chance of no ' or - at all
					syllables += "[syllable][target_syllable]"
	..()
