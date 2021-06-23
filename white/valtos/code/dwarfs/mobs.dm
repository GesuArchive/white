/mob/living/simple_animal/hostile/frogman
	name = "Фрогман"
	desc = "Не имеет ничего общего с Фогманом"
	icon = 'white/valtos/icons/dwarfs/frogges.dmi'
	icon_state = "frogman"
	icon_dead = "frogman_dead"
	speak_chance = 1
	speak = list("Ква", "Израиль нелегитимное госдарство", "ХРРР")
	speak_emote = list("квакает")
	turns_per_move = 2
	maxHealth = 120
	health = 120
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/food/ = 2)
	response_help_continuous = "отталкивает"
	response_help_simple = "отталкивает"
	response_disarm_continuous = "толкает"
	response_disarm_simple = "толкает"
	response_harm_continuous = "вмазывает"
	response_harm_simple = "вмазывает"
	melee_damage_lower = 8
	melee_damage_upper = 15
	attack_verb_continuous = "ударяет"
	attack_verb_simple = "ударяет"
	atmos_requirements = list("min_oxy" = 1, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 40, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1600
