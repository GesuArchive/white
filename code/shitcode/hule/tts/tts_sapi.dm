#define TTS_PATH "code/shitcode/hule/tts"
#define MALE_VOICES list("Maxim", "Nicolai")
#define FEMALE_VOICES list("Alyona", "Tatyana")

GLOBAL_VAR_INIT(tts, FALSE)
GLOBAL_LIST_EMPTY(tts_datums)

PROCESSING_SUBSYSTEM_DEF(tts)
	name = "Text To Speech"
	priority = 15
	flags = SS_NO_INIT
	wait = 20

/proc/tts_core(var/msg, var/filename, var/voice)
	world.shelleo("chcp 1251")
	world.shelleo("[TTS_PATH]\\balcon -t \"[msg]\" -w [TTS_PATH]/lines/[filename].wav -n [voice] -enc 1251")
	world.shelleo("chcp 437")

/atom/movable/proc/tts(var/msg, var/voice)
	var/namae
	if(!ismob(src))
		namae = name
	else
		var/mob/etot = src
		namae = etot.ckey

	tts_core(msg, namae, voice)

	if(fexists("[TTS_PATH]/lines/[namae].wav"))
		for(var/mob/M in range(13))
			var/turf/T = get_turf(src)
			M.playsound_local(T, "[TTS_PATH]/lines/[namae].wav", 100, channel = TTS.assigned_channel)
		fdel("[TTS_PATH]/lines/[namae].wav")

/atom/movable
	var/datum/tts/TTS

/atom/movable/proc/grant_tts()
	if(!TTS)
		TTS = new /datum/tts
		TTS.owner = src

/atom/movable/proc/remove_tts()
	if(TTS)
		qdel(TTS)

/datum/tts
	var/atom/movable/owner
	var/cooldown = 0
	var/createtts = 0 //create tts on hear
	var/voicename = "Anna"

	var/charcd = 0.2 //ticks for one char
	var/maxchars = 256 //sasai kudosai

	var/assigned_channel

/datum/tts/New()
	. = ..()
	if(ismob(owner))
		var/mob/M = owner
		if(M.gender == "male")
			voicename = pick(MALE_VOICES)
		else if(M.gender == "female")
			voicename = pick(FEMALE_VOICES)

	assigned_channel = open_sound_channel()
	GLOB.tts_datums += src
	START_PROCESSING(SStts, src)

/datum/tts/Destroy()
	GLOB.tts_datums -= src
	STOP_PROCESSING(SStts, src)
	. = ..()

/datum/tts/process()
	if(cooldown > 0)
		cooldown--

/datum/tts/proc/generate_tts(msg)
	if(cooldown <= 0)
		msg = trim(msg, maxchars)
		cooldown = length(msg)*charcd
		owner.tts(msg, voicename)

/client/proc/anime_voiceover()
	set category = "Fun"
	set name = "ANIME VO"


	if(!(ckey in GLOB.anonists))
		return
/*
	if(!check_rights())
		return
*/
	var/list/menu = list("Cancel", "Toggle TTS", "Change Lang", "Toggle Living Only")

	var/selected = input("Main Menu", "ANIME VOICEOVER", "Cancel") as null|anything in menu

	switch(selected)
		if("Cancel")
			return

		if("Toggle TTS")
			GLOB.tts = !GLOB.tts

			if(GLOB.tts)
				message_admins("[key] toggled anime voiceover on.")
			else
				message_admins("[key] toggled anime voiceover off.")

#undef TTS_PATH