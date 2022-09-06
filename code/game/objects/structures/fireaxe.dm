/obj/structure/fireaxecabinet
	name = "шкаф для пожарного топора"
	desc = "Есть небольшая этикетка, которая гласит \"Только для экстренного использования\" вместе с деталями для безопасного использования топора. Будто кто-то будет использовать его по назначению."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 50, BULLET = 20, LASER = 0, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 90, ACID = 50)
	max_integrity = 150
	integrity_failure = 0.33
	var/locked = TRUE
	var/open = FALSE
	var/obj/item/fireaxe/fireaxe

/obj/structure/fireaxecabinet/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/structure/fireaxecabinet/directional/south
	dir = NORTH
	pixel_y = -32

/obj/structure/fireaxecabinet/directional/east
	dir = WEST
	pixel_x = 32

/obj/structure/fireaxecabinet/directional/west
	dir = EAST
	pixel_x = -32

/obj/structure/fireaxecabinet/Initialize(mapload)
	. = ..()
	fireaxe = new
	update_icon()

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		QDEL_NULL(fireaxe)
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/I, mob/user, params)
	if(iscyborg(user) || I.tool_behaviour == TOOL_MULTITOOL)
		toggle_lock(user)
	else if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP && !broken)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return

			to_chat(user, span_notice("Начинаю чинить [src]."))
			if(I.use_tool(src, user, 40, volume=50, amount=2))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, span_notice("Чиню [src]."))
		else
			to_chat(user, span_warning("[capitalize(src.name)] сейчас в хорошем состоянии!"))
		return
	else if(istype(I, /obj/item/stack/sheet/glass) && broken)
		var/obj/item/stack/sheet/glass/G = I
		if(G.get_amount() < 2)
			to_chat(user, span_warning("Вам нужно два листа стекла, чтобы починить [src]!"))
			return
		to_chat(user, span_notice("Начинаю чинить [src]..."))
		if(do_after(user, 20, target = src) && G.use(2))
			broken = FALSE
			obj_integrity = max_integrity
			update_icon()
	else if(open || broken)
		if(istype(I, /obj/item/fireaxe) && !fireaxe)
			var/obj/item/fireaxe/F = I
			if(F?.wielded)
				to_chat(user, span_warning("Для начала разварите [F.name] ."))
				return
			if(!user.transferItemToLoc(F, src))
				return
			fireaxe = F
			to_chat(user, span_notice("Кладу [F.name] обратно в [name]."))
			update_icon()
			return
		else if(!broken)
			toggle_open()
	else
		return ..()

/obj/structure/fireaxecabinet/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(broken)
				playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 90, TRUE)
			else
				playsound(loc, 'sound/effects/glasshit.ogg', 90, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/fireaxecabinet/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir)
	if(open)
		return
	. = ..()
	if(.)
		update_icon()

/obj/structure/fireaxecabinet/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		update_icon()
		broken = TRUE
		playsound(src, 'sound/effects/glassbr3.ogg', 100, TRUE)
		new /obj/item/shard(loc)
		new /obj/item/shard(loc)

/obj/structure/fireaxecabinet/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(fireaxe && loc)
			fireaxe.forceMove(loc)
			fireaxe = null
		new /obj/item/stack/sheet/iron(loc, 2)
	qdel(src)

/obj/structure/fireaxecabinet/blob_act(obj/structure/blob/B)
	if(fireaxe)
		fireaxe.forceMove(loc)
		fireaxe = null
	qdel(src)

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(open || broken)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(user, span_notice("Вы берете пожарный топор из [name]."))
			src.add_fingerprint(user)
			update_icon()
			return
	if(locked)
		to_chat(user, span_warning(" [name] не хочет двигаться!"))
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/fireaxecabinet/attack_ai(mob/user)
	toggle_lock(user)
	return


/obj/structure/fireaxecabinet/attack_tk(mob/user)
	. = COMPONENT_CANCEL_ATTACK_CHAIN
	if(locked)
		to_chat(user, span_warning(" [name] не собирается двигаться!"))
		return
	open = !open
	update_icon()


/obj/structure/fireaxecabinet/update_overlays()
	. = ..()
	if(fireaxe)
		. += "axe"
	if(!open)
		var/hp_percent = obj_integrity/max_integrity * 100
		if(broken)
			. += "glass4"
		else
			switch(hp_percent)
				if(-INFINITY to 40)
					. += "glass3"
				if(40 to 60)
					. += "glass2"
				if(60 to 80)
					. += "glass1"
				if(80 to INFINITY)
					. += "glass"
		if(locked)
			. += "locked"
		else
			. += "unlocked"
	else
		. += "glass_raised"

/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)
	to_chat(user, span_notice("Сброс схем..."))
	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)
	if(do_after(user, 20, target = src))
		to_chat(user, span_notice("[locked ? "выключаю" : "перезапускаю"] блокирующие модули."))
		locked = !locked
		update_icon()

/obj/structure/fireaxecabinet/verb/toggle_open()
	set name = "Open/Close"
	set category = "Объект"
	set src in oview(1)

	if(locked)
		to_chat(usr, span_warning(" [name] двигаться не собирается!"))
		return
	else
		open = !open
		update_icon()
		return
