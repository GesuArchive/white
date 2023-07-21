// .45 (M1911 & C20r)

/obj/projectile/bullet/c45
	name = "пуля .45 калибра"
	damage = 30
	wound_bonus = -10
	wound_falloff_tile = -10

/obj/projectile/bullet/c45/fake
	damage = 1
	stamina = 3

/obj/projectile/bullet/c45_ap
	name = "бронебойная пуля .45 калибра"
	damage = 25
	armour_penetration = 30

/obj/projectile/bullet/incendiary/c45
	name = "зажигательная пуля .45 калибра"
	damage = 20
	fire_stacks = 2

// 4.6x30mm (Autorifles)

/obj/projectile/bullet/c46x30mm
	name = "пуля калибра 4.6x30мм"
	damage = 20
	wound_bonus = -5
	bare_wound_bonus = 5
	embed_falloff_tile = -4
	min_hitchance = 5 //WT-550 balance

/obj/projectile/bullet/c46x30mm_ap
	name = "бронебойная пуля калибра 4.6x30мм"
	damage = 15
	armour_penetration = 30
	embedding = null
	min_hitchance = 5 //WT-550 balance

/obj/projectile/bullet/incendiary/c46x30mm
	name = "зажигательная пуля калибра 4.6x30мм"
	damage = 10
	fire_stacks = 1
	min_hitchance = 5 //WT-550 balance

// 9x19mm (PP-95)

/obj/projectile/bullet/c9x19mm
	name = "9x19мм пуля"
	damage = 10
