#define CIV_BOUNTY_SPLIT 30

///Pad for the Civilian Bounty Control.
/obj/machinery/piratepad/civilian
	name = "гражданская платформа отправки"
	desc = "Используется для отправки груза на ЦК."
	layer = TABLE_LAYER
	resistance_flags = FIRE_PROOF
	circuit = /obj/item/circuitboard/machine/bountypad

///Computer for assigning new civilian bounties, and sending bounties for collection.
/obj/machinery/computer/piratepad_control/civilian
	name = "гражданский терминал заказов"
	desc = "Консоль, которая предоставляет персоналу возможность выполнять небольшие поручения, достаточно лишь вставить свою ID-карту."
	status_report = "Готово к отправке."
	icon_screen = "civ_bounty"
	icon_keyboard = "id_key"
	warmup_time = 3 SECONDS
	var/obj/item/card/id/inserted_scan_id
	circuit = /obj/item/circuitboard/computer/bountypad
	interface_type = "CivCargoHoldTerminal"

/obj/machinery/computer/piratepad_control/civilian/Initialize(mapload)
	. = ..()
	pad = /obj/machinery/piratepad/civilian

/obj/machinery/computer/piratepad_control/civilian/attackby(obj/item/I, mob/living/user, params)
	if(isidcard(I))
		if(id_insert(user, I, inserted_scan_id))
			inserted_scan_id = I
			return TRUE
	return ..()

/obj/machinery/computer/piratepad_control/multitool_act(mob/living/user, obj/item/multitool/I)
	if(istype(I) && istype(I.buffer,/obj/machinery/piratepad/civilian))
		to_chat(user, span_notice("Привязываю [src] используя [I.buffer] в буффере [I]."))
		pad = I.buffer
		return TRUE

/obj/machinery/computer/piratepad_control/civilian/LateInitialize()
	. = ..()
	if(cargo_hold_id)
		for(var/obj/machinery/piratepad/civilian/C in GLOB.machines)
			if(C.cargo_hold_id == cargo_hold_id)
				pad = C
				return
	else
		pad = locate() in range(4,src)

/obj/machinery/computer/piratepad_control/civilian/recalc()
	if(sending)
		return FALSE
	if(!inserted_scan_id)
		status_report = "Вставьте сначала вашу ID-карту."
		playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)
		return FALSE
	if(!inserted_scan_id.registered_account.civilian_bounty)
		status_report = "Получите новый заказ, пожалуйста."
		playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)
		return FALSE
	status_report = "Civilian Bounty: "
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(inserted_scan_id.registered_account.civilian_bounty.applies_to(AM))
			status_report += "Объект подходит."
			playsound(loc, 'sound/machines/synth_yes.ogg', 30 , TRUE)
			return
	status_report += "Неудовлетворительно."
	playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)

/**
 * This fully rewrites base behavior in order to only check for bounty objects, and nothing else.
 */
