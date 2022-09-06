/obj/item/computer_hardware/printer
	name = "Принтер"
	desc = "Компьютерный принтер с модулем переработки бумаги."
	power_usage = 100
	icon_state = "printer"
	w_class = WEIGHT_CLASS_NORMAL
	device_type = MC_PRINT
	expansion_hw = TRUE
	var/stored_paper = 20
	var/max_paper = 30

/obj/item/computer_hardware/printer/diagnostics(mob/living/user)
	..()
	to_chat(user, span_notice("Уровень бумаги: [stored_paper]/[max_paper]."))

/obj/item/computer_hardware/printer/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Уровень бумаги: [stored_paper]/[max_paper].</span>"


/obj/item/computer_hardware/printer/proc/print_text(text_to_print, paper_title = "")
	if(!stored_paper)
		return FALSE
	if(!check_functionality())
		return FALSE

	var/obj/item/paper/P = new/obj/item/paper(holder.drop_location())

	// Damaged printer causes the resulting paper to be somewhat harder to read.
	if(damage > damage_malfunction)
		P.info = stars(text_to_print, 100-malfunction_probability)
	else
		P.info = text_to_print
	if(paper_title)
		P.name = paper_title
	P.update_icon()
	stored_paper--
	P = null
	return TRUE

/obj/item/computer_hardware/printer/try_insert(obj/item/I, mob/living/user = null)
	if(istype(I, /obj/item/paper))
		if(stored_paper >= max_paper)
			to_chat(user, span_warning("Пытаюсь добавить [I] в [src.name], но буффер бумаги оказывается переполнен!"))
			return FALSE

		if(user && !user.temporarilyRemoveItemFromInventory(I))
			return FALSE
		to_chat(user, span_notice("Вставляю [I] в переработчик бумаги [src.name]."))
		qdel(I)
		stored_paper++
		return TRUE
	return FALSE

/obj/item/computer_hardware/printer/mini
	name = "Минипринтер"
	desc = "Маленький принтер с модулем переработки бумаги."
	power_usage = 50
	icon_state = "printer_mini"
	w_class = WEIGHT_CLASS_TINY
	stored_paper = 5
	max_paper = 15
