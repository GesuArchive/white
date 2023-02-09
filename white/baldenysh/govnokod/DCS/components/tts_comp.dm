/datum/component/tts
	var/atom/owner

	var/creation = 0 //create tts on hear
	var/tts_speaker

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
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	if(ismob(owner))
		var/mob/M = owner
		var/forced_voice = M?.client?.prefs?.forced_voice

		if(forced_voice && forced_voice != "auto")
			tts_speaker = forced_voice

/datum/component/tts/UnregisterFromParent()
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/component/tts/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	if(GLOB.tts || creation)
		INVOKE_ASYNC(src, PROC_REF(prikolize), speech_args[SPEECH_MESSAGE])

/datum/component/tts/proc/prikolize(msg)
	msg = trim(msg, maxchars)
	if(tts_speaker)
		owner.tts(msg, tts_speaker, freq = frequency)
