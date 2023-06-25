/obj/machinery/organdoc
	name = "Орган-Док МК IIX"
	desc = "Автоматический хирургически комплекс специализированный на имплантационных и трансплантационных операциях."
	density = TRUE
	state_open = FALSE
	icon = 'white/valtos/icons/64x64_autodoc.dmi'
	icon_state = "autodoc_machine"
	verb_say = "констатирует"
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 10
	circuit = /obj/item/circuitboard/machine/organdoc
	var/obj/item/organ/storedorgan
	var/organ_type = /obj/item/organ
	var/processing = FALSE
	var/surgerytime = 300

/obj/machinery/organdoc/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/organdoc/RefreshParts()
	. = ..()
/*
	var/max_time = 350
	for(var/obj/item/stock_parts/L in component_parts)
		max_time -= (L.rating*10)
	surgerytime = max(max_time,10)
*/
	//Скорость работы (300 -> 225 -> 150 -> 75 -> 30)
	var/T = -2
	for(var/obj/item/stock_parts/micro_laser/Ml in component_parts)
		T += Ml.rating
	surgerytime = initial(surgerytime) - (initial(surgerytime)*(T))/8
	if(surgerytime <= 30)
		surgerytime = 30

	//Энергопотребление (10к -> 7.5к -> 5к -> 2.5к -> 1к)
	var/P = -1
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		P += cap.rating
	active_power_usage = initial(active_power_usage) - (initial(active_power_usage)*(P))/4
	if(active_power_usage <= 1000)
		active_power_usage = 1000

/obj/machinery/organdoc/examine(mob/user)
	. = ..()
	if((obj_flags & EMAGGED) && panel_open)
		. += "<hr><span class='warning'>Хирургические протоколы нарушены!</span>"
	if(processing)
		. += "<hr><span class='notice'>На данный момент вставляет [storedorgan] в [occupant].</span>"
	else if(storedorgan)
		. += "<hr><span class='notice'>Готов вставить [storedorgan].</span>"

/obj/machinery/organdoc/close_machine(mob/user)
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(occupant)
		if(!iscarbon(occupant))
			occupant.forceMove(drop_location())
			occupant = null
			return
		to_chat(occupant, span_notice("Вхожу в [src.name]"))

		dosurgery()

/obj/machinery/organdoc/proc/dosurgery()
	if(!storedorgan && !(obj_flags & EMAGGED))
		to_chat(occupant, span_notice("Органдок не имеет имплантов."))
		return

	occupant.visible_message(span_notice("<b>[occupant]</b> нажимает на кнопку Органдока.") , span_notice("Ощущаю как острые штуки протыкают меня и что-то делают с моими органами."))
	playsound(get_turf(occupant), 'sound/weapons/circsawhit.ogg', 50, 1)
	processing = TRUE
	update_icon()
	var/mob/living/carbon/C = occupant
	if(obj_flags & EMAGGED)

		for(var/obj/item/bodypart/BP in reverseList(C.bodyparts)) //Chest and head are first in bodyparts, so we invert it to make them suffer more
			C.emote("agony")
			if(!HAS_TRAIT(C, TRAIT_NODISMEMBER))
				BP.dismember()
			else
				C.apply_damage(40, BRUTE, BP)
			sleep(5) //2 seconds to get outta there before dying
			if(!processing)
				return

		occupant.visible_message(span_warning("Органдок нарезает на кусочки <b>[occupant]</b>!") , span_warning("Органдок начинает шинковать меня как салат Цезарь!"))

	else
		sleep(surgerytime)
		if(!processing)
			return
		var/obj/item/organ/currentorgan = C.get_organ_slot(storedorgan.slot)
		if(currentorgan)
			currentorgan.Remove(C)
			currentorgan.forceMove(get_turf(src))
		storedorgan.Insert(occupant)//insert stored organ into the user
		storedorgan = null
		occupant.visible_message(span_notice("Органдок завершает хирургическую процедуру") , span_notice("Органдок вставляет орган в моё тело."))
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, 0)
	processing = FALSE
	use_power(active_power_usage)
	open_machine()

/obj/machinery/organdoc/open_machine(mob/user)
	if(processing)
		occupant.visible_message(span_notice("<b>[user]</b> отменяет процедуру Органдока") , span_notice("Органдок прекращает вставлять орган в моё тело."))
		processing = FALSE
	if(occupant)
		occupant.forceMove(drop_location())
		occupant = null
	..(FALSE)

/obj/machinery/organdoc/interact(mob/user)
	if(panel_open)
		to_chat(user, span_notice("Закрыть бы техническую панель сначала."))
		return

	if(state_open)
		close_machine()
		return

	open_machine()

/obj/machinery/organdoc/attackby(obj/item/I, mob/user, params)
	if(istype(I, organ_type))
		if(storedorgan)
			to_chat(user, span_notice("Органдок уже имеет орган для работы."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		storedorgan = I
		I.forceMove(src)
		to_chat(user, span_notice("Вставляю [I.name] в Органдок."))
	else
		return ..()

/obj/machinery/organdoc/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, span_warning("Органдок уже занят!"))
		return
	if(state_open)
		to_chat(user, span_warning("Органдок должен быть закрыт!"))
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		if(storedorgan)
			storedorgan.forceMove(drop_location())
			storedorgan = null
		update_icon()
		return
	return FALSE

/obj/machinery/organdoc/crowbar_act(mob/living/user, obj/item/I)
	if(default_deconstruction_crowbar(I))
		return TRUE


/obj/machinery/organdoc/update_icon()
	. = ..()
	overlays.Cut()
	if(!state_open)
		if(processing)
			overlays += "[icon_state]_door_on"
			overlays += "[icon_state]_stack"
			overlays += "[icon_state]_smoke"
			overlays += "[icon_state]_green"
		else
			overlays += "[icon_state]_door_off"
			if(occupant)
				if(powered(AREA_USAGE_EQUIP))
					overlays += "[icon_state]_stack"
					overlays += "[icon_state]_yellow"
			else
				overlays += "[icon_state]_red"
	else if(powered(AREA_USAGE_EQUIP))
		overlays += "[icon_state]_red"
	if(panel_open)
		overlays += "[icon_state]_panel"

/obj/machinery/organdoc/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_warning("Переделываю программу в режим готовки шаурмы."))

/obj/item/circuitboard/machine/organdoc
	name = "Плата Орган-Дока МК IIX"
	desc = "Автоматический хирургически комплекс специализированный на имплантационных и трансплантационных операциях."
	build_path = /obj/machinery/organdoc
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	req_components = list(/obj/item/scalpel/advanced = 1,
		/obj/item/retractor/advanced = 1,
		/obj/item/cautery/advanced = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1)

/datum/design/board/organdoc
	name = "Орган-Док МК IIX"
	desc = "Автоматический хирургически комплекс специализированный на имплантационных и трансплантационных операциях."
	id = "organdoc"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/organdoc
	category = list("Медицинское оборудование")
	sub_category = list("Автохирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
