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
	var/list/selflog = list(" -!- Очищено Системным Администратором -!- ")
	var/authed = FALSE
	req_access = list(ACCESS_HEADS)

/obj/machinery/computer/price_controller/Initialize(mapload, obj/item/circuitboard/C)
	if(!SSeconomy.PC)
		SSeconomy.PC = src
	. = ..()

/obj/machinery/computer/price_controller/Destroy()
	SSeconomy.PC = null
	. = ..()

/obj/machinery/computer/price_controller/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if (I.GetID())
		togglelock(user)

/obj/machinery/computer/price_controller/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, !issilicon(user)) || !isturf(loc))
		return
	else
		togglelock(user)

/obj/machinery/computer/price_controller/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("Консоль повреждена!"))
	else if(machine_stat & (BROKEN|MAINT))
		to_chat(user, span_warning("Ничего не происходит!"))
	else
		if(allowed(usr))
			authed = !authed
			to_chat(user, span_notice("Консоль [ authed ? "раз" : "заб"]локирована."))
			update_icon()
			updateUsrDialog()
		else
			to_chat(user, span_warning("В доступе отказано."))

/obj/machinery/computer/price_controller/proc/log_self(msg)
	selflog += "\[[station_time_timestamp()]\] [msg]"

/obj/machinery/computer/price_controller/proc/clear_logs()
	selflog = list()
	log_self(" -!- Очищено Оператором Системы -!- ")

/obj/item/circuitboard/computer/price_controller
	name = "контроллер цен"
	desc = "Используется для искусственных манипуляций внутренним рынком."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/price_controller

/obj/machinery/computer/price_controller/ui_interact(mob/user, datum/tgui/ui)
	if(!authed)
		to_chat(user, span_warning("Консоль заблокирована!"))
		return
	. = ..()
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

	return data

/obj/machinery/computer/price_controller/ui_static_data(mob/user)
	. = ..()
	.["selflog"] = list()
	for(var/i in selflog)
		.["selflog"] += list(list("entry" = i))
	.["accounts"] = list()
	for(var/B in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/A = SSeconomy.bank_accounts_by_id[B] // ???
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
			log_self("Изменена ставка налога на [params["nalog"]] для Инженерного отдела.")
			GLOB.eng_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_sci")
			log_self("Изменена ставка налога на [params["nalog"]] для Научного отдела.")
			GLOB.sci_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_med")
			log_self("Изменена ставка налога на [params["nalog"]] для Медицинского отдела.")
			GLOB.med_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_sec")
			log_self("Изменена ставка налога на [params["nalog"]] для отдела Безопасности.")
			GLOB.sec_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_srv")
			log_self("Изменена ставка налога на [params["nalog"]] для Сервисного отдела.")
			GLOB.srv_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("change_civ")
			log_self("Изменена ставка налога на [params["nalog"]] для Гражданского отдела.")
			GLOB.civ_eco_mod = text2num(params["nalog"])
			. = TRUE
		if("clear_me")
			clear_logs()
			. = TRUE
