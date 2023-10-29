/datum/component/soundplayer
	var/atom/movable/sound_source_override

	var/sound_version = 1
	var/sound/current_player_sound
	var/active = FALSE
	var/playing_range = 21
	var/list/listener_comps = list()

	var/environmental = TRUE
	var/env_id = 12
	var/repeating = TRUE
	var/playing_volume = 100
	var/playing_falloff = 4
	var/playing_channel

	var/prefs_toggle_flag = SOUND_JUKEBOX

/datum/component/soundplayer/Initialize(mapload)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	playing_channel = SSsounds.random_available_channel()
	START_PROCESSING(SSsoundplayer, src)
	. = ..()
	set_sound(sound('white/baldenysh/sounds/hardbass_loop.ogg'))

/datum/component/soundplayer/Destroy()
	stop_sounds()
	STOP_PROCESSING(SSsoundplayer, src)
	. = ..()

/datum/component/soundplayer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_sounds))
	RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(update_sounds))

/datum/component/soundplayer/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE)

/datum/component/soundplayer/proc/override_sound_source(atom/movable/A)
	if(sound_source_override)
		UnregisterSignal(sound_source_override, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(sound_source_override, COMSIG_RIDDEN_DRIVER_MOVE)
	else
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE)
	RegisterSignal(A, COMSIG_MOVABLE_MOVED, PROC_REF(update_sounds))
	RegisterSignal(A, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(update_sounds))

/datum/component/soundplayer/process()
	if(!active || !current_player_sound)
		return

	for(var/client/listening_client)
		if(prefs_toggle_flag && !(listening_client.prefs?.w_toggles & prefs_toggle_flag))
			continue
		if(!listening_client?.mob)
			continue
		var/mob/listening_mob = listening_client.mob
		if(LAZYLEN((list() + listening_mob.GetComponents(/datum/component/soundplayer_listener) & listener_comps)))
			continue
		var/datum/component/soundplayer_listener/SPL = listening_mob.AddComponent(/datum/component/soundplayer_listener, src)
		listener_comps += SPL
		INVOKE_ASYNC(SPL, TYPE_PROC_REF(/datum/component/soundplayer_listener, update_sound))

/datum/component/soundplayer/proc/update_sounds()
	SIGNAL_HANDLER
	for(var/datum/component/soundplayer_listener/SPL in listener_comps)
		INVOKE_ASYNC(SPL, TYPE_PROC_REF(/datum/component/soundplayer_listener, update_sound))

/datum/component/soundplayer/proc/stop_sounds()
	active = FALSE
	for(var/datum/component/soundplayer_listener/SPL in listener_comps)
		SPL.stop_sound()
		qdel(SPL)

/datum/component/soundplayer/proc/set_sound(newsound)
	if(istext(newsound) || isfile(newsound))
		current_player_sound = sound(newsound)
	else
		current_player_sound = newsound
	sound_version++
	current_player_sound.wait = 0
	current_player_sound.volume = 0
	update_sounds()

/datum/component/soundplayer/proc/set_channel(chan)
	playing_channel = chan
	if(current_player_sound)
		current_player_sound.channel = chan
	update_sounds()

/datum/component/soundplayer/proc/set_channel_auto()
	playing_channel = open_sound_channel_for_boombox()
	if(current_player_sound)
		current_player_sound.channel = playing_channel
	update_sounds()
////////////////////////////////////////////////

/datum/component/soundplayer_listener
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mob/mob_listener
	var/sound_version = 0
	var/sound/current_listener_sound
	var/datum/component/soundplayer/myplayer

/datum/component/soundplayer_listener/Initialize(datum/component/soundplayer/player)
	if(!ismob(parent) || !istype(player))
		return COMPONENT_INCOMPATIBLE
	mob_listener = parent
	myplayer = player
	. = ..()

/datum/component/soundplayer_listener/Destroy()
	mob_listener = null
	myplayer.listener_comps -= src
	stop_sound()
	. = ..()

/datum/component/soundplayer_listener/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_sound))
	RegisterSignal(myplayer.parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_sound))
	RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(update_sound))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(qdel_check))

/datum/component/soundplayer_listener/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(myplayer.parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE)
	UnregisterSignal(parent, COMSIG_MOB_LOGOUT)

/datum/component/soundplayer_listener/proc/stop_sound()
	SEND_SOUND(mob_listener, sound(null, repeat = 0, wait = 0, channel = myplayer.playing_channel))

/datum/component/soundplayer_listener/proc/qdel_check()
	SIGNAL_HANDLER
	if(!mob_listener?.client || !myplayer?.current_player_sound)
		qdel(src)
		return TRUE
	return FALSE

/datum/component/soundplayer_listener/proc/update_sound()
	SIGNAL_HANDLER

	if(qdel_check())
		return

	if(myplayer.prefs_toggle_flag && !(mob_listener?.client?.prefs?.w_toggles & myplayer.prefs_toggle_flag))
		stop_sound()
		qdel(src)
		return

	if(!current_listener_sound || sound_version != myplayer.sound_version)
		sound_version = myplayer.sound_version
		current_listener_sound = myplayer.current_player_sound
		current_listener_sound.status = 0
		current_listener_sound.volume = 0
		current_listener_sound.repeat = myplayer.repeating
		current_listener_sound.falloff = myplayer.playing_falloff
		current_listener_sound.channel = myplayer.playing_channel
		current_listener_sound.environment = myplayer.env_id
		current_listener_sound.y = 1
		SEND_SOUND(mob_listener, current_listener_sound)
	current_listener_sound.status = SOUND_UPDATE | SOUND_STREAM
	current_listener_sound.channel = myplayer.playing_channel

	var/turf/listener_turf = get_turf(mob_listener)
	var/turf/player_turf = get_turf(myplayer.sound_source_override ? myplayer.sound_source_override : myplayer.parent)
	if(!listener_turf || !player_turf)
		return

	var/dist = get_dist(listener_turf, player_turf)

	var/list/turf/allowed_z_levels = list(player_turf.z)
	var/turf/above = SSmapping.get_turf_above(player_turf)
	if(above)
		allowed_z_levels += above.z
	var/turf/below = SSmapping.get_turf_below(player_turf)
	if(below)
		allowed_z_levels += below.z

	if(dist <= myplayer.playing_range && (listener_turf.z in allowed_z_levels))
		if(myplayer.environmental && player_turf && listener_turf)
			current_listener_sound.volume = round(myplayer.playing_volume - ((myplayer.playing_volume / myplayer.playing_range) * dist))
		else
			current_listener_sound.volume = myplayer.playing_volume
		current_listener_sound.falloff = myplayer.playing_falloff
		current_listener_sound.environment = myplayer.env_id
	else
		current_listener_sound.volume = 0
	SEND_SOUND(mob_listener, current_listener_sound)
	current_listener_sound.volume = 0
