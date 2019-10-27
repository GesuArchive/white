/obj/item/organ/ears/cat/tts
	name = "magical cat ears"
	desc = "ВНИМАНИЕ!!! Носителя этих ушек разрешается хуярить в крит, сажать в пермабриг или пермагулаг и ловить с целью отрезать эти ушки."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	damage_multiplier = 5

/obj/item/organ/ears/cat/tts/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(H.TTS)
		H.TTS.createtts = 1

/obj/item/organ/ears/cat/tts/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(H.TTS)
		H.TTS.createtts = 0

/obj/item/organ/ears/cat/tts/attack(mob/living/carbon/human/H, mob/living/carbon/human/user, obj/target)
	if(H == user && istype(H))
		playsound(user,'sound/effects/singlebeat.ogg',40,1)
		user.temporarilyRemoveItemFromInventory(src, TRUE)
		Insert(user)
	else
		return ..()
