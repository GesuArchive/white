/obj/structure/toilet
	name = "туалет"
	desc = "HT-451 - устройство для удаления мелких отходов, работающее на основе крутящего момента. Этот кажется на удивление чистым."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	var/open = FALSE			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie
	var/buildstacktype = /obj/item/stack/sheet/iron //they're iron now, shut up
	var/buildstackamount = 1

/obj/structure/toilet/Initialize(mapload)
	. = ..()
	open = round(rand(0, 1))
	update_icon()
	if(!reagents)
		create_reagents(500, OPENCONTAINER)

/obj/structure/toilet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(swirlie)
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src.loc, "swing_hit", 25, TRUE)
		swirlie.visible_message(span_danger("[user] бьет туалетной крышкой об голову [swirlie]!") , span_userdanger("[user] бьет мою голову крышкой унитаза!") , span_hear("Слышу звон фарфора."))
		log_combat(user, swirlie, "swirlied (brute)")
		swirlie.adjustBruteLoss(5)

	else if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		user.changeNext_move(CLICK_CD_MELEE)
		var/mob/living/GM = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(GM.loc != get_turf(src))
				to_chat(user, span_warning("Надо бы подтащить [GM] поближе к унитазу!"))
				return
			if(!swirlie)
				if(open)
					GM.visible_message(span_danger("[user] начинает запихивать голову [GM] в сартир!") , span_userdanger("[user] пытается утопить меня в сартире..."))
					swirlie = GM
					var/was_alive = (swirlie.stat != DEAD)
					if(do_after(user, 3 SECONDS, target = src, timed_action_flags = IGNORE_HELD_ITEM))
						GM.visible_message(span_danger("[user] нажимает кнопку слива! [GM] булькает!") , span_userdanger("[user] нажал кнопку смыва! ВОДА!") , span_hear("Слышу звук смываемой воды."))
						if(iscarbon(GM))
							var/mob/living/carbon/C = GM
							if(!C.internal)
								log_combat(user, C, "swirlied (oxy)")
								C.adjustOxyLoss(5)
						else
							log_combat(user, GM, "swirlied (oxy)")
							GM.adjustOxyLoss(5)
					if(was_alive && swirlie.stat == DEAD && swirlie.client)
						swirlie.client.give_award(/datum/award/achievement/misc/swirlie, swirlie) // just like space high school all over again!
					swirlie = null
				else
					playsound(src.loc, 'sound/effects/bang.ogg', 25, TRUE)
					GM.visible_message(span_danger("[user] вмазывает [GM.name] об [src]!") , span_userdanger("[user] ударяет меня об [src]!"))
					log_combat(user, GM, "toilet slammed")
					GM.adjustBruteLoss(5)
		else
			to_chat(user, span_warning("Вырывается! Надо схватить сильнее!"))

	else if(cistern && !open && user.CanReach(src))
		if(!contents.len)
			to_chat(user, span_notice("Бачок для воды пуст."))
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(drop_location())
			to_chat(user, span_notice("Внутри бачка для воды лежит [I]."))
			w_items -= I.w_class
	else
		open = !open
		update_icon()


/obj/structure/toilet/update_icon_state()
	. = ..()
	icon_state = "toilet[open][cistern]"

/obj/structure/toilet/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
		else
			for(var/i in custom_materials)
				var/datum/material/M = i
				new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))
	..()

