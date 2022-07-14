/obj/item/gun/grenadelauncher
	name = "гранатомет"
	desc = "Ужасная, ужасная вещь. Действительно ужасающая!"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "riotgun"
	inhand_icon_state = "riotgun"
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 5
	var/list/grenades = new/list()
	var/max_grenades = 6
	var/detonation_delay = 5
	custom_materials = list(/datum/material/iron=2000)

/obj/item/gun/grenadelauncher/examine(mob/user)
	. = ..()
	. += "<hr>[grenades.len]/[max_grenades] гранат внутри."

/obj/item/gun/grenadelauncher/attackby(obj/item/I, mob/user, params)

	if((istype(I, /obj/item/grenade)))
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

/obj/item/gun/grenadelauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
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
	addtimer(CALLBACK(F, /obj/item/grenade.proc/detonate), detonation_delay)
