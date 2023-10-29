/datum/round_event_control/pirates
	name = "Спавн: Пираты"
	typepath = /datum/round_event/pirates
	weight = 8
	max_occurrences = 1
	min_players = 10
	dynamic_should_hijack = TRUE
	earliest_start = 30 MINUTES
	gamemode_blacklist = list("nuclear")

#define PIRATES_ROGUES "Rogues"
#define PIRATES_SILVERSCALES "Silverscales"
#define PIRATES_DUTCHMAN "Flying Dutchman"

/datum/round_event_control/pirates/preRunEvent()
	if (!SSmapping.empty_space)
		return EVENT_CANT_RUN

	return ..()

/datum/round_event/pirates/start()
	send_pirate_threat()

/proc/send_pirate_threat()
	var/pirate_type = pick(PIRATES_ROGUES, PIRATES_SILVERSCALES, PIRATES_DUTCHMAN)
	var/ship_template = null
	var/ship_name = "Space Privateers Association"
	var/payoff_min = 20000
	var/payoff = 0
	var/initial_send_time = world.time
	var/response_max_time = 2 MINUTES
	priority_announce("Входящая подпространственная передача данных. Открыт защищенный канал связи на всех коммуникационных консолях.", "Входящее сообщение", SSstation.announcer.get_rand_report_sound())
	var/datum/comm_message/threat = new
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
	if(D)
		payoff = max(payoff_min, FLOOR(D.account_balance * 0.80, 1000))
	switch(pirate_type)
		if(PIRATES_ROGUES)
			ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))
			ship_template = /datum/map_template/shuttle/pirate/default
			threat.title = "Предложение защиты сектора"
			threat.content = "Приветствуем вас с корабля [ship_name]. Ваш сектор нуждается в защите, заплатите нам [payoff] кредитов или на вас наверняка кто-то нападёт."
			threat.possible_answers = list("Мы заплатим.","Пахнет наёбом...")
		if(PIRATES_SILVERSCALES)
			ship_name = pick(strings(PIRATE_NAMES_FILE, "silverscale_names"))
			ship_template = /datum/map_template/shuttle/pirate/silverscale
			threat.title = "Пожертвование высшему обществу"
			threat.content = "Это [ship_name]. Серебряные чешуйки хотят собрать с вас дань. [payoff] кредитов решат проблему."
			threat.possible_answers = list("Мы заплатим.","Че, серьёзно? Пошли на хуй!")
		if(PIRATES_DUTCHMAN)
			ship_name = "Flying Dutchman"
			ship_template = /datum/map_template/shuttle/pirate/dutchman
			threat.title = "Бизнес-предложение"
			threat.content = "Это [ship_name]. Выплатите [payoff] кредит[get_num_string(payoff)] или вы пройдётесь по доске."
			threat.possible_answers = list("Мы заплатим.","Нет.")
	threat.answer_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pirates_answered), threat, payoff, ship_name, initial_send_time, response_max_time, ship_template)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_pirates), threat, ship_template, FALSE), response_max_time)
	SScommunications.send_message(threat,unique = TRUE)

/proc/pirates_answered(datum/comm_message/threat, payoff, ship_name, initial_send_time, response_max_time, ship_template)
	if(world.time > initial_send_time + response_max_time)
		priority_announce("Слишком поздно умолять о пощаде!",sender_override = ship_name)
		return
	if(threat && threat.answered == 1)
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(D)
			if(D.adjust_money(-payoff))
				priority_announce("Спасибо за кредиты, сухопутные крысы.",sender_override = ship_name)
				return
			else
				priority_announce("Пытаешься нас обмануть? Ты пожалеешь об этом!",sender_override = ship_name)
				spawn_pirates(threat, ship_template, TRUE)

