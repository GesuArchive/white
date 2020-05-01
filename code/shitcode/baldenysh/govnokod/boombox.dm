/obj/item/boombox
	name = "взрыв каробка"
	desc = "пизда тваему интернет канекшону."
	icon = 'code/shitcode/valtos/icons/jukeboxes.dmi'
	icon_state = "default"
	verb_say = "констатирует"

	var/list/songs = list()
	var/datum/track/selection = null

	var/list/rangers = list()
	var/sound/bbsound = null
	var/active = FALSE
	var/env_sound = FALSE
	var/obj/item/card/music/disk
	var/playing_range = 12
	var/volume = 100
	var/bbchannel = 0

/proc/open_sound_channel_for_boombox()
	var/static/next_channel = CHANNEL_HIGHEST_AVAILABLE
	. = ++next_channel
	if(next_channel > CHANNEL_BOOMBOX_AVAILABLE)
		next_channel = CHANNEL_HIGHEST_AVAILABLE + 1

/obj/item/boombox/single
	desc = "ти гомик."

/obj/item/boombox/Initialize()
	. = ..()

	bbchannel = open_sound_channel_for_boombox()

	START_PROCESSING(SSobj, src)

	icon_state = pick("default", "tall", "neon")

	if(icon_state == "tall")
		name = "младший [name]"

	load_tracks()

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
		songs |= T

	if(songs.len)
		selection = pick(songs)

/obj/item/boombox/single/Initialize()
	. = ..()
	for(var/obj/item/boombox/single/BB) // NO WAY
		if(BB != src)
			qdel(src)

/obj/item/boombox/Del()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/boombox/process()
	if(!active)
		return

	for(var/mob/M in range(playing_range , get_turf(src)))
		if(!M.client || (M in rangers))
			continue
		rangers[M] = TRUE
		listener_inrange(M)

	for(var/mob/L in rangers)
		listener_update(L)
		if(get_dist(get_turf(src),L) > playing_range)
			rangers -= L
			if(!L || !L.client)
				continue
			listener_outofrange(L)

/obj/item/boombox/proc/listener_inrange(var/mob/M)
	if(!M.client)
		return
	for(var/sound/S in M.client.SoundQuery())
		if(S.file == bbsound.file)
			listener_update(M)
			return

	bbsound.status = SOUND_UPDATE
	SEND_SOUND(M, bbsound)

/obj/item/boombox/proc/listener_outofrange(var/mob/M)
	if(!M.client)
		return
	for(var/sound/S in M.client.SoundQuery())
		if(S.file == bbsound.file)
			S.volume = 0
			S.status = SOUND_UPDATE
			SEND_SOUND(M, S)
			return

/obj/item/boombox/proc/listener_update(var/mob/M)
	for(var/sound/S in M.client.SoundQuery())
		if(S.file == bbsound.file)
			if(env_sound)
				var/turf/T = get_turf(src)
				var/turf/MT = get_turf(M)

				S.falloff = 12
				S.y = 1
				var/dx = T.x - MT.x // Hearing from the right/left
				S.x = dx
				var/dy = T.y - MT.y // Hearing from infront/behind
				S.z = dy
			else
				S.falloff = 8
				S.x = 0
				S.y = 1
				S.z = 1

			S.volume = volume
			S.status = SOUND_UPDATE
			SEND_SOUND(M, S)
			return

/obj/item/boombox/proc/startsound()
	if(!selection)
		return
	var/sound/S = sound(selection.song_path)
	S.repeat = 1
	S.channel = bbchannel//CHANNEL_CUSTOM_JUKEBOX
	S.falloff = 8
	S.wait = 0
	S.volume = 0
	S.status = 0 //SOUND_STREAM

	S.x = 0
	S.z = 1
	S.y = 1

	bbsound = S

	for(var/mob/M) //у кого не лагает тот лох
		if(!M.client)
			continue
		SEND_SOUND(M, bbsound)

	update_icon()
	active = TRUE

/obj/item/boombox/proc/stopsound()
	for(var/mob/M)
		if(!M.client)
			continue

		for(var/sound/S in M.client.SoundQuery())
			if(S.file == bbsound.file)
				M.stop_sound_channel(bbchannel)
				break

	bbsound = null
	playsound(src,'sound/machines/terminal_off.ogg',50,1)
	update_icon()

	active = FALSE

