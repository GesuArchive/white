/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

GLOBAL_LIST_EMPTY(req_console_assistance)
GLOBAL_LIST_EMPTY(req_console_supplies)
GLOBAL_LIST_EMPTY(req_console_information)
GLOBAL_LIST_EMPTY(allConsoles)
GLOBAL_LIST_EMPTY(req_console_ckey_departments)


#define REQ_SCREEN_MAIN 			0
#define REQ_SCREEN_REQ_ASSISTANCE 	1
#define REQ_SCREEN_REQ_SUPPLIES 	2
#define REQ_SCREEN_RELAY 			3
#define REQ_SCREEN_WRITE 			4
#define REQ_SCREEN_CHOOSE 			5
#define REQ_SCREEN_SENT 			6
#define REQ_SCREEN_ERR 				7
#define REQ_SCREEN_VIEW_MSGS 		8
#define REQ_SCREEN_AUTHENTICATE 	9
#define REQ_SCREEN_ANNOUNCE 		10

#define REQ_EMERGENCY_SECURITY 1
#define REQ_EMERGENCY_ENGINEERING 2
#define REQ_EMERGENCY_MEDICAL 3

/obj/machinery/requests_console
	name = "консоль запросов"
	desc = "Консоль предназначенная для отправки запросов в различные отделы на станции."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/messages = list() //List of all messages
	var/departmentType = 0 //bitflag
		// 0 = none (not listed, can only replied to)
		// assistance 	= 1
		// supplies 	= 2
		// info 		= 4
		// assistance + supplies 	= 3
		// assistance + info 		= 5
		// supplies + info 			= 6
		// assistance + supplies + info = 7
	var/newmessagepriority = REQ_NO_NEW_MESSAGE
	var/screen = REQ_SCREEN_MAIN
		// 0 = main menu,
		// 1 = req. assistance,
		// 2 = req. supplies
		// 3 = relay information
		// 4 = write msg - not used
		// 5 = choose priority - not used
		// 6 = sent successfully
		// 7 = sent unsuccessfully
		// 8 = view messages
		// 9 = authentication before sending
		// 10 = send announcement
	var/silent = FALSE // set to 1 for it not to beep all the time
	var/hackState = FALSE
	var/announcementConsole = FALSE // FALSE = This console cannot be used to send department announcements, TRUE = This console can send department announcements
	var/open = FALSE // TRUE if open
	var/announceAuth = FALSE //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who verified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = ""
	var/to_department = "" //the department which will be receiving the message
	var/priority = REQ_NO_NEW_MESSAGE //Priority of the message being sent
	var/obj/item/radio/Radio
	var/emergency //If an emergency has been called by this device. Acts as both a cooldown and lets the responder know where it the emergency was triggered from
	var/receive_ore_updates = FALSE //If ore redemption machines will send an update when it receives new ores.
	max_integrity = 300
	armor = list(MELEE = 70, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 0, BIO = 0, RAD = 0, FIRE = 90, ACID = 90)

/obj/machinery/requests_console/directional/north
	dir = SOUTH
	pixel_y = 30

/obj/machinery/requests_console/directional/south
	dir = NORTH
	pixel_y = -30

/obj/machinery/requests_console/directional/east
	dir = WEST
	pixel_x = 30

/obj/machinery/requests_console/directional/west
	dir = EAST
	pixel_x = -30

