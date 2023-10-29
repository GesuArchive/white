GLOBAL_DATUM_INIT(keycard_events, /datum/events, new)

#define KEYCARD_RED_ALERT "Красный Код"
#define KEYCARD_EMERGENCY_MAINTENANCE_ACCESS "Аварийный доступ к техтоннелям"
#define KEYCARD_MIGGER_ALARM "Иммиграционная политика"
#define KEYCARD_BSA_UNLOCK "Разблокировка Блюспейс Артиллерии"

/obj/machinery/keycard_auth
	name = "Устройство аутентификации"
	desc = "Используется для запуска функций станции, для аутентификации которых требуется более одной идентификационной карты."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	power_channel = AREA_USAGE_ENVIRON
	req_access = list(ACCESS_KEYCARD_AUTH)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/datum/callback/ev
	var/event = ""
	var/obj/machinery/keycard_auth/event_source
	var/mob/triggerer = null
	var/waiting = FALSE

/obj/machinery/keycard_auth/directional/north
	dir = SOUTH
	pixel_y = 26

/obj/machinery/keycard_auth/directional/south
	dir = NORTH
	pixel_y = -26

/obj/machinery/keycard_auth/directional/east
	dir = WEST
	pixel_x = 26

/obj/machinery/keycard_auth/directional/west
	dir = EAST
	pixel_x = -26

/obj/machinery/keycard_auth/Initialize(mapload)
	. = ..()
	ev = GLOB.keycard_events.addEvent("triggerEvent", CALLBACK(src, PROC_REF(triggerEvent)))

/obj/machinery/keycard_auth/Destroy()
	GLOB.keycard_events.clearEvent("triggerEvent", ev)
	QDEL_NULL(ev)
	return ..()

/obj/machinery/keycard_auth/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/keycard_auth/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KeycardAuth", name)
		ui.open()

/obj/machinery/keycard_auth/ui_data()
	var/list/data = list()
	data["waiting"] = waiting
	data["auth_required"] = event_source ? event_source.event : 0
	data["red_alert"] = (SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED) ? 1 : 0
	data["emergency_maint"] = GLOB.emergency_access
	data["bsa_unlock"] = GLOB.bsa_unlock
	return data

/obj/machinery/keycard_auth/ui_status(mob/user)
	if(isanimal(user))
		var/mob/living/simple_animal/A = user
		if(!A.dextrous)
			to_chat(user, span_warning("Очко и жопа! Гы-гы!"))
			return UI_CLOSE
	return ..()

/obj/machinery/keycard_auth/ui_act(action, params)
	. = ..()

	if(. || waiting || !allowed(usr))
		return
	switch(action)
		if("red_alert")
			if(!event_source)
				sendEvent(KEYCARD_RED_ALERT)
				. = TRUE
		if("emergency_maint")
			if(!event_source)
				sendEvent(KEYCARD_EMERGENCY_MAINTENANCE_ACCESS)
				. = TRUE
		if("auth_swipe")
			if(event_source)
				event_source.trigger_event(usr)
				event_source = null
				update_appearance()
				. = TRUE
		if("bsa_unlock")
			if(!event_source)
				sendEvent(KEYCARD_BSA_UNLOCK)
				. = TRUE
		if("migger_alarm")
			if(!event_source)
				sendEvent(KEYCARD_MIGGER_ALARM)
				. = TRUE

/obj/machinery/keycard_auth/update_appearance(updates)
	. = ..()

	if(event_source && !(machine_stat & (NOPOWER|BROKEN)))
		set_light(1.4, 0.7, "#5668E1")
	else
		set_light(0)

/obj/machinery/keycard_auth/update_overlays()
	. = ..()

	if(event_source && !(machine_stat & (NOPOWER|BROKEN)))
		. += mutable_appearance(icon, "auth_on")
		. += emissive_appearance(icon, "auth_on", alpha = src.alpha)

/obj/machinery/keycard_auth/proc/sendEvent(event_type)
	triggerer = usr
	event = event_type
	waiting = TRUE
	GLOB.keycard_events.fireEvent("triggerEvent", src)
	addtimer(CALLBACK(src, PROC_REF(eventSent)), 20)

