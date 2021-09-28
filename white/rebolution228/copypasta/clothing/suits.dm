// field medic vest

/obj/item/clothing/suit/armor/vest/fieldmedic
	name = "бронежилет полевого медика"
	desc = "Бронированный лабораторный халат полевого медика, обеспечивающий достойную защиту от большинства видов повреждений."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	icon_state = "labcoatsec"
	blood_overlay_type = "coat"
	dog_fashion = /datum/dog_fashion/back
	allowed = list(/obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/flashlight, /obj/item/gun/ballistic, /obj/item/gun/energy, /obj/item/kitchen/knife/combat, /obj/item/melee/baton, /obj/item/melee/classic_baton, /obj/item/reagent_containers/spray/pepper, /obj/item/restraints/handcuffs, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/storage/belt/holster/detective, /obj/item/storage/belt/holster/nukie, /obj/item/tank/internals/emergency_oxygen, /obj/item/healthanalyzer, /obj/item/medbot_carrier)

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

	to_chat(usr, span_notice("Расстегиваю [src]."))
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

// black&grey hoodies
// нагло спизжено с /tg/reen

/obj/item/clothing/suit/jacket/hoodie
	name = "черная кофта"
	desc = "Простая черная кофточка. Неплохо защитит от ветра."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	icon_state = "blackhoodie"
	inhand_icon_state = "bluit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/radio)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/jacket/hoodie/grey
	name = "серая кофта"
	desc = "Простая серая кофточка. Неплохо защитит от ветра."
	icon_state = "greyhoodie"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/suit/jacket/hoodie/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	else
		suit_toggle(user)

/obj/item/clothing/suit/jacket/hoodie/ui_action_click()
	suit_toggle()

/obj/item/clothing/suit/jacket/hoodie/proc/suit_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	to_chat(usr, span_notice("Расстегиваю [src]."))
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

/obj/item/clothing/suit/jacket/hoodie/examine(mob/user)
	. = ..()
	. += "<hr>ПКМ по [src] чтобы расстегнуть кофту."


// радужное пончо
// тоже с /tg/reen

/obj/item/clothing/suit/poncho/colorful
	name = "разноцветное пончо"
	desc = "Ваше классическое нерасистское пончо. Этот разноцветный."
	icon = 'white/rebolution228/icons/clothing/suits.dmi'
	worn_icon = 'white/rebolution228/icons/clothing/mob/suits_mob.dmi'
	icon_state = "poncho"
	inhand_icon_state = "clownpriest"
