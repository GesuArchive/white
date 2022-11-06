/// Default master server machine state. Use a special screwdriver to get to the next state.
#define HDD_PANEL_CLOSED 0
/// Front master server HDD panel has been removed. Use a special crowbar to get to the next state.
#define HDD_PANEL_OPEN 1
/// Master server HDD has been pried loose and is held in by only cables. Use a special set of wirecutters to finish stealing the objective.
#define HDD_PRIED 2
/// Master server HDD has been cut loose.
#define HDD_CUT_LOOSE 3
/// The ninja has blown the HDD up.
#define HDD_OVERLOADED 4

#define SERVER_NOMINAL_TEXT "<font color='lightgreen'>Nominal</font>"

/obj/machinery/rnd/server
	name = "Сервер РнД"
	desc = "Компьютерная система, работающая на развитой нейронной сети, которая обрабатывает произвольную информацию для получения данных, пригодных для разработки новых технологий. С точки зрения компьютерного ботана, оно производит очки исследований."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "RD-server-on"
	base_icon_state = "RD-server"
	circuit = /obj/item/circuitboard/machine/rdserver
	req_access = list(ACCESS_RD)

	/// if TRUE, we are currently operational and giving out research points.
	var/working = TRUE
	/// if TRUE, someone manually disabled us via console.
	var/research_disabled = FALSE

/obj/machinery/rnd/server/Initialize(mapload)
	. = ..()
	name += " [num2hex(rand(1,65535), -1)]" //gives us a random four-digit hex number as part of the name. Y'know, for fluff.
	SSresearch.servers |= src
	AddElement(/datum/element/traitor_desc, "Эти серверы настолько отсталые, что сгодятся лишь для варки яиц в них. Никто даже не заметит, если я переведу их на систему пассивного охлаждения и саботирую <b>научный отдел</b>. Также, за это мне достанутся 5 телекристаллов.", SABOTAGE_RESEARCH)

/obj/machinery/rnd/server/Destroy()
	SSresearch.servers -= src
	return ..()

/obj/machinery/rnd/server/update_icon_state()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		// "working" will cover EMP'd, disabled, or just broken
		icon_state = "[base_icon_state]-[working ? "on" : "halt"]"
	return ..()

/obj/machinery/rnd/server/power_change()
	refresh_working()
	return ..()

/obj/machinery/rnd/server/on_set_machine_stat()
	refresh_working()
	return ..()

/// Checks if we should be working or not, and updates accordingly.
/obj/machinery/rnd/server/proc/refresh_working()
	if(machine_stat & (NOPOWER|EMPED) || research_disabled)
		working = FALSE
	else
		working = TRUE

	update_current_power_usage()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/rnd/server/emp_act()
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	set_machine_stat(machine_stat | EMPED)
	addtimer(CALLBACK(src, .proc/fix_emp), 60 SECONDS)
	refresh_working()

/// Callback to un-emp the server afetr some time.
/obj/machinery/rnd/server/proc/fix_emp()
	set_machine_stat(machine_stat & ~EMPED)
	refresh_working()

/// Toggles whether or not researched_disabled is, yknow, disabled
/obj/machinery/rnd/server/proc/toggle_disable(mob/user)
	research_disabled = !research_disabled
	user.log_message("[research_disabled ? "shut off" : "turned on"] [src]", LOG_GAME)
	refresh_working()

/// Gets status text based on this server's status for the computer.
/obj/machinery/rnd/server/proc/get_status_text()
	if(machine_stat & EMPED)
		return "<font color=red>O&F@I*$ - R3*&O$T R@U!R%D</font>"
	else if(machine_stat & NOPOWER)
		return "<font color=red>Оффлайн - Нет питания</font>"
	else if(research_disabled)
		return "<font color=red>Оффлайн - Управление отключено</font>"
	else if(!working)
		// If, for some reason, working is FALSE even though we're not emp'd or powerless,
		// We need something to update our working state - such as rebooting the server
		return "<font color=red>Оффлайн - Требуется перезагрузка</font>"

	return SERVER_NOMINAL_TEXT

/obj/machinery/computer/rdservercontrol
	name = "Серверный контроллер РнД"
	desc = "Используется для доступа к серверам производственно-исследовательских баз данных."
	icon_screen = "rdcomp"
	icon_keyboard = "rd_key"
	var/screen = 0
	var/obj/machinery/rnd/server/temp_server
	var/list/servers = list()
	var/list/consoles = list()
	req_access = list(ACCESS_RD)
	var/badmin = 0
	circuit = /obj/item/circuitboard/computer/rdservercontrol