/obj/structure/toilet/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)
	if(I.tool_behaviour == TOOL_CROWBAR)
		to_chat(user, span_notice("Начинаю [cistern ? "закрывать бачок туалета" : "открывать бачок туалета"]..."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
		if(I.use_tool(src, user, 30))
			user.visible_message(span_notice("[user] [cistern ? "закрывает бачок туалета" : "открывает бачок туалета"]!") , span_notice("[cistern ? "закрываю бачок туалета" : "открываю бачок туалета"]!") , span_hear("Слышу звук фарфора."))
			cistern = !cistern
			update_icon()
		return TRUE
	else if(I.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		I.play_tool_sound(src)
		deconstruct()
		return TRUE
	else if(cistern)
		if(user.a_intent != INTENT_HARM)
			if(I.w_class > WEIGHT_CLASS_NORMAL)
				to_chat(user, span_warning("[I] не помещается!"))
				return
			if(w_items + I.w_class > WEIGHT_CLASS_HUGE)
				to_chat(user, span_warning("Нет места!"))
				return
			if(!user.transferItemToLoc(I, src))
				to_chat(user, span_warning("<b>[capitalize(I)]</b> прилипла к руке!"))
				return
			w_items += I.w_class
			to_chat(user, span_notice("Аккуратно запихиваю [I] внутрь бачка туалета."))
		return TRUE

	else if (istype(I, /obj/item/melee/ersh))
		if(!open)
			return
		user.visible_message(span_notice("<b>[user]</b> элегантно чистит <b>[src.name]</b>.") ,
			span_notice("Элегантно чищу <b>[src.name]</b>.") , span_hear("Слышу как что-то ёрзает."))
		return TRUE

	else if (istype(I, /obj/item/kitchen/fork))
		if(!open)
			return
		user.visible_message(span_warning("<b>[user]</b> шкрябает <b>парашу</b> вилкой.") ,
			span_userdanger("Шкрябаю парашу вилкой.") , span_hear("Слышу как кто-то скребёт вилкой по чему-то твёрдому."))
		inc_metabalance(user, -1, reason="Не хочу я работать...")
		playsound(get_turf(src), 'white/valtos/sounds/vilka.ogg', 80, TRUE)
		return TRUE

	else if(istype(I, /obj/item/reagent_containers))
		if (!open)
			return
		if(istype(I, /obj/item/food/monkeycube))
			var/obj/item/food/monkeycube/cube = I
			cube.Expand()
			return
		var/obj/item/reagent_containers/RG = I
		reagents.trans_to(RG, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		to_chat(user, span_notice("Наполняю [RG] из туалета. Отвратительно..."))
		return TRUE
	. = ..()

/obj/structure/toilet/secret
	var/obj/item/secret
	var/secret_type = null

/obj/structure/toilet/secret/Initialize(mapload)
	. = ..()
	if (secret_type)
		secret = new secret_type(src)
		secret.desc += " It's a secret!"
		w_items += secret.w_class
		contents += secret

/obj/structure/toilet/greyscale
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstacktype = null

/obj/structure/urinal
	name = "писуар"
	desc = "Экспериментальный писуар ХУ-452. Поставляется в комплекте с набором туалетных таблеток."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	var/exposed = 0 // can you currently put an item inside
	var/obj/item/hiddenitem = null // what's in the urinal

/obj/structure/urinal/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/structure/urinal/directional/south
	dir = NORTH
	pixel_y = -32

/obj/structure/urinal/directional/east
	dir = WEST
	pixel_x = 32

/obj/structure/urinal/directional/west
	dir = EAST
	pixel_x = -32

/obj/structure/urinal/Initialize(mapload)
	. = ..()
	hiddenitem = new /obj/item/food/urinalcake

/obj/structure/urinal/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		var/mob/living/GM = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(GM.loc != get_turf(src))
				to_chat(user, span_notice("[GM.name] needs to be on [src]."))
				return
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message(span_danger("[user] slams [GM] into [src]!") , span_danger("You slam [GM] into [src]!"))
			GM.adjustBruteLoss(8)
		else
			to_chat(user, span_warning("You need a tighter grip!"))

	else if(exposed)
		if(!hiddenitem)
			to_chat(user, span_warning("There is nothing in the drain holder!"))
		else
			if(ishuman(user))
				user.put_in_hands(hiddenitem)
			else
				hiddenitem.forceMove(get_turf(src))
			to_chat(user, span_notice("You fish [hiddenitem] out of the drain enclosure."))
			hiddenitem = null
	else
		..()

/obj/structure/urinal/attackby(obj/item/I, mob/living/user, params)
	if(exposed)
		if (hiddenitem)
			to_chat(user, span_warning("There is already something in the drain enclosure!"))
			return
		if(I.w_class > 1)
			to_chat(user, span_warning("[I] is too large for the drain enclosure."))
			return
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("\[I] is stuck to your hand, you cannot put it in the drain enclosure!"))
			return
		hiddenitem = I
		to_chat(user, span_notice("You place [I] into the drain enclosure."))
	else
		return ..()

/obj/structure/urinal/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	to_chat(user, span_notice("You start to [exposed ? "screw the cap back into place" : "unscrew the cap to the drain protector"]..."))
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
	if(I.use_tool(src, user, 20))
		user.visible_message(span_notice("[user] [exposed ? "screws the cap back into place" : "unscrew the cap to the drain protector"]!") ,
			span_notice("You [exposed ? "screw the cap back into place" : "unscrew the cap on the drain"]!") ,
			span_hear("You hear metal and squishing noises."))
		exposed = !exposed
	return TRUE


/obj/item/food/urinalcake
	name = "таблетка для туалета"
	desc = "Таблетка с ароматизатором для туалета, защищающая трубы станции от мочи. Не ешьте это. Пожалуйста."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/chlorine = 3, /datum/reagent/ammonia = 1)
	foodtypes = TOXIC | GROSS
	preserved_food = TRUE

/obj/item/food/urinalcake/attack_self(mob/living/user)
	user.visible_message(span_notice("[user] squishes [src]!") , span_notice("You squish [src].") , "<i>You hear a squish.</i>")
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 8)

/obj/item/bikehorn/rubberducky/plasticducky
	name = "пластиковая уточка"
	desc = "Дешевая пластиковая подделка вашей любимой игрушки для ванны."
	custom_materials = list(/datum/material/plastic = 1000)

/obj/item/bikehorn/rubberducky
	name = "резиновая уточка"
	desc = "Резиновая уточка, такая милая! С ней так весело купаааааться. Я всегда тебя найдууу!!!"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	inhand_icon_state = "rubberducky"
	worn_icon_state = "duck"

/obj/structure/sink
	name = "умывальник"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face. Passively reclaims water over time."
	anchored = TRUE
	pixel_z = 1
	///Something's being washed at the moment
	var/busy = FALSE
	///What kind of reagent is produced by this sink by default? (We now have actual plumbing, Arcane, August 2020)
	var/dispensedreagent = /datum/reagent/water
	///Material to drop when broken or deconstructed.
	var/buildstacktype = /obj/item/stack/sheet/iron
	///Number of sheets of material to drop when broken or deconstructed.
	var/buildstackamount = 1
	///Does the sink have a water recycler to recollect it's water supply?
	var/has_water_reclaimer = TRUE
	///Units of water to reclaim per second
	var/reclaim_rate = 0.5
	///Amount of shift the pixel for placement
	var/pixel_shift = 14

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sink, (-14))

