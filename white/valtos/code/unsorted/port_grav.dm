/obj/item/graviton_beacon
	name = "гравитоновый маяк"
	desc = "Военный маяк, который сообщает о том, что сюда необходимо посылать гравитоны. Работает точечно и в пределе одного помещения."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "beacon"
	w_class = WEIGHT_CLASS_TINY

/obj/item/graviton_beacon/attack_self(mob/user)
	..()
	user.visible_message(span_notice("[user] активирует [src.name].") , span_notice("Активирую [src.name]."))
	playsound(src, 'sound/machines/terminal_alert.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(make_gravity)), 30)

/obj/item/graviton_beacon/proc/make_gravity()
	var/viable = FALSE

	if(isfloorturf(loc))
		viable = TRUE

	var/area/A = get_area(src.loc)
	if(istype(A, /area/space))
		viable = FALSE

	if(viable)
		playsound(src, 'sound/effects/phasein.ogg', 50, TRUE)
		var/sound/alert_sound = sound('sound/effects/alert.ogg')
		A.has_gravity = STANDARD_GRAVITY
		for(var/mob/M in A)
			M.update_gravity(M.has_gravity())
			if(M.client)
				shake_camera(M, 15, 1)
				M.playsound_local(src.loc, null, 100, 1, 0.5, sound_to_use = alert_sound)
		visible_message(span_notice("Пол начинает притягивать меня к себе!"))
		qdel(src)
	else
		playsound(src, 'white/valtos/sounds/error2.ogg', 50)

/datum/supply_pack/engineering/graviton_beacon
	name = "Гравитоновые маяки"
	desc = "Используются для создания гравитации в небольшой зоне."
	cost = BUY_CRATE_VALUE
	contains = list(/obj/item/graviton_beacon,
					/obj/item/graviton_beacon,
					/obj/item/graviton_beacon)
	crate_name = "ящик с гравитоновыми мяками"
