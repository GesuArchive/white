/obj/structure/window
	name = "окно"
	desc = "Окно. Невероятно."
	icon_state = "window"
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE //initially is 0 for tile smoothing
	flags_1 = ON_BORDER_1 | RAD_PROTECT_CONTENTS_1
	max_integrity = 25
	can_be_unanchored = TRUE
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	can_atmos_pass = ATMOS_PASS_PROC
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	pass_flags_self = PASSGLASS
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.5
	var/ini_dir = null
	var/state = WINDOW_OUT_OF_FRAME
	var/reinf = FALSE
	var/heat_resistance = 800
	var/decon_speed = 30
	var/wtype = "glass"
	var/fulltile = FALSE
	var/glass_type = /obj/item/stack/sheet/glass
	var/glass_amount = 1
	var/mutable_appearance/crack_overlay
	var/real_explosion_block	//ignore this, just use explosion_block
	var/breaksound = "shatter"
	var/knocksound = 'sound/effects/Glassknock.ogg'
	var/bashsound = 'sound/effects/Glassbash.ogg'
	var/hitsound = 'sound/effects/Glasshit.ogg'
	/// If some inconsiderate jerk has had their blood spilled on this window, thus making it cleanable
	var/bloodied = FALSE


/obj/structure/window/examine(mob/user)
	. = ..()
	if(reinf)
		if(anchored && state == WINDOW_SCREWED_TO_FRAME)
			. += span_notice("Окно <b>прикручено</b> к рамке.")
		else if(anchored && state == WINDOW_IN_FRAME)
			. += span_notice("Окно <i>откручено</i> от рамки, но всё ещё <b>пристыковано</b> к ней.")
		else if(anchored && state == WINDOW_OUT_OF_FRAME)
			. += span_notice("Окно вышло из рамки, но может быть <i>пристыковано</i> к ней. Оно <b>прикручено</b> к полу.")
		else if(!anchored)
			. += span_notice("Окно <i>окручено</i> от пола, и может быть разобрано <b>раскручиванием</b>.")
	else
		if(anchored)
			. += span_notice("Окно <b>прикручено</b> к полу.")
		else
			. += span_notice("Окно <i>окручено</i> от пола, и может быть разобрано <b>раскручиванием</b>.")

/obj/structure/window/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)
	if(reinf && anchored)
		state = RWINDOW_SECURE

	ini_dir = dir
	air_update_turf(TRUE)

	if(fulltile)
		setDir()

	//windows only block while reinforced and fulltile, so we'll use the proc
	real_explosion_block = explosion_block
	explosion_block = EXPLOSION_BLOCK_PROC

	flags_1 |= ALLOW_DARK_PAINTS_1
	RegisterSignal(src, COMSIG_OBJ_PAINTED, PROC_REF(on_painted))

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	if (flags_1 & ON_BORDER_1)
		AddComponent(/datum/component/connect_loc_behalf, src, loc_connections)

/obj/structure/window/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS ,null,CALLBACK(src, PROC_REF(can_be_rotated)),CALLBACK(src, PROC_REF(after_rotation)))
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/window/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
	return FALSE

/obj/structure/window/rcd_act(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Разбираю окно."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/window/narsie_act()
	add_atom_colour(NARSIE_WINDOW_COLOUR, FIXED_COLOUR_PRIORITY)

/obj/structure/window/singularity_pull(S, current_size)
	..()
	if(anchored && current_size >= STAGE_TWO)
		set_anchored(FALSE)
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)

/obj/structure/window/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/window/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return

	if(fulltile)
		return FALSE

	if(border_dir == dir)
		return FALSE

	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/moved_window = mover
		return valid_window_location(loc, moved_window.dir, is_fulltile = moved_window.fulltile)

	if(istype(mover, /obj/structure/windoor_assembly) || istype(mover, /obj/machinery/door/window))
		return valid_window_location(loc, mover.dir, is_fulltile = FALSE)

	return TRUE

/obj/structure/window/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if (leaving.pass_flags & pass_flags_self)
		return

	if (fulltile)
		return

	if(direction == dir && density)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/window/attack_tk(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("Что-то стучит по окну."))
	add_fingerprint(user)
	playsound(src, knocksound, 50, TRUE)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/structure/window/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	if(!can_be_reached(user))
		return
	. = ..()