/obj/structure/sink/Initialize(mapload, ndir = 0, has_water_reclaimer = null)
	. = ..()

	if(ndir)
		dir = ndir

	if(has_water_reclaimer != null)
		src.has_water_reclaimer = has_water_reclaimer

	switch(dir)
		if(NORTH)
			pixel_x = 0
			pixel_y = -pixel_shift
		if(SOUTH)
			pixel_x = 0
			pixel_y = pixel_shift
		if(EAST)
			pixel_x = -pixel_shift
			pixel_y = 0
		if(WEST)
			pixel_x = pixel_shift
			pixel_y = 0

	create_reagents(100, NO_REACT)
	if(src.has_water_reclaimer)
		reagents.add_reagent(dispensedreagent, 100)
	AddComponent(/datum/component/plumbing/simple_demand, extend_pipe_to_edge = TRUE)

/obj/structure/sink/examine(mob/user)
	. = ..()
	if(has_water_reclaimer)
		. += span_notice("A water recycler is installed. It looks like you could pry it out.")
	. += span_notice("[reagents.total_volume]/[reagents.maximum_volume] liquids remaining.")

/obj/structure/sink/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user || !istype(user))
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return
	if(reagents.total_volume < 5)
		to_chat(user, span_warning("The sink has no more contents left!"))
		return
	if(busy)
		to_chat(user, span_warning("Someone's already washing here!"))
		return
	var/selected_area = parse_zone(user.zone_selected)
	var/washing_face = 0
	if(selected_area in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES))
		washing_face = 1
	user.visible_message(span_notice("[user] starts washing [user.p_their()] [washing_face ? "face" : "hands"]..."), \
						span_notice("You start washing your [washing_face ? "face" : "hands"]..."))
	busy = TRUE

	if(!do_after(user, 40, target = src))
		busy = FALSE
		return

	busy = FALSE
	reagents.remove_any(5)
	reagents.expose(user, TOUCH, 5 / max(reagents.total_volume, 5))
	begin_reclamation()
	if(washing_face)
		SEND_SIGNAL(user, COMSIG_COMPONENT_CLEAN_FACE_ACT, CLEAN_WASH)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.lip_style = null //Washes off lipstick
			H.lip_color = initial(H.lip_color)
			H.headstamp = null
			H.regenerate_icons()
		user.drowsyness = max(user.drowsyness - rand(2,3), 0) //Washing your face wakes you up if you're falling asleep
	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.wash_hands(CLEAN_WASH))
			to_chat(user, span_warning("Your hands are covered by something!"))
			return
	else
		user.wash(CLEAN_WASH)

	user.visible_message(span_notice("[user] washes [user.p_their()] [washing_face ? "face" : "hands"] using [src]."), \
						span_notice("You wash your [washing_face ? "face" : "hands"] using [src]."))