/obj/machinery/computer/rdservercontrol/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)
	if (href_list["toggle"])
		if(allowed(usr) || obj_flags & EMAGGED)
			var/obj/machinery/rnd/server/S = locate(href_list["toggle"]) in SSresearch.servers
			S.toggle_disable(usr)
		else
			to_chat(usr, span_danger("Доступ запрещён."))

	updateUsrDialog()
	return

/obj/machinery/computer/rdservercontrol/ui_interact(mob/user)
	. = ..()
	var/list/dat = list()

	dat += "<b>Серверы:</b>"
	dat += "<table><tr><td style='width:25%'><b>Сервер</b></td><td style='width:25%'><b>Состояние</b></td><td style='width:25%'><b>Управление</b></td>"
	for(var/obj/machinery/rnd/server/server in GLOB.machines)
		var/server_info = ""

		var/status_text = server.get_status_text()
		var/disable_text = server.research_disabled ? "<font color=red>Отключено</font>" : "<font color=lightgreen>Онлайн</font>"

		server_info += "<tr><td style='width:25%'>[server.name]</td>"
		server_info += "<td style='width:25%'>[status_text]</td>"
		server_info += "<td style='width:25%'><a href='?src=[REF(src)];toggle=[REF(server)]'>([disable_text])</a></td><br>"

		dat += server_info

	dat += "</table></br>"

	dat += "<b>Журнал исследований</b></br>"
	var/datum/techweb/stored_research = SSresearch.science_tech
	if(length(stored_research.research_logs))
		dat += "<table BORDER=\"1\">"
		dat += "<tr><td><b>Запись</b></td><td><b>Исследование</b></td><td><b>Стоимость</b></td><td><b>Исследователь</b></td><td><b>Локация</b></td></tr>"
		for(var/i=stored_research.research_logs.len, i>0, i--)
			dat += "<tr><td>[i]</td>"
			for(var/j in stored_research.research_logs[i])
				dat += "<td>[j]</td>"
			dat +="</tr>"
		dat += "</table>"

	else
		dat += "</br>Нет истории."

	var/datum/browser/popup = new(user, "server_com", src.name, 900, 620)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/computer/rdservercontrol/attackby(obj/item/D, mob/user, params)
	. = ..()
	src.updateUsrDialog()

/obj/machinery/computer/rdservercontrol/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	obj_flags |= EMAGGED
	to_chat(user, span_notice("Выключаю протоколы безопасности."))

/// Master R&D server. As long as this still exists and still holds the HDD for the theft objective, research points generate at normal speed. Destroy it or an antag steals the HDD? Half research speed.
/obj/machinery/rnd/server/master
	max_integrity = 1800 //takes roughly ~15s longer to break then full deconstruction.
	circuit = null
	var/obj/item/computer_disk/source_code_hdd
	var/deconstruction_state = HDD_PANEL_CLOSED
	var/front_panel_screws = 4
	var/hdd_wires = 6

/obj/machinery/rnd/server/master/Initialize(mapload)
	. = ..()
	name = "мастер " + name
	desc += "\nВыглядит невероятно защищённым!"
	source_code_hdd = new(src)
	SSresearch.master_servers += src

	add_overlay("RD-server-objective-stripes")

/obj/machinery/rnd/server/master/Destroy()
	if (source_code_hdd && (deconstruction_state == HDD_OVERLOADED))
		QDEL_NULL(source_code_hdd)

	SSresearch.master_servers -= src

	return ..()

/obj/machinery/rnd/server/master/get_status_text()
	. = ..()
	// Give us a special message if we're nominal, but our hard drive is gone
	if(. == SERVER_NOMINAL_TEXT && !source_code_hdd)
		return "<font color=orange>Номинально - Нет жёсткого диска</font>"

/obj/machinery/rnd/server/master/examine(mob/user)
	. = ..()

	switch(deconstruction_state)
		if(HDD_PANEL_CLOSED)
			. += "Фронтальная панель закрыта. На ней есть <b>винтики</b>."
		if(HDD_PANEL_OPEN)
			. += "Фронтальная панель вырвана. Жёсткий диск надёжно закреплён. Я думаю, можно попробовать <b>выломать</b> его."
		if(HDD_PRIED)
			. += "Фронтальная панель вырвана. Жёсткий диск варварски вырван из гнезда. Он всё ещё соединён <b>проводами</b>."
		if(HDD_CUT_LOOSE)
			. += "Фронтальная панель вырвана. Внутри ошмётки металла."
		if(HDD_OVERLOADED)
			. += "Фронтальная панель вырвана. Диск внутри уничтожен, а провода сгорели."

