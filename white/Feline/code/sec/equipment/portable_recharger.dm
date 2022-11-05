/obj/machinery/recharger/internal
	//name = "" // to hide it from context menus
	desc = "Сбоку на корпусе написано: <b></i>\"ЕСЛИ ВЫ ЭТО ВИДИТЕ, ПОЗВОНИТЕ 8-800-ВАЛТОС\"</i></b>"
	flags_1 = IS_ONTOP_1
	vis_flags = VIS_INHERIT_ID
	ping_cooldown = 50
	var/obj/machinery/portable_recharger/housing

/obj/machinery/recharger/internal/Initialize(mapload, _housing)
	. = ..()
	if(!istype(_housing, /obj/machinery/portable_recharger))
		stack_trace("Internal rechargers meant to be used inside portable rechargers. Do not spawn them in or place them on the map.") // so long,
		qdel(src) // and thanks for all the shitcode
	// the rest of init will be done by the recharger body housing us
	housing = _housing

/obj/machinery/recharger/internal/on_deconstruction()
	QDEL_LAZYLIST(component_parts)
	. = ..()

/obj/machinery/recharger/internal/powered(chan)
	return _area_powered() || _cell_powered() || housing.powernet_connection


/obj/machinery/recharger/internal/proc/_area_powered(chan = power_channel) //direct copypaste of the original powered() proc
	if(!loc)
		return FALSE
	if(!use_power)
		return TRUE
	var/area/A = get_area(src)	// make sure it's in an area
	if(!A)
		return FALSE // if not, then not powered
	return A.powered(chan) // return power status of the area

/obj/machinery/recharger/internal/proc/_cell_powered()
	var/obj/item/stock_parts/cell/C = housing.cell
	return C?.charge ? TRUE : FALSE

// Tries to draw power from powernet directly. If fails, uses use_power(). If it also fails, tries to use the battery in the housing. If it also fails, returns zero. Otherwise, returns amount.
/obj/machinery/recharger/internal/proc/use_any_power_available(amount)
	var/obj/machinery/power/powernet = housing.powernet_connection
	if(powernet && powernet.surplus() >= amount + active_power_usage) // try sucking power from connected powernet
		powernet.add_load(amount + active_power_usage) // also accounting for active_power_usage
		return amount
	if(_area_powered()) // if not, add load to the area's APC
		use_power(amount)
		return amount
	if(_cell_powered()) // if not, tax the battery
		var/obj/item/stock_parts/cell/C = housing.cell
		if(C?.use(min(amount*0.625, C.charge))) // slightly more efficient (compared to using powernet) to recharge from a cell - 2.5k cell to fully charge 1k e-gun cell but not 1 to 1 to prevent abuse of upgraded cells
			return amount
	return 0 // hope you brought some spare batteries

// it saddens me to do this it must be done
/obj/machinery/recharger/internal/process(delta_time) // i have to copypaste this entire proc just to change 2 lines in it
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		using_power = FALSE
		return PROCESS_KILL

	using_power = FALSE
	if(charging)
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		if(C)
			if(C.charge < C.maxcharge) // not fully charged
				if(use_any_power_available(2 * C.chargerate * recharge_coeff * delta_time, FALSE)) // formelly this
					C.give(C.chargerate * recharge_coeff * delta_time / 2)
					using_power = TRUE
					update_icon()
			else //fully charged, return PROCESS_KILL
				if(world.time > last_ping_time + ping_cooldown)
					last_ping_time = world.time + ping_cooldown
					playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
				update_icon()
				return PROCESS_KILL

		if(istype(charging, /obj/item/ammo_box/magazine/recharge))
			var/obj/item/ammo_box/magazine/recharge/R = charging
			if(R.stored_ammo.len < R.max_ammo)
				if(use_any_power_available(casing_recharge_cost * delta_time, TRUE)) // and this
					R.stored_ammo += new R.ammo_type(R)
					using_power = TRUE
					update_icon()
			else
				if(world.time > last_ping_time + ping_cooldown)
					last_ping_time = world.time + ping_cooldown
					playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
				update_icon()
				return PROCESS_KILL
	else
		return PROCESS_KILL


