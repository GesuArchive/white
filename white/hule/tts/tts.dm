// TODO: перенести это всё в жсон и добавить кэширование

GLOBAL_LIST_INIT(tts_lowfreq, list(
	"aidar",
	"baya",
	"kseniya",
	"xenia",
	"eugene",
	"mykyta"
))

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
	"amina" = "Амина",
	"kleiner" = "Кляйнер"
))

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
