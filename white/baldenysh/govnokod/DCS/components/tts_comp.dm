/datum/component/tts
	var/mob/owner

	var/creation = 0 //create tts on hear
	var/lang

	var/maxchars = 140 //sasai kudosai

	var/assigned_channel
	var/frequency = 1

/datum/component/tts/Initialize(mapload)
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
	msg = trim(msg, maxchars)
	if(lang)
		owner.tts(msg, lang, freq = frequency)
	else
		var/lang_to_use = "eugene" // plural go fuck
		switch(owner.gender)
			if(MALE)
				lang_to_use = "aidar"
			if(FEMALE)
				lang_to_use = "xenia"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			frequency = 32000 - (H.age * 200)
		if(HAS_TRAIT(owner, TRAIT_CLUMSY) || isfelinid(owner))
			frequency *= 1.5
		owner.tts(msg, lang_to_use, freq = frequency)
