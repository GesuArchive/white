/obj/machinery/door/poddoor
	name = "бронеставни"
	desc = "Тяжелый бронированный шлюз надежно перекрывающий проход и способный выдержать даже небольшой взрыв."
	icon = 'icons/obj/doors/blastdoor.dmi'
	icon_state = "closed"
	layer = BLASTDOOR_LAYER
	closingLayer = CLOSED_BLASTDOOR_LAYER
	sub_door = TRUE
	explosion_block = 3
	heat_proof = TRUE
	safe = FALSE
	max_integrity = 600
	armor = list(MELEE = 50, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 50, BIO = 0, FIRE = 100, ACID = 70)
	resistance_flags = FIRE_PROOF
	damage_deflection = 70
	air_tight = TRUE
	var/deconstruction = BLASTDOOR_FINISHED // этап разборки
	var/datum/crafting_recipe/recipe_type = /datum/crafting_recipe/blast_doors
	var/encrypted = TRUE
	can_open_with_hands = FALSE
	var/id = 1

// 	Разборка шлюза

/obj/machinery/door/poddoor/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	else if (default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		update_icon_state()
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/poddoor/multitool_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (!panel_open)
		return
	if (deconstruction != BLASTDOOR_FINISHED)
		return
	if(id != 1) // Быстрый пропуск проверки для стандартного 1 канала
		to_chat(user, span_notice("Кажется на этом шлюзе уже меняли заводские настройки ID. Начинаю перебирать коды..."))
		if(!do_after(user, 60 SECONDS, user))
			return TRUE
		if(!encrypted) // Проверка на пользовательский диапазон от 1 до 100, обычный мультитул может взламывать только такие шлюзы
			to_chat(user, span_notice("Текущий ID [id]..."))
		else
			if(istype(tool, /obj/item/multitool/mechcomp) || istype(tool, /obj/item/multitool/tricorder) || istype(tool, /obj/item/closet_hacker))
				to_chat(user, span_notice("Текущий ID [id]..."))
			else
				to_chat(user, span_notice("ID закодирован более сложным шифром, мне понадобится устройство помощнее для взлома этого шлюза..."))
				return

	var/change_id = tgui_input_number(user, "Установите номер ID", "Канал", id, 100)
	if(!change_id || QDELETED(usr) || QDELETED(src) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	id = change_id
	encrypted = FALSE
	to_chat(user, span_notice("Меняю ID на [id]."))
	balloon_alert(user, "ID изменен")
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/poddoor/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(machine_stat & NOPOWER)
		open(TRUE)
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (!panel_open)
		return
	if(id != 1)
		balloon_alert(user, "для разборки необходимо установить ID на 1 канал!")
		return
	if (deconstruction != BLASTDOOR_FINISHED)
		return
	balloon_alert(user, "начинаю извлекать плату...")
	if(tool.use_tool(src, user, 10 SECONDS, volume = 50))
		new /obj/item/electronics/airlock(loc)
		id = null
		deconstruction = BLASTDOOR_NEEDS_ELECTRONICS
		balloon_alert(user, "плата извлечена")
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/poddoor/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (!panel_open)
		return
	if (deconstruction != BLASTDOOR_NEEDS_ELECTRONICS)
		return
	balloon_alert(user, "начинаю срезать проводку...")
	if(tool.use_tool(src, user, 10 SECONDS, volume = 50))
		var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
		var/amount = recipe.reqs[/obj/item/stack/cable_coil]
		new /obj/item/stack/cable_coil(loc, amount)
		deconstruction = BLASTDOOR_NEEDS_WIRES
		balloon_alert(user, "проводка удалена")
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/poddoor/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (!panel_open)
		return
	if (deconstruction != BLASTDOOR_NEEDS_WIRES)
		return
	balloon_alert(user, "начинаю разваривать [src] на части...")
	if(tool.use_tool(src, user, 15 SECONDS, volume = 50))
		var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
		var/amount = recipe.reqs[/obj/item/stack/sheet/plasteel]
		new /obj/item/stack/sheet/plasteel(loc, amount)
		user.balloon_alert(user, "готово")
		qdel(src)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/door/poddoor/examine(mob/user)
	. = ..()
	if(panel_open)
		if(deconstruction == BLASTDOOR_FINISHED)
			. += span_notice("Панель технического обслуживания открыта, и плата может быть <b>извлечена</b>.")
		else if(deconstruction == BLASTDOOR_NEEDS_ELECTRONICS)
			. += span_notice("<i>Плата</i> отсутствует, и <b>провода</b> торчат наружу.")
		else if(deconstruction == BLASTDOOR_NEEDS_WIRES)
			. += span_notice("<i>Провода</i> извлечены, теперь корпус можно <b>разварить на части</b>.")
/*			if(!anchored)
				. += span_notice("<i>Анкерные болты</i> <b>откручены</b>.")
			else
				. += span_notice("<i>Анкерные болты</i> <b>закручены</b>.")
*/
// 	Ручная сборка

/obj/machinery/door/poddoor/attackby(obj/item/W, mob/user, params)
//  Этап проводов
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/S = W
		if(!panel_open)
			return
		if(!anchored)
			balloon_alert(user, "необходимо закрутить анкерные болты!")
			return
		if (deconstruction == BLASTDOOR_NEEDS_WIRES)
			var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
			var/amount = recipe.reqs[/obj/item/stack/sheet/plasteel]
			if(S.amount < amount)
				to_chat(user, span_warning("Для сборки шлюза необходимо по крайней мере 10 метров кабеля."))
				return
			to_chat(user, span_notice("Закрепляю проводку..."))
			playsound(user, 'sound/items/deconstruct.ogg', 100, TRUE)
			if(!do_after(user, 2 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/screwdriver.ogg', 100, TRUE)
			deconstruction = BLASTDOOR_NEEDS_ELECTRONICS
			S.use(amount)
			return

// 	Этап платы
	if(istype(W, /obj/item/electronics/airlock))
		var/obj/item/electronics/airlock/S = W
		if(!panel_open)
			return
		if (deconstruction == BLASTDOOR_NEEDS_ELECTRONICS)
			to_chat(user, span_notice("Устанавливаю плату на место..."))
			playsound(user, 'sound/items/deconstruct.ogg', 100, TRUE)
			if(!do_after(user, 2 SECONDS, src))
				return TRUE
			playsound(user, 'sound/items/screwdriver.ogg', 100, TRUE)
			deconstruction = BLASTDOOR_FINISHED
			id = 1
			icon_state = "open"
			update_icon_state()
			qdel(S)
			return
	. = ..()
/*
// 	Перемещение
/obj/machinery/door/poddoor/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "необходимо открыть шлюз!")
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if (!panel_open)
		return
	if (deconstruction != BLASTDOOR_NEEDS_WIRES)
		return
	balloon_alert(user, "начинаю [anchored ? "откручивать" : "закручивать"] анкерные болты...")
	if(tool.use_tool(src, user, 15 SECONDS, volume = 50))
		anchored = !anchored
		user.balloon_alert(user, "готово")
	return TOOL_ACT_TOOLTYPE_SUCCESS
*/

// 	Заготовка
/obj/machinery/door/poddoor/assembly
	icon_state = "bilding"
	density = FALSE
	opacity = FALSE
	deconstruction = BLASTDOOR_NEEDS_WIRES
	encrypted = FALSE
	panel_open = TRUE

/obj/machinery/door/poddoor/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[port.id]_[id]"

//"BLAST" doors are obviously stronger than regular doors when it comes to BLASTS.
/obj/machinery/door/poddoor/ex_act(severity, target)
	if(severity <= EXPLODE_LIGHT)
		return FALSE
	return ..()

/obj/machinery/door/poddoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("closing")
			flick("closing", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)

/obj/machinery/door/poddoor/update_icon_state()
	. = ..()
	icon_state = density ? "closed" : "open"

/obj/machinery/door/poddoor/attack_alien(mob/living/carbon/alien/humanoid/user, list/modifiers)
	if(density & !(resistance_flags & INDESTRUCTIBLE))
		add_fingerprint(user)
		user.visible_message(span_warning("[user] begins prying open [src]."),\
					span_noticealien("You begin digging your claws into [src] with all your might!"),\
					span_warning("You hear groaning metal..."))
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)

		var/time_to_open = 5 SECONDS
		if(hasPower())
			time_to_open = 15 SECONDS

		if(do_after(user, time_to_open, src))
			if(density && !open(TRUE)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
				to_chat(user, span_warning("Despite your efforts, [src] managed to resist your attempts to open it!"))

	else
		return ..()

/obj/machinery/door/poddoor/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/ert
	name = "hardened blast door"
	desc = "A heavy duty blast door that only opens for dire emergencies."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

//special poddoors that open when emergency shuttle docks at centcom
/obj/machinery/door/poddoor/shuttledock
	var/checkdir = 4 //door won't open if turf in this dir is `turftype`
	var/turftype = /turf/open/space

/obj/machinery/door/poddoor/shuttledock/proc/check()
	var/turf/turf = get_step(src, checkdir)
	if(!istype(turf, turftype))
		INVOKE_ASYNC(src, PROC_REF(open))
	else
		INVOKE_ASYNC(src, PROC_REF(close))

/obj/machinery/door/poddoor/incinerator_ordmix
	name = "combustion chamber vent"
	id = INCINERATOR_ORDMIX_VENT

/obj/machinery/door/poddoor/incinerator_atmos_main
	name = "turbine vent"
	id = INCINERATOR_ATMOS_MAINVENT

/obj/machinery/door/poddoor/incinerator_atmos_aux
	name = "combustion chamber vent"
	id = INCINERATOR_ATMOS_AUXVENT

/obj/machinery/door/poddoor/atmos_test_room_mainvent_1
	name = "test chamber 1 vent"
	id = TEST_ROOM_ATMOS_MAINVENT_1

/obj/machinery/door/poddoor/atmos_test_room_mainvent_2
	name = "test chamber 2 vent"
	id = TEST_ROOM_ATMOS_MAINVENT_2

/obj/machinery/door/poddoor/incinerator_syndicatelava_main
	name = "turbine vent"
	id = INCINERATOR_SYNDICATELAVA_MAINVENT

/obj/machinery/door/poddoor/incinerator_syndicatelava_aux
	name = "combustion chamber vent"
	id = INCINERATOR_SYNDICATELAVA_AUXVENT

/obj/machinery/door/poddoor/massdriver_ordnance
	name = "Toxins Launcher Bay Door"
	id = MASSDRIVER_TOXINS

/obj/machinery/door/poddoor/massdriver_chapel
	name = "бронедверь священного выброса"
	id = MASSDRIVER_CHAPEL

/obj/machinery/door/poddoor/massdriver_trash
	name = "Disposals Launcher Bay Door"
	id = MASSDRIVER_DISPOSALS

/obj/machinery/door/poddoor/Bumped(atom/movable/AM)
	if(density)
		return 0
	else
		return ..()

/obj/machinery/door/poddoor/shutters/bumpopen()
	return

//"BLAST" doors are obviously stronger than regular doors when it comes to BLASTS.
/obj/machinery/door/poddoor/ex_act(severity, target)
	if(severity <= EXPLODE_LIGHT)
		return
	..()

/obj/machinery/door/poddoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("closing")
			flick("closing", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)

/obj/machinery/door/poddoor/update_icon_state()
	. = ..()
	if(deconstruction == BLASTDOOR_FINISHED)
		if(density)
			icon_state = "closed"
		else
			if(!panel_open)
				icon_state = "open"
			else
				icon_state = "bilding"

/obj/machinery/door/poddoor/try_to_activate_door(mob/user)
	return

/obj/machinery/door/poddoor/try_to_crowbar(obj/item/I, mob/user)
	if(machine_stat & NOPOWER)
		open(TRUE)

/obj/machinery/door/poddoor/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(!can_open_with_hands)
		return
	if(density & !(resistance_flags & INDESTRUCTIBLE))
		add_fingerprint(user)
		user.visible_message(span_warning("[user] начинает отжимать [src].") ,\
					span_noticealien("Вцепляюсь когтями в [src] и наваливаюсь всей своей мощью на створки!") ,\
					span_warning("Где-то рядом раздается скрежет металла..."))
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)

		var/time_to_open = 5 SECONDS
		if(hasPower())
			time_to_open = 60 SECONDS

		if(do_after(user, time_to_open, src))
			if(density && !open(TRUE)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
				to_chat(user, span_warning("Несмотря на все мои потуги, [src] сопротивляется попыткам его открытия!"))

	else
		return ..()

