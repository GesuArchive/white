/datum/job/station_engineer/mechanic
	title = JOB_MECHANIC
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/mechanic

	skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)
	minimal_skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_ENG

	metalocked = TRUE

/datum/id_trim/job/mechanic
	assignment = JOB_MECHANIC
	trim_state = "trim_mechanic"
	full_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_AUX_BASE,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_ATMOSPHERICS)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_AUX_BASE,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_ATMOSPHERICS)
	config_job = "mechanic"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CE, ACCESS_CHANGE_IDS)

/datum/outfit/job/mechanic
	name = JOB_MECHANIC
	jobtype = /datum/job/station_engineer/mechanic

	head = /obj/item/clothing/head/welding/open
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	suit = /obj/item/clothing/suit/mechanicus
	gloves = /obj/item/clothing/gloves/color/yellow
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/storage/part_replacer
	l_pocket = /obj/item/modular_computer/tablet/pda/engineering
	r_pocket = /obj/item/t_scanner

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET

	skillchips = list(/obj/item/skillchip/job/engineer)

	id_trim = /datum/id_trim/job/mechanic

/obj/machinery/copytech
	name = "копирующий станок"
	desc = "Создаёт что угодно в неограниченных объёмах. Потребляет много энергии."
	icon = 'white/valtos/icons/something.dmi'
	circuit = /obj/item/circuitboard/machine/copytech
	icon_state = "apparatus"
	density = TRUE
	layer = MOB_LAYER
	var/timer
	var/scanned_type = null
	var/tier_rate = 1
	var/obj/machinery/copytech_platform/cp = null
	var/current_design = null
	var/working = FALSE
	var/atom/movable/active_item = null
	var/crystals = 0
	var/max_crystals = 4
	var/obj/structure/cable/attached_cable
	var/siphoned_power = 0
	var/siphon_max = 1e7

/obj/machinery/copytech/process()
	if(siphoned_power >= siphon_max)
		return
	update_cable()
	if(attached_cable)
		attempt_siphon()

/obj/machinery/copytech/proc/update_cable()
	var/turf/T = get_turf(src)
	attached_cable = locate(/obj/structure/cable) in T

/obj/machinery/copytech/proc/attempt_siphon()
	var/surpluspower = clamp(attached_cable.surplus(), 0, (siphon_max - siphoned_power))
	if(surpluspower)
		attached_cable.add_load(surpluspower)
		siphoned_power += surpluspower

/obj/machinery/copytech/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Примерное время создания объекта: [time2text(get_replication_speed(tier_rate), "mm:ss")].</span>\n"
	. += "<span class='info'>Оставшееся время: [timeleft(timer)] секунд.</span>\n"
	. += "<span class='info'>Внутри запасено: <b>[crystals]/[max_crystals] человеческой кожи</b>.</span>\n"
	. += span_info("Накоплено энергии: <b>[num2loadingbar((siphon_max-siphoned_power)/siphon_max, 10, reverse = TRUE)] [display_power(siphoned_power)]/[display_power(siphon_max)]</b>.")
	. += "<hr><span class='notice'>Похоже, ему требуется подключение к энергосети через кабель.</span>"

/obj/machinery/copytech/Initialize(mapload)
	. = ..()
	check_platform()

/obj/machinery/copytech/update_icon()
	. = ..()
	if(working)
		icon_state = "apparatus_on"
	else
		icon_state = "apparatus"

/obj/machinery/copytech/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/stack/sheet/animalhide/human))
		if(crystals >= max_crystals)
			to_chat(user, span_warning("Перебор!"))
			return
		var/obj/item/stack/BC = I
		if(!BC.amount)
			to_chat(user, span_warning("БЛЯТЬ!"))
			return
		crystals++
		user.visible_message("[user] вставляет [I.name] в [src.name].", span_notice("Вставляю [I.name] в [src.name]."))
		BC.use(1)
		return
	else
		return ..()

/obj/machinery/copytech/attack_hand(mob/living/user)
	. = ..()
	if(working)
		say("Работа в процессе!")
		return
	if(siphoned_power < siphon_max)
		say("Недостаточно энергии.")
		return
	if(!cp)
		say("Не обнаружена дезинтегрирующая платформа. Попытка синхронизации...")
		check_platform()
		return
	if(!current_design)
		say("Не обнаружено дизайна. Разберите что-то сперва на дезинтегрирующей платформе!")
		return
	if(!crystals)
		say("Недостаточно человеческой кожи для начала работы!")
		return
	start_working()


