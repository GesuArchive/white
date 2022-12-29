/obj/machinery/fat_sucker
	name = "Авто-Экстрактор липидов МК IV"
	desc = "Безопасно и эффективно удаляет лишний жир."
	icon = 'icons/obj/machines/fat_sucker.dmi'
	icon_state = "fat"
	circuit = /obj/item/circuitboard/machine/fat_sucker
	state_open = FALSE
	density = TRUE
	req_access = list(ACCESS_KITCHEN)
	var/processing = FALSE
	var/start_at = NUTRITION_LEVEL_WELL_FED
	var/stop_at = NUTRITION_LEVEL_STARVING
	var/free_exit = TRUE //set to false to prevent people from exiting before being completely stripped of fat
	var/bite_size = 7.5 //amount of nutrients we take per second
	var/nutrients //amount of nutrients we got build up
	var/nutrient_to_meat = 90 //one slab of meat gives about 52 nutrition
	var/datum/looping_sound/microwave/soundloop //100% stolen from microwaves
	var/breakout_time = 600

	var/next_fact = 10 //in ticks, so about 20 seconds
	var/static/list/fat_facts = list(\
	"Жиры - это триглицериды, состоящие из комбинации различных строительных блоков; глицерин и жирные кислоты.", \
	"Взрослые должны получать 20-35% своей калорийности из жиров.", \
	"Избыточный вес или ожирение подвергают вас повышенному риску хронических заболеваний, таких как сердечно-сосудистые заболевания, метаболический синдром, диабет 2 типа и некоторые виды рака.", \
	"Не все жиры плохие. Определенное количество жира - важная часть здорового сбалансированного питания. " , \
	"Насыщенные жиры должны составлять не более 11% ваших ежедневных калорий.", \
	"Ненасыщенные жиры, то есть мононенасыщенные жиры, полиненасыщенные жиры и жирные кислоты омега-3, содержатся в растительной пище и рыбе." \
	)

/obj/machinery/fat_sucker/Initialize(mapload)
	. = ..()
	soundloop = new(src,  FALSE)
	update_icon()

/obj/machinery/fat_sucker/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/fat_sucker/RefreshParts()
	. = ..()
	var/rating = 0
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		rating += L.rating
	bite_size = initial(bite_size) + rating * 2.5
	nutrient_to_meat = initial(nutrient_to_meat) - rating * 5

