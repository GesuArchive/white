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

	data["eng_eco_mod"] = GLOB.eng_eco_mod
	data["sci_eco_mod"] = GLOB.sci_eco_mod
	data["med_eco_mod"] = GLOB.med_eco_mod
	data["sec_eco_mod"] = GLOB.sec_eco_mod
	data["srv_eco_mod"] = GLOB.srv_eco_mod
	data["civ_eco_mod"] = GLOB.civ_eco_mod

	data["selflog"] = selflog
	return data

/obj/machinery/computer/price_controller/ui_static_data(mob/user)
	. = ..()
	.["accounts"] = list()
	for(var/B in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/A = B // ???
		.["accounts"] += list(list("id" = A.account_id, "name" = A.account_holder, "balance" = A.account_balance))

/obj/machinery/computer/price_controller/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(params["nalog"] && (text2num(params["nalog"]) > 10 || text2num(params["nalog"]) < 0.5))
		message_admins("[ADMIN_LOOKUPFLW(usr)] попытался выставить налог вне лимитов.")
		return
	switch(action)
		if("change_eng")
			log_self("Изменена ставка налогов для Инженерного отдела.")
			GLOB.eng_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_sci")
			log_self("Изменена ставка налогов для Научного отдела.")
			GLOB.sci_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_med")
			log_self("Изменена ставка налогов для Медицинского отдела.")
			GLOB.med_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_sec")
			log_self("Изменена ставка налогов для отдела Безопасности.")
			GLOB.sec_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_srv")
			log_self("Изменена ставка налогов для Сервисного отдела.")
			GLOB.srv_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_civ")
			log_self("Изменена ставка налогов для Гражданского отдела.")
			GLOB.civ_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("clear_me")
			clear_logs()
			. = TRUE
