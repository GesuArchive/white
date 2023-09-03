#define DOOR_CLOSE_WAIT 60 ///Default wait until doors autoclose
/obj/machinery/door
	name = "дверь"
	desc = "Открывается и закрывается. Удивительно."
	icon = 'icons/obj/doors/Doorint.dmi'
	base_icon_state = "door"
	icon_state = "door1"
	opacity = TRUE
	density = TRUE
	move_resist = MOVE_FORCE_VERY_STRONG
	layer = OPEN_DOOR_LAYER
	power_channel = AREA_USAGE_ENVIRON
	pass_flags_self = PASSDOORS
	max_integrity = 350
	armor = list(MELEE = 20, BULLET = 30, LASER = 20, ENERGY = 20, BOMB = 10, BIO = 100, RAD = 100, FIRE = 80, ACID = 70)
	can_atmos_pass = ATMOS_PASS_DENSITY
	flags_1 = PREVENT_CLICK_UNDER_1
	receive_ricochet_chance_mod = 0.8
	damage_deflection = 10

	interaction_flags_atom = INTERACT_ATOM_UI_INTERACT

	var/air_tight = FALSE	//TRUE means density will be set as soon as the door begins to close

	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.2

	var/secondsElectrified = MACHINE_NOT_ELECTRIFIED
	var/shockedby
	var/visible = TRUE
	var/operating = FALSE
	var/glass = FALSE
	var/welded = FALSE
	var/normalspeed = 1
	var/heat_proof = FALSE // For rglass-windowed airlocks and firedoors
	var/emergency = FALSE // Emergency access override
	var/sub_door = FALSE // true if it's meant to go under another door.
	var/closingLayer = CLOSED_DOOR_LAYER
	var/autoclose = FALSE //does it automatically close after some time
	var/safe = TRUE //whether the door detects things and mobs in its way and reopen or crushes them.
	var/locked = FALSE //whether the door is bolted or not.
	var/assemblytype //the type of door frame to drop during deconstruction
	var/datum/effect_system/spark_spread/spark_system
	var/real_explosion_block	//ignore this, just use explosion_block
	var/red_alert_access = FALSE //if TRUE, this door will always open on red alert
	/// Checks to see if this airlock has an unrestricted "sensor" within (will set to TRUE if present).
	var/unres_sensor = FALSE
	/// Unrestricted sides. A bitflag for which direction (if any) can open the door with no access
	var/unres_sides = NONE
	var/safety_mode = FALSE ///Whether or not the airlock can be opened with bare hands while unpowered
	var/can_crush = TRUE /// Whether or not the door can crush mobs.
	var/prevent_clicks_under_when_closed = TRUE
	var/can_open_with_hands = TRUE /// Whether or not the door can be opened by hand (used for blast doors and shutters)
	/// Whether or not this door can be opened through a door remote, ever
	var/opens_with_door_remote = FALSE
	/// Special operating mode for elevator doors
	var/elevator_mode = FALSE
	/// Current elevator status for processing
	var/elevator_status
	/// What specific lift ID do we link with?
	var/elevator_linked_id

/obj/machinery/door/examine(mob/user)
	. = ..()
	if(red_alert_access)
		. += "<hr>"
		if(SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED)
			. += "<span class='notice'>Учитывая угрозу, требования по доступу повышены!</span>\n"
		else
			. += "<span class='notice'>Учитывая красный код, требования по доступу повышены.</span>\n"
	. += "<hr><span class='notice'>Техническая панель <b>прикручена</b> на месте.</span>"
	if(safety_mode)
		. += "<hr><span class='notice'>Здесь есть надпись, что этот шлюз откроется <b>просто твоими руками</b>, если здесь не будет энергии.</span>"

/obj/machinery/door/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(!can_open_with_hands)
		return .

	if(isaicamera(user) || issilicon(user))
		return .

	if (isnull(held_item) && Adjacent(user))
		context[SCREENTIP_CONTEXT_LMB] = "Открыть"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/door/check_access_list(list/access_list)
	if(red_alert_access && SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED)
		return TRUE
	return ..()