/obj/machinery/keycard_auth/proc/eventSent()
	triggerer = null
	event = ""
	waiting = FALSE

/obj/machinery/keycard_auth/proc/triggerEvent(source)
	event_source = source
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(eventTriggered)), 20)

/obj/machinery/keycard_auth/proc/eventTriggered()
	event_source = null
	update_appearance()

/obj/machinery/keycard_auth/proc/trigger_event(confirmer)
	log_game("[key_name(triggerer)] triggered and [key_name(confirmer)] confirmed event [event]")
	message_admins("[ADMIN_LOOKUPFLW(triggerer)] triggered and [ADMIN_LOOKUPFLW(confirmer)] confirmed event [event]")

	var/area/A1 = get_area(triggerer)
	deadchat_broadcast(" запускает [event] в локации <span class='name'>[A1.name]</span>.", span_name("[triggerer]") , triggerer, message_type=DEADCHAT_ANNOUNCEMENT)

	var/area/A2 = get_area(confirmer)
	deadchat_broadcast(" подтверждает [event] в локации <span class='name'>[A2.name]</span>.", span_name("[confirmer]") , confirmer, message_type=DEADCHAT_ANNOUNCEMENT)
	switch(event)
		if(KEYCARD_RED_ALERT)
			SSsecurity_level.set_level(SEC_LEVEL_RED)
		if(KEYCARD_EMERGENCY_MAINTENANCE_ACCESS)
			make_maint_all_access()
		if(KEYCARD_BSA_UNLOCK)
			toggle_bluespace_artillery()
		if(KEYCARD_MIGGER_ALARM)
			toggle_migger_alarm()

GLOBAL_VAR_INIT(emergency_access, FALSE)
/proc/make_maint_all_access()
	for(var/area/maintenance/A in GLOB.areas)
		for(var/turf/in_area as anything in A.get_contained_turfs())
			for(var/obj/machinery/door/airlock/D in in_area)
				D.emergency = TRUE
				D.update_icon(ALL, 0)
	minor_announce("Были сняты ограничения доступа на технические тоннели и внешние шлюзы.", "Внимание! Объявлена чрезвычайная ситуация на всей станции!",1)
	GLOB.emergency_access = TRUE
	SSblackbox.record_feedback("nested tally", "keycard_auths", 1, list("emergency maintenance access", "enabled"))

/proc/revoke_maint_all_access()
	for(var/area/maintenance/A in GLOB.areas)
		for(var/turf/in_area as anything in A.get_contained_turfs())
			for(var/obj/machinery/door/airlock/D in in_area)
				D.emergency = FALSE
				D.update_icon(ALL, 0)
	minor_announce("Восстановлены ограничения доступа в зоны обслуживания.", "Внимание! Аварийная ситуация на всей станции отменена!")
	GLOB.emergency_access = FALSE
	SSblackbox.record_feedback("nested tally", "keycard_auths", 1, list("emergency maintenance access", "disabled"))

/proc/toggle_bluespace_artillery()
	GLOB.bsa_unlock = !GLOB.bsa_unlock
	minor_announce("Протоколы блюспейс артиллерии были [GLOB.bsa_unlock? "разблокированы" : "заблокированы"].", "Обновление систем вооружения")
	SSblackbox.record_feedback("nested tally", "keycard_auths", 1, list("bluespace artillery", GLOB.bsa_unlock? "unlocked" : "locked"))


/proc/toggle_migger_alarm()
	GLOB.migger_alarm = !GLOB.migger_alarm
	spawn(rand(600, 3000))
		GLOB.migger_alarm = FALSE
	minor_announce("Отправка новых наёмных рабочих из дальних секторов была [GLOB.migger_alarm? "временно приостановлена" : "запущена вновь"].", "Миграционная политика станции")

#undef KEYCARD_RED_ALERT
#undef KEYCARD_EMERGENCY_MAINTENANCE_ACCESS
#undef KEYCARD_MIGGER_ALARM
#undef KEYCARD_BSA_UNLOCK
