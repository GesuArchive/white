/area/trading_outpost
	name = "Trading Outpost"
	icon_state = "centcom"
	static_lighting = FALSE
	requires_power = TRUE
	has_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT
	flags_1 = CAN_BE_DIRTY_1
	ambientsounds = SCARLET_DAWN_AMBIENT

/area/trading_outpost/transfer
	name = "Trading Outpost Transfer"
	area_flags = UNIQUE_AREA

/obj/item/card/id/departmental_budget/tra
	department_ID = ACCOUNT_TRA
	department_name = ACCOUNT_TRA_NAME
	icon_state = "car_budget"

/obj/machinery/trading_beacon
	name = "Торговый Маяк"
	desc = "Служит для торговли с поселениями на планете."
	icon_state = "wooden_tv"
	density = TRUE
	req_access = list(ACCESS_TRADER)
	var/list/shoppinglist = list()
	var/list/supply_packs = list()
	flags_1 = NODECONSTRUCT_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/trading_beacon/Initialize(mapload)
	. = ..()
	for(var/pack in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new pack()
		if(!P.contains)
			continue
		supply_packs[P.type] = P

/obj/machinery/trading_beacon/can_be_unfasten_wrench(mob/user, silent)
	return FALSE

/obj/machinery/trading_beacon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, JOB_TRADER, name)
		ui.open()

/obj/machinery/trading_beacon/ui_data()
	var/list/data = list()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_TRA)
	if(D)
		data["points"] = D.account_balance
	data["cart"] = list()
	for(var/datum/supply_order/SO in shoppinglist)
		data["cart"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost * 2,
			"id" = SO.id,
			"orderer" = SO.orderer,
			"paid" = !isnull(SO.paying_account) //paid by requester
		))
	return data

/obj/machinery/trading_beacon/ui_static_data(mob/user)
	var/list/data = list()
	data["supplies"] = list()
	for(var/pack in supply_packs)
		var/datum/supply_pack/P = supply_packs[pack]
		if(!data["supplies"][P.group])
			data["supplies"][P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		data["supplies"][P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.cost * 2,
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"small_item" = P.goody,
			"access" = P.access
		))
	return data

/obj/machinery/trading_beacon/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	if(issilicon(usr))
		say("Единицам ИИ запрещено пользоваться торговыми сетями.")
		return
	var/obj/item/card/id/ID
	if(isliving(usr))
		var/mob/living/L = usr
		ID = L.get_idcard(hand_first = TRUE)
	if(ID && istype(ID))
		if(!check_access(ID))
			say("Нет доступа.")
			electrocute_mob(usr, get_area(src), src, 1.7, TRUE)
			return
	switch(action)
		if("buy")
			buy_items()
			. = TRUE
		if("sell")
			sell_items()
			. = TRUE
		if("add")
			var/id = text2path(params["id"])
			var/datum/supply_pack/pack = supply_packs[id]
			if(!istype(pack))
				return

			var/name = "*None Provided*"
			var/ckey = usr.ckey
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				name = H.get_authentification_name()

			var/turf/T = get_turf(src)
			var/datum/supply_order/SO = new(pack, name, "Торговец", ckey, "N/A", null)
			SO.generateRequisition(T)
			shoppinglist += SO
			. = TRUE
		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in shoppinglist)
				if(SO.id == id)
					shoppinglist -= SO
					. = TRUE
					break
		if("clear")
			shoppinglist.Cut()
			. = TRUE

/obj/machinery/trading_beacon/proc/buy_items()
	var/list/obj/miscboxes = list()
	var/list/misc_order_num = list()
	var/list/misc_contents = list()
	if(!shoppinglist.len)
		return
	var/list/empty_turfs = list()
	var/area/trading_outpost/transfer/A = GLOB.areas_by_type[/area/trading_outpost/transfer]
	for(var/turf/T in A)
		if(T.is_blocked_turf(FALSE))
			continue
		empty_turfs += T
	var/value = 0
	var/purchases = 0
	for(var/datum/supply_order/SO in shoppinglist)
		if(!empty_turfs.len)
			break
		var/price = SO.pack.cost * 2
		var/datum/bank_account/department/D = SSeconomy.get_dep_account(ACCOUNT_TRA)
		if(D)
			if(!D.adjust_money(-price))
				continue
		value += SO.pack.cost * 2
		shoppinglist -= SO
		if(SO.pack.goody) //goody means it gets piled in the miscbox
			if(!miscboxes.len || !miscboxes["Cargo"])
				miscboxes["Cargo"] = new /obj/structure/closet/crate/secure(pick_n_take(empty_turfs))
				miscboxes["Cargo"].name = "small items crate"
				misc_contents["Cargo"] = list()
				miscboxes["Cargo"].req_access = list()
			for (var/item in SO.pack.contains)
				misc_contents["Cargo"] += item
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
		var/datum/supply_order/SO = new/datum/supply_order()
		SO.id = misc_order_num[I]
		SO.generateCombo(miscboxes[I], I, misc_contents[I])
		qdel(SO)
	var/datum/bank_account/trader_budget = SSeconomy.get_dep_account(ACCOUNT_TRA)

	say("Куплено [purchases] товаров на сумму [value].")

	investigate_log("[purchases] orders in this shipment, worth [value] credits. [trader_budget.account_balance] credits left.", INVESTIGATE_CARGO)

