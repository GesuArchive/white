
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
	recharge_rate = 30

/obj/item/ammo_casing/magic/tentacle/mutantzombie
	projectile_type = /obj/projectile/tentacle/mutantzombie

/obj/projectile/tentacle/mutantzombie
	range = 5

/////////////////////////////shield

/obj/item/shield/mutantzombie
	name = "щитообразная масса"
	desc = "Масса жесткой костной ткани с пузырями термита. При должном упорстве этим можно прожечь стену."
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/obj/changeling_items.dmi'
	icon_state = "ling_shield"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	block_chance = 40
	force = 21
	max_integrity = 500
	var/thermite_apply_time = 2 SECONDS
	var/thermite_amount = 5

/obj/item/shield/mutantzombie/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(isturf(target) && do_after(user, thermite_apply_time, target))
		var/datum/component/thermite/therm = target.AddComponent(/datum/component/thermite, thermite_amount)
		playsound(src, 'sound/effects/splat.ogg', 30, TRUE)
		if(therm && therm.amount >= therm.burn_require)
			therm.flame_react(src, 2000)

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
	icon_state = "bloodhand_right"
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 21 // Just enough to break airlocks with melee attacks
	sharpness = SHARP_EDGED
	wound_bonus = -30
	bare_wound_bonus = 15
	damtype = BRUTE

/obj/item/mutant_zombie_hand/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

