/mob/living/simple_animal/pet/dog/corgi/pig
	name = "Свинья"
	real_name = "Свинья"
	desc = "Хрюкает."
	icon = 'white/valtos/icons/animal.dmi'
	icon_state = "pig"
	icon_living = "pig"
	icon_dead = "pig_dead"
	speak = list("ХРЮ!","УИИИИ!","ХРЮ?")
	speak_emote = list("хрюкает")
	emote_hear = list("хрюкает.")
	emote_see = list("хрюкает.")
	pet_bonus = FALSE
	speak_chance = 5
	turns_per_move = 1
	see_in_dark = 3
	maxHealth = 50
	health = 50
	attacked_sound = 'white/valtos/sounds/pig/oink.ogg'
	deathsound = 'white/valtos/sounds/pig/death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/pig = 3)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "отталкивает"
	response_disarm_simple = "отталкивает"
	response_harm_continuous = "пинает"
	response_harm_simple = "пинает"
	density = TRUE
	mob_size = MOB_SIZE_LARGE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = FALSE
	held_state = "pig"
	faction = list("neutral")

/mob/living/simple_animal/pet/dog/corgi/pig/Initialize()
	. = ..()
	if(prob(1))
		name = "Randy Sandy"
		desc = "<big>Самый жирный боров.</big>"
		maxHealth = 500
		health = 500

/mob/living/simple_animal/pet/dog/corgi/pig/Life()
	..()
	if(stat)
		return
	if(prob(10))
		var/chosen_sound = pick('white/valtos/sounds/pig/hru.ogg', 'white/valtos/sounds/pig/oink.ogg', 'white/valtos/sounds/pig/squeak.ogg')
		playsound(src, chosen_sound, 50, TRUE)

/mob/living/simple_animal/pet/dog/corgi/pig/update_corgi_fluff()
	name = real_name
	desc = initial(desc)
	speak = list("ХРЮ!","УИИИИ!","ХРЮ?")
	speak_emote = list("хрюкает")
	emote_hear = list("хрюкает!")
	emote_see = list("хрюкает гениально")
	set_light(0)

	if(inventory_head?.dog_fashion)
		var/datum/dog_fashion/DF = new inventory_head.dog_fashion(src)
		DF.apply(src)

	if(inventory_back?.dog_fashion)
		var/datum/dog_fashion/DF = new inventory_back.dog_fashion(src)
		DF.apply(src)

/obj/item/food/meat/slab/pig
	name = "сало"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "salo"
	foodtypes = MEAT

/obj/item/food/meat/slab/pig/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/salo, 3, 30)

/obj/item/food/meat/rawcutlet/plain/salo
	name = "сало"
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "salo_slice"