/obj/structure/window/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!can_be_reached(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)

	if(user.a_intent != INTENT_HARM)
		user.visible_message(span_notice("[user] стучит по окну.") , \
			span_notice("Стучу по окну."))
		playsound(src, knocksound, 50, TRUE)
	else
		user.visible_message(span_warning("[user] долбится в окно!") , \
			span_warning("Долблю окно!"))
		playsound(src, bashsound, 100, TRUE)

/obj/structure/window/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/window/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)	//used by attack_alien, attack_animal, and attack_slime
	if(!can_be_reached(user))
		return
	..()

/obj/structure/window/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return 1 //skip the afterattack

	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю чинить [src.name]..."))
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				update_nearby_icons()
				to_chat(user, span_notice("Чиню [src.name]."))
		else
			to_chat(user, span_warning("[capitalize(skloname(src.name, VINITELNI, src.gender))] не требуется починка!"))
		return

	if(!(flags_1&NODECONSTRUCT_1) && !(reinf && state >= RWINDOW_FRAME_BOLTED))
		if(I.tool_behaviour == TOOL_SCREWDRIVER)
			to_chat(user, span_notice("Начинаю [anchored ? "откручивать окно от пола":"прикручивать окно к полу"]..."))
			if(I.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_anchored), anchored)))
				set_anchored(!anchored)
				to_chat(user, span_notice("[anchored ? "Прикручиваю к полу":"Откручиваю от пола"]."))
			return
		else if(I.tool_behaviour == TOOL_WRENCH && !anchored)
			to_chat(user, span_notice("Начинаю разбирать [src.name]..."))
			if(I.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				var/obj/item/stack/sheet/G = new glass_type(user.loc, glass_amount)
				if (!QDELETED(G))
					G.add_fingerprint(user)
				playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
				to_chat(user, span_notice("Разбираю [src.name]."))
				qdel(src)
			return
		else if(I.tool_behaviour == TOOL_CROWBAR && reinf && (state == WINDOW_OUT_OF_FRAME) && anchored)
			to_chat(user, span_notice("Начинаю вставлять окно в рамку..."))
			if(I.use_tool(src, user, 100, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				state = RWINDOW_SECURE
				to_chat(user, span_notice("Вставляю окно в рамку."))
			return

	return ..()

/obj/structure/window/set_anchored(anchorvalue)
	..()
	air_update_turf(anchorvalue)
	update_nearby_icons()

/obj/structure/window/proc/check_state(checked_state)
	if(state == checked_state)
		return TRUE

/obj/structure/window/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/window/proc/check_state_and_anchored(checked_state, checked_anchored)
	return check_state(checked_state) && check_anchored(checked_anchored)


/obj/structure/window/proc/can_be_reached(mob/user)
	if(fulltile)
		return TRUE
	var/checking_dir = get_dir(user, src)
	if(!(checking_dir & dir))
		return TRUE // Only windows on the other side may be blocked by other things.
	checking_dir = REVERSE_DIR(checking_dir)
	for(var/obj/blocker in loc)
		if(!blocker.CanPass(user, checking_dir))
			return FALSE
	return TRUE


/obj/structure/window/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	. = ..()
	if(.) //received damage
		update_nearby_icons()

/obj/structure/window/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, hitsound, 75, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/Welder.ogg', 100, TRUE)


/obj/structure/window/deconstruct(disassembled = TRUE)
	if(QDELETED(src))
		return
	if(!disassembled)
		playsound(src, breaksound, 70, TRUE)
		if(!(flags_1 & NODECONSTRUCT_1))
			for(var/obj/item/shard/debris in spawnDebris(drop_location()))
				transfer_fingerprints_to(debris) // transfer fingerprints to shards only
	qdel(src)
	update_nearby_icons()

/obj/structure/window/proc/spawnDebris(location)
	. = list()
	. += new /obj/item/shard(location)
	. += new /obj/effect/decal/cleanable/glass(location)
	if (reinf)
		. += new /obj/item/stack/rods(location, (fulltile ? 2 : 1))
	if (fulltile)
		. += new /obj/item/shard(location)

/obj/structure/window/proc/can_be_rotated(mob/user,rotation_type)
	if(anchored)
		to_chat(user, span_warning("[src] cannot be rotated while it is fastened to the floor!"))
		return FALSE

	var/target_dir = turn(dir, rotation_type == ROTATION_CLOCKWISE ? -90 : 90)

	if(!valid_window_location(loc, target_dir, is_fulltile = fulltile))
		to_chat(user, span_warning("[src] cannot be rotated in that direction!"))
		return FALSE
	return TRUE

/obj/structure/window/proc/after_rotation(mob/user,rotation_type)
	air_update_turf(TRUE)
	ini_dir = dir
	add_fingerprint(user)

/obj/structure/window/proc/on_painted(obj/structure/window/source, is_dark_color)
	SIGNAL_HANDLER

	if (is_dark_color)
		set_opacity(255)
	else
		set_opacity(initial(opacity))

/obj/structure/window/wash(clean_types)
	. = ..()
	if(!(clean_types & CLEAN_SCRUB))
		return
	set_opacity(initial(opacity))
	remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	for(var/atom/movable/cleanables as anything in src)
		if(cleanables == src)
			continue
		if(!cleanables.wash(clean_types))
			continue
		vis_contents -= cleanables
	bloodied = FALSE

/obj/structure/window/Destroy()
	set_density(FALSE)
	air_update_turf(TRUE)
	update_nearby_icons()
	return ..()


/obj/structure/window/Move()
	var/turf/T = loc

	. = ..()
	setDir(ini_dir)
	if(anchored)
		move_update_air(T)

/obj/structure/window/can_atmos_pass(turf/T)
	if(!anchored || !density)
		return TRUE
	return !(FULLTILE_WINDOW_DIR == dir || dir == get_dir(loc, T))

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_appearance()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

//merges adjacent full-tile windows into one
/obj/structure/window/update_overlays(updates=ALL)
	. = ..()
	if(QDELETED(src) || !fulltile)
		return

	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

	var/ratio = obj_integrity / max_integrity
	ratio = CEILING(ratio*4, 1) * 25
	cut_overlay(crack_overlay)
	if(ratio > 75)
		return
	crack_overlay = mutable_appearance('icons/obj/structures.dmi', "damage[ratio]", -(layer+0.1))
	. += crack_overlay

/obj/structure/window/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > T0C + heat_resistance

/obj/structure/window/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(round(air.return_volume() / 100), BURN, 0, 0)

/obj/structure/window/get_dumping_location(obj/item/storage/source,mob/user)
	return null

/obj/structure/window/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id)
	if(!density)
		return TRUE
	if((dir == FULLTILE_WINDOW_DIR) || (dir == to_dir))
		return FALSE

	return TRUE

/obj/structure/window/GetExplosionBlock()
	return reinf && fulltile ? real_explosion_block : 0

/obj/structure/window/spawner/east
	dir = EAST

/obj/structure/window/spawner/west
	dir = WEST

/obj/structure/window/spawner/north
	dir = NORTH

/obj/structure/window/unanchored
	anchored = FALSE

/obj/structure/window/reinforced
	name = "армированное окно"
	desc = "Окно, которое укреплено стальными прутьями."
	icon_state = "rwindow"
	reinf = TRUE
	heat_resistance = 1600
	armor = list(MELEE = 80, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 25, BIO = 100, RAD = 100, FIRE = 80, ACID = 100)
	max_integrity = 75
	explosion_block = 1
	damage_deflection = 11
	state = RWINDOW_SECURE
	glass_type = /obj/item/stack/sheet/rglass
	rad_insulation = RAD_HEAVY_INSULATION
	receive_ricochet_chance_mod = 1.1

//this is shitcode but all of construction is shitcode and needs a refactor, it works for now
//If you find this like 4 years later and construction still hasn't been refactored, I'm so sorry for this //Adding a timestamp, I found this in 2020, I hope it's from this year -Lemon
/obj/structure/window/reinforced/attackby(obj/item/I, mob/living/user, params)
	switch(state)
		if(RWINDOW_SECURE)
			if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HARM)
				user.visible_message(span_notice("[user] направляет [skloname(I.name, VINITELNI, I.gender)] на защищённые винтики [skloname(src.name, VINITELNI, src.gender)]...") ,
										span_notice("Начинаю нагревать винтики [skloname(src.name, VINITELNI, src.gender)]..."))
				if(I.use_tool(src, user, 180, volume = 100))
					to_chat(user, span_notice("Винтики раскалены до бела, похоже можно открутить их прямо сейчас."))
					state = RWINDOW_BOLTS_HEATED
					addtimer(CALLBACK(src, PROC_REF(cool_bolts)), 300)
				return
		if(RWINDOW_BOLTS_HEATED)
			if(I.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user] втыкает отвёртку в раскалённые винтики и начинает их выкручивать...") ,
										span_notice("Втыкаю отвёртку в раскалённые винтики и начинаю их выкручивать..."))
				if(I.use_tool(src, user, 80, volume = 50))
					state = RWINDOW_BOLTS_OUT
					to_chat(user, span_notice("Винтики удалены и теперь окно можно подпереть."))
				return
		if(RWINDOW_BOLTS_OUT)
			if(I.tool_behaviour == TOOL_CROWBAR)
				user.visible_message(span_notice("[user] вставляет [skloname(I.name, VINITELNI, I.gender)] в щель и начинает подпирать окно...") ,
										span_notice("Вставляю [skloname(I.name, VINITELNI, I.gender)] в щель и начинаю подпирать окно..."))
				if(I.use_tool(src, user, 50, volume = 50))
					state = RWINDOW_POPPED
					to_chat(user, span_notice("Основная плита вышла из рамки и стали видны прутья, которые можно откусить."))
				return
		if(RWINDOW_POPPED)
			if(I.tool_behaviour == TOOL_WIRECUTTER)
				user.visible_message(span_notice("[user] начинает откусывать доступные прутья [skloname(src.name, VINITELNI, src.gender)]...") ,
										span_notice("Начинаю откусывать доступные прутья [skloname(src.name, VINITELNI, src.gender)]..."))
				if(I.use_tool(src, user, 30, volume = 50))
					state = RWINDOW_BARS_CUT
					to_chat(user, span_notice("Основная плита отделена от рамки и теперь её удерживает только несколько болтов."))
				return
		if(RWINDOW_BARS_CUT)
			if(I.tool_behaviour == TOOL_WRENCH)
				user.visible_message(span_notice("[user] начинает откручивать [skloname(src.name, VINITELNI, src.gender)] от рамки...") ,
					span_notice("Начинаю откручивать болты..."))
				if(I.use_tool(src, user, 50, volume = 50))
					to_chat(user, span_notice("Снимаю окно с болтов и теперь оно может быть свободно перемещено."))
					state = WINDOW_OUT_OF_FRAME
					set_anchored(FALSE)
				return
	return ..()