/obj/machinery/door/Initialize(mapload)
	. = ..()
	set_init_door_layer()
	update_freelook_sight()
	air_update_turf(TRUE)
	register_context()
	GLOB.airlocks += src
	if(elevator_mode)
		if(elevator_linked_id)
			elevator_status = LIFT_PLATFORM_LOCKED
			GLOB.elevator_doors += src
		else
			stack_trace("Elevator door [src] has no linked elevator ID!")
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(2, 1, src)
	if(density && prevent_clicks_under_when_closed)
		flags_1 |= PREVENT_CLICK_UNDER_1
	else
		flags_1 &= ~PREVENT_CLICK_UNDER_1

	//doors only block while dense though so we have to use the proc
	real_explosion_block = explosion_block
	explosion_block = EXPLOSION_BLOCK_PROC
	RegisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED, PROC_REF(check_security_level))

	var/static/list/loc_connections = list(
		COMSIG_ATOM_MAGICALLY_UNLOCKED = PROC_REF(on_magic_unlock),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/door/proc/set_init_door_layer()
	if(density)
		layer = closingLayer
	else
		layer = initial(layer)

/obj/machinery/door/Destroy()
	update_freelook_sight()
	GLOB.airlocks -= src
	if(spark_system)
		qdel(spark_system)
		spark_system = null
	air_update_turf(TRUE)
	return ..()

/**
 * Signal handler for checking if we notify our surrounding that access requirements are lifted accordingly to a newly set security level
 *
 * Arguments:
 * * source The datum source of the signal
 * * new_level The new security level that is in effect
 */
/obj/machinery/door/proc/check_security_level(datum/source, new_level)
	SIGNAL_HANDLER

	if(new_level <= SEC_LEVEL_BLUE)
		return
	if(!red_alert_access)
		return
	audible_message("<span class='notice'>[src] издаёт странные звуки, похоже уровень доступа изменился!</span>")
	playsound(src, 'sound/machines/boltsup.ogg', 50, TRUE)

/obj/machinery/door/proc/try_safety_unlock(mob/user)
	if(safety_mode && !hasPower() && density)
		to_chat(user, span_notice("Начинаю разблокировать протоколы безопасности шлюза..."))
		if(do_after(user, 15 SECONDS, target = src))
			try_to_crowbar(null, user)
			return TRUE
	return FALSE

/obj/machinery/door/proc/is_holding_pressure()
	var/turf/open/T = get_turf(src)
	if(!T || !isopenturf(T))
		return FALSE
	if(!density)
		return FALSE
	// alrighty now we check for how much pressure we're holding back
	var/min_moles = T.air.total_moles()
	var/max_moles = min_moles
	// okay this is a bit hacky. First, we set density to 0 and recalculate our adjacent turfs
	density = FALSE
	T.immediate_calculate_adjacent_turfs()
	// then we use those adjacent turfs to figure out what the difference between the lowest and highest pressures we'd be holding is
	for(var/turf/open/T2 in T.atmos_adjacent_turfs)
		if((flags_1 & ON_BORDER_1) && get_dir(src, T2) != dir)
			continue
		var/moles = T2.air.total_moles()
		if(moles < min_moles)
			min_moles = moles
		if(moles > max_moles)
			max_moles = moles
	density = TRUE
	T.immediate_calculate_adjacent_turfs() // alright lets put it back
	return max_moles - min_moles > 20
/**
 * Called when attempting to remove the seal from an airlock
 *
 * Here because we need to call it and return if there was a seal so we don't try to open the door
 * or try its safety lock while it's sealed
 * Arguments:
 * * user - the mob attempting to remove the seal
 */
/obj/machinery/door/proc/try_remove_seal(mob/user)
	return

/obj/machinery/door/Bumped(atom/movable/AM)
	. = ..()
	if(operating || (obj_flags & EMAGGED) || (!can_open_with_hands && density))
		return
	if(ismob(AM))
		var/mob/B = AM
		if((isdrone(B) || iscyborg(B)) && B.stat)
			return
		if(isliving(AM))
			var/mob/living/M = AM
			if(world.time - M.last_bumped <= 10)
				return	//Can bump-open one airlock per second. This is to prevent shock spam.
			M.last_bumped = world.time
			if(HAS_TRAIT(M, TRAIT_HANDS_BLOCKED) && !check_access(null))
				return
			if(try_safety_unlock(M))
				return
			bumpopen(M)
			return
		return

	if(isitem(AM))
		var/obj/item/I = AM
		if(!density || (I.w_class < WEIGHT_CLASS_NORMAL && !LAZYLEN(I.GetAccess())))
			return
		if(check_access(I))
			open()
		else
			do_animate("deny")
		return

/obj/machinery/door/Move()
	var/turf/T = loc
	. = ..()
	if(density) //Gotta be closed my friend
		move_update_air(T)

/obj/machinery/door/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	// Snowflake handling for PASSGLASS.
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return !opacity

/obj/machinery/door/proc/bumpopen(mob/user)
	if(operating || !can_open_with_hands)
		return

	add_fingerprint(user)
	if(!density || (obj_flags & EMAGGED))
		return

	if(elevator_mode && elevator_status == LIFT_PLATFORM_UNLOCKED)
		open()
	else if(requiresID() && allowed(user))
		open()
	else
		do_animate("deny")

/obj/machinery/door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(try_remove_seal(user))
		return
	if(try_safety_unlock(user))
		return
	return try_to_activate_door(user)


/obj/machinery/door/attack_tk(mob/user)
	if(requiresID() && !allowed(null))
		return
	return ..()


/obj/machinery/door/proc/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating || (obj_flags & EMAGGED) || !can_open_with_hands)
		return
	if(!requiresID())
		user = null //so allowed(user) always succeeds
	if(allowed(user))
		if(density)
			open()
		else
			close()
		return TRUE
	if(density)
		do_animate("deny")

