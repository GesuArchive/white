/obj/machinery/computer/telescience
	name = "Консоль телепада"
	desc = "Для работы необходимо связать с телепадом и поместить в консоль блюспейс кристаллы. Нуждается в калибровке."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/circuitboard/computer/telesci_console
	var/sending = 1
	var/obj/machinery/telepad/telepad = null
	var/temp_msg = "Здравствуйте! Консоль инициализирована, подключите телепад."

	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/datum/projectile_data/last_tele_data = null
	var/z_co = 1
	var/power_off
	var/rotation_off
	var/last_target

	var/rotation = 0
	var/angle = 45
	var/power = 5

	// Based on the power used
	var/teleport_cooldown = 0 // every index requires a bluespace crystal
	var/list/power_options = list(5, 10, 20, 25, 30, 40, 50, 80, 100)
	var/teleporting = 0
	var/starting_crystals = 4
	var/max_crystals = 4
	var/crystals = 0
	var/obj/item/gps/inserted_gps

/obj/machinery/computer/telescience/Initialize(mapload)
	recalibrate()
	. = ..()
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/telepad_console,
	))

/obj/item/circuit_component/telepad_console
	display_name = "Telepad Console"
	desc = "Хз заполните ету хуйню мне впадлу."

	var/datum/port/input/elevation
	var/datum/port/input/rotation
	var/datum/port/input/power
	var/datum/port/input/sector

	var/datum/port/input/send_trigger
	var/datum/port/input/retrieve_trigger

	var/datum/port/output/sent
	var/datum/port/output/retrieved
	//var/datum/port/output/on_fail
	var/datum/port/output/status

	var/obj/machinery/computer/telescience/attached_console

/obj/item/circuit_component/telepad_console/Initialize(mapload)
	. = ..()
	elevation = add_input_port("Подъем", PORT_TYPE_NUMBER)
	rotation = add_input_port("Поворот", PORT_TYPE_NUMBER)
	power = add_input_port("Сила", PORT_TYPE_NUMBER)
	sector = add_input_port("Сектор", PORT_TYPE_NUMBER)

	send_trigger = add_input_port("Отправить", PORT_TYPE_SIGNAL)
	retrieve_trigger = add_input_port("Принять", PORT_TYPE_SIGNAL)

	sent = add_output_port("Принято", PORT_TYPE_SIGNAL)
	retrieved = add_output_port("Отправлено", PORT_TYPE_SIGNAL)
	//on_fail = add_output_port("Провал", PORT_TYPE_SIGNAL)
	status = add_output_port("Cтатус", PORT_TYPE_STRING)

/obj/item/circuit_component/telepad_console/Destroy()
	elevation = null
	rotation = null
	power = null
	sector = null
	send_trigger = null
	retrieve_trigger = null
	sent = null
	retrieved = null
	//on_fail = null
	status = null
	return ..()

/obj/item/circuit_component/telepad_console/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/machinery/computer/telescience))
		attached_console = parent

/obj/item/circuit_component/telepad_console/unregister_usb_parent(atom/movable/parent)
	attached_console = null
	return ..()

/obj/item/circuit_component/telepad_console/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return
	if(!attached_console || !attached_console.telepad)
		status.set_output("Не найдена консоль или ее телепад!")
		return

	attached_console.angle = elevation.value
	attached_console.rotation = rotation.value
	attached_console.power = power.value
	attached_console.z_co = sector.value
	if(COMPONENT_TRIGGERED_BY(port, elevation))
		elevation.set_input(attached_console.angle, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, rotation))
		rotation.set_input(attached_console.rotation, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, power))
		power.set_input(attached_console.power, FALSE)
		return
	if(COMPONENT_TRIGGERED_BY(port, sector))
		sector.set_input(attached_console.z_co, FALSE)
		return

	status.set_output(attached_console.temp_msg)

	if(COMPONENT_TRIGGERED_BY(send_trigger, port))
		attached_console.sending = 1
		attached_console.teleport(parent.get_creator())

	if(COMPONENT_TRIGGERED_BY(retrieve_trigger, port))
		attached_console.sending = 0
		attached_console.teleport(parent.get_creator())



/obj/machinery/computer/telescience/Destroy()
	eject()
	if(inserted_gps)
		inserted_gps.loc = loc
		inserted_gps = null
	return ..()