/proc/spawn_pirates(datum/comm_message/threat, ship_template, skip_answer_check)
	if(!skip_answer_check && threat?.answered == 1)
		return

	var/list/candidates = poll_ghost_candidates("Хотите попасть в команду пиратов?", ROLE_TRAITOR)
	shuffle_inplace(candidates)

	var/datum/map_template/shuttle/pirate/ship = new ship_template
	var/x = rand(TRANSITIONEDGE,world.maxx - TRANSITIONEDGE - ship.width)
	var/y = rand(TRANSITIONEDGE,world.maxy - TRANSITIONEDGE - ship.height)
	var/z = SSmapping.empty_space.z_value
	var/turf/T = locate(x,y,z)
	if(!T)
		CRASH("Pirate event found no turf to load in")

	if(!ship.load(T))
		CRASH("Loading pirate ship failed!")

	for(var/turf/A in ship.get_affected_turfs(T))
		for(var/obj/effect/mob_spawn/human/pirate/spawner in A)
			if(candidates.len > 0)
				var/mob/our_candidate = candidates[1]
				spawner.create(our_candidate)
				candidates -= our_candidate
				notify_ghosts("Здесь есть что-то интересное: [our_candidate]!", source=our_candidate, action=NOTIFY_ORBIT, header="Пираты!")
			else
				notify_ghosts("Здесь есть что-то интересное: [spawner]!", source=spawner, action=NOTIFY_ORBIT, header="Пираты!")

	priority_announce("Вблизи станции обнаружен неопознанный вооруженный корабль.")

//Shuttle equipment

/obj/machinery/shuttle_scrambler
	name = "дата майнер"
	desc = "Эта куча хакерского оборудования крадет кредиты и данные из незащищенных систем, а так же блокирует грузовой шаттл."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator"
	density = TRUE
	var/active = FALSE
	var/credits_stored = 0
	var/siphon_per_tick = 50

/obj/machinery/shuttle_scrambler/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/shuttle_scrambler/process()
	if(active)
		if(is_station_level(z))
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				var/siphoned = min(D.account_balance,siphon_per_tick)
				D.adjust_money(-siphoned)
				credits_stored += siphoned
			interrupt_research()
		else
			return
	else
		STOP_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/proc/toggle_on(mob/user)
	SSshuttle.registerTradeBlockade(src)
	AddComponent(/datum/component/gps, "Канал кражи персональных данных")
	active = TRUE
	to_chat(user,span_notice("You toggle [src] [active ? "on":"off"]."))
	to_chat(user,span_warning("The scrambling signal can be now tracked by GPS."))
	START_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/interact(mob/user)
	if(!active)
		if(tgui_alert(user, "Turning the scrambler on will make the shuttle trackable by GPS. Are you sure you want to do it?", "Scrambler", list("Yes", "Cancel")) == "Cancel")
			return
		if(active || !user.canUseTopic(src, BE_CLOSE))
			return
		toggle_on(user)
		update_icon()
		send_notification()
	else
		dump_loot(user)

//interrupt_research
/obj/machinery/shuttle_scrambler/proc/interrupt_research()
	for(var/obj/machinery/rnd/server/S in GLOB.machines)
		if(S.machine_stat & (NOPOWER|BROKEN))
			continue
		S.emp_act(1)
		new /obj/effect/temp_visual/emp(get_turf(S))

/obj/machinery/shuttle_scrambler/proc/dump_loot(mob/user)
	if(credits_stored)	// Prevents spamming empty holochips
		new /obj/item/holochip(drop_location(), credits_stored)
		to_chat(user,span_notice("You retrieve the siphoned credits!"))
		credits_stored = 0
	else
		to_chat(user,span_notice("There's nothing to withdraw."))

/obj/machinery/shuttle_scrambler/proc/send_notification()
	priority_announce("Обнаружен сигнал кражи данных, источник зарегистрирован на локальных GPS устройствах.")

/obj/machinery/shuttle_scrambler/proc/toggle_off(mob/user)
	SSshuttle.clearTradeBlockade(src)
	active = FALSE
	STOP_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/update_icon_state()
	icon_state = active ? "dominator-Blue" : "dominator"
	return ..()