/obj/structure/window/proc/cool_bolts()
	if(state == RWINDOW_BOLTS_HEATED)
		state = RWINDOW_SECURE
		visible_message(span_notice("Винтики в [skloname(src.name, DATELNI, src.gender)] выглядят остывшими..."))

/obj/structure/window/reinforced/examine(mob/user)
	. = ..()
	switch(state)
		if(RWINDOW_SECURE)
			. += span_notice("Окно прикручено одноразовыми винтами. Придётся <b>нагреть их</b>, чтобы получить хоть какой-то шанс выкрутить их обратно.")
		if(RWINDOW_BOLTS_HEATED)
			. += span_notice("Винтики раскалены до бела, похоже можно <b>открутить их</b> прямо сейчас.")
		if(RWINDOW_BOLTS_OUT)
			. += span_notice("Винтики удалены и теперь окно можно <b>подпереть</b> сквозь доступную щель.")
		if(RWINDOW_POPPED)
			. += span_notice("Основная плита вышла из рамки и стали видны прутья, которые можно <b>откусить</b>.")
		if(RWINDOW_BARS_CUT)
			. += span_notice("Основная плита отделена от рамки и теперь её удерживает только несколько <b>болтов</b>.")

/obj/structure/window/reinforced/spawner/east
	dir = EAST

