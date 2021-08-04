/mob/living/simple_animal/hostile/frogman
	name = "Фрогман"
	desc = "Не имеет ничего общего с Фогманом"
	icon = 'white/rashcat/icons/dwarfs/mobs/frogges.dmi'
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
	butcher_results = list(/obj/item/food/meat/slab = 2)
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
/mob/living/simple_animal/hostile/mech_frog
	name = "Меха-лягуха"
	desc = "All systems nominal."
	icon = 'white/rashcat/icons/dwarfs/mobs/frogges.dmi'
	icon_state = "frog_mech"
	icon_dead = "mech_dead"
	speak_chance = 1
	speak = list("Ква", "Квас", "Квадракоптер")
	speak_emote = list("квакает")
	turns_per_move = 4
	maxHealth = 180
	health = 180
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/blacksmith/ingot = 1, /obj/item/food/meat/slab = 1)
	response_help_continuous = "подталкивает"
	response_help_simple = "подталкивает"
	response_disarm_continuous = "толкает"
	response_disarm_continuous = "толкает"
	response_harm_continuous = "таранит"
	response_harm_simple = "таранит"
	melee_damage_lower = 12
	melee_damage_upper = 18
	attack_verb_continuous = "врезается в"
	attack_verb_simple = "врезается в"
	atmos_requirements = list("min_oxy" = 1, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 40, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1600

/mob/living/simple_animal/hostile/froggernaut
	name = "Фроггернаут"
	desc = "Это конец"
	icon = 'white/rashcat/icons/dwarfs/mobs/46x46.dmi'
	icon_state = "froggernaut"
	speak_chance = 1
	speak = list("ПОКАЙТЕСЬ", "ЭТО КОНЕЦ")
	speak_emote = list("орет")
	speed = 2
	move_to_delay = 2
	del_on_death = TRUE
	loot = list(/obj/item/gem/cut/diamond = 5)
	maxHealth = 600
	health = 600
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	attack_verb_continuous = "уничтожает"
	attack_verb_simple = "уничтожает"
	melee_damage_lower = 28
	melee_damage_upper = 35
	armour_penetration = 40
