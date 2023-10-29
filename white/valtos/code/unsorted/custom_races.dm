/mob/living/carbon/proc/draw_white_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_custom_android = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_custom_android = FALSE

/////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/athena
	race = /datum/species/android/athena

/datum/species/android/athena
	name = "Athena"
	id = "athena_s"
	limbs_id = null

/datum/species/android/athena/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.draw_white_parts()
	C.update_body()

/////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/aandroid
	race = /datum/species/android/aandroid

/datum/species/android/aandroid
	name = "A-Android"
	id = "aandroid"
	limbs_id = null

/datum/species/android/aandroid/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.draw_white_parts()
	C.update_body()

/////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/oni_android
	race = /datum/species/android/oni_android

/datum/species/android/oni_android
	name = "Oni Android"
	id = "oni"
	limbs_id = null
	mutant_organs = list(/obj/item/organ/tail/cat/oni_android)
	mutant_bodyparts = list("tail_human" = "Oni")
	species_traits = list(NOBLOOD, NOEYESPRITES, EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH)

/datum/species/android/oni_android/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.draw_white_parts()
	C.update_body()

/datum/species/android/oni_android/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["tail_human"] || mutant_bodyparts["waggingtail_human"]

/datum/species/android/oni_android/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_human"]

/datum/species/android/oni_android/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_human"])
		mutant_bodyparts["waggingtail_human"] = mutant_bodyparts["tail_human"]
		mutant_bodyparts -= "tail_human"
	H.update_body()

/datum/species/android/oni_android/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_human"])
		mutant_bodyparts["tail_human"] = mutant_bodyparts["waggingtail_human"]
		mutant_bodyparts -= "waggingtail_human"
	H.update_body()

/obj/item/organ/tail/cat/oni_android
	name = "кибернетический хвост"
	desc = "Отрезанный кибернетический хвост. Кто сейчас кибер-виляет?"
	tail_type = "Oni"

/////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/synthman
	race = /datum/species/android/synthman

/datum/species/android/synthman
	name = "Синтетик"
	id = "synthman"
	limbs_id = null
	draw_robot_hair = TRUE
	use_skintones = TRUE
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, NOBLOOD)

/datum/species/android/synthman/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.draw_white_parts()
	C.update_body()

/////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/babulet
	race = /datum/species/android/babulet

/datum/species/android/babulet
	name = "Babulet"
	id = "babulet"
	liked_food = VEGETABLES | DAIRY | CLOTH
	disliked_food = FRUIT | GROSS
	toxic_food = MEAT | RAW
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutanteyes = /obj/item/organ/eyes/moth
	mutant_bodyparts = list("moth_wings" = "Plain", "moth_markings" = "None")
	attack_verb = "цапает"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/food/meat/slab/human/mutant/moth
	limbs_id = null
	draw_robot_hair = TRUE
	use_skintones = TRUE
	species_traits = list(LIPS, NOEYESPRITES, HAS_FLESH, HAS_BONE, HAS_MARKINGS)
	species_language_holder = /datum/language_holder/moth
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
	)
	wings_icon = "Megamoth"
	has_innate_wings = TRUE
	payday_modifier = 0.75

/datum/species/android/babulet/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.draw_white_parts()
	C.update_body()

/////////////////////////////////////////////////////////////////////////////////////////

/datum/species/human/pigman
	name = "Свиноч"
	id = "pigman"
	say_mod = "хрюкает"
	species_language_holder = /datum/language_holder/xoxol
	brutemod = 0.5
	coldmod = 0.5
	burnmod = 2
	heatmod = 2
	payday_modifier = 1.5 // :^)
	mutant_bodyparts = list("tail_human" = "Pig", "ears" = "Pig")
	meat = /obj/item/food/meat/slab/pig
	mutantears = /obj/item/organ/ears/pig
	mutant_organs = list(/obj/item/organ/tail/cat/pig)

/datum/species/human/pigman/on_species_gain(mob/living/carbon/human/C)
	C.draw_custom_races(TRUE)
	. = ..()

/datum/species/human/pigman/on_species_loss(mob/living/carbon/human/C)
	C.draw_custom_races(FALSE)
	. = ..()

/datum/species/human/pigman/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.stat && prob(25))
		playsound(get_turf(target), pick('white/valtos/sounds/pig/hru.ogg', 'white/valtos/sounds/pig/oink.ogg', 'white/valtos/sounds/pig/squeak.ogg'), 50, TRUE)
	. = ..()

/datum/language_holder/xoxol
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/xoxol = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/xoxol = list(LANGUAGE_ATOM))

/obj/item/organ/ears/pig
	name = "свиноушки"
	icon = 'white/valtos/icons/mutant_bodyparts.dmi'
	icon_state = "piggy"
	damage_multiplier = 1.5

/obj/item/organ/ears/pig/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		H.dna.features["ears"] = H.dna.species.mutant_bodyparts["ears"] = "Pig"
		H.update_body()

/obj/item/organ/ears/pig/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.features["ears"] = "None"
		H.dna.species.mutant_bodyparts -= "ears"
		H.update_body()

/obj/item/organ/tail/cat/pig
	name = "свинячий хвост"
	desc = "Отрезанный свинячий хвост. Хрю?"
	icon = 'white/valtos/icons/mutant_bodyparts.dmi'
	icon_state = "piggy"
	tail_type = "Pig"

/////////////////////////////////////////////////////////////////////////////////////////