/obj/machinery/portable_recharger
	name = "портативная зарядная станция"
	//desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. При необходимости может быть свернут для транспортировки."
	desc = "Портативная зарядная станция для энергетического оружия. Оборудована двумя портами. Запитывается от станционной сети, использует батаерю в качестве резервного источника энергии. Можно свернуть и перенести в другое место."
	icon = 'white/Feline/icons/sec_recharger.dmi'
	icon_state = "sec"
	base_icon_state = "sec"
	circuit = /obj/item/circuitboard/machine/portable_recharger
	use_power = NO_POWER_USE
	processing_flags = START_PROCESSING_MANUALLY
	var/obj/machinery/recharger/internal/left
	var/obj/machinery/recharger/internal/right

	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell/high

	var/obj/item/portable_recharger/chargerbox

	var/obj/structure/cable/powernet_connection // A dummy machine for interfacing with powernets

	var/deploytime = 0
	var/deploycd = 35
	var/redeploycd = 30
	var/fully_deployed = FALSE // prevents from using the chargers if it's false

/obj/machinery/portable_recharger/Initialize(mapload, _chargerbox)
	if(!_chargerbox)
		stack_trace("[src] has been spawned without a housing box.")
		return INITIALIZE_HINT_QDEL
	chargerbox = _chargerbox
	cell = new cell_type(src)
	CreateLeftRecharger()
	CreateRightRecharger()
	RegisterSignal(src, COMSIG_PARENT_EXAMINE_MORE, .proc/on_examine_more)
	. = ..()

/obj/machinery/portable_recharger/Destroy()
	STOP_PROCESSING(SSmachines, src)
	if(!QDELETED(chargerbox))
		QDEL_NULL(chargerbox)
	if(!QDELETED(left))
		QDEL_NULL(left)
	if(!QDELETED(right))
		QDEL_NULL(right)
	. = ..()

/obj/machinery/portable_recharger/examine(mob/user)
	. = ..()
	. += "<hr>"

	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("Слишком далеко, чтобы рассмотреть дисплей зарядной станции!")
		return

	. += span_notice("Левый порт: ")
	if(left.charging)
		var/obj/item/stock_parts/cell/C = left.charging.get_cell()
		. += span_notice("<b>[left.charging.name]</b> заряжен на <b>[C.percent()]%</b>.")
	else
		. += span_notice("<b>Пусто!</b>")
	. += "<br>"

	. += span_notice("Правый порт: ")
	if(right.charging)
		var/obj/item/stock_parts/cell/C = right.charging.get_cell()
		. += span_notice("<b>[right.charging.name]</b> заряжен на <b>[C.percent()]%</b>.")
	else
		. += span_notice("<b>Пусто!</b>")
	. += "<br>"
	if(panel_open)
		. += "Панель техобслуживания открыта. В батарейном отсеке [cell ? "установлена [cell.name]" : "пусто"]."
	else
		. += "Панель техобслуживания закрыта."
	. += "<hr>"

	if(cell)
		. += span_notice("Уроверь батареи - <b>[cell.percent()]%</b>.")
	else
		. += span_notice("Уровень батареи - БАТАРЕЯ ОТСУТСТВУЕТ!")
	if(powernet_connection)
		. += "<hr>"
		. += span_notice("Станция подключена к электросети.")
		. += span_notice("   Суммарная мощность: [display_power(powernet_connection.powernet.avail)]\n" + \
						"   Нагрузка: [display_power(powernet_connection.powernet.load)]\n" + \
						"   Излишки: [display_power(powernet_connection.surplus())]")

/obj/machinery/portable_recharger/proc/on_examine_more(mob/user) //As a signal handler because examine_more doesn't look like it's supposed to be overwritten
	SIGNAL_HANDLER
	. = list()
	. += span_notice("На внутренней стороне крышки прикреплена маленькая табличка с описанием техники безопасности при работе с зарядной станцией.")
	. += span_notice("<br>")
	. += span_notice("\"Не вставлять в порты посторонние предметы\", \"Не класть предметы на поверхность станции\", \"Не касаться батареи во время работы станции\"...")
	. += span_notice("<br>")
	. += span_notice("Так же тут сказано, что при отсутствии питания от АПЦ/батареи, станцию можно развернуть на оголённом проводе под напряжением.")

