/datum/lobbyscreen
	var/image_file

/datum/lobbyscreen/main
	image_file = 'icons/ts.png'

/datum/lobbyscreen/proc/show_titlescreen(client/C)
	winset(C, "lobbyprotoc", 		      			 "is-disabled=false;is-visible=true")
	C << browse(image_file, 	 	      			 "file=ts.png;display=0")
	C << browse(file('icons/blank_console.png'),     "file=blank_console.png;display=0")
	C << browse(file('html/ts.html'),     			 "window=lobbyprotoc")
	C << output(SStitle.ctt, 						 "lobbyprotoc:set_cons")

/datum/lobbyscreen/proc/hide_titlescreen(client/C)
	if(C?.mob)
		C << browse(null, "window=lobbyprotoc")
		winset(C, "lobbyprotoc", "is-disabled=true;is-visible=false")

/client/proc/send_to_lobby_console(msg)
	src << output(msg, "lobbyprotoc:set_cons")

/client/proc/clear_titlescreen()
	src << output("", "lobbyprotoc:cls")

/client/proc/show_lobby()
	lobbyscreen_image.show_titlescreen(src)

/client/proc/clear_lobby()
	clear_titlescreen()

/client/verb/hide_lobby()
	lobbyscreen_image.hide_titlescreen(src)
