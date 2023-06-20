/**********************Jaunter**********************/
/obj/item/wormhole_jaunter
	name = "генератор Червоточин"
	desc = "Одноразовое устройство использующее древнюю технологию червоточин, Нанотрейзен перешёл на блюспейс технологии благодаря этому. Путешествовать через эти дыры не самое приятное дело.\nСпасибо за модификации от Свободных Големов, этот генератор может спасти от бездны, если находится на поясе."
	icon = 'icons/obj/mining.dmi'
	icon_state = "Jaunter"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	slot_flags = ITEM_SLOT_BELT

/obj/item/wormhole_jaunter/attack_self(mob/user)
	user.visible_message(span_notice("[user.name] activates the [src.name]!"))
	SSblackbox.record_feedback("tally", "jaunter", 1, "User") // user activated
	activate(user, TRUE)

/obj/item/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(src)
	if(!device_turf || is_centcom_level(device_turf.z) || is_reserved_level(device_turf.z))
		if(user)
			to_chat(user, span_notice("Какие-то трудности у меня с [src.name]."))
		return FALSE
	return TRUE

/obj/item/wormhole_jaunter/proc/get_destinations()
	var/list/destinations = list()

	for(var/obj/item/beacon/B in GLOB.teleportbeacons)
		var/turf/T = get_turf(B)
		if(is_station_level(T.z))
			destinations += B

	return destinations

/obj/item/wormhole_jaunter/proc/can_jaunter_teleport()
	var/list/destinations = get_destinations()
	return destinations.len > 0

/obj/item/wormhole_jaunter/proc/activate(mob/user, adjacent, teleport)
	if(!turf_check(user))
		return FALSE

	if(!can_jaunter_teleport())
		if(user)
			to_chat(user, span_notice("[capitalize(src.name)] не может найти маяков."))
		else
			visible_message(span_notice("[capitalize(src.name)] не может найти маяков!"))
		return TRUE // used for chasm code

	var/list/destinations = get_destinations()
	var/chosen_beacon = pick(destinations)

	var/obj/effect/portal/jaunt_tunnel/tunnel = new (get_turf(src), 100, null, FALSE, get_turf(chosen_beacon))
	if(teleport)
		tunnel.teleport(user)
	else if(adjacent)
		try_move_adjacent(tunnel)

	playsound(src,'sound/effects/sparks4.ogg',50,TRUE)
	qdel(src)
	return FALSE // used for chasm code


/obj/item/wormhole_jaunter/emp_act(power)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	var/triggered = FALSE
	if(power == 1)
		triggered = TRUE
	else if(power == 2 && prob(50))
		triggered = TRUE

	var/mob/M = loc
	if(istype(M) && triggered)
		M.visible_message(span_warning("[capitalize(src.name)] перегружается и активируется!"))
		SSblackbox.record_feedback("tally", "jaunter", 1, "EMP") // EMP accidental activation
		activate(M, FALSE, TRUE)
	else if(triggered)
		visible_message(span_warning("[capitalize(src.name)] перегружается и активируется!"))
		activate()

/obj/item/wormhole_jaunter/proc/chasm_react(mob/user)
	var/fall_into_chasm = activate(user, FALSE, TRUE)

	if(!fall_into_chasm)
		to_chat(user, span_notice("[capitalize(name)] активируется, спасая меня от бездны!"))
		SSblackbox.record_feedback("tally", "jaunter", 1, "Chasm") // chasm automatic activation
	return fall_into_chasm

//jaunter tunnel
/obj/effect/portal/jaunt_tunnel
	name = "червивый туннель"
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "vortex"
	desc = "Стабильная дырка. Также может привести к маяку."
	mech_sized = TRUE //save your ripley
	innate_accuracy_penalty = 6

/obj/effect/portal/jaunt_tunnel/teleport(atom/movable/M)
	. = ..()
	if(.)
		// KERPLUNK
		playsound(M,'sound/weapons/resonator_blast.ogg',50,TRUE)
		if(iscarbon(M))
			var/mob/living/carbon/L = M
			L.Paralyze(60)
			if(ishuman(L))
				shake_camera(L, 20, 1)
				addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon, vomit)), 20)