//these procs handle stuff that should happen at deploying/packing up the rechargers
/obj/machinery/portable_recharger/proc/do_wrapup_stuff()
	left?.vis_flags |= VIS_HIDE
	right?.vis_flags |= VIS_HIDE
	fully_deployed = FALSE
	powernet_connection = null
	STOP_PROCESSING(SSmachines, src)

/obj/machinery/portable_recharger/proc/do_deploy_stuff()
	left?.vis_flags &= ~VIS_HIDE
	right?.vis_flags &= ~VIS_HIDE
	fully_deployed = TRUE
	var/obj/structure/cable/foundcable = locate() in get_turf(src) //not using get_cable_node() because i only want to connect to cable if it's not covered by tiles
	if(foundcable?.invisibility == 0) // we found a cable and it isn't invisible (i.e. it's not covered)
		powernet_connection = foundcable
		START_PROCESSING(SSmachines, src)

/// used for recharging installed cell when we're connected to a powernet via cable
/obj/machinery/portable_recharger/process(dt)
	if(!powernet_connection)
		powernet_connection = null
		return PROCESS_KILL
	if(powernet_connection.surplus() >= cell.chargerate * 1.5 * dt)
		powernet_connection.add_load(cell.chargerate * 1.5 * dt)
		cell.give(cell.chargerate * dt * 0.5) // shit efficiency - use actual cell chargers, kids

/obj/machinery/portable_recharger/get_cell()
	return cell

/obj/machinery/portable_recharger/proc/isCharging()
	return left.charging || right.charging

/obj/machinery/portable_recharger/proc/CreateLeftRecharger()
	QDEL_NULL(left)
	left = new(src, src)
	left.pixel_x = -7
	left.pixel_y = 2
	vis_contents += left

/obj/machinery/portable_recharger/proc/CreateRightRecharger()
	QDEL_NULL(right)
	right = new(src, src)
	right.pixel_x = 7
	right.pixel_y = 2
	vis_contents += right

#define _IS_IN_RECT(point_x, point_y, x1, y1, x2, y2) (point_x > x1 && point_x < x2 && point_y > y1 && point_y < y2)
#define IS_IN_RECT(point_x, point_y, width, height, x, y) _IS_IN_RECT(point_x, point_y, x-width, y-height, x+width, y+ height)

/obj/machinery/portable_recharger/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(I.tool_behaviour == TOOL_SCREWDRIVER) // check if they're trying to open/close the panel
		panel_open = !panel_open
		to_chat(user, span_notice("[panel_open ? "Открываю" : "Закрываю"] панель техобслуживания зарядной станции."))
		I.play_tool_sound(src, 50)
		update_icon()
		return TRUE

	if(istype(I, /obj/item/stock_parts/cell)) // maybe they're trying to insert a battery?
		var/obj/item/stock_parts/cell/C = I
		if(!panel_open)
			to_chat(user, span_warning("Надо бы сначала открутить панель!"))
			return TRUE
		if(cell)
			to_chat(user, span_warning("Надо бы сначала вытащить батарейку, что уже внутри!"))
			return TRUE
		C.forceMove(src)
		cell = C
		if(!dumbass_check(user))
			to_chat(user, span_notice("Вставляю батарею в зарядную станцию."))
		left.power_change()
		right.power_change()
		return TRUE

	if(fully_deployed)
		var/list/p = params2list(params) // finally, let them access the rechargers
		var/px = text2num(p["icon-x"])
		var/py = text2num(p["icon-y"])

		if(IS_IN_RECT(px, py,   5, 7,   -7+16, 2+16))
			left.attackby(I, user, params)
			return TRUE

		if(IS_IN_RECT(px, py,   5, 7,   7+16, 2+16))
			right.attackby(I, user, params)
			return TRUE

	return ..()