/obj/machinery/computer/telescience/examine(mob/user)
	. = ..()
	. += "<hr>Внутри [crystals ? crystals : "нет"] блюспейс кристаллов."

/obj/machinery/computer/telescience/Initialize(mapload)
	. = ..()
	if(mapload)
		crystals = starting_crystals

/obj/machinery/computer/telescience/attack_paw(mob/user)
	to_chat(user, span_warning("А КАК?!"))
	return

/obj/machinery/computer/telescience/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/bluespace_crystal) || istype(W, /obj/item/stack/sheet/bluespace_crystal))
		if(crystals >= max_crystals)
			to_chat(user, span_warning("Не хватает слотов."))
			return
		var/obj/item/stack/BC = W
		if(!BC.amount)
			to_chat(user, span_warning("БЛЯТЬ!"))
			return
		crystals++
		BC.use(1)
		user.visible_message("[user] вставляет [W] в <b>[src.name]</b>.", span_notice("Вставляю [W] в <b>[src.name]</b>."))
		updateDialog()
	else if(istype(W, /obj/item/gps))
		if(!inserted_gps)
			if(!user.transferItemToLoc(W, src))
				return
			inserted_gps = W
			user.visible_message("[user] вставляет [W] в <b>[src.name]</b>.", span_notice("Вставляю [W] в <b>[src.name]</b>."))
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		if(M.buffer && istype(M.buffer, /obj/machinery/telepad))
			telepad = M.buffer
			M.buffer = null
			to_chat(user, span_caution("Выгружаю данные из буффера [W.name] в консоль."))
	else
		return ..()

/obj/machinery/computer/telescience/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelesciComputer", name)
		ui.open()

/obj/machinery/computer/telescience/ui_data()
	var/list/data = list()
	data["telepad"] = telepad
	data["power_options"] = power_options
	data["efficiency"] = telepad?.efficiency
	data["crystals"] = crystals
	data["z_co"] = z_co
	data["angle"] = angle
	data["rotation"] = rotation
	data["power"] = power
	data["temp_msg"] = temp_msg
	data["inserted_gps"] = inserted_gps
	data["teleporting"] = teleporting
	data["last_tele_data"] = last_tele_data
	data["src_x"] = last_tele_data?.src_x
	data["src_y"] = last_tele_data?.src_y
	data["timedata"] = round(last_tele_data?.time, 0.1)
	return data

/obj/machinery/computer/telescience/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("setrotation")
			var/new_rot = text2num(params["newrotation"])
			rotation = clamp(new_rot, -900, 900)
			rotation = round(rotation, 0.01)
			. = TRUE
		if("setangle")
			var/new_angle = text2num(params["newangle"])
			angle = clamp(round(new_angle, 0.1), 1, 9999)
			. = TRUE
		if("setpower")
			var/new_power = text2num(params["newpower"])
			power = new_power
			. = TRUE
		if("setz")
			var/new_z = text2num(params["newz"])
			z_co = clamp(round(new_z), 1, 13)
			. = TRUE
		if("ejectGPS")
			if(inserted_gps)
				inserted_gps.loc = loc
				inserted_gps = null
			. = TRUE
		if("setMemory")
			if(last_target && inserted_gps)
				//inserted_gps.locked_location = last_target
				temp_msg = "Местность не сохранена."
			else
				temp_msg = "Ошибка! Данных не обнаружено."
			. = TRUE
		if("send")
			sending = 1
			teleport(usr)
			. = TRUE
		if("receive")
			sending = 0
			teleport(usr)
			. = TRUE
		if("recal")
			recalibrate()
			sparks()
			temp_msg = "Калибрация успешна."
			. = TRUE
		if("eject")
			eject()
			temp_msg = "Кристаллы извлечены."
			. = TRUE

/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		do_sparks(5, TRUE, get_turf(telepad))

/obj/machinery/computer/telescience/proc/telefail()
	sparks()
	visible_message(span_warning("Телепад слабо искрит."))