/obj/structure/window/reinforced/spawner/west
	dir = WEST

/obj/structure/window/reinforced/spawner/north
	dir = NORTH

/obj/structure/window/reinforced/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/plasma
	name = "окно из плазмы"
	desc = "Окно из плазменно-силикатного сплава. Выглядит безумно сложным для ломания и прожигания."
	icon_state = "plasmawindow"
	reinf = FALSE
	heat_resistance = 25000
	armor = list(MELEE = 80, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 45, BIO = 100, RAD = 100, FIRE = 99, ACID = 100)
	max_integrity = 200
	explosion_block = 1
	glass_type = /obj/item/stack/sheet/plasmaglass
	rad_insulation = RAD_NO_INSULATION

/obj/structure/window/plasma/ComponentInitialize()
	. = ..()
	RemoveElement(/datum/element/atmos_sensitive)

/obj/structure/window/plasma/spawnDebris(location)
	. = list()
	. += new /obj/item/shard/plasma(location)
	. += new /obj/effect/decal/cleanable/glass/plasma(location)
	if (reinf)
		. += new /obj/item/stack/rods(location, (fulltile ? 2 : 1))
	if (fulltile)
		. += new /obj/item/shard/plasma(location)

/obj/structure/window/plasma/spawner/east
	dir = EAST

