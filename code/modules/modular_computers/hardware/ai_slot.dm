/obj/item/computer_hardware/ai_slot
	name = "Слот Интелкарты ИИ"
	desc = "Модуль, позволяющий этому компьютеру взаимодействовать с наиболее распространенными модулями Интелкарт. Необходимо для правильной работы некоторых программ."
	power_usage = 100 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_SMALL
	device_type = MC_AI
	expansion_hw = TRUE

	var/obj/item/aicard/stored_card
	var/locked = FALSE

///What happens when the intellicard is removed (or deleted) from the module, through try_eject() or not.
/obj/item/computer_hardware/ai_slot/Exited(atom/movable/gone, direction)
	if(stored_card == gone)
		stored_card = null
	return ..()

/obj/item/computer_hardware/ai_slot/examine(mob/user)
	. = ..()
	if(stored_card)
		. += "<hr>Здесь уже загружена intelliCard. Есть небольшая щель для возможность вытащить её. Отвёртка, возможно, подойдёт."

/obj/item/computer_hardware/ai_slot/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/aicard))
		return FALSE

	if(stored_card)
		to_chat(user, span_warning("Пытаюсь вставить [I] в <b>[src.name]</b>, но слот уже занят."))
		return FALSE
	if(user && !user.transferItemToLoc(I, src))
		return FALSE

	stored_card = I
	to_chat(user, span_notice("Вставляю [I] в <b>[src.name]</b>."))

	return TRUE


/obj/item/computer_hardware/ai_slot/try_eject(mob/living/user = null, forced = FALSE)
	if(!stored_card)
		to_chat(user, span_warning("В <b>[src.name]</b> нет карты."))
		return FALSE

	if(locked && !forced)
		to_chat(user, span_warning("Защитные меры не позволяют вынуть карту до завершения реконструкции..."))
		return FALSE

	if(stored_card)
		to_chat(user, span_notice("Вытаскивю [stored_card] из [src]."))
		locked = FALSE
		if(Adjacent(user))
			user.put_in_hands(stored_card)
		else
			stored_card.forceMove(drop_location())

		return TRUE
	return FALSE

/obj/item/computer_hardware/ai_slot/attackby(obj/item/I, mob/living/user)
	if(..())
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, span_notice("Нажимаю кнопку ручного извлечения с [I]."))
		try_eject(user, TRUE)
		return