/obj/machinery/rnd/server/master/tool_act(mob/living/user, obj/item/tool, tool_type)
	// Only antags are given the training and knowledge to disassemble this thing.
	if(is_special_character(user))
		return ..()

	if(user.a_intent == INTENT_HARM)
		return FALSE

	balloon_alert(user, "не вижу ничего подозрительного внутри!")
	return TRUE

/obj/machinery/rnd/server/master/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/computer_disk))
		switch(deconstruction_state)
			if(HDD_PANEL_CLOSED)
				balloon_alert(user, "куда вставлять?!")
				return TRUE
			if(HDD_PANEL_OPEN)
				balloon_alert(user, "сложно!")
				return TRUE
			if(HDD_PRIED)
				balloon_alert(user, "не влезает!")
				return TRUE
			if(HDD_CUT_LOOSE)
				balloon_alert(user, "проводов нет!")
				return TRUE
			if(HDD_OVERLOADED)
				balloon_alert(user, "всё внутри сгорело!")
				return TRUE
	return ..()

/obj/machinery/rnd/server/master/screwdriver_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PANEL_CLOSED || user.a_intent == INTENT_HARM)
		return FALSE

	to_chat(user, span_notice("Вижу [front_panel_screws] винтик[front_panel_screws == 1 ? "" : "а"]. Начинаю откручивать [front_panel_screws == 1 ? "его" : "их"]..."))
	while(tool.use_tool(src, user, 7.5 SECONDS, volume=100))
		front_panel_screws--

		if(front_panel_screws <= 0)
			deconstruction_state = HDD_PANEL_OPEN
			to_chat(user, span_notice("Откручиваю последний винтик [src]."))
			add_overlay("RD-server-hdd-panel-open")
			return TRUE
		to_chat(user, span_notice("Винтик ломается как только я его выкручиваю. Осталось [front_panel_screws]..."))
	return TRUE

/obj/machinery/rnd/server/master/crowbar_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PANEL_OPEN || user.a_intent == INTENT_HARM)
		return FALSE

	to_chat(user, span_notice("Внутри виднеется [source_code_hdd]. Пытаюсь вырвать его..."))
	if(tool.use_tool(src, user, 15 SECONDS, volume=100))
		to_chat(user, span_notice("Вырываю [source_code_hdd]."))
		deconstruction_state = HDD_PRIED
	return TRUE

/obj/machinery/rnd/server/master/wirecutter_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PRIED || user.a_intent == INTENT_HARM)
		return FALSE

	to_chat(user, span_notice("Здесь [hdd_wires] подключённы[hdd_wires == 1 ? "й" : "х"] провод[hdd_wires == 1 ? "" : "ов"] к [source_code_hdd]. Начинаю откусывать [hdd_wires == 1 ? "его" : "их"]..."))
	while(tool.use_tool(src, user, 7.5 SECONDS, volume=100))
		hdd_wires--

		if(hdd_wires <= 0)
			deconstruction_state = HDD_CUT_LOOSE
			to_chat(user, span_notice("Откусываю последний провод от [source_code_hdd]."))
			try_put_in_hand(source_code_hdd, user)
			source_code_hdd = null
			SSresearch.mining_multiplier *= 0.5
			GLOB.is_research_sabotaged = TRUE
			return TRUE
		to_chat(user, span_notice("Откусываю провод. [hdd_wires] осталось..."))
	return TRUE

/obj/machinery/rnd/server/master/on_deconstruction()
	// If the machine contains a source code HDD, destroying it will negatively impact research speed. Safest to log this.
	if(source_code_hdd)
		// If there's a usr, this was likely a direct deconstruction of some sort. Extra logging info!
		if(usr)
			var/mob/user = usr

			message_admins("[ADMIN_LOOKUPFLW(user)] deconstructed [ADMIN_JMP(src)].")
			user.log_message("deconstructed [src].", LOG_GAME)
			return ..()

		message_admins("[ADMIN_JMP(src)] has been deconstructed by an unknown user.")
		log_game("[src] has been deconstructed by an unknown user.")

	return ..()

/// Destroys the source_code_hdd if present and sets the machine state to overloaded, adding the panel open overlay if necessary.
/obj/machinery/rnd/server/master/proc/overload_source_code_hdd()
	if(source_code_hdd)
		QDEL_NULL(source_code_hdd)

	if(deconstruction_state == HDD_PANEL_CLOSED)
		add_overlay("RD-server-hdd-panel-open")

	front_panel_screws = 0
	hdd_wires = 0
	deconstruction_state = HDD_OVERLOADED

#undef HDD_PANEL_CLOSED
#undef HDD_PANEL_OPEN
#undef HDD_PRIED
#undef HDD_CUT_LOOSE
