#define CAMERA_UPGRADE_XRAY 1
#define CAMERA_UPGRADE_EMP_PROOF 2
#define CAMERA_UPGRADE_MOTION 4

/obj/machinery/camera
	name = "камера"
	desc = "Используется для мониторинга помещений."
	icon = 'icons/obj/machines/camera.dmi'
	icon_state = "camera" //mapping icon to represent upgrade states. if you want a different base icon, update default_camera_icon as well as this.
	use_power = ACTIVE_POWER_USE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.02
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE_UPPER
	resistance_flags = FIRE_PROOF
	damage_deflection = 12
	armor = list(MELEE = 50, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 90, ACID = 50)
	max_integrity = 100
	integrity_failure = 0.5
	var/default_camera_icon = "camera" //the camera's base icon used by update_icon - icon_state is primarily used for mapping display purposes.
	var/list/network = list("ss13")
	var/c_tag = null
	var/status = TRUE
	var/start_active = FALSE //If it ignores the random chance to start broken on round start
	var/invuln = null
	var/obj/item/camera_bug/bug = null
	var/datum/weakref/assembly_ref = null
	var/area/myarea = null

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/alarm_on = FALSE
	var/busy = FALSE
	var/emped = FALSE  //Number of consecutive EMP's on this camera
	var/in_use_lights = 0

	// Upgrades bitflag
	var/upgrades = 0

	var/internal_light = TRUE //Whether it can light up when an AI views it
	///Represents a signel source of camera alarms about movement or camera tampering
	var/datum/alarm_handler/alarm_manager

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/autoname, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/emp_proof, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/motion, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/xray, 0)

/obj/machinery/camera/preset/ordnance //Bomb test site in space
	name = "полигонная камера"
	desc = "Специально усиленная камера с длительным сроком службы батареи, используемая для наблюдения за местом испытания бомбы. К верхней части камеры приделана лампочка."
	c_tag = "Bomb Testing Site"
	network = list("rd","toxins")
	use_power = NO_POWER_USE //Test site is an unpowered area
	invuln = TRUE
	light_range = 10
	start_active = TRUE

/obj/machinery/camera/preset/ordnance/num1
	name = "полигонная камера №1"
	c_tag = "Bomb Testing Site №1"

/obj/machinery/camera/preset/ordnance/num2
	name = "полигонная камера №2"
	c_tag = "Bomb Testing Site №2"

/obj/machinery/camera/Initialize(mapload, obj/structure/camera_assembly/CA)
	. = ..()
	for(var/i in network)
		network -= i
		network += lowertext(i)
	var/obj/structure/camera_assembly/assembly
	if(CA)
		assembly = CA
		if(assembly.xray_module)
			upgradeXRay()
		else if(assembly.malf_xray_firmware_present) //if it was secretly upgraded via the MALF AI Upgrade Camera Network ability
			upgradeXRay(TRUE)

		if(assembly.emp_module)
			upgradeEmpProof()
		else if(assembly.malf_xray_firmware_present) //if it was secretly upgraded via the MALF AI Upgrade Camera Network ability
			upgradeEmpProof(TRUE)

		if(assembly.proxy_module)
			upgradeMotion()
	else
		assembly = new(src)
		assembly.state = 4 //STATE_FINISHED
	assembly_ref = WEAKREF(assembly)
	GLOB.cameranet.cameras += src
	GLOB.cameranet.addCamera(src)
	if (isturf(loc))
		myarea = get_area(src)
		LAZYADD(myarea.cameras, src)

	if(mapload && is_station_level(z) && prob(3) && !start_active)
		toggle_cam()
	else //this is handled by toggle_camera, so no need to update it twice.
		update_icon()

	alarm_manager = new(src)

	RegisterSignal(src, COMSIG_ATOM_FRIENDLY_WAVED, PROC_REF(handle_waving))

/obj/machinery/camera/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	for(var/i in network)
		network -= i
		network += "[port.id]_[i]"

