#define CONSTRUCTION_PANEL_OPEN 1 //Maintenance panel is open, still functioning
#define CONSTRUCTION_NO_CIRCUIT 2 //Circuit board removed, can safely weld apart
#define DEFAULT_STEP_TIME 20 /// default time for each step

/obj/machinery/door/firedoor
	name = "пожарный шлюз"
	desc = "Используй ломик!"
	icon = 'icons/obj/doors/Doorfireglass.dmi'
	icon_state = "door_open"
	opacity = FALSE
	density = FALSE
	max_integrity = 300
	resistance_flags = FIRE_PROOF
	heat_proof = TRUE
	glass = TRUE
	sub_door = TRUE
	explosion_block = 1
	safe = FALSE
	layer = BELOW_OPEN_DOOR_LAYER
	closingLayer = CLOSED_FIREDOOR_LAYER
	assemblytype = /obj/structure/firelock_frame
	armor = list(MELEE = 10, BULLET = 30, LASER = 20, ENERGY = 20, BOMB = 30, BIO = 100, RAD = 100, FIRE = 95, ACID = 70)
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_REQUIRES_SILICON | INTERACT_MACHINE_OPEN
	air_tight = TRUE
	var/emergency_close_timer = 0
	var/nextstate = null
	var/boltslocked = TRUE
	var/list/affecting_areas

/obj/machinery/door/firedoor/Initialize()
	. = ..()
	CalculateAffectingAreas()

/obj/machinery/door/firedoor/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(!density)
		. += "<span class='notice'>Он открыт, но может быть закрыт <b>ломиком</b>.</span>\n"
	else if(!welded)
		. += "<span class='notice'>Он закрыт, но может быть открыт <i>ломиком</i>. Для разбора придётся <b>заварить</b> его намертво.</span>\n"
	else if(boltslocked)
		. += "<span class='notice'>Он <i>заварен</i> намертво. Осталось <b>отвинтить</b> от пола.</span>\n"
	else
		. += "<span class='notice'>Он <i>отвинчен</i>, но сами винты <b>прикручены</b> к полу.</span>"

/obj/machinery/door/firedoor/proc/CalculateAffectingAreas()
	remove_from_areas()
	affecting_areas = get_adjacent_open_areas(src) | get_area(src)
	for(var/I in affecting_areas)
		var/area/A = I
		LAZYADD(A.firedoors, src)

/obj/machinery/door/firedoor/closed
	icon_state = "door_closed"
	density = TRUE

//see also turf/AfterChange for adjacency shennanigans

/obj/machinery/door/firedoor/proc/remove_from_areas()
	if(affecting_areas)
		for(var/I in affecting_areas)
			var/area/A = I
			LAZYREMOVE(A.firedoors, src)

/obj/machinery/door/firedoor/Destroy()
	remove_from_areas()
	affecting_areas.Cut()
	return ..()

/obj/machinery/door/firedoor/Bumped(atom/movable/AM)
	if(panel_open || operating)
		return
	if(!density)
		return ..()
	return FALSE


/obj/machinery/door/firedoor/power_change()
	. = ..()
	INVOKE_ASYNC(src, .proc/latetoggle)

/obj/machinery/door/firedoor/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(!welded && !operating && !(machine_stat & NOPOWER) && (!density || allow_hand_open(user)))
		add_fingerprint(user)
		if(density)
			emergency_close_timer = world.time + 30 // prevent it from instaclosing again if in space
			open()
		else
			close()
		return TRUE
	if(operating || !density)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	user.visible_message("<span class='notice'>[user] бьётся в [src].</span>", \
						 "<span class='notice'>Бьюсь в [src]. Гениально.</span>")
	playsound(loc, 'sound/effects/glassknock.ogg', 10, FALSE, frequency = 32000)

