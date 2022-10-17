// Disposal bin and Delivery chute.

GLOBAL_VAR_INIT(disposals_are_hungry, FALSE)

#define SEND_PRESSURE (0.05*ONE_ATMOSPHERE)

/obj/machinery/disposal
	icon = 'icons/obj/atmospherics/pipes/disposal.dmi'
	density = TRUE
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 90, ACID = 30)
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON
	obj_flags = CAN_BE_HIT | USES_TGUI
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1

	var/datum/gas_mixture/air_contents	// internal reservoir
	var/full_pressure = FALSE
	var/pressure_charging = TRUE
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	var/obj/structure/disposalconstruct/stored
	// create a new disposal
	// find the attached trunk (if present) and init gas resvr.

/obj/machinery/disposal/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()

	if(make_from)
		setDir(make_from.dir)
		make_from.moveToNullspace()
		stored = make_from
		pressure_charging = FALSE // newly built disposal bins start with pump off
	else
		stored = new /obj/structure/disposalconstruct(null, null , SOUTH , FALSE , src)

	trunk_check()

	air_contents = new /datum/gas_mixture()
	//gas.volume = 1.05 * CELLSTANDARD
	RegisterSignal(src, COMSIG_STORAGE_DUMP_CONTENT, .proc/on_storage_dump)
	update_icon()

	return INITIALIZE_HINT_LATELOAD //we need turfs to have air

/obj/machinery/disposal/proc/trunk_check()
	trunk = locate() in loc
	if(!trunk)
		pressure_charging = FALSE
		flush = FALSE
	else
		if(initial(pressure_charging))
			pressure_charging = TRUE
		flush = initial(flush)
		trunk.linked = src // link the pipe trunk to self


/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	return ..()

/obj/machinery/disposal/handle_atom_del(atom/A)
	if(A == stored && !QDELETED(src))
		stored = null
		deconstruct(FALSE)

/obj/machinery/disposal/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

/obj/machinery/disposal/LateInitialize()
	//this will get a copy of the air turf and take a SEND PRESSURE amount of air from it
	var/atom/L = loc
	var/datum/gas_mixture/env = new
	if(env && air_contents)
		var/datum/gas_mixture/copied = L?.return_air()
		if(copied)
			env.copy_from(copied)
		var/datum/gas_mixture/removed = env.remove(SEND_PRESSURE + 1)
		if(removed)
			air_contents.merge(removed)
	trunk_check()

/obj/machinery/disposal/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(!pressure_charging && !full_pressure && !flush)
		if(I.tool_behaviour == TOOL_SCREWDRIVER)
			panel_open = !panel_open
			I.play_tool_sound(src)
			to_chat(user, span_notice("[panel_open ? "Откручиваю":"Закручиваю"] винтики питания."))
			return
		else if(I.tool_behaviour == TOOL_WELDER && panel_open)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю разваривать [src]..."))
			if(I.use_tool(src, user, 20, volume=100) && panel_open)
				to_chat(user, span_notice("Развариваю [src]."))
				deconstruct()
			return

	if(user.a_intent != INTENT_HARM)
		if((I.item_flags & ABSTRACT) || !user.temporarilyRemoveItemFromInventory(I))
			return
		place_item_in_disposal(I, user)
		update_icon()
		return 1 //no afterattack
	else
		return ..()

/obj/machinery/disposal/proc/place_item_in_disposal(obj/item/I, mob/user)
	I.forceMove(src)
	if(GLOB.disposals_are_hungry)
		user.visible_message(span_danger("[user.name] кормит [src] используя [I]."), span_danger("Кормлю [src] используя [I]."))
		playsound(get_turf(src), 'sound/items/eatfood.ogg', 100, TRUE)
		qdel(I)
	else
		user.visible_message(span_notice("[user.name] закидывает [I] в [src]."), span_notice("Закидываю [I] в [src]."))

//mouse drop another mob or self
/obj/machinery/disposal/MouseDrop_T(mob/living/target, mob/living/user)
	if(istype(target))
		stuff_mob_in(target, user)