/obj/machinery/copytech/proc/start_working()
	say("Приступаю к процессу создания объекта...")
	working = TRUE
	update_icon()

	var/atom/drop_loc = drop_location()

	if(ispath(current_design, /obj))
		var/obj/O = new current_design(drop_loc)
		O.set_anchored(TRUE)
		O.layer = ABOVE_MOB_LAYER
		O.alpha = 0
		var/mutable_appearance/result = mutable_appearance(O.icon, O.icon_state)
		var/mutable_appearance/scanline = mutable_appearance('icons/effects/effects.dmi',"transform_effect")
		O.transformation_animation(result, time = get_replication_speed(tier_rate), transform_overlay = scanline)
		active_item = O
		crystals--
		siphoned_power = 0
		timer = addtimer(CALLBACK(src, PROC_REF(finish_work), O), get_replication_speed(tier_rate), TIMER_STOPPABLE)
		return TRUE

	if (ispath(current_design, /mob/living))
		if(tier_rate < 8)
			say("Слишком слабая мощность лазера.")
			return FALSE
		var/mob/living/M = new current_design(drop_loc)
		M.SetParalyzed(get_replication_speed(tier_rate) * 1.5)
		M.emote("agony")
		M.layer = ABOVE_MOB_LAYER
		var/mutable_appearance/result = mutable_appearance(M.icon, M.icon_state)
		var/mutable_appearance/scanline = mutable_appearance('icons/effects/effects.dmi',"transform_effect")
		M.transformation_animation(result, time = get_replication_speed(tier_rate), transform_overlay = scanline)
		active_item = M
		crystals--
		siphoned_power = 0
		timer = addtimer(CALLBACK(src, PROC_REF(finish_work), M), get_replication_speed(tier_rate), TIMER_STOPPABLE)
		return TRUE

	say("Неизвестная ошибка! Пожалуйста, свяжитесь с инженерным департаментом.")
	return FALSE
/obj/machinery/copytech/proc/finish_work(obj/O)
	if(istype(O, /mob/living))
		var/mob/living/L = O
		L.adjust_disgust(70)
		L.adjustCloneLoss(30)
		L.Jitter(40)
		L.AdjustKnockdown(20)
	O.set_anchored(FALSE)
	O.layer = initial(O.layer)
	O.alpha = initial(O.alpha)
	say("Завершение работы...")
	timer = null
	working = FALSE
	update_icon()



/obj/machinery/copytech/RefreshParts()
	. = ..()
	var/T = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		T += M.rating
	tier_rate = T

/proc/get_replication_speed(tier)
	return (60 SECONDS) / tier

/obj/machinery/copytech/proc/check_platform()
	if(!cp)
		for(var/obj/machinery/copytech_platform/M in range(3, src))
			cp = M
			return TRUE
	return FALSE

/obj/machinery/copytech_platform
	name = "дезинтегрирующая платформа"
	desc = "Уничтожает всё, что на ней есть, если активировать. Потребляет много энергии."
	icon = 'white/valtos/icons/something.dmi'
	circuit = /obj/item/circuitboard/machine/copytech_platform
	icon_state = "platform"
	density = 0
	layer = MOB_LAYER
	var/timer
	var/tier_rate = 1
	var/obj/machinery/copytech/ct = null
	var/working = FALSE
	var/atom/movable/active_item = null
	var/list/blacklisted_items = list(
			/obj/item/card/id,
			/obj/item/stack/telecrystal,
			/obj/item/uplink,
			/obj/item/pen/uplink,
			/obj/item/multitool/uplink,
			/obj/item/dice/d20/fate/one_use,
			/obj/item/dice/d100/fate/one_use,
			/obj/item/storage/box/syndie_kit,
			/obj/structure/closet/crate/necropolis,
			/obj/item/book/granter,
			/obj/item/storage/box/syndicate,
			/obj/item/spellbook
		)
	var/obj/structure/cable/attached_cable
	var/siphoned_power = 0
	var/siphon_max = 1e7


/obj/machinery/copytech_platform/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(movable_crossed),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/copytech_platform/process(delta_time)
	if(siphoned_power < siphon_max)
		update_cable()
		if(attached_cable)
			attempt_siphon()
	if(working)
		for(var/mob/living/L in get_turf(src))
			L.adjustFireLoss(10*delta_time)
			L.set_fire_stacks(5)
			L.ignite_mob()
			playsound(L, 'sound/machines/shower/shower_mid1.ogg', 90, TRUE)

/obj/machinery/copytech_platform/proc/update_cable()
	var/turf/T = get_turf(src)
	attached_cable = locate(/obj/structure/cable) in T

/obj/machinery/copytech_platform/proc/attempt_siphon()
	var/surpluspower = clamp(attached_cable.surplus(), 0, (siphon_max - siphoned_power))
	if(surpluspower)
		attached_cable.add_load(surpluspower)
		siphoned_power += surpluspower

/obj/machinery/copytech_platform/RefreshParts()
	. = ..()
	var/T = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		T += M.rating
	tier_rate = T

