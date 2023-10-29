
/obj/machinery/food_cart
	name = "продуктовая тележка"
	desc = "Компактная мобильная тележка для раздачи еды в любой части станции. Вау!"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "foodcart"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	req_access = list(ACCESS_KITCHEN)
	flags_1 = NODECONSTRUCT_1
	var/unpacked = FALSE
	var/obj/machinery/griddle/stand/cart_griddle
	var/obj/machinery/smartfridge/food/cart_smartfridge
	var/obj/structure/table/reinforced/cart_table
	var/obj/effect/food_cart_stand/cart_tent
	var/list/packed_things

/obj/machinery/food_cart/Initialize(mapload)
	. = ..()
	cart_griddle = new(src)
	cart_smartfridge = new(src)
	cart_table = new(src)
	cart_tent = new(src)
	packed_things = list(cart_table, cart_smartfridge, cart_tent, cart_griddle) //middle, left, left, right
	RegisterSignal(cart_griddle, COMSIG_PARENT_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_smartfridge, COMSIG_PARENT_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_table, COMSIG_PARENT_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_tent, COMSIG_PARENT_QDELETING, PROC_REF(lost_part))

/obj/machinery/food_cart/Destroy()
	/*
	if(cart_griddle)
		QDEL_NULL(cart_griddle)
	if(cart_smartfridge)
		QDEL_NULL(cart_smartfridge)
	if(cart_table)
		QDEL_NULL(cart_table)
	if(cart_tent)
		QDEL_NULL(cart_tent)
	packed_things.Cut()
	*/
	return ..()

/obj/machinery/food_cart/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		if(cart_griddle.machine_stat & BROKEN)
			. += "<hr>[span_warning("<b>Гридль</b> полностью сломан сломан!")]"
		else
			. += "<hr>[span_notice("<b>Гридль</b> в порядке.")]"
		. += span_notice("\n<b>Холодильник</b> в порядке.") //weirdly enough, these fridges don't break
		. += span_notice("\n<b>Стол</b> в порядке.")

/obj/machinery/food_cart/proc/pack_up()
	if(!unpacked)
		return
	visible_message(span_notice("[src] собирается обратно в компактную форму."))
	for(var/o in packed_things)
		var/obj/object = o
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	anchored = FALSE
	unpacked = FALSE

/obj/machinery/food_cart/proc/unpack(mob/user)
	if(unpacked)
		return
	if(!check_setup_place())
		to_chat(user, span_warning("Здесь недостаточно места для того, чтобы разложить тележку."))
		return
	visible_message(span_notice("[capitalize(src)] раскладывается."))
	anchored = TRUE
	var/iteration = 1
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		var/obj/thing = packed_things[iteration]
		thing.forceMove(T)
		RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(lost_part))
		iteration++
	unpacked = TRUE

/obj/machinery/food_cart/attack_hand(mob/living/user)
	. = ..()
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[src] полностью сломана!"))
		return
	var/obj/item/card/id/id_card = user.get_idcard(hand_first = TRUE)
	if(!check_access(id_card))
		playsound(src, 'white/valtos/sounds/error1.ogg', 30, TRUE)
		return
	to_chat(user, span_notice("Я пытаюсь [unpacked ? "собрать" :"разложить"] продуктовую тележку..."))
	if(!do_after(user, 5 SECONDS, src))
		if(unpacked)
			to_chat(user, span_warning("Распакова тележки была прервана!"))
			return
		to_chat(user, span_warning("Сборка тележки была прервана!"))
		return
	if(unpacked)
		pack_up()
	else
		unpack(user)

/obj/machinery/food_cart/proc/check_setup_place()
	var/has_space = TRUE
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		if(T && !T.density)
			new /obj/effect/temp_visual/cart_space(T)
		else
			has_space = FALSE
			new /obj/effect/temp_visual/cart_space/bad(T)
	return has_space

/obj/machinery/food_cart/proc/lost_part(atom/movable/source, force)
	SIGNAL_HANDLER

	//okay, so it's deleting the fridge or griddle which are more important. We're gonna break the machine then
	UnregisterSignal(cart_griddle, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_smartfridge, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_table, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_tent, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	obj_break()

/obj/machinery/food_cart/obj_break(damage_flag)
	. = ..()
	pack_up()
	if(cart_griddle)
		QDEL_NULL(cart_griddle)
	if(cart_smartfridge)
		QDEL_NULL(cart_smartfridge)
	if(cart_table)
		QDEL_NULL(cart_table)
	QDEL_NULL(cart_tent)

/obj/effect/food_cart_stand
	name = "навес"
	desc = "Хоть что-то для борьбы с солнцем, ведь у повара нет обеда."
	icon = 'icons/obj/3x3.dmi'
	icon_state = "stand"
	layer = ABOVE_MOB_LAYER//big mobs will still go over the tent, this is fine and cool
	plane = GAME_PLANE_UPPER