/obj/structure/window/plasma/spawner/west
	dir = WEST

/obj/structure/window/plasma/spawner/north
	dir = NORTH

/obj/structure/window/plasma/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced
	name = "армированное окно из плазмы"
	desc = "Окно из плазменно-силикатного сплава и стержневой матрицы. Он выглядит безнадежно жестким для разрушения и, скорее всего, почти пожаробезопасным."
	icon_state = "plasmarwindow"
	reinf = TRUE
	heat_resistance = 50000
	armor = list(MELEE = 80, BULLET = 20, LASER = 0, ENERGY = 0, BOMB = 60, BIO = 100, RAD = 100, FIRE = 99, ACID = 100)
	max_integrity = 500
	damage_deflection = 21
	explosion_block = 2
	glass_type = /obj/item/stack/sheet/plasmarglass

/obj/structure/window/plasma/reinforced/block_superconductivity()
	return TRUE

//entirely copypasted code
//take this out when construction is made a component or otherwise modularized in some way
/obj/structure/window/plasma/reinforced/attackby(obj/item/I, mob/living/user, params)
	switch(state)
		if(RWINDOW_SECURE)
			if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HARM)
				user.visible_message(span_notice("[user] направляет [skloname(I.name, VINITELNI, I.gender)] на защищённые винтики [skloname(src.name, VINITELNI, src.gender)]...") ,
										span_notice("Начинаю нагревать винтики [skloname(src.name, VINITELNI, src.gender)]..."))
				if(I.use_tool(src, user, 180, volume = 100))
					to_chat(user, span_notice("Винтики раскалены до бела, похоже можно открутить их прямо сейчас."))
					state = RWINDOW_BOLTS_HEATED
					addtimer(CALLBACK(src, PROC_REF(cool_bolts)), 300)
				return
		if(RWINDOW_BOLTS_HEATED)
			if(I.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user] втыкает отвёртку в раскалённые винтики и начинает их выкручивать...") ,
										span_notice("Втыкаю отвёртку в раскалённые винтики и начинаю их выкручивать..."))
				if(I.use_tool(src, user, 80, volume = 50))
					state = RWINDOW_BOLTS_OUT
					to_chat(user, span_notice("Винтики удалены и теперь окно можно подпереть."))
				return
		if(RWINDOW_BOLTS_OUT)
			if(I.tool_behaviour == TOOL_CROWBAR)
				user.visible_message(span_notice("[user] вставляет [skloname(I.name, VINITELNI, I.gender)] в щель и начинает подпирать окно...") ,
										span_notice("Вставляю [skloname(I.name, VINITELNI, I.gender)] в щель и начинаю подпирать окно..."))
				if(I.use_tool(src, user, 50, volume = 50))
					state = RWINDOW_POPPED
					to_chat(user, span_notice("Основная плита вышла из рамки и стали видны прутья, которые можно откусить."))
				return
		if(RWINDOW_POPPED)
			if(I.tool_behaviour == TOOL_WIRECUTTER)
				user.visible_message(span_notice("[user] начинает откусывать доступные прутья [skloname(src.name, VINITELNI, src.gender)]...") ,
										span_notice("Начинаю откусывать доступные прутья [skloname(src.name, VINITELNI, src.gender)]..."))
				if(I.use_tool(src, user, 30, volume = 50))
					state = RWINDOW_BARS_CUT
					to_chat(user, span_notice("Основная плита отделена от рамки и теперь её удерживает только несколько болтов."))
				return
		if(RWINDOW_BARS_CUT)
			if(I.tool_behaviour == TOOL_WRENCH)
				user.visible_message(span_notice("[user] начинает откручивать [skloname(src.name, VINITELNI, src.gender)] от рамки...") ,
					span_notice("Начинаю откручивать болты..."))
				if(I.use_tool(src, user, 50, volume = 50))
					to_chat(user, span_notice("Снимаю окно с болтов и теперь оно может быть свободно перемещено."))
					state = WINDOW_OUT_OF_FRAME
					set_anchored(FALSE)
				return
	return ..()

