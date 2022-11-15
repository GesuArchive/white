/client/proc/commit_warcrime()
	set name = " ? Commit Warcrime"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	message_admins("[ADMIN_LOOKUPFLW(usr)] делает всякое!")
	log_admin("[key_name(usr)] makes warcrime.")

	for(var/client/C in GLOB.clients)
		C.dir = pick(GLOB.cardinals)
		C.change_view("15x15", TRUE)
		C.mob.add_client_colour(/datum/client_colour/ohfuckrection)
		C.mob.overlay_fullscreen("fuckoise", /atom/movable/screen/fullscreen/noisescreen)
		to_chat(C, span_revenbignotice("Было совершено военное преступление."))

/client/proc/uncommit_warcrime()
	set name = " ? UnCommit Warcrime"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	message_admins("[ADMIN_LOOKUPFLW(usr)] не делает всякое!")
	log_admin("[key_name(usr)] unmakes warcrime.")

	for(var/client/C in GLOB.clients)
		C.dir = NORTH
		C.change_view("19x15", TRUE)
		C.mob.remove_client_colour(/datum/client_colour/ohfuckrection)
		C.mob.clear_fullscreen("fuckoise")
		to_chat(C, span_revenbignotice("Военных преступлений не было."))

/client/proc/raspidoars()
	set name = " ? Raspidoars"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return



	var/rss = input("Raspidoars range (Tiles):") as num
	var/turf/where = get_turf(mob)
	if(!where)
		to_chat(usr, span_userwarning("Null loc, what the fuck?"))
		return
	message_admins("[ADMIN_LOOKUPFLW(usr)] жмёт на всякое!")
	log_admin("[key_name(usr)] uses raspidoars.")

	for(var/atom/A in spiral_range(rss, where))
		if(isturf(A) || isobj(A) || ismob(A))
			playsound(where, 'white/valtos/sounds/bluntcreep.ogg', 100, TRUE, rss)
			var/matrix/M = A.transform
			M.Scale(rand(1, 2), rand(1, 2))
			M.Translate(rand(-2, 2), rand(-2, 2))
			M.Turn(rand(-90, 90))
			A.color = "#[random_short_color()]"
			animate(A, color = color_matrix_rotate_hue(rand(0, 360)), time = rand(200, 500), easing = CIRCULAR_EASING, flags = ANIMATION_PARALLEL)
			animate(A, transform = M, time = rand(200, 1000), flags = ANIMATION_PARALLEL)
			sleep(pick(0.3, 0.5, 0.7))

/client/proc/kaboom()
	set name = " ? Ka-Boom"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	var/turf/where = get_turf(mob)

	if(!where)
		return

	var/rss = input("Ka-Boom range (Tiles):") as num

	message_admins("[ADMIN_LOOKUPFLW(usr)] жмёт на КА-БУМ!")
	log_admin("[key_name(usr)] uses Ka-Boom.")

	var/list/AT = circle_range(where, rss)

	var/x0 = where.x
	var/y0 = where.y

	for(var/atom/A in AT)
		var/dist = max(1, cheap_hypotenuse(A.x, A.y, x0, y0))

		var/matrix/M = A.transform
		M.Scale(2, 2)
		spawn(dist*1.5)
			animate(A, transform = M, time = 3, easing = QUAD_EASING)
			animate(transform = null, time = 3, easing = QUAD_EASING)

/client/proc/smooth_fucking_z_level()
	set name = " ? Smooth Z-Level"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	var/zlevel = input("Z-Level? Пиши 0, если не понимаешь че нажал:") as num

	if(zlevel != 0)
		smooth_zlevel(zlevel, now = FALSE)
		message_admins("[ADMIN_LOOKUPFLW(usr)] запустил процесс сглаживания Z-уровня [zlevel].")
		log_admin("[key_name(usr)] запустил процесс сглаживания Z-уровня [zlevel].")

/client/proc/get_tacmap_for_test()
	set name = " ? Generate TacMap"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	var/fuckz = input("З-уровень") as num

	if(!fuckz || fuckz > world.maxz)
		to_chat(usr, span_adminnotice(" !! RETARD !! "))
		return

	message_admins("[ADMIN_LOOKUPFLW(usr)] запустил генерацию миникарты Z-уровня [fuckz].")
	log_admin("[key_name(usr)] запустил генерацию миникарты Z-уровня [fuckz].")

	spawn(0)
		var/icon/I = gen_tacmap(fuckz)
		usr << browse_rsc(I, "tacmap[fuckz].png")
		to_chat(usr, span_adminnotice("Ваша овсянка, сер:"))
		to_chat(usr, "<img src='tacmap[fuckz].png'>")

/client/proc/toggle_major_mode()
	set name = " ? Переключить ММ (тест)"
	set category = "Дбг"

	if(!check_rights(R_SECURED))
		return

	GLOB.major_mode_active = !GLOB.major_mode_active

	message_admins("[ADMIN_LOOKUPFLW(usr)] переключает MAJOR MODE в положение [GLOB.major_mode_active ? "ВКЛ" : "ВЫКЛ"].")
	log_admin("[key_name(usr)] переключает MAJOR MODE в положение [GLOB.major_mode_active ? "ВКЛ" : "ВЫКЛ"].")

/client/verb/roundstatus()
	set name = "Статус раунда"
	set category = null

	var/round_time = world.time - SSticker.round_start_time

	var/list/data_list = list(
		"Карта: [SSmapping.config?.map_name || "Загрузка..."]",
		SSmapping.next_map_config ? "Следующая: [SSmapping.next_map_config.map_name]" : null,
		"ID раунда: [GLOB.round_id ? GLOB.round_id : "NULL"]",
		"Серверное время: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
		"Длительность раунда: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[worldtime2text()]" : worldtime2text()]",
		"Время на станции: [station_time_timestamp()]",
		"Замедление времени: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)"
	)

	var/data_to_send = jointext(data_list, "\n")
	to_chat(src, span_notice("\n[data_to_send]\n"))

/client/proc/change_lobby_music()
	set category = "Особенное"
	set name = "Change TM"
	set desc = "Fucky"

	if(!check_rights(R_FUN))
		return

	var/msg = input(src, null, "Enter ze paff") as sound|null
	if(!msg)
		return

	SSticker.login_music = sound(msg)

	message_admins(span_danger("[ADMIN_LOOKUPFLW(usr)] меняет лобби-трек на: [msg]"))
	log_admin("[key_name(usr)] changes lobby music to [msg].")

	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()
