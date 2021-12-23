#define FIREALARM_COOLDOWN 67 // Chosen fairly arbitrarily, it is the length of the audio in FireAlarm.ogg. The actual track length is 7 seconds 8ms but but the audio stops at 6s 700ms

/obj/item/electronics/firealarm
	name = "электроника пожарной сигнализации"
	desc = "Схема пожарной сигнализации. Может выдерживать температуру до 40 градусов по Цельсию."

/obj/item/wallframe/firealarm
	name = "рамка пожарной сигнализации"
	desc = "Используется для создания пожарной сигнализации."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	result_path = /obj/machinery/firealarm

/obj/machinery/firealarm
	name = "пожарная тревога"
	desc = "<i>\"Потяните в случае чрезвычайной ситуации\"</i>. То есть тяните его постоянно."
	gender = FEMALE
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	max_integrity = 250
	integrity_failure = 0.4
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 90, ACID = 30)
	use_power = IDLE_POWER_USE
	idle_power_usage = 200
	active_power_usage = 600
	power_channel = AREA_USAGE_ENVIRON
	resistance_flags = FIRE_PROOF

	light_power = 0
	light_range = 7
	light_color = COLOR_VIVID_RED

	//Trick to get the glowing overlay visible from a distance
	luminosity = 1

	var/detecting = 1
	var/buildstage = 2 // 2 = complete, 1 = no wires, 0 = circuit gone
	COOLDOWN_DECLARE(last_alarm)
	var/area/myarea = null
	//Has this firealarm been triggered by its enviroment?
	var/triggered = FALSE

/obj/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()
	if(dir)
		src.setDir(dir)
	if(building)
		buildstage = 0
		panel_open = TRUE
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
	update_icon()
	myarea = get_area(src)
	LAZYADD(myarea.firealarms, src)

/obj/machinery/firealarm/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/machinery/firealarm/Destroy()
	if(myarea)
		myarea.firereset(src)
		LAZYREMOVE(myarea.firealarms, src)
	return ..()

/obj/machinery/firealarm/update_icon_state()
	if(panel_open)
		icon_state = "fire_b[buildstage]"
		return

	if(machine_stat & BROKEN)
		icon_state = "firex"
		return

	icon_state = "fire0"

/obj/machinery/firealarm/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)

	if(machine_stat & NOPOWER)
		return

	. += "fire_overlay"

	if(is_station_level(z))
		. += "fire_[GLOB.security_level]"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_[GLOB.security_level]", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_[GLOB.security_level]", layer, EMISSIVE_PLANE, dir)
	else
		. += "fire_[SEC_LEVEL_GREEN]"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_[SEC_LEVEL_GREEN]", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_[SEC_LEVEL_GREEN]", layer, EMISSIVE_PLANE, dir)

	var/area/A = get_area(src)

	if(!detecting || !A.fire)
		. += "fire_off"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_off", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_off", layer, EMISSIVE_PLANE, dir)
	else if(obj_flags & EMAGGED)
		. += "fire_emagged"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_emagged", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_emagged", layer, EMISSIVE_PLANE, dir)
	else
		. += "fire_on"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_on", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_on", layer, EMISSIVE_PLANE, dir)

	if(!panel_open && detecting && triggered) //It just looks horrible with the panel open
		. += "fire_detected"
		SSvis_overlays.add_vis_overlay(src, icon, "fire_detected", layer, plane, dir)
		SSvis_overlays.add_vis_overlay(src, icon, "fire_detected", layer, EMISSIVE_PLANE, dir) //Pain

/obj/machinery/firealarm/emp_act(severity)
	. = ..()

	if (. & EMP_PROTECT_SELF)
		return

	if(prob(50 / severity))
		alarm()

