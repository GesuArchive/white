/datum/computer_file/program/ntcad
	filename = "ntcad"
	filedesc = "NTCAD"
	program_icon_state = "id"
	extended_desc = "sasaikudasai"
	size = 32
	tgui_id = "NTCAD"
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
