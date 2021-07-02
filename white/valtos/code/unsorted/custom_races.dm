/obj/item/bodypart/var/should_draw_white = FALSE

/mob/living/carbon/proc/draw_white_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_white = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_white = FALSE

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
	species_traits = list(NOBLOOD, NOEYESPRITES)
	mutant_organs = list(/obj/item/organ/tail/cat/oni_android)
	mutant_bodyparts = list("tail_human" = "Oni")

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
