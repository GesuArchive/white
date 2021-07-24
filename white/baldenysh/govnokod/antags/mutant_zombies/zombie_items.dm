
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

/obj/item/mutant_zombie_hand
	name = "zombie claw"
	desc = "A zombie's claw is its primary tool, capable of infecting \
		humans, butchering all other living things to \
		sustain the zombie, smashing open airlock doors and opening \
		child-safe caps on bottles."
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 21 // Just enough to break airlocks with melee attacks
	sharpness = SHARP_EDGED
	wound_bonus = -30
	bare_wound_bonus = 15
	damtype = BRUTE

/obj/item/mutant_zombie_hand/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

