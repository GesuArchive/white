/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	max_integrity = 200
	integrity_failure = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 40, ACID = 20)
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON|INTERACT_MACHINE_SET_MACHINE|INTERACT_MACHINE_REQUIRES_LITERACY
	var/brightness_on = 1
	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/time_to_screwdrive = 20
	var/authenticated = 0
	var/clued = FALSE

/obj/machinery/computer/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()

	AddElement(/datum/element/climbable)
	power_change()

/obj/machinery/computer/Destroy()
	. = ..()

/obj/machinery/computer/process()
	if(machine_stat & (NOPOWER|BROKEN))
		return FALSE
	if(clued)
		for(var/mob/living/carbon/human/H as anything in view(7, get_turf(src)))
			if(!ishuman(H))
				continue
			var/obj/item/organ/heart/heart = H.get_organ_slot(ORGAN_SLOT_HEART)
			if(IS_DREAMER(H) || heart?.key_for_dreamer)
				continue
			interact(H)
	return TRUE

/obj/machinery/computer/update_overlays()
	. = ..()
	if(icon_keyboard)
		if(machine_stat & NOPOWER)
			. += "[icon_keyboard]_off"
		else
			. += icon_keyboard

	// This whole block lets screens ignore lighting and be visible even in the darkest room
	if(machine_stat & BROKEN)
		. += mutable_appearance(icon, "[icon_state]_broken")
		return // If we don't do this broken computers glow in the dark.

	if(machine_stat & NOPOWER) // Your screen can't be on if you've got no damn charge
		return

	. += mutable_appearance(icon, icon_screen)
	. += emissive_appearance(icon, icon_screen, src)

/obj/machinery/computer/power_change()
	. = ..()
	if(machine_stat & NOPOWER)
		set_light(0)
	else
		set_light(brightness_on)

/obj/machinery/computer/screwdriver_act(mob/living/user, obj/item/I)
	if(clued)
		if(!IS_DREAMER(user))
			return FALSE
		to_chat(user, span_notice("Убираю ШЕДЕВР..."))
		for(var/obj/item/fuck in src)
			fuck.forceMove(drop_location())
		cut_overlays()
		clued = FALSE
		icon_screen = initial(icon_screen)
		update_icon()
		interaction_flags_atom |= INTERACT_ATOM_UI_INTERACT
		return TRUE
	if(..())
		return TRUE
	if(circuit && !(flags_1&NODECONSTRUCT_1))
		to_chat(user, span_notice("You start to disconnect the monitor..."))
		if(I.use_tool(src, user, time_to_screwdrive, volume=50))
			deconstruct(TRUE, user)
	return TRUE

/obj/machinery/computer/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(machine_stat & BROKEN)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
			else
				playsound(src.loc, 'sound/effects/glasshit.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/machinery/computer/obj_break(damage_flag)
	if(!circuit) //no circuit, no breaking
		return
	. = ..()
	if(.)
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)
		set_light(0)

/obj/machinery/computer/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		switch(severity)
			if(1)
				if(prob(50))
					obj_break(ENERGY)
			if(2)
				if(prob(10))
					obj_break(ENERGY)

/obj/machinery/computer/deconstruct(disassembled = TRUE, mob/user)
	on_deconstruction()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(circuit) //no circuit, no computer frame
			var/obj/structure/frame/computer/A = new /obj/structure/frame/computer(src.loc)
			A.setDir(dir)
			A.circuit = circuit
			// Circuit removal code is handled in /obj/machinery/Exited()
			circuit.forceMove(A)
			A.set_anchored(TRUE)
			if(machine_stat & BROKEN)
				if(user)
					to_chat(user, span_notice("The broken glass falls out."))
				else
					playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
				new /obj/item/shard(drop_location())
				new /obj/item/shard(drop_location())
				A.state = 3
				A.icon_state = "3"
			else
				if(user)
					to_chat(user, span_notice("You disconnect the monitor."))
				A.state = 4
				A.icon_state = "4"
		for(var/obj/C in src)
			C.forceMove(loc)
	qdel(src)

