/obj/item/uber_teleporter
	name = "его владения"
	desc = "Внутри нахдится ужасное чудовище которое владеет этим порталом."
	icon = 'white/valtos/icons/black_mesa/plants.dmi'
	icon_state = "crystal_pylon"

/obj/item/uber_teleporter/attack_self(mob/living/user, modifiers)
	. = ..()
	playsound(get_turf(user), 'sound/weapons/zapbang.ogg', 50, TRUE)
	var/area/area_to_teleport_to = tgui_input_list(usr, "Area to teleport to", "Teleport", GLOB.teleportlocs)
	if(!area_to_teleport_to)
		return

	var/area/teleport_area = GLOB.teleportlocs[area_to_teleport_to]

	var/list/possible_turfs = list()
	for(var/turf/iterating_turf in get_area_turfs(teleport_area.type))
		if(!iterating_turf.density)
			var/clear = TRUE
			for(var/obj/iterating_object in iterating_turf)
				if(iterating_object.density)
					clear = FALSE
					break
			if(clear)
				possible_turfs += iterating_turf

	if(!LAZYLEN(possible_turfs))
		to_chat(user, span_warning("Матрица заклинаний не смогла найти подходящее место для телепортации по неизвестной причине. Извините."))
		return

	if(user.buckled)
		user.buckled.unbuckle_mob(user, force=1)

	var/list/temp_turfs = possible_turfs
	var/attempt = null
	var/success = FALSE
	while(length(temp_turfs))
		attempt = pick(temp_turfs)
		do_teleport(user, attempt, channel = TELEPORT_CHANNEL_FREE)
		if(get_turf(user) == attempt)
			success = TRUE
			break
		else
			temp_turfs.Remove(attempt)

	if(!success)
		do_teleport(user, possible_turfs, channel = TELEPORT_CHANNEL_FREE)
		playsound(get_turf(user), 'sound/weapons/zapbang.ogg', 50, TRUE)
