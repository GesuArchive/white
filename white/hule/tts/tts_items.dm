/obj/item/organ/ears/cat/tts
	name = "magical cat ears"
	desc = "ВНИМАНИЕ! С носителем этих ушек разрешается делать что угодно, вплоть до отправки в космос без скафандра!"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	damage_multiplier = 5

/obj/item/organ/ears/cat/tts/Insert(mob/living/carbon/C, special = 0, drop_if_replaced = TRUE)
	..()
	//C?.tts_comp?.creation = TRUE

/obj/item/organ/ears/cat/tts/Remove(mob/living/carbon/C,  special = 0)
	..()
	//C?.tts_comp?.creation = FALSE

/obj/item/organ/ears/cat/tts/attack(mob/living/carbon/C, mob/living/carbon/human/user, obj/target)
	if(C == user && istype(C))
		playsound(user,'sound/effects/singlebeat.ogg',40,1)
		user.temporarilyRemoveItemFromInventory(src, TRUE)
		Insert(user)
	else
		return ..()
