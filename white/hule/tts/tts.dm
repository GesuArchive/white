 //needs gtts python module

GLOBAL_VAR_INIT(tts, FALSE)

GLOBAL_LIST_INIT(tts_voices, list(
	"aidar" = "Айдар",
	"baya" = "Байя",
	"kseniya" = "Ксения",
	"xenia" = "Сения",
	"eugene" = "Евгений",
	"charlotte" = "Шарлотта",
	"bebey" = "Бэбэй",
	"biden" = "Байден",
	"papa" = "Папич",
	"mykyta" = "Микита",
	"glados" = "Гладос",
	"sentrybot" = "Сентрибот",
	"mana" = "Мана",
	"soldier" = "Солдат",
	"planya" = "Планя",
	"amina" = "Амина"
))

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

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