/obj/machinery/door/firedoor/attackby(obj/item/C, mob/user, params)
	add_fingerprint(user)
	if(operating)
		return
	if(welded)
		if(C.tool_behaviour == TOOL_WRENCH)
			if(boltslocked)
				to_chat(user, "<span class='notice'>Есть винты, фиксирующие болты на месте!</span>")
				return
			C.play_tool_sound(src)
			user.visible_message("<span class='notice'>[user] начинает откручивать болты [src]...</span>", \
								 "<span class='notice'>Начинаю откручивать [src] от пола...</span>")
			if(!C.use_tool(src, user, DEFAULT_STEP_TIME))
				return
			playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
			user.visible_message("<span class='notice'>[user] откручивает болты [src].</span>", \
								 "<span class='notice'>Откручиваю [src] от пола.</span>")
			var/turf/T = get_turf(src)
			new /obj/item/shard(T, 1)
			qdel(src)
			return
		if(C.tool_behaviour == TOOL_SCREWDRIVER)
			user.visible_message("<span class='notice'>[user] [boltslocked ? "разблокирует" : "блокирует"] болты [src].</span>", \
								 "<span class='notice'>[boltslocked ? "Разблокирую" : "Блокирую"] напольные болты [src].</span>")
			C.play_tool_sound(src)
			boltslocked = !boltslocked
			return
	return ..()

/obj/machinery/door/firedoor/try_to_activate_door(mob/user)
	return

/obj/machinery/door/firedoor/try_to_weld(obj/item/weldingtool/W, mob/user)
	if(!W.tool_start_check(user, amount=0))
		return
	user.visible_message("<span class='notice'>[user] начинает [welded ? "разваривать" : "заваривать"] [src].</span>", "<span class='notice'>Начинаю оперировать сваркой над [src].</span>")
	if(W.use_tool(src, user, DEFAULT_STEP_TIME, volume=50))
		welded = !welded
		to_chat(user, "<span class='danger'>[user] [welded?"заваривает":"разваривает"] [src].</span>", "<span class='notice'>[welded ? "Завариваю" : "Развариваю"] [src].</span>")
		log_game("[key_name(user)] [welded ? "welded":"unwelded"] firedoor [src] with [W] at [AREACOORD(src)]")
		update_icon()

/obj/machinery/door/firedoor/try_to_crowbar(obj/item/I, mob/user)
	if(welded || operating)
		return

	if(density)
		if(is_holding_pressure())
			// tell the user that this is a bad idea, and have a do_after as well
			to_chat(user, "<span class='warning'>Начинаю вскрывать [src] ломиком, попутно ощущая сильный поток воздуха... может стоит ПЕРЕДУМАТЬ?</span>")
			if(!do_after(user, 2 SECONDS, src)) // give them a few seconds to reconsider their decision.
				return
			log_game("[key_name_admin(user)] has opened a firelock with a pressure difference at [AREACOORD(loc)]") // there bibby I made it logged just for you. Enjoy.
			// since we have high-pressure-ness, close all other firedoors on the tile
			whack_a_mole()
		if(welded || operating || !density)
			return // in case things changed during our do_after
		emergency_close_timer = world.time + 60 // prevent it from instaclosing again if in space
		open()
	else
		close()

/obj/machinery/door/firedoor/proc/whack_a_mole(reconsider_immediately = FALSE)
	set waitfor = 0
	for(var/cdir in GLOB.cardinals)
		if((flags_1 & ON_BORDER_1) && cdir != dir)
			continue
		whack_a_mole_part(get_step(src, cdir), reconsider_immediately)
	if(flags_1 & ON_BORDER_1)
		whack_a_mole_part(get_turf(src), reconsider_immediately)

