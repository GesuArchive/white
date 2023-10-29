/obj/item/implantcase
	name = "кейс микроимпланта"
	desc = "Удобное хранилище для имплантов."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "implantcase-0"
	inhand_icon_state = "implantcase"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/glass=500)
	var/obj/item/implant/imp = null
	var/imp_type


/obj/item/implantcase/update_icon_state()
	. = ..()
	if(imp)
		icon_state = "implantcase-[imp.implant_color]"
	else
		icon_state = "implantcase-0"


/obj/item/implantcase/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("Царапаю что-то на краю <b>[src.name]</b>!"))
			return
		var/t = stripped_input(user, "Что же мы напишем?", name, null)
		if(user.get_active_held_item() != W)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(t)
			name = "микроимплант - '[t]'"
		else
			name = "микроимплант"
	else if(istype(W, /obj/item/implanter))
		var/obj/item/implanter/I = W
		if(I.imp)
			if(imp || I.imp.imp_in)
				return
			I.imp.forceMove(src)
			imp = I.imp
			I.imp = null
			update_icon()
			reagents = imp.reagents
			I.update_icon()
		else
			if(imp)
				if(I.imp)
					return
				imp.forceMove(I)
				I.imp = imp
				imp = null
				reagents = null
				update_icon()
			I.update_icon()

	else
		return ..()

/obj/item/implantcase/Initialize(mapload)
	. = ..()
	if(imp_type)
		imp = new imp_type(src)
	update_icon()
	if(imp)
		reagents = imp.reagents


/obj/item/implantcase/tracking
	name = "микроимплант - 'Слежка'"
	desc = "Содержит имплант для отслеживания позиции."
	imp_type = /obj/item/implant/tracking

/obj/item/implantcase/weapons_auth
	name = "микроимплант - 'Аутентификация на оружие'"
	desc = "Содержит имплант, который дозволяет стрелять из специального оружия."
	imp_type = /obj/item/implant/weapons_auth

/obj/item/implantcase/adrenaline
	name = "микроимплант - 'Адреналин'"
	desc = "Содержит имплант с инъектором адреналина."
	imp_type = /obj/item/implant/adrenalin
