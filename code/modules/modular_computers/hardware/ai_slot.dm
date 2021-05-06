/obj/item/computer_hardware/ai_slot
	name = "Слот интерфейса intelliCard"
	desc = "Модуль, позволяющий этому компьютеру взаимодействовать с наиболее распространенными модулями intelliCard. Необходимо для правильной работы некоторых программ."
	power_usage = 100 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_SMALL
	device_type = MC_AI
	expansion_hw = TRUE

	var/obj/item/aicard/stored_card = null
	var/locked = FALSE

/obj/item/computer_hardware/ai_slot/handle_atom_del(atom/A)
	if(A == stored_card)
		try_eject(forced = TRUE)
	. = ..()

/obj/item/computer_hardware/ai_slot/examine(mob/user)
	. = ..()
	if(stored_card)
		. += "<hr>There appears to be an intelliCard loaded. There appears to be a pinhole protecting a manual eject button. A screwdriver could probably press it."

/obj/item/computer_hardware/ai_slot/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/aicard))
		return FALSE

	if(stored_card)
		to_chat(user, "<span class='warning'>Пытаюсь insert \the [I] into <b>[src.name]</b>, but the slot is occupied.</span>")
		return FALSE
	if(user && !user.transferItemToLoc(I, src))
		return FALSE

	stored_card = I
	to_chat(user, "<span class='notice'>Я вставляю \ [I] в <b>[src.name]</b>.</span>")

	return TRUE


/obj/item/computer_hardware/ai_slot/try_eject(mob/living/user = null, forced = FALSE)
	if(!stored_card)
		to_chat(user, "<span class='warning'>В <b>[src.name]</b> нет карты.</span>")
		return FALSE

	if(locked && !forced)
		to_chat(user, "<span class='warning'>Защитные меры не позволяют вынуть карту до завершения реконструкции...</span>")
		return FALSE

	if(stored_card)
		to_chat(user, "<span class='notice'>Я вытаскивю [stored_card] из [src].</span>")
		locked = FALSE
		if(user)
			user.put_in_hands(stored_card)
		else
			stored_card.forceMove(drop_location())
		stored_card = null

		return TRUE
	return FALSE

/obj/item/computer_hardware/ai_slot/attackby(obj/item/I, mob/living/user)
	if(..())
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, "<span class='notice'>Я нажимаю кнопку ручного извлечения с \[I].</span>")
		try_eject(user, TRUE)
		return
