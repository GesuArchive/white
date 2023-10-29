/mob/living/simple_animal/hostile/carp/ranged/chaos/hohol
	name = "Хохлокарась"
	desc = "Винахід Правого Сіктора"

	color = null

	icon = 'white/baldenysh/icons/mob/karasik.dmi'
	icon_state = "karasik"
	icon_living = "karasik"
	icon_dead = "karasik"

	base_pixel_x = -16
	pixel_x = -16

	maxHealth = 100
	health = 100

	random_color = FALSE
	projectilesound = list('white/valtos/sounds/pig/hru.ogg', 'white/valtos/sounds/pig/oink.ogg', 'white/valtos/sounds/pig/squeak.ogg')

	attacked_sound = 'white/valtos/sounds/pig/oink.ogg'
	deathsound = 'white/valtos/sounds/pig/death.ogg'

	speak = list("СЛАВА УКРАЇНІ!","ГЕРОЯМ СЛАВА!","МОСКАЛІ СОСАТИ", "МОСКАЛЯКУ НА ГІЛЯКУ", "ХРЮ", "Хочу сальця")

	butcher_results = list(/obj/item/food/meat/slab/pig = 10)

	mob_size = MOB_SIZE_HUGE
	mob_biotypes = MOB_ORGANIC|MOB_EPIC

/mob/living/simple_animal/hostile/carp/ranged/chaos/hohol/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SHVAINOKARAS, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)