/obj/machinery/computer/piratepad_control/civilian/send()
	playsound(loc, 'sound/machines/wewewew.ogg', 70, TRUE)
	if(!sending)
		return
	if(!inserted_scan_id)
		stop_sending()
		return FALSE
	if(!inserted_scan_id.registered_account.civilian_bounty)
		stop_sending()
		return FALSE
	var/datum/bounty/curr_bounty = inserted_scan_id.registered_account.civilian_bounty
	var/active_stack = 0
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(curr_bounty.applies_to(AM))
			active_stack ++
			curr_bounty.ship(AM)
			qdel(AM)
	if(active_stack >= 1)
		status_report += "Найдены требуемые предметы x[active_stack]. "
	else
		status_report = "Не обнаружены необходимые предметы. Отмена."
		stop_sending()
	if(curr_bounty.can_claim())
		//Pay for the bounty with the ID's department funds.
		status_report += "Заказ завершён! Пожалуйста, отправьте куб с данными заказа на шаттле для получения вознаграждения."
		inserted_scan_id.registered_account.reset_bounty()
		SSeconomy.civ_bounty_tracker++
		var/obj/item/bounty_cube/reward = new /obj/item/bounty_cube(drop_location())
		reward.bounty_value = curr_bounty.reward
		reward.bounty_name = curr_bounty.name
		reward.bounty_holder = inserted_scan_id.registered_name
		reward.name = "[reward.name] [reward.bounty_value] кредит[get_num_string(reward.bounty_value)] "
		reward.desc += " Бирка указывает, что этот куб принадлежит [reward.bounty_holder] за выполнение заказа <i>[reward.bounty_name]</i> который был принят в [station_time_timestamp()]."
		reward.AddComponent(/datum/component/pricetag, inserted_scan_id.registered_account, CIV_BOUNTY_SPLIT)
		switch(curr_bounty.reward)
			if(1 to 10 * CARGO_CRATE_VALUE)
				inc_metabalance(usr, METACOIN_BOUNTY_REWARD_EASY, reason="Лёгкий заказ выполнен!")
			if(10 * CARGO_CRATE_VALUE + 1 to 50 * CARGO_CRATE_VALUE)
				inc_metabalance(usr, METACOIN_BOUNTY_REWARD_NORMAL, reason="Обычный заказ выполнен!")
			if(50 * CARGO_CRATE_VALUE + 1 to INFINITY)
				inc_metabalance(usr, METACOIN_BOUNTY_REWARD_HARD, reason="Сложный заказ выполнен!")
	pad.visible_message(span_notice("[capitalize(pad.name)] активируется!"))
	flick(pad.sending_state,pad)
	pad.icon_state = pad.idle_state
	playsound(loc, 'sound/machines/synth_yes.ogg', 30 , TRUE)
	sending = FALSE

///Here is where cargo bounties are added to the player's bank accounts, then adjusted and scaled into a civilian bounty.
/obj/machinery/computer/piratepad_control/civilian/proc/add_bounties()
	if(!inserted_scan_id || !inserted_scan_id.registered_account)
		return
	var/datum/bank_account/pot_acc = inserted_scan_id.registered_account
	if((pot_acc.civilian_bounty && ((world.time) < pot_acc.bounty_timer + 5 MINUTES)) || pot_acc.bounties)
		var/curr_time = round(((pot_acc.bounty_timer + (5 MINUTES))-world.time)/ (1 MINUTES), 0.01)
		to_chat(usr, span_warning("Internal ID network spools coiling, try again in [curr_time] minutes!"))
		return FALSE
	if(!pot_acc.account_job)
		to_chat(usr, span_warning("The console smartly rejects your ID card, as it lacks a job assignment!"))
		return FALSE
	var/list/datum/bounty/crumbs = list(random_bounty(pot_acc.account_job.bounty_types), // We want to offer 2 bounties from their appropriate job catagories
										random_bounty(pot_acc.account_job.bounty_types), // and 1 guarenteed assistant bounty if the other 2 suck.
										random_bounty(CIV_JOB_BASIC))
	pot_acc.bounty_timer = world.time
	pot_acc.bounties = crumbs

/obj/machinery/computer/piratepad_control/civilian/proc/pick_bounty(choice)
	if(!inserted_scan_id?.registered_account)
		playsound(loc, 'sound/machines/synth_no.ogg', 40 , TRUE)
		return
	inserted_scan_id.registered_account.civilian_bounty = inserted_scan_id.registered_account.bounties[choice]
	inserted_scan_id.registered_account.bounties = null
	return inserted_scan_id.registered_account.civilian_bounty

/obj/machinery/computer/piratepad_control/civilian/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !issilicon(user)) || !is_operational)
		id_eject(user, inserted_scan_id)

/obj/machinery/computer/piratepad_control/civilian/ui_data(mob/user)
	var/list/data = list()
	data["points"] = points
	data["pad"] = pad ? TRUE : FALSE
	data["sending"] = sending
	data["status_report"] = status_report
	data["id_inserted"] = inserted_scan_id
	if(inserted_scan_id?.registered_account)
		if(inserted_scan_id.registered_account.civilian_bounty)
			data["id_bounty_info"] = inserted_scan_id.registered_account.civilian_bounty.description
			data["id_bounty_num"] = inserted_scan_id.registered_account.bounty_num()
			data["id_bounty_value"] = (inserted_scan_id.registered_account.civilian_bounty.reward) * (CIV_BOUNTY_SPLIT/100)
		if(inserted_scan_id.registered_account.bounties)
			data["picking"] = TRUE
			data["id_bounty_names"] = list(inserted_scan_id.registered_account.bounties[1].name,
											inserted_scan_id.registered_account.bounties[2].name,
											inserted_scan_id.registered_account.bounties[3].name)
			data["id_bounty_values"] = list(inserted_scan_id.registered_account.bounties[1].reward * (CIV_BOUNTY_SPLIT/100),
											inserted_scan_id.registered_account.bounties[2].reward * (CIV_BOUNTY_SPLIT/100),
											inserted_scan_id.registered_account.bounties[3].reward * (CIV_BOUNTY_SPLIT/100))
		else
			data["picking"] = FALSE

	return data

