/obj/machinery/turntable
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
//	req_access = list(ACCESS_BAR)
	var/active = FALSE
	var/list/rangers = list()
	var/stop = 0
	var/list/songs = list()
	var/datum/track/selection = null
	var/obj/item/card/music/disk
	var/playing_range = 12

/*
/datum/track
	var/song_name = "generic"
	var/song_path = null
	var/song_length = 0
	var/song_beat = 0

/datum/track/New(name, path, length, beat)
	song_name = name
	song_path = path
	song_length = length
	song_beat = beat
*/

/obj/machinery/turntable/Initialize()
	. = ..()
	var/list/tracks = flist("config/jukebox_music/sounds/")

	for(var/S in tracks)
		var/datum/track/T = new()
		T.song_path = file("config/jukebox_music/sounds/[S]")
		var/list/L = splittext(S,"+")
		if(L.len != 3)
			continue
		T.song_name = L[1]
		T.song_length = text2num(L[2])
		T.song_beat = text2num(L[3])
		songs |= T

	if(songs.len)
		selection = pick(songs)

/obj/machinery/turntable/Destroy()
	dance_over()
	return ..()

/obj/machinery/turntable/process()
	if(!selection)
		return

	var/sound/song_played = sound(selection.song_path)

	for(var/mob/M in range(playing_range,src))
		if(!M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue
		if(!(M in rangers))
			rangers[M] = TRUE
			M.playsound_local(get_turf(M), null, 100, channel = CHANNEL_JUKEBOX, S = song_played)
	for(var/mob/L in rangers)
		if(get_dist(src,L) > playing_range)
			rangers -= L
			if(!L || !L.client)
				continue
			L.stop_sound_channel(CHANNEL_JUKEBOX)
	/*
	if(world.time < stop && active)
		var/sound/song_played = sound(selection.song_path)

		for(var/mob/M in range(10,src))
			if(!M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				continue
			if(!(M in rangers))
				rangers[M] = TRUE
				M.playsound_local(get_turf(M), null, 100, channel = CHANNEL_JUKEBOX, S = song_played)
		for(var/mob/L in rangers)
			if(get_dist(src,L) > 10)
				rangers -= L
				if(!L || !L.client)
					continue
				L.stop_sound_channel(CHANNEL_JUKEBOX)
	else if(active)
		active = FALSE
		STOP_PROCESSING(SSobj, src)
		dance_over()
		playsound(src,'sound/machines/terminal_off.ogg',50,1)
		update_icon()
		stop = world.time + 100
	*/

/obj/machinery/party/turntable/attackby(obj/item/I, mob/user)
	if(default_unfasten_wrench(user, I))
		return

	if(istype(I, /obj/item/card/music) && !disk)
		if(disk_insert(user, I, disk))
			disk = I
		return

	return ..()

/obj/machinery/computer/card/proc/disk_insert(mob/user, /obj/item/card/music/I, target)
	if(istype(I))
		if(target)
			to_chat(user, "<span class='warning'>There's already a disk!</span>")
			return FALSE
		if(!user.transferItemToLoc(I, src))
			return FALSE
		user.visible_message("<span class='notice'>[user] inserts a disk into the jukebox.</span>", \
							"<span class='notice'>You insert a disk into the jukebox.</span>")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		updateUsrDialog()
		return TRUE


/obj/machinery/turntable/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]-active"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/turntable/ui_interact(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if (!anchored)
		to_chat(user,"<span class='warning'>This device must be anchored by a wrench!</span>")
		return
	if(!allowed(user))
		to_chat(user,"<span class='warning'>Error: Access Denied.</span>")
		user.playsound_local(src,'sound/misc/compiler-failure.ogg', 25, 1)
		return
	/*
	if(!songs.len)
		to_chat(user,"<span class='warning'>Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue.</span>")
		playsound(src,'sound/misc/compiler-failure.ogg', 25, 1)
		return
	*/

	var/list/dat = list()
	dat +="<div class='statusDisplay' style='text-align:center'>"
	dat += "<b><A href='?src=[REF(src)];action=toggle'>[!active ? "BREAK IT DOWN" : "SHUT IT DOWN"]<b></A><br>"
	dat += "</div><br>"
	dat += "<A href='?src=[REF(src)];action=select'> Select Track</A><br>"
	dat += "Track Selected: [selection.song_name]<br>"

	if(selection.song_length)
		dat += "Track Length: [DisplayTimeText(selection.song_length)]<br><br>"
	if(disk)
		dat += "<A href='?src=[REF(src)];action=eject'>Eject Disk</A><br>"

	var/datum/browser/popup = new(user, "vending", "[name]", 400, 350)
	popup.set_content(dat.Join())
	popup.open()


