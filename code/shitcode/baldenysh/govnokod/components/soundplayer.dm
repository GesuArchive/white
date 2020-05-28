/datum/component/soundplayer
	var/atom/soundsource

	var/sound/cursound
	var/active = FALSE
	var/playing_range = 12

	var/environmental = TRUE
	var/repeating = TRUE
	var/playing_volume = 100
	var/playing_falloff = 1
	var/playing_channel = 0

/datum/component/soundplayer/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	soundsource = parent
	playing_channel = open_sound_channel()
	START_PROCESSING(SSprocessing, src)
	cursound = sound('code/shitcode/baldenysh/sounds/hardbass_loop.ogg')
	. = ..()

/datum/component/soundplayer/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	stop_sounds()
	. = ..()

/datum/component/soundplayer/process()
	if(!active || !cursound)
		return
	for(var/client/C)
		if(!client_get_cursound(C))
			client_preload_cursound(C)
		if(!C.mob)
			continue
		client_update_cursound(C)

/datum/component/soundplayer/proc/client_get_cursound(var/client/C)
	for(var/sound/S in C.SoundQuery())
		if(S.file == cursound.file)
			return S
	return FALSE

/datum/component/soundplayer/proc/client_preload_cursound(var/client/C)
	SEND_SOUND(C, get_blank_sound())

/datum/component/soundplayer/proc/client_update_cursound(var/client/C)
	var/sound/S = client_get_cursound(C)
	if(!S)
		return
	var/turf/TT = get_turf(C.mob)
	var/turf/MT = get_turf(soundsource)
	var/dist = get_dist(TT, MT)
	S.status = SOUND_UPDATE
	if(dist <= playing_range)
		S.volume = playing_volume
		S.volume -= max(dist - world.view, 0) * 2
		S.falloff = playing_falloff
		if(environmental)
			var/dx = MT.x - TT.x
			S.x = dx
			var/dy = MT.y - TT.y
			S.z = dy
		else
			S.x = 0
			S.z = 1
	else
		S.volume = 0
	SEND_SOUND(C, S)

/datum/component/soundplayer/proc/client_stop_cursound(var/client/C)
	SEND_SOUND(C, sound(null, repeat = 0, wait = 0, channel = playing_channel))

/datum/component/soundplayer/proc/stop_sounds()
	active = FALSE
	for(var/client/C)
		if(!client_get_cursound(C))
			continue
		client_stop_cursound(C)

/datum/component/soundplayer/proc/get_blank_sound()
	var/sound/S = cursound
	S.repeat = repeating
	S.falloff = playing_falloff
	S.channel = playing_channel
	S.volume = 0
	S.status = 0
	S.wait = 0
	S.x = 0
	S.z = 1
	S.y = 1
	return S

/datum/component/soundplayer/proc/toggle()
	active = !active
