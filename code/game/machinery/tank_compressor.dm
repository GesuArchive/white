#define TANK_COMPRESSOR_PRESSURE_LIMIT 5000
#define TANK_COMPRESSOR_MAX_TRANSFER_RATE 20
#define SIGNIFICANT_AMOUNT_OF_MOLES 10

/obj/machinery/atmospherics/components/binary/tank_compressor
	name = "компрессор"
	desc = "Сверхмощный экранированный воздушный компрессор, предназначенный для создания давления в резервуарах выше безопасного предела."
	circuit = /obj/item/circuitboard/machine/tank_compressor
	icon = 'icons/obj/machines/research.dmi'
	base_icon_state = "tank_compressor"
	icon_state = "tank_compressor-open"
	density = TRUE

	var/active = FALSE
	var/transfer_rate = TANK_COMPRESSOR_MAX_TRANSFER_RATE
	var/datum/gas_mixture/leaked_gas_buffer
	var/list/compressor_record
	var/last_recorded_pressure = 0
	var/record_number = 1
	var/obj/item/tank/inserted_tank
	/// Reference to a disk we are going to print to.
	var/obj/item/computer_disk/inserted_disk

	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

/obj/machinery/atmospherics/components/binary/tank_compressor/Initialize(mapload)
	. = ..()
	leaked_gas_buffer = new(200)
	compressor_record = list()

/obj/machinery/atmospherics/components/binary/tank_compressor/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_INTERNAL_EXPLOSION, PROC_REF(explosion_handle))

/obj/machinery/atmospherics/components/binary/tank_compressor/examine()
	. = ..()
	. += "Рассчитан на давление до [TANK_COMPRESSOR_PRESSURE_LIMIT] кПа."
	. += "Может открываться отверткой и поворачиваться гаечным ключом. Зеленый порт - это вход, красный - выход."

/// Stores the record of the gas data for a significant enough tank leak
/datum/data/compressor_record
	/// Tank Name
	var/experiment_source
	/// Key: Path, Value: Moles
	var/list/gas_data = list()
	var/timestamp

/obj/machinery/atmospherics/components/binary/tank_compressor/attackby(obj/item/item, mob/living/user)
	if (panel_open)
		return ..()

	if(istype(item, /obj/item/tank))
		var/obj/item/tank/tank_item = item
		if(inserted_tank)
			if(!eject_tank(user))
				balloon_alert(user, span_warning("Внутри находится [inserted_tank]. Он застрял."))
				return ..()
		if(!user.transferItemToLoc(tank_item, src))
			balloon_alert(user, span_warning("[tank_item] прилип к моей руке!"))
			return ..()
		inserted_tank = tank_item
		last_recorded_pressure = 0
		RegisterSignal(inserted_tank, COMSIG_PARENT_QDELETING, PROC_REF(tank_destruction))
		update_appearance()
		return
	if(istype(item, /obj/item/computer_disk))
		var/obj/item/computer_disk/attacking_disk = item
		eject_disk(user)
		if(user.transferItemToLoc(attacking_disk, src))
			inserted_disk = attacking_disk
		else
			balloon_alert(user, span_warning("[attacking_disk] прилип к моей руке!"))
		return
	return ..()

/obj/machinery/atmospherics/components/binary/tank_compressor/wrench_act(mob/living/user, obj/item/tool)
	if(active || inserted_tank)
		return FALSE
	if(!default_change_direction_wrench(user, tool))
		return FALSE
	return TRUE

/obj/machinery/atmospherics/components/binary/tank_compressor/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	set_init_directions()
	update_appearance()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/get_node_connects()
	return list(turn(dir, 180), dir) // airs[2] is input which is facing dir, airs[1] is output which is facing the other side of dir

/obj/machinery/atmospherics/components/binary/tank_compressor/screwdriver_act(mob/living/user, obj/item/tool)
	if(active || inserted_tank)
		return FALSE
	if(!default_deconstruction_screwdriver(user, "[base_icon_state]-open", "[base_icon_state]-open", tool))
		return FALSE
	change_nodes_connection(panel_open)
	update_appearance()
	return TRUE

/obj/machinery/atmospherics/components/binary/tank_compressor/crowbar_act(mob/living/user, obj/item/tool)
	if(active || inserted_tank)
		return FALSE
	if(!default_deconstruction_crowbar(tool))
		return FALSE
	return TRUE

