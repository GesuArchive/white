/obj/projectile/temp/inferno
	name = "расплавленный сгусток нанитов"
	icon_state = "infernoshot"
	damage = 20
	damage_type = BURN
	flag = ENERGY
	armour_penetration = 10
	reflectable = NONE
	wound_bonus = -10
	bare_wound_bonus = 0
	temperature = 20
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser

/obj/projectile/temp/inferno/on_hit(atom/target, blocked, pierce_hit)
	..()
	if(!ishuman(target))
		return

	var/mob/living/carbon/cold_target = target
	var/how_cold_is_target = cold_target.bodytemperature
	var/danger_zone = cold_target.dna.species.bodytemp_cold_damage_limit - 150
	if(how_cold_is_target < danger_zone)
		cold_target.Knockdown(10)
		cold_target.apply_damage(20, BURN)
		cold_target.bodytemperature = cold_target.dna.species.bodytemp_normal //avoids repeat knockdowns, maybe could be used to cool down again?
		playsound(cold_target, 'sound/weapons/sear.ogg', 30, TRUE, -1)
/*
		explosion(cold_target, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 2, flame_range = 3) //maybe stand back a bit
		cold_target.bodytemperature = cold_target.dna.species.bodytemp_normal //avoids repeat explosions, maybe could be used to heat up again?
		playsound(cold_target, 'sound/weapons/sear.ogg', 30, TRUE, -1)
*/

/obj/projectile/temp/cryo
	name = "замороженный осколок нанитов"
	icon_state = "cryoshot"
	damage = 20
	damage_type = BRUTE
	armour_penetration = 10
	flag = ENERGY
	sharpness = SHARP_POINTY //it's a big ol' shard of ice
	reflectable = NONE
	wound_bonus = -10
	bare_wound_bonus = 0
	temperature = -20

/obj/projectile/temp/cryo/on_hit(atom/target, blocked, pierce_hit)
	..()
	if(!ishuman(target))
		return

	var/mob/living/carbon/hot_target = target
	var/how_hot_is_target = hot_target.bodytemperature
	var/danger_zone = hot_target.dna.species.bodytemp_heat_damage_limit + 300
	if(how_hot_is_target > danger_zone)
		hot_target.Knockdown(100)
		hot_target.apply_damage(5, BURN)
		hot_target.bodytemperature = hot_target.dna.species.bodytemp_normal //avoids repeat knockdowns, maybe could be used to cool down again?
		playsound(hot_target, 'sound/weapons/sonic_jackhammer.ogg', 30, TRUE, -1)