/obj/structure/window/plasma/reinforced/examine(mob/user)
	. = ..()
	switch(state)
		if(RWINDOW_SECURE)
			. += "<hr><span class='notice'>Окно прикручено одноразовыми винтами. Придётся <b>нагреть их</b>, чтобы получить хоть какой-то шанс выкрутить их обратно.</span>"
		if(RWINDOW_BOLTS_HEATED)
			. += "<hr><span class='notice'>Винтики раскалены до бела, похоже можно <b>открутить их</b> прямо сейчас.</span>"
		if(RWINDOW_BOLTS_OUT)
			. += "<hr><span class='notice'>Винтики удалены и теперь окно можно <b>подпереть</b> сквозь доступную щель.</span>"
		if(RWINDOW_POPPED)
			. += "<hr><span class='notice'>Основная плита вышла из рамки и стали видны прутья, которые можно <b>откусить</b>.</span>"
		if(RWINDOW_BARS_CUT)
			. += "<hr><span class='notice'>Основная плита отделена от рамки и теперь её удерживает только несколько <b>болтов</b>.</span>"

/obj/structure/window/plasma/reinforced/spawner/east
	dir = EAST

/obj/structure/window/plasma/reinforced/spawner/west
	dir = WEST

/obj/structure/window/plasma/reinforced/spawner/north
	dir = NORTH

/obj/structure/window/plasma/reinforced/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	icon_state = "twindow"
	opacity = TRUE
/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	icon_state = "fwindow"

/* Full Tile Windows (more obj_integrity) */

/obj/structure/window/fulltile
	icon = 'white/valtos/icons/window_glass.dmi'
	icon_state = "window_glass-0"
	base_icon_state = "window_glass"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 50
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS)
	glass_amount = 2

/obj/structure/window/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/plasma/fulltile
	icon = 'icons/obj/smooth_structures/plasma_window.dmi'
	icon_state = "plasma_window-0"
	base_icon_state = "plasma_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 300
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS)
	glass_amount = 2

/obj/structure/window/plasma/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced/fulltile
	icon = 'white/valtos/icons/window_rplasma.dmi'
	icon_state = "window_rplasma-0"
	base_icon_state = "window_rplasma"
	dir = FULLTILE_WINDOW_DIR
	state = RWINDOW_SECURE
	max_integrity = 1000
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS)
	glass_amount = 2

/obj/structure/window/plasma/reinforced/fulltile/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/fulltile
	icon = DEFAULT_RWINDOW_ICON
	icon_state = "window_rglass-0"
	base_icon_state = "window_rglass"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 150
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	state = RWINDOW_SECURE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS)
	glass_amount = 2

/obj/structure/window/reinforced/fulltile/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/tinted/fulltile
	icon = 'icons/obj/smooth_structures/tinted_window.dmi'
	icon_state = "tinted_window-0"
	base_icon_state = "tinted_window"
	dir = FULLTILE_WINDOW_DIR
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	glass_amount = 2

/obj/structure/window/reinforced/fulltile/ice
	icon = 'icons/obj/smooth_structures/rice_window.dmi'
	icon_state = "rice_window-0"
	base_icon_state = "rice_window"
	max_integrity = 150
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	glass_amount = 2

/obj/structure/window/shuttle
	name = "окно шаттла"
	desc = "Усиленное герметичное окно кабины."
	icon = 'icons/obj/smooth_structures/shuttle_window.dmi'
	icon_state = "shuttle_window-0"
	base_icon_state = "shuttle_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 150
	wtype = "shuttle"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	reinf = TRUE
	heat_resistance = 1600
	armor = list(MELEE = 90, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 100)
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	explosion_block = 3
	glass_type = /obj/item/stack/sheet/titaniumglass
	glass_amount = 2
	receive_ricochet_chance_mod = 1.2