/obj/item/boombox/proc/set_volume(var/vol)
	bbsound = vol
	for(var/mob/M in rangers)
		if(!M.client)
			continue
		listener_update(M)

/obj/item/boombox/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/music) && !disk)
		if(disk_insert(user, I, disk))
			disk = I
		return
	return ..()

/obj/item/boombox/proc/disk_insert(mob/user, obj/item/card/music/I, target)
	if(istype(I))
		if(target)
			to_chat(user, "<span class='warning'>Здесь уже есть диск!</span>")
			return FALSE
		if(!user.transferItemToLoc(I, src))
			return FALSE
		user.visible_message("<span class='notice'>[user] вставляет диск в музыкальный автомат.</span>", \
							"<span class='notice'>Вставляю диск в музыкальный автомат.</span>")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		return TRUE



/obj/item/boombox/attack_self(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/boombox/ui_interact(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !issilicon(user)))
		return

	var/list/dat = list()
	dat +="<div class='statusDisplay' style='text-align:center'>"
	dat += "<b><A href='?src=[REF(src)];action=toggle'>[!active ? "СТАРТ" : "СТОП"]<b></A><br>"
	dat += "</div><br>"
	dat += "<A href='?src=[REF(src)];action=select'> Выбрать трек</A><br>"
	dat += "<A href='?src=[REF(src)];action=volume'> Громкость</A><br>"
	dat += "<A href='?src=[REF(src)];action=env'> Объёмный звук [!env_sound ? "ВЫКЛ" : "ВКЛ"]</A><br>"

	if(selection)
		if(selection.song_name)
			dat += "<br>Трек: [selection.song_name]<br>"
		if(selection.song_length)
			dat += "Длина трека: [DisplayTimeText(selection.song_length)]<br><br>"
	if(disk)
		dat += "<br><br><br><A href='?src=[REF(src)];action=eject'>Изъять диск</A><br>"

	var/datum/browser/popup = new(user, "vending", "[name]", 400, 350)
	popup.set_content(dat.Join())
	popup.open()

/obj/item/boombox/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	switch(href_list["action"])
		if("toggle")
			if (QDELETED(src))
				return
			if(!active)
				startsound()
			else if(active)
				stopsound()

		if("select")
			var/list/available = list()
			for(var/datum/track/S in songs)
				available[S.song_name] = S

			if(disk)
				if(disk.data)
					available[disk.data.song_name] = disk.data

			var/selected = input(usr, "Выбирай мудро", "Трек:") as null|anything in available
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			if(active)
				stopsound()
			selection = available[selected]

		if("eject")
			if(disk)
				disk.loc = src.loc
				if(active)
					stopsound()
				if(selection == disk.data)
					selection = null
				disk = null

		if("volume")
			var/new_volume = input(usr, "Громкость", null) as num|null
			if(new_volume)
				set_volume(max(0, min(100, new_volume)))

		if("env")
			env_sound = !env_sound

	updateUsrDialog()
/*
/obj/item/boombox/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "BoomBox", name, 400, 350, master_ui, state)
		ui.open()

/obj/item/boombox/ui_data(mob/user)
	var/list/data = list()

	data["active"] = active
	data["disk"] = 0 disk ? 1 : 0
	data["volume"] = volume
	data["name"] = selection ? selection.song_name : "Ничего"
	data["length"] = selection ? (selection.song_length ? selection.song_length : 0) : 0
	data["env"] = env_sound

	return data

/obj/item/boombox/ui_act(action, params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("toggle")
			if(!active)
				startsound()
			else
				stopsound()

		if("select")
			var/list/available = list()
			for(var/datum/track/S in songs)
				available[S.song_name] = S

			if(disk)
				if(disk.data)
					available[disk.data.song_name] = disk.data

			var/selected = input(usr, "Выбирай мудро", "Трек:") as null|anything in available
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			if(active)
				stopsound()
			selection = available[selected]

		if("change_volume")
			var/target = text2num(params["volume"])
			set_volume(clamp(target, 0, 100))

		if("eject")
			if(disk)
				disk.forceMove(get_turf(src))
				if(active)
					stopsound()
				if(selection == disk.data)
					selection = null
				disk = null

		if("env")
			env_sound = !env_sound
*/
