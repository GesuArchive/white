/obj/item/gun/grenadelauncher
	name = "гранатомет"
	desc = "Ужасная, ужасная вещь. Действительно ужасающая!"
	icon = 'white/Feline/icons/grenadelauncher.dmi'
	icon_state = "grenadelauncher"
	inhand_icon_state = "riotgun"
	pickup_sound = 'white/Feline/sounds/Grenade_Pickup.ogg'
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 5
	fire_delay = 20
	var/list/grenades = new/list()
	var/max_grenades = 6
	var/detonation_long = TRUE
	var/detonation_delay = 5
	custom_materials = list(/datum/material/iron=2000)

/obj/item/gun/grenadelauncher/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	detonation_long = !detonation_long
	to_chat(user, span_notice("Выставляю [detonation_long ? "долгую" : "короткую"] задержку."))
	playsound(user, detonation_long ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)


/obj/item/gun/grenadelauncher/examine(mob/user)
	. = ..()
	. += "<hr>[grenades.len]/[max_grenades] гранат внутри."
	. += "<hr>Выставлена [detonation_long ? "долгая" : "короткая"] задержка."
	. += "<hr>Сбоку есть <b>Z</b>-образная скоба для извлечения гранат."

/obj/item/gun/grenadelauncher/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/grenade))
		if(grenades.len < max_grenades)
			if(!user.transferItemToLoc(I, src))
				return
			grenades += I
			to_chat(user, span_notice("Помещаю гранату в гранатомет."))
			playsound(user.loc, 'white/Feline/sounds/Grenade_Reload.ogg', 100, TRUE)
			to_chat(user, span_notice("[grenades.len]/[max_grenades] гранат."))
		else
			to_chat(usr, span_warning("Гранатомет полностью заряжен!"))

/obj/item/gun/grenadelauncher/can_shoot()
	return grenades.len

/obj/item/gun/grenadelauncher/attack_self(mob/user)
	if(grenades.len)
		var/obj/item/grenade/F = grenades[1]
		to_chat(usr, span_warning("Извлекаю гранату из гранатомета!"))
		playsound(user.loc, 'white/Feline/sounds/Grenade_Extraction.ogg', 100, TRUE)
		grenades -= F
		F.forceMove(user.loc)
		user.put_in_hands(F)

/obj/item/gun/grenadelauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)

	if(semicd)	//задержка между выстрелами
		return
	user.visible_message(span_danger("[user] выстреливает гранатой!") , \
						span_danger("Стреляю из гранатомета!"))
	var/obj/item/grenade/F = grenades[1]
	grenades -= F
	F.forceMove(user.loc)
	F.throw_at(target, 30, 2, user)
	message_admins("[ADMIN_LOOKUPFLW(user)] fired a grenade ([F.name]) from a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].")
	log_game("[key_name(user)] fired a grenade ([F.name]) with a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].")
	F.active = 1
	F.icon_state = initial(F.icon_state) + "_active"
	playsound(user.loc, 'white/Feline/sounds/Grenade_Shot.ogg', 100, TRUE)
	detonation_delay = initial(detonation_delay)
	if(detonation_long)
		detonation_delay = 30
	else
		var/obj/item/grenade/chem_grenade/I = F
		if(istype(F, /obj/item/grenade/chem_grenade))
			if(I.landminemode)
				detonation_delay = 5
			else
				detonation_delay = 15

	addtimer(CALLBACK(F, TYPE_PROC_REF(/obj/item/grenade, detonate)), detonation_delay)

	semicd = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)
