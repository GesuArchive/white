/datum/phonescreen
	var/obj/item/cellphone/myphone

	var/id = "aaa"
	var/name = "sasai kudosai"
	var/rf_menu
	var/lf_menu
	var/default = TRUE

/datum/phonescreen/proc/screen_data()
	return

/datum/phonescreen/proc/call_act()
	myphone.set_screen("recent")

/datum/phonescreen/proc/hang_act()
	myphone.set_screen("main")

/datum/phonescreen/proc/lf_act()

/datum/phonescreen/proc/rf_act()

/datum/phonescreen/proc/dpad_act(button)

/datum/phonescreen/proc/numpad_act(digit)

/datum/phonescreen/main
	id = "main"
	name = "Главная"
	lf_menu = "Меню"

/datum/phonescreen/main/lf_act()
	myphone.set_screen("menu")

/datum/phonescreen/main/hang_act()
	return

/datum/phonescreen/menu
	id = "menu"
	name = "Меню"
	lf_menu = "Закрыть"
	var/list/options = list(
							list("o1", "o2"),
							list("o2", "o3", "o5"),
							list("Настройки")
							)
	var/ptr_ml = 1 //main list pointer
	var/ptr_sl = 1 //sublist pointer

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

/datum/phonescreen/recent
	id = "recent"
	name = "История"
	lf_menu = ""

/datum/phonescreen/recent/call_act()
	return

/datum/phonescreen/contacts
	id = "contacts"
	name = "Контакты"
	lf_menu = ""

/datum/phonescreen/contacts/call_act()
	return

/datum/phonescreen/numinput
	id = "call"
	name = "Набор номера"
	lf_menu = ""

/datum/phonescreen/numinput/call_act()
	return

/datum/phonescreen/incall
	id = "incall"
	name = "Звонок"
	lf_menu = ""

/datum/phonescreen/incall/hang_act()
	return

/datum/phonescreen/incall/call_act()
	return