/obj/machinery/door/firedoor/proc/whack_a_mole_part(turf/start_point, reconsider_immediately)
	set waitfor = 0
	var/list/doors_to_close = list()
	var/list/turfs = list()
	turfs[start_point] = 1
	for(var/i = 1; (i <= turfs.len && i <= 11); i++) // check up to 11 turfs.
		var/turf/open/T = turfs[i]
		if(istype(T, /turf/open/space))
			return -1
		for(var/T2 in T.atmos_adjacent_turfs)
			if(turfs[T2])
				continue
			var/is_cut_by_unopen_door = FALSE
			for(var/obj/machinery/door/firedoor/FD in T2)
				if((FD.flags_1 & ON_BORDER_1) && get_dir(T2, T) != FD.dir)
					continue
				if(FD.operating || FD == src || FD.welded || FD.density)
					continue
				doors_to_close += FD
				is_cut_by_unopen_door = TRUE

			for(var/obj/machinery/door/firedoor/FD in T)
				if((FD.flags_1 & ON_BORDER_1) && get_dir(T, T2) != FD.dir)
					continue
				if(FD.operating || FD == src || FD.welded || FD.density)
					continue
				doors_to_close += FD
				is_cut_by_unopen_door= TRUE
			if(!is_cut_by_unopen_door)
				turfs[T2] = 1
	if(turfs.len > 10)
		return // too big, don't bother
	for(var/obj/machinery/door/firedoor/FD in doors_to_close)
		FD.emergency_pressure_stop(FALSE)
		if(reconsider_immediately)
			var/turf/open/T = FD.loc
			if(istype(T))
				T.ImmediateCalculateAdjacentTurfs()

/obj/machinery/door/firedoor/proc/allow_hand_open(mob/user)
	var/area/A = get_area(src)
	if(A && A.fire)
		return FALSE
	return !is_holding_pressure()

/obj/machinery/door/firedoor/attack_ai(mob/user)
	add_fingerprint(user)
	if(welded || operating || machine_stat & NOPOWER)
		return TRUE
	if(density)
		open()
	else
		close()
	return TRUE

/obj/machinery/door/firedoor/attack_robot(mob/user)
	return attack_ai(user)

/obj/machinery/door/firedoor/attack_alien(mob/user)
	add_fingerprint(user)
	if(welded)
		to_chat(user, "<span class='warning'>[capitalize(src.name)] не хочет открываться!</span>")
		return
	open()

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
		if("closing")
			flick("door_closing", src)

/obj/machinery/door/firedoor/update_icon_state()
	if(density)
		icon_state = "door_closed"
	else
		icon_state = "door_open"

/obj/machinery/door/firedoor/update_overlays()
	. = ..()
	if(!welded)
		return
	if(density)
		. += "welded"
	else
		. += "welded_open"

/obj/machinery/door/firedoor/open()
	. = ..()
	latetoggle()

/obj/machinery/door/firedoor/close()
	. = ..()
	latetoggle()

/obj/machinery/door/firedoor/proc/emergency_pressure_stop(consider_timer = TRUE)
	set waitfor = 0
	if(density || operating || welded)
		return
	if(world.time >= emergency_close_timer || !consider_timer)
		close()

/obj/machinery/door/firedoor/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/turf/T = get_turf(src)
		if(disassembled || prob(40))
			var/obj/structure/firelock_frame/F = new assemblytype(T)
			if(disassembled)
				F.constructionStep = CONSTRUCTION_PANEL_OPEN
			else
				F.constructionStep = CONSTRUCTION_NO_CIRCUIT
				F.obj_integrity = F.max_integrity * 0.5
			F.update_icon()
		else
			new /obj/item/electronics/firelock (T)
	qdel(src)


/obj/machinery/door/firedoor/proc/latetoggle()
	if(operating || machine_stat & NOPOWER || !nextstate)
		return
	switch(nextstate)
		if(FIREDOOR_OPEN)
			nextstate = null
			open()
		if(FIREDOOR_CLOSED)
			nextstate = null
			close()

/obj/machinery/door/firedoor/border_only
	icon = 'icons/obj/doors/edge_Doorfire.dmi'
	can_crush = FALSE
	flags_1 = ON_BORDER_1
	CanAtmosPass = ATMOS_PASS_PROC
	glass = FALSE

/obj/machinery/door/firedoor/border_only/closed
	icon_state = "door_closed"
	opacity = TRUE
	density = TRUE

/obj/machinery/door/firedoor/border_only/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(!(get_dir(loc, target) == dir)) //Make sure looking at appropriate border
		return TRUE

