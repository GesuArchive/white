/obj/machinery/portable_atmospherics
	name = "портативная атмосфера"
	icon = 'icons/obj/atmos.dmi'
	use_power = NO_POWER_USE
	max_integrity = 250
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 60, ACID = 30)
	anchored = FALSE

	var/datum/gas_mixture/air_contents
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0

	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/Initialize(mapload)
	. = ..()
	air_contents = new(volume)
	air_contents.set_temperature(T20C)
	SSair.atmos_machinery += src

/obj/machinery/portable_atmospherics/Destroy()
	SSair.atmos_machinery -= src
	disconnect()
	QDEL_NULL(air_contents)
	//SSair.stop_processing_machine(src)

	return ..()

/obj/machinery/portable_atmospherics/ex_act(severity, target)
	if(severity >= EXPLODE_DEVASTATE || target == src)
		if(resistance_flags & INDESTRUCTIBLE)
			return //Indestructable cans shouldn't release air

		//This explosion will destroy the can, release its air.
		var/turf/T = get_turf(src)
		T.assume_air(air_contents)
		T.air_update_turf()

	return ..()

/obj/machinery/portable_atmospherics/process_atmos()
	if(!connected_port) // Pipe network handles reactions if connected.
		air_contents.react(src)

/obj/machinery/portable_atmospherics/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/return_analyzable_air()
	return air_contents

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/components/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return FALSE

	//Make sure are close enough for a valid connection
	if(!(new_port.loc in locs))
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	var/datum/pipeline/connected_port_parent = connected_port.parents[1]
	connected_port_parent.reconcile_air()

	anchored = TRUE //Prevent movement
	pixel_x = new_port.pixel_x
	pixel_y = new_port.pixel_y
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/Move()
	. = ..()
	if(.)
		disconnect()

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return FALSE
	anchored = FALSE
	connected_port.connected_device = null
	connected_port = null
	pixel_x = 0
	pixel_y = 0
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)) || !can_interact(user))
		return
	if(holding)
		to_chat(user, span_notice("Достаю [holding] из [src]."))
		replace_tank(user, TRUE)

/obj/machinery/portable_atmospherics/examine(mob/user)
	. = ..()
	if(holding)
		. += "<hr><span class='notice'>[capitalize(src.name)] содержит [holding]. ПКМ [src] для быстрого изъятия.</span>"+\
			span_notice("\nНажми на [src.name] держа бак в руке для горячей замены [holding].")

/obj/machinery/portable_atmospherics/proc/replace_tank(mob/living/user, close_valve, obj/item/tank/new_tank)
	if(!user)
		return FALSE
	if(holding)
		user.put_in_hands(holding)
		holding = null
	if(new_tank)
		holding = new_tank
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank))
		if(!(machine_stat & BROKEN))
			var/obj/item/tank/T = W
			if(!user.transferItemToLoc(T, src))
				return
			to_chat(user, span_notice("[holding ? "Разом заменяю [holding] в [src] на [T]" : "Вставляю [T] в [src]"]."))
			investigate_log("had its internal [holding] swapped with [T] by [key_name(user)].", INVESTIGATE_ATMOS)
			replace_tank(user, FALSE, T)
			update_icon()
	else if(W.tool_behaviour == TOOL_WRENCH)
		if(!(machine_stat & BROKEN))
			if(connected_port)
				investigate_log("was disconnected from [connected_port] by [key_name(user)].", INVESTIGATE_ATMOS)
				disconnect()
				W.play_tool_sound(src)
				user.visible_message( \
					"[user] отсоединяет [src].", \
					span_notice("Отсоединяю [src] от порта.") , \
					span_hear("Слышу трещотку."))
				update_icon()
				return
			else
				var/obj/machinery/atmospherics/components/unary/portables_connector/possible_port = locate(/obj/machinery/atmospherics/components/unary/portables_connector) in loc
				if(!possible_port)
					to_chat(user, span_notice("Ничего не происходит."))
					return
				if(!connect(possible_port))
					to_chat(user, span_notice("[name] проваливает попытку присоединения к порту."))
					return
				W.play_tool_sound(src)
				user.visible_message( \
					"[user] присоединяет [src].", \
					span_notice("Присоединяю [src] к порту.") , \
					span_hear("Слышу трещотку."))
				update_icon()
				investigate_log("was connected to [possible_port] by [key_name(user)].", INVESTIGATE_ATMOS)
	else
		return ..()

/obj/machinery/portable_atmospherics/attacked_by(obj/item/I, mob/user)
	if(I.force < 10 && !(machine_stat & BROKEN))
		take_damage(0)
	else
		investigate_log("was smacked with \a [I] by [key_name(user)].", INVESTIGATE_ATMOS)
		add_fingerprint(user)
		..()

/obj/machinery/portable_atmospherics/rad_act(strength)
	. = ..()
	if (air_contents.get_moles(GAS_CO2) && air_contents.get_moles(GAS_O2))
		strength = min(strength,air_contents.get_moles(GAS_CO2)*1000,air_contents.get_moles(GAS_O2)*2000) //Ensures matter is conserved properly
		air_contents.set_moles(GAS_CO2, max(air_contents.get_moles(GAS_CO2)-(strength * 0.001),0))
		air_contents.set_moles(GAS_O2, max(air_contents.get_moles(GAS_O2)-(strength * 0.0005),0))
		air_contents.adjust_moles(GAS_PLUOXIUM, strength * 0.004)
		air_update_turf()
