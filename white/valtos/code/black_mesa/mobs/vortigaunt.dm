/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt
	name = "вортигонт"
	desc = "Рабочий Зена, он выглядит растерянно. Имеет третью руку на животе."
	icon = 'white/valtos/icons/black_mesa/mobs.dmi'
	icon_state = "vortigaunt"
	icon_living = "vortigaunt"
	icon_dead = "vortigaunt_dead"
	icon_gib = null
	gender = MALE
	faction = list(FACTION_STATION, "neutral")
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	speak_chance = 1
	speak_emote = list("колдует")
	speed = 1
	emote_taunt = list("колдует", "говорит на непонятном языке", "заклинает")
	projectiletype = /obj/projectile/beam/emitter
	projectilesound = 'white/valtos/sounds/black_mesa/mobs/vortigaunt/attack_shoot4.ogg'
	ranged_cooldown_time = 5 SECONDS
	ranged_message = "fires"
	taunt_chance = 100
	turns_per_move = 7
	maxHealth = 130
	health = 130
	speed = 3
	ranged = TRUE
	dodging = TRUE
	harm_intent_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	retreat_distance = 5
	minimum_distance = 5
	attack_sound = 'sound/weapons/bite.ogg'
	gold_core_spawnable = FRIENDLY_SPAWN
	loot = list(/obj/item/stack/sheet/bone)
	alert_sounds = list(
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert01.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert01b.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert02.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert03.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert04.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert05.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/alert06.ogg',
	)
	/// SOunds we play when asked to follow/unfollow.
	var/list/follow_sounds = list(
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue01.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue02.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue03.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue04.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue05.ogg',
		'white/valtos/sounds/black_mesa/mobs/vortigaunt/village_argue05a.ogg',
	)
	var/follow_speed = 1
	var/follow_distance = 2

/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/follow, follow_sounds, follow_sounds, follow_distance, follow_speed)

/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt/slave
	name = "вортигонт"
	desc = "Раб Зена. Он тебя не будет трогать, ему надо работать."
	icon_state = "vortigaunt_slave"
	faction = list(FACTION_XEN)
