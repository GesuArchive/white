

/obj/machinery/computer/upload
	var/mob/living/silicon/current = null //The target of future law uploads
	icon_screen = "command"
	time_to_screwdrive = 60

/obj/machinery/computer/upload/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Зашифрованный канал загрузки")

/obj/machinery/computer/upload/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/ai_module))
		var/obj/item/ai_module/M = O
		if(machine_stat & (NOPOWER|BROKEN|MAINT))
			return
		if(!current)
			to_chat(user, span_alert("You haven't selected anything to transmit laws to!"))
			return
		if(!can_upload_to(current))
			to_chat(user, span_alert("Upload failed! Check to make sure [current.name] is functioning properly."))
			current = null
			return
		var/turf/currentloc = get_turf(current)
		if(!is_station_level(currentloc.z) || !is_station_level(user.z))
			if(currentloc && user.z != currentloc.z)
				to_chat(user, span_alert("Upload failed! Unable to establish a connection to [current.name]. You're too far away!"))
				current = null
				return
		M.install(current.laws, user)
	else
		return ..()

/obj/machinery/computer/upload/proc/can_upload_to(mob/living/silicon/S)
	if(S.stat == DEAD)
		return FALSE
	return TRUE

/obj/machinery/computer/upload/ai
	name = "Консоль загрузки законов ИИ"
	desc = "Используется для обновления законов  искусственного интеллекта станции."
	circuit = /obj/item/circuitboard/computer/aiupload

/obj/machinery/computer/upload/ai/interact(mob/user)
	current = select_active_ai(user, z)

	if (!current)
		to_chat(user, span_alert("No active AIs detected!"))
	else
		to_chat(user, span_notice("[current.name] selected for law changes."))

/obj/machinery/computer/upload/ai/can_upload_to(mob/living/silicon/ai/A)
	if(!A || !isAI(A))
		return FALSE
	if(A.control_disabled)
		return FALSE
	return ..()


/obj/machinery/computer/upload/borg
	name = "Консоль загрузки законов Киборгов"
	desc = "Используется для обновления законов Киборгов станции."
	circuit = /obj/item/circuitboard/computer/borgupload

/obj/machinery/computer/upload/borg/interact(mob/user)
	current = select_active_free_borg(user)

	if(!current)
		to_chat(user, span_alert("No active unslaved cyborgs detected."))
	else
		to_chat(user, span_notice("[current.name] selected for law changes."))

/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(!B || !iscyborg(B))
		return FALSE
	if(B.scrambledcodes || B.emagged)
		return FALSE
	return ..()