/obj/structure/sink/attackby(obj/item/O, mob/living/user, params)
	if(busy)
		to_chat(user, span_warning("Someone's already washing here!"))
		return

	if(is_reagent_container(O))
		var/obj/item/reagent_containers/RG = O
		if(reagents.total_volume <= 0)
			to_chat(user, span_notice("<b>[capitalize(src)]</b> is dry."))
			return FALSE
		if(RG.is_refillable())
			if(!RG.reagents.holder_full())
				reagents.trans_to(RG, RG.amount_per_transfer_from_this, transfered_by = user)
				begin_reclamation()
				to_chat(user, span_notice("You fill [RG] from [src]."))
				return TRUE
			to_chat(user, span_notice("<b>[capitalize(RG)]</b> is full."))
			return FALSE

	if(istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.cell && B.cell.charge && B.turned_on)
			flick("baton_active", src)
			user.Paralyze(B.stun_time)
			user.stuttering = B.stun_time/20
			B.deductcharge(B.cell_hit_cost)
			user.visible_message(span_warning("[user] shocks [user.ru_na()]self while attempting to wash the active [B.name]!") , \
								span_userdanger("You unwisely attempt to wash [B] while it's still on."))
			playsound(src, B.stun_sound, 50, TRUE)
			return

	if(istype(O, /obj/item/mop))
		if(reagents.total_volume <= 0)
			to_chat(user, span_notice("<b>[capitalize(src)]</b> is dry."))
			return FALSE
		reagents.trans_to(O, 5, transfered_by = user)
		begin_reclamation()
		to_chat(user, span_notice("You wet [O] in [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return

	if(O.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		O.play_tool_sound(src)
		deconstruct()
		return

	if(O.tool_behaviour == TOOL_CROWBAR)
		if(!has_water_reclaimer)
			to_chat(user, span_warning("There isn't a water recycler to remove."))
			return

		O.play_tool_sound(src)
		has_water_reclaimer = FALSE
		new/obj/item/stock_parts/water_recycler(get_turf(loc))
		to_chat(user, span_notice("You remove the water reclaimer from [src]"))
		return

	if(istype(O, /obj/item/stack/medical/gauze))
		var/obj/item/stack/medical/gauze/G = O
		new /obj/item/reagent_containers/glass/rag(src.loc)
		to_chat(user, span_notice("You tear off a strip of gauze and make a rag."))
		G.use(1)
		return

	if(istype(O, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/cloth = O
		new /obj/item/reagent_containers/glass/rag(loc)
		to_chat(user, span_notice("You tear off a strip of cloth and make a rag."))
		cloth.use(1)
		return

	if(istype(O, /obj/item/stack/ore/glass))
		new /obj/item/stack/sheet/sandblock(loc)
		to_chat(user, span_notice("You wet the sand in the sink and form it into a block."))
		O.use(1)
		return

	if(istype(O, /obj/item/stock_parts/water_recycler))
		if(has_water_reclaimer)
			to_chat(user, span_warning("There is already has a water recycler installed."))
			return

		playsound(src, 'sound/machines/click.ogg', 20, TRUE)
		qdel(O)
		has_water_reclaimer = TRUE
		begin_reclamation()
		return

	if(!istype(O))
		return
	if(O.item_flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	if(user.a_intent != INTENT_HARM)
		to_chat(user, span_notice("You start washing [O]..."))
		busy = TRUE
		if(!do_after(user, 40, target = src))
			busy = FALSE
			return 1
		busy = FALSE
		O.wash(CLEAN_WASH)
		reagents.expose(O, TOUCH, 5 / max(reagents.total_volume, 5))
		user.visible_message(span_notice("[user] washes [O] using [src]."), \
							span_notice("You wash [O] using [src]."))
		return 1
	else
		return ..()

/obj/structure/sink/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		drop_materials()
		if(has_water_reclaimer)
			new /obj/item/stock_parts/water_recycler(drop_location())
	..()

/obj/structure/sink/process(delta_time)
	// Water reclamation complete?
	if(!has_water_reclaimer || reagents.total_volume >= reagents.maximum_volume)
		return PROCESS_KILL

	reagents.add_reagent(dispensedreagent, reclaim_rate * delta_time)

/obj/structure/sink/proc/drop_materials()
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/i in custom_materials)
			var/datum/material/M = i
			new M.sheet_type(loc, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))

/obj/structure/sink/proc/begin_reclamation()
	START_PROCESSING(SSplumbing, src)

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"
	pixel_z = 4
	pixel_shift = 16

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sink/kitchen, (-16))

/obj/structure/sink/greyscale
	icon_state = "sink_greyscale"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstacktype = null

/obj/structure/sinkframe
	name = "sink frame"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_frame"
	desc = "A sink frame, that needs a water recycler to finish construction."
	anchored = FALSE
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/obj/structure/sinkframe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))

/obj/structure/sinkframe/proc/can_be_rotated(mob/user, rotation_type)
	if(anchored)
		to_chat(user, span_warning("It is fastened to the floor!"))
	return !anchored

/obj/structure/sinkframe/attackby(obj/item/tool, mob/living/user, params)
	if(istype(tool, /obj/item/stock_parts/water_recycler))
		qdel(tool)
		var/obj/structure/sink/greyscale/new_sink = new(loc, REVERSE_DIR(dir), TRUE)
		new_sink.set_custom_materials(custom_materials)
		qdel(src)
		playsound(new_sink, 'sound/machines/click.ogg', 20, TRUE)
		return
	return ..()

/obj/structure/sinkframe/wrench_act(mob/living/user, obj/item/tool)
	. = ..()

	tool.play_tool_sound(src)
	var/obj/structure/sink/greyscale/new_sink = new(loc, REVERSE_DIR(dir), FALSE)
	new_sink.set_custom_materials(custom_materials)
	qdel(src)

	return TRUE

//Water source, use the type water_source for unlimited water sources like classic sinks.
/obj/structure/water_source
	name = "Water Source"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face. This one seems to be infinite!"
	anchored = TRUE
	var/busy = FALSE 	//Something's being washed at the moment
	var/dispensedreagent = /datum/reagent/water // for whenever plumbing happens

/obj/structure/water_source/Initialize(mapload)
	. = ..()
	create_reagents(100, NO_REACT)
	reagents.add_reagent(dispensedreagent, 100)

/obj/structure/water_source/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, span_warning("Someone's already washing here!"))
		return
	var/selected_area = parse_zone(user.zone_selected)
	var/washing_face = FALSE
	if(selected_area in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES))
		washing_face = TRUE
	user.visible_message(span_notice("[user] starts washing [user.ru_ego()] [washing_face ? "face" : "hands"]...") , \
						span_notice("You start washing your [washing_face ? "face" : "hands"]..."))
	busy = TRUE

	if(!do_after(user, 4 SECONDS, target = src))
		busy = FALSE
		return

	busy = FALSE

	if(washing_face)
		SEND_SIGNAL(user, COMSIG_COMPONENT_CLEAN_FACE_ACT, CLEAN_WASH)
		user.drowsyness = max(user.drowsyness - rand(2,3), 0) //Washing your face wakes you up if you're falling asleep
	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.wash_hands(CLEAN_WASH))
			to_chat(user, span_warning("Your hands are covered by something!"))
			return
	else
		user.wash(CLEAN_WASH)

	user.visible_message(span_notice("[user] washes [user.ru_ego()] [washing_face ? "face" : "hands"] using [src].") , \
						span_notice("You wash your [washing_face ? "face" : "hands"] using [src]."))