/// Glorified volume pump.
/obj/machinery/atmospherics/components/binary/tank_compressor/process_atmos()
	var/datum/gas_mixture/input_air = airs[2]
	if(!input_air?.total_moles() || !active || !transfer_rate || !inserted_tank)
		return

	var/datum/gas_mixture/tank_air = inserted_tank.return_air()
	if(!tank_air)
		return

	if(input_air.return_pressure() < 0.01 || tank_air.return_pressure() > TANK_COMPRESSOR_PRESSURE_LIMIT)
		return

	/// Prevent pumping if tank is taking damage but still below pressure limit. Here to prevent exploiting the buffer system.
	if((inserted_tank.obj_integrity <= 0) && (tank_air.return_pressure() <= TANK_LEAK_PRESSURE))
		active = FALSE
		return

	var/datum/gas_mixture/removed = input_air.remove_ratio(transfer_rate / input_air.return_volume())
	if(!removed)
		return

	tank_air.merge(removed)
	update_parents()

/obj/machinery/atmospherics/components/binary/tank_compressor/assume_air(datum/gas_mixture/giver)
	if(!leaked_gas_buffer)
		return ..()
	leaked_gas_buffer.merge(giver)
	return TRUE

/// Recording of last pressure of the tank. Ran when a tank is about to explode or disintegrate. We dont care about last pressure if the tank is ejected.
/obj/machinery/atmospherics/components/binary/tank_compressor/proc/tank_destruction()
	SIGNAL_HANDLER
	if(inserted_tank.get_integrity() > 0)
		return
	flush_buffer()
	var/datum/gas_mixture/tank_air = inserted_tank.return_air()
	last_recorded_pressure = tank_air.return_pressure()
	active = FALSE
	return

/// Use this to absorb explosions.
/obj/machinery/atmospherics/components/binary/tank_compressor/proc/explosion_handle(atom/source, list/arguments)
	SIGNAL_HANDLER
	say("Обнаружен и поглощен внутренний взрыв.")
	SSexplosions.shake_the_room(get_turf(src), 1, 8, 0.5, 0.25, FALSE)
	return COMSIG_CANCEL_EXPLOSION

/**
 * Everytime a tank is destroyed or a new tank is inserted, our buffer is flushed.
 * Mole requirements in experiments are tracked by buffer data.
 */
/obj/machinery/atmospherics/components/binary/tank_compressor/proc/flush_buffer()
	if(!leaked_gas_buffer.total_moles())
		return
	if(leaked_gas_buffer.total_moles() > SIGNIFICANT_AMOUNT_OF_MOLES)
		record_data()
	else
		say("Данные буфера забракованы. Необходимые моли для хранения: [SIGNIFICANT_AMOUNT_OF_MOLES] молей.")
	var/datum/gas_mixture/removed = leaked_gas_buffer.remove_ratio(1)
	airs[1].merge(removed)
	say("Газ, хранящийся в буфере, сбрасывается в выходной порт. Компрессор готов к началу следующего эксперимента.")

/// This proc should be called whenever we want to store our buffer data.
/obj/machinery/atmospherics/components/binary/tank_compressor/proc/record_data()
	var/datum/data/compressor_record/new_record = new()
	new_record.name = "Запись #[record_number]"
	new_record.experiment_source = inserted_tank.name
	new_record.timestamp = station_time_timestamp()
	for(var/gas_path in leaked_gas_buffer.gases)
		new_record.gas_data[gas_path] = leaked_gas_buffer.gases[gas_path][MOLES]

	compressor_record += new_record
	record_number += 1
	say("Данные буфера сохранены.")

/// Ejecting a tank. Also called on insertion to clear previous tanks.
/obj/machinery/atmospherics/components/binary/tank_compressor/proc/eject_tank(mob/user)
	if(!inserted_tank)
		return FALSE
	var/datum/gas_mixture/tank_air = inserted_tank.return_air()
	if(tank_air.return_pressure() >= ((ONE_ATMOSPHERE * 25) + ONE_ATMOSPHERE))
		return FALSE
	flush_buffer()
	if(user)
		user.put_in_hands(inserted_tank)
	else
		inserted_tank.forceMove(drop_location())
	active = FALSE
	return TRUE

/obj/machinery/atmospherics/components/binary/tank_compressor/proc/eject_disk(mob/user)
	if(!inserted_disk)
		return FALSE
	if(user)
		user.put_in_hands(inserted_disk)
	else
		inserted_disk.forceMove(drop_location())
	playsound(src, 'sound/machines/card_slide.ogg', 50)
	return TRUE

