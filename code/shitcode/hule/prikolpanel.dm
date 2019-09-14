GLOBAL_LIST_INIT(pidorlist, world.file2list("[global.config.directory]/autoeban/pidorlist.fackuobema"))
GLOBAL_LIST_INIT(obembalist, world.file2list("[global.config.directory]/autoeban/obembalist.fackuobema"))

/client/proc/prikol_panel()
	set category = "Debug"
	set name = "Prikol Panel"

	if(!(ckey in GLOB.anonists))
		to_chat(usr,"<span class='warning'>dont touch donbass protivniy pidoras</span>")
		return

	var/list/menu = list("Debug Pidoras Antag", "Exile Obamka Obezyanka", "Prikol Knopka")

	var/selected = input("Main Menu", "PRIKOLPANEL V1.0") as null|anything in menu

	if(!selected)
		return

	switch(selected)
		if("Debug Pidoras Antag")
			var/list/debugmenu = list("Add Pidoras", "Remove Pidoras (rly?)", "Pidoras List")

			var/selected_debug = input("Debug Pidoras Antag", "PRIKOLPANEL V1.0") as null|anything in debugmenu

			if(!selected_debug)
				return

			switch(selected_debug)
				if("Add Pidoras")
					var/pidorasname = input("Enter Pidoras Name", ">ADD PIDORAS") as null|text

					text2file(pidorasname, "[global.config.directory]/autoeban/pidorlist.fackuobema")
					GLOB.pidorlist += pidorasname

				if("Remove Pidoras (rly?)")
					to_chat(usr,"<span class='warning'>A zachem</span>")
					return

				if("Pidoras List")
					for(var/pidor in GLOB.pidorlist)
						to_chat(usr, "[pidor]")

		if("Exile Obamka Obezyanka")
			var/list/exilemenu = list("Exile Obemka", "Remove Obemka", "Obemka List")

			var/selected_exile = input("Exile Obamka Obezyanka", "PRIKOLPANEL V1.0") as null|anything in exilemenu

			if(!selected_exile)
				return

			switch(selected_exile)
				if("Exile Obemka")
					var/obemkaname = input("Enter Obemka Name", ">EXILE OBEMKA") as null|text

					text2file(obemkaname, "[global.config.directory]/autoeban/obembalist.fackuobema")
					GLOB.obembalist += obemkaname

				if("Remove Obemka")
					var/nonobemkaname = input("Enter Obemka Name", ">UNEXILE OBEMKA") as null|anything in GLOB.obembalist

					if(!nonobemkaname)
						return

					GLOB.obembalist -= nonobemkaname

					fdel("[global.config.directory]/autoeban/obembalist.fackuobema")

					for(var/i in GLOB.obembalist)
						text2file(i, "[global.config.directory]/autoeban/obembalist.fackuobema")

				if("Obemka List")
					for(var/obemba in GLOB.obembalist)
						to_chat(usr, "[obemba]")

		if("Prikol Knopka")

			SSmapping.LoadGroup(list(), "MultiZ Debug", "map_files/debug", "multiz.dmm", list(list(ZTRAIT_UP = 1),list(ZTRAIT_UP = 1, ZTRAIT_DOWN = -1), list(ZTRAIT_DOWN = -1)), ZTRAITS_STATION, silent = FALSE)


/client/proc/proverka_na_obemky()
	if(ckey in GLOB.obembalist)
		var/list/csa = CONFIG_GET(keyed_list/cross_server)
		var/pick = pick(csa)
		var/addr = csa[pick]
		winset(src, null, "command=.options")
		src << link("[addr]?redirect=1")
		message_admins("[key] находится под санкциями и был сослан на [pick].")