/obj/machinery/portable_recharger/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(fully_deployed)
		var/px = text2num(modifiers["icon-x"])
		var/py = text2num(modifiers["icon-y"])

		if(IS_IN_RECT(px, py,   5, 7,   -7+16, 2+16))
			left.attack_hand(user, modifiers)
			return TRUE

		if(IS_IN_RECT(px, py,   5, 7,   7+16, 2+16))
			right.attack_hand(user, modifiers)
			return TRUE

	if(panel_open) //if not, check if the panel is open and let them take the cell out
		if(cell)
			cell.forceMove(drop_location())
			if(!dumbass_check(user))
				to_chat(user, span_notice("Вытаскиваю батарею из зарядной станции."))
				user.put_in_hands(cell)
				cell.update_icon()
			cell = null
		else
			to_chat(user, span_notice("Батарея зарядной станции отсутствует."))



/// Returns false if user is not a dumbass. If C is not supplied, the currently installed cell is used.
/obj/machinery/portable_recharger/proc/dumbass_check(mob/living/carbon/human/user, obj/item/stock_parts/cell/C)
	var/you_fool = 0
	if(!C)
		C = cell
	if(!istype(user) || !C)
		return FALSE
	if(left.using_power)
		you_fool += 1
	if(right.using_power)
		you_fool += 1
	you_fool *= (user.gloves?.siemens_coefficient ? user.gloves.siemens_coefficient : 1)
	if(you_fool) // safety regulations are written in blood
		if(powernet_connection?.powernet)
			you_fool *= max(powernet_connection.surplus() / 25000, 1)
		if(cell)
			you_fool *= max(cell.charge / 5000, 1)
		cell.use(cell.charge)
		cell.update_icon()
		punishment(user, you_fool)
		user.client.give_award(/datum/award/achievement/popierdolilo, user)
		return TRUE
	return FALSE

/datum/award/achievement/popierdolilo
	name = "OFFICERA POPIERDOLILO"
	desc = "Техника безопасности написана кровью."
	icon = "popierdolilo"
	database_id = MEDAL_POPIERDOLILO

/obj/machinery/portable_recharger/proc/punishment(mob/living/carbon/human/user, mul)
	user.electrocute_act(10 * mul, "батарейки зарядника", 1, SHOCK_NOGLOVES & SHOCK_NOSTUN) //accounted for the gloves myself, also applying stun myself
	playsound(src, "sparks", 50, TRUE)
	var/msg
	switch(mul)
		if(32 to INFINITY)	// using both ports AND wearing very shit insuls AND also discharging a big fucking battery on yourself
							// honestly you're just asking for trouble at this point
			msg = "<font size=+3>О-О-О-О-О-ОХ-ОХХХ К-К-КАК П-П-ПРО-П-ПРОПЕРДОЛИЛО!!</font>"
			user.adjustFireLoss(10*mul)
			playsound(src.loc, 'sound/magic/lightningbolt.ogg', 50, TRUE, extrarange = 5)
			var/ass = Beam(user, "lightning[rand(1,12)]") // in case they didn't realise they fucked up big time
			QDEL_IN(ass, 10)
			spawn(10)
				take_damage(1984) //literally
				user.throw_at(get_edge_target_turf(user, get_dir(get_turf(src), get_turf(usr))), 3, spin = FALSE)
				user.AdjustKnockdown(90)
		if(16 to 32) // using both ports AND wearing very shit insuls
			msg = "<font size=+2>ПБХПХБПБПХ!</font>"
			user.adjustFireLoss(5*mul)
		if(4 to 16) // Reverse insuls (some cheap insuls do that, very cool right?) or using both charging ports
			msg = "<font size=+1>Б-БА-Б-БАТА-БЛЯЯТЬ!</font>"
		if(2 to 4) // no insuls or bad cheap insuls
			msg = "Б-б-б-блять! Надо было вытащить батарейку!"
		if(0 to 2) // cheap insuls with some protection
			msg = "Ай! Возможно, не стоит пытаться менять батарейку, пока зарядник используется."
	to_chat(user, span_userdanger(msg))