/obj/machinery/requests_console/update_icon_state()
	if(machine_stat & NOPOWER)
		set_light(0)
	else
		set_light(1.4,0.7,"#34D352")//green light
	if(open)
		if(!hackState)
			icon_state="req_comp_open"
		else
			icon_state="req_comp_rewired"
	else if(machine_stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(emergency || (newmessagepriority == REQ_EXTREME_MESSAGE_PRIORITY))
			icon_state = "req_comp3"
		else if(newmessagepriority == REQ_HIGH_MESSAGE_PRIORITY)
			icon_state = "req_comp2"
		else if(newmessagepriority == REQ_NORMAL_MESSAGE_PRIORITY)
			icon_state = "req_comp1"
		else
			icon_state = "req_comp0"

/obj/machinery/requests_console/Initialize()
	. = ..()
	name = "консоль запросов [skloname(department, VINITELNI, MALE)]"
	GLOB.allConsoles += src

	if(departmentType)

		if((departmentType & REQ_DEP_TYPE_ASSISTANCE) && !(department in GLOB.req_console_assistance))
			GLOB.req_console_assistance += department

		if((departmentType & REQ_DEP_TYPE_SUPPLIES) && !(department in GLOB.req_console_supplies))
			GLOB.req_console_supplies += department

		if((departmentType & REQ_DEP_TYPE_INFORMATION) && !(department in GLOB.req_console_information))
			GLOB.req_console_information += department

	GLOB.req_console_ckey_departments[ckey(department)] = department

	Radio = new /obj/item/radio(src)
	Radio.listening = 0

/obj/machinery/requests_console/Destroy()
	QDEL_NULL(Radio)
	GLOB.allConsoles -= src
	return ..()

/obj/machinery/requests_console/ui_interact(mob/user)
	. = ..()
	var/dat = ""
	if(!open)
		switch(screen)
			if(REQ_SCREEN_MAIN)
				announceAuth = FALSE
				if (newmessagepriority == REQ_NORMAL_MESSAGE_PRIORITY)
					dat += "<div class='notice'>Есть новые сообщения</div><BR>"
				else if (newmessagepriority == REQ_HIGH_MESSAGE_PRIORITY)
					dat += "<div class='notice'>Есть новые <b>ПРИОРИТЕТНЫЕ</b> сообщения</div><BR>"
				else if (newmessagepriority == REQ_EXTREME_MESSAGE_PRIORITY)
					dat += "<div class='notice'>Есть новые <b>НЕВЕРОЯТНО ПРИОРИТЕТНЫЕ</b> сообщения</div><BR>"
				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_VIEW_MSGS]'>Показать сообщения</A><BR><BR>"

				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_REQ_ASSISTANCE]'>Запросить поддержку</A><BR>"
				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_REQ_SUPPLIES]'>Запросить поставки</A><BR>"
				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_RELAY]'>Передача анонимной информации</A><BR><BR>"

				if(!emergency)
					dat += "<A href='?src=[REF(src)];emergency=[REQ_EMERGENCY_SECURITY]'>Экстренный запрос: Служба безопасности</A><BR>"
					dat += "<A href='?src=[REF(src)];emergency=[REQ_EMERGENCY_ENGINEERING]'>Экстренный запрос: Инженерный отдел</A><BR>"
					dat += "<A href='?src=[REF(src)];emergency=[REQ_EMERGENCY_MEDICAL]'>Экстренный запрос: Медицинский отдел</A><BR><BR>"
				else
					dat += "<B><font color='red'>[emergency] была отправлена в это место.</font></B><BR><BR>"

				if(announcementConsole)
					dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_ANNOUNCE]'>Отправить объявление всей станции</A><BR><BR>"
				if (silent)
					dat += "Динамик <A href='?src=[REF(src)];setSilent=0'>ВЫКЛ</A>"
				else
					dat += "Динамик <A href='?src=[REF(src)];setSilent=1'>ВКЛ</A>"
			if(REQ_SCREEN_REQ_ASSISTANCE)
				dat += "Из какого отдела вам нужна помощь?<BR><BR>"
				dat += departments_table(GLOB.req_console_assistance)

			if(REQ_SCREEN_REQ_SUPPLIES)
				dat += "Из какого отдела вам нужны материалы?<BR><BR>"
				dat += departments_table(GLOB.req_console_supplies)

			if(REQ_SCREEN_RELAY)
				dat += "В какой отдел вы хотели бы отправить информацию?<BR><BR>"
				dat += departments_table(GLOB.req_console_information)

			if(REQ_SCREEN_SENT)
				dat += "<span class='good'>Сообщение отправлено.</span><BR><BR>"
				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< Назад</A><BR>"

			if(REQ_SCREEN_ERR)
				dat += "<span class='bad'>Произошла ошибка.</span><BR><BR>"
				dat += "<A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< Назад</A><BR>"

			if(REQ_SCREEN_VIEW_MSGS)
				for (var/obj/machinery/requests_console/Console in GLOB.allConsoles)
					if (Console.department == department)
						Console.newmessagepriority = REQ_NO_NEW_MESSAGE
						Console.update_icon()

				newmessagepriority = REQ_NO_NEW_MESSAGE
				update_icon()
				var/messageComposite = ""
				for(var/msg in messages) // This puts more recent messages at the *top*, where they belong.
					messageComposite = "<div class='block'>[msg]</div>" + messageComposite
				dat += messageComposite
				dat += "<BR><A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< В главное меню</A><BR>"

			if(REQ_SCREEN_AUTHENTICATE)
				dat += "<B>Авторизация сообщения</B><BR><BR>"
				dat += "<b>Сообщение для [to_department]: </b>[message]<BR><BR>"
				dat += "<div class='notice'>Вы можете аутентифицировать свое сообщение сейчас, отсканировав свою ID-карту или свою печать</div><BR>"
				dat += "<b>Утверждено:</b> [msgVerified ? msgVerified : "<i>Не подтверждено</i>"]<br>"
				dat += "<b>Отмечено:</b> [msgStamped ? msgStamped : "<i>Нет штампа</i>"]<br><br>"
				dat += "<A href='?src=[REF(src)];send=[TRUE]'>Отправить сообщение</A><BR>"
				dat += "<BR><A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< Отменить отправку</A><BR>"

			if(REQ_SCREEN_ANNOUNCE)
				dat += "<h3>Объявление всей станции</h3>"
				if(announceAuth)
					dat += "<div class='notice'>Авторизация принята</div><BR>"
				else
					dat += "<div class='notice'>Проведите своей картой, чтобы идентифицировать себя</div><BR>"
				dat += "<b>Сообщение: </b>[message ? message : "<i>Нет сообщения</i>"]<BR>"
				dat += "<A href='?src=[REF(src)];writeAnnouncement=1'>[message ? "Изменить" : "Написать"] сообщение</A><BR><BR>"
				if ((announceAuth || isAdminGhostAI(user)) && message)
					dat += "<A href='?src=[REF(src)];sendAnnouncement=1'>Объявить сообщение</A><BR>"
				else
					dat += "<span class='linkOff'>Объявить сообщение</span><BR>"
				dat += "<BR><A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< Назад</A><BR>"

		if(!dat)
			CRASH("No UI for src. Screen var is: [screen]")
		var/datum/browser/popup = new(user, "req_console", "Консоль запросов [department]", 450, 440)
		popup.set_content(dat)
		popup.open()
	return