/obj/structure/water_source/attackby(obj/item/O, mob/living/user, params)
	if(busy)
		to_chat(user, span_warning("Someone's already washing here!"))
		return

	if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = O
		if(container.is_refillable())
			if(!container.reagents.holder_full())
				container.reagents.add_reagent(dispensedreagent, min(container.volume - container.reagents.total_volume, container.amount_per_transfer_from_this))
				to_chat(user, span_notice("You fill [container] from [src]."))
				return TRUE
			to_chat(user, span_notice("<b>[capitalize(container)]</b> is full."))
			return FALSE

	if(istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/baton = O
		if(baton.cell && baton.cell.charge && baton.turned_on)
			flick("baton_active", src)
			user.Paralyze(baton.stun_time)
			user.stuttering = baton.stun_time * 0.05
			baton.deductcharge(baton.cell_hit_cost)
			user.visible_message(span_warning("[user] shocks [user.ru_na()]self while attempting to wash the active [baton.name]!") , \
								span_userdanger("You unwisely attempt to wash [baton] while it's still on."))
			playsound(src, baton.stun_sound, 50, TRUE)
			return

	if(istype(O, /obj/item/mop))
		O.reagents.add_reagent(dispensedreagent, 5)
		to_chat(user, span_notice("You wet [O] in [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return

	if(istype(O, /obj/item/stack/medical/gauze))
		var/obj/item/stack/medical/gauze/G = O
		new /obj/item/reagent_containers/glass/rag(loc)
		to_chat(user, span_notice("You tear off a strip of gauze and make a rag."))
		G.use(1)
		return

	if(istype(O, /obj/item/stack/ore/glass))
		new /obj/item/stack/sheet/sandblock(loc)
		to_chat(user, span_notice("You wet the sand and form it into a block."))
		O.use(1)
		return

	if(O.item_flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	if(user.a_intent != INTENT_HARM)
		to_chat(user, span_notice("You start washing [O]..."))
		busy = TRUE
		if(!do_after(user, 4 SECONDS, target = src))
			busy = FALSE
			return TRUE
		busy = FALSE
		O.wash(CLEAN_WASH)
		reagents.expose(O, TOUCH, 5 / 100, 5)
		user.visible_message(span_notice("[user] washes [O] using [src].") , \
							span_notice("You wash [O] using [src]."))
		return TRUE

	return ..()


/obj/structure/water_source/puddle	//splishy splashy ^_^
	name = "puddle"
	desc = "A puddle used for washing one's hands and face."
	icon_state = "puddle"
	resistance_flags = UNACIDABLE

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/water_source/puddle/attack_hand(mob/M)
	icon_state = "puddle-splash"
	. = ..()
	icon_state = "puddle"

/obj/structure/water_source/puddle/attackby(obj/item/O, mob/user, params)
	icon_state = "puddle-splash"
	. = ..()
	icon_state = "puddle"

/obj/structure/water_source/puddle/deconstruct(disassembled = TRUE)
	qdel(src)

//End legacy sink


//Shower Curtains//
//Defines used are pre-existing in layers.dm//

/obj/structure/curtain
	name = "занавеска"
	desc = "Содержит менее одного процента ртути."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "bathroom-open"
	var/icon_type = "bathroom"//used in making the icon state
	color = "#ACD1E9" //Default color, didn't bother hardcoding other colors, mappers can and should easily change it.
	alpha = 200 //Mappers can also just set this to 255 if they want curtains that can't be seen through
	layer = SIGN_LAYER
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	var/open = TRUE
	/// if it can be seen through when closed
	var/opaque_closed = FALSE

/obj/structure/curtain/proc/toggle()
	open = !open
	if(open)
		icon_state = "[icon_type]-open"
		layer = SIGN_LAYER
		SET_PLANE_IMPLICIT(src, GAME_PLANE)
		set_density(FALSE)
		set_opacity(FALSE)
	else
		icon_state = "[icon_type]-closed"
		layer = WALL_OBJ_LAYER
		SET_PLANE_IMPLICIT(src, GAME_PLANE_UPPER)
		set_density(TRUE)
		open = FALSE
		if(opaque_closed)
			set_opacity(TRUE)

/obj/structure/curtain/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/toy/crayon))
		color = input(user,"","Choose Color",color) as color
	else
		return ..()

/obj/structure/curtain/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 50)
	return TRUE

/obj/structure/curtain/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		return TRUE

	user.visible_message(span_warning("[user] cuts apart [src].") ,
		span_notice("You start to cut apart [src].") , span_hear("You hear cutting."))
	if(I.use_tool(src, user, 50, volume=100) && !anchored)
		to_chat(user, span_notice("You cut apart [src]."))
		deconstruct()

	return TRUE


/obj/structure/curtain/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	playsound(loc, 'sound/effects/curtain.ogg', 50, TRUE)
	toggle()

/obj/structure/curtain/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/cloth (loc, 2)
	new /obj/item/stack/sheet/plastic (loc, 2)
	new /obj/item/stack/rods (loc, 1)
	qdel(src)

/obj/structure/curtain/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/weapons/slash.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, TRUE)