/obj/machinery/portable_recharger/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(world.time < deploytime + deploycd)
		return
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return FALSE
		if(isCharging())
			to_chat(usr, span_warning("Сначала надо вытащить оружие из зарядных портов."))
			return FALSE

		usr.visible_message(span_notice("[usr] сворачивает зарядную станцию.") , span_notice("Сворачиваю зарядную станцию."))
		add_fingerprint(usr)
		do_wrapup_stuff()
		chargerbox.anchored = TRUE
		chargerbox.forceMove(loc) // move charger item into our loc (usually a turf)
		forceMove(chargerbox)	// move ourself inside said item
		flick("sec-move", chargerbox)
		playsound(chargerbox, 'white/Feline/sounds/recharger_go.ogg', 30, FALSE)
		spawn(redeploycd)
			chargerbox.anchored = FALSE



/obj/machinery/recharger/portable/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "[base_icon_state]-open", layer, src, plane, alpha)

/obj/item/portable_recharger
	name = "портативная зарядная станция"
	desc = "Портативная зарядная станция для энергетического оружия. Оборудована двумя портами. Запитывается от станционной сети, использует батаерю в качестве резервного источника энергии. Для использования по назначению разложить в любом удобном месте."
	icon = 'white/Feline/icons/sec_recharger.dmi'
	icon_state = "case"
	inhand_icon_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	force = 15
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = 500)
	attack_verb_continuous = list("робастит")
	attack_verb_simple = list("робастит")
	hitsound = 'sound/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbox_pickup.ogg'
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	wound_bonus = 5
	var/obj/machinery/portable_recharger/recharger

/obj/item/portable_recharger/Initialize(mapload)
	. = ..()
	recharger = new(src, src)

//	Разворачивание станции
/obj/item/portable_recharger/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(user.a_intent != INTENT_HARM)
		if(isopenturf(target))
			if(isfloorturf(target))
				deploy_recharger(user, target)
			else
				to_chat(user, span_notice("Не могу развернуть зарядную станцию здесь!"))

/obj/item/portable_recharger/Destroy()
	if(!QDELETED(recharger))
		QDEL_NULL(recharger)
	. = ..()

/obj/item/portable_recharger/proc/deploy_recharger(mob/user, atom/location)
	recharger.deploytime = world.time
	recharger.forceMove(get_turf(location))
	user.transferItemToLoc(src, recharger, TRUE)
	add_fingerprint(user)
	user.visible_message(span_notice("[user] разворачивает зарядную станцию.") , span_notice("Разворачиваю зарядную станцию."))
	flick("sec-deploy", recharger)
	playsound(recharger, 'white/Feline/sounds/recharger_deploy.ogg', 30, FALSE)
	spawn(recharger.deploycd)
		recharger.do_deploy_stuff()


/obj/item/portable_recharger/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("Слишком далеко, чтобы рассмотреть дисплей зарядной станции!")
		return
	. += span_notice("Дисплей:")
	. += "</br>"
	if(recharger.cell)
		. += span_notice("Уроверь батареи - <b>[recharger.cell.charge*100/recharger.cell.maxcharge]%</b>.")
	else
		. += span_notice("Уровень батареи - БАТАРЕЯ ОТСУТСТВУЕТ!")




/obj/item/circuitboard/machine/portable_recharger
	name = "портативная зарядная станция"
	//desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. Для начала работы необходимо разложить в любом подходящем месте."
	desc = "Портативная зарядная станция для оружия. Оборудована двумя портами. Запитывается от станционной сети, использует батаерю в качестве резервного источника энергии."
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/portable_recharger
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stack/cable_coil = 5
		)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = TRUE


