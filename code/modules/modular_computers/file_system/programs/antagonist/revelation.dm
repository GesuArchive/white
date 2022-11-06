/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Откровение"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "hostile"
	extended_desc = "Скрипт уничтожающий все данные на устройстве, на котором он был запущен. Программа может изменять имя любое другое для дополнительной скрытности. После взвода, скрипт уничтожит операционную систему при следующем открытии программы."
	size = 13
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	tgui_id = "NtosRevelation"
	program_icon = "magnet"
	var/armed = 0

/datum/computer_file/program/revelation/on_start(mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(computer)
		if(istype(computer, /obj/item/modular_computer/tablet/integrated)) //If this is a borg's integrated tablet
			var/obj/item/modular_computer/tablet/integrated/modularInterface = computer
			to_chat(modularInterface.silicon_owner, span_userdanger("ОБНАРУЖЕНА ЧИСТКА СИСТЕМЫ/"))
			addtimer(CALLBACK(modularInterface.silicon_owner, /mob/living/silicon/robot/.proc/death), 2 SECONDS, TIMER_UNIQUE)
			return

		computer.visible_message(span_notice("[computer] экран ярко мерцает, и слышно громкое жужжание электричества."))
		computer.enabled = FALSE
		computer.update_appearance()
		var/obj/item/computer_hardware/battery/battery_module = computer.all_components[MC_CELL]
		computer.take_damage(25, BRUTE, 0, 0)
		if(battery_module && prob(25))
			qdel(battery_module)
			computer.visible_message(span_notice("Батарея [computer] взрывается дождём из искр."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
			spark_system.start()


/datum/computer_file/program/revelation/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("PRG_arm")
			armed = !armed
			return TRUE
		if("PRG_activate")
			activate()
			return TRUE
		if("PRG_obfuscate")
			var/newname = params["new_name"]
			if(!newname)
				return
			filedesc = newname
			return TRUE


/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/computer_file/program/revelation/ui_data(mob/user)
	var/list/data = get_header_data()

	data["armed"] = armed

	return data
