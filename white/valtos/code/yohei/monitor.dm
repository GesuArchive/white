/obj/lab_monitor/yohei
	name = "Монитор исполнения"
	desc = "Здесь выводятся задания. Стекло всё ещё выглядит не очень крепким..."

	var/obj/item/radio/internal_radio
	var/datum/yohei_task/current_task = null
	var/list/possible_tasks = list()
	var/list/action_guys = list()
	var/mission_mode = null

/obj/lab_monitor/yohei/Initialize(mapload)
	. = ..()
	for(var/path in subtypesof(/datum/yohei_task))
		var/datum/yohei_task/T = path
		possible_tasks += T
	GLOB.yohei_main_controller = src

	internal_radio = new /obj/item/radio(src)
	internal_radio.set_listening(FALSE)
	internal_radio.independent = TRUE
	internal_radio.set_frequency(FREQ_YOHEI)

/obj/lab_monitor/yohei/Destroy(force)
	. = ..()
	QDEL_NULL(internal_radio)
	GLOB.yohei_main_controller = null
	STOP_PROCESSING(SSobj, src)

/obj/lab_monitor/yohei/process(delta_time)
	if(mission_mode == YOHEI_MISSION_HUNT)
		if(current_task)
			check_task_completion(autocheck = TRUE)
			return
		if(!current_task)
			give_new_task()

/**
 * placeholder until we figure out new gamemodes for yoheis
 * which wont be just KILL KIDNAP.
 * now it needs to be only for it to not shit new tasks
 * until first contractor commits himself
 */
/obj/lab_monitor/yohei/proc/init_mission_mode(mode)
	if(!mission_mode)
		mission_mode = mode
		START_PROCESSING(SSobj, src)
		return TRUE
	return FALSE

/obj/lab_monitor/yohei/proc/is_this_target(mob/living/checkmob)
	if(istype(current_task, /datum/yohei_task/kill))
		var/datum/yohei_task/kill/KT = current_task
		if(KT.target == checkmob)
			return TRUE
	return FALSE

/obj/lab_monitor/yohei/proc/give_new_task()
	var/datum/yohei_task/new_task = pick(possible_tasks)
	current_task = new new_task()
	current_task.parent = src
	internal_radio.talk_into(src, "Получено новое задание: [current_task.desc] Награда: [current_task.prize]. Исполнители: [english_list(action_guys)]", FREQ_YOHEI)

/**
 * return true in case if we get rid of task
 * return false otherwise
 */
/obj/lab_monitor/yohei/proc/check_task_completion(autocheck)
	if(autocheck && !current_task.can_autocomplete)
		return FALSE
	if(current_task)
		switch(current_task.check_task(autocheck))
			if(YOHEI_MISSION_COMPLETED)
				internal_radio.talk_into(src, "Задание выполнено. Награда в размере [current_task.prize] выдана. Получение следующего задания...", FREQ_YOHEI)
				for(var/mob/living/carbon/human/H in action_guys)
					///inc_metabalance(H, current_task.prize, reason = "Задание выполнено.")
					SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "killed_innocent") //И скольких жизней это стоило?
					var/obj/item/card/id/cardid = H.get_idcard(FALSE)
					cardid?.registered_account?.adjust_money(rand(5000, 10000))
					var/obj/item/armament_points_card/APC = locate() in H.get_all_gear()
					if(APC)
						APC.points += 10
						APC.update_maptext()
				QDEL_NULL(current_task)
				return TRUE
			if(YOHEI_MISSION_FAILED)
				internal_radio.talk_into(src, "Задание провалено. Награда не выдана. Получение следующего задания...", FREQ_YOHEI)
				QDEL_NULL(current_task)
				return TRUE
			if(YOHEI_MISSION_UNFINISHED)
				return FALSE
	return FALSE

/obj/lab_monitor/yohei/proc/add_to_action_guys(mob/living/user)
	if(is_hired_yohei(user))
		log_admin("[user.ckey] пытался получить задание будучи нанятым.")
		message_admins("[ADMIN_LOOKUPFLW(user)] пытался получить задание будучи нанятым.")
		say("Вы не можете работать по базовому контракту.")
		return FALSE
	if(!(user in action_guys)) // sanity check
		action_guys += user
		internal_radio.talk_into(src, "[user.real_name] был добавлен в список исполнителей задания.", FREQ_YOHEI)
		return TRUE
	return FALSE

/obj/lab_monitor/yohei/proc/remove_from_action_guys(mob/living/user)
	if((user in action_guys))
		action_guys -= user
		internal_radio.talk_into(src, "[user.real_name] был вычеркнут из исполнителей в связи с работой по протоколу 'WhiteHat'.", FREQ_YOHEI)
	else
		internal_radio.talk_into(src, "[user.real_name] начинает работу по протоколу 'WhiteHat'.", FREQ_YOHEI)

/obj/lab_monitor/yohei/AltClick(mob/user)
	. = ..()
	if(!current_task)
		to_chat(user, span_notice("Нечего отменять!"))
		return
	switch(tgui_alert(user, "Ты правда хочешь сменить эту задачу? За это будет наложен штраф!", "Сменить задачу", list("Да", "Нет")))
		if("Да")
			internal_radio.talk_into(src, "Задание отменено [skloname(user.real_name, TVORITELNI, user.gender)]. На подтвердившего отмену наложен штраф. Получение следующего задания...", FREQ_YOHEI)
			//inc_metabalance(user, rand(-15, -5), reason = "Отмена задания.")
			QDEL_NULL(current_task)
			return
		if("Нет")
			return

/obj/lab_monitor/yohei/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/pamk))
		var/obj/item/pamk/P = I
		if(P.charge_left >= 10)
			say("Полевой автоматический медицинский комплект всё ещё имеет заряд. Опустошите его.")
			return ..()
		P.charge_left = 50
		P.update_icon()
		//inc_metabalance(user, -10, reason = "Небольшая жертва.")
		say("Полевой автоматический медицинский комплект был заряжен на половину от максимальной емкости. Приятной работы.")
	else
		return ..()

/obj/lab_monitor/yohei/attack_hand(mob/living/user)
	. = ..()

	if(!current_task && !mission_mode)
		var/static/list/choices = list(
			"Классическая охота" = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "classic"),
			"Помочь событиям" 	 = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "gamemode")
		)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			say("Ничего не выбрано!")
			return

		if(choice == "Классическая охота")
			internal_radio.talk_into(src, "Загружаю стандартное задание...", FREQ_YOHEI)
			add_to_action_guys(user)
			give_new_task()
			init_mission_mode(YOHEI_MISSION_HUNT)
			return
		else
			internal_radio.talk_into(src, "Особых заданий больше НЕТ!", FREQ_YOHEI)
			return

	if(!current_task)
		give_new_task()
		return

	if(current_task && !(user in action_guys))
		add_to_action_guys(user)
		return

	check_task_completion()

/obj/lab_monitor/yohei/examine(mob/user)
	. = ..()
	if(current_task)
		. += "<hr>"
		. += span_notice("<b>Задание:</b> [current_task.desc]")
		. += span_notice("\n<b>Награда:</b> [current_task.prize]")
		. += span_notice("\n<b>Исполнители:</b> [english_list(action_guys)]")
