/area/trading_outpost
	name = "Trading Outpost"
	icon_state = "centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = TRUE
	has_gravity = STANDARD_GRAVITY
	noteleport = TRUE
	blob_allowed = FALSE
	flags_1 = CAN_BE_DIRTY_1

/obj/item/card/id/departmental_budget/tra
	department_ID = ACCOUNT_TRA
	department_name = ACCOUNT_TRA_NAME
	icon_state = "car_budget"

/obj/machinery/computer/cargo/trader
	name = "trader console"
	desc = "Used to order supplies, approve requests, and control the shuttle."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/cargo
	ui_x = 780
	ui_y = 750
	light_color = "#E2853D"//orange

/obj/machinery/computer/cargo/trader/ui_data()
	var/list/data = list()
	data["location"] = SSshuttle.trader_supply.getStatusText()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_TRA)
	if(D)
		data["points"] = D.account_balance
	data["away"] = SSshuttle.trader_supply.getDockedId() == "trader_supply_away"
	data["self_paid"] = self_paid
	data["docked"] = SSshuttle.trader_supply.mode == SHUTTLE_IDLE
	var/message = "Remember to stamp and send back the supply manifests."
	if(SSshuttle.trader_centcom_message)
		message = SSshuttle.trader_centcom_message
	if(SSshuttle.supplyBlocked)
		message = blockade_warning
	data["message"] = message
	data["cart"] = list()
	for(var/datum/supply_order/trader/SO in SSshuttle.trader_shoppinglist)
		data["cart"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost,
			"id" = SO.id,
			"orderer" = SO.orderer,
			"paid" = !isnull(SO.paying_account) //paid by requester
		))

	data["requests"] = list()
	for(var/datum/supply_order/trader/SO in SSshuttle.trader_requestlist)
		data["requests"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost,
			"orderer" = SO.orderer,
			"reason" = SO.reason,
			"id" = SO.id
		))

	return data

/obj/machinery/computer/cargo/trader/ui_static_data(mob/user)
	var/list/data = list()
	data["requestonly"] = requestonly
	data["supplies"] = list()
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack]
		if(!data["supplies"][P.group])
			data["supplies"][P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		if((P.hidden && !(obj_flags & EMAGGED)) || (P.contraband && !contraband) || (P.special && !P.special_enabled) || P.DropPodOnly)
			continue
		data["supplies"][P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.cost,
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"small_item" = P.small_item,
			"access" = P.access
		))
	return data

/obj/machinery/computer/cargo/trader/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("send")
			if(!SSshuttle.trader_supply.canMove())
				say(safety_warning)
				return
			if(SSshuttle.supplyBlocked)
				say(blockade_warning)
				return
			if(SSshuttle.trader_supply.getDockedId() == "trader_supply_home")
				SSshuttle.trader_supply.export_categories = get_export_categories()
				SSshuttle.moveShuttle("trader_supply", "trader_supply_away", TRUE)
				say("The trader shuttle is departing.")
				investigate_log("[key_name(usr)] sent the trader shuttle away.", INVESTIGATE_CARGO)
			else
				investigate_log("[key_name(usr)] called the trader shuttle.", INVESTIGATE_CARGO)
				say("The trader shuttle has been called and will arrive in [SSshuttle.trader_supply.timeLeft(1200)] minutes.")
				SSshuttle.moveShuttle("trader_supply", "trader_supply_home", TRUE)
			. = TRUE
		if("add")
			var/id = text2path(params["id"])
			var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
			if(!istype(pack))
				return
			if((pack.hidden && !(obj_flags & EMAGGED)) || (pack.contraband && !contraband) || pack.DropPodOnly)
				return

			var/name = "*None Provided*"
			var/rank = "*None Provided*"
			var/ckey = usr.ckey
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				name = H.get_authentification_name()
				rank = H.get_assignment(hand_first = TRUE)
			else if(issilicon(usr))
				name = usr.real_name
				rank = "Silicon"

			var/datum/bank_account/account
			if(self_paid && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id_card = H.get_idcard(TRUE)
				if(!istype(id_card))
					say("No ID card detected.")
					return
				account = id_card.registered_account
				if(!istype(account))
					say("Invalid bank account.")
					return

			var/reason = ""
			if(requestonly && !self_paid)
				reason = stripped_input("Reason:", name, "")
				if(isnull(reason) || ..())
					return

			var/turf/T = get_turf(src)
			var/datum/supply_order/trader/SO = new(pack, name, rank, ckey, reason, account)
			SO.generateRequisition(T)
			if(requestonly && !self_paid)
				SSshuttle.trader_requestlist += SO
			else
				SSshuttle.trader_shoppinglist += SO
				if(self_paid)
					say("Order processed. The price will be charged to [account.account_holder]'s bank account on delivery.")
			if(requestonly && message_cooldown < world.time)
				radio.talk_into(src, "A new order has been requested.", RADIO_CHANNEL_SUPPLY)
				message_cooldown = world.time + 30 SECONDS
			. = TRUE
		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/trader/SO in SSshuttle.trader_shoppinglist)
				if(SO.id == id)
					SSshuttle.trader_shoppinglist -= SO
					. = TRUE
					break
		if("clear")
			SSshuttle.trader_shoppinglist.Cut()
			. = TRUE
		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/trader/SO in SSshuttle.trader_requestlist)
				if(SO.id == id)
					SSshuttle.trader_requestlist -= SO
					SSshuttle.trader_shoppinglist += SO
					. = TRUE
					break
		if("deny")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/trader/SO in SSshuttle.trader_requestlist)
				if(SO.id == id)
					SSshuttle.trader_requestlist -= SO
					. = TRUE
					break
		if("denyall")
			SSshuttle.trader_requestlist.Cut()
			. = TRUE
		if("toggleprivate")
			self_paid = !self_paid
			. = TRUE

