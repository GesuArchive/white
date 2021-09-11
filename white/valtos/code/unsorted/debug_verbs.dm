/client/proc/raspidoars()
	set name = " ? Raspidoars"
	set category = "Дбг"

	if(!check_rights(R_DEBUG))
		return

	var/turf/where = get_turf(mob)

	if(!where)
		return

	var/rss = input("Raspidoars range (Tiles):") as num

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

	if(!check_rights(R_DEBUG))
		return

	var/turf/where = get_turf(mob)

	if(!where)
		return

	var/rss = input("Ka-Boom range (Tiles):") as num

	var/list/AT = circlerange(where, rss)

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

	if(!check_rights(R_DEBUG))
		return

	var/zlevel = input("Z-Level? Пиши 0, если не понимаешь че нажал:") as num

	if(zlevel != 0)
		smooth_zlevel(zlevel, now = FALSE)
		message_admins("[ADMIN_LOOKUPFLW(usr)] запустил процесс сглаживания Z-уровня [zlevel].")
		log_admin("[key_name(usr)] запустил процесс сглаживания Z-уровня [zlevel].")

/client/proc/get_tacmap_for_test()
	set name = " ? Generate TacMap"
	set category = "Дбг"

	if(!check_rights(R_DEBUG))
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

	if(!check_rights(R_DEBUG))
		return

	GLOB.major_mode_active = !GLOB.major_mode_active

	message_admins("[ADMIN_LOOKUPFLW(usr)] переключает MAJOR MODE в положение [GLOB.major_mode_active ? "ВКЛ" : "ВЫКЛ"].")
	log_admin("[key_name(usr)] переключает MAJOR MODE в положение [GLOB.major_mode_active ? "ВКЛ" : "ВЫКЛ"].")

//legacy faggotry
/*
GLOBAL_LIST_INIT(pidorlist, world.file2list("[global.config.directory]/autoeban/pidorlist.fackuobema"))
GLOBAL_LIST_INIT(obembalist, world.file2list("[global.config.directory]/autoeban/obembalist.fackuobema"))

/client/proc/prikol_panel()
	set category = "Дбг"
	set name = "Prikol Panel"

	if(!check_rights())
		return

	var/list/menu = list("Debug Pidoras Antag", "Exile Obamka Obezyanka", "Prikol Knopka")

	var/selected = input("Main Menu", "PRIKOLPANEL V1.0") as null|anything in menu

	if(!selected)
		return

	switch(selected)
		if("Debug Pidoras Antag")
			var/list/debugmenu = list("Add Pidoras", "Remove Pidoras (rly?)", "Pidoras List")

			var/selected_debug = input("Debug Pidoras Antag", "PRIKOLPANEL V1.0") as null|anything in debugmenu

			if(!selected_debug)
				return

			switch(selected_debug)
				if("Add Pidoras")
					var/pidorasname = input("Enter Pidoras Name", ">ADD PIDORAS") as null|text

					text2file(pidorasname, "[global.config.directory]/autoeban/pidorlist.fackuobema")
					GLOB.pidorlist += pidorasname

				if("Remove Pidoras (rly?)")
					to_chat(usr,span_warning("A zachem"))
					return

				if("Pidoras List")
					for(var/pidor in GLOB.pidorlist)
						to_chat(usr, "[pidor]")

		if("Exile Obamka Obezyanka")
			var/list/exilemenu = list("Exile Obemka", "Remove Obemka", "Obemka List")

			var/selected_exile = input("Exile Obamka Obezyanka", "PRIKOLPANEL V1.0") as null|anything in exilemenu

			if(!selected_exile)
				return

			switch(selected_exile)
				if("Exile Obemka")
					var/obemkaname = input("Enter Obemka Name", ">EXILE OBEMKA") as null|text

					text2file(obemkaname, "[global.config.directory]/autoeban/obembalist.fackuobema")
					GLOB.obembalist += obemkaname

				if("Remove Obemka")
					var/nonobemkaname = input("Enter Obemka Name", ">UNEXILE OBEMKA") as null|anything in GLOB.obembalist

					if(!nonobemkaname)
						return

					GLOB.obembalist -= nonobemkaname

					fdel("[global.config.directory]/autoeban/obembalist.fackuobema")

					for(var/i in GLOB.obembalist)
						text2file(i, "[global.config.directory]/autoeban/obembalist.fackuobema")

				if("Obemka List")
					for(var/obemba in GLOB.obembalist)
						to_chat(usr, "[obemba]")

		if("Prikol Knopka")
			var/confpath = input("Enter map json file path", ">AAAAAAAA") as null|text

			if(!confpath)
				return

			var/datum/map_config/config = load_map_config(filename = confpath, default_to_box = FALSE, delete_after = FALSE, error_if_missing = TRUE)

			if(config.map_name == "Box Station")
				return

			to_chat(usr, "Map: [config.map_name]")

			SSmapping.LoadGroup(list(), config.map_name, config.map_path, config.map_file, config.traits)

			repopulate_sorted_areas()

/client/proc/proverka_na_obemky()
	if(ckey in GLOB.obembalist)
		var/list/csa = CONFIG_GET(keyed_list/cross_server)
		var/pick = pick(csa)
		var/addr = csa[pick]
		winset(src, null, "command=.options")
		src << link("[addr]?redirect=1")
		message_admins("[key] находится под санкциями и был сослан на [pick].")
*/

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

/datum/smite/valid_hunt
	name = "Valid Hunt"

/datum/smite/valid_hunt/effect(client/user, mob/living/target)
	. = ..()
	var/bounty = input("Награда в кредитах (выдавать руками пока):", "Жопа", 50) as num|null
	if(bounty)
		target.color = COLOR_RED
		target.set_light(1.4, 4, COLOR_RED, TRUE)
		priority_announce("За голову [target] назначена награда в размере [bounty] кредит[get_num_string(bounty)]. Он будет подсвечен лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')

/proc/maptick_initialize()
	var/result = call(EXTOOLS, "maptick_initialize")()
	message_admins(span_danger("ENABLING EXPERIMENTAL MAPTICK BOOST WITH RESULT OF: [result]"))
