
//////////////////////////////////////////////////////////weapons

/////////////////////////////armblade

//obj/item/melee/arm_blade/mutantzombie

/////////////////////////////tentacle

/obj/item/gun/magic/tentacle/mutantzombie
	should_del = FALSE

	item_flags = ABSTRACT | DROPDEL
	force = 21
	wound_bonus = -30
	bare_wound_bonus = 15
	damtype = BRUTE

	ammo_type = /obj/item/ammo_casing/magic/tentacle/mutantzombie
	hitsound = 'sound/effects/splat.ogg'
	recharge_rate = 30 SECONDS

/obj/item/ammo_casing/magic/tentacle/mutantzombie
	projectile_type = /obj/projectile/tentacle/mutantzombie

/obj/projectile/tentacle/mutantzombie
	range = 5

/////////////////////////////shield

//obj/item/shield/changeling/mutantzombie

/////////////////////////////hand