/obj/machinery/computer/shuttle/ferry/trader
	name = "transport trader console"
	desc = "A console that controls the transport trader."
	circuit = /obj/item/circuitboard/computer/ferry
	shuttleId = "trader_transport"
	possible_destinations = "trader_transport_home;trader_transport_station"
	req_access = list()
	req_access_txt = "209"

/obj/machinery/computer/shuttle/ferry/request/trader
	name = "trader transport console"
	circuit = /obj/item/circuitboard/computer/ferry/request
	possible_destinations = "trader_transport_home;trader_transport_station"
	req_access = list()
	req_access_txt = "209"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/datum/map_template/shuttle/trader_transport
	port_id = "trader"
	suffix = "transport"
	name = "Trader Transport Shuttle"
	can_be_bought = FALSE

/datum/map_template/shuttle/trader_supply
	port_id = "trader"
	suffix = "supply"
	name = "Trader Supply Shuttle"
	can_be_bought = FALSE

/obj/docking_port/mobile/supply/trader
	name = "trader supply shuttle"
	id = "trader_supply"
	callTime = 1200

	dir = WEST
	port_direction = EAST
	width = 12
	dwidth = 5
	height = 7
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)

/datum/supply_order/trader/New(datum/supply_pack/pack, orderer, orderer_rank, orderer_ckey, reason, paying_account)
	id = SSshuttle.trader_ordernum++
	src.pack = pack
	src.orderer = orderer
	src.orderer_rank = orderer_rank
	src.orderer_ckey = orderer_ckey
	src.reason = reason
	src.paying_account = paying_account

/obj/docking_port/mobile/supply/trader/register()
	SSshuttle.mobile += src
	SSshuttle.trader_supply = src

/obj/docking_port/mobile/supply/trader/canMove()
	if(is_centcom_level(z))
		return check_blacklist(shuttle_areas)
	return ..()

/obj/docking_port/mobile/supply/trader/initiate_docking()
	if(getDockedId() == "trader_supply_away") // Buy when we leave home.
		buy()
	. = ..() // Fly/enter transit.
	if(. != DOCKING_SUCCESS)
		return
	if(getDockedId() == "trader_supply_away") // Sell when we get home
		sell()

