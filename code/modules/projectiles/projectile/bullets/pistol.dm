// 9мм (Makarov and Stechkin APS)

/obj/projectile/bullet/c9mm
	name = "9мм пуля"
	damage = 30
	embedding = list(embed_chance=15, fall_chance=3, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=6, rip_time=10)

/obj/projectile/bullet/c9mm_ap
	name = "9мм бронебойная пуля"
	damage = 25
	armour_penetration = 30
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/c9mm_hp
	name = "9мм экспансивная пуля"
	damage = 40
	armour_penetration = -50

/obj/projectile/bullet/incendiary/c9mm
	name = "9мм зажигательная пуля"
	damage = 20
	fire_stacks = 2

/obj/projectile/bullet/traumatic
	name = "9мм травматическая пуля"
	damage = 3
	stamina = 45

// 10mm

/obj/projectile/bullet/c10mm
	name = "10мм пуля"
	damage = 40

/obj/projectile/bullet/c10mm_ap
	name = "10мм бронебойная пуля"
	damage = 35
	armour_penetration = 40

/obj/projectile/bullet/c10mm_hp
	name = "10мм экспансивная пуля"
	damage = 60
	armour_penetration = -50

/obj/projectile/bullet/incendiary/c10mm
	name = "10мм зажигательная пуля"
	damage = 30
	fire_stacks = 3
