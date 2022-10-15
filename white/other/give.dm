/mob/living/carbon/verb/give_verb()
	set category = "IC"
	set name = "Дать"
	set src in view(1)

	if(src == usr)
		to_chat(usr,span_warning("А?"))
		return

	if(!ismonkey(src)&&!ishuman(src) || isalien(src) || src.stat || usr.stat || !src.client)
		to_chat(usr,span_warning("<b>[capitalize(src)]</b> не может что-то сейчас брать."))
		return

	var/obj/item/I = usr.get_active_held_item()
	if(!I)
		to_chat(usr,span_warning("А у меня в руке ничего и нет, что можно дать <b>[src]</b>."))
		return

	if(!usr.canUnEquip(I))
		return

	var/list/empty_hands = get_empty_held_indexes()
	if(!empty_hands.len)
		to_chat(usr,span_warning("Руки <b>[src]</b> полны."))
		return

	switch(alert(src,"[usr] хочет дать мне [I]. Взять?",,list("Да","Нет")))
		if("Да")
			if(!I || !usr)
				return
			if(!Adjacent(usr))
				to_chat(src,span_warning("Надо бы ближе стоять."))
				to_chat(usr,span_warning("<b>[usr]</b> слишком далеко."))
				return

			if(I != usr.get_active_held_item())
				to_chat(usr,span_warning("Надо бы держать предмет в руке."))
				to_chat(src,span_warning("<b>[usr]</b> не хочет отдавать <b>[I]</b> мне."))
				return

			if(!(src.mobility_flags & MOBILITY_STAND) || src.handcuffed)
				to_chat(usr,span_warning("Руки <b>[src]</b> связаны."))
				return

			empty_hands = get_empty_held_indexes()
			if(!empty_hands.len)
				to_chat(src,span_warning("Мои руки заняты."))
				to_chat(usr,span_warning("Руки <b>[src]</b> заняты."))
				return

			if(!usr.dropItemToGround(I))
				return

			if(!put_in_hands(I))
				to_chat(src,span_warning("Не удалось взять <b>[I]</b>, так что <b>[usr]</b> сдаётся!"))
				to_chat(usr,span_warning("<b>[capitalize(src)]</b> не может взять <b>[I]</b>!"))
				return

			src.visible_message(span_notice("<b>[usr]</b> передаёт <b>[I]</b> <b>[src]</b>."))
		if("Нет")
			src.visible_message(span_warning("<b>[usr]</b> пытается передать <b>[I]</b> <b>[src]</b>, но <b>[src]</b> не хочет брать его."))