/obj/machinery/disposal/proc/stuff_mob_in(mob/living/target, mob/living/user)
	var/ventcrawler = HAS_TRAIT(user, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(user, TRAIT_VENTCRAWLER_NUDE)
	if(!iscarbon(user) && !ventcrawler) //only carbon and ventcrawlers can climb into disposal by themselves.
		if (iscyborg(user))
			var/mob/living/silicon/robot/borg = user
			if (!borg.module || !borg.module.canDispose)
				return
		else
			return
	if(!isturf(user.loc)) //No magically doing it from inside closets
		return
	if(target.buckled || target.has_buckled_mobs())
		return
	if(target.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, span_warning("[target] не помещается внутри [src]!"))
		return
	add_fingerprint(user)
	if(user == target)
		user.visible_message(span_warning("[user] начинает забираться внутрь [src].") , span_notice("Начинаю забираться внутрь [src]..."))
	else
		target.visible_message(span_danger("[user] начинает заталкивать [target] в [src].") , span_userdanger("[user] начинает заталкивать меня в [src]!"))
	if(do_mob(user, target, 20))
		if (!loc)
			return
		target.forceMove(src)
		if(user == target)
			user.visible_message(span_warning("[user] забирается в [src].") , span_notice("Забираюсь в [src]."))
			. = TRUE
		else
			target.visible_message(span_danger("[user] заталкивает [target] в [src].") , span_userdanger("[user] заталкивает меня в [src]."))
			log_combat(user, target, "stuffed", addition="into [src]")
			target.LAssailant = WEAKREF(user)
			. = TRUE
		if(GLOB.disposals_are_hungry)
			playsound(get_turf(src), 'sound/items/eatfood.ogg', 100, TRUE)
			target.gib()
		update_icon()

/obj/machinery/disposal/relaymove(mob/living/user, direction)
	attempt_escape(user)

// resist to escape the bin
/obj/machinery/disposal/container_resist_act(mob/living/user)
	attempt_escape(user)

/obj/machinery/disposal/proc/attempt_escape(mob/user)
	if(flushing)
		return
	go_out(user)

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	user.forceMove(loc)
	update_icon()

// clumsy monkeys and xenos can only pull the flush lever
/obj/machinery/disposal/attack_paw(mob/user)
	if(ISADVANCEDTOOLUSER(user))
		return ..()
	if(machine_stat & BROKEN)
		return
	flush = !flush
	update_icon()


// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	pipe_eject(src, FALSE, FALSE)
	update_icon()

/obj/machinery/disposal/proc/flush()
	flushing = TRUE
	flushAnimation()
	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, FALSE, FALSE)
		last_sound = world.time
	sleep(5)
	if(QDELETED(src))
		return
	var/obj/structure/disposalholder/H = new(src)
	newHolderDestination(H)
	H.init(src)
	air_contents = new()
	H.start(src)
	flushing = FALSE
	flush = FALSE

/obj/machinery/disposal/proc/newHolderDestination(obj/structure/disposalholder/H)
	for(var/obj/item/delivery/small/O in src)
		H.tomail = TRUE
		return

/obj/machinery/disposal/proc/flushAnimation()
	flick("[icon_state]-flush", src)

// called when holder is expelled from a disposal
/obj/machinery/disposal/proc/expel(obj/structure/disposalholder/H)
	H.active = FALSE

	playsound(src, 'sound/machines/hiss.ogg', 50, FALSE, FALSE)

	pipe_eject(H)

	H.vent_gas(loc)
	qdel(H)

/obj/machinery/disposal/deconstruct(disassembled = TRUE)
	var/turf/T = loc
	if(!(flags_1 & NODECONSTRUCT_1))
		if(stored)
			stored.forceMove(T)
			src.transfer_fingerprints_to(stored)
			stored.set_anchored(FALSE)
			stored.set_density(TRUE)
			stored.update_appearance()
	for(var/atom/movable/AM in src) //out, out, darned crowbar!
		AM.forceMove(T)
	..()