/obj/machinery/door/allowed(mob/M)
	if(emergency)
		return TRUE
	if(unrestricted_side(M))
		return TRUE
	return ..()

/obj/machinery/door/proc/unrestricted_side(mob/M) //Allows for specific side of airlocks to be unrestrected (IE, can exit maint freely, but need access to enter)
	return get_dir(src, M) & unres_sides

/obj/machinery/door/proc/try_to_weld(obj/item/weldingtool/W, mob/user)
	return

/obj/machinery/door/proc/try_to_crowbar(obj/item/I, mob/user)
	return

/obj/machinery/door/attackby(obj/item/I, mob/user, params)
	if(user.a_intent != INTENT_HARM && (I.tool_behaviour == TOOL_CROWBAR || istype(I, /obj/item/fireaxe) || istype(I, /obj/item/melee/sabre/proton_cutter)))
		var/forced_open = FALSE
		if(istype(I, /obj/item/crowbar))
			var/obj/item/crowbar/C = I
			forced_open = C.force_opens
		try_to_crowbar(I, user, forced_open)
		return TRUE
	else if(I.tool_behaviour == TOOL_WELDER)
		try_to_weld(I, user)
		return TRUE
	else if(!(I.item_flags & NOBLUDGEON) && user.a_intent != INTENT_HARM)
		try_to_activate_door(user)
		return TRUE
	return ..()

/obj/machinery/door/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && obj_integrity > 0)
		if(damage_amount >= 10 && prob(30))
			spark_system.start()

