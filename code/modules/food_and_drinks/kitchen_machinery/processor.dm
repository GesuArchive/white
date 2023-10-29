
/obj/machinery/processor
	name = "кухонный комбайн"
	desc = "Промышленный измельчитель, используемый для обработки мяса и других продуктов. Во время работы держите руки подальше от приемника."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor1"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	circuit = /obj/item/circuitboard/machine/processor
	var/broken = FALSE
	var/processing = FALSE
	var/rating_speed = 1
	var/rating_amount = 1
	var/list/processor_contents

/obj/machinery/processor/RefreshParts()
	. = ..()
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		rating_amount = B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		rating_speed = M.rating

/obj/machinery/processor/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: На выходе <b>[rating_amount]</b> предметов со скоростью <b>[rating_speed*100]%</b>.</span>"

/obj/machinery/processor/proc/process_food(datum/food_processor_process/recipe, atom/movable/what)
	if(recipe.output && loc && !QDELETED(src))
		var/list/cached_mats = recipe.preserve_materials && what.custom_materials
		var/cached_multiplier = recipe.multiplier
		for(var/i in 1 to cached_multiplier)
			var/atom/processed_food = new recipe.output(drop_location())
			if(cached_mats)
				processed_food.set_custom_materials(cached_mats, 1 / cached_multiplier)

	if(isliving(what))
		var/mob/living/themob = what
		themob.gib(TRUE,TRUE,TRUE)
	else
		qdel(what)
	LAZYREMOVE(processor_contents, what)

/obj/machinery/processor/proc/select_recipe(X)
	for (var/type in subtypesof(/datum/food_processor_process) - /datum/food_processor_process/mob)
		var/datum/food_processor_process/recipe = new type()
		if (!istype(X, recipe.input) || !istype(src, recipe.required_machine))
			continue
		return recipe

/obj/machinery/processor/attackby(obj/item/O, mob/user, params)
	if(processing)
		to_chat(user, span_warning("[capitalize(src.name)] в процессе процессирования!"))
		return TRUE
	if(default_deconstruction_screwdriver(user, "processor", "processor1", O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		return

	if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/storage/bag/tray))
		var/obj/item/storage/T = O
		var/loaded = 0
		for(var/obj/S in T.contents)
			if(!IS_EDIBLE(S))
				continue
			var/datum/food_processor_process/P = select_recipe(S)
			if(P)
				if(T.atom_storage.attempt_remove(S, src))
					LAZYADD(processor_contents, S)
					loaded++

		if(loaded)
			to_chat(user, span_notice("Закидываю [loaded] предметов в [src]."))
		return

	var/datum/food_processor_process/P = select_recipe(O)
	if(P)
		user.visible_message(span_notice("[user] закидывает [O] в [src].") , \
			span_notice("Закидываю [O] в [src]."))
		user.transferItemToLoc(O, src, TRUE)
		LAZYADD(processor_contents, O)
		return 1
	else
		if(user.a_intent != INTENT_HARM)
			to_chat(user, span_warning("Это не получится измельчить!"))
			return 1
		else
			return ..()

/obj/machinery/processor/interact(mob/user)
	if(processing)
		to_chat(user, span_warning("[capitalize(src.name)] в процессе процессирования!"))
		return TRUE
	if(user.a_intent == INTENT_GRAB && ismob(user.pulling) && select_recipe(user.pulling))
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, span_warning("Потребуется более сильный захват для этого!"))
			return
		var/mob/living/pushed_mob = user.pulling
		visible_message(span_warning("[user] запихивает [pushed_mob] в [src]!"))
		pushed_mob.forceMove(src)
		LAZYADD(processor_contents, pushed_mob)
		user.stop_pulling()
		return
	if(!LAZYLEN(processor_contents))
		to_chat(user, span_warning("[capitalize(src.name)] пуст!"))
		return TRUE
	processing = TRUE
	user.visible_message(span_notice("[user] включает [src].") , \
		span_notice("Включаю [src].") , \
		span_hear("Слышу рёв металла."))
	playsound(src.loc, 'sound/machines/blender.ogg', 50, TRUE)
	use_power(active_power_usage)
	var/total_time = 0
	for(var/O in processor_contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor doesn't have a suitable recipe. How did it get in there? Please report it immediately!!!")
			continue
		total_time += P.time
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = (total_time / rating_speed)*5) //start shaking
	sleep(total_time / rating_speed)
	for(var/atom/movable/O in processor_contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor doesn't have a suitable recipe. How do you put it in?")
			continue
		process_food(P, O)
	pixel_x = base_pixel_x //return to its spot after shaking
	processing = FALSE
	visible_message(span_notice("[capitalize(src.name)] заканчивает свою работу."))

/obj/machinery/processor/verb/eject()
	set category = "Объект"
	set name = "Изъять содержимое"
	set src in oview(1)
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_UI))
			return
	dump_inventory_contents()
	add_fingerprint(usr)

/obj/machinery/processor/dump_inventory_contents()
	. = ..()
	if(!LAZYLEN(processor_contents))
		processor_contents?.Cut()

/obj/machinery/processor/container_resist_act(mob/living/user)
	user.forceMove(drop_location())
	user.visible_message(span_notice("[user] вылезает из комбайна!"))

/obj/machinery/processor/slime
	name = "переработчик слаймов"
	desc = "Промышленный комбайн с наклейкой для научного отдела. Во время работы держите руки подальше от области забора."
	circuit = /obj/item/circuitboard/machine/processor/slime

/obj/machinery/processor/slime/adjust_item_drop_location(atom/movable/AM)
	var/static/list/slimecores = subtypesof(/obj/item/slime_extract)
	var/i = 0
	if(!(i = slimecores.Find(AM.type))) // If the item is not found
		return
	if (i <= 16) // If in the first 12 slots
		AM.pixel_x = AM.base_pixel_x - 12 + ((i%4)*8)
		AM.pixel_y = AM.base_pixel_y - 12 + (round(i/4)*8)
		return i
	var/ii = i - 16
	AM.pixel_x = AM.base_pixel_x - 8 + ((ii%3)*8)
	AM.pixel_y = AM.base_pixel_y - 8 + (round(ii/3)*8)
	return i

/obj/machinery/processor/slime/process()
	if(processing)
		return
	var/mob/living/simple_animal/slime/picked_slime
	for(var/mob/living/simple_animal/slime/slime in range(1,src))
		if(slime.loc == src)
			continue
		if(istype(slime, /mob/living/simple_animal/slime))
			if(slime.stat)
				picked_slime = slime
				break
	if(!picked_slime)
		return
	var/datum/food_processor_process/P = select_recipe(picked_slime)
	if (!P)
		return

	visible_message(span_notice("[picked_slime] всасывается в [src.name]."))
	LAZYADD(processor_contents, picked_slime)
	picked_slime.forceMove(src)

/obj/machinery/processor/slime/process_food(datum/food_processor_process/recipe, atom/movable/what)
	var/mob/living/simple_animal/slime/S = what
	if (istype(S))
		var/C = S.cores
		if(S.stat != DEAD)
			LAZYREMOVE(processor_contents, S)
			S.forceMove(drop_location())
			S.visible_message(span_notice("[C] выпрыгивает из комбайна!"))
			return
		for(var/i in 1 to (C+rating_amount-1))
			var/atom/movable/item = new S.coretype(drop_location())
			adjust_item_drop_location(item)
			SSblackbox.record_feedback("tally", "slime_core_harvested", 1, S.colour)
	..()
