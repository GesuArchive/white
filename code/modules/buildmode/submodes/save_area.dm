GLOBAL_VAR_INIT(save_area_executing, FALSE)

/datum/buildmode_mode/save
	key = "save"

	use_corner_selection = TRUE

/datum/buildmode_mode/save/show_help(client/user)
	to_chat(user, span_notice("БЕРИ И ВЫБИРАЙ ЗОНУ ЕБЛАН!"))

/datum/buildmode_mode/save/handle_selected_area(client/user, params)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	if(left_click)
		var/map_name = tgui_input_text(user, "Please select a name for your map", "Buildmode", "")
		if(map_name == "" || GLOB.save_area_executing)
			return
		GLOB.save_area_executing = TRUE
		var/our_map = "//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE\n"
		our_map += convert_map_to_tgm(block(get_turf(cornerA), get_turf(cornerB)))
		var/filedir = file("data/temp.dmm")
		if(fexists(filedir))
			fdel(filedir)
		WRITE_FILE(filedir, "[our_map]")
		user << ftp(filedir)
		fdel(filedir)
		log_game("Map have been saved by [ckey(user)]")
		alert("Area saved successfully.", "Action Successful!", "Ok")
		GLOB.save_area_executing = FALSE
