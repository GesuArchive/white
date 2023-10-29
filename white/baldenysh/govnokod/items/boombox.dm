/obj/item/boombox
	name = "взрыв каробка"
	desc = "Магнитола, разыскиваемая в одном из соседних секторов. Почему-то пахнет малиной."
	icon = 'white/baldenysh/icons/obj/boombox.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "boombox"
	verb_say = "констатирует"
	w_class = WEIGHT_CLASS_HUGE

	var/list/songs = list()
	var/datum/track/selection = null
	var/obj/item/card/data/music/disk
	var/playing = FALSE
	var/obj/effect/music/effect
	var/obj/machinery/turntable/tt

/proc/open_sound_channel_for_boombox()
	var/static/next_channel = CHANNEL_WIND_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_BOOMBOX_AVAILABLE)
		next_channel = CHANNEL_WIND_AVAILABLE + 1

/obj/item/boombox/single
	desc = "Единственная и неповторимая."

/obj/item/boombox/Initialize(mapload)
	. = ..()
	var/datum/component/soundplayer/SP = AddComponent(/datum/component/soundplayer)
	SP.set_channel(open_sound_channel_for_boombox())
	load_tracks()
	name = "Взрыв [pick("каробка",50;"каропка",25;"коропка",10;"коробка")]"
	color = color_matrix_rotate_hue(rand(0, 360))
	effect = new
	src.vis_contents += effect

/obj/item/boombox/update_icon()
	. = ..()
	if(playing)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/boombox/proc/load_tracks()
	var/list/tracks = flist("[global.config.directory]/jukebox_music/sounds/")
	for(var/S in tracks)
		var/datum/track/T = new()
		T.song_path = file("[global.config.directory]/jukebox_music/sounds/[S]")
		var/list/L = splittext(S,"+")
		if(L.len != 3)
			continue
		T.song_name = L[1]
		T.song_length = text2num(L[2])
		T.song_beat = text2num(L[3])

		var/list/song_values = splittext(splittext(T.song_name,"\[")[2], "\] ")

		T.song_category = song_values[1]
		if(song_values[2])
			T.short_name 	= song_values[2]
		else
			T.short_name 	= T.song_name

		songs |= T
	if(songs.len)
		selection = pick(songs)

/obj/item/boombox/single/Initialize(mapload)
	. = ..()
	for(var/obj/item/boombox/single/BB) // NO WAY
		if(BB != src)
			qdel(src)

/obj/item/boombox/proc/startsound()
	if(!selection)
		return
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	SP.set_sound(sound(selection.song_path))
	SP.active = TRUE
	playing = TRUE
	update_icon()
	if(tt)
		tt.effect.play_notes()
	else
		effect.play_notes()

/obj/item/boombox/proc/stopsound()
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	SP.stop_sounds()
	playsound(get_turf(src),'sound/machines/terminal_off.ogg',50,1)
	playing = FALSE
	update_icon()
	if(tt)
		tt.effect.stop_notes()
	else
		effect.stop_notes()

/obj/item/boombox/dropped(mob/user, silent)
	. = ..()
	user.vis_contents -= effect

/obj/item/boombox/pickup(mob/user)
	. = ..()
	user.vis_contents |= effect

/obj/item/boombox/proc/toggle_env()
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	SP.environmental = !SP.environmental

/obj/item/boombox/proc/set_volume(var/vol)
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	SP.playing_volume = vol

/obj/item/boombox/attackby(obj/item/I, mob/user)
	if(disk_insert(user, I, disk))
		disk = I
		if(!selection)
			selection = disk.track
		ui_interact(user)
	return ..()

