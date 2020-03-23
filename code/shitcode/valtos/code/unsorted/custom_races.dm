///////////////////////////////////////////////////////////////
/*
/obj/item/bodypart/chest/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "chest"

/obj/item/bodypart/head/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "head"

/obj/item/bodypart/l_arm/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "l_arm"

/obj/item/bodypart/r_arm/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "r_arm"

/obj/item/bodypart/r_leg/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "r_leg"

/obj/item/bodypart/l_leg/athena
	icon = 'code/shitcode/valtos/icons/hephaestus_athena.dmi'
	icon_state = "l_leg"
*/
///////////////////////////////////////////////////////////////

/obj/item/bodypart/var/should_draw_white = FALSE

/mob/living/carbon/human/species/android/athena
	race = /datum/species/android/athena

/datum/species/android/athena
	name = "Athena"
	should_draw_white = TRUE

/datum/species/android/athena/on_species_gain(mob/living/carbon/C)
	C.draw_white_parts()
	. = ..()

/mob/living/carbon/proc/draw_white_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_white = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_white = FALSE
