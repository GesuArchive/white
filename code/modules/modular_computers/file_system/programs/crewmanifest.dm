/datum/computer_file/program/crew_manifest
	filename = "plexagoncrew"
	filedesc = "Список экипажа"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Программа для просмотра и печати списка экипажа станции."
	transfer_access = list(ACCESS_HEADS)
	requires_ntnet = TRUE
	size = 4
	tgui_id = "NtosCrewManifest"
	program_icon = "clipboard-list"
	detomatix_resistance = DETOMATIX_RESIST_MAJOR

/datum/computer_file/program/crew_manifest/ui_static_data(mob/user)
	var/list/data = get_header_data()
	data["manifest"] = GLOB.data_core.get_manifest()
	return data

/datum/computer_file/program/crew_manifest/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("PRG_print")
			if(computer) //This option should never be called if there is no printer
				var/contents = {"<h4>Декларация экипажа</h4>
								<br>
								[GLOB.data_core ? GLOB.data_core.get_manifest_html(0) : ""]
								"}
				if(!computer.print_text(contents,text("crew manifest ([])", station_time_timestamp())))
					to_chat(usr, span_notice("Аппаратная ошибка: принтеру не удалось распечатать файл. Возможно, закончилась бумага."))
					return
				else
					computer.visible_message(span_notice("[computer] распечатывает бумагу."))