/obj/item/boombox/proc/disk_insert(mob/user, obj/item/card/data/music/I, target)
	if(istype(I))
		if(target)
			to_chat(user, span_warning("Здесь уже есть диск!"))
			return FALSE
		if(!user.transferItemToLoc(I, src))
			return FALSE
		user.visible_message(span_notice("[user] вставляет диск в [src].") , \
							span_notice("Вставляю диск в [src]."))
		playsound(get_turf(src), 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		return TRUE

/obj/item/boombox/proc/eject_disk(mob/user)
	if(disk)
		if(user)
			user.put_in_hands(disk)
		else
			disk.forceMove(get_turf(src))
		if(playing)
			stopsound()
		else
			playsound(get_turf(src), 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		if(selection == disk.track)
			selection = null
		disk = null

/obj/item/boombox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BoomBox", name)
		ui.open()

/obj/item/boombox/ui_status(mob/user)
	if(isAdminGhostAI(user))
		return UI_INTERACTIVE
	if(!isliving(user))
		return UI_UPDATE
	if(get_dist(get_turf(src), user) < 1.5)
		return UI_INTERACTIVE
	else
		return UI_CLOSE

/obj/item/boombox/ui_static_data(mob/user)
	var/list/data = list()

	data["songs"] = list()
	for(var/datum/track/S in songs)
		if(!data["songs"][S.song_category])
			data["songs"][S.song_category] = list (
				"name" 	 = S.song_category,
				"tracks" = list()
			)
		data["songs"][S.song_category]["tracks"] += list(list(
			"name" 		 = S.song_name,
			"short_name" = S.short_name,
			"length_t" 	 = S.song_length ? "[add_leading(num2text(((S.song_length / S.song_beat) / 60) % 60), 2, "0")]:[add_leading(num2text((S.song_length / S.song_beat) % 60), 2, "0")]" : "0:00"
		))

	if(disk)
		data["songs"]["DISC"] = list (
			"name" 	 = "ДИСК",
			"tracks" = list()
		)
		data["songs"]["DISC"]["tracks"] += list(list(
			"name" 		 = disk.track.song_name,
			"short_name" = disk.track.short_name,
			"length_t" 	 = "?:??"
		))

	data["disk"] = disk ? TRUE : FALSE
	data["disktrack"] = disk && disk.track ? disk.track.song_name : FALSE

	return data

/obj/item/boombox/ui_data(mob/user)
	var/list/data = list()
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	data["name"] = name
	data["active"] = playing
	data["volume"] = SP.playing_volume
	data["curtrack"] = selection && selection.short_name ? selection.short_name : FALSE
	data["curlength"] = selection && selection.song_length ? "[add_leading(num2text(((selection.song_length / selection.song_beat) / 60) % 60), 2, "0")]:[add_leading(num2text((selection.song_length / selection.song_beat) % 60), 2, "0")]" : "0:00"
	data["env"] = SP.environmental
	return data

/obj/item/boombox/ui_act(action, params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("toggle")
			if(!playing)
				startsound()
			else
				stopsound()
		if("select_track")
			var/list/available = list()
			for(var/datum/track/S in songs)
				available[S.song_name] = S
			if(disk)
				if(disk.track)
					available[disk.track.song_name] = disk.track
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			if(playing)
				stopsound()
			selection = available[selected]
		if("change_volume")
			var/target = text2num(params["volume"])
			set_volume(clamp(target, 0, 100))
		if("eject")
			eject_disk(usr)
		if("env")
			toggle_env()
	update_icon()

/obj/machinery/turntable
	name = "музыкальный автомат"
	desc = "Классический музыкальный проигрыватель."
	icon = 'white/valtos/icons/jukeboxes.dmi'
	icon_state = "default"
	verb_say = "констатирует"
	density = TRUE
	layer = ABOVE_MOB_LAYER
	var/obj/item/boombox/bbox
	var/obj/effect/music/effect

/obj/machinery/turntable/Initialize(mapload)
	. = ..()
	icon_state = pick("default", "tall", "neon", "box")
	if(icon_state == "tall")
		name = "младший [name]"
	bbox = new(src)
	bbox.name = name
	effect = new
	src.vis_contents += effect
	bbox.tt = src

/obj/machinery/turntable/Destroy()
	if(bbox)
		qdel(bbox)
	. = ..()

/obj/machinery/turntable/ui_interact(mob/user)
	bbox.ui_interact(user)

/obj/machinery/turntable/attackby(obj/item/I, mob/user)
	if(bbox.disk_insert(user, I, bbox.disk))
		bbox.disk = I
		return
	return ..()

/obj/machinery/turntable/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TRUE

/obj/machinery/turntable/donate
	desc = "Классический музыкальный проигрыватель. Пахнет помидорами."

/obj/machinery/turntable/donate/Initialize(mapload)
	. = ..()
	for(var/obj/machinery/turntable/donate/TT)
		if(TT != src)
			qdel(src)

//переделать нафиг

/obj/item/card/data/music
	icon_state = "data_3"
	var/datum/track/track
	var/uploader_ckey

/obj/machinery/musicwriter
	name = "записыватель мозговых импульсов МК-3"
	desc = "Может быть перезапущен с использованием мультитула."
	icon = 'white/valtos/icons/musicconsole.dmi'
	icon_state = "off"
	var/coin = 1
	var/mob/retard //current user
	var/writing = 0

/obj/machinery/musicwriter/examine(mob/user)
	. = ..()
	if(writing)
		. += span_notice("Можно перезагрузить <b>мультитулом</b>.")

/obj/machinery/musicwriter/attackby(obj/item/I, mob/user)
	if(default_unfasten_wrench(user, I))
		return
	if(istype(I, /obj/item/coin))
		user.dropItemToGround(I)
		qdel(I)
		coin++
		return

/obj/machinery/musicwriter/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(writing && do_after(user, 5 SECONDS, src))
		writing = 0
		to_chat(user,span_warning("Перезагружаю систему мультулом."))
		icon_state = "off"
		retard = null

/obj/machinery/musicwriter/ui_interact(mob/user)
	if (!anchored)
		to_chat(user,span_warning("Надо бы прикрутить!"))
		return
	if(!allowed(user))
		to_chat(user,span_warning("Ошибка! Нет доступа."))
		user.playsound_local(src,'sound/misc/compiler-failure.ogg', 25, 1)
		return
	if(writing)
		say("Записываем мозги [retard.name]... Подождите!")
		return
	if(!coin)
		say("Вставьте монетку.")
		return
	write(user)

/obj/machinery/musicwriter/proc/write(mob/user)
	if(!writing && !retard && coin)
		icon_state = "on"
		writing = TRUE
		retard = user
		var/N = sanitize(input("Название") as text|null)
		to_chat(user,span_warning("Надо бы прикрутить!"))
		if(N)
			var/sound/S = input("Файл") as sound|null
			if(S)
				var/datum/track/T = new()
				var/obj/item/card/data/music/disk = new(src)
				T.song_path = S
				T.song_name = N
				disk.track = T
				disk.name = "диск ([N])"
				disk.forceMove(get_turf(src))
				disk.uploader_ckey = retard.ckey
				message_admins("[ADMIN_LOOKUPFLW(user)] uploaded <A HREF='?_src_=holder;listensound=[text_ref(S)]'>sound</A> named as [N]. <A HREF='?_src_=holder;wipedata=[text_ref(disk)]'>Wipe</A> data.")
				coin--

		icon_state = "off"
		writing = FALSE
		retard = null
