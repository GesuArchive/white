/datum/phonescreen
	var/obj/item/cellphone/myphone

	var/name = "sasai kudosai"
	var/rf_menu
	var/lf_menu

/datum/phonescreen/proc/screen_data()
	return

/datum/phonescreen/proc/call_act()

/datum/phonescreen/proc/hang_act()

/datum/phonescreen/proc/lf_act()

/datum/phonescreen/proc/rf_act()

/datum/phonescreen/proc/dpad_act(button)

/datum/phonescreen/proc/numpad_act(digit)

/datum/phonescreen/main
	name = "main"
	lf_menu = "Меню"

/datum/phonescreen/main/lf_act()
	myphone.set_screen("menu")

/datum/phonescreen/menu
	name = "menu"
	lf_menu = "Закрыть"
	var/list/options = list(
							list("o1", "o2"),
							list("o2", "o3", "o5"),
							list("Настройки")
							)
	var/ptr_ml = 1 //main list
	var/ptr_sl = 1 //sublist

/datum/phonescreen/menu/screen_data()
	return list("options" = options, "ptr_ml" = ptr_ml, "ptr_sl" = ptr_sl)

/datum/phonescreen/menu/lf_act()
	myphone.set_screen("main")

/datum/phonescreen/menu/dpad_act(button)
	switch(button)
		if("larrow")
			ptr_ml--
			if(ptr_ml<1)
				ptr_ml = options.len
			var/list/SL = options[ptr_ml]
			if(ptr_sl>SL.len)
				ptr_sl = SL.len
		if("rarrow")
			ptr_ml++
			if(ptr_ml>options.len)
				ptr_ml = 1
			var/list/SL = options[ptr_ml]
			if(ptr_sl>SL.len)
				ptr_sl = SL.len
		if("uarrow")
			ptr_sl--
			var/list/SL = options[ptr_ml]
			if(ptr_sl<1)
				ptr_sl = SL.len
		if("darrow")
			ptr_sl++
			var/list/SL = options[ptr_ml]
			if(ptr_sl>SL.len)
				ptr_sl = 1
		if("enter")
			return
