GLOBAL_LIST_INIT(pidorlist, world.file2list("[global.config.directory]/autoeban/pidorlist.fackuobema"))

/client/proc/prikol_panel()
	set category = "Debug"
	set name = "Prikol Panel"

	if(!(ckey in GLOB.anonists))
		to_chat(usr,"<span class='warning'>dont touch donbass protivniy pidoras</span>")
		return

	var/list/menu = list("Cancel", "Debug Pidoras Antag")

	var/selected = input("Main Menu", "PRIKOLPANEL V1.0", "Cancel") as null|anything in menu

	switch(selected)
		if("Cancel")
			return

		if("Debug Pidoras Antag")
			var/list/debugmenu = list("Cancel", "Add Pidoras", "Remove Pidoras (rly?)", "Pidoras List")

			var/selected_debug = input("Debug Pidoras Antag", "PRIKOLPANEL V1.0", "Cancel") as null|anything in debugmenu

			switch(selected_debug)
				if("Cancel")
					return

				if("Add Pidoras")
					var/pidorasname = input("Enter Pidoras Name", ">ADD PIDORAS", null) as null|text

					text2file(pidorasname, "[global.config.directory]/autoeban/pidorlist.fackuobema")
					GLOB.pidorlist += pidorasname

				if("Remove Pidoras (rly?)")
					to_chat(usr,"<span class='warning'>A zachem</span>")
					return

				if("Pidoras List")
					for(var/pidor in GLOB.pidorlist)
						to_chat(usr, "[pidor]")





