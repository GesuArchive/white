GLOBAL_LIST_EMPTY(announcement_systems)

/obj/machinery/announcement_system
	density = TRUE
	name = "АСО"
	desc = "Автоматизированная Система Оповещений делает важные оповещения в радиоканалах, пока ты не трогаешь её своими грязными руками."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "AAS_On"

	verb_say = "холодно констатирует"
	verb_ask = "запрашивает"
	verb_exclaim = "тревожит"

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05

	circuit = /obj/item/circuitboard/machine/announcement_system

	var/obj/item/radio/headset/radio
	var/arrival = "%PERSON прибывает на станцию как %RANK"
	var/arrivalToggle = 1
	var/newhead = "%PERSON, %RANK, глава отдела."
	var/newheadToggle = 1

	var/greenlight = "Light_Green"
	var/pinklight = "Light_Pink"
	var/errorlight = "Error_Red"

/obj/machinery/announcement_system/Initialize(mapload)
	. = ..()
	GLOB.announcement_systems += src
	radio = new /obj/item/radio/headset/silicon/ai(src)
	update_icon()

/obj/machinery/announcement_system/update_icon_state()
	. = ..()
	if(is_operational)
		icon_state = (panel_open ? "AAS_On_Open" : "AAS_On")
	else
		icon_state = (panel_open ? "AAS_Off_Open" : "AAS_Off")

/obj/machinery/announcement_system/update_overlays()
	. = ..()
	if(arrivalToggle)
		. += greenlight

	if(newheadToggle)
		. += pinklight

	if(machine_stat & BROKEN)
		. += errorlight

/obj/machinery/announcement_system/Destroy()
	QDEL_NULL(radio)
	GLOB.announcement_systems -= src //"OH GOD WHY ARE THERE 100,000 LISTED ANNOUNCEMENT SYSTEMS?!!"
	return ..()

/obj/machinery/announcement_system/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_SCREWDRIVER)
		P.play_tool_sound(src)
		toggle_panel_open()
		to_chat(user, span_notice("You [panel_open ? "open" : "close"] the maintenance hatch of [src]."))
		update_icon()
	else if(default_deconstruction_crowbar(P))
		return
	else if(P.tool_behaviour == TOOL_MULTITOOL && panel_open && (machine_stat & BROKEN))
		to_chat(user, span_notice("You reset [src] firmware."))
		set_machine_stat(machine_stat & ~BROKEN)
		update_icon()
	else
		return ..()

/obj/machinery/announcement_system/proc/CompileText(str, user, rank) //replaces user-given variables with actual thingies.
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%RANK", "[ru_job_parse(rank)]")
	return str

/obj/machinery/announcement_system/proc/announce(message_type, user, rank, list/channels)
	if(!is_operational)
		return

	var/message

	if(message_type == "ARRIVAL" && arrivalToggle)
		message = CompileText(arrival, user, rank)
	else if(message_type == "NEWHEAD" && newheadToggle)
		message = CompileText(newhead, user, rank)
	else if(message_type == "CRYOSTORAGE")
		message = "[user][rank ? ", [ru_job_parse(rank)]" : ""] уходит в криосон."

	if(world.time - SSticker.round_start_time > 10)
		for(var/mob/M in GLOB.player_list)
			var/turf/T = get_turf(M)
			if(!isnewplayer(M) && M.can_hear() && (is_station_level(T.z) || is_mining_level(T.z) || is_centcom_level(T.z)))
				SEND_SOUND(M, 'white/valtos/sounds/newmate.ogg')

	use_power(active_power_usage)

	if(channels.len == 0)
		radio.talk_into(src, message, null)
	else
		for(var/channel in channels)
			radio.talk_into(src, message, channel)

/obj/machinery/announcement_system/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedAnnouncement")
		ui.open()

/obj/machinery/announcement_system/ui_data()
	var/list/data = list()
	data["arrival"] = arrival
	data["arrivalToggle"] = arrivalToggle
	data["newhead"] = newhead
	data["newheadToggle"] = newheadToggle
	return data

/obj/machinery/announcement_system/ui_act(action, param)
	. = ..()
	if(.)
		return
	if(!usr.canUseTopic(src, !issilicon(usr)))
		return
	if(machine_stat & BROKEN)
		visible_message(span_warning("[capitalize(src.name)] buzzes.") , span_hear("You hear a faint buzz."))
		playsound(src.loc, 'white/valtos/sounds/error2.ogg', 50, TRUE)
		return
	switch(action)
		if("ArrivalText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, !issilicon(usr)))
				return
			if(NewMessage)
				arrival = NewMessage
				log_game("The arrivals announcement was updated: [NewMessage] by:[key_name(usr)]")
		if("NewheadText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, !issilicon(usr)))
				return
			if(NewMessage)
				newhead = NewMessage
				log_game("The head announcement was updated: [NewMessage] by:[key_name(usr)]")
		if("NewheadToggle")
			newheadToggle = !newheadToggle
			update_icon()
		if("ArrivalToggle")
			arrivalToggle = !arrivalToggle
			update_icon()
	add_fingerprint(usr)

/obj/machinery/announcement_system/attack_robot(mob/living/silicon/user)
	. = attack_ai(user)

/obj/machinery/announcement_system/attack_ai(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[capitalize(src.name)] firmware appears to be malfunctioning!"))
		return
	interact(user)

/obj/machinery/announcement_system/proc/act_up() //does funny breakage stuff
	if(!obj_break()) // if badmins flag this unbreakable or its already broken
		return

	arrival = pick("#!@%ERR-34%2 CANNOT LOCAT@# JO# F*LE!", "CRITICAL ERROR 99.", "ERR)#: DA#AB@#E NOT F(*ND!")
	newhead = pick("OV#RL()D: \[UNKNOWN??\] DET*#CT)D!", "ER)#R - B*@ TEXT F*O(ND!", "AAS.exe is not responding. NanoOS is searching for a solution to the problem.")

/obj/machinery/announcement_system/emp_act(severity)
	. = ..()
	if(!(machine_stat & (NOPOWER|BROKEN)) && !(. & EMP_PROTECT_SELF))
		act_up()

/obj/machinery/announcement_system/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	act_up()
