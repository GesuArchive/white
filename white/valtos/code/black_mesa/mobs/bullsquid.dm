/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid
	name = "Буллсквид"
	desc = "Быкокальмар. Плюётся кислотой."
	icon = 'white/valtos/icons/black_mesa/mobs.dmi'
	icon_state = "bullsquid"
	icon_living = "bullsquid"
	icon_dead = "bullsquid_dead"
	icon_gib = null
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	speak_chance = 1
	speak_emote = list("рычит")
	emote_taunt = list("рычит", "трясёт щупальцами", "урчит")
	taunt_chance = 100
	turns_per_move = 7
	maxHealth = 110
	health = 110
	obj_damage = 50
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = TRUE
	retreat_distance = 4
	minimum_distance = 4
	dodging = TRUE
	projectiletype = /obj/projectile/bullsquid
	projectilesound = 'white/valtos/sounds/black_mesa/mobs/bullsquid/goo_attack3.ogg'
	melee_damage_upper = 18
	attack_sound = 'white/valtos/sounds/black_mesa/mobs/bullsquid/attack1.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	alert_sounds = list(
		'white/valtos/sounds/black_mesa/mobs/bullsquid/detect1.ogg',
		'white/valtos/sounds/black_mesa/mobs/bullsquid/detect2.ogg',
		'white/valtos/sounds/black_mesa/mobs/bullsquid/detect3.ogg'
	)

/obj/projectile/bullsquid
	name = "слизь"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = BURN
	nodamage = FALSE
	knockdown = 20
	impact_effect_type = /obj/effect/temp_visual/impact_effect/neurotoxin
	hitsound = 'white/valtos/sounds/black_mesa/mobs/bullsquid/splat1.ogg'
	hitsound_wall = 'white/valtos/sounds/black_mesa/mobs/bullsquid/splat1.ogg'

/obj/projectile/bullsquid/on_hit(atom/target, blocked, pierce_hit)
	new /obj/effect/decal/cleanable/greenglow(target.loc)
	return ..()