/obj/machinery/proc/create_prox_monitor()
	if(!proximity_monitor)
		proximity_monitor = new(src, 1)

/obj/machinery/camera/proc/set_area_motion(area/A)
	area_motion = A
	create_prox_monitor()

/obj/machinery/camera/Destroy()
	if(can_use())
		toggle_cam(null, 0) //kick anyone viewing out and remove from the camera chunks
	GLOB.cameranet.removeCamera(src)
	GLOB.cameranet.cameras -= src
	cancelCameraAlarm()
	if(isarea(myarea))
		LAZYREMOVE(myarea.cameras, src)
	QDEL_NULL(alarm_manager)
	QDEL_NULL(assembly_ref)
	if(bug)
		bug.bugged_cameras -= c_tag
		if(bug.current == src)
			bug.current = null
		bug = null

	UnregisterSignal(src, COMSIG_ATOM_FRIENDLY_WAVED)

	return ..()

/obj/machinery/camera/examine(mob/user)
	. += ..()
	if(isEmpProof(TRUE)) //don't reveal it's upgraded if was done via MALF AI Upgrade Camera Network ability
		. += "<hr>Видно, что защита от ЭМИ установлена."
	else
		. += "<hr><span class='info'>Она может быть улучшена защитой от ЭМИ <b>плазмой</b>.</span>"
	if(isXRay(TRUE)) //don't reveal it's upgraded if was done via MALF AI Upgrade Camera Network ability
		. += "<hr>Похоже тут установлен X-ray фотодиод."
	else
		. += "<hr><span class='info'>Она может быть улучшена рентгеновским фотодиодом при помощи <b>газоанализатора</b>.</span>"
	if(isMotion())
		. += "<hr>Здесь установлен датчик движения."
	else
		. += "<hr><span class='info'>Она может быть улучшена установкой <b>датчика движения</b>.</span>"

	if(!status)
		. += "<hr><span class='info'>Она не работает.</span>"
		if(!panel_open && powered())
			. += "<hr><span class='notice'>Надо бы сначала <b>открутить</b>, чтобы включить её снова.</span>"
	if(panel_open)
		. += "<hr><span class='info'>Техническая панель открыта.</span>"
		if(!status && powered())
			. += "<hr><span class='info'>Она может быть активирована снова при помощи <b>кусачек</b>.</span>"

/obj/machinery/camera/emp_act(severity)
	. = ..()
	if(!status)
		return
	if(!(. & EMP_PROTECT_SELF))
		if(prob(150/severity))
			update_icon()
			network = list()
			GLOB.cameranet.removeCamera(src)
			set_machine_stat(machine_stat | EMPED)
			set_light(0)
			emped = emped+1  //Increase the number of consecutive EMP's
			update_icon()
			addtimer(CALLBACK(src, PROC_REF(post_emp_reset), emped, network), 90 SECONDS)
			for(var/i in GLOB.player_list)
				var/mob/M = i
				if (M.client.eye == src)
					M.unset_machine()
					M.reset_perspective(null)
					to_chat(M, span_warning("The screen bursts into static!"))

/obj/machinery/camera/proc/post_emp_reset(thisemp, previous_network)
	if(QDELETED(src))
		return
	triggerCameraAlarm() //camera alarm triggers even if multiple EMPs are in effect.
	if(emped != thisemp) //Only fix it if the camera hasn't been EMP'd again
		return
	network = previous_network
	set_machine_stat(machine_stat & ~EMPED)
	update_icon()
	if(can_use())
		GLOB.cameranet.addCamera(src)
	emped = 0 //Resets the consecutive EMP count
	addtimer(CALLBACK(src, PROC_REF(cancelCameraAlarm)), 100)

/obj/machinery/camera/ex_act(severity, target)
	if(invuln)
		return
	..()

/obj/machinery/camera/proc/setViewRange(num = 7)
	src.view_range = num
	GLOB.cameranet.updateVisibility(src, 0)

/obj/machinery/camera/proc/shock(mob/living/user)
	if(!istype(user))
		return
	user.electrocute_act(10, src)