/// We rely on exited to clear references.
/obj/machinery/atmospherics/components/binary/tank_compressor/Exited(atom/movable/gone, direction)
	if(gone == inserted_disk)
		inserted_disk = null
	if(gone == inserted_tank)
		UnregisterSignal(inserted_tank, COMSIG_PARENT_QDELETING)
		inserted_tank = null
		update_appearance()
	. = ..()

/obj/machinery/atmospherics/components/binary/tank_compressor/on_deconstruction()
	eject_tank()
	eject_disk()
	return ..()

/obj/machinery/atmospherics/components/binary/tank_compressor/Destroy()
	inserted_tank = null
	inserted_disk = null
	leaked_gas_buffer = null
	QDEL_NULL(compressor_record) //We only want the list nuked, not the contents.
	return ..()

/obj/machinery/atmospherics/components/binary/tank_compressor/update_icon_state()
	if(istype(inserted_tank))
		icon_state = "[base_icon_state]-closed"
	else
		icon_state = "[base_icon_state]-open"
	return ..()

/obj/machinery/atmospherics/components/binary/tank_compressor/update_overlays()
	. = ..()
	. += get_pipe_image(icon, "[base_icon_state]-pipe", dir, COLOR_VIBRANT_LIME, piping_layer)
	. += get_pipe_image(icon, "[base_icon_state]-pipe", turn(dir, 180), COLOR_RED, piping_layer)
	if(!istype(inserted_tank))
		. += mutable_appearance(icon, "[base_icon_state]-doors")
	if(panel_open)
		. += mutable_appearance(icon, "[base_icon_state]-maintenance")
	else
		. += mutable_appearance(icon, "[base_icon_state]-cables")

/obj/machinery/atmospherics/components/binary/tank_compressor/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TankCompressor")
		ui.open()

/obj/machinery/atmospherics/components/binary/tank_compressor/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("change_rate")
			transfer_rate = clamp(params["target"], 0, TANK_COMPRESSOR_MAX_TRANSFER_RATE)
		if("toggle_injection")
			active = !active
		if("eject_tank")
			eject_tank(usr)
		if("eject_disk")
			eject_disk(usr)
		if("delete_record")
			var/datum/data/compressor_record/record = locate(params["ref"]) in compressor_record
			if(!compressor_record || !(record in compressor_record))
				return
			compressor_record -= record
			return TRUE

/obj/machinery/atmospherics/components/binary/tank_compressor/ui_static_data()
	var/list/data = list(
	"maxTransfer" = TANK_COMPRESSOR_MAX_TRANSFER_RATE,
	"leakPressure" = round(TANK_LEAK_PRESSURE),
	"fragmentPressure" = round(TANK_FRAGMENT_PRESSURE),
	"ejectPressure" = (ONE_ATMOSPHERE * 25) + ONE_ATMOSPHERE,
	)
	return data

/obj/machinery/atmospherics/components/binary/tank_compressor/ui_data(mob/user)
	var/list/data = list()
	data["tankPresent"] = inserted_tank ? TRUE : FALSE
	var/datum/gas_mixture/tank_air = inserted_tank?.return_air()
	data["tankPressure"] = tank_air?.return_pressure()
	data["leaking"] = inserted_tank?.obj_integrity <= 0

	data["active"] = active
	data["transferRate"] = transfer_rate
	data["lastPressure"] = last_recorded_pressure

	data["inputData"] = gas_mixture_parser(airs[2], "Input Port")
	data["outputData"] = gas_mixture_parser(airs[1], "Ouput Port")
	data["bufferData"] = gas_mixture_parser(leaked_gas_buffer, "Gas Buffer")

	data["disk"] = inserted_disk?.name
	data["storage"] = "[inserted_disk?.used_capacity] / [inserted_disk?.max_capacity] GQ"
	data["records"] = list()
	for (var/datum/data/compressor_record/record in compressor_record)
		var/list/single_record_data = list(
			"ref" = REF(record),
			"name" = record.name,
			"source" = record.experiment_source,
			"timestamp" = record.timestamp,
			"gases" = list()
		)
		for (var/gas_id in record.gas_data)
			single_record_data["gases"] += list(gas_id = record.gas_data[gas_id])
		data["records"] += list(single_record_data)
	return data