//How disposal handles getting a storage dump from a storage object
/obj/machinery/disposal/proc/on_storage_dump(datum/source, obj/item/storage_source, mob/user)
	SIGNAL_HANDLER

	. = STORAGE_DUMP_HANDLED

	to_chat(user, span_notice("Вытряхиваю содержимое <b>[storage_source]</b> в <b>[src]</b>."))

	for(var/obj/item/to_dump in storage_source)
		if(to_dump.loc != storage_source)
			continue
		if(user.active_storage != storage_source && to_dump.on_found(user))
			return
		if(!storage_source.atom_storage.attempt_remove(to_dump, src, silent = TRUE))
			continue
		to_dump.pixel_x = to_dump.base_pixel_x + rand(-5, 5)
		to_dump.pixel_y = to_dump.base_pixel_y + rand(-5, 5)

// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables

GLOBAL_LIST_EMPTY(disposal_bins)

/obj/machinery/disposal/bin
	name = "мусорка"
	desc = "Пневматическая установка для удаления отходов."
	icon_state = "disposal"

/obj/machinery/disposal/bin/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()
	GLOB.disposal_bins += src

/obj/machinery/disposal/bin/Destroy()
	GLOB.disposal_bins -= src
	. = ..()

// attack by item places it in to disposal
/obj/machinery/disposal/bin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/trash))	//Not doing component overrides because this is a specific type.
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, span_warning("Опустошаю мешок."))
		for(var/obj/item/O in T.contents)
			T.atom_storage.attempt_remove(O,src)
		T.update_icon()
		update_icon()
	else
		return ..()

// handle machine interaction

/obj/machinery/disposal/bin/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/disposal/bin/ui_interact(mob/user, datum/tgui/ui)
	if(machine_stat & BROKEN)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DisposalUnit", name)
		ui.open()

/obj/machinery/disposal/bin/ui_data(mob/user)
	var/list/data = list()
	data["flush"] = flush
	data["full_pressure"] = full_pressure
	data["pressure_charging"] = pressure_charging
	data["panel_open"] = panel_open
	data["per"] = CLAMP01(air_contents.return_pressure() / (SEND_PRESSURE))
	data["isai"] = isAI(user)
	return data

/obj/machinery/disposal/bin/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("handle-0")
			flush = FALSE
			update_icon()
			. = TRUE
		if("handle-1")
			if(!panel_open)
				flush = TRUE
				update_icon()
			. = TRUE
		if("pump-0")
			if(pressure_charging)
				pressure_charging = FALSE
				update_icon()
			. = TRUE
		if("pump-1")
			if(!pressure_charging)
				pressure_charging = TRUE
				update_icon()
			. = TRUE
		if("eject")
			eject()
			. = TRUE


/obj/machinery/disposal/bin/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isitem(AM) && AM.CanEnterDisposals())
		if(GLOB.disposals_are_hungry)
			visible_message(span_danger("[capitalize(src)] поедает [AM]."))
			playsound(get_turf(src), 'sound/items/eatfood.ogg', 100, TRUE)
			qdel(AM)
			return
		if(prob(75))
			AM.forceMove(src)
			visible_message(span_notice("[AM] приземляется в [src]."))
			update_icon()
		else
			visible_message(span_notice("[AM] отскакивает от края [src]!"))
			return ..()
	else
		return ..()

/obj/machinery/disposal/bin/flush()
	..()
	full_pressure = FALSE
	pressure_charging = TRUE
	update_icon()

/obj/machinery/disposal/bin/update_overlays()
	. = ..()

	luminosity = 0

	if(machine_stat & BROKEN)
		return

	//flush handle
	if(flush)
		. += "dispover-handle"

	//only handle is shown if no power
	if(machine_stat & NOPOWER || panel_open)
		return

	luminosity = 1
	//check for items in disposal - occupied light
	if(contents.len > 0)
		. += "dispover-full"
		. += emissive_appearance(icon, "dispover-full", src, alpha = src.alpha)

	//charging and ready light
	if(pressure_charging)
		. += "dispover-charge"
		. += emissive_appearance(icon, "dispover-charge-glow", src, alpha = src.alpha)
	else if(full_pressure)
		. += "dispover-ready"
		. += emissive_appearance(icon, "dispover-ready-glow", src, alpha = src.alpha)