/obj/machinery/fat_sucker/examine(mob/user)
	. = ..()
	. += {"<hr><span class='notice'>ПКМ для разблокировки или блокировки люка.</span>
				<span class='notice'>Удаляем [bite_size] единиц питательных веществ за операцию.</span>
				<span class='notice'>Требует [nutrient_to_meat] единиц питательных веществ на кусок мяса.</span>"}

/obj/machinery/fat_sucker/close_machine(mob/user)
	if(panel_open)
		to_chat(user, span_warning("Нужно закрыть техническую панель сначала!"))
		return
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(occupant)
		if(!iscarbon(occupant))
			occupant.forceMove(drop_location())
			set_occupant(null)
			return
		to_chat(occupant, span_notice("Вхожу в [src.name]."))
		addtimer(CALLBACK(src, PROC_REF(start_extracting)), 20, TIMER_OVERRIDE|TIMER_UNIQUE)
		update_icon()

/obj/machinery/fat_sucker/open_machine(mob/user)
	make_meat()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(processing)
		stop()
	..()

/obj/machinery/fat_sucker/container_resist_act(mob/living/user)
	if(!free_exit || state_open)
		to_chat(user, span_notice("Аварийный выход не работает! СЕЙЧАС БУДУ ЛОМАТЬ ЭТО ВСЁ!!!"))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		user.visible_message(span_notice("[user] пытается выломать дверь [src.name]!") , \
			span_notice("Упираюсь в стенку [src.name] и начинаю выдавливать дверь... (это займёт примерно [DisplayTimeText(breakout_time)].)") , \
			span_hear("Слышу металлический стук исходящий из [src.name]."))
		if(do_after(user, breakout_time, target = src))
			if(!user || user.stat != CONSCIOUS || user.loc != src || state_open)
				return
			free_exit = TRUE
			user.visible_message(span_warning("[user] успешно вырывается из [src.name]!") , \
				span_notice("Успешно вырываюсь из [src.name]!"))
			open_machine()
		return
	open_machine()

/obj/machinery/fat_sucker/interact(mob/user)
	if(state_open)
		close_machine()
	else if(!processing || free_exit)
		open_machine()
	else
		to_chat(user, span_warning("Люк отключен!"))

/obj/machinery/fat_sucker/AltClick(mob/living/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(user == occupant)
		to_chat(user, span_warning("Не могу достать до панели управления изнутри!"))
		return
	if(!(obj_flags & EMAGGED) && !allowed(user))
		to_chat(user, span_warning("Доступ не подходит."))
		return
	free_exit = !free_exit
	to_chat(user, span_notice("Люк [free_exit ? "разблокирован" : "заблокирован"]."))

/obj/machinery/fat_sucker/update_overlays()
	. = ..()

	if(!state_open)
		if(processing)
			. += "[icon_state]_door_on"
			. += "[icon_state]_stack"
			. += "[icon_state]_smoke"
			. += "[icon_state]_green"
		else
			. += "[icon_state]_door_off"
			if(occupant)
				if(powered())
					. += "[icon_state]_stack"
					. += "[icon_state]_yellow"
			else
				. += "[icon_state]_red"
	else if(powered())
		. += "[icon_state]_red"
	if(panel_open)
		. += "[icon_state]_panel"

/obj/machinery/fat_sucker/process(delta_time)
	if(!processing)
		return
	if(!powered() || !occupant || !iscarbon(occupant))
		open_machine()
		return

	var/mob/living/carbon/C = occupant
	if(C.nutrition <= stop_at)
		open_machine()
		playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
		return
	C.adjust_nutrition(-bite_size * delta_time)
	nutrients += bite_size * delta_time

	if(next_fact <= 0)
		next_fact = initial(next_fact)
		say(pick(fat_facts))
		playsound(loc, 'sound/machines/chime.ogg', 30, FALSE)
	else
		next_fact--
	use_power(active_power_usage)

/obj/machinery/fat_sucker/proc/start_extracting()
	if(state_open || !occupant || processing || !powered())
		return
	if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		if(C.nutrition > start_at)
			processing = TRUE
			soundloop.start()
			update_icon()
			set_light(2, 1, "#ff0000")
		else
			say("Пациент недостаточно жирный.")
			playsound(src, 'white/valtos/sounds/error1.ogg', 40, FALSE)
			overlays += "[icon_state]_red" //throw a red light icon over it, to show that it won't work

/obj/machinery/fat_sucker/proc/stop()
	processing = FALSE
	soundloop.stop()
	set_light(0, 0)

/obj/machinery/fat_sucker/proc/make_meat()
	if(occupant && iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		if(C.type_of_meat)
			if(nutrients >= nutrient_to_meat * 2)
				C.put_in_hands(new /obj/item/food/cookie, del_on_fail = TRUE)
			while(nutrients >= nutrient_to_meat)
				nutrients -= nutrient_to_meat
				var/atom/meat = new C.type_of_meat (drop_location())
				meat.set_custom_materials(list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, C) = MINERAL_MATERIAL_AMOUNT * 4))
			while(nutrients >= nutrient_to_meat / 3)
				nutrients -= nutrient_to_meat / 3
				var/atom/meat = new /obj/item/food/meat/rawcutlet/plain (drop_location())
				meat.set_custom_materials(list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, C) = round(MINERAL_MATERIAL_AMOUNT * (4/3))))
			nutrients = 0

/obj/machinery/fat_sucker/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, span_warning("[capitalize(src.name)] уже занят!"))
		return
	if(state_open)
		to_chat(user, span_warning("[capitalize(src.name)] имеет [panel_open ? "закрытую" : "открытую"] техническую панель!"))
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	return FALSE

/obj/machinery/fat_sucker/crowbar_act(mob/living/user, obj/item/I)
	if(default_deconstruction_crowbar(I))
		return TRUE

/obj/machinery/fat_sucker/emag_act(mob/living/user)
	if(obj_flags & EMAGGED)
		return
	start_at = 100
	stop_at = 0
	to_chat(user, span_notice("Снимаю ограничения доступа и понижаю порог автоматического выброса!"))
	obj_flags |= EMAGGED
