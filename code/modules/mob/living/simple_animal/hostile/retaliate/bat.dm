/mob/living/simple_animal/hostile/retaliate/bat
	name = "Space Bat"
	desc = "A rare breed of bat which roosts in spaceships, probably not vampiric."
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 20
	health = 20
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	butcher_results = list(/obj/item/food/meat/slab = 1)
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_TINY
	speak_emote = list("пищит")
	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0
	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/bat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_flying)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NO_MIRROR_REFLECTION, INNATE_TRAIT)

/mob/living/simple_animal/hostile/retaliate/bat/sgt_araneus //Despite being a bat for... reasons, this is now a spider, and is one of the HoS' pets.
	name = "Сержант Арахниус"
	real_name = "Сержант Арахниус"
	desc = "A fierce companion of the Head of Security, this spider has been carefully trained by Nanotrasen specialists. Its beady, staring eyes send shivers down your spine."
	emote_hear = list("chitters")
	faction = list("spiders")
	harm_intent_damage = 3
	health = 200
	icon_dead = "guard_dead"
	icon_gib = "guard_dead"
	icon_living = "guard"
	icon_state = "guard"
	maxHealth = 250
	max_co2 = 5
	max_tox = 2
	melee_damage_lower = 15
	melee_damage_upper = 20
	min_oxy = 5
	movement_type = GROUND
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	turns_per_move = 10
	pet_bonus = TRUE
	pet_bonus_emote = "радостно стрекочет!"

/mob/living/simple_animal/hostile/retaliate/bat/magmawing
	name = "магмовый страж"
	desc = "Будучи выпущенными очень близко к лаве, некоторые стражи приспосабливаются к экстремальной жаре и используют лаву как оружие..."
	icon = 'icons/mob/lavaland/lavaland_monsters_wide.dmi'
	icon_state = "watcher_magmawing"
	icon_living = "watcher_magmawing"
	icon_dead = "watcher_magmawing_dead"
	faction = list("neutral")
	maxHealth = 300 //Compensate for the lack of slowdown on projectiles with a bit of extra health
	health = 300
	melee_damage_lower = 15
	melee_damage_upper = 20
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 2.5
	light_color = LIGHT_COLOR_LAVA
	projectiletype = /obj/projectile/temp/basilisk/magmawing

/mob/living/simple_animal/hostile/retaliate/bat/icewing
	name = "ледяной страж"
	desc = "Очень редко некоторые стражи предпочитают обитать вдали от источников тепла. В отсутствие тепла они становятся ледяными и хрупкими, но стреляют гораздо более сильными морозными ударами."
	icon = 'icons/mob/lavaland/lavaland_monsters_wide.dmi'
	icon_state = "watcher_icewing"
	icon_living = "watcher_icewing"
	icon_dead = "watcher_icewing_dead"
	faction = list("neutral")
	maxHealth = 200
	health = 200
	melee_damage_lower = 20
	melee_damage_upper = 25
	projectiletype = /obj/projectile/temp/basilisk/icewing