/obj/machinery/shuttle_scrambler/Destroy()
	toggle_off()
	return ..()

/obj/machinery/computer/shuttle_flight/pirate
	name = "pirate shuttle console"
	shuttleId = "pirateship"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	possible_destinations = "pirateship_away;pirateship_home;pirateship_custom"

/obj/docking_port/mobile/pirate
	name = "pirate shuttle"
	id = "pirateship"
	rechargeTime = 3 MINUTES

/obj/machinery/suit_storage_unit/pirate
	suit_type = /obj/item/clothing/suit/space
	helmet_type = /obj/item/clothing/head/helmet/space
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/tank/internals/oxygen

/obj/machinery/loot_locator
	name = "Поисковик Сокровищ"
	desc = "Эта удивительная машина ищет и выводит на экран ценность ближайших кладов."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	density = TRUE
	var/cooldown = 300
	var/next_use = 0

/obj/machinery/loot_locator/interact(mob/user)
	if(world.time <= next_use)
		to_chat(user,span_warning("[capitalize(src.name)] перезаряжается."))
		return
	next_use = world.time + cooldown
	var/atom/movable/AM = find_random_loot()
	if(!AM)
		say("Ничего ценного не обнаружено. Попробуйте ещё.")
	else
		say("Обнаружено: [AM.name] в [get_area_name(AM)]")

/obj/machinery/loot_locator/proc/find_random_loot()
	if(!GLOB.exports_list.len)
		setupExports()
	var/list/possible_loot = list()
	for(var/datum/export/pirate/E in GLOB.exports_list)
		possible_loot += E
	var/datum/export/pirate/P
	var/atom/movable/AM
	while(!AM && possible_loot.len)
		P = pick_n_take(possible_loot)
		AM = P.find_loot()
	return AM

//Pad & Pad Terminal
/obj/machinery/piratepad
	name = "платформа отправки"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "lpad-idle-o"
	var/idle_state = "lpad-idle-o"
	var/warmup_state = "lpad-idle"
	var/sending_state = "lpad-beam"
	var/cargo_hold_id

/obj/machinery/piratepad/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, span_notice("Записываю [src] в буффере [I]."))
		I.buffer = src
		return TRUE

/obj/machinery/computer/piratepad_control
	name = "управление платформой торговли"
	var/status_report = "Готово к доставке."
	var/obj/machinery/piratepad/pad
	var/warmup_time = 100
	var/sending = FALSE
	var/points = 0
	var/datum/export_report/total_report
	var/sending_timer
	var/cargo_hold_id
	var/interface_type = "CargoHoldTerminal"

/obj/machinery/computer/piratepad_control/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/piratepad_control/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I) && istype(I.buffer,/obj/machinery/piratepad))
		to_chat(user, span_notice("Привязываю [src] используя [I.buffer] в буффере [I]."))
		pad = I.buffer
		return TRUE

/obj/machinery/computer/piratepad_control/LateInitialize()
	. = ..()
	if(cargo_hold_id)
		for(var/obj/machinery/piratepad/P in GLOB.machines)
			if(P.cargo_hold_id == cargo_hold_id)
				pad = P
				return
	else
		pad = locate() in range(4,src)

/obj/machinery/computer/piratepad_control/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_type, name)
		ui.open()

/obj/machinery/computer/piratepad_control/ui_data(mob/user)
	var/list/data = list()
	data["points"] = points
	data["pad"] = pad ? TRUE : FALSE
	data["sending"] = sending
	data["status_report"] = status_report
	return data

/obj/machinery/computer/piratepad_control/ui_act(action, params)
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

/obj/machinery/computer/piratepad_control/proc/recalc()
	if(sending)
		return

	status_report = "Возможная ценность: "
	var/value = 0
	var/datum/export_report/ex = new
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		export_item_and_contents(AM, apply_elastic = FALSE, dry_run = TRUE, external_report = ex)

	for(var/datum/export/E in ex.total_amount)
		status_report += E.total_printout(ex,notes = FALSE)
		status_report += " "
		value += ex.total_value[E]

	if(!value)
		status_report += "0"

