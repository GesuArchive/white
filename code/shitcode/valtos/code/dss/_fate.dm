/mob/living/carbon/human
	var/list/current_fate = list(MOB_STR = 0, MOB_STM = 0, MOB_INT = 0, MOB_DEX = 0)
	var/list/base_fate    = list(MOB_STR = 0, MOB_STM = 0, MOB_INT = 0, MOB_DEX = 0)
	var/fate_luck = 1

/mob/living/carbon/human/proc/StatsInit()
	// аугментируем статы согласно ролям
	spawn(50)
		if(mind)
			switch(mind.assigned_role)
				if("Captain", "Head of Security", "Head of Personnel", "Chief Medical Officer", "Chief Engineer", "Research Director", "Kazakhstan Officer", "Warden", "Detective", "Russian Officer", "International Officer")
					fate_luck = 4

				if("Quartermaster", "Shaft Miner", "Curator", "Chaplain", "Medical Doctor", "Station Engineer", "Atmospheric Technician", "Scientist", "Paramedic")
					fate_luck = 3

				if("Lawyer", "Cargo Technician", "Clown", "Mime", "Janitor", "Cook", "Botanist", "Bartender", "Chemist", "Virologist", "Geneticist", "Roboticist", "Trader")
					fate_luck = 2

				if("Assistant", "Prisoner")
					fate_luck = 1

			// если антаг, то
			if(mind.special_role)
				fate_luck += 1

		if(prob(50)) // если просто повезло
			fate_luck += 1

		current_fate[MOB_STR] = roll_stat_dice(fate_luck)
		current_fate[MOB_STM] = roll_stat_dice(fate_luck)
		current_fate[MOB_INT] = roll_stat_dice(fate_luck)
		current_fate[MOB_DEX] = roll_stat_dice(fate_luck)

		base_fate[MOB_STR]    = current_fate[MOB_STR]
		base_fate[MOB_STM]    = current_fate[MOB_STM]
		base_fate[MOB_INT]    = current_fate[MOB_INT]
		base_fate[MOB_DEX]    = current_fate[MOB_DEX]

		recalculate_stats()

/mob/living/carbon/human/proc/recalculate_stats()
	// калькулируем модификаторы
	if(!dna || !dna.species)
		return

/mob/living/carbon/human/proc/get_stats()
	return list(MOB_STR = current_fate[MOB_STR], MOB_STM = current_fate[MOB_STM], MOB_INT = current_fate[MOB_INT], MOB_DEX = current_fate[MOB_DEX])

/mob/living/carbon/human/proc/set_stats(str = current_fate[MOB_STR], stm = current_fate[MOB_STM], int = current_fate[MOB_INT], dex = current_fate[MOB_DEX])
	current_fate[MOB_STR] = str
	current_fate[MOB_STM] = stm
	current_fate[MOB_INT] = int
	current_fate[MOB_DEX] = dex

	recalculate_stats()

	return

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("ИГРА"))
		stat(null, null)
		stat("Сила:",			fateize_stat(current_fate[MOB_STR]))
		stat("Выносливость:",   fateize_stat(current_fate[MOB_STM]))
		stat("Интеллект:",      fateize_stat(current_fate[MOB_INT]))
		stat("Ловкость:",       fateize_stat(current_fate[MOB_DEX]))
		stat("Метакэш:",      	client.mc_cached)

/proc/fateize_stat(stat)
	switch(stat)
		if(-4)
			return "<<<<"
		if(-3)
			return "<<<"
		if(-2)
			return "<<"
		if(-1)
			return "<"
		if(0)
			return "~"
		if(1)
			return ">"
		if(2)
			return ">>"
		if(3)
			return ">>>"
		if(4)
			return ">>>>"


/proc/roll_stat_dice(luck)
	var/bb = 0
	if(luck < -4)
		luck = 1
	switch(roll(luck, 20))
		if(1)
			bb = -4
		if(2 to 3)
			bb = -3
		if(4 to 9)
			bb = -2
		if(10 to 15)
			bb = -1
		if(16 to 25)
			bb = 0
		if(26 to 30)
			bb = 1
		if(31 to 47)
			bb = 2
		if(48 to 65)
			bb = 3
		if(66 to INFINITY)
			bb = 4
	return bb
