/mob/living/simple_animal/hostile/troll
	name = "тролль"
	desc = "Милый."
	icon = 'white/valtos/icons/troll.dmi'
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 2
	maxHealth = 500
	health = 500
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/food/meat/slab = 3, /obj/item/raw_stone = 30)
	response_help_continuous = "отталкивает"
	response_help_simple = "отталкивает"
	response_disarm_continuous = "толкает"
	response_disarm_simple = "толкает"
	response_harm_continuous = "вмазывает"
	response_harm_simple = "вмазывает"
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_verb_continuous = "разъёбывает"
	attack_verb_simple = "разъёбывает"
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 10, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1600
	gold_core_spawnable = HOSTILE_SPAWN
	var/rockfalling_last = 0

/mob/living/simple_animal/hostile/troll/Life()
	. = ..()
	if(target && rockfalling_last < world.time && prob(50))
		rockfalling_last = world.time + 60 SECONDS
		for(var/turf/open/T in view(7, src))
			if(prob(15))
				new /obj/effect/temp_visual/rockfall(T)
				spawn(rand(30, 60))
					for(var/mob/living/L in T.contents)
						L.apply_damage_type(20, BRUTE)
						L.Paralyze(100)
						to_chat(L, "<span class='userdanger'>ГРУДА КАМНЕЙ ПАДАЕТ С ПОТОЛКА ПРЯМО НА МЕНЯ!</span>")
					T.ChangeTurf(/turf/closed/mineral/random/dwarf_lustress)

/obj/effect/temp_visual/rockfall
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 9

/obj/effect/temp_visual/rockfall/ex_act()
	return

/obj/effect/temp_visual/rockfall/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, .proc/fall)

/obj/effect/temp_visual/rockfall/proc/fall()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
