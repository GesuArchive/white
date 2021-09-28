/obj/machinery/meter
	name = "расходомер газа"
	desc = "Он что-то измеряет."
	icon = 'icons/obj/atmospherics/pipes/meter.dmi'
	icon_state = "meterX"
	layer = HIGH_PIPE_LAYER
	power_channel = AREA_USAGE_ENVIRON
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	active_power_usage = 400
	max_integrity = 150
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 40, ACID = 0)
	var/frequency = 0
	var/atom/target
	var/target_layer = PIPING_LAYER_DEFAULT

/obj/machinery/meter/atmos
	frequency = FREQ_ATMOS_STORAGE

/obj/machinery/meter/atmos/layer2
	target_layer = 2

/obj/machinery/meter/atmos/layer4
	target_layer = 4

/obj/machinery/meter/atmos/atmos_waste_loop
	name = "расходомер отстойника"
	id_tag = ATMOS_GAS_MONITOR_LOOP_ATMOS_WASTE

/obj/machinery/meter/atmos/distro_loop
	name = "расходомер распеределителя"
	id_tag = ATMOS_GAS_MONITOR_LOOP_DISTRIBUTION

/obj/machinery/meter/Destroy()
	SSair.atmos_machinery -= src
	target = null
	return ..()

/obj/machinery/meter/Initialize(mapload, new_piping_layer)
	if(!isnull(new_piping_layer))
		target_layer = new_piping_layer
	SSair.atmos_machinery += src
	if(!target)
		reattach_to_layer()
	return ..()

/obj/machinery/meter/proc/reattach_to_layer()
	var/obj/machinery/atmospherics/candidate
	for(var/obj/machinery/atmospherics/pipe/pipe in loc)
		if(pipe.piping_layer == target_layer)
			candidate = pipe
	if(candidate)
		target = candidate
		setAttachLayer(candidate.piping_layer)

/obj/machinery/meter/proc/setAttachLayer(new_layer)
	target_layer = new_layer
	PIPING_LAYER_DOUBLE_SHIFT(src, target_layer)

/obj/machinery/meter/process_atmos()
	if(!(target?.flags_1 & INITIALIZED_1))
		icon_state = "meterX"
		return FALSE

	if(machine_stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return FALSE

	use_power(5)

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		icon_state = "meterX"
		return FALSE

	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_[val]"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_[val]"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_[val]"
	else
		icon_state = "meter4"

	if(frequency)
		var/datum/radio_frequency/radio_connection = SSradio.return_frequency(frequency)

		if(!radio_connection)
			return

		var/datum/signal/signal = new(list(
			"id_tag" = id_tag,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		))
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/proc/status()
	if (target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			. = "<hr>Манометр показывает [round(environment.return_pressure(), 0.01)] кПа; [round(environment.return_temperature(),0.01)] K ([round(environment.return_temperature()-T0C,0.01)]&deg;C)."
		else
			. = "<hr>Ошибка сенсора."
	else
		. = "<hr>Ошибка подключения."

/obj/machinery/meter/examine(mob/user)
	. = ..()
	. += status()

/obj/machinery/meter/wrench_act(mob/user, obj/item/I)
	..()
	to_chat(user, span_notice("Начинаю откручивать <b>[src.name]</b>..."))
	if (I.use_tool(src, user, 40, volume=50))
		user.visible_message(
			"[user] откручивает <b>[src.name]</b>.",
			span_notice("Откручиваю <b>[src.name]</b>.") ,
			span_hear("Слышу трещотку."))
		deconstruct()
	return TRUE

/obj/machinery/meter/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/pipe_meter(loc)
	qdel(src)

/obj/machinery/meter/interact(mob/user)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	else
		to_chat(user, status())

/obj/machinery/meter/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

// TURF METER - REPORTS A TILE'S AIR CONTENTS
//	why are you yelling?
/obj/machinery/meter/turf

/obj/machinery/meter/turf/reattach_to_layer()
	target = loc