/obj/machinery/copytech_platform/proc/movable_crossed(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!working)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		L.adjustFireLoss(20)
		L.set_fire_stacks(5)
		L.ignite_mob()
		L.visible_message(span_danger("<b>[L]</b> прожаривается!"))
		playsound(L, 'sound/machines/shower/shower_mid1.ogg', 90, TRUE)

/obj/machinery/copytech_platform/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Примерное время для уничтожения объекта: [time2text(get_replication_speed(tier_rate), "mm:ss")].</span>\n"
	. += "<span class='info'>Оставшееся время: [time2text(timeleft(timer), "mm:ss")]</span>\n"
	. += span_info("Накоплено энергии: <b>[num2loadingbar((siphon_max-siphoned_power)/siphon_max, 10, reverse = TRUE)] [display_power(siphoned_power)]/[display_power(siphon_max)]</b>.")
	. += "<hr><span class='notice'>Похоже, ему требуется подключение к энергосети через кабель.</span>"

/obj/machinery/copytech_platform/Initialize(mapload)
	. = ..()
	check_copytech()

/obj/machinery/copytech_platform/update_icon()
	. = ..()
	if(working)
		icon_state = "platform_on"
	else
		icon_state = "platform"

/obj/machinery/copytech_platform/attack_hand(mob/living/user)
	. = ..()
	if(working)
		say("Работа в процессе!")
		return
	if(siphoned_power < siphon_max)
		say("Недостаточно энергии.")
		return
	if(!ct)
		say("Не обнаружен копирующий станок. Попытка синхронизации...")
		check_copytech()
		return
	destroy_thing(user)


/obj/machinery/copytech_platform/proc/check_copytech()
	if(!ct)
		for(var/obj/machinery/copytech/M in range(3, src))
			ct = M
			return TRUE
	return FALSE

/obj/machinery/copytech_platform/proc/destroy_thing(mob/user)
	if(!ct )
		return FALSE
	var/turf/T = get_turf(src)
	var/atom/movable/D = null
	if(T?.contents)
		for(var/thing in T.contents)
			if(istype(thing, /obj))
				var/obj/O = thing
				if(O.anchored || (O.resistance_flags & INDESTRUCTIBLE) || O == src)
					continue
				D = thing
			if(istype(thing, /mob/living) && tier_rate >= 8)
				D = thing

	if(!D)
		return

	for(var/type in blacklisted_items)
		if(istype(D, type))
			if(user)
				message_admins("[key_name(user)] попытался скопировать [D.name] ([D.type])!")
			say("СИСТЕМА ПОИСКА ПИДОРАСОВ АКТИВИРОВАНА!")
			sleep(3 SECONDS)
			say("ПИДОРАС НАЙДЕН!")
			sleep(1 SECONDS)
			say("Приступаю к процессу дезинтеграции объекта...")
			if(isliving(D))
				var/mob/living/M = D
				M.Paralyze(get_replication_speed(tier_rate) * 2)
				M.emote("agony")
				M.layer = ABOVE_MOB_LAYER
			sleep(1 SECONDS)
			if(user)
				to_chat(user, span_alert("Ну бл~"))
				explosion(src, light_impact_range = 1)
			if(isliving(user))
				var/mob/living/L = user
				L.gib()
			explosion(src, devastation_range = 3, heavy_impact_range = 7, light_impact_range = 14)
			return

	say("Приступаю к процессу дезинтеграции объекта...")
	working = TRUE
	update_icon()

	D.set_anchored(TRUE)
	if(isliving(D))
		var/mob/living/M = D
		M.SetParalyzed(get_replication_speed(tier_rate) * 2)
		M.emote("agony")
		M.layer = ABOVE_MOB_LAYER
	D.layer = ABOVE_MOB_LAYER
	var/mutable_appearance/result = mutable_appearance('icons/effects/effects.dmi',"nothing")
	var/mutable_appearance/scanline = mutable_appearance('icons/effects/effects.dmi',"transform_effect")
	D.transformation_animation(result, time = get_replication_speed(tier_rate), transform_overlay = scanline)
	active_item = D
	siphoned_power = 0
	timer = addtimer(CALLBACK(src, PROC_REF(finish_work), D), get_replication_speed(tier_rate), TIMER_STOPPABLE)
	return TRUE

/obj/machinery/copytech_platform/proc/finish_work(obj/D)
	if(!src)
		return
	if(get_turf(D) != get_turf(src))
		say("Ошибка!")
		working = FALSE
		update_icon()
		return

	ct.current_design = D.type
	say("Завершение работы...")
	timer = null
	qdel(D)
	working = FALSE
	update_icon()

/obj/item/circuitboard/machine/copytech
	name = "Копирующий станок (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/copytech
	req_components = list(/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/copytech_platform
	name = "Дезинтегрирующая платформа (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/copytech_platform
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