/obj/machinery/computer/telescience/proc/doteleport(mob/user)

	if(teleport_cooldown > world.time)
		temp_msg = "Телепад перезаряжается. Подождите примерно [round((teleport_cooldown - world.time) / 10)] секунд."
		return

	if(teleporting)
		temp_msg = "Телепад активен, подождите."
		return

	if(telepad)

		var/truePower = clamp(power + power_off, 1, 1000)
		var/trueRotation = rotation + rotation_off
		var/trueAngle = clamp(angle, 1, 90)

		var/datum/projectile_data/proj_data = projectile_trajectory(telepad.x, telepad.y, trueRotation, trueAngle, truePower)
		last_tele_data = proj_data

		var/trueX = clamp(round(proj_data.dest_x, 1), 1, world.maxx)
		var/trueY = clamp(round(proj_data.dest_y, 1), 1, world.maxy)
		var/spawn_time = round(proj_data.time) * 10

		var/turf/target = locate(trueX, trueY, z_co)
		last_target = target
		var/area/A = get_area(target)
		flick("pad-beam", telepad)

		if(spawn_time > 15) // 1.5 seconds
			playsound(telepad.loc, 'sound/weapons/flash.ogg', 25, 1)
			// Wait depending on the time the projectile took to get there
			teleporting = 1
			temp_msg = "Заряжаем блюспейс-кристаллы, подождите."

		spawn(round(proj_data.time) * 10) // in seconds
			if(!telepad)
				return
			if(telepad.machine_stat & NOPOWER)
				return
			teleporting = 0
			teleport_cooldown = world.time + (power * 2)
			teles_left -= 1

			// use a lot of power
			use_power(power * 10)

			do_sparks(5, TRUE, get_turf(telepad))

			temp_msg = "Телепортация успешна."
			if(teles_left < 10)
				temp_msg += " Потребуется калибрация."
			else
				temp_msg += " Данные выводятся."

			do_sparks(5, TRUE, get_turf(target))

			var/turf/source = target
			var/turf/dest = get_turf(telepad)
			var/log_msg = ""
			log_msg += ": [key_name(user)] has teleported "

			if(sending)
				source = dest
				dest = target

			flick("pad-beam", telepad)
			playsound(telepad.loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3)
			for(var/atom/movable/ROI in source)
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue

							log_msg += "[key_name(L)] (on a chair), "
						else
							continue
					else if(!isobserver(ROI))
						continue
				if(ismob(ROI))
					var/mob/T = ROI
					log_msg += "[key_name(T)], "
				else
					log_msg += "[ROI.name]"
					if (istype(ROI, /obj/structure/closet))
						var/obj/structure/closet/C = ROI
						log_msg += " ("
						for(var/atom/movable/Q as mob|obj in C)
							if(ismob(Q))
								log_msg += "[key_name(Q)], "
							else
								log_msg += "[Q.name], "
						if (dd_hassuffix(log_msg, "("))
							log_msg += "empty)"
						else
							log_msg = dd_limittext(log_msg, length(log_msg) - 2)
							log_msg += ")"
					log_msg += ", "
				do_teleport(ROI, dest)

			if (dd_hassuffix(log_msg, ", "))
				log_msg = dd_limittext(log_msg, length(log_msg) - 2)
			else
				log_msg += "nothing"
			log_msg += " [sending ? "to" : "from"] [trueX], [trueY], [z_co] ([A ? A.name : "null area"])"
			investigate_log(log_msg, "telesci")
			updateDialog()

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(rotation == null || angle == null || z_co == null)
		temp_msg = "ОШИБКА! Выставьте поворот, угол и сектор."
		return
	if(power <= 0)
		telefail()
		temp_msg = "ОШИБКА! Недостаточно энергии!"
		return
	if(angle < 1 || angle > 90)
		telefail()
		temp_msg = "ОШИБКА! Угол менее единицы или более 90 градусов."
		return
	if(z_co == 1 || z_co < 1 || z_co > 13)
		telefail()
		temp_msg = "ОШИБКА! Сектор недоступен!"
		return
	if(teles_left > 0)
		doteleport(user)
		return
	else
		telefail()
		temp_msg = "ОШИБКА! Требуется калибрация."
		return

/obj/machinery/computer/telescience/proc/eject()
	for(var/i in 1 to crystals)
		new /obj/item/stack/ore/bluespace_crystal(drop_location())
	crystals = 0
	power = 0

/obj/machinery/computer/telescience/proc/recalibrate()
	teles_left = rand(30, 40)
	power_off = rand(-4, 0)
	rotation_off = rand(-10, 10)