/obj/machinery/disposal/bin/proc/do_flush()
	set waitfor = FALSE
	flush()

//timed process
//charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/bin/process(delta_time)
	if(machine_stat & BROKEN) //nothing can happen if broken
		return

	flush_count++
	if(flush_count >= flush_every_ticks)
		if(contents.len)
			if(full_pressure)
				do_flush()
		flush_count = 0

	updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE) // flush can happen even without power
		do_flush()

	if(machine_stat & NOPOWER) // won't charge if no power
		return

	use_power(idle_power_usage) // base power usage

	if(!pressure_charging) // if off or ready, no need to charge
		if(GLOB.disposals_are_hungry && prob(10))
			for(var/obj/item/I in view(1, src))
				if(I == src || !isitem(I))
					continue
				hitby(I)
				break
		return

	// otherwise charge
	use_power(idle_power_usage) // charging power usage

	var/atom/L = loc //recharging from loc turf

	var/datum/gas_mixture/env = L.return_air()
	var/pressure_delta = (SEND_PRESSURE*1.01) - air_contents.return_pressure()

	if(env && air_contents && env.return_temperature() > 0)
		var/transfer_moles = 0.1 * pressure_delta*air_contents.return_volume()/(env.return_temperature() * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		if(removed)
			air_contents.merge(removed)
		air_update_turf()


	//if full enough, switch to ready mode
	if(air_contents.return_pressure() >= SEND_PRESSURE)
		full_pressure = TRUE
		pressure_charging = FALSE
		update_icon()
	return

/obj/machinery/disposal/bin/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 2)

//Delivery Chute

/obj/machinery/disposal/delivery_chute
	name = "разгрузочный желоб"
	desc = "Лоток для больших и маленьких пакетов!"
	density = TRUE
	icon_state = "intake"
	pressure_charging = FALSE // the chute doesn't need charging and always works

/obj/machinery/disposal/delivery_chute/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()
	trunk = locate() in loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/delivery_chute/place_item_in_disposal(obj/item/I, mob/user)
	if(I.CanEnterDisposals())
		..()
		flush()

/obj/machinery/disposal/delivery_chute/Bumped(atom/movable/AM) //Go straight into the chute
	if(QDELETED(AM) || !AM.CanEnterDisposals())
		return
	if(!(get_step(loc, dir) in AM.locs))
		return

	if(isobj(AM))
		var/obj/O = AM
		O.forceMove(src)
	else if(ismob(AM))
		var/mob/M = AM
		if(prob(2)) // to prevent mobs being stuck in infinite loops
			to_chat(M, span_warning("Влетаю в край желоба."))
			return
		M.forceMove(src)
	flush()

/atom/movable/proc/CanEnterDisposals()
	return TRUE

/obj/projectile/CanEnterDisposals()
	return

/obj/effect/CanEnterDisposals()
	return

/obj/vehicle/sealed/mecha/CanEnterDisposals()
	return

/obj/machinery/disposal/bin/newHolderDestination(obj/structure/disposalholder/H)
	H.destinationTag = 1

/obj/machinery/disposal/delivery_chute/newHolderDestination(obj/structure/disposalholder/H)
	H.destinationTag = 1

/obj/machinery/disposal/mechcomp
	name = "mechcomp Disposals trapdoor"
	desc = "You have a bad feeling about this."
	icon = 'white/RedFoxIV/icons/obj/mechcomp.dmi'
	icon_state = "comp_disp"
	density = FALSE
	var/cooldown = FALSE
	var/datum/component/mechanics_holder/compdatum

/obj/machinery/disposal/mechcomp/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Flush!", "activateproc")

/obj/machinery/disposal/mechcomp/ComponentInitialize()
	. = ..()
	compdatum = AddComponent(/datum/component/mechanics_holder)