/obj/machinery/computer/piratepad_control/civilian/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!pad)
		return
	if(!usr.canUseTopic(src, BE_CLOSE) || (machine_stat & (NOPOWER|BROKEN)))
		return
	switch(action)
		if("recalc")
			recalc()
		if("send")
			start_sending()
		if("stop")
			stop_sending()
		if("pick")
			pick_bounty(params["value"])
		if("bounty")
			add_bounties()
		if("eject")
			id_eject(usr, inserted_scan_id)
			inserted_scan_id = null
	. = TRUE

///Self explanitory, holds the ID card inthe console for bounty payout and manipulation.
/obj/machinery/computer/piratepad_control/civilian/proc/id_insert(mob/user, obj/item/inserting_item, obj/item/target)
	var/obj/item/card/id/card_to_insert = inserting_item
	var/holder_item = FALSE

	if(!isidcard(card_to_insert))
		card_to_insert = inserting_item.RemoveID()
		holder_item = TRUE

	if(!card_to_insert || !user.transferItemToLoc(card_to_insert, src))
		return FALSE

	if(target)
		if(holder_item && inserting_item.InsertID(target))
			playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		else
			id_eject(user, target)

	user.visible_message(span_notice("[user] вставляет [card_to_insert] в [src].") ,
						span_notice("Вставляю [card_to_insert] в [src]."))
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	updateUsrDialog()
	return TRUE

///Removes A stored ID card.
/obj/machinery/computer/piratepad_control/civilian/proc/id_eject(mob/user, obj/target)
	if(!target)
		to_chat(user, span_warning("Внутри пусто!"))
		return FALSE
	else
		target.forceMove(drop_location())
		if(!issilicon(user) && Adjacent(user))
			user.put_in_hands(target)
		user.visible_message(span_notice("[user] достаёт [target] из [src].") , \
							span_notice("Достаю [target] из[src]."))
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		inserted_scan_id = null
		updateUsrDialog()
		return TRUE

///Upon completion of a civilian bounty, one of these is created. It is sold to cargo to give the cargo budget bounty money, and the person who completed it cash.
/obj/item/bounty_cube
	name = "Куб с Данными"
	desc = "Набор сжатых данных, которые имеют информацию о выполненном заказе. Это нужно отправить на шаттле снабжения!"
	icon = 'icons/obj/economy.dmi'
	icon_state = "bounty_cube"
	///Value of the bounty that this bounty cube sells for.
	var/bounty_value = 0
	///Who completed the bounty.
	var/bounty_holder
	///What the bounty was for.
	var/bounty_name

/obj/item/bounty_cube/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_BARCODES, INNATE_TRAIT) // Don't allow anyone to override our pricetag component with a barcode

///Beacon to launch a new bounty setup when activated.
/obj/item/civ_bounty_beacon
	name = "гражданский маяк заказов"
	desc = "Универсальный приёмник от NanoTrasen, который посылает сигнал с требованием прислать гражданский терминал заказов и платформу прямо сюда. Чудеса!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"
	var/uses = 2

/obj/item/civ_bounty_beacon/attack_self()
	loc.visible_message(span_warning("[capitalize(src.name)] начинает громко пищать!"))
	addtimer(CALLBACK(src, .proc/launch_payload), 1 SECONDS)

/obj/item/civ_bounty_beacon/proc/launch_payload()
	playsound(src, "zap", 80, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	switch(uses)
		if(2)
			new /obj/machinery/piratepad/civilian(drop_location())
		if(1)
			new /obj/machinery/computer/piratepad_control/civilian(drop_location())
			qdel(src)
	uses--
