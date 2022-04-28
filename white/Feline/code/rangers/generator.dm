// 	Мобы

// 	Ратвар

/mob/living/simple_animal/hostile/ratvar
	name = "Мехскарабей"
	desc = "Механическое устройство, наполненное движущимися шестерёнками и механическими частями, создано для Риби."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_clock"
	icon_living = "drone_clock"
	icon_dead = "drone_clock_dead"

	health = 30
	maxHealth = 30
	discovery_points = 2000

	obj_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10

	attack_verb_continuous = "бьет"
	attack_verb_simple = "бьет"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	faction = list("ratvar")
	deathsound = 'sound/magic/clockwork/anima_fragment_death.ogg'

	gold_core_spawnable = HOSTILE_SPAWN
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/ratvar/marauder
	name = "механический мародёр"
	desc = "Латунная машина разрушения."
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	icon_living = "clockwork_marauder"
	icon_dead = "anime_fragment"
	health = 140
	maxHealth = 140
	discovery_points = 3000

	obj_damage = 30
	melee_damage_lower = 25
	melee_damage_upper = 35

// 	Саморастущая паутина

/obj/structure/spider/stickyweb/expand

/obj/structure/spider/stickyweb/expand/Initialize()
	. = ..()
	for(var/T in circleviewturfs(src, 1))
		if(!isclosedturf(T))
			new /obj/structure/spider/stickyweb(T)