/obj/machinery/requests_console/proc/departments_table(list/req_consoles)
	var/dat = ""
	dat += "<table width='100%'>"
	for(var/req_dpt in req_consoles)
		if (req_dpt != department)
			dat += "<tr>"
			dat += "<td width='55%'>[req_dpt]</td>"
			dat += "<td width='45%'><A href='?src=[REF(src)];write=[ckey(req_dpt)];priority=[REQ_NORMAL_MESSAGE_PRIORITY]'>Нормальный</A> <A href='?src=[REF(src)];write=[ckey(req_dpt)];priority=[REQ_HIGH_MESSAGE_PRIORITY]'>Высокий</A>"
			if(hackState)
				dat += "<A href='?src=[REF(src)];write=[ckey(req_dpt)];priority=[REQ_EXTREME_MESSAGE_PRIORITY]'>НЕВЕРОЯТНО ВЫСОКИЙ</A>"
			dat += "</td>"
			dat += "</tr>"
	dat += "</table>"
	dat += "<BR><A href='?src=[REF(src)];setScreen=[REQ_SCREEN_MAIN]'><< Назад</A><BR>"
	return dat

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["write"])
		to_department = ckey(reject_bad_text(href_list["write"])) //write contains the string of the receiving department's name

		var/new_message = (to_department in GLOB.req_console_ckey_departments) && stripped_input(usr, "Введите сообщение:", "Ожидание ввода", "", MAX_MESSAGE_LEN)
		if(new_message)
			to_department = GLOB.req_console_ckey_departments[to_department]
			message = new_message
			screen = REQ_SCREEN_AUTHENTICATE
			priority = clamp(text2num(href_list["priority"]), REQ_NORMAL_MESSAGE_PRIORITY, REQ_EXTREME_MESSAGE_PRIORITY)

	if(href_list["writeAnnouncement"])
		var/new_message = reject_bad_text(stripped_input(usr, "Введите сообщение:", "Ожидание ввода", "", MAX_MESSAGE_LEN))
		if(new_message)
			message = new_message
			priority = clamp(text2num(href_list["priority"]) || REQ_NORMAL_MESSAGE_PRIORITY, REQ_NORMAL_MESSAGE_PRIORITY, REQ_EXTREME_MESSAGE_PRIORITY)
		else
			message = ""
			announceAuth = FALSE
			screen = REQ_SCREEN_MAIN

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)
			return
		if(!(announceAuth || isAdminGhostAI(usr)))
			return
		if(isliving(usr))
			var/mob/living/L = usr
			message = L.treat_message(message)
		minor_announce(message, "[department] делает объявление", html_encode = FALSE)
		GLOB.news_network.SubmitArticle(message, department, "Станционные Объявления", null)
		usr.log_talk(message, LOG_SAY, tag="station announcement from [src]")
		message_admins("[ADMIN_LOOKUPFLW(usr)] has made a station announcement from [src] at [AREACOORD(usr)].")
		deadchat_broadcast(" делает оповещение <span class='name'>[get_area_name(usr, TRUE)]</span>.", span_name("[usr.real_name]") , usr, message_type=DEADCHAT_ANNOUNCEMENT)
		announceAuth = FALSE
		message = ""
		screen = REQ_SCREEN_MAIN

	if(href_list["emergency"])
		if(!emergency)
			var/radio_freq
			switch(text2num(href_list["emergency"]))
				if(REQ_EMERGENCY_SECURITY) //Security
					radio_freq = FREQ_SECURITY
					emergency = "Служба безопасности"
				if(REQ_EMERGENCY_ENGINEERING) //Engineering
					radio_freq = FREQ_ENGINEERING
					emergency = "Инженерная группа"
				if(REQ_EMERGENCY_MEDICAL) //Medical
					radio_freq = FREQ_MEDICAL
					emergency = "Медицинская бригада"
			if(radio_freq)
				Radio.set_frequency(radio_freq)
				Radio.talk_into(src,"[emergency] должна срочно направиться в [department]!!",radio_freq)
				update_icon()
				addtimer(CALLBACK(src, .proc/clear_emergency), 5 MINUTES)

	if(href_list["send"] && message && to_department && priority)

		var/radio_freq
		switch(ckey(to_department))
			if("bridge")
				radio_freq = FREQ_COMMAND
			if("medbay")
				radio_freq = FREQ_MEDICAL
			if("science")
				radio_freq = FREQ_SCIENCE
			if("engineering")
				radio_freq = FREQ_ENGINEERING
			if("security")
				radio_freq = FREQ_SECURITY
			if("cargobay" || "mining")
				radio_freq = FREQ_SUPPLY

		var/datum/signal/subspace/messaging/rc/signal = new(src, list(
			"sender" = department,
			"rec_dpt" = to_department,
			"send_dpt" = department,
			"message" = message,
			"verified" = msgVerified,
			"stamped" = msgStamped,
			"priority" = priority,
			"notify_freq" = radio_freq
		))
		signal.send_to_receivers()

		screen = signal.data["done"] ? REQ_SCREEN_SENT : REQ_SCREEN_ERR

	//Handle screen switching
	if(href_list["setScreen"])
		var/set_screen = clamp(text2num(href_list["setScreen"]) || 0, REQ_SCREEN_MAIN, REQ_SCREEN_ANNOUNCE)
		switch(set_screen)
			if(REQ_SCREEN_MAIN)
				to_department = ""
				msgVerified = ""
				msgStamped = ""
				message = ""
				priority = -1
			if(REQ_SCREEN_ANNOUNCE)
				if(!announcementConsole)
					return
		screen = set_screen

	//Handle silencing the console
	if(href_list["setSilent"])
		silent = text2num(href_list["setSilent"]) ? TRUE : FALSE

	updateUsrDialog()

