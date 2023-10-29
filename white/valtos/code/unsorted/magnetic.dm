/obj/item/circuitboard/machine/magnetic_concentrator
	name = "Магнитный Концентратор (Оборудование)"
	build_path = /obj/machinery/magnetic_concentrator
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 4,
		/obj/item/stock_parts/manipulator = 1)

/obj/machinery/magnetic_concentrator
	name = "магнитный концентратор"
	desc = "Если не вдаваться в технические подробности, то это самый обычный магнит. Требует излучатели для работы."
	icon = 'white/valtos/icons/power.dmi'
	icon_state = "magnetic_concentrator"

	density = TRUE
	anchored = FALSE

	circuit = /obj/item/circuitboard/machine/magnetic_concentrator

	var/magpower = 0
	var/maxmagpower = 120
	var/obj/singularity/hooked_singulo

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION

/obj/machinery/magnetic_concentrator/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Сила магнитного притяжения [magpower]/[maxmagpower] единиц Теслы.</span>"
	if(hooked_singulo)
		. += "<hr><span class='notice'><b>Уровень сингулярности:</b> [hooked_singulo.current_size]/[hooked_singulo.allowed_size].</span>\n"
		. += "<hr><span class='notice'><b>Энергия:</b> [hooked_singulo.energy].</span>"

/obj/machinery/magnetic_concentrator/RefreshParts()
	. = ..()
	var/t = 0
	for(var/obj/item/stock_parts/L in component_parts)
		t += L.rating * 20
	maxmagpower = t

/obj/machinery/magnetic_concentrator/update_icon_state()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	luminosity = 0
	if(magpower > 1)
		luminosity = 1
		SSvis_overlays.add_vis_overlay(src, icon, "magnetic_concentrator_overlay", plane = ABOVE_LIGHTING_PLANE, dir = src.dir, alpha = src.alpha)

/obj/machinery/magnetic_concentrator/bullet_act(obj/projectile/Proj)
	if(Proj.flag != BULLET)
		magpower = min(magpower + Proj.damage, maxmagpower)
		update_icon()
	. = ..()

/obj/machinery/magnetic_concentrator/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		default_unfasten_wrench(user, I, time = 20)
	else
		. = ..()

/obj/machinery/magnetic_concentrator/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/magnetic_concentrator/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/machinery/magnetic_concentrator/singularity_pull(S, current_size)
	return

/obj/machinery/magnetic_concentrator/process()
	if(!hooked_singulo && magpower > 1)
		for(var/obj/singularity/S in orange(6, src))
			hooked_singulo = S
			hooked_singulo.forceMove(get_turf(src))
			hooked_singulo.alpha = 200
			visible_message(span_warning("[capitalize(src.name)] цапает сингулярность!"))
			qdel(hooked_singulo.singularity_component)
	else if (hooked_singulo)
		if(magpower > 1)
			magpower -= hooked_singulo.current_size * 3
			hooked_singulo.forceMove(get_turf(src))
			for (var/_tile in spiral_range_turfs(hooked_singulo.current_size, src))
				var/turf/tile = _tile
				if (!tile || !isturf(loc))
					continue
				if(tile == get_turf(src))
					continue
				if (get_dist(tile, src) > 1)
					tile.singularity_pull(src, hooked_singulo.current_size)
				for (var/_thing in tile)
					var/atom/thing = _thing
					if (QDELETED(thing))
						continue
					if (isturf(loc) && thing != src && thing != hooked_singulo)
						var/atom/movable/movable_thing = thing
						if (get_dist(movable_thing, src) > 1)
							movable_thing.singularity_pull(src, hooked_singulo.current_size)
						else
							hooked_singulo.consume(movable_thing)
					CHECK_TICK
		else
			hooked_singulo.be_free()
			hooked_singulo.alpha = 255
			hooked_singulo = null

