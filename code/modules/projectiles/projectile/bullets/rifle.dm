// 5.56mm (M-90gl Carbine)

/obj/projectile/bullet/a556
	name = "пуля калибра 5.56мм"
	damage = 35
	armour_penetration = 30
	wound_bonus = -40

/obj/projectile/bullet/a556/phasic
	name = "блюспейс пуля калибра 5.56мм"
	icon_state = "gaussphase"
	damage = 20
	armour_penetration = 70
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE | PASSDOORS

// 7.62 (Nagant Rifle)

/obj/projectile/bullet/a762
	name = "пуля калибра 7.62мм"
	damage = 60
	wound_bonus = -35
	wound_falloff_tile = 0

/obj/projectile/bullet/a762_enchanted
	name = "травматическая пуля калибра 7.62мм"
	damage = 20
	stamina = 80

// Harpoons (Harpoon Gun)

/obj/projectile/bullet/harpoon
	name = "гарпун"
	icon_state = "gauss"
	damage = 60
	armour_penetration = 50
	wound_bonus = -20
	bare_wound_bonus = 80
	embedding = list(embed_chance=100, fall_chance=3, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=6, rip_time=10)
	wound_falloff_tile = -5
