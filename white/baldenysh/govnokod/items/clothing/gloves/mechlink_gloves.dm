/datum/component/mecha_weapon_ripper/gloves
	ripping_time = 1 SECONDS

/obj/item/clothing/gloves/combat/mechlink
	name = "мех-линк перчатки"
	//desc = "Кто же знал, что покраска кончиков пальцев перчаток в зеленый цвет может привести к таким результатам..."
	//icon = 'white/baldenysh/icons/obj/gloves.dmi'
	//icon_state = "mechlink"
	var/datum/component/ripper
	var/datum/component/shooter

/obj/item/clothing/gloves/combat/mechlink/Destroy()
	ripper = null
	return ..()

/obj/item/clothing/gloves/combat/mechlink/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		ripper = H.AddComponent(/datum/component/mecha_weapon_ripper/gloves)

/obj/item/clothing/gloves/combat/mechlink/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		QDEL_NULL(ripper)
