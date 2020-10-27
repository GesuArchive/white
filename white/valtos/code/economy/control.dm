////////////////////////////////////////////////
//
//
// Терминал управления налогообложением и прочие прелести
//
//
////////////////////////////////////////////////

/obj/machinery/computer/price_controller
	name = "контроллер цен"
	desc = "Используется для искусственных манипуляций внутренним рынком."
	icon_screen = "supply"
	light_color = COLOR_BRIGHT_ORANGE
	circuit = /obj/item/circuitboard/computer/price_controller
	var/selflog = " -- Очищено Системным Администратором -- \n"

/obj/machinery/computer/price_controller/Initialize(mapload, obj/item/circuitboard/C)
	if(!SSeconomy.PC)
		SSeconomy.PC = src
	. = ..()

/obj/machinery/computer/price_controller/Destroy()
	SSeconomy.PC = null
	. = ..()

/obj/machinery/computer/price_controller/proc/log_self(msg)
	selflog += "\[[station_time_timestamp()]\] [msg]\n"

/obj/machinery/computer/price_controller/proc/clear_logs()
	selflog = " -- Очищено Системным Администратором -- \n"

/obj/item/circuitboard/computer/price_controller
	name = "Контроллер цен (Компьютер)"
	icon_state = "supply"
	build_path = /obj/machinery/computer/price_controller

/obj/machinery/computer/price_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EconomyController", name)
		ui.open()

/obj/machinery/computer/price_controller/ui_data(mob/user)
	var/list/data = list()
	var/list/accounts = list()
	data["eng_eco_mod"] = GLOB.eng_eco_mod
	data["sci_eco_mod"] = GLOB.sci_eco_mod
	data["med_eco_mod"] = GLOB.med_eco_mod
	data["sec_eco_mod"] = GLOB.sec_eco_mod
	data["srv_eco_mod"] = GLOB.srv_eco_mod
	data["civ_eco_mod"] = GLOB.civ_eco_mod

	for(var/datum/bank_account/A in SSeconomy.bank_accounts_by_id)
		accounts += list(list("name" = A.account_holder, "balance" = A.account_balance))

	data["accounts"] = accounts
	data["selflog"] = selflog
	return data
