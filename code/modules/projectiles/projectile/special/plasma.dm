/obj/projectile/plasma
	name = "плазменная дуга"
	icon_state = "plasmacutter"
	damage_type = BRUTE
	damage = 5
	range = 4
	dismemberment = 20
	aim_mod = 1.5 //Xenos go away!
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	var/mine_range = 3 //mines this many additional tiles of rock
	tracer_type = /obj/effect/projectile/tracer/plasma_cutter
	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter

/obj/projectile/plasma/on_hit(atom/target)
	. = ..()
	if(ismineralturf(target))
		var/turf/closed/mineral/M = target
		M.attempt_drill(firer, FALSE)
		if(mine_range)
			mine_range--
			range++
		if(range > 0)
			return BULLET_ACT_FORCE_PIERCE

/obj/projectile/plasma/adv
	damage = 7
	range = 5
	mine_range = 5

/obj/projectile/plasma/adv/mega
	range = 7
	mine_range = 7

/obj/projectile/plasma/adv/mech
	damage = 10
	range = 9
	mine_range = 3

/obj/projectile/plasma/turret
	//Between normal and advanced for damage, made a beam so not the turret does not destroy glass
	name = "плазма-луч"
	damage = 24
	range = 7
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

// ПВЕ
/obj/projectile/plasma/adv/pve
	range = 7
	damage = 18		//В ПВП урон ниже

/obj/projectile/plasma/adv/pve/on_hit(atom/target)
	if(iscarbon(target))
		damage = 9
	if(issilicon(target))
		damage = 9
	if(isalienadult(target))
		damage = 18
	. = ..()
