/obj/item/storage/box/pillpack
	name = "пачка таблеток"
	desc = "Картонная пачка."
	icon = 'white/baldenysh/icons/obj/pillpack.dmi'
	icon_state = "pillpack"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	illustration = "haloperidol"
	w_class = WEIGHT_CLASS_SMALL
	var/list/blister_list = list()

/obj/item/storage/box/pillpack/Initialize()
	. = ..()
	atom_storage.max_slots = blister_list.len
	atom_storage.set_holdable(list(/obj/item/storage/blister))
	atom_storage.locked = TRUE

/obj/item/storage/box/pillpack/PopulateContents()
	for(var/type in blister_list)
		new type(src)

/obj/item/storage/box/pillpack/attack_self(mob/user)
	if(atom_storage.locked)
		icon_state += "_open"
		user.visible_message(span_notice("[user] открывает [src].") , span_notice("Ты открываешь [src]."))
		atom_storage.locked = FALSE
		if(contents.len)
			return
	else
		icon_state = initial(icon_state)
		user.visible_message(span_notice("[user] закрывает [src].") , span_notice("Ты закрываешь [src]."))
		atom_storage.locked = TRUE
		return

	..()
