/obj/item/inducer
	name = "индуктор"
	desc = "Инструмент для индуктивной зарядки элементов питания, позволяя заряжать их без необходимости извлечения."
	icon = 'icons/obj/tools.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "inducer-engi"
	inhand_icon_state = "inducer-engi"
	force = 7
	var/powertransfer = 1000
	var/opened = FALSE
	var/cell_type = /obj/item/stock_parts/cell/high
	var/obj/item/stock_parts/cell/cell
	var/recharging = FALSE

/obj/item/inducer/Initialize(mapload)
	. = ..()
	if(!cell && cell_type)
		cell = new cell_type

/obj/item/inducer/proc/induce(obj/item/stock_parts/cell/target, coefficient)
	var/totransfer = min(cell.charge,(powertransfer * coefficient))
	var/transferred = target.give(totransfer)
	cell.use(transferred)
	cell.update_icon()
	target.update_icon()

/obj/item/inducer/get_cell()
	return cell

/obj/item/inducer/emp_act(severity)
	. = ..()
	if(cell && !(. & EMP_PROTECT_CONTENTS))
		cell.emp_act(severity)

/obj/item/inducer/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(cantbeused(user))
		return

	if(recharge(O, user))
		return

	return ..()

/obj/item/inducer/proc/cantbeused(mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("Мне не хватает ловкости для использования [src]!"))
		return TRUE

	if(!cell)
		to_chat(user, span_warning("[capitalize(src.name)] не имеет установленного элемента питания!"))
		return TRUE

	if(!cell.charge)
		to_chat(user, span_warning("[capitalize(src.name)] батарея разряжена!"))
		return TRUE
	return FALSE


/obj/item/inducer/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		W.play_tool_sound(src)
		if(!opened)
			to_chat(user, span_notice("Откручиваю защиту батарейного отсека."))
			opened = TRUE
			update_icon()
			return
		else
			to_chat(user, span_notice("Закручиваю защиту батарейного отсека."))
			opened = FALSE
			update_icon()
			return
	if(istype(W, /obj/item/stock_parts/cell))
		if(opened)
			if(!cell)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, span_notice("Помещаю [W] в [src]."))
				cell = W
				update_icon()
				return
			else
				to_chat(user, span_warning("В [capitalize(src.name)] уже установлена [cell]!"))
				return

	if(cantbeused(user))
		return

	if(recharge(W, user))
		return

	return ..()

/obj/item/inducer/proc/recharge(atom/movable/A, mob/user)
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(recharging)
		return TRUE
	else
		recharging = TRUE
	var/obj/item/stock_parts/cell/C = A.get_cell()
	var/obj/O
	var/coefficient = 1
	if(istype(A, /obj/item/gun/energy))
		to_chat(user, span_alert("Ошибка, не удается подключиться к устройству."))
		return FALSE
	if(istype(A, /obj/item/clothing/suit/space))
		to_chat(user, span_alert("Ошибка, не удается подключиться к устройству."))
		return FALSE
	if(istype(A, /obj))
		O = A
	if(C)
		var/done_any = FALSE
		if(C.charge >= C.maxcharge)
			to_chat(user, span_notice("[A] полностью заряжен!"))
			recharging = FALSE
			return TRUE
		user.visible_message(span_notice("[user] начинает заряжать [A] при помощи [src].") , span_notice("Начинаю заряжать [A] при помощи [src]."))
		while(C.charge < C.maxcharge)
			if(do_after(user, 10, target = user) && cell && cell.charge)
				done_any = TRUE
				induce(C, coefficient)
				do_sparks(1, FALSE, A)
				if(O)
					O.update_icon()
			else
				break
		if(done_any) // Only show a message if we succeeded at least once
			user.visible_message(span_notice("[user] зарядил [A]!") , span_notice("[A] заряжен!"))
		recharging = FALSE
		return TRUE
	recharging = FALSE


/obj/item/inducer/attack(mob/M, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(cantbeused(user))
		return

	if(recharge(M, user))
		return
	return ..()


/obj/item/inducer/attack_self(mob/user)
	if(opened && cell)
		user.visible_message(span_notice("[user] извлекает [cell] из [src]!") , span_notice("Извлекаю [cell]."))
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		update_icon()


/obj/item/inducer/examine(mob/living/M)
	. = ..()
	. += "<hr>"
	if(cell)
		. += span_notice("Его дисплей показывает: [display_energy(cell.charge)].")
	else
		. += span_notice("Его дисплей темный.")
	if(opened)
		. += "<hr><span class='notice'>Его батарейный отсек открыт.</span>"

/obj/item/inducer/update_overlays()
	. = ..()
	if(opened)
		if(!cell)
			. += "inducer-nobat"
		else
			. += "inducer-bat"

/obj/item/inducer/sci
	icon_state = "inducer-sci"
	inhand_icon_state = "inducer-sci"
	desc = "Инструмент для индуктивной зарядки внутренних элементов питания. Этот имеет научную цветовую гамму и менее мощный, чем его инженерный аналог."
	cell_type = null
	powertransfer = 500
	opened = TRUE

/obj/item/inducer/sci/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/inducer/syndicate
	icon_state = "inducer-syndi"
	inhand_icon_state = "inducer-syndi"
	desc = "Инструмент для индуктивной зарядки внутренних элементов питания. Этот имеет подозрительную цветовую гамму и, похоже, приспособлен для передачи заряда с гораздо большей скоростью."
	powertransfer = 2000
	cell_type = /obj/item/stock_parts/cell/super
