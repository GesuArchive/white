/obj/machinery/power/apc/proc/get_malf_status(mob/living/silicon/ai/malf)
	if(!istype(malf) || !malf.malf_picker)
		return APC_AI_NO_MALF
	if(malfai != (malf.parent || malf))
		return APC_AI_NO_HACK
	if(occupier == malf)
		return APC_AI_HACK_SHUNT_HERE
	if(istype(malf.loc, /obj/machinery/power/apc))
		return APC_AI_HACK_SHUNT_ANOTHER
	return APC_AI_HACK_NO_SHUNT

/obj/machinery/power/apc/proc/malfhack(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(get_malf_status(malf) != 1)
		return
	if(malf.malfhacking)
		to_chat(malf, span_warning("Уже взламываю энергощиток!"))
		return
	to_chat(malf, span_notice("Начинаю переписывать системы энергощитка. Это займёт некоторое время и практически всю свободную память."))
	malf.malfhack = src
	malf.malfhacking = addtimer(CALLBACK(malf, /mob/living/silicon/ai/.proc/malfhacked, src), 600, TIMER_STOPPABLE)

	var/atom/movable/screen/alert/hackingapc/hacking_apc
	hacking_apc = malf.throw_alert("hackingapc", /atom/movable/screen/alert/hackingapc)
	hacking_apc.target = src

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, span_warning("Нужно выбраться из энергощитка!"))
		return
	if(!malf.can_shunt)
		to_chat(malf, span_warning("Не могу!"))
		return
	if(!is_station_level(z))
		return
	malf.ShutOffDoomsdayDevice()
	occupier = new /mob/living/silicon/ai(src, malf.laws, malf) //DEAR GOD WHY? //IKR????
	occupier.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(occupier.name, "копия энергощитка"))
		occupier.name = "копия энергощитка [malf.name]"
	if(malf.parent)
		occupier.parent = malf.parent
	else
		occupier.parent = malf
	malf.shunted = TRUE
	occupier.eyeobj.name = "[occupier.name] (око ИИ)"
	if(malf.parent)
		qdel(malf)
	for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
		disk_pinpointers.switch_mode_to(TRACK_MALF_AI) //Pinpointer will track the shunted AI
	var/datum/action/innate/core_return/return_action = new
	return_action.Grant(occupier)
	occupier.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!occupier)
		return
	if(occupier.parent && occupier.parent.stat != DEAD)
		occupier.mind.transfer_to(occupier.parent)
		occupier.parent.shunted = FALSE
		occupier.parent.setOxyLoss(occupier.getOxyLoss())
		occupier.parent.cancel_camera()
		qdel(occupier)
		return
	to_chat(occupier, span_danger("Основное ядро повреждено, невозможно вернуться."))
	if(forced)
		occupier.forceMove(drop_location())
		INVOKE_ASYNC(occupier, /mob/living/proc/death)
		occupier.gib()

	if(!occupier.nuking) //Pinpointers go back to tracking the nuke disk, as long as the AI (somehow) isn't mid-nuking.
		for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
			disk_pinpointers.switch_mode_to(TRACK_NUKE_DISK)
			disk_pinpointers.alert = FALSE

/obj/machinery/power/apc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(card.AI)
		to_chat(user, span_warning("[card] уже занята!"))
		return
	if(!occupier)
		to_chat(user, span_warning("Некого забирать из [src]!"))
		return
	if(!occupier.mind || !occupier.client)
		to_chat(user, span_warning("[occupier] не активен или уничтожен!"))
		return
	if(!occupier.parent.stat)
		to_chat(user, span_warning("[occupier] отказывается принимать запросы!") )
		return
	if(transfer_in_progress)
		to_chat(user, span_warning("Уже что-то передаём!"))
		return
	if(interaction != AI_TRANS_TO_CARD || occupier.stat)
		return
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return
	transfer_in_progress = TRUE
	user.visible_message(span_notice("[user] вставляет [card] в [src]..."), span_notice("Протокол передачи активен. Отправляем запрос ИИ для разрешения..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	SEND_SOUND(occupier, sound('sound/misc/notice2.ogg')) //To alert the AI that someone's trying to card them if they're tabbed out
	if(tgui_alert(occupier, "[user] пытается перетащить меня на [card.name]. Соглашаемся?", "Перенос с энергощитка", list("Да - Перенеси меня", "Нет - Оставь меня")) == "Нет - Оставь меня")
		to_chat(user, span_danger("ИИ отклоняет запрос. Процесс завершён."))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		transfer_in_progress = FALSE
		return
	if(user.loc != user_turf)
		to_chat(user, span_danger("Локация изменена. Процесс завершён."))
		to_chat(occupier, span_warning("[user] двигается! Передача отменена."))
		transfer_in_progress = FALSE
		return
	to_chat(user, span_notice("ИИ принимает запрос. Переносим ИИ на [card]..."))
	to_chat(occupier, span_notice("Передача начата. Скоро перенесёмся на [card]."))
	if(!do_after(user, 50, target = src))
		to_chat(occupier, span_warning("[user] помешали! Передача отменена."))
		transfer_in_progress = FALSE
		return
	if(!occupier || !card)
		transfer_in_progress = FALSE
		return
	user.visible_message(span_notice("[user] переносит [occupier] на [card]!"), span_notice("Передача завершена! [occupier] теперь находится на [card]."))
	to_chat(occupier, span_notice("Передача завершена! Теперь я нахожусь в [card.name] [user]."))
	occupier.forceMove(card)
	card.AI = occupier
	occupier.parent.shunted = FALSE
	occupier.cancel_camera()
	occupier = null
	transfer_in_progress = FALSE
	return
