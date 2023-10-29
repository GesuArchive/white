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

	remap_mood(C)

	RegisterSignal(C, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp_act))

/datum/species/android/proc/remap_mood(mob/living/carbon/C)
	set waitfor = FALSE

	var/datum/component/mood/mood = C.GetComponent(/datum/component/mood)
	mood.remove_temp_moods()

	SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "android_base_mood", /datum/mood_event/android_base_mood)

/datum/species/android/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)
		O.brute_reduction = initial(O.brute_reduction)
		O.burn_reduction = initial(O.burn_reduction)

	SEND_SIGNAL(C, COMSIG_CLEAR_MOOD_EVENT, "android_base_mood")
	UnregisterSignal(C, COMSIG_ATOM_EMP_ACT)

/datum/species/android/proc/on_emp_act(mob/living/carbon/human/H, severity)
	SIGNAL_HANDLER

	var/fucky_wucky = ""
	for(var/i in 1 to 30)
		fucky_wucky += "[random_emoji()]"

	to_chat(H, span_notice(readable_corrupted_text(fucky_wucky)))
	SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "android_base_mood", /datum/mood_event/android_emp_mood)

	addtimer(CALLBACK(src, PROC_REF(remap_mood), H), 3 MINUTES)
