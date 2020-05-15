/datum/computer_file/program/ntcad
	filename = "ntcad"
	filedesc = "NTCAD"
	program_icon_state = "generic"
	extended_desc = "sasaikudosai"
	size = 32
	tgui_id = "NtosNTCAD"
	ui_x = 400
	ui_y = 480

/datum/computer_file/program/ntcad/ui_static_data(mob/user)
	var/list/data = list()

	return data

/datum/computer_file/program/ntcad/ui_data(mob/user)
	var/list/data = get_header_data()

	return data

/datum/computer_file/program/ntcad/ui_act(action, params, datum/tgui/ui)
	if(..())
		return

	var/mob/user = usr

	switch(action)
		if("PRG_test")
			to_chat(user, "sasai")
			return TRUE
