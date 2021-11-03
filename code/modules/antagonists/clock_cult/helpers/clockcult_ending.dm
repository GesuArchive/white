/proc/trigger_clockcult_victory(hostile)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/clockcult_gg), 700)
	sleep(50)
	set_security_level("delta")
	priority_announce("Обнаружен огромный всплеск гравитационной энергии, исходящий от нейтронной звезды недалеко от вашего сектора. Было определено, что событие можно выжить с 0% жизни. РАСЧЕТНОЕ ВРЕМЯ, КОГДА ЭНЕРГОИМПУЛЬС ДОЙДЁТ ДО [GLOB.station_name]: 56 СЕКУНД. Успехов и слава Нанотрейзен! - Адмирал Телвиг.", "Отделение аномальных материалов Центрального командования", 'sound/misc/bloblarm.ogg')
	for(var/client/C in GLOB.clients)
		SEND_SOUND(C, sound('sound/misc/airraid.ogg', 1))
	sleep(500)
	priority_announce("Станция [GLOB.station_name] находится в во#новом %o[text2ratvar("ВЫ УВИДИТЕ СВЕТ")] неизбежном разрушении. Слава [text2ratvar(" ДВИГ'АТЕЛЮ")].","Отделение аномальных материалов Центрального командования", 'sound/machines/alarm.ogg')
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			M.client.color = COLOR_WHITE
			animate(M.client, color=LIGHT_COLOR_CLOCKWORK, time=135)
	sleep(135)
	SSshuttle.registerHostileEnvironment(hostile)
	SSshuttle.lockdown = TRUE
	for(var/mob/M in GLOB.mob_list)
		if(M.client)
			M.client.color = LIGHT_COLOR_CLOCKWORK
			animate(M.client, color=COLOR_WHITE, time=5)
			SEND_SOUND(M, sound(null))
			SEND_SOUND(M, sound('sound/magic/fireball.ogg'))
		if(!is_servant_of_ratvar(M) && isliving(M))
			var/mob/living/L = M
			L.fire_stacks = INFINITY
			L.IgniteMob()
			L.emote("agony")

	for(var/turf/closed/wall/W in world)
		W.ChangeTurf(/turf/closed/wall/clockwork, flags = CHANGETURF_DEFER_CHANGE)
		CHECK_TICK

	for(var/turf/open/floor/O in world)
		O.ChangeTurf(/turf/open/floor/clockwork, flags = CHANGETURF_DEFER_CHANGE)
		CHECK_TICK

/proc/clockcult_gg()
	SSticker.force_ending = TRUE