/obj/item/tactical_recharger
	name = "тактический оружейный зарядник"
	desc = "Продвинутая переносная зарядная станция для энергетического оружия. Скорость зарядки немного ниже по сравнению с более крупными образцами, однако ее использование все равно значительно расширяет общую потенциальную емкость энергетического оружия."
	icon = 'white/Feline/icons/tactical_recharger.dmi'
	icon_state = "toz"
	worn_icon = 'white/Feline/icons/tactical_recharger_body.dmi'
	worn_icon_state = "toz"
	force = 15
	dog_fashion = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'

	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell/high
	var/cell_imitator_lvl = 2500
	var/cell_imitator_max = 2500
	var/chargerate = 250

	var/obj/item/held_weapon = null
	var/using_power = FALSE
	var/recharge_coeff = 0.5

	var/last_use = 0 // world.time when last used
	var/cooldown = 800

	var/overlay_state
	var/mutable_appearance/gun_overlay
	var/static/list/holdable_weapons_list = list(
		/obj/item/gun/energy/disabler = "disabler",
		/obj/item/gun/energy/laser = "laser",
		/obj/item/gun/energy/laser/rangers = "rangerlaser",
		/obj/item/gun/energy/laser/captain = "cap",
		/obj/item/gun/energy/e_gun = "egun",
		/obj/item/gun/energy/e_gun/nuclear = "nuke",
		/obj/item/gun/energy/e_gun/hos = "hos",
		/obj/item/gun/energy/e_gun/stun = "egun_taser",
		/obj/item/gun/energy/xray = "xray",
		/obj/item/gun/energy/e_gun/mini = "pistol",
		/obj/item/gun/energy/pulse = "pulse",
		/obj/item/gun/energy/pulse/pistol = "pistol",
	)

/obj/item/tactical_recharger/Initialize(mapload)
	. = ..()
	cell = new cell_type(src)
	create_storage(type = /datum/storage/pockets/tactical)
	update_icon()
	update_appearance()

////////////////////////////////////////////////////
/datum/storage/pockets/tactical
	max_slots = 1
	max_specific_storage = WEIGHT_CLASS_BULKY
	rustle_sound = FALSE
	attack_hand_interact = TRUE
////////////////////////////////////////////////////

/obj/item/tactical_recharger/pulse/Initialize(mapload)
	. = ..()
	new /obj/item/gun/energy/pulse(src)
	update_appearance()

/obj/item/tactical_recharger/disabler/Initialize(mapload)
	. = ..()
	new /obj/item/gun/energy/disabler(src)
	update_appearance()

