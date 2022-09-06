
/obj/proc/is_modular_computer()
	return FALSE

//item
/obj/item/modular_computer/is_modular_computer()
	return TRUE

//machine
/obj/machinery/modular_computer/is_modular_computer()
	return TRUE

/obj/proc/get_modular_computer_part(part_type)
	return null

//item
/obj/item/modular_computer/get_modular_computer_part(part_type)
	if(!part_type)
		stack_trace("get_modular_computer_part() called without a valid part_type")
		return null
	return all_components[part_type]

//machine
/obj/machinery/modular_computer/get_modular_computer_part(part_type)
	if(!part_type)
		stack_trace("get_modular_computer_part() called without a valid part_type")
		return null
	return cpu?.all_components[part_type]

/obj/proc/get_modular_computer_parts_examine(mob/user)
	. = list()
	if(!is_modular_computer())
		return

	var/user_is_adjacent = Adjacent(user) //don't reveal full details unless they're close enough to see it on the screen anyway.

	var/obj/item/computer_hardware/ai_slot/ai_slot = get_modular_computer_part(MC_AI)
	if(ai_slot)
		if(ai_slot.stored_card)
			if(user_is_adjacent)
				. += "<hr>Здесь установлен слот для Интелкарты, в котором установлен: [ai_slot.stored_card.name]"
			else
				. += "<hr>Здесь установлен слот для Интелкарты, который пуст."
			. += "<hr><span class='info'>ПКМ для извлечения Интелкарты.</span>"
		else
			. += "<hr>Здесь установлен слот для Интелкарты."

	var/obj/item/computer_hardware/card_slot/card_slot = get_modular_computer_part(MC_CARD)
	var/obj/item/computer_hardware/card_slot/card_slot2 = get_modular_computer_part(MC_CARD2)
	var/multiple_slots = istype(card_slot) && istype(card_slot2)
	if(card_slot)
		if(card_slot?.stored_card || card_slot2?.stored_card)
			var/obj/item/card/id/first_ID = card_slot?.stored_card
			var/obj/item/card/id/second_ID = card_slot2?.stored_card
			var/multiple_cards = istype(first_ID) && istype(second_ID)
			if(user_is_adjacent)
				. += "<hr>Здесь [multiple_slots ? "два слота" : "слот"] для ID-карты[multiple_cards ? ", которые содержат [first_ID] и [second_ID]" : ", один из которых содержит [first_ID ? first_ID : second_ID]"]."
			else
				. += "<hr>Здесь [multiple_slots ? "два слота" : "слот"] для ID-карты, [multiple_cards ? "оба из них заняты" : "один из них занят"]."
			. += span_info("\nПКМ для извлечения карт[multiple_cards ? "":"ы"] идентификации.")
		else
			. += "<hr>Здесь [multiple_slots ? "два слота" : "слот"] для ID-карт."

	var/obj/item/computer_hardware/printer/printer_slot = get_modular_computer_part(MC_PRINT)
	if(printer_slot)
		. += "<hr>Здесь есть принтер."
		if(user_is_adjacent)
			. += "\nУровень краски: [printer_slot.stored_paper]/[printer_slot.max_paper].</span>"
