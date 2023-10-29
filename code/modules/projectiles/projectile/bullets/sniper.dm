// .50 (Sniper)

/obj/projectile/bullet/p50
	name = "пуля .50 калибра"
	speed = 0.4
	damage = 70
	paralyze = 100
	dismemberment = 50
	armour_penetration = 50
	var/breakthings = TRUE

/obj/projectile/bullet/p50/on_hit(atom/target, blocked = 0)
	if(isobj(target) && (blocked != 100) && breakthings)
		var/obj/O = target
		O.take_damage(80, BRUTE, BULLET, FALSE)
	return ..()

/obj/projectile/bullet/p50/soporific
	name = "усыпляющая пуля .50 калибра"
	armour_penetration = 0
	damage = 0
	dismemberment = 25
	paralyze = 0
	breakthings = FALSE

/obj/projectile/bullet/p50/soporific/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && isliving(target))
		var/mob/living/L = target
		L.Sleeping(400)
	return ..()

/obj/projectile/bullet/p50/penetrator
	name = "бронебойная пуля .50 калибра"
	icon_state = "gauss"
	damage = 60
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))
	dismemberment = 25 //It goes through you cleanly.
	paralyze = 0
	breakthings = FALSE

/obj/projectile/bullet/p50/penetrator/shuttle //Nukeop Shuttle Variety
	icon_state = "gaussstrong"
	damage = 25
	speed = 0.3
	range = 16

/obj/projectile/bullet/p50/marksman
	name = "высокоточная пуля .50 калибра"
	damage = 50
	paralyze = 0
	tracer_type = /obj/effect/projectile/tracer/sniper
	impact_type = /obj/effect/projectile/impact/sniper
	muzzle_type = /obj/effect/projectile/muzzle/sniper
	hitscan = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_YELLOW
	muzzle_flash_intensity = 5
	muzzle_flash_range = 1
	muzzle_flash_color_override = LIGHT_COLOR_YELLOW
	impact_light_intensity = 5
	impact_light_range = 1
	impact_light_color_override = LIGHT_COLOR_YELLOW
	ricochets_max = 1
	ricochet_chance = 100
	ricochet_auto_aim_angle = 45
	ricochet_auto_aim_range = 15
	ricochet_incidence_leeway = 90
	ricochet_decay_damage = 1
	ricochet_shoots_firer = FALSE