/obj/docking_port/mobile/supply/trader/buy()
	var/list/obj/miscboxes = list() //miscboxes are combo boxes that contain all small_item orders grouped
	var/list/misc_order_num = list() //list of strings of order numbers, so that the manifest can show all orders in a box
	var/list/misc_contents = list() //list of lists of items that each box will contain
	if(!SSshuttle.trader_shoppinglist.len)
		return

	var/list/empty_turfs = list()
	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/T in shuttle_area)
			if(is_blocked_turf(T))
				continue
			empty_turfs += T

	var/value = 0
	var/purchases = 0
	for(var/datum/supply_order/trader/SO in SSshuttle.trader_shoppinglist)
		if(!empty_turfs.len)
			break
		var/price = SO.pack.cost * 2
		var/datum/bank_account/D
		if(SO.paying_account) //Someone paid out of pocket
			D = SO.paying_account
		else
			D = SSeconomy.get_dep_account(ACCOUNT_TRA)
		if(D)
			if(!D.adjust_money(-price))
				if(SO.paying_account)
					D.bank_card_talk("Trader order #[SO.id] rejected due to lack of funds. Credits required: [price]")
				continue

		if(SO.paying_account)
			D.bank_card_talk("Trader order #[SO.id] has shipped. [price] credits have been charged to your bank account.")
			var/datum/bank_account/department/trader = SSeconomy.get_dep_account(ACCOUNT_TRA)
			trader.adjust_money(price - SO.pack.cost) //Cargo gets the handling fee
		value += SO.pack.cost
		SSshuttle.trader_shoppinglist -= SO
		SSshuttle.trader_orderhistory += SO

		if(SO.pack.small_item) //small_item means it gets piled in the miscbox
			if(SO.paying_account)
				if(!miscboxes.len || !miscboxes[D.account_holder]) //if there's no miscbox for this person
					miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned(pick_n_take(empty_turfs), SO.paying_account)
					miscboxes[D.account_holder].name = "small items crate - purchased by [D.account_holder]"
					misc_contents[D.account_holder] = list()
				for (var/item in SO.pack.contains)
					misc_contents[D.account_holder] += item
				misc_order_num[D.account_holder] = "[misc_order_num[D.account_holder]]#[SO.id]  "
			else //No private payment, so we just stuff it all into a generic crate
				if(!miscboxes.len || !miscboxes["Cargo"])
					miscboxes["Cargo"] = new /obj/structure/closet/crate/secure(pick_n_take(empty_turfs))
					miscboxes["Cargo"].name = "small items crate"
					misc_contents["Cargo"] = list()
					miscboxes["Cargo"].req_access = list()
				for (var/item in SO.pack.contains)
					misc_contents["Cargo"] += item
					//new item(miscboxes["Cargo"])
				if(SO.pack.access)
					miscboxes["Cargo"].req_access += SO.pack.access
				misc_order_num["Cargo"] = "[misc_order_num["Cargo"]]#[SO.id]  "
		else
			SO.generate(pick_n_take(empty_turfs))

		SSblackbox.record_feedback("nested tally", "trader_imports", 1, list("[SO.pack.cost]", "[SO.pack.name]"))
		investigate_log("Trader order #[SO.id] ([SO.pack.name], placed by [key_name(SO.orderer_ckey)]), paid by [D.account_holder] has shipped.", INVESTIGATE_CARGO)
		if(SO.pack.dangerous)
			message_admins("\A [SO.pack.name] ordered by [ADMIN_LOOKUPFLW(SO.orderer_ckey)], paid by [D.account_holder] has shipped.")
		purchases++

	for(var/I in miscboxes)
		var/datum/supply_order/trader/SO = new/datum/supply_order/trader()
		SO.id = misc_order_num[I]
		SO.generateCombo(miscboxes[I], I, misc_contents[I])
		qdel(SO)

	var/datum/bank_account/trader_budget = SSeconomy.get_dep_account(ACCOUNT_TRA)
	investigate_log("[purchases] orders in this shipment, worth [value] credits. [trader_budget.account_balance] credits left.", INVESTIGATE_CARGO)

/obj/docking_port/mobile/supply/trader/sell()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_TRA)
	var/presale_points = D.account_balance

	if(!GLOB.exports_list.len) // No exports list? Generate it!
		setupExports()

	var/msg = ""

	var/datum/export_report/ex = new

	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/atom/movable/AM in shuttle_area)
			if(iscameramob(AM))
				continue
			if(!AM.anchored || istype(AM, /obj/mecha))
				export_item_and_contents(AM, export_categories , dry_run = FALSE, external_report = ex)

	if(ex.exported_atoms)
		ex.exported_atoms += "." //ugh

	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex)
		if(!export_text)
			continue

		msg += export_text + "\n"
		D.adjust_money(ex.total_value[E])

	SSshuttle.trader_centcom_message = msg
	investigate_log("Shuttle contents sold for [D.account_balance - presale_points] credits. Contents: [ex.exported_atoms ? ex.exported_atoms.Join(",") + "." : "none."] Message: [SSshuttle.trader_centcom_message || "none."]", INVESTIGATE_CARGO)
