/datum/phonescreen
	var/obj/item/cellphone/myphone

	var/name = "sasai kudosai"
	var/rf_menu
	var/lf_menu

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
	rf_menu = "Главн"

/datum/phonescreen/menu/rf_act()
	myphone.set_screen("main")
