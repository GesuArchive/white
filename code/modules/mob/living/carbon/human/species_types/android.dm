/datum/species/android
	name = "андроид"
	id = "android"
	say_mod = "констатирует"
	species_traits = list(
		NOTRANSSTING,
		NOBLOOD
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOMETABOLISM,
		TRAIT_NOLIMBDISABLE,
		TRAIT_TOXIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_GENELESS,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOCLONELOSS,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_CAN_STRIP,
		TRAIT_NOHYDRATION
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	damage_overlay_type = "synth"
	mutanttongue = /obj/item/organ/tongue/robot
	species_language_holder = /datum/language_holder/synthetic
	limbs_id = "synth"
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

/datum/species/android/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE)
		O.brute_reduction = 3
		O.burn_reduction = 2

	// Androids don't eat, hunger or metabolise foods. Let's do some cleanup.
	C.set_safe_hunger_level()

/datum/species/android/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)
		O.brute_reduction = initial(O.brute_reduction)
		O.burn_reduction = initial(O.burn_reduction)