/obj/machinery/camera/singularity_pull(S, current_size)
	if (status && current_size >= STAGE_FIVE) // If the singulo is strong enough to pull anchored objects and the camera is still active, turn off the camera as it gets ripped off the wall.
		toggle_cam(null, 0)
	..()

// Construction/Deconstruction
/obj/machinery/camera/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	toggle_panel_open()
	to_chat(user, span_notice("[panel_open ? "Откручиваю" : "Закручиваю"] техническую панель."))
	I.play_tool_sound(src)
	update_icon()
	return TRUE

/obj/machinery/camera/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		return
	var/obj/structure/camera_assembly/assembly = assembly_ref?.resolve()
	if(!assembly)
		assembly_ref = null
		return
	var/list/droppable_parts = list()
	if(assembly.xray_module)
		droppable_parts += assembly.xray_module
	if(assembly.emp_module)
		droppable_parts += assembly.emp_module
	if(assembly.proxy_module)
		droppable_parts += assembly.proxy_module
	if(!droppable_parts.len)
		return
	var/obj/item/choice = tgui_input_list(user, "Убираем мы:", src, sort_names(droppable_parts))
	if(!choice || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	to_chat(user, span_notice("Вытаскиваю [choice] из [src]."))
	if(choice == assembly.xray_module)
		assembly.drop_upgrade(assembly.xray_module)
		removeXRay()
	if(choice == assembly.emp_module)
		assembly.drop_upgrade(assembly.emp_module)
		removeEmpProof()
	if(choice == assembly.proxy_module)
		assembly.drop_upgrade(assembly.proxy_module)
		removeMotion()
	I.play_tool_sound(src)
	return TRUE

/obj/machinery/camera/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		return
	toggle_cam(user, 1)
	obj_integrity = max_integrity //this is a pretty simplistic way to heal the camera, but there's no reason for this to be complex.
	set_machine_stat(machine_stat & ~BROKEN)
	I.play_tool_sound(src)
	return TRUE

/obj/machinery/camera/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		return

	setViewRange((view_range == initial(view_range)) ? short_range : initial(view_range))
	to_chat(user, span_notice("[(view_range == initial(view_range)) ? "Восстанавливаю" : "Ломаю"] фокусировку камеры."))
	return TRUE

/obj/machinery/camera/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		return

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("Начинаю разваривать [src.name]..."))
	if(I.use_tool(src, user, 100, volume=50))
		user.visible_message(span_warning("[user] отваривает [src.name] от стены, оставляя только рамку с болтами.") ,
			span_warning("Отвариваю [src.name] от стены, оставив только рамку с болтами."))
		deconstruct(TRUE)

	return TRUE

