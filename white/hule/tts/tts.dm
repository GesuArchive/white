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
	"aidar" = "Разное: Айдар",
	"baya" = "Разное: Байя",
	"kseniya" = "Разное: Ксения",
	"xenia" = "Разное: Сения",
	"eugene" = "Разное: Евгений",
	"charlotte" = "Медиа: Шарлотта",
	"bebey" = "Медиа: Бэбэй",
	"biden" = "Разное: Байден",
	"papa" = "Медиа: Папич",
	"mykyta" = "Разное: Микита",
	"glados" = "Portal: Гладос",
	"adventure_core" = "Portal: Приключенец",
	"space_core" = "Portal: Космонавт",
	"fact_core" = "Portal: Фактовик",
	"sentrybot" = "Fallout: Сентрибот",
	"mana" = "Медиа: Мана",
	"soldier" = "TF2: Солдат",
	"planya" = "Медиа: Планя",
	"amina" = "Медиа: Амина",
	"kleiner" = "HL2: Кляйнер",
	"dbkn" = "Медиа: Добакин",
	"neco" = "Аниме: Неко",
	"gman" = "HL2: G-Man",
	"obama" = "Разное: Обама",
	"trump" = "Разное: Трамп"
))

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
