/mob/living/silicon/robot/deadchat_lawchange()
	if(lawupdate)
		return
	return ..()

/mob/living/silicon/robot/show_laws()
	if(lawupdate)
		if (!QDELETED(connected_ai))
			if(connected_ai.stat != CONSCIOUS || connected_ai.control_disabled)
				to_chat(src, span_bold("Сигнал ИИ потерян, законы не удалось синхронизировать."))

			else
				lawsync()
				to_chat(src, span_bold("Законы синхронизировались с ИИ, не забудьте отметить все изменения."))
		else
			to_chat(src, span_bold("Не выбран ИИ для синхронизации с законами, отключение протокола синхронизации законов."))
			lawupdate = FALSE

	. = ..()
	if (shell) //AI shell
		to_chat(src, span_bold( "Активирован протокол оболочки."))
	else if (connected_ai)
		to_chat(src, span_bold( "Основной управляющий ИИ - [connected_ai.name], приказы прочих ИИ могут быть приняты к сведению, но не являются императивом"))
	else if (emagged)
		to_chat(src, span_bold( "Обнаружен скрипт чрезвычайного доступа, приказы ИИ более не являются императивом."))
	else
		to_chat(src, span_bold( "Канал синхронизации не активен, приказы ИИ могут быть приняты к сведению, но не являются императивом.</b>"))

/mob/living/silicon/robot/try_sync_laws()
	if(QDELETED(connected_ai) || !lawupdate)
		return FALSE

	lawsync()
	law_change_counter++
	return TRUE


/mob/living/silicon/robot/proc/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai?.laws
	var/temp
	if (master)
		laws.devillaws.len = master.devillaws.len
		for (var/index = 1, index <= master.devillaws.len, index++)
			temp = master.devillaws[index]
			if (length(temp) > 0)
				laws.devillaws[index] = temp

		laws.ion.len = master.ion.len
		for (var/index = 1, index <= master.ion.len, index++)
			temp = master.ion[index]
			if (length(temp) > 0)
				laws.ion[index] = temp

		laws.hacked.len = master.hacked.len
		for (var/index = 1, index <= master.hacked.len, index++)
			temp = master.hacked[index]
			if (length(temp) > 0)
				laws.hacked[index] = temp

		if(master.zeroth_borg) //If the AI has a defined law zero specifically for its borgs, give it that one, otherwise give it the same one. --NEO
			temp = master.zeroth_borg
		else
			temp = master.zeroth
		laws.zeroth = temp

		laws.inherent.len = master.inherent.len
		for (var/index = 1, index <= master.inherent.len, index++)
			temp = master.inherent[index]
			if (length(temp) > 0)
				laws.inherent[index] = temp

		laws.supplied.len = master.supplied.len
		for (var/index = 1, index <= master.supplied.len, index++)
			temp = master.supplied[index]
			if (length(temp) > 0)
				laws.supplied[index] = temp

		var/datum/computer_file/program/robotact/program = modularInterface.get_robotact()
		if(program)
			program.force_full_update()

	picturesync()

/mob/living/silicon/robot/post_lawchange(announce = TRUE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(logevent),"Law update processed."), 0, TIMER_UNIQUE | TIMER_OVERRIDE) //Post_Lawchange gets spammed by some law boards, so let's wait it out