/obj/machinery/camera/attackby(obj/item/I, mob/living/user, params)
	// UPGRADES
	if(panel_open)
		var/obj/structure/camera_assembly/assembly = assembly_ref?.resolve()
		if(!assembly)
			assembly_ref = null
		if(I.tool_behaviour == TOOL_ANALYZER)
			if(!isXRay(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				upgradeXRay(FALSE, TRUE)
				to_chat(user, span_notice("Прикрепляю [I.name] во внутреннюю схему [assembly.name]."))
				qdel(I)
			else
				to_chat(user, span_warning("[src.name] уже имеет это улучшение!"))
			return

		else if(istype(I, /obj/item/stack/sheet/mineral/plasma))
			if(!isEmpProof(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(I.use_tool(src, user, 0, amount=1))
					upgradeEmpProof(FALSE, TRUE)
					to_chat(user, span_notice("Прикрепляю [I.name] во внутреннюю схему [assembly.name]."))
			else
				to_chat(user, span_warning("[src.name] уже имеет это улучшение!"))
			return

		else if(istype(I, /obj/item/assembly/prox_sensor))
			if(!isMotion())
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				upgradeMotion()
				to_chat(user, span_notice("Прикрепляю [I.name] во внутреннюю схему [assembly.name]."))
				qdel(I)
			else
				to_chat(user, span_warning("[src.name] уже имеет это улучшение!"))
			return

	// OTHER
	if((istype(I, /obj/item/paper) || istype(I, /obj/item/modular_computer/tablet)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null

		var/itemname = ""
		var/info = ""
		if(istype(I, /obj/item/paper))
			X = I
			itemname = X.name
			info = X.info
		to_chat(U, span_notice("Показываю [itemname] перед камерой..."))
		U.changeNext_move(CLICK_CD_MELEE)
		for(var/mob/O in GLOB.player_list)
			if(isAI(O))
				var/mob/living/silicon/ai/AI = O
				if(AI.control_disabled || (AI.stat == DEAD))
					continue
				if(U.name == "Неизвестный")
					to_chat(AI, "<span class='name'>[U]</span> держит <a href='?_src_=usr;show_paper=1;'> [itemname]</a> перед одной из моих камер...")
				else
					to_chat(AI, "<b><a href='?src=[REF(AI)];track=[html_encode(U.name)]'>[U]</a></b> держит <a href='?_src_=usr;show_paper=1;'> [itemname]</a> перед одной из моих камер...")
				AI.last_paper_seen = "<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>"
			else if (O.client.eye == src)
				to_chat(O, "<span class='name'>[U]</span> держит [itemname] перед одной из моих камер...")
				O << browse(text("<HTML><HEAD><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))
		return

	else if(istype(I, /obj/item/camera_bug))
		if(!can_use())
			to_chat(user, span_notice("Камера не работает."))
			return
		if(bug)
			to_chat(user, span_notice("Жучок удалён."))
			bug.bugged_cameras -= src.c_tag
			bug = null
		else
			to_chat(user, span_notice("Жучок установлен."))
			bug = I
			bug.bugged_cameras[src.c_tag] = WEAKREF(src)
		return

	return ..()

/obj/machinery/camera/proc/handle_waving(mob/source, mob_intent)
	SIGNAL_HANDLER

	if(!prob(1))
		return

	var/target_message

	switch(mob_intent)
		if(INTENT_HELP)
			target_message = "машет рукой одной"
		if(INTENT_DISARM)
			target_message = "кривляется перед одной"
		if(INTENT_GRAB)
			target_message = "подманивает пальчиком одну"
		if(INTENT_HARM)
			target_message = "угрожает кулаком одной"

	to_chat(source, span_notice("Камера фокусируется на мне."))

	for(var/mob/O in GLOB.player_list)
		if(isAI(O))
			var/mob/living/silicon/ai/AI = O
			if(AI.control_disabled || (AI.stat == DEAD))
				continue
			if(source.name == "Неизвестный")
				to_chat(AI, "<span class='name'>[source]</span> [target_message] из моих камер...")
			else
				to_chat(AI, "<b><a href='?src=[REF(AI)];track=[html_encode(source.name)]'>[source]</a></b> [target_message] из моих камер...")

/obj/machinery/camera/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(machine_stat & BROKEN)
		return damage_amount
	. = ..()

/obj/machinery/camera/obj_break(damage_flag)
	if(!status)
		return
	. = ..()
	if(.)
		triggerCameraAlarm()
		toggle_cam(null, 0)

/obj/machinery/camera/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			var/obj/structure/camera_assembly/assembly = assembly_ref?.resolve()
			if(!assembly)
				assembly = new()
			assembly.forceMove(drop_location())
			assembly.state = 1
			assembly.setDir(dir)
			assembly_ref = null
		else
			var/obj/item/I = new /obj/item/wallframe/camera (loc)
			I.obj_integrity = I.max_integrity * 0.5
			new /obj/item/stack/cable_coil(loc, 2)
	qdel(src)

/obj/machinery/camera/update_icon_state() //TO-DO: Make panel open states, xray camera, and indicator lights overlays instead.
	. = ..()
	var/xray_module
	if(isXRay(TRUE))
		xray_module = "xray"
	if(!status)
		icon_state = "[xray_module][default_camera_icon]_off"
	else if (machine_stat & EMPED)
		icon_state = "[xray_module][default_camera_icon]_emp"
	else
		icon_state = "[xray_module][default_camera_icon][in_use_lights ? "_in_use" : ""]"

/obj/machinery/camera/proc/toggle_cam(mob/user, displaymessage = 1)
	status = !status
	if(can_use())
		GLOB.cameranet.addCamera(src)
		if (isturf(loc))
			myarea = get_area(src)
			LAZYADD(myarea.cameras, src)
		else
			myarea = null
	else
		set_light(0)
		GLOB.cameranet.removeCamera(src)
		if (isarea(myarea))
			LAZYREMOVE(myarea.cameras, src)
	// We are not guarenteed that the camera will be on a turf. account for that
	var/turf/our_turf = get_turf(src)
	GLOB.cameranet.updateChunk(our_turf.x, our_turf.y, our_turf.z)
	var/change_msg = "выключает"
	if(status)
		change_msg = "включает"
		triggerCameraAlarm()
		if(!QDELETED(src)) //We'll be doing it anyway in destroy
			addtimer(CALLBACK(src, PROC_REF(cancelCameraAlarm)), 100)
	if(displaymessage)
		if(user)
			visible_message(span_danger("[user] [change_msg] [src]!"))
			add_hiddenprint(user)
		else
			visible_message(span_danger("<b>[capitalize(src)]</b> [change_msg]!"))

		playsound(src, 'sound/items/wirecutter.ogg', 100, TRUE)
	update_icon() //update Initialize() if you remove this.

	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for(var/mob/O in GLOB.player_list)
		if (O.client.eye == src)
			O.unset_machine()
			O.reset_perspective(null)
			to_chat(O, span_warning("Экран заливается помехами!"))

/obj/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = TRUE
	alarm_manager.send_alarm(ALARM_CAMERA, src, src)

/obj/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = FALSE
	alarm_manager.clear_alarm(ALARM_CAMERA)

/obj/machinery/camera/proc/can_use()
	if(!status)
		return FALSE
	if(machine_stat & EMPED)
		return FALSE
	return TRUE

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	var/check_lower = pos != get_lowest_turf(pos)
	var/check_higher = pos != get_highest_turf(pos)

	if(isXRay())
		see = range(view_range, pos)
	else
		see = get_hear(view_range, pos)
	if(check_lower || check_higher)
		// Haha datum var access KILL ME
		var/datum/controller/subsystem/mapping/local_mapping = SSmapping
		for(var/turf/seen in see)
			if(check_lower)
				var/turf/visible = seen
				while(visible && istransparentturf(visible))
					var/turf/below = local_mapping.get_turf_below(visible)
					for(var/turf/adjacent in range(1, below))
						see += adjacent
						see += adjacent.contents
					visible = below
			if(check_higher)
				var/turf/above = local_mapping.get_turf_above(seen)
				while(above && istransparentturf(above))
					for(var/turf/adjacent in range(1, above))
						see += adjacent
						see += adjacent.contents
					above = local_mapping.get_turf_above(above)
	return see

/obj/machinery/camera/proc/Togglelight(on=0)
	for(var/mob/living/silicon/ai/A in GLOB.ai_list)
		for(var/obj/machinery/camera/cam in A.lit_cameras)
			if(cam == src)
				return
	if(on)
		set_light(AI_CAMERA_LUMINOSITY)
	else
		set_light(0)

/obj/machinery/camera/get_remote_view_fullscreens(mob/user)
	if(view_range == short_range) //unfocused
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 2)

/obj/machinery/camera/update_remote_sight(mob/living/user)
	user.set_invis_see(SEE_INVISIBLE_LIVING) //can't see ghosts through cameras
	if(isXRay())
		user.add_sight(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		user.set_see_in_dark(max(user.see_in_dark, 8))
	else
		user.clear_sight(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		user.sight = 0
		user.set_see_in_dark(2)
	return 1
