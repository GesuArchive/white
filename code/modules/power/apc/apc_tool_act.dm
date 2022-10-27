//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/crowbar_act(mob/user, obj/item/crowbar)
	. = TRUE
	if((!opened && opened != APC_COVER_REMOVED) && !(machine_stat & BROKEN))
		if(coverlocked && !(machine_stat & MAINT)) // locked...
			balloon_alert(user, "крышка закрыта!")
			return
		else if(panel_open)
			balloon_alert(user, "провода мешают!")
			return
		else
			opened = APC_COVER_OPENED
			update_appearance()
			return

	if(opened && integration_cog)
		to_chat(user, span_notice("Начинаю вырывать шестерёнку..."))
		crowbar.play_tool_sound(src)
		if(crowbar.use_tool(src, user, 50))
			to_chat(user, span_warning("Вырываю мусор из энергощитка!"))
			QDEL_NULL(integration_cog)
		return

	if((opened && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
		opened = APC_COVER_CLOSED
		coverlocked = TRUE //closing cover relocks it
		balloon_alert(user, "закрываем")
		update_appearance()
		return

	if(!opened || has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	if(terminal)
		balloon_alert(user, "нужно отсоединить провода!")
		return
	crowbar.play_tool_sound(src)
	balloon_alert(user, "удаляем плату")
	if(!crowbar.use_tool(src, user, 50))
		return
	if(has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	has_electronics = APC_ELECTRONICS_MISSING
	if(machine_stat & BROKEN)
		user.visible_message(span_notice("[user.name] ломает плату внутри [name]!"), \
			span_hear("Слышу хруст."))
		balloon_alert(user, "сгоревшая плата ломается")
		return
	else if(obj_flags & EMAGGED)
		obj_flags &= ~EMAGGED
		user.visible_message(span_notice("[user.name] вырывает намагниченную плату из [name]!"))
		balloon_alert(user, "намагниченная плата улетает")
		return
	else if(malfhack)
		user.visible_message(span_notice("[user.name] вырывает странно перепрограммированную плату из [name]!"))
		balloon_alert(user, "перепрограммированная плата улетает")
		malfai = null
		malfhack = 0
		return
	user.visible_message(span_notice("[user.name] вытаскивает плату из [name]!"))
	balloon_alert(user, "удаляем плату")
	new /obj/item/electronics/apc(loc)
	return

/obj/machinery/power/apc/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	. = TRUE

	if(!opened)
		if(obj_flags & EMAGGED)
			balloon_alert(user, "интерфейс повреждён!")
			return
		panel_open = !panel_open
		balloon_alert(user, "провода [panel_open ? "видны" : "не видны"]")
		update_appearance()
		return

	if(cell)
		user.visible_message(span_notice("[user] вытаскивает [cell] из [src]!"))
		balloon_alert(user, "батарея удалена")
		var/turf/user_turf = get_turf(user)
		cell.forceMove(user_turf)
		cell.update_appearance()
		cell = null
		charging = APC_NOT_CHARGING
		update_appearance()
		return

	switch (has_electronics)
		if(APC_ELECTRONICS_INSTALLED)
			has_electronics = APC_ELECTRONICS_SECURED
			set_machine_stat(machine_stat & ~MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "плата прикручена")
		if(APC_ELECTRONICS_SECURED)
			has_electronics = APC_ELECTRONICS_INSTALLED
			set_machine_stat(machine_stat | MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "плата откручена")
		else
			balloon_alert(user, "внутри нет платы!")
			return
	update_appearance()

/obj/machinery/power/apc/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(terminal && opened)
		terminal.dismantle(user, W)
		return TRUE

/obj/machinery/power/apc/welder_act(mob/living/user, obj/item/welder)
	. = ..()
	if(!opened || has_electronics || terminal)
		return
	if(!welder.tool_start_check(user, amount=3))
		return
	user.visible_message(span_notice("[user.name] заваривает [src]."), \
						span_hear("Слышу сварку."))
	balloon_alert(user, "варим рамку энергощитка")
	if(!welder.use_tool(src, user, 50, volume=50, amount=3))
		return
	if((machine_stat & BROKEN) || opened==APC_COVER_REMOVED)
		new /obj/item/stack/sheet/iron(loc)
		user.visible_message(span_notice("[user.name] разрезает [src] на куски используя [welder]."))
		balloon_alert(user, "разбираю повреждённую рамку")
	else
		new /obj/item/wallframe/apc(loc)
		user.visible_message(span_notice("[user.name] отрезает [src] от стены используя [welder]."))
		balloon_alert(user, "отрезаю рамку от стены")
	qdel(src)
	return TRUE

/obj/machinery/power/apc/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "плата сильно повреждена!")
			return FALSE
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "нет платы!")
			return FALSE
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 50, "cost" = 10) //16 for a wall

	balloon_alert(user, "уже всё имеет!")
	return FALSE

/obj/machinery/power/apc/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(!(passed_mode & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return FALSE
	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "рамка сильно повреждена!")
			return
		user.visible_message(span_notice("[user] создаёт микросхему и впихивает в [src]."))
		balloon_alert(user, "плата управления установлена")
		has_electronics = TRUE
		locked = TRUE
		return TRUE

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "не имеет платы для батареи!")
			return FALSE
		var/obj/item/stock_parts/cell/crap/empty/C = new(src)
		C.forceMove(src)
		cell = C
		chargecount = 0
		user.visible_message(span_notice("[user] создаёт новую кривую батарейку и впихивает в [src]."), \
		span_warning("Мой [the_rcd.name] крякает и пукает, прежде чем вставляет батарейку в [src]!"))
		update_appearance()
		return TRUE

	balloon_alert(user, "уже всё имеет!")
	return FALSE

/obj/machinery/power/apc/emag_act(mob/user)
	if((obj_flags & EMAGGED) || malfhack)
		return

	if(opened)
		balloon_alert(user, "нужно закрыть крышку!")
	else if(panel_open)
		balloon_alert(user, "нужно закрыть панель!")
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "ничего не происходит")
	else
		flick("apc-spark", src)
		playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		obj_flags |= EMAGGED
		locked = FALSE
		balloon_alert(user, "взламываю энергощиток")
		update_appearance()

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		if(cell)
			cell.emp_act(severity)
		if(occupier)
			occupier.emp_act(severity)
	if(. & EMP_PROTECT_SELF)
		return
	lighting = APC_CHANNEL_OFF
	equipment = APC_CHANNEL_OFF
	environ = APC_CHANNEL_OFF
	update_appearance()
	update()
	addtimer(CALLBACK(src, .proc/reset, APC_RESET_EMP), 600)

/obj/machinery/power/apc/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "интерфейс повреждён!")
	else if(opened)
		balloon_alert(user, "нужно закрыть крышку!")
	else if(panel_open)
		balloon_alert(user, "нужно закрыть панель!")
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "ничего не происходит!")
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN) && !malfhack && !remote_control_user)
			locked = !locked
			balloon_alert(user, "энергощиток [ locked ? "заблокирован" : "разблокирован"]")
			update_appearance()
			if(!locked)
				ui_interact(user)
		else
			balloon_alert(user, "доступ запрещён!")