/obj/machinery/computer/piratepad_control/proc/send()
	if(!sending)
		return

	var/datum/export_report/ex = new

	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		export_item_and_contents(AM, EXPORT_PIRATE | EXPORT_CARGO | EXPORT_CONTRABAND | EXPORT_EMAG, apply_elastic = FALSE, delete_unsold = FALSE, external_report = ex)

	status_report = "Продажа: "
	var/value = 0
	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex,notes = FALSE) //Don't want nanotrasen messages, makes no sense here.
		if(!export_text)
			continue

		status_report += export_text
		status_report += " "
		value += ex.total_value[E]

	if(!total_report)
		total_report = ex
	else
		total_report.exported_atoms += ex.exported_atoms
		for(var/datum/export/E in ex.total_amount)
			total_report.total_amount[E] += ex.total_amount[E]
			total_report.total_value[E] += ex.total_value[E]
		playsound(loc, 'sound/machines/wewewew.ogg', 70, TRUE)

	points += value

	if(!value)
		status_report += "Ничего"

	pad.visible_message(span_notice("[capitalize(pad.name)] активируется!"))
	flick(pad.sending_state,pad)
	pad.icon_state = pad.idle_state
	sending = FALSE

/obj/machinery/computer/piratepad_control/proc/start_sending()
	if(sending)
		return
	sending = TRUE
	status_report = "Отправка... "
	pad.visible_message(span_notice("[capitalize(pad.name)] начинает разогреваться."))
	pad.icon_state = pad.warmup_state
	sending_timer = addtimer(CALLBACK(src,PROC_REF(send)),warmup_time, TIMER_STOPPABLE)

/obj/machinery/computer/piratepad_control/proc/stop_sending(custom_report)
	if(!sending)
		return
	sending = FALSE
	status_report = "Готово к отправке."
	if(custom_report)
		status_report = custom_report
	pad.icon_state = pad.idle_state
	deltimer(sending_timer)

//Attempts to find the thing on station
/datum/export/pirate/proc/find_loot()
	return

/datum/export/pirate/ransom
	cost = CARGO_CRATE_VALUE * 300
	unit_name = "hostage"
	export_types = list(/mob/living/carbon/human)

/datum/export/pirate/ransom/find_loot()
	var/list/head_minds = SSjob.get_living_heads()
	var/list/head_mobs = list()
	for(var/datum/mind/M in head_minds)
		head_mobs += M.current
	if(head_mobs.len)
		return pick(head_mobs)

/datum/export/pirate/ransom/get_cost(atom/movable/AM)
	var/mob/living/carbon/human/H = AM
	if(H.stat != CONSCIOUS || !H.mind || !H.mind.assigned_role) //mint condition only
		return 0
	else if("pirate" in H.faction) //can't ransom your fellow pirates to CentCom!
		return 0
	else
		if(H.mind.assigned_role in GLOB.command_positions)
			return 3000
		else
			return 1000

/datum/export/pirate/parrot
	cost = CARGO_CRATE_VALUE * 200
	unit_name = "alive parrot"
	export_types = list(/mob/living/simple_animal/parrot)

/datum/export/pirate/parrot/find_loot()
	for(var/mob/living/simple_animal/parrot/P in GLOB.alive_mob_list)
		var/turf/T = get_turf(P)
		if(T && is_station_level(T.z))
			return P

/datum/export/pirate/cash
	cost = 1
	unit_name = "bills"
	export_types = list(/obj/item/stack/spacecash)

/datum/export/pirate/cash/get_amount(obj/O)
	var/obj/item/stack/spacecash/C = O
	return ..() * C.amount * C.value

/datum/export/pirate/holochip
	cost = 1
	unit_name = "holochip"
	export_types = list(/obj/item/holochip)

/datum/export/pirate/holochip/get_cost(atom/movable/AM)
	var/obj/item/holochip/H = AM
	return H.credits
