// C3D (Borgs)

/obj/projectile/bullet/c3d
	damage = 20

// Mech LMG

/obj/projectile/bullet/lmg
	damage = 30

// Mech FNX-99

/obj/projectile/bullet/incendiary/fnx99
	damage = 30

// Turrets

/obj/projectile/bullet/manned_turret
	damage = 20

/obj/projectile/bullet/manned_turret/hmg
	icon_state = "redtrac"

/obj/projectile/bullet/syndicate_turret
	damage = 20

// 7.12x82mm (SAW)

/obj/projectile/bullet/mm712x82
	name = "пуля калибра 7.12x82"
	damage = 40
	armour_penetration = 5
	wound_bonus = -50
	wound_falloff_tile = 0

/obj/projectile/bullet/mm712x82_ap
	name = "бронебойная пуля калибра 7.12x82"
	damage = 35
	armour_penetration = 40

/obj/projectile/bullet/mm712x82_hp
	name = "экспансивная пуля калибра 7.12x82"
	damage = 50
	armour_penetration = -60
	sharpness = SHARP_EDGED
	wound_bonus = -40
	bare_wound_bonus = 30
	wound_falloff_tile = -8

/obj/projectile/bullet/incendiary/mm712x82
	name = "зажигательная пуля калибра 7.12x82"
	damage = 30
	fire_stacks = 3

/obj/projectile/bullet/mm712x82_match
	name = "самонаводящаяся пуля калибра 7.12x82"
	damage = 40
	ricochets_max = 2
	ricochet_chance = 60
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 55
	wound_bonus = -50

/obj/projectile/bullet/mm712x82_bouncy
	name = "резиновая пуля калибра 7.12x82"
	damage = 15
	ricochets_max = 40
	ricochet_chance = 500 // will bounce off anything and everything, whether they like it or not
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 0.9

/obj/projectile/bullet/a792x57
	damage = 3
	stamina = 5
	speed = 0.4
	armour_penetration = 0

/obj/projectile/bullet/a556
	damage = 50
	armour_penetration = 25

/obj/projectile/bullet/carab
	damage = 30
	armour_penetration = 7.5

/obj/projectile/bullet/assault_rifle
	damage = 30
	armour_penetration = 25