/obj/machinery/requests_console/say_mod(input, list/message_mods = list())
	if(spantext_char(input, "!", -3))
		return "вспыхивает"
	else
		. = ..()

/obj/machinery/requests_console/proc/clear_emergency()
	emergency = null
	update_icon()

//from message_server.dm: Console.createmessage(data["sender"], data["send_dpt"], data["message"], data["verified"], data["stamped"], data["priority"], data["notify_freq"])
/obj/machinery/requests_console/proc/createmessage(source, source_department, message, msgVerified, msgStamped, priority, radio_freq)
	var/linkedsender

	var/sending = "[message]<br>"
	if(msgVerified)
		sending = "[sending][msgVerified]<br>"
	if(msgStamped)
		sending = "[sending][msgStamped]<br>"

	linkedsender = source_department ? "<a href='?src=[REF(src)];write=[ckey(source_department)]'>[source_department]</a>" : (source || "unknown")

	var/authentic = (msgVerified || msgStamped) && " (Подтверждено)"
	var/alert = "Сообщение от [source][authentic]"
	var/silenced = silent
	var/header = "<b>От:</b> [linkedsender] Получено: [station_time_timestamp()]<BR>"

	switch(priority)
		if(REQ_NORMAL_MESSAGE_PRIORITY)
			if(newmessagepriority < REQ_NORMAL_MESSAGE_PRIORITY)
				newmessagepriority = REQ_NORMAL_MESSAGE_PRIORITY
				update_icon()

		if(REQ_HIGH_MESSAGE_PRIORITY)
			header = "<span class='bad'>Высокий Приоритет</span><BR>[header]"
			alert = "Приоритетное сообщение от [source][authentic]"
			if(newmessagepriority < REQ_HIGH_MESSAGE_PRIORITY)
				newmessagepriority = REQ_HIGH_MESSAGE_PRIORITY
				update_icon()

		if(REQ_EXTREME_MESSAGE_PRIORITY)
			header = "<span class='bad'>!!!Сверхвысокий Приоритет!!!</span><BR>[header]"
			alert = "Сверхприоритетное сообщение от [source][authentic]"
			silenced = FALSE
			if(newmessagepriority < REQ_EXTREME_MESSAGE_PRIORITY)
				newmessagepriority = REQ_EXTREME_MESSAGE_PRIORITY
				update_icon()

	messages += "[header][sending]"

	if(!silenced)
		playsound(src, 'sound/machines/twobeep_high.ogg', 50, TRUE)
		say(alert)

	if(radio_freq)
		Radio.set_frequency(radio_freq)
		Radio.talk_into(src, "[alert]: <i>[message]</i>", radio_freq)