//Быстрое извлечение через ЛКМ, быстрое разоружение через "E" тут code\modules\mob\inventory.dm
/obj/item/tactical_recharger/attack_hand(mob/user)
	if(loc != user || user.get_item_by_slot(ITEM_SLOT_SUITSTORE) != src || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return ..()

	if(held_weapon)
		//var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] достаёт из тактического зарядника [skloname(held_weapon.name, VINITELNI)]."), span_notice("Достаю из тактического зарядника [skloname(held_weapon.name, VINITELNI)]."))
		user.put_in_hands(held_weapon)
		held_weapon = null
		update_appearance()
		update_icon()
		user.update_inv_s_store()
	else
		to_chat(user, span_warning("Крепления расстегнуты, [capitalize(src.name)] пуст."))

	return ..()

/obj/item/tactical_recharger/proc/run_check(mob/user, obj/W)
	. = user.m_intent == MOVE_INTENT_WALK
	if(!.)
		to_chat(user, span_alert("У меня не получается зарядить [skloname(W.name, VINITELNI)] на бегу!"))

/obj/item/tactical_recharger/attackby_secondary(obj/item/gun/energy/W, mob/user, params)

	if(!istype(W))
		return ..()

	if(!W.can_charge)
		to_chat(user, span_alert("[W.name] не имеет внешнего коннектора для зарядки!"))
		return

	var/obj/item/stock_parts/cell/target_cell = W.get_cell()
	if(!target_cell)
		to_chat(user, span_alert("В [skloname(W.name, PREDLOZHNI)] отсутствует батарея!"))
		return

	if(!cell)
		to_chat(user, span_alert("Батарея отсутствует!"))
		return

	if(cell.charge == 0)
		to_chat(user, span_alert("Батарея разряжена!"))
		return

	if(world.time < last_use + cooldown)
		to_chat(user, span_alert("Конденсаторы тактического зарядника всё ещё остывают!"))
		return

	var/was_running = user.m_intent == MOVE_INTENT_RUN
	if(was_running)
		user.toggle_move_intent()

	if(do_after(user, 30, src, IGNORE_USER_LOC_CHANGE & IGNORE_TARGET_LOC_CHANGE & IGNORE_SLOWDOWNS, extra_checks = CALLBACK(src, .proc/run_check, user, W)))
		var/target_draw = (target_cell.maxcharge-target_cell.charge) * 2.5
		var/actual_draw = min(cell.charge,  target_draw)
		cell.use(actual_draw)
		target_cell.give(actual_draw / 2.5)
		to_chat(user, span_notice("[target_draw == actual_draw ? "Полностью" : "Частично" ] заряжаю [skloname(W.name, VINITELNI)]"))
		new /obj/effect/particle_effect/sparks(get_turf(src))
		last_use = world.time

	if(was_running)
		user.toggle_move_intent()

/obj/item/tactical_recharger/update_icon_state()
	icon_state = initial(icon_state)
//	worn_icon_state = initial(worn_icon_state)
	cut_overlay(gun_overlay)
	if(held_weapon)
//		worn_icon_state = "full"

		if(held_weapon.type in holdable_weapons_list)
			overlay_state = holdable_weapons_list[held_weapon.type]
			gun_overlay = mutable_appearance(icon, overlay_state)
			add_overlay(gun_overlay)
		else
			overlay_state = "box"
			gun_overlay = mutable_appearance(icon, overlay_state)
			add_overlay(gun_overlay)

//			var/overlay_state = holdable_weapons_list[I.type]
//			. += mutable_appearance(icon, overlay_state, layer, src, plane, alpha)
//			icon_state = holdable_weapons_list[I.type]
	return ..()


///obj/item/tactical_recharger/process(delta_time)
//	using_power = FALSE
//	if(length(contents))
//		var/obj/item/I = contents[1]
//		charging = I
//	else
//		charging = null
//
//	if(charging)
//		var/obj/item/stock_parts/cell/C = charging.get_cell()
//		if(C)
//			if(C.charge < C.maxcharge)
//				if(cell.use(C.chargerate * recharge_coeff * delta_time / 2))
//					using_power = TRUE
//					cell_imitator_lvl = cell_imitator_lvl - (C.chargerate * recharge_coeff * delta_time / 2)
//					C.give(C.chargerate * recharge_coeff * delta_time / 2)
//					charging.update_icon()
//				else
//					if(cell_imitator_lvl < 0)	// защита от отрицательных значений
//						cell_imitator_lvl = 0
//	if(cell_imitator_lvl > cell_imitator_max)
//		cell_imitator_lvl = cell_imitator_max
//	update_icon()

/obj/item/tactical_recharger/update_overlays()
	. = ..()

	if(held_weapon)
		//if(using_power)
		//	. += mutable_appearance(icon, "toz-charge", layer, src, plane, alpha)
		//	. += emissive_appearance(icon, "toz-charge", src)
		//else
		. += mutable_appearance(icon, "toz-full", layer, src, plane, alpha)
		. += emissive_appearance(icon, "toz-full", src)

		var/w_cell_percent
		var/obj/item/stock_parts/cell/C = held_weapon.get_cell()
		switch(C.percent())
			if(0 to 10)
				w_cell_percent = "1"
			if(11 to 20)
				w_cell_percent = "2"
			if(21 to 30)
				w_cell_percent = "3"
			if(31 to 40)
				w_cell_percent = "4"
			if(41 to 50)
				w_cell_percent = "5"
			if(51 to 60)
				w_cell_percent = "6"
			if(61 to 70)
				w_cell_percent = "7"
			if(71 to 80)
				w_cell_percent = "8"
			if(81 to 90)
				w_cell_percent = "9"
			if(91 to 100)
				w_cell_percent = "10"

		. += mutable_appearance(icon, "toz-w_lvl-[w_cell_percent]", layer, src, plane, alpha)
		. += emissive_appearance(icon, "toz-w_lvl-[w_cell_percent]", src)

	var/cell_percent
	switch(cell_imitator_lvl*100/cell_imitator_max)
		if(0 to 14)
			cell_percent = "1"
		if(15 to 28)
			cell_percent = "2"
		if(29 to 42)
			cell_percent = "3"
		if(43 to 56)
			cell_percent = "4"
		if(57 to 70)
			cell_percent = "5"
		if(71 to 84)
			cell_percent = "6"
		if(85 to 100)
			cell_percent = "7"

	. += mutable_appearance(icon, "toz-c_lvl-[cell_percent]", layer, src, plane, alpha)
	. += emissive_appearance(icon, "toz-c_lvl-[cell_percent]", src)
