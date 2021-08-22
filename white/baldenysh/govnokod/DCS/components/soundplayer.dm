/datum/component/soundplayer
	var/atom/movable/sound_source_override

	var/sound/cursound
	var/active = FALSE
	var/playing_range = 32
	var/list/listener_comps = list()

	var/environmental = TRUE
	var/env_id = 12
	var/repeating = TRUE
	var/playing_volume = 100
	var/playing_falloff = 4
	var/playing_channel

	var/prefs_toggle_flag = SOUND_JUKEBOX

/datum/component/soundplayer/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	playing_channel = SSsounds.random_available_channel()
	START_PROCESSING(SSprocessing, src)
	. = ..()
	set_sound(sound('white/baldenysh/sounds/hardbass_loop.ogg'))

/datum/component/soundplayer/Destroy()
	stop_sounds()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/component/soundplayer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/update_sounds)

/datum/component/soundplayer/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/soundplayer/proc/override_sound_source(atom/movable/A)
	if(sound_source_override)
		UnregisterSignal(sound_source_override, COMSIG_MOVABLE_MOVED)
	else
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	RegisterSignal(A, COMSIG_MOVABLE_MOVED, .proc/update_sounds)

/datum/component/soundplayer/process()
	if(!active || !cursound)
		return
	for(var/client/C)
		if(prefs_toggle_flag && !(C.prefs?.w_toggles & prefs_toggle_flag))
			continue
		if(!C.mob)
			continue
		var/mob/M = C.mob
		var/list/mycomps = (M.GetComponents(/datum/component/soundplayer_listener) & listener_comps)
		if(mycomps && mycomps.len)
			continue
		var/datum/component/soundplayer_listener/SPL = M.AddComponent(/datum/component/soundplayer_listener, src)
		listener_comps += SPL
		INVOKE_ASYNC(SPL, /datum/component/soundplayer_listener.proc/update_sound)

/datum/component/soundplayer/proc/update_sounds()
	SIGNAL_HANDLER
	for(var/datum/component/soundplayer_listener/SPL in listener_comps)
		INVOKE_ASYNC(SPL, /datum/component/soundplayer_listener.proc/update_sound)

/datum/component/soundplayer/proc/stop_sounds()
	active = FALSE
	for(var/datum/component/soundplayer_listener/SPL in listener_comps)
		SPL.stop_sound()
		qdel(SPL)

/datum/component/soundplayer/proc/set_sound(newsound)
	if(istext(newsound))
		cursound = sound(newsound)
	else
		cursound = newsound
	cursound.wait = 0
	cursound.volume = 0
	update_sounds()

/datum/component/soundplayer/proc/upload_sound(client/uploader)
	var/sound/soundpath = input(uploader, null, "Upload sound") as sound|null
	if(soundpath)
		set_sound(sound(soundpath))

/datum/component/soundplayer/proc/set_channel(chan)
	playing_channel = chan
	if(cursound)
		cursound.channel = chan
	update_sounds()

////////////////////////////////////////////////

/datum/component/soundplayer_listener
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/datum/component/soundplayer/myplayer

/datum/component/soundplayer_listener/Initialize(datum/component/soundplayer/player)
	if(!ismob(parent) || !istype(player))
		return COMPONENT_INCOMPATIBLE
	myplayer = player
	. = ..()

/datum/component/soundplayer_listener/Destroy()
	myplayer.listener_comps -= src
	stop_sound()
	. = ..()

/datum/component/soundplayer_listener/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/do_update_sound)
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, .proc/qdel_check)

/datum/component/soundplayer_listener/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_LOGOUT)

/datum/component/soundplayer_listener/proc/stop_sound()
	var/mob/M = parent
	SEND_SOUND(M, sound(null, repeat = 0, wait = 0, channel = myplayer.playing_channel))

/datum/component/soundplayer_listener/proc/get_player_sound()
	var/mob/M = parent
	var/list/sounds = M.client.SoundQuery()
	for(var/sound/S in sounds)
		if(S.file == myplayer.cursound.file)
			return S
	for(var/sound/S in sounds)
		if(S.channel == myplayer.playing_channel && S.repeat == myplayer.repeating)
			return S
	return FALSE

/datum/component/soundplayer_listener/proc/qdel_check()
	SIGNAL_HANDLER
	var/mob/P = parent
	if(!P || !P.client || !myplayer || !myplayer.cursound)
		qdel(src)
		return TRUE
	return FALSE

/datum/component/soundplayer_listener/proc/do_update_sound()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, .proc/update_sound)

/datum/component/soundplayer_listener/proc/update_sound()
	if(qdel_check())
		return
	var/mob/M = parent
	if(myplayer.prefs_toggle_flag && !(M?.client?.prefs?.w_toggles & myplayer.prefs_toggle_flag))
		stop_sound()
		qdel(src)
		return
	var/sound/S = get_player_sound()
	if(!S)
		S = myplayer.cursound
		S.status = 0
		S.volume = 0
		S.repeat = myplayer.repeating
		S.falloff = myplayer.playing_falloff
		S.channel = myplayer.playing_channel
		S.environment = myplayer.env_id
		S.y = 1
		SEND_SOUND(M, S)
	S.status = SOUND_UPDATE
	S.channel = myplayer.playing_channel

	var/turf/listener_turf = get_turf(M)
	var/atom/movable/A = myplayer.sound_source_override ? myplayer.sound_source_override : myplayer.parent
	var/turf/player_turf = get_turf(A)
	if(!listener_turf || !player_turf)
		return

	var/dist = get_dist(listener_turf, player_turf)//cheap_hypotenuse(listener_turf.x, listener_turf.y, player_turf.x, player_turf.y)

	var/list/turf/allowed_z_levels = list(player_turf.z)
	var/turf/above = SSmapping.get_turf_above(player_turf)
	if(above)
		allowed_z_levels += above.z
	var/turf/below = SSmapping.get_turf_below(player_turf)
	if(below)
		allowed_z_levels += below.z

	if(dist <= myplayer.playing_range && (listener_turf.z in allowed_z_levels))
		if(myplayer.environmental && player_turf && listener_turf)
			S.volume = myplayer.playing_volume - max(dist * round(myplayer.playing_range/8), 0)
		else
			S.volume = myplayer.playing_volume
		S.falloff = myplayer.playing_falloff
		S.environment = myplayer.env_id
	else
		S.volume = 0
	SEND_SOUND(M, S)
	S.volume = 0