/obj/machinery/requests_console/attackby(obj/item/O, mob/user, params)
	if(O.tool_behaviour == TOOL_CROWBAR)
		if(open)
			to_chat(user, span_notice("Закрываю панель обслуживания."))
			open = FALSE
		else
			to_chat(user, span_notice("Открываю панель обслуживания."))
			open = TRUE
		update_icon()
		return
	if(O.tool_behaviour == TOOL_SCREWDRIVER)
		if(open)
			hackState = !hackState
			if(hackState)
				to_chat(user, span_notice("Модифицирую проводку."))
			else
				to_chat(user, span_notice("Возвращаю проводку на место."))
			update_icon()
		else
			to_chat(user, span_warning("Надо бы сначала открыть панель обслуживания!"))
		return

	var/obj/item/card/id/ID = O.GetID()
	if(ID)
		if(screen == REQ_SCREEN_AUTHENTICATE)
			msgVerified = "<font color='green'><b>Подтверждено [ID.registered_name] ([ID.assignment])</b></font>"
			updateUsrDialog()
		if(screen == REQ_SCREEN_ANNOUNCE)
			if (ACCESS_RC_ANNOUNCE in ID.access)
				announceAuth = TRUE
			else
				announceAuth = FALSE
				to_chat(user, span_warning("У меня нет авторизации для отправки объявлений!"))
			updateUsrDialog()
		return
	if (istype(O, /obj/item/stamp))
		if(screen == REQ_SCREEN_AUTHENTICATE)
			var/obj/item/stamp/T = O
			msgStamped = span_boldnotice("Штамп от [T.name]")
			updateUsrDialog()
		return
	return ..()

#undef REQ_EMERGENCY_SECURITY
#undef REQ_EMERGENCY_ENGINEERING
#undef REQ_EMERGENCY_MEDICAL

#undef REQ_SCREEN_MAIN
#undef REQ_SCREEN_REQ_ASSISTANCE
#undef REQ_SCREEN_REQ_SUPPLIES
#undef REQ_SCREEN_RELAY
#undef REQ_SCREEN_WRITE
#undef REQ_SCREEN_CHOOSE
#undef REQ_SCREEN_SENT
#undef REQ_SCREEN_ERR
#undef REQ_SCREEN_VIEW_MSGS
#undef REQ_SCREEN_AUTHENTICATE
#undef REQ_SCREEN_ANNOUNCE
