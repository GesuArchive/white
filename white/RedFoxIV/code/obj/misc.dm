/obj/item/implant/bonjour
	name = "Пищалка"
	desc = "Очень страшно пищит."
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "legsweep"
	actions_types = list(/datum/action/cooldown/bonjour)

/obj/item/implant/bonjour/get_data()

	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> АААААААААААА<BR>
				<b>Life:</b> БЛЯЯЯЯЯЯЯЯЯЯЯЯЯТЬ<BR>
				<b>Important Notes:</b> СУКАААААААААААААААААААА<BR>
				<HR>
				<b>Implant Details:</b><img src="data:image/png;base64,[image_base64]"/>
				"}
	return dat




/datum/action/cooldown/bonjour
	name = "Напугать жертву до усрачки."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"
	cooldown_time = 3 SECONDS
	var/sound_length = 5.5 SECONDS
	var/active = FALSE
	var/datum/component/soundplayer/bonjour
	//var/datum/sound_player/bonjour
	//var/sound/sound = sound('white/RedFoxIV/sounds/your_demise.ogg')
	var/soundfile = 'white/RedFoxIV/sounds/bonjour.ogg'

/datum/action/cooldown/bonjour/New()
	. = ..()
	//bonjour = new(soundfile, 100, 10, FALSE, target)
	bonjour = target.AddComponent(/datum/component/soundplayer)
	bonjour.repeating = FALSE
	bonjour.prefs_toggle_flag = null
	bonjour.playing_volume = 100
	bonjour.playing_range = 10
	bonjour.playing_falloff = 1
	//bonjour.active = TRUE

/datum/action/cooldown/bonjour/link_to(var/atom/owner)
	..()

/datum/action/cooldown/bonjour/Destroy()
	qdel(bonjour)
	. = ..()

/datum/action/cooldown/bonjour/proc/stop()
	bonjour.stop_sounds()


/datum/action/cooldown/bonjour/Activate(atom/target)
	..()
	//bonjour.play()
	bonjour.set_sound(sound(soundfile))
	bonjour.current_player_sound.status |= SOUND_STREAM
	bonjour.set_channel(open_sound_channel_for_boombox())
	bonjour.active = TRUE
	addtimer(CALLBACK(src, PROC_REF(stop)), sound_length)



/datum/sound_player
	var/volume = 100
	var/reverb = FALSE
	var/range = 10
	var/sound_length = 5.4 SECONDS
	var/soundfile
	var/sound/sound
	var/current_channel
	var/atom/position
	var/playing = FALSE
	var/list/rangers = list()


/datum/sound_player/New(_soundfile, _volume, _range, _reverb, _position)
	soundfile = _soundfile
	volume = _volume
	range = _range
	reverb = _reverb
	position = _position

/datum/sound_player/proc/play()
	if(playing)
		return FALSE
	sound = sound(soundfile)
	sound.len = sound_length
	current_channel = open_sound_channel_for_tts()
	START_PROCESSING(SSprocessing, src)
	playing = TRUE
	addtimer(CALLBACK(src, PROC_REF(stop)), sound_length)
	return TRUE

/datum/sound_player/proc/stop()
	if(!playing)
		return FALSE
	STOP_PROCESSING(SSprocessing, src)
	for(var/mob/L in rangers)
		if(!L || !L.client)
			continue
		L.stop_sound_channel(current_channel)
	playing = FALSE
	return TRUE

//#define GEOMETRIC_DIST(turf_a, turf_b) sqrt((turf_a.x - turf_b.x)**2 + (turf_a.y - turf_b.y)**2 )

/datum/sound_player/process(delta_time)
	for(var/mob/M in range(range, get_turf(position)))
		if(!M.client)
			continue
		if(!(M in rangers))
			rangers[M] = TRUE
			M.playsound_local(get_turf(position), null, volume, channel = current_channel, sound_to_use = sound, use_reverb = reverb, distance_multiplier = 2)
	for(var/mob/L in rangers)
		if(get_dist(get_turf(position), L) > range)
			rangers -= L
			if(!L || !L.client)
				continue
			L.stop_sound_channel(current_channel)
