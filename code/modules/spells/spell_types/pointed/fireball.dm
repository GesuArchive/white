/datum/action/cooldown/spell/pointed/projectile/fireball
	name = "Огненный шар"
	desc = "Запускает взрывной огненный шар в цель."
	button_icon_state = "fireball0"

	sound = 'sound/magic/fireball.ogg'
	school = SCHOOL_EVOCATION
	cooldown_time = 6 SECONDS
	cooldown_reduction_per_rank = 1 SECONDS // 1 second reduction per rank

	invocation = "ONI SOMA!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	active_msg = "Готовлюсь к произнесению заклинания огненного шара!"
	deactive_msg = "Пламя моего огненного шара затухает... На время..."
	cast_range = 8
	projectile_type = /obj/projectile/magic/fireball

/datum/action/cooldown/spell/pointed/projectile/fireball/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.range = (6 + 2 * spell_level)
