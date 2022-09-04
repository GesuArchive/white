/datum/computer_file/program/crew_manifest
	filename = "plexagoncrew"
	filedesc = "Список экипажа"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Программа для просмотра и печати списка экипажа станции."
	transfer_access = ACCESS_HEADS
	requires_ntnet = TRUE
	size = 4
	tgui_id = "NtosCrewManifest"
	program_icon = "clipboard-list"
	detomatix_resistance = DETOMATIX_RESIST_MAJOR

/datum/computer_file/program/crew_manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = GLOB.data_core.get_manifest()
	return data

/datum/computer_file/program/crew_manifest/ui_data(mob/user)
	var/list/data = get_header_data()

	var/obj/item/computer_hardware/printer/printer
	if(computer)
		printer = computer.all_components[MC_PRINT]

	if(computer)
		data["have_printer"] = !!printer
	else
		data["have_printer"] = FALSE
	return data

/datum/computer_file/program/crew_manifest/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/obj/item/computer_hardware/printer/printer
	if(computer)
		printer = computer.all_components[MC_PRINT]

	switch(action)
		if("PRG_print")
			if(computer && printer) //This option should never be called if there is no printer
				var/contents = {"<h4>Декларация экипажа</h4>
								<br>
								[GLOB.data_core ? GLOB.data_core.get_manifest_html(0) : ""]
								"}
				if(!printer.print_text(contents,text("crew manifest ([])", SSday_night.get_twentyfourhour_timestamp())))
					to_chat(usr, "<span class='notice'>Аппаратная ошибка: принтеру не удалось распечатать файл. Возможно, закончилась бумага.</span>")
					return
				else
					computer.visible_message("<span class='notice'>[computer] распечатывает бумагу.</span>")
