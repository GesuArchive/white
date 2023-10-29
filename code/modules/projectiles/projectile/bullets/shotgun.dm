/obj/projectile/bullet/shotgun_slug
	name = "пуля 12 калибра"
	damage = 50
	sharpness = SHARP_POINTY
	wound_bonus = -20 //Выбивание органов с двух пуль это смешно, но не очень честно.

/obj/projectile/bullet/shotgun_slug/executioner
	name = "калечащая пуля 12 калибра" // admin only, can dismember limbs
	sharpness = SHARP_EDGED
	wound_bonus = 80

/obj/projectile/bullet/shotgun_slug/pulverizer
	name = "увечащая пуля 12 калибра" // admin only, can crush bones
	sharpness = NONE
	wound_bonus = 80

/obj/projectile/bullet/shotgun_beanbag
	name = "резиновая пуля 12 калибра"
	damage = 10
	stamina = 55
	wound_bonus = 20
	sharpness = NONE
	embedding = null
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.8

/obj/projectile/bullet/incendiary/shotgun
	name = "зажигательная пуля 12 калибра"
	damage = 40

/obj/projectile/bullet/incendiary/shotgun/dragonsbreath
	name = "гранула драконьего дыхания"
	damage = 10

/obj/projectile/bullet/shotgun_stunslug
	name = "электропуля 12 калибра"
	damage = 5
	paralyze = 100
	stutter = 5
	jitter = 20
	range = 7
	icon_state = "spark"
	color = "#FFFF00"
	embedding = null

/obj/projectile/bullet/shotgun_meteorslug
	name = "пуля-метеор 12 калибра"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "dust"
	damage = 25
	paralyze = 15
	knockdown = 60
	hitsound = 'sound/effects/meteorimpact.ogg'

/obj/projectile/bullet/shotgun_meteorslug/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ismovable(target))
		var/atom/movable/M = target
		var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
		M.safe_throw_at(throw_target, 3, 2, force = MOVE_FORCE_EXTREMELY_STRONG)

/obj/projectile/bullet/shotgun_meteorslug/Initialize(mapload)
	. = ..()
	SpinAnimation()

/obj/projectile/bullet/shotgun_frag12
	name = "разрывная пуля 12 калибра"
	damage = 15
	paralyze = 10

/obj/projectile/bullet/shotgun_frag12/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, devastation_range = -1, light_impact_range = 1, explosion_cause = src)
	return BULLET_ACT_HIT

/obj/projectile/bullet/pellet
	var/tile_dropoff = 0.45
	var/tile_dropoff_s = 0.25
	min_hitchance = 5 //Дробька маленькая

/obj/projectile/bullet/pellet/Range()
	..()
	if(damage > 0)
		damage -= tile_dropoff
	if(stamina > 0)
		stamina -= tile_dropoff_s
	if(damage < 0 && stamina < 0)
		qdel(src)

/obj/projectile/bullet/pellet/shotgun_buckshot
	name = "дробинки картечи"
	damage = 7.5
	wound_bonus = 5
	bare_wound_bonus = 5
	wound_falloff_tile = -2.5 // low damage + additional dropoff will already curb wounding potential anything past point blank

/obj/projectile/bullet/pellet/shotgun_rubbershot
	name = "резиновые дробинки"
	damage = 3
	stamina = 11
	sharpness = NONE
	embedding = null
	speed = 1.2
	ricochets_max = 4
	ricochet_chance = 120
	ricochet_decay_chance = 0.9
	ricochet_decay_damage = 0.8
	ricochet_auto_aim_range = 2
	ricochet_auto_aim_angle = 30
	ricochet_incidence_leeway = 75
	/// Subtracted from the ricochet chance for each tile traveled
	var/tile_dropoff_ricochet = 4

/obj/projectile/bullet/pellet/shotgun_rubbershot/Range()
	if(ricochet_chance > 0)
		ricochet_chance -= tile_dropoff_ricochet
	. = ..()

/obj/projectile/bullet/pellet/shotgun_incapacitate
	name = "обезвреживающие дробинки"
	damage = 1
	stamina = 6
	embedding = null

/obj/projectile/bullet/pellet/shotgun_improvised
	tile_dropoff = 0.35		//Come on it does 6 damage don't be like that.
	damage = 6
	wound_bonus = 0
	bare_wound_bonus = 7.5

/obj/projectile/bullet/pellet/shotgun_improvised/Initialize(mapload)
	. = ..()
	range = rand(1, 8)

/obj/projectile/bullet/pellet/shotgun_improvised/on_range()
	do_sparks(1, TRUE, src)
	..()

// Mech Scattershot

/obj/projectile/bullet/scattershot
	damage = 24

/obj/projectile/bullet/apslug
	name = "бронебойная пуля 12 калибра"
	armour_penetration = 40
	damage = 40
	projectile_phasing = (ALL & (~PASSMOB))
	dismemberment = 0