/obj/machinery/door/firedoor/border_only/CheckExit(atom/movable/mover as mob|obj, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/machinery/door/firedoor/border_only/CanAtmosPass(turf/T)
	if(get_dir(loc, T) == dir)
		return !density
	else
		return TRUE

/obj/machinery/door/firedoor/heavy
	name = "тяжёлый пожарный шлюз"
	icon = 'icons/obj/doors/Doorfire.dmi'
	glass = FALSE
	explosion_block = 2
	assemblytype = /obj/structure/firelock_frame/heavy
	max_integrity = 550

/obj/machinery/door/firedoor/window
	name = "запасное окно"
	icon = 'white/valtos/icons/doorfirewindow.dmi'
	desc = "Автоматически закрывается при повреждении основного окна. Гениальная разработка наших инженеров."
	glass = TRUE
	explosion_block = 0
	max_integrity = 50
	resistance_flags = 0 // not fireproof
	heat_proof = FALSE
	assemblytype = /obj/item/shard // yeah

/obj/machinery/door/firedoor/window/allow_hand_open()
	return TRUE

/obj/machinery/door/firedoor/window/deconstruct(disassembled = TRUE)
	new assemblytype(get_turf(src))
	qdel(src)

/obj/item/electronics/firelock
	name = "микросхема пожарного шлюза"
	custom_price = 50
	desc = "Печатная плата, используемая в конструкции пожарных шлюзов."
	icon_state = "mainboard"

/obj/structure/firelock_frame
	name = "рама пожарного шлюза"
	desc = "Почти готовый пожарный шлюз."
	icon = 'icons/obj/doors/Doorfire.dmi'
	icon_state = "frame1"
	anchored = FALSE
	density = TRUE
	var/constructionStep = CONSTRUCTION_NO_CIRCUIT
	var/reinforced = 0

/obj/structure/firelock_frame/examine(mob/user)
	. = ..()
	. += "<hr>"
	switch(constructionStep)
		if(CONSTRUCTION_PANEL_OPEN)
			. += "<span class='notice'>Он <i>откручен</i> от пола. Микросхема может быть изъята <b>ломиком</b>.</span>"
			if(!reinforced)
				. += "<span class='notice'>Он может быть укреплён пласталью.</span>"
		if(CONSTRUCTION_NO_CIRCUIT)
			. += "<span class='notice'>Здесь нет <i>микросхемы</i> внутри. Рама может быть <b>разварена</b> на части.</span>"

/obj/structure/firelock_frame/update_icon_state()
	icon_state = "frame[constructionStep]"

/obj/structure/firelock_frame/attackby(obj/item/C, mob/user)
	switch(constructionStep)
		if(CONSTRUCTION_PANEL_OPEN)
			if(C.tool_behaviour == TOOL_CROWBAR)
				C.play_tool_sound(src)
				user.visible_message("<span class='notice'>[user] начинает извлекать микросхему из [src]...</span>", \
									 "<span class='notice'>Начинаю извлекать микросхему из [src]...</span>")
				if(!C.use_tool(src, user, DEFAULT_STEP_TIME))
					return
				if(constructionStep != CONSTRUCTION_PANEL_OPEN)
					return
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				user.visible_message("<span class='notice'>[user] извлекает плату из [src].</span>", \
									 "<span class='notice'>Извлекаю плату из [src].</span>")
				new /obj/item/electronics/firelock(drop_location())
				constructionStep = CONSTRUCTION_NO_CIRCUIT
				update_icon()
				return
			if(C.tool_behaviour == TOOL_WRENCH)
				if(locate(/obj/machinery/door/firedoor) in get_turf(src))
					to_chat(user, "<span class='warning'>Здесь уже есть пожарный шлюз.</span>")
					return
				C.play_tool_sound(src)
				user.visible_message("<span class='notice'>[user] начинает прикручивать [src]...</span>", \
									 "<span class='notice'>Начинаю прикручивать [src]...</span>")
				if(!C.use_tool(src, user, DEFAULT_STEP_TIME))
					return
				if(locate(/obj/machinery/door/firedoor) in get_turf(src))
					return
				user.visible_message("<span class='notice'>[user] заканчивает пожарный шлюз.</span>", \
									 "<span class='notice'>Заканчиваю пожарный шлюз.</span>")
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(reinforced)
					new /obj/machinery/door/firedoor/heavy(get_turf(src))
				else
					new /obj/machinery/door/firedoor(get_turf(src))
				qdel(src)
				return
			if(istype(C, /obj/item/stack/sheet/plasteel))
				var/obj/item/stack/sheet/plasteel/P = C
				if(reinforced)
					to_chat(user, "<span class='warning'>[capitalize(src.name)] уже укреплён.</span>")
					return
				if(P.get_amount() < 2)
					to_chat(user, "<span class='warning'>Мне потребуется чуть больше пластали для [src].</span>")
					return
				user.visible_message("<span class='notice'>[user] начинает укреплять [src]...</span>", \
									 "<span class='notice'>Начинаю укреплять [src]...</span>")
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(do_after(user, DEFAULT_STEP_TIME, target = src))
					if(constructionStep != CONSTRUCTION_PANEL_OPEN || reinforced || P.get_amount() < 2 || !P)
						return
					user.visible_message("<span class='notice'>[user] укрепляет [src].</span>", \
										 "<span class='notice'>Укрепляю [src].</span>")
					playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
					P.use(2)
					reinforced = 1
				return
		if(CONSTRUCTION_NO_CIRCUIT)
			if(istype(C, /obj/item/electronics/firelock))
				user.visible_message("<span class='notice'>[user] начинает устанавливает [C] к [src]...</span>", \
									 "<span class='notice'>Начинаю вставлять плату в [src]...</span>")
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				if(!do_after(user, DEFAULT_STEP_TIME, target = src))
					return
				if(constructionStep != CONSTRUCTION_NO_CIRCUIT)
					return
				qdel(C)
				user.visible_message("<span class='notice'>[user] устанавливает плату в [src].</span>", \
									 "<span class='notice'>Вставляю плату в [C].</span>")
				playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE)
				constructionStep = CONSTRUCTION_PANEL_OPEN
				return
			if(C.tool_behaviour == TOOL_WELDER)
				if(!C.tool_start_check(user, amount=1))
					return
				user.visible_message("<span class='notice'>[user] начинает разваривать [src]...</span>", \
									 "<span class='notice'>Начинаю разваривать [src] на куски...</span>")

				if(C.use_tool(src, user, DEFAULT_STEP_TIME, volume=50, amount=1))
					if(constructionStep != CONSTRUCTION_NO_CIRCUIT)
						return
					user.visible_message("<span class='notice'>[user] разваривает на куски [src]!</span>", \
										 "<span class='notice'>Развариваю [src] в метал.</span>")
					var/turf/T = get_turf(src)
					new /obj/item/stack/sheet/metal(T, 3)
					if(reinforced)
						new /obj/item/stack/sheet/plasteel(T, 2)
					qdel(src)
				return
			if(istype(C, /obj/item/electroadaptive_pseudocircuit))
				var/obj/item/electroadaptive_pseudocircuit/P = C
				if(!P.adapt_circuit(user, DEFAULT_STEP_TIME * 0.5))
					return
				user.visible_message("<span class='notice'>[user] создаёт специальную плату и вставляет в [src].</span>", \
				"<span class='notice'>Адаптирую микросхему и вставляю в пожарный шлюз.</span>")
				constructionStep = CONSTRUCTION_PANEL_OPEN
				update_icon()
				return
	return ..()

/obj/structure/firelock_frame/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 16)
	else if((constructionStep == CONSTRUCTION_NO_CIRCUIT) && (the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("mode" = RCD_UPGRADE_SIMPLE_CIRCUITS, "delay" = 20, "cost" = 1)
	return FALSE

/obj/structure/firelock_frame/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_UPGRADE_SIMPLE_CIRCUITS)
			user.visible_message("<span class='notice'>[user] создаёт специальную плату и вставляет в [src].</span>", \
			"<span class='notice'>Адаптирую микросхему и вставляю в пожарный шлюз.</span>")
			constructionStep = CONSTRUCTION_PANEL_OPEN
			update_icon()
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>Разбираю [src].</span>")
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/firelock_frame/heavy
	name = "рама тяжёлого пожарного шлюза"
	reinforced = TRUE

#undef CONSTRUCTION_PANEL_OPEN
#undef CONSTRUCTION_NO_CIRCUIT