/obj/machinery/firealarm/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	update_icon()
	if(user)
		user.visible_message(span_warning("Искры вылетают из [src]!") ,
							span_notice("Взламываю [src], отключая её термальные сенсоры."))
	playsound(src, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/machinery/firealarm/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return (exposed_temperature > T0C + 200 || exposed_temperature < BODYTEMP_COLD_DAMAGE_LIMIT) && !(obj_flags & EMAGGED) && !machine_stat

/obj/machinery/firealarm/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	if(!detecting)
		return
	if(!triggered)
		triggered = TRUE
		myarea.triggered_firealarms += 1
		update_icon()
	alarm()

/obj/machinery/firealarm/atmos_end(datum/gas_mixture/air, exposed_temperature)
	if(!detecting)
		return
	if(triggered)
		triggered = FALSE
		myarea.triggered_firealarms -= 1
		update_icon()

/obj/machinery/firealarm/proc/alarm(mob/user)
	if(!is_operational || !COOLDOWN_FINISHED(src, last_alarm))
		return
	COOLDOWN_START(src, last_alarm, FIREALARM_COOLDOWN)
	var/area/A = get_area(src)
	A.firealert(src)
	playsound(loc, 'goon/sound/machinery/FireAlarm.ogg', 75)
	if(user)
		log_game("[user] triggered a fire alarm at [COORD(src)]")

/obj/machinery/firealarm/proc/reset(mob/user)
	if(!is_operational)
		return
	var/area/A = get_area(src)
	A.firereset()
	if(user)
		log_game("[user] reset a fire alarm at [COORD(src)]")

/obj/machinery/firealarm/attack_hand(mob/user)
	if(buildstage != 2)
		return ..()
	add_fingerprint(user)
	var/area/A = get_area(src)
	if(A.fire)
		reset(user)
	else
		alarm(user)

/obj/machinery/firealarm/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/firealarm/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/firealarm/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(W.tool_behaviour == TOOL_SCREWDRIVER && buildstage == 2)
		W.play_tool_sound(src)
		panel_open = !panel_open
		to_chat(user, span_notice("Провода теперь [panel_open ? "доступны" : "скрыты"]."))
		update_icon()
		return

	if(panel_open)

		if(W.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
			if(obj_integrity < max_integrity)
				if(!W.tool_start_check(user, amount=0))
					return

				to_chat(user, span_notice("Начинаю чинить [src]..."))
				if(W.use_tool(src, user, 40, volume=50))
					obj_integrity = max_integrity
					to_chat(user, span_notice("Чиню [src]."))
			else
				to_chat(user, span_warning("[capitalize(src.name)] уже в полном порядке!"))
			return

		switch(buildstage)
			if(2)
				if(W.tool_behaviour == TOOL_MULTITOOL)
					detecting = !detecting
					if (src.detecting)
						user.visible_message(span_notice("[user] переподключает детектирующую единицу [src]!") , span_notice("Переподключаю детектирующую единицу [src]."))
					else
						user.visible_message(span_notice("[user] отключает детектирующую единицу [src]!") , span_notice("Отключаю детектирующую единицу [src]"))
					return

				else if(W.tool_behaviour == TOOL_WIRECUTTER)
					buildstage = 1
					W.play_tool_sound(src)
					new /obj/item/stack/cable_coil(user.loc, 5)
					to_chat(user, span_notice("Перерезаю провода [src]."))
					update_icon()
					return

				else if(W.force) //hit and turn it on
					..()
					var/area/A = get_area(src)
					if(!A.fire)
						alarm()
					return

			if(1)
				if(istype(W, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/coil = W
					if(coil.get_amount() < 5)
						to_chat(user, span_warning("Мне потребуется больше проводов для этого!"))
					else
						coil.use(5)
						buildstage = 2
						to_chat(user, span_notice("Подключаю проводку к [src]."))
						update_icon()
					return

				else if(W.tool_behaviour == TOOL_CROWBAR)
					user.visible_message(span_notice("[user.name] начинает извлекать электронику из [src.name].") , \
										span_notice("Начинаю извлекать электронику из [src.name]..."))
					if(W.use_tool(src, user, 20, volume=50))
						if(buildstage == 1)
							if(machine_stat & BROKEN)
								to_chat(user, span_notice("Вырываю сгоревшую плату."))
								set_machine_stat(machine_stat & ~BROKEN)
							else
								to_chat(user, span_notice("Вытаскиваю плату."))
								new /obj/item/electronics/firealarm(user.loc)
							buildstage = 0
							update_icon()
					return
			if(0)
				if(istype(W, /obj/item/electronics/firealarm))
					to_chat(user, span_notice("Вставляю плату."))
					qdel(W)
					buildstage = 1
					update_icon()
					return

				else if(istype(W, /obj/item/electroadaptive_pseudocircuit))
					var/obj/item/electroadaptive_pseudocircuit/P = W
					if(!P.adapt_circuit(user, 15))
						return
					user.visible_message(span_notice("[user] создаёт специальную плату и вставляет в [src].") , \
					span_notice("Адаптирую микросхему и вставляю в пожарную тревогу."))
					buildstage = 1
					update_icon()
					return

				else if(W.tool_behaviour == TOOL_WRENCH)
					user.visible_message(span_notice("[user] снимает пожарную тревогу со стену.") , \
						span_notice("Снимаю пожарную тревогу со стены."))
					var/obj/item/wallframe/firealarm/frame = new /obj/item/wallframe/firealarm()
					frame.forceMove(user.drop_location())
					W.play_tool_sound(src)
					qdel(src)
					return

	return ..()

/obj/machinery/firealarm/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if((buildstage == 0) && (the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)
	return FALSE

/obj/machinery/firealarm/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_UPGRADE_SIMPLE_CIRCUITS)
			user.visible_message(span_notice("[user] создаёт специальную плату и вставляет в [src].") , \
			span_notice("Адаптирую микросхему и вставляю в пожарную тревогу."))
			buildstage = 1
			update_icon()
			return TRUE
	return FALSE

/obj/machinery/firealarm/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(obj_integrity > 0 && !(machine_stat & BROKEN) && buildstage != 0)
			if(prob(33))
				alarm()

/obj/machinery/firealarm/singularity_pull(S, current_size)
	if (current_size >= STAGE_FIVE) // If the singulo is strong enough to pull anchored objects, the fire alarm experiences integrity failure
		deconstruct()
	..()

/obj/machinery/firealarm/obj_break(damage_flag)
	if(buildstage == 0) //can't break the electronics if there isn't any inside.
		return
	. = ..()
	if(.)
		LAZYREMOVE(myarea.firealarms, src)

/obj/machinery/firealarm/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, 1)
		if(!(machine_stat & BROKEN))
			var/obj/item/I = new /obj/item/electronics/firealarm(loc)
			if(!disassembled)
				I.obj_integrity = I.max_integrity * 0.5
		new /obj/item/stack/cable_coil(loc, 3)
	qdel(src)

/obj/machinery/firealarm/proc/update_fire_light(fire)
	if(fire == !!light_power)
		return  // do nothing if we're already active
	if(fire)
		set_light(l_power = 0.8)
	else
		set_light(l_power = 0)

/obj/machinery/firealarm/directional/north
	pixel_y = 26

/obj/machinery/firealarm/directional/south
	dir = NORTH
	pixel_y = -26

/obj/machinery/firealarm/directional/east
	dir = WEST
	pixel_x = 26

/obj/machinery/firealarm/directional/west
	dir = EAST
	pixel_x = -26

/*
 * Return of Party button
 */

/area
	var/party = FALSE

/obj/machinery/firealarm/partyalarm
	name = "ПАТИ"
	desc = "Ruzone went up!"
	var/static/party_overlay

/obj/machinery/firealarm/partyalarm/reset()
	if (machine_stat & (NOPOWER|BROKEN))
		return
	var/area/A = get_area(src)
	if (!A || !A.party)
		return
	A.party = FALSE
	A.cut_overlay(party_overlay)

/obj/machinery/firealarm/partyalarm/alarm()
	if (machine_stat & (NOPOWER|BROKEN))
		return
	var/area/A = get_area(src)
	if (!A || A.party || A.name == "Space")
		return
	A.party = TRUE
	if (!party_overlay)
		party_overlay = iconstate2appearance('icons/turf/areas.dmi', "party")
	A.add_overlay(party_overlay)
