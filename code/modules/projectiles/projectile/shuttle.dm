
//Travels through walls until it hits the target
/obj/projectile/bullet/shuttle
	name = "shuttle projectile"
	desc = "A projectile fired from someone else"
	icon_state = "84mm-hedp"
	movement_type = FLYING
	range = 30
	reflectable = NONE

	//Turf damage factor
	//Values are between 0 and 10
	var/light_damage_factor = 11
	var/heavy_damage_factor = 11
	var/devestate_damage_factor = 11

	var/obj_damage = 0
	var/miss = FALSE
	var/force_miss = FALSE

/obj/projectile/bullet/shuttle/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	// Never hit targets if we missed, but do hit turfs along the way
	if (!isturf(target) && (miss || force_miss))
		return FALSE
	. = ..()

/obj/projectile/bullet/shuttle/on_hit(atom/target, blocked)
	//Damage turfs
	if (isclosedturf(target))
		var/turf/T = target
		//Apply damage overlay
		if(impact_effect_type && !hitscan)
			new impact_effect_type(T, target.pixel_x + rand(-8, 8), target.pixel_y + rand(-8, 8))
		//Damage the turf
		var/selected_damage = rand(0, 10)
		if(selected_damage >= light_damage_factor && selected_damage <= heavy_damage_factor - 1)
			T.ex_act(EXPLODE_LIGHT)
		if (selected_damage >= heavy_damage_factor && selected_damage <= devestate_damage_factor - 1)
			T.ex_act(EXPLODE_HEAVY)
		if (selected_damage >= devestate_damage_factor)
			T.ex_act(EXPLODE_DEVASTATE)
		//Damage objects in the turf
		for(var/obj/object in T)
			object.take_damage(damage)
	return ..()

/obj/projectile/bullet/shuttle/ballistic
	name = "bullet"
	desc = "Will kill you."
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	hitsound_wall = "ricochet"
	flag = "bullet"
	eyeblur = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	ricochets_max = 2
	ricochet_chance = 20
	nodamage = FALSE
	hitsound_wall = "ricochet"

/obj/projectile/bullet/shuttle/ballistic/guass
	icon_state = "guassstrong"
	name = "guass round"
	damage = 50
	armour_penetration = 40
	projectile_piercing = ALL

/obj/projectile/bullet/shuttle/ballistic/guass/on_hit(atom/target, blocked)
	var/turf/T = target
	//Make it so it can damage turfs
	if(istype(T))
		if(impact_effect_type && !hitscan)
			new impact_effect_type(T, target.pixel_x + rand(-8, 8), target.pixel_y + rand(-8, 8))
		//Boom
		explosion(T, 0, 0, 1, 0, flame_range = 2, adminlog = FALSE)
		return BULLET_ACT_FORCE_PIERCE
	return ..()

/obj/projectile/bullet/shuttle/ballistic/guass/uranium
	icon_state = "gaussradioactive"
	name = "uranium-coated guass round"
	irradiate = 200
	damage = 80
	slur = 50
	knockdown = 80

/obj/projectile/bullet/shuttle/ballistic/point_defense
	name = "point defense round"
	damage = 15
	eyeblur = 0
	light_damage_factor = 7
	heavy_damage_factor = 10

/obj/projectile/bullet/shuttle/beam
	name = "beam"
	desc = "A heavy damage laser that will deal good damage to people and machines, but does little to penetrate hull, especially that which is reflective."
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 40
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	ricochets_max = 50	//Honk!
	ricochet_chance = 50
	light_damage_factor = 0
	heavy_damage_factor = 6
	var/ignore_ricochet_chance = 70

/obj/projectile/bullet/shuttle/beam/Initialize()
	. = ..()
	if(prob(ignore_ricochet_chance))
		ricochet_chance = 0

/obj/projectile/bullet/shuttle/beam/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/bullet/shuttle/beam/laser/heavy
	damage = 65
	light_damage_factor = 0
	heavy_damage_factor = 4
	devestate_damage_factor = 8

/obj/projectile/bullet/shuttle/missile
	name = "missile"
	desc = "You should probably move rather than stare at this."
	damage = 0
	armour_penetration = 100
	dismemberment = 0
	ricochets_max = 0
	pass_flags = ALL
	var/devastation = -1
	var/heavy = -1
	var/light_r = -1
	var/flash = -1
	var/fire = -1

/obj/projectile/bullet/shuttle/missile/on_hit(atom/target, blocked = FALSE)
	if(get_turf(target) != original && istype(target, /obj/structure/emergency_shield))
		return FALSE
	explosion(target, devastation, heavy, light_r, flash, 0, flame_range = fire)
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/bullet/shuttle/missile/breach
	name = "breaching missile"
	desc = "Putting holes in your hulls since 2042."
	devastation = -1
	heavy = 2
	light_r = 4
	flash = 5
	fire = 1

/obj/projectile/bullet/shuttle/missile/fire
	name = "incediary missile"
	desc = "An anti-personnel weapon, for roasting your enemies harder than any diss-track ever could."
	light_r = 2
	flash = 5
	fire = 4

/obj/projectile/bullet/shuttle/missile/mini
	name = "missile"
	desc = "A missile with a small payload."
	heavy = 1
	light_r = 3
	flash = 4
	fire = 2

/obj/projectile/bullet/shuttle/missile/mini/examine(mob/user)
	. = ..()
	if (in_range(src, user))
		. += "It has a label on it that reads <b>'Caution: This missile is extremely underwhelming.'</b>"
	else
		. += "It has a small label on the side, but you are too far away to read it."

/obj/projectile/bullet/shuttle/missile/black_hole
	name = "black_hole missile"
	desc = "A mixture of a highly reactive putty explosive and dense supermatter extracts. Upon impact, the reactive putty will detonate and compress the supermatter extract forming a blackhole."
	light_r = 150

/obj/projectile/bullet/shuttle/missile/black_hole/on_hit(atom/target, blocked)
	//Locate our current z-level
	var/turf/T = get_turf(target)
	var/datum/orbital_object/orbital_body = SSorbits.assoc_z_levels["[T.z]"]
	new /obj/singularity(T)
	if(!orbital_body)
		return
