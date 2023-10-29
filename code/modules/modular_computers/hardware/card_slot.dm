/obj/item/computer_hardware/card_slot
	name = "Слот ID-карты"	// \improper breaks the find_hardware_by_name proc
	desc = "Модуль, позволяющий этому компьютеру считывать или записывать данные на идентификационные карты. Необходимо для правильной работы некоторых программ."
	power_usage = 10 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_CARD

	var/obj/item/card/id/stored_card
	var/current_identification = null
	var/current_job = null

///What happens when the ID card is removed (or deleted) from the module, through try_eject() or not.
/obj/item/computer_hardware/card_slot/Exited(atom/movable/gone, direction)
	if(stored_card == gone)
		stored_card = null
		if(holder)
			if(holder.active_program)
				holder.active_program.event_idremoved(0)
			for(var/p in holder.idle_threads)
				var/datum/computer_file/program/computer_program = p
				computer_program.event_idremoved(1)

			holder.update_slot_icon()

			if(ishuman(holder.loc))
				var/mob/living/carbon/human/human_wearer = holder.loc
				if(human_wearer.wear_id == holder)
					human_wearer.sec_hud_set_ID()
	return ..()

/obj/item/computer_hardware/card_slot/Destroy()
	if(stored_card) //If you didn't expect this behavior for some dumb reason, do something different instead of directly destroying the slot
		QDEL_NULL(stored_card)
	return ..()

/obj/item/computer_hardware/card_slot/GetAccess()
	var/list/total_access = list()
	if(stored_card)
		total_access = stored_card.GetAccess()
	var/obj/item/computer_hardware/card_slot/card_slot2 = holder?.all_components[MC_CARD2] //Best of both worlds
	if(card_slot2?.stored_card)
		total_access |= card_slot2.stored_card.GetAccess()
	return total_access

/obj/item/computer_hardware/card_slot/GetID()
	if(stored_card)
		return stored_card
	return ..()

/obj/item/computer_hardware/card_slot/RemoveID()
	if(stored_card)
		. = stored_card
		if(!try_eject())
			return null
		return

/obj/item/computer_hardware/card_slot/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/card/id))
		return FALSE

	if(stored_card)
		return FALSE

	// item instead of player is checked so telekinesis will still work if the item itself is close
	if(!in_range(src, I))
		return FALSE

	if(user)
		if(!user.transferItemToLoc(I, src))
			return FALSE
	else
		I.forceMove(src)

	stored_card = I
	to_chat(user, span_notice("Вставляю <b>[I]</b> в <b>[expansion_hw ? "вторичный":"первичный"]</b> [src]."))
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	holder.update_appearance()

	current_identification = stored_card.registered_name
	current_job = stored_card.assignment

	var/holder_loc = holder.loc
	if(ishuman(holder_loc))
		var/mob/living/carbon/human/human_wearer = holder_loc
		if(human_wearer.wear_id == holder)
			human_wearer.sec_hud_set_ID()
	holder.update_slot_icon()

	return TRUE


/obj/item/computer_hardware/card_slot/try_eject(mob/living/user = null, forced = FALSE)
	if(!stored_card)
		to_chat(user, span_warning("Нет карт внутри <b>[src]</b>."))
		return FALSE

	if(user && !issilicon(user) && in_range(src, user))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(drop_location())

	to_chat(user, span_notice("Извлекаю карту из <b>[src.name]</b>."))
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	holder?.update_appearance()

	stored_card = null
	current_identification = null
	current_job = null

	return TRUE

/obj/item/computer_hardware/card_slot/attackby(obj/item/I, mob/living/user)
	if(..())
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(stored_card)
			to_chat(user, span_notice("Нажимаю кнопку ручного извлечения с [I]."))
			try_eject(user)
			return
		swap_slot()
		to_chat(user, span_notice("Настраиваю разъем, чтобы он соответствовал [expansion_hw ? "дополнительному слоту" : "основному слоту"]."))

/**
 *Swaps the card_slot hardware between using the dedicated card slot bay on a computer, and using an expansion bay.
*/
/obj/item/computer_hardware/card_slot/proc/swap_slot()
	expansion_hw = !expansion_hw
	if(expansion_hw)
		device_type = MC_CARD2
		name = "Второстепенный модуль RFID-карты"
	else
		device_type = MC_CARD
		name = "Основной модуль RFID-карты"

/obj/item/computer_hardware/card_slot/examine(mob/user)
	. = ..()
	. += "<hr>Коннектор сейчас в режиме [expansion_hw ? "дополнительного слота" : "основного слота компьютера"], но его можно настроить при помощи отвёртки."
	if(stored_card)
		. += "<hr>Что-то уже есть в слоте."

/obj/item/computer_hardware/card_slot/secondary
	name = "Второстепенный модуль RFID-карты"
	device_type = MC_CARD2
	expansion_hw = TRUE