/obj/structure/window/shuttle/narsie_act()
	add_atom_colour("#3C3434", FIXED_COLOUR_PRIORITY)

/obj/structure/window/shuttle/tinted
	opacity = TRUE

/obj/structure/window/shuttle/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced/plastitanium
	name = "пластитановое окно"
	desc = "Прочное окно из сплава плазмы и титана."
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 1200
	wtype = "shuttle"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	heat_resistance = 1600
	armor = list(MELEE = 95, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 100)
	smoothing_flags = SMOOTH_BITMASK
//	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
//	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	explosion_block = 3
	damage_deflection = 21 //The same as reinforced plasma windows.3
	glass_type = /obj/item/stack/sheet/plastitaniumglass
	glass_amount = 2
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/window/plasma/reinforced/plastitanium/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/paperframe
	name = "бумажная рамка"
	desc = "Хрупкий разделитель из тонкого дерева и бумаги."
	icon = 'icons/obj/smooth_structures/paperframes.dmi'
	icon_state = "paperframes-0"
	base_icon_state = "paperframes"
	dir = FULLTILE_WINDOW_DIR
	opacity = TRUE
	max_integrity = 15
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_PAPERFRAME)
	canSmoothWith = list(SMOOTH_GROUP_PAPERFRAME)
	glass_amount = 2
	glass_type = /obj/item/stack/sheet/paperframes
	heat_resistance = 233
	decon_speed = 10
	can_atmos_pass = ATMOS_PASS_YES
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	knocksound = "pageturn"
	bashsound = 'sound/weapons/slashmiss.ogg'
	breaksound = 'sound/items/poster_ripped.ogg'
	hitsound = 'sound/weapons/slashmiss.ogg'
	var/static/mutable_appearance/torn = mutable_appearance('icons/obj/smooth_structures/paperframes.dmi',icon_state = "torn", layer = ABOVE_OBJ_LAYER - 0.1)
	var/static/mutable_appearance/paper = mutable_appearance('icons/obj/smooth_structures/paperframes.dmi',icon_state = "paper", layer = ABOVE_OBJ_LAYER - 0.1)

/obj/structure/window/paperframe/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/window/paperframe/examine(mob/user)
	. = ..()
	if(obj_integrity < max_integrity)
		. += "<hr><span class='info'>Он выглядит немного поврежденным, можно исправить его с помощью <b>бумаги</b>.</span>"

/obj/structure/window/paperframe/spawnDebris(location)
	. = list(new /obj/item/stack/sheet/mineral/wood(location))
	for (var/i in 1 to rand(1,4))
		. += new /obj/item/paper/natural(location)

/obj/structure/window/paperframe/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(user.a_intent == INTENT_HARM)
		take_damage(4,BRUTE,MELEE, 0)
		if(!QDELETED(src))
			update_icon()

/obj/structure/window/paperframe/update_icon(updates = ALL)
	. = ..()
	if(obj_integrity < max_integrity)
		cut_overlay(paper)
		add_overlay(torn)
		set_opacity(FALSE)
	else
		cut_overlay(torn)
		add_overlay(paper)
		set_opacity(TRUE)
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)


/obj/structure/window/paperframe/attackby(obj/item/W, mob/user)
	if(W.get_temperature())
		fire_act(W.get_temperature())
		return
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(W, /obj/item/paper) && obj_integrity < max_integrity)
		user.visible_message(span_notice("[user] начинает заделывать щели в [src]."))
		if(do_after(user, 20, target = src))
			obj_integrity = min(obj_integrity+4,max_integrity)
			qdel(W)
			user.visible_message(span_notice("[user] заделывает некоторые щели в [src]."))
			if(obj_integrity == max_integrity)
				update_icon()
			return
	..()
	update_icon()

/obj/structure/window/bronze
	name = "латунное окно"
	desc = "Тонкая, как бумага, панель из полупрозрачной, но усиленной латуни. Да ладно, это слабая латунь!"
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window_single"
	glass_type = /obj/item/stack/tile/bronze

/obj/structure/window/bronze/unanchored
	anchored = FALSE

/obj/structure/window/bronze/fulltile
	icon_state = "clockwork_window-0"
	base_icon_state = "clockwork_window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE)
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 50
	glass_amount = 2

/obj/structure/window/bronze/fulltile/unanchored
	anchored = FALSE
