/obj/item/computer_hardware/battery
	name = "Контроллер батареи"
	desc = "Контроллер заряда для стандартных ячеек питания, используемых во всех типах модульных компьютеров."
	icon_state = "cell_con"
	critical = 1
	malfunction_probability = 1
	var/obj/item/stock_parts/cell/battery
	device_type = MC_CELL

/obj/item/computer_hardware/battery/get_cell()
	return battery

/obj/item/computer_hardware/battery/Initialize(mapload, battery_type)
	. = ..()
	if(battery_type)
		battery = new battery_type(src)

/obj/item/computer_hardware/battery/Destroy()
	if(battery)
		QDEL_NULL(battery)
	return ..()

///What happens when the battery is removed (or deleted) from the module, through try_eject() or not.
/obj/item/computer_hardware/battery/Exited(atom/movable/gone, direction)
	if(battery == gone)
		battery = null
		if(holder?.enabled && !holder.use_power())
			holder.shutdown_computer()
	return ..()

/obj/item/computer_hardware/battery/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/stock_parts/cell))
		return FALSE

	if(battery)
		to_chat(user, span_warning("Пытаюсь подключить [I] к <b>[src.name]</b>, но не могу найти куда."))
		return FALSE

	if(I.w_class > holder.max_hardware_size)
		to_chat(user, span_warning("Эта батарея слишком велика для [holder]!"))
		return FALSE

	if(user && !user.transferItemToLoc(I, src))
		return FALSE

	battery = I
	to_chat(user, span_notice("Подключаю [I] к <b>[src.name]</b>."))

	return TRUE

/obj/item/computer_hardware/battery/try_eject(mob/living/user, forced = FALSE)
	if(!battery)
		to_chat(user, span_warning("Батарея не подключена к <b>[src.name]</b>."))
		return FALSE
	else
		if(user)
			user.put_in_hands(battery)
			to_chat(user, span_notice("You detach <b>[battery]</b> from <b>[src]</b>."))
		else if(holder)
			battery.forceMove(get_turf(holder))
		return TRUE

/obj/item/stock_parts/cell/computer
	name = "Стандартная батарея ПК"
	desc = "Стандартный элемент питания, обычно встречающийся в портативных микрокомпьютерах высокого класса или ноутбуках младших моделей."
	icon = 'icons/obj/module.dmi'
	icon_state = "cell_mini"
	w_class = WEIGHT_CLASS_TINY
	maxcharge = 750

/obj/item/stock_parts/cell/computer/advanced
	name = "Продвинутая батарея ПК"
	desc = "Продвинутая батарея, часто используемая в большинстве ноутбуков. Она слишком велика для установки в устройства меньшего размера."
	icon_state = "cell"
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 1500

/obj/item/stock_parts/cell/computer/super
	name = "Супер баттарея ПК"
	desc = "Продвинутая батарея, часто используемая в ноутбуках высокого класса"
	icon_state = "cell"
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 2000

/obj/item/stock_parts/cell/computer/micro
	name = "Микро батарея ПК"
	desc = "Маленькая батарея, обычно используемая в большинстве портативных микрокомпьютеров."
	icon_state = "cell_micro"
	maxcharge = 500

/obj/item/stock_parts/cell/computer/nano
	name = "Нано батарея ПК"
	desc = "Крошечная батарея, обычно встречающаяся в портативных микрокомпьютерах младших моделей."
	icon_state = "cell_micro"
	maxcharge = 300