/obj/machinery/turntable/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	switch(href_list["action"])
		if("toggle")
			if (QDELETED(src))
				return
			if(!active)
				activate_music()
				updateUsrDialog()
			else if(active)
				dance_over()
				updateUsrDialog()
			/*
			if(!active)
				if(stop > world.time)
					to_chat(usr, "<span class='warning'>Error: The device is still resetting from the last activation, it will be ready again in [DisplayTimeText(stop-world.time)].</span>")
					playsound(src, 'sound/misc/compiler-failure.ogg', 50, 1)
					return
				activate_music()
				START_PROCESSING(SSobj, src)
				updateUsrDialog()
			else if(active)
				stop = 0
				updateUsrDialog()
			*/
		if("select")
			/*
			if(active)
				to_chat(usr, "<span class='warning'>Error: You cannot change the song until the current one is over.</span>")
				return
			*/
			var/list/available = list()
			for(var/datum/track/S in songs)
				available[S.song_name] = S

			if(disk)
				if(disk.data)
					available[disk.data.song_name] = disk.data

			var/selected = input(usr, "Choose your song", "Track:") as null|anything in available
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			selection = available[selected]
			updateUsrDialog()

		if("eject")
			if(disk)
				disk.loc = src.loc
				if(active)
					dance_over()
					selection = null
				disk = null

			updateUsrDialog()

/obj/machinery/turntable/proc/activate_music()
	active = TRUE
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/machinery/turntable/proc/dance_over()
	for(var/mob/living/L in rangers)
		if(!L || !L.client)
			continue
		L.stop_sound_channel(CHANNEL_JUKEBOX)
	rangers = list()

	active = FALSE
	playsound(src,'sound/machines/terminal_off.ogg',50,1)
	update_icon()
	STOP_PROCESSING(SSobj, src)

/obj/item/card/music
	icon_state = "data_3"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	w_class = 1.0
	var/datum/track/data
	var/uploader_ckey

/obj/machinery/musicwriter
	name = "Memories writer"
	icon = 'code/shitcode/magkorobka.dmi'
	icon_state = "writer_off"
	var/coin = 0
	//var/obj/item/weapon/disk/music/disk
	var/mob/retard //current user
	var/retard_name
	var/writing = 0

/obj/machinery/musicwriter/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/coin))
		user.dropItemToGround(O)
		qdel(O)
		coin++

/obj/machinery/musicwriter/attack_hand(mob/user)
	var/dat = ""
	if(writing)
		dat += "Memory scan completed. <br>Writing from scan of [retard_name] mind... Please Stand By."
	else if(!coin)
		dat += "Please insert a coin."
	else
		dat += "<A href='?src=\ref[src];write=1'>Write</A>"

	user << browse(dat, "window=musicwriter;size=200x100")
	onclose(user, "onclose")
	return

/obj/machinery/musicwriter/Topic(href, href_list)
	if(href_list["write"])
		if(!writing && !retard && coin)
			icon_state = "writer_on"
			writing = 1
			retard = usr
			retard_name = retard.name
			var/N = sanitize(input("Name of music") as text|null)
			//retard << "Please stand still while your data is uploading"
			if(N)
				var/sound/S = input("Your music file") as sound|null
				if(S)
					var/datum/track/T = new()
					var/obj/item/card/music/disk = new
					T.song_path = S
					//T.f_name = copytext(N, 1, 2)
					T.song_name = copytext(N, 2)
					disk.data = T
					disk.name = "disk ([N])"
					disk.loc = src.loc
					disk.uploader_ckey = retard.ckey
					var/mob/M = usr
					message_admins("[M.real_name]([M.ckey]) uploaded <A HREF='?_src_=holder;listensound=\ref[S]'>sound</A> named as [N]. <A HREF='?_src_=holder;wipedata=\ref[disk]'>Wipe</A> data.")
					coin--

			icon_state = "writer_off"
			writing = 0
			retard = null
			retard_name = null