/obj/structure/curtain/bounty
	icon_type = "bounty"
	icon_state = "bounty-open"
	color = null
	alpha = 255
	opaque_closed = TRUE

/obj/structure/curtain/cloth
	color = null
	alpha = 255
	opaque_closed = TRUE

/obj/structure/curtain/cloth/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/cloth (loc, 4)
	new /obj/item/stack/rods (loc, 1)
	qdel(src)

/obj/structure/curtain/cloth/fancy
	icon_type = "cur_fancy"
	icon_state = "cur_fancy-open"

/obj/structure/curtain/cloth/fancy/mechanical
	var/id = null

/obj/structure/curtain/cloth/fancy/mechanical/Destroy()
	GLOB.curtains -= src
	return ..()

/obj/structure/curtain/cloth/fancy/mechanical/Initialize(mapload)
	. = ..()
	GLOB.curtains += src

/obj/structure/curtain/cloth/fancy/mechanical/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[port.id]_[id]"

/obj/structure/curtain/cloth/fancy/mechanical/proc/open()
	icon_state = "[icon_type]-open"
	layer = SIGN_LAYER
	SET_PLANE_IMPLICIT(src, GAME_PLANE)
	set_density(FALSE)
	open = TRUE
	playsound(loc, 'sound/effects/curtain.ogg', 50, TRUE)
	set_opacity(FALSE)

/obj/structure/curtain/cloth/fancy/mechanical/proc/close()
	icon_state = "[icon_type]-closed"
	layer = WALL_OBJ_LAYER
	SET_PLANE_IMPLICIT(src, GAME_PLANE_UPPER)
	set_density(TRUE)
	open = FALSE
	playsound(loc, 'sound/effects/curtain.ogg', 50, TRUE)
	if(opaque_closed)
		set_opacity(TRUE)

/obj/structure/curtain/cloth/fancy/mechanical/attack_hand(mob/user)
		return
