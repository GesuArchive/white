///////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////

/mob/living/carbon/human/species/android/athena
	race = /datum/species/android/athena

/datum/species/android/athena
	name = "Athena"
	mutant_bodyparts = list(/obj/item/bodypart/chest/athena, /obj/item/bodypart/head/athena, /obj/item/bodypart/l_arm/athena, /obj/item/bodypart/r_arm/athena, /obj/item/bodypart/r_leg/athena, /obj/item/bodypart/l_leg/athena)
