// field medic vest

/obj/item/clothing/suit/armor/vest/fieldmedic
	name = "бронежилет полевого медика"
	desc = "Бронированный лабораторный халат полевого медика, обеспечивающий достойную защиту от большинства видов повреждений."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	icon_state = "labcoatsec"
	blood_overlay_type = "coat"
	dog_fashion = /datum/dog_fashion/back


/obj/item/clothing/suit/armor/vest/fieldmedic/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	else
		suit_toggle(user)

/obj/item/clothing/suit/armor/vest/fieldmedic/ui_action_click()
	suit_toggle()

/obj/item/clothing/suit/armor/vest/fieldmedic/proc/suit_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, "<span class='notice'>Расстегиваю [src].</span>")
	if(src.suittoggled)
		src.icon_state = "[initial(icon_state)]"
		src.suittoggled = FALSE
	else if(!src.suittoggled)
		src.icon_state = "[initial(icon_state)]_t"
		src.suittoggled = TRUE
	usr.update_inv_wear_suit()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/suit/armor/vest/fieldmedic/examine(mob/user)
	. = ..()
	. += "<hr>ПКМ по [src] чтобы расстегнуть халат."
