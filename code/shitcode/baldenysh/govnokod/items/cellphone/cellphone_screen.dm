/datum/phonescreen
	var/obj/item/cellphone/myphone

	var/id = "aaa"
	var/name = "sasai kudosai"
	var/rf_menu
	var/lf_menu
	var/default = FALSE
	var/menuitem = TRUE

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

////////////////////////////////////////////////

/datum/phonescreen/main
	id = "main"
	name = "Главная"
	lf_menu = "Меню"
	default = TRUE

/datum/phonescreen/main/lf_act()
	myphone.set_screen("menu")

/datum/phonescreen/main/hang_act()
	return

///////////////////////////////////////////////
/datum/phonescreen/matrixmenu
	var/list/options
	var/ptr_i = 1
	var/ptr_j = 1

/datum/phonescreen/matrixmenu/proc/regen_options()
	options = list(list())

/datum/phonescreen/matrixmenu/screen_data()
	var/list/data = list()
	data["ptr_i"] = ptr_i
	data["ptr_j"] = ptr_j
	regen_options()
	data["options"] = options
	return data

/datum/phonescreen/matrixmenu/dpad_act(button)
	switch(button)
		if("larrow")
			ptr_i--
			if(ptr_i<1)
				ptr_i = options.len
			var/list/SL = options[ptr_i]
			if(ptr_j>SL.len)
				ptr_j = SL.len
		if("rarrow")
			ptr_i++
			if(ptr_i>options.len)
				ptr_i = 1
			var/list/SL = options[ptr_i]
			if(ptr_j>SL.len)
				ptr_j = SL.len
		if("uarrow")
			ptr_j--
			var/list/SL = options[ptr_i]
			if(ptr_j<1)
				ptr_j = SL.len
		if("darrow")
			ptr_j++
			var/list/SL = options[ptr_i]
			if(ptr_j>SL.len)
				ptr_j = 1
		if("enter")
			selected_act(options[ptr_i][ptr_j])

/datum/phonescreen/matrixmenu/proc/selected_act(selection)
	return

/////////////////////////////////////////
//datum/phonescreen/vectormenu



//////////////////////////////////////////
/datum/phonescreen/matrixmenu/menu
	id = "menu"
	name = "Меню"
	lf_menu = "Закрыть"
	default = TRUE

/datum/phonescreen/matrixmenu/menu/lf_act()
	myphone.set_screen("main")

/datum/phonescreen/matrixmenu/menu/regen_options()
	options = list(list())
	var/i = 1
	for(var/scr_id in myphone.screens)
		var/datum/phonescreen/PS = myphone.screens[scr_id]
		if(!PS.menuitem)
			continue
		if(options.len >= i)
			options[i] += list(list(PS.name, PS.id))
		else
			options += list(list(list(PS.name, PS.id)))
		i++
		if(i>3)
			i=1

/datum/phonescreen/matrixmenu/menu/selected_act(selection)
	myphone.set_screen(selection[2])

///////////////////////////

/datum/phonescreen/recent
	id = "recent"
	name = "История"
	lf_menu = "Звонок"
	rf_menu = "Контакты"
	default = TRUE

/datum/phonescreen/recent/call_act()
	return

/datum/phonescreen/recent/lf_act()
	myphone.set_screen("call")
/datum/phonescreen/recent/rf_act()
	myphone.set_screen("contacts")

/datum/phonescreen/contacts
	id = "contacts"
	name = "Контакты"
	lf_menu = "История"
	rf_menu = "Звонок"
	default = TRUE
	menuitem = TRUE

/datum/phonescreen/contacts/call_act()
	return

/datum/phonescreen/contacts/lf_act()
	myphone.set_screen("recent")
/datum/phonescreen/contacts/rf_act()
	myphone.set_screen("call")

/datum/phonescreen/numinput
	id = "call"
	name = "Набор номера"
	lf_menu = "Контакты"
	rf_menu = "История"
	default = TRUE

/datum/phonescreen/numinput/call_act()
	return

/datum/phonescreen/numinput/lf_act()
	myphone.set_screen("contacts")
/datum/phonescreen/numinput/rf_act()
	myphone.set_screen("recent")

/datum/phonescreen/incall
	id = "incall"
	name = "Звонок"
	lf_menu = ""

/datum/phonescreen/incall/hang_act()
	return

/datum/phonescreen/incall/call_act()
	return

///////////////////////////////////////////////
