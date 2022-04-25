/datum/antagonist/gypsy
	name = "gypsy"
	roundend_category = "yohei"
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/mind/protected_guy
	greentext_reward = 250

/datum/id_trim/job/assistant/gypsy
	assignment = "Gypsy"

/datum/outfit/gypsy
	name = "Цыганин"

	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/switer/tracksuit
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	shoes = /obj/item/clothing/shoes/jackboots/timbs
	gloves = /obj/item/clothing/gloves/ring/diamond
	suit = /obj/item/clothing/suit/gothcoat

	l_pocket = /obj/item/modular_computer/tablet/pda

	id_trim = /datum/id_trim/job/assistant/gypsy

	back = /obj/item/storage/backpack/satchel/leather

/datum/job/assistant/Gypsy
	title = "Gypsy"
	ru_title = "Цыган"
	total_positions = 3
	spawn_positions = 3
	outfit = /datum/outfit/gypsy

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT
//////////////////////////////////////////////////////
///////////////ДЕРЬМО ЖОПА ЗАДНИЦА ///////////////////
//////////////////////////////////////////////////////

/obj/machinery/piratepad/gypsy
	name = "платформа отправки в общак"
	var/cargo_hold_idg


/obj/machinery/piratepad/gypsy/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, span_notice("Записываю [src] в буффере [I]."))
		I.buffer = src
		return TRUE

/obj/machinery/computer/piratepad_control/gypsy
	name = "управление платформой торговли"
	status_report = "Готово к доставке."
	var/obj/machinery/piratepad/pad/gypsy
	warmup_time = 100
	sending = FALSE
	points = 0
	datum/export_report/total_report
	var/cargo_hold_idg

/obj/machinery/computer/piratepad_control/gypsy/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/piratepad_control/gypsy/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I) && istype(I.buffer,/obj/machinery/piratepad/gypsy))
		to_chat(user, span_notice("Привязываю [src] используя [I.buffer] в буффере [I]."))
		pad = I.buffer
		return TRUE

/obj/machinery/computer/piratepad_control/gypsy/LateInitialize()
	. = ..()
	if(cargo_hold_id)
		for(var/obj/machinery/piratepad/gypsy/P in GLOB.machines)
			if(P.cargo_hold_idg == cargo_hold_idg)
				pad = P
				return
	else
		pad = locate() in range(4,src)

/obj/machinery/computer/piratepad_control/gypsy/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoHoldgTerminal", name)
		ui.open()

/obj/machinery/computer/piratepad_control/gypsy/ui_data(mob/user)
	var/list/data = list()
	data["points"] = points
	data["pad"] = pad ? TRUE : FALSE
	data["sending"] = sending
	data["status_report"] = status_report
	return data

/obj/machinery/computer/piratepad_control/gypsy/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!pad)
		return

	switch(action)
		if("recalc")
			recalc()
			. = TRUE
		if("send")
			start_sending()
			. = TRUE
		if("stop")
			stop_sending()
			. = TRUE

//Attempts to find the thing on station
/datum/export/pirate/gypsy/proc/find_loot_gypsy()
	return

/datum/export/pirate/gypsy/parrot
	cost = CARGO_CRATE_VALUE * 200
	unit_name = "alive parrot"
	export_types = list(/mob/living/simple_animal/parrot)

/datum/export/pirate/parrot/gypsy/find_loot()
	for(var/mob/living/simple_animal/parrot/P in GLOB.alive_mob_list)
		var/turf/T = get_turf(P)
		if(T && is_station_level(T.z))
			return P

/datum/export/pirate/gypsy/cash
	cost = 1
	unit_name = "bills"
	export_types = list(/obj/item/stack/spacecash)

/datum/export/pirate/gypsy/cash/get_amount(obj/O)
	var/obj/item/stack/spacecash/C = O
	return ..() * C.amount * C.value

/datum/export/pirate/gypsy/holochip
	cost = 1
	unit_name = "holochip"
	export_types = list(/obj/item/holochip)

/datum/export/pirate/gypsy/holochip/get_cost(atom/movable/AM)
	var/obj/item/holochip/H = AM
	return H.credits
