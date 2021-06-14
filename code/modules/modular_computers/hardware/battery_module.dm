/obj/item/computer_hardware/battery
	name = "Контроллер батареи"
	desc = "Контроллер заряда для стандартных ячеек питания, используемых во всех типах модульных компьютеров."
	icon_state = "cell_con"
	critical = 1
	malfunction_probability = 1
	var/obj/item/stock_parts/cell/battery = null
	device_type = MC_CELL

/obj/item/computer_hardware/battery/get_cell()
	return battery

/obj/item/computer_hardware/battery/New(loc, battery_type = null)
	if(battery_type)
		battery = new battery_type(src)
	..()

/obj/item/computer_hardware/battery/Destroy()
	. = ..()
	QDEL_NULL(battery)

/obj/item/computer_hardware/battery/handle_atom_del(atom/A)
	if(A == battery)
		try_eject(forced = TRUE)
	. = ..()

/obj/item/computer_hardware/battery/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/stock_parts/cell))
		return FALSE

	if(battery)
		to_chat(user, "<span class='warning'>Пытаюсь подключить [I] к <b>[src.name]</b>, но не могу найти куда.</span>")
		return FALSE

	if(I.w_class > holder.max_hardware_size)
		to_chat(user, "<span class='warning'>Эта батарея слишком велика для [holder]!</span>")
		return FALSE

	if(user && !user.transferItemToLoc(I, src))
		return FALSE

	battery = I
	to_chat(user, "<span class='notice'>Подключаю [I] к <b>[src.name]</b>.</span>")

	return TRUE


/obj/item/computer_hardware/battery/try_eject(mob/living/user = null, forced = FALSE)
	if(!battery)
		to_chat(user, "<span class='warning'>Батарея не подключена к <b>[src.name]</b>.</span>")
		return FALSE
	else
		if(user)
			user.put_in_hands(battery)
		else
			battery.forceMove(drop_location())
		to_chat(user, "<span class='notice'>Отсоединяю [battery] от <b>[src.name]</b>.</span>")
		battery = null

		if(holder)
			if(holder.enabled && !holder.use_power())
				holder.shutdown_computer()

		return TRUE







/obj/item/stock_parts/cell/computer
	name = "Стандартная батарея"
	desc = "Стандартный элемент питания, обычно встречающийся в портативных микрокомпьютерах высокого класса или ноутбуках младших моделей."
	icon = 'icons/obj/module.dmi'
	icon_state = "cell_mini"
	w_class = WEIGHT_CLASS_TINY
	maxcharge = 750


/obj/item/stock_parts/cell/computer/advanced
	name = "Усовершенствованная батарея"
	desc = "Усовершенствованная батарея, часто используемая в большинстве ноутбуков. Она слишком велика для установки в устройства меньшего размера."
	icon_state = "cell"
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 1500

/obj/item/stock_parts/cell/computer/super
	name = "Супербаттарея"
	desc = "Усовершенствованная батарея, часто используемая в ноутбуках высокого класса"
	icon_state = "cell"
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 2000

/obj/item/stock_parts/cell/computer/micro
	name = "Микробатарея"
	desc = "Маленькая батарея, обычно используемая в большинстве портативных микрокомпьютеров."
	icon_state = "cell_micro"
	maxcharge = 500

/obj/item/stock_parts/cell/computer/nano
	name = "Нанобатарея"
	desc = "Крошечная батарея, обычно встречающаяся в портативных микрокомпьютерах младших моделей."
	icon_state = "cell_micro"
	maxcharge = 300
