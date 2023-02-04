 //needs gtts python module

#define TTS_PATH "/home/ubuntu/tenebrae/prod/server_white/white/hule/tts"

GLOBAL_VAR_INIT(tts, FALSE)
GLOBAL_VAR_INIT(tts_speaker, "default")

GLOBAL_LIST_INIT(gtts_voices, list(
	"Авто" = "auto",
	"Afrikaans" = "af",
	"Arabic" = "ar",
	"Bulgarian" = "bg",
	"Bengali" = "bn",
	"Bosnian" = "bs",
	"Catalan" = "ca",
	"Czech" = "cs",
	"Danish" = "da",
	"German" = "de",
	"Greek" = "el",
	"English" = "en",
	"Spanish" = "es",
	"Estonian" = "et",
	"Finnish" = "fi",
	"French" = "fr",
	"Gujarati" = "gu",
	"Hindi" = "hi",
	"Croatian" = "hr",
	"Hungarian" = "hu",
	"Indonesian" = "id",
	"Icelandic" = "is",
	"Italian" = "it",
	"Hebrew" = "iw",
	"Japanese" = "ja",
	"Javanese" = "jw",
	"Khmer" = "km",
	"Kannada" = "kn",
	"Korean" = "ko",
	"Latin" = "la",
	"Latvian" = "lv",
	"Malayalam" = "ml",
	"Marathi" = "mr",
	"Malay" = "ms",
	"Myanmar (Burmese)" = "my",
	"Nepali" = "ne",
	"Dutch" = "nl",
	"Norwegian" = "no",
	"Polish" = "pl",
	"Portuguese" = "pt",
	"Romanian" = "ro",
	"Russian" = "ru",
	"Sinhala" = "si",
	"Slovak" = "sk",
	"Albanian" = "sq",
	"Serbian" = "sr",
	"Sundanese" = "su",
	"Swedish" = "sv",
	"Swahili" = "sw",
	"Tamil" = "ta",
	"Telugu" = "te",
	"Thai" = "th",
	"Filipino" = "tl",
	"Turkish" = "tr",
	"Ukrainian" = "uk",
	"Urdu" = "ur",
	"Vietnamese" = "vi",
	"Chinese (Simplified)" = "zh-CN",
	"Chinese (Mandarin/Taiwan)" = "zh-TW",
	"Chinese (Mandarin)" = "zh"
))

PROCESSING_SUBSYSTEM_DEF(tts)
	name = "Text To Speech"
	priority = 15
	flags = SS_NO_INIT
	wait = 10

////////////////////////////////////////////////

/proc/tts_args(var/name, var/msg, var/lang)
	world.Export("http://127.0.0.1:2386/?text=[url_encode(msg)]&speaker=[lang]&ckey=[name]")

/////////////////////////////////////

/atom/proc/tts(var/msg, var/lang=GLOB.tts_speaker, var/freq)
	var/namae
	if(!ismob(src))
		namae = name
	else
		var/mob/etot = src
		namae = etot.ckey

	spawn(-1)
		tts_args(namae, msg, lang)
		spawn(2)
			if(fexists("[TTS_PATH]/lines/[namae].wav"))
				playsound(src, "[TTS_PATH]/lines/[namae].wav", 100, channel = tts_comp?.assigned_channel, vary = TRUE, frequency = freq)

////////////////////////////////////////

/client/proc/anime_voiceover()
	set category = "Адм.Веселье"
	set name = "ANIME VO"

	if(!check_rights())
		return

	var/list/menu = list("Cancel", "Toggle TTS", "Change Lang")

	var/selected = tgui_input_list(usr, "Main Menu", "ANIME VOICEOVER", menu, "Cancel")

	switch(selected)
		if("Cancel")
			return

		if("Toggle TTS")
			GLOB.tts = !GLOB.tts

			if(GLOB.tts)
				message_admins("[key] toggled anime voiceover on.")
			else
				message_admins("[key] toggled anime voiceover off.")

		if("Change Lang")
			var/selectedlang = tgui_input_text(usr, "Main Menu", "ANIME VOICEOVER")
			if(!selectedlang)
				return

			message_admins("[key] sets anime voiceover lang to \"[selectedlang]\"")
			GLOB.tts_speaker = selectedlang

#undef TTS_PATH

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
