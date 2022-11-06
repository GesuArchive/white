/datum/computer_file/program/notepad
	filename = "notepad"
	filedesc = "Заметки"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "generic"
	extended_desc = "Программа ведения заметок. Можете здесь написать что нибудь."
	size = 2
	tgui_id = "NtosNotepad"
	program_icon = "book"
	usage_flags = PROGRAM_TABLET

	var/written_note = "Congratulations on your station upgrading to the new NtOS and Thinktronic based collaboration effort, \
		bringing you the best in electronics and software since 2467!"

/datum/computer_file/program/notepad/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("UpdateNote")
			written_note = params["newnote"]
			return UI_UPDATE

/datum/computer_file/program/notepad/ui_data(mob/user)
	var/list/data = get_header_data()

	data["note"] = written_note

	return data