/obj/machinery/disposal/mechcomp/proc/activateproc(datum/mechcompMessage/msg)
	if(cooldown || !anchored || !trunk)
		return
	var/list/flushed_mobs = list()
	var/flushed_AM = 0
	var/mob/living/L
	for(var/obj/AM in get_turf(src))
		if(AM.anchored || AM == src)
			continue
		AM.forceMove(src)
		flushed_AM++
		if(isliving(AM))
			L = AM
			flushed_mobs.Add("[L.ckey ? "[L.ckey] as " : ""][L.name]")
	log_mechcomp("[src.name] at x=[src.x], y=[src.y], z=[src.z]: flushed [flushed_AM] objects[flushed_mobs.len ? ", including following mobs: [jointext(flushed_mobs, ", ")]." : ""] Last IO edit [last_io_edit()], last config edit: [last_config_edit()]")
	activate_for(7 SECONDS)
	flush()

//copypaste of attackby proc from /obj/machinery/disposal because i need to move temporarilyRemoveItemFromInventory() proc call because it's fucking me over.
/obj/machinery/disposal/mechcomp/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(!pressure_charging && !full_pressure && !flush)
		if(I.tool_behaviour == TOOL_SCREWDRIVER)
			panel_open = !panel_open
			I.play_tool_sound(src)
			to_chat(user, span_notice("[panel_open ? "Откручиваю":"Закручиваю"] винтики питания."))
			return
		else if(I.tool_behaviour == TOOL_WELDER && panel_open)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю разваривать [src]..."))
			if(I.use_tool(src, user, 20, volume=100) && panel_open)
				to_chat(user, span_notice("Развариваю [src]."))
				deconstruct()
			return

	if(user.a_intent != INTENT_HARM)
		if((I.item_flags & ABSTRACT) || !flushing)
			to_chat(user, span_notice("You don't see any opening to drop [I.name] into!"))
			return
		if(!user.temporarilyRemoveItemFromInventory(I))
			return
		place_item_in_disposal(I, user)
		update_icon()
		return 1 //no afterattack
	else
		return ..()

/obj/machinery/disposal/mechcomp/proc/activate_for(time)
	cooldown = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/_deactivate), time)

/obj/machinery/disposal/mechcomp/proc/_deactivate()
	cooldown = FALSE
	update_icon()

/obj/machinery/disposal/mechcomp/flushAnimation()
	update_icon()
	. = ..()

/obj/machinery/disposal/mechcomp/flush()
	. = ..()
	update_icon()

/obj/machinery/disposal/mechcomp/trunk_check()
	. = ..()
	if(!trunk)
		return
	switch(trunk.dir)
		if(1)
			pixel_y = -2
		if(2)
			pixel_y = 2
		if(4)
			pixel_x = -2
		if(8)
			pixel_x = 2

/obj/machinery/disposal/mechcomp/place_item_in_disposal(obj/item/I, mob/user)
	to_chat(user, span_notice("You [prob(50)?"manage to":"quickly"] [prob(50)?"slip":"drop"] [I.name] inside while [src.name] is open."))
	. = ..()

/obj/machinery/disposal/mechcomp/update_overlays()
	. = ..()
	if(!anchored)
		return
	if(flushing)
		. += "disp_overlay_working"
		return
	if(cooldown)
		. += "disp_overlay_cooldown"
	if(!flushing && !cooldown)
		. += "disp_overlay_standby"


/obj/machinery/disposal/mechcomp/proc/last_config_edit()
	//return list("user" = compdatum.last_edited_configs_by["user"], "action" = compdatum.last_edited_configs_by["action"])
	var/mob/user = compdatum.last_edited_configs_by["user"]
	return  "by [user?.ckey], [compdatum.last_edited_configs_by["action"]]"

/obj/machinery/disposal/mechcomp/proc/last_io_edit()
	//return list("user" = compdatum.last_edited_inputs_by["user"], "action" = compdatum.last_edited_inputs_by["action"])
	var/mob/user = compdatum.last_edited_configs_by["user"]
	return  "by [user?.ckey], [compdatum.last_edited_inputs_by["action"]]"