/obj/machinery/trading_beacon/proc/sell_items()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_TRA)
	var/presale_points = D.account_balance

	if(!GLOB.exports_list.len) // No exports list? Generate it!
		setupExports()

	var/msg = ""

	var/datum/export_report/ex = new
	var/area/trading_outpost/transfer/A = GLOB.areas_by_type[/area/trading_outpost/transfer]
	for(var/turf/T in A)
		for(var/atom/movable/AM in T)
			if(iscameramob(AM))
				continue
			if(!AM.anchored || istype(AM, /obj/vehicle/sealed/mecha))
				export_item_and_contents(AM, EXPORT_CARGO | EXPORT_CONTRABAND | EXPORT_EMAG, dry_run = FALSE,  delete_unsold = FALSE, external_report = ex)

	if(ex.exported_atoms)
		ex.exported_atoms += "." //ugh

	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex)
		if(!export_text)
			continue

		msg += export_text + "\n"
		if(ex.total_value[E] != 0)
			D.adjust_money(ex.total_value[E] / 2)

	say("Проданы товары на сумму [D.account_balance - presale_points].")

	investigate_log("Contents sold for [D.account_balance - presale_points] credits. Contents: [ex.exported_atoms ? ex.exported_atoms.Join(",") + "." : "none."]", INVESTIGATE_CARGO)

/obj/machinery/computer/shuttle_flight/ferry/trader
	name = "transport trader console"
	desc = "A console that controls the transport trader."
	circuit = /obj/item/circuitboard/computer/ferry/trader
	shuttleId = "trader_transport"
	possible_destinations = "trader_transport_home;trader_transport_station;whiteship_home"
	req_access = list(ACCESS_TRADER)
	req_access_txt = "209"
	allow_emag = TRUE

/obj/machinery/computer/shuttle_flight/ferry/request/trader
	name = "trader transport console"
	circuit = /obj/item/circuitboard/computer/ferry/request/trader
	shuttleId = "trader_transport"
	possible_destinations = "trader_transport_home;trader_transport_station;whiteship_home"
	req_access = list(ACCESS_TRADER)
	req_access_txt = "209"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	allow_emag = TRUE

/obj/item/circuitboard/computer/ferry/trader
	name = "Trader Transport Ferry (Консоль)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle_flight/ferry/trader

/obj/item/circuitboard/computer/ferry/request/trader
	name = "Trader Transport Console (Консоль)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/shuttle_flight/ferry/request/trader

/datum/map_template/shuttle/trader_transport
	port_id = "trader"
	suffix = "transport"
	name = "Trader Transport Shuttle"
	can_be_bought = FALSE

/obj/structure/punching_bag/pizdul
	name = "денежная груша"
	desc = "Странным образом трансформирует силу киннетических ударов в деньги."
	anchored = FALSE
	armor = list(MELEE = 20, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 10, BIO = 100, RAD = 100, FIRE = 70, ACID = 100)
	maptext_y = 24
	var/tier = 1
	var/exp = 0
	var/datum/bank_account/linked_account

/obj/structure/punching_bag/pizdul/Initialize(mapload)
	. = ..()
	linked_account = SSeconomy.get_dep_account(ACCOUNT_CAR)

/obj/structure/punching_bag/pizdul/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Производительность: <b>[tier]</b></span>"
	. += span_notice("\nОпыт: <b>[exp]</b>")
	. += span_notice("\nПривязанный аккаунт: <b>[linked_account.account_holder]</b>.")

/obj/structure/punching_bag/pizdul/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	linked_account?.adjust_money(tier)
	exp++
	maptext = MAPTEXT("[exp]")
	if(exp >= 100 * tier)
		tier++
		exp = 0
		say("Новый уровень! Теперь производим [tier] кредит[get_num_string(tier)] за удар.")

/obj/structure/punching_bag/pizdul/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/acard = I
		if(acard.registered_account)
			linked_account = acard.registered_account
			to_chat(user, span_notice("Привязываю карту к пиздюлегенератору."))
			return
		to_chat(user, span_warning("На карте нет аккаунта!"))
		return

	. = ..()

/obj/item/card/id/trader_ex
	name = "Карта расширения"
	desc = "Открывает дополнительную зону в апартаментах трейдера."
	icon = 'icons/obj/card.dmi'
	icon_state = "data_1"
	access = list(ACCESS_TRADER_EX)
	registered_age = null