/obj/machinery/door/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(glass)
				playsound(loc, 'sound/effects/glasshit.ogg', 90, TRUE)
			else if(damage_amount)
				playsound(src, pick('white/valtos/sounds/metalblock1.wav', 'white/valtos/sounds/metalblock2.wav', \
									'white/valtos/sounds/metalblock3.wav', 'white/valtos/sounds/metalblock4.wav', \
									'white/valtos/sounds/metalblock5.wav', 'white/valtos/sounds/metalblock6.wav', \
									'white/valtos/sounds/metalblock7.wav', 'white/valtos/sounds/metalblock8.wav'), 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/machinery/door/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(prob(20/severity) && (istype(src, /obj/machinery/door/airlock) || istype(src, /obj/machinery/door/window)) )
		INVOKE_ASYNC(src, PROC_REF(open))
	if(prob(severity*10 - 20))
		if(secondsElectrified == MACHINE_NOT_ELECTRIFIED)
			secondsElectrified = MACHINE_ELECTRIFIED_PERMANENT
			LAZYADD(shockedby, "\[[time_stamp()]\]EM Pulse")
			addtimer(CALLBACK(src, PROC_REF(unelectrify)), 300)

/obj/machinery/door/proc/unelectrify()
	secondsElectrified = MACHINE_NOT_ELECTRIFIED

/obj/machinery/door/update_icon_state()
	. = ..()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(panel_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(panel_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("deny")
			if(!machine_stat)
				flick("door_deny", src)


/obj/machinery/door/proc/open()
	if(!density)
		return 1
	if(operating)
		return
	operating = TRUE
	use_power(active_power_usage)
	do_animate("opening")
	set_opacity(0)
	sleep(5)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	sleep(5)
	layer = initial(layer)
	update_icon()
	set_opacity(0)
	operating = FALSE
	air_update_turf(TRUE)
	update_freelook_sight()
	if(autoclose)
		autoclose_in(DOOR_CLOSE_WAIT)
	return 1

/obj/machinery/door/proc/close()
	if(density)
		return TRUE
	if(operating || welded)
		return
	if(safe)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				if(autoclose)
					autoclose_in(DOOR_CLOSE_WAIT)
				return

	operating = TRUE

	do_animate("closing")
	layer = closingLayer
	if(air_tight)
		density = TRUE
	sleep(5)
	set_density(TRUE)
	flags_1 |= PREVENT_CLICK_UNDER_1
	sleep(5)
	update_icon()
	if(visible && !glass)
		set_opacity(1)
	operating = FALSE
	air_update_turf(TRUE)
	update_freelook_sight()

	if(!can_crush)
		return TRUE

	if(safe)
		CheckForMobs()
	else
		crush()
	return TRUE

/obj/machinery/door/proc/CheckForMobs()
	if(locate(/mob/living) in get_turf(src))
		sleep(1)
		open()

/obj/machinery/door/proc/crush()
	for(var/mob/living/L in get_turf(src))
		L.visible_message(span_warning("[capitalize(src.name)] закрывается на [L], раздавливая [L.ru_ego()]!") , span_userdanger("[capitalize(src.name)] закрывается на мне с прикольным звуком!"))
		SEND_SIGNAL(L, COMSIG_LIVING_DOORCRUSHED, src)
		if(isalien(L))  //For xenos
			L.adjustBruteLoss(DOOR_CRUSH_DAMAGE * 1.5) //Xenos go into crit after aproximately the same amount of crushes as humans.
			L.emote("roar")
		else if(ishuman(L)) //For humans
			L.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
			L.emote("agony")
			L.Paralyze(100)
		else //for simple_animals & borgs
			L.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
		var/turf/location = get_turf(src)
		//add_blood doesn't work for borgs/xenos, but add_blood_floor does.
		L.add_splatter_floor(location)
		log_combat(src, L, "crushed")
	for(var/obj/vehicle/sealed/mecha/M in get_turf(src))
		M.take_damage(DOOR_CRUSH_DAMAGE)
		log_combat(src, M, "crushed")

/obj/machinery/door/proc/autoclose()
	if(!QDELETED(src) && !density && !operating && !locked && !welded && autoclose)
		close()

/obj/machinery/door/proc/autoclose_in(wait)
	addtimer(CALLBACK(src, PROC_REF(autoclose)), wait, TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/proc/hasPower()
	return !(machine_stat & NOPOWER)

/obj/machinery/door/proc/update_freelook_sight()
	if(!glass && GLOB.cameranet)
		GLOB.cameranet.updateVisibility(src, 0)

/obj/machinery/door/block_superconductivity() // All non-glass airlocks block heat, this is intended.
	if(opacity || heat_proof)
		return TRUE
	return FALSE

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

/obj/machinery/door/get_dumping_location(obj/item/storage/source,mob/user)
	return null

/obj/machinery/door/proc/lock()
	return

/obj/machinery/door/proc/unlock()
	return

/obj/machinery/door/proc/hostile_lockdown(mob/origin)
	if(!machine_stat) //So that only powered doors are closed.
		close() //Close ALL the doors!

/obj/machinery/door/proc/disable_lockdown()
	if(!machine_stat) //Opens only powered doors.
		open() //Open everything!

/obj/machinery/door/ex_act(severity, target)
	//if it blows up a wall it should blow up a door
	return ..(severity ? min(EXPLODE_DEVASTATE, severity + 1) : EXPLODE_NONE, target)

/obj/machinery/door/GetExplosionBlock()
	return density ? real_explosion_block : 0

/obj/machinery/door/power_change()
	. = ..()
	if(. && !(machine_stat & NOPOWER))
		autoclose_in(DOOR_CLOSE_WAIT)

/obj/machinery/door/zap_act(power, zap_flags)
	zap_flags &= ~ZAP_OBJ_DAMAGE
	. = ..()

/// Signal proc for [COMSIG_ATOM_MAGICALLY_UNLOCKED]. Open up when someone casts knock.
/obj/machinery/door/proc/on_magic_unlock(datum/source, datum/action/cooldown/spell/aoe/knock/spell, mob/living/caster)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(open))

#undef DOOR_CLOSE_WAIT