/obj/machinery/computer/can_interact(mob/user)
	if(clued && ishuman(user) && !IS_DREAMER(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/heart/heart = H.get_organ_slot(ORGAN_SLOT_HEART)
		if(heart?.key_for_dreamer)
			return FALSE
		H.visible_message(span_danger("[H] пялится в экран [src.name] с отвращением!"), span_danger("ЧТО ЭТО ТАКОЕ?!"))
		H.pointed(src)
		new /obj/effect/particle_effect/sparks(loc)
		playsound(src, "zap", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "dreamer", /datum/mood_event/seen_dream, clued)
		return FALSE
	if(..())
		return TRUE

/obj/machinery/computer/AltClick(mob/user)
	. = ..()
	if((IS_DREAMER(user) && !clued))
		if(!user.CanReach(src))
			return
		var/list/temp_list = list()
		temp_list += GLOB.dreamer_current_recipe
		var/list/get_list = list()
		for(var/atom/movable/AM in range(1, src))
			for(var/t_type in GLOB.dreamer_current_recipe)
				if(istype(AM, t_type))
					temp_list -= t_type
					get_list += AM
		if(temp_list.len)
			var/list/req_list = list()
			for(var/itype in temp_list)
				var/obj/item/req = new itype
				req_list += req.name
				qdel(req)
			to_chat(user, span_revenbignotice("Для этого шедевра потребуется [english_list(req_list)]. Пока есть только [english_list(get_list)]"))
			return
		for(var/i in 1 to 10)
			new /obj/effect/particle_effect/sparks(loc)
			playsound(src, "zap", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
			if(!do_after(user, (rand(9, 15)), target = src))
				return
		clued = tgui_input_list(user, "ВЫБЕРЕМ ЖЕ ШЕДЕВР", "ШЕДЕВР", GLOB.dreamer_clues)
		if(!clued)
			return
		GLOB.dreamer_current_recipe = get_random_organ_list(5)
		for(var/obj/item/I in get_list)
			I.forceMove(src)
			var/mutable_appearance/wish = mutable_appearance(I.icon, I.icon_state, layer + 0.01)
			wish.pixel_x = rand(-16, 16)
			wish.pixel_y = pick(-16, 16)
			add_overlay(wish)
		var/icon/blood_splatter_icon = icon(icon, icon_state, dir, 1)
		blood_splatter_icon.Blend("#fff", ICON_ADD)
		blood_splatter_icon.Blend(icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY)
		add_overlay(blood_splatter_icon)
		to_chat(user, span_revenbignotice("[clued]... ЭТОТ ШЕДЕВР ДОЛЖНЫ УЗРЕТЬ!"))
		icon_screen = "clued"
		update_icon()
		tgui_id = "DreamerCorruption"
		interaction_flags_atom &= ~INTERACT_ATOM_UI_INTERACT
		return
	if(!user.canUseTopic(src, !issilicon(user)) || !is_operational)
		return

/obj/machinery/computer/examine(mob/user)
	. = ..()
	if(IS_DREAMER(user))
		. += "<hr>"
		if(clued)
			. += span_revenbignotice("Чудо [clued]!")
		else
			. += span_revenbignotice("СПРАВА есть АЛЬТЕРНАТИВНЫЙ секрет.")
	else if (clued)
		interact(user)

/obj/machinery/computer/interact(mob/user, special_state)
	if(clued)
		var/datum/tgui/ui = new(user, src, "DreamerCorruption", IS_DREAMER(user) ? "ШЕДЕВР" : "УЖАС! УЖАС! УЖАС!")
		ui.open()
	. = ..()

/obj/machinery/computer/ui_interact(mob/user, datum/tgui/ui)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	update_use_power(ACTIVE_POWER_USE)

/obj/machinery/computer/ui_close(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	update_use_power(IDLE_POWER_USE)
