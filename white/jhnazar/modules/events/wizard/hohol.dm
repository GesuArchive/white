/mob/living/simple_animal/hostile/carp/ranged/chaos/hohol
	name = "Хохлокарась"
	desc = "Винахід Правого Сіктора"

	icon = 'white/jhnazar/icons/hohol.dmi'
	icon_state = "hohol"
	icon_living = "hohol"
	icon_dead = "hohol_dead"

	maxHealth = 1488
	health = 1488

	random_color = FALSE
	projectilesound = list('white/valtos/sounds/pig/hru.ogg', 'white/valtos/sounds/pig/oink.ogg', 'white/valtos/sounds/pig/squeak.ogg')

	attacked_sound = 'white/valtos/sounds/pig/oink.ogg'
	deathsound = 'white/valtos/sounds/pig/death.ogg'

	speak = list("СЛАВА УКРАЇНІ!","ГЕРОЯМ СЛАВА!","МОСКАЛІ СОСАТИ", "МОСКАЛЯКУ НА ГІЛЯКУ", "ХРЮ", "Хочу сальця")

	butcher_results = list(/obj/item/food/meat/slab/pig = 10)

	mob_size = MOB_SIZE_HUGE
	mob_biotypes = MOB_ORGANIC|MOB_EPIC
