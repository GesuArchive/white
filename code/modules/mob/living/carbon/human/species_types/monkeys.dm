/datum/species/monkey
	name = "Monkey"
	id = "monkey"
	say_mod = "выкрикивает"
	attack_verb = "кусает"
	attack_effect = ATTACK_EFFECT_BITE
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/bite.ogg'
	mutant_organs = list(/obj/item/organ/tail/monkey)
	mutantbrain = /obj/item/organ/brain/primate
	mutant_bodyparts = list("tail_monkey" = "Monkey")
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	meat = /obj/item/food/meat/slab/monkey
	knife_butcher_results = list(/obj/item/food/meat/slab/monkey = 5, /obj/item/stack/sheet/animalhide/monkey = 1)
	species_traits = list(
		HAS_FLESH,
		HAS_BONE,
		NO_UNDERWEAR,
		LIPS,
		NOEYESPRITES,
		NOBLOODOVERLAY,
		NOTRANSSTING,
		NOAUGMENTS,
	)
	inherent_traits = list(
		TRAIT_CAN_STRIP,
		TRAIT_GUN_NATURAL,
		TRAIT_MONKEYLIKE,
		TRAIT_PRIMITIVE,
		TRAIT_VENTCRAWLER_NUDE,
		TRAIT_WEAK_SOUL,
	)
	no_equip = list(
		ITEM_SLOT_OCLOTHING,
		ITEM_SLOT_GLOVES,
		ITEM_SLOT_FEET,
		ITEM_SLOT_SUITSTORE,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN | SLIME_EXTRACT
	liked_food = MEAT | FRUIT
	disliked_food = CLOTH
	limbs_id = "monkey"
	damage_overlay_type = "monkey"
	sexes = FALSE
	punchdamagelow = 1
	punchdamagehigh = 3
	punchstunthreshold = 4 // no stun punches
	species_language_holder = /datum/language_holder/monkey
	bodypart_overides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/monkey,\
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/monkey,\
		BODY_ZONE_HEAD = /obj/item/bodypart/head/monkey,\
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/monkey,\
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/monkey,\
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/monkey
	)
	fire_overlay = "monkey"
	dust_anim = "dust-m"
	gib_anim = "gibbed-m"

	payday_modifier = 1.5


/datum/species/monkey/random_name(gender,unique,lastname,en_lang)
	var/randname = "мартышка ([rand(1,999)])"

	return randname

/datum/species/monkey/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	H.pass_flags |= PASSTABLE
	H.butcher_results = knife_butcher_results
	if(!H.dna.features["tail_monkey"] || H.dna.features["tail_monkey"] == "None")
		H.dna.features["tail_monkey"] = "Monkey"
		handle_mutant_bodyparts(H)

	H.dna.add_mutation(RACEMUT, MUT_NORMAL)
	H.dna.activate_mutation(RACEMUT)


/datum/species/monkey/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.pass_flags = initial(C.pass_flags)
	C.butcher_results = null
	C.dna.remove_mutation(RACEMUT)

/datum/species/monkey/spec_unarmedattack(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		if(!iscarbon(target))
			return TRUE
		var/mob/living/carbon/victim = target
		if(user.a_intent != INTENT_HARM || user.is_muzzled())
			return TRUE
		var/obj/item/bodypart/affecting = null
		if(ishuman(victim))
			var/mob/living/carbon/human/human_victim = victim
			affecting = human_victim.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		var/armor = victim.run_armor_check(affecting, MELEE)
		if(prob(25))
			victim.visible_message(span_danger("[user] bite misses [victim]!") ,
				span_danger("You avoid [user] bite!") , span_hear("You hear jaws snapping shut!") , COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_danger("Your bite misses [victim]!"))
			return TRUE
		victim.apply_damage(rand(punchdamagelow, punchdamagehigh), BRUTE, affecting, armor)
		victim.visible_message(span_danger("[name] bites [victim]!") ,
			span_userdanger("[name] bites you!") , span_hear("You hear a chomp!") , COMBAT_MESSAGE_RANGE, name)
		to_chat(user, span_danger("You bite [victim]!"))
		if(armor >= 2)
			return TRUE
		for(var/d in user.diseases)
			var/datum/disease/bite_infection = d
			victim.ForceContractDisease(bite_infection)
		return TRUE
	target.attack_paw(user)
	return TRUE

/datum/species/monkey/handle_mutations_and_radiation(mob/living/carbon/human/H)
	. = ..()
	if(H.radiation > RAD_MOB_MUTATE * 2 && prob(50))
		H.gorillize()
		return

/datum/species/monkey/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[MONKEYDAY])
		return TRUE
	return ..()

/obj/item/organ/brain/primate //Ook Ook
	name = "мозг примата"
	desc = "Этот мозг небольшой, но имеет увеличенные затылочные доли для обнаружения бананов."
	actions_types = list(/datum/action/item_action/organ_action/toggle_trip)
	/// Will this monkey stumble if they are crossed by a simple mob or a carbon in combat mode? Toggable by monkeys with clients, and is messed automatically set to true by monkey AI.
	var/tripping = TRUE

/datum/action/item_action/organ_action/toggle_trip
	name = "Переключить опрокидывание"
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "lesser_form"
	background_icon_state = "bg_default_on"
	overlay_icon_state = "bg_default_border"

/datum/action/item_action/organ_action/toggle_trip/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	var/obj/item/organ/brain/primate/monkey_brain = target
	if(monkey_brain.tripping)
		monkey_brain.tripping = FALSE
		background_icon_state = "bg_default"
		overlay_icon_state = "bg_default_border"
		to_chat(monkey_brain.owner, span_notice("Теперь я не споткнусь при столкновении с людьми, находящимися в боевом режиме."))
	else
		monkey_brain.tripping = TRUE
		background_icon_state = "bg_default_on"
		to_chat(monkey_brain.owner, span_notice("Теперь я буду спотыкаться при столкновении с людьми, находящимися в боевом режиме."))
	build_all_button_icons()

/obj/item/organ/brain/primate/Insert(mob/living/carbon/primate, special, no_id_transfer)
	. = ..()
	ADD_TRAIT(primate, TRAIT_PRIMITIVE, ORGAN_TRAIT)
	RegisterSignal(primate, COMSIG_MOVABLE_CROSS, PROC_REF(on_crossed), TRUE)

/obj/item/organ/brain/primate/Remove(mob/living/carbon/primate, special = 0, no_id_transfer = FALSE)
	. = ..()
	REMOVE_TRAIT(primate, TRAIT_PRIMITIVE, ORGAN_TRAIT)
	UnregisterSignal(primate, COMSIG_MOVABLE_CROSS)

/obj/item/organ/brain/primate/proc/on_crossed(datum/source, atom/movable/crossed)
	SIGNAL_HANDLER
	if(!tripping)
		return
	if(IS_DEAD_OR_INCAP(owner) || !isliving(crossed))
		return
	var/mob/living/in_the_way_mob = crossed
	if(iscarbon(in_the_way_mob) && in_the_way_mob.a_intent != INTENT_HARM)
		return
	if(in_the_way_mob.pass_flags & PASSTABLE)
		return
	in_the_way_mob.knockOver(owner)