/obj/item/circuitboard/machine/meteor_catcher
	name = "улавливатель метеоритов"
	desc = "Создаёт небольшое гравитационное поле вокруг себя, которое позволяет притягивать метеоры. Используйте мультитул для смены режима."
	build_path = /obj/machinery/meteor_catcher
	req_components = list(/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/machinery/meteor_catcher
	name = "улавливатель метеоритов"
	desc = "Создаёт небольшое гравитационное поле вокруг себя, которое позволяет притягивать метеоры. Используйте мультитул для смены режима."
	icon = 'white/valtos/icons/power.dmi'
	icon_state = "beacon_off"

	processing_flags = START_PROCESSING_MANUALLY

	density = TRUE
	anchored = TRUE

	circuit = /obj/item/circuitboard/machine/meteor_catcher
	var/catch_power = 5
	var/last_catch = 0
	var/list/enslaved_meteors = list()
	var/asteroid_mode = FALSE
	var/asteroid_catched = FALSE
	var/asteroid_catching = FALSE
	var/asteroid_catch_time = 600 SECONDS
	var/last_err = "ГОТОВ К РАБОТЕ"
	var/list/valid_turfs = list()
	var/list/ripples = list()

/obj/machinery/meteor_catcher/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'><b>Режим:</b> [asteroid_mode ? "АСТЕРОИДЫ" : "МЕТЕОРЫ"].</span>"
	if(asteroid_mode)
		. += span_notice("\nЛовит объекты размером максимум <b>[catch_power] метров</b>.")
		if(asteroid_catching)
			if(!asteroid_catched)
				. += span_notice("\nВремя до прилёта объекта <b>[DisplayTimeText(asteroid_catch_time / catch_power)]</b>.")
			else
				. += span_notice("\nВремя до отправки объекта <b>[DisplayTimeText(asteroid_catch_time / catch_power)]</b>.")
		. += span_notice("\n<b>Последняя ошибка:</b> [last_err].")
	else
		. += span_notice("\nЛовит максимум <b>[catch_power] метеоров</b>.")


/obj/machinery/meteor_catcher/RefreshParts()
	. = ..()
	var/t = 0
	for(var/obj/item/stock_parts/L in component_parts)
		t += L.rating
	catch_power = t

/obj/machinery/meteor_catcher/attackby(obj/item/I, mob/living/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(asteroid_catching)
		to_chat(user, span_warning("<b>[capitalize(src.name)]</b> занят!"))
		return FALSE
	if(I.tool_behaviour == TOOL_WRENCH)
		if(default_unfasten_wrench(user, I, time = 20) == SUCCESSFUL_UNFASTEN)
			if(anchored)
				icon_state = "beacon_off"
			else
				icon_state = "beacon"
				STOP_PROCESSING(SSobj, src)
			return
	if(I.tool_behaviour == TOOL_MULTITOOL)
		to_chat(user, span_warning("Меняю режим."))
		STOP_PROCESSING(SSobj, src)
		asteroid_mode = !asteroid_mode
		return

	if(user.a_intent != INTENT_HARM && !(I.item_flags & NOBLUDGEON))
		return attack_hand(user)
	else
		return ..()

/obj/machinery/meteor_catcher/attack_hand(mob/living/user)
	. = ..()
	if(anchored)
		if(asteroid_catching)
			to_chat(user, span_warning("<b>[capitalize(src.name)]</b> занят!"))
			return
		if(asteroid_catched)
			user.visible_message(span_notice("<b>[user]</b> включает <b>[src.name]</b>.") , \
						span_notice("Включаю <b>[src.name]</b>.") , \
						span_hear("Слышу тяжёлое жужжание."))
			START_PROCESSING(SSobj, src)
			icon_state = "beacon_on"
			return
		if(!(datum_flags & DF_ISPROCESSING))
			user.visible_message(span_notice("<b>[user]</b> включает <b>[src.name]</b>.") , \
						span_notice("Включаю <b>[src.name]</b>.") , \
						span_hear("Слышу тяжёлое жужжание."))
			START_PROCESSING(SSobj, src)
			icon_state = "beacon_on"
		else
			user.visible_message(span_notice("<b>[user]</b> выключает <b>[src.name]</b>.") , \
						span_notice("Выключаю <b>[src.name]</b>.") , \
						span_hear("Слышу утихающее жужжание."))
			STOP_PROCESSING(SSobj, src)
			icon_state = "beacon_off"
	else
		to_chat(user, span_warning("<b>[capitalize(src.name)]</b> должен быть закреплён на полу!"))

/obj/machinery/meteor_catcher/process()
	if(!anchored)
		icon_state = "beacon"
		last_err = "НЕТ ОПОРЫ"
		return PROCESS_KILL

	if(asteroid_mode)
		if(asteroid_catched)
			if(!asteroid_catching)
				for(var/T in valid_turfs)
					ripples += new /obj/effect/abstract/ripple(T, null, asteroid_catch_time / catch_power)
				asteroid_catching = TRUE
			asteroid_catch_time -= (10 * catch_power) * 2
			if(asteroid_catch_time <= 0)
				for(var/turf/T in valid_turfs)
					if(T.z == 2)
						T.ChangeTurf(/turf/open/space)
					else
						T.ChangeTurf(/turf/open/space/openspace)
					for(var/atom/A in T)
						if(isobj(A))
							qdel(A)
				asteroid_catched = FALSE
				asteroid_catch_time = 600 SECONDS
				asteroid_catching = FALSE
				icon_state = "beacon_off"
				QDEL_LIST(ripples)
				last_err = "ГОТОВ К РАБОТЕ"
				return PROCESS_KILL
			return
		if(!asteroid_catching)
			var/turf/point
			var/turf/target
			switch(dir)
				if(WEST)
					target = locate(1,y,z)
					point = locate(x - (catch_power + 1),y,z)
				if(EAST)
					target = locate(world.maxx,y,z)
					point = locate(x + (catch_power + 1),y,z)
				if(NORTH)
					target = locate(x,world.maxy,z)
					point = locate(x,y + (catch_power + 1),z)
				if(SOUTH)
					target = locate(x,1,z)
					point = locate(x,y - (catch_power + 1),z)
			for(var/T in get_line(get_step(point, dir), target))
				var/turf/tile = T
				if(isclosedturf(tile))
					Beam(tile, icon_state = "nzcrentrs_power", time = 5 SECONDS)
					icon_state = "beacon_off"
					last_err = "ЧТО-ТО МАССИВНОЕ НА ПУТИ. ОТМЕНА"
					return PROCESS_KILL
			valid_turfs.Cut()
			for(var/T in circle_view_turfs(point, round(catch_power * 0.75)))
				if(isopenspace(T) || isspaceturf(T))
					valid_turfs += T
				else
					new /obj/effect/particle_effect/sparks/quantum(T)
					icon_state = "beacon_off"
					last_err = "НЕДОСТАТОЧНО МЕСТА ДЛЯ АКТИВАЦИИ ЗАХВАТА. ОТМЕНА"
					return PROCESS_KILL
			for(var/T in valid_turfs)
				ripples += new /obj/effect/abstract/ripple(T, null, asteroid_catch_time / catch_power)
			Beam(target, icon_state = "nzcrentrs_power", time = asteroid_catch_time / catch_power, maxdistance = world.maxx)
			asteroid_catching = TRUE
			icon_state = "beacon_on"
			return
		if(!asteroid_catched)
			asteroid_catch_time -= (10 * catch_power) * 2
			if(asteroid_catch_time <= 0)
				for(var/turf/T in valid_turfs)
					if(prob(90))
						T.ChangeTurf(/turf/closed/mineral/random, /turf/open/floor/plating/asteroid)
					else
						T.ChangeTurf(/turf/open/floor/plating/asteroid, /turf/open/floor/plating/asteroid)
				asteroid_catched = TRUE
				asteroid_catch_time = 600 SECONDS
				asteroid_catching = FALSE
				icon_state = "beacon_off"
				QDEL_LIST(ripples)
				last_err = "ГОТОВ К РАБОТЕ"
				return PROCESS_KILL
		return
	else
		for(var/obj/O in enslaved_meteors)
			if(QDELETED(O))
				enslaved_meteors -= O

		if(enslaved_meteors.len < catch_power)
			if(last_catch < world.time + 1200 / catch_power)
				var/turf/T = pick(RANGE_TURFS(5, src.loc))
				if((locate(/obj/effect/meteor) in T.contents) || (!isopenspace(T) && !isspaceturf(T)))
					return
				var/obj/meteor_to = pick(typesof(/obj/effect/meteor) - /obj/effect/meteor/pumpkin - /obj/effect/meteor/meaty - /obj/effect/meteor/meaty/xeno)
				var/obj/effect/meteor/M = new meteor_to(T)
				last_catch = world.time
				enslaved_meteors += M
				visible_message(span_notice("В магнитный захват улавливателя попадает <b>[M]</b>."))
				Beam(get_turf(M), icon_state = "nzcrentrs_power", time = 5 SECONDS)
				return
		else
			icon_state = "beacon_off"
			return
