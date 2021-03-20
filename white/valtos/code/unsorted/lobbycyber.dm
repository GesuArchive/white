/datum/lobbyscreen/proc/show_titlescreen(client/C)
	winset(C, "lobbyprotoc", 		      			 "is-disabled=true;is-visible=true")
	C << browse(SStitle.current_lobby_screen, 	 	 "file=ts.png;display=0")
	C << browse(file('icons/blank_console.png'),     "file=blank_console.png;display=0")
	C << browse(file('html/ts.html'),     			 "window=lobbyprotoc")

/datum/lobbyscreen/proc/hide_titlescreen(client/C)
	if(C?.mob)
		C << browse(null, "window=lobbyprotoc")
		winset(C, "lobbyprotoc", "is-disabled=true;is-visible=false")

/datum/lobbyscreen/proc/reload_titlescreen(client/C)
	C << browse(null, "window=lobbyprotoc")
	winset(C, "lobbyprotoc", 		      			 "is-disabled=true;is-visible=true")
	C << browse(SStitle.current_lobby_screen, 	 	 "file=ts.png;display=0")
	C << browse(file('icons/blank_console.png'),     "file=blank_console.png;display=0")
	C << browse(file('html/ts.html'),     			 "window=lobbyprotoc")

/client/proc/send_to_lobby_console(msg)
	src << output(msg, "lobbyprotoc:set_cons")

/client/proc/send_to_lobby_console_now(msg)
	src << output(msg, "lobbyprotoc:set_cons_now")

/client/proc/send_to_lobby_load_pos(val, msg)
	src << output("[val];[msg];", "lobbyprotoc:set_loader_pos")

/client/proc/show_lobby()
	lobbyscreen_image.show_titlescreen(src)

/client/proc/clear_lobby()
	src << output(SStitle.game_loaded, "lobbyprotoc:set_state")
	src << output("", "lobbyprotoc:cls")

/client/verb/lobby_ready()
	set category = null

	src << output(SStitle.game_loaded, 		   "lobbyprotoc:set_state")
	src << output(SStitle.ctt, 				   "lobbyprotoc:set_cons_now")
	src << output("[SStitle.loader_pos];...;", "lobbyprotoc:set_loader_pos")

/client/proc/reload_lobby()
	lobbyscreen_image.reload_titlescreen(src)

/client/verb/hide_lobby()
	lobbyscreen_image.hide_titlescreen(src)

/client/proc/set_lobby_image()
	set category = "Особенное"
	set name = "Картинка в лобби"
	set desc = "Прикол."

	var/img_to_set = input("Выберите файл:", "Файл") as null|file
	if (!isfile(img_to_set))
		return

	message_admins("[key] меняет картинку в лобби.")

	SStitle.current_lobby_screen = img_to_set
	SStitle.update_lobby_screen()
