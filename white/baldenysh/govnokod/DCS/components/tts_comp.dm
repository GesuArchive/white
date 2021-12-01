/datum/component/tts
	var/mob/owner

	var/next_line_time = 0
	var/creation = 0 //create tts on hear
	var/lang

	var/charcd = 0.2 //ticks for one char
	var/maxchars = 140 //sasai kudosai

	var/assigned_channel
	var/frequency = 1

/datum/component/tts/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	assigned_channel = open_sound_channel_for_tts()
	. = ..()

/datum/component/tts/RegisterWithParent()
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/component/tts/UnregisterFromParent()
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/component/tts/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	if(GLOB.tts || creation)
		INVOKE_ASYNC(src, .proc/prikolize, speech_args[SPEECH_MESSAGE])

/datum/component/tts/proc/prikolize(msg)
	if(world.time < next_line_time)
		return
	next_line_time = world.time
	msg = trim(msg, maxchars)
	next_line_time += length(msg)*charcd * 2
	if(lang)
		owner.tts(msg, lang, freq = frequency)
	else
		var/lang_to_use = "ruslan" // plural go fuck
		switch(owner.gender)
			if(MALE)
				lang_to_use = "aidar"
			if(FEMALE)
				lang_to_use = "baya" // блять ну и говно
		owner.tts(msg, lang_to_use, freq = frequency)
