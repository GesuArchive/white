// TODO: перенести это всё в жсон и добавить кэширование

GLOBAL_LIST_INIT(tts_lowfreq, list(
	"aidar",
	"baya",
	"kseniya",
	"xenia",
	"eugene",
	"mykyta",
	"briman",
	"kleiner_alt",
	"father_grigori",
	"vance",
	"barni",
	"gman_alt",
	"alyx",
	"mossman",
	"bandit",
	"papich_alt",
	"bebey_alt"
))

GLOBAL_LIST_INIT(tts_voices, list(
	"aidar" 	= "Разное: Айдар",
	"baya" 		= "Разное: Байя",
	"kseniya" 	= "Разное: Ксения",
	"xenia" 	= "Разное: Сения",
	"eugene" 	= "Разное: Евгений",
	"biden" 	= "Разное: Байден",
	"obama" 	= "Разное: Обама",
	"trump" 	= "Разное: Трамп",
	"mykyta" 	= "Разное: Микита",

	"charlotte" = "Медиа: Шарлотта",
	"bebey" 	= "Медиа: Бэбэй",
	"papa" 		= "Медиа: Папич",
	"mana" 		= "Медиа: Мана",
	"planya" 	= "Медиа: Планя",
	"amina" 	= "Медиа: Амина",
	"dbkn" 		= "Медиа: Добакин",
	"papich_alt"= "Медиа: Папич Альт.",
	"bebey_alt" = "Медиа: Бэбэй Альт.",

	"glados" 		 = "Portal: Гладос",
	"adventure_core" = "Portal: Приключенец",
	"space_core" 	 = "Portal: Космонавт",
	"fact_core" 	 = "Portal: Фактовик",

	"sentrybot" = "Fallout: Сентрибот",

	"soldier" = "TF2: Солдат",

	"neco" = "Аниме: Неко",

	"kleiner" 		= "HL2: Кляйнер",
	"gman" 			= "HL2: G-Man",
	"briman" 		= "HL2: Уоллес Брин",
	"alyx" 			= "HL2: Аликс Вэнс",
	"kleiner_alt" 	= "HL2: Айзек Кляйнер Альт.",
	"father_grigori"= "HL2: Отец Григорий",
	"vance" 		= "HL2: Илай Вэнс",
	"barni" 		= "HL2: Барни Калхун",
	"gman_alt" 		= "HL2: G-Man Альт.",
	"mossman" 		= "HL2: Джудит Моссман",

	"bandit" = "S.T.A.L.K.E.R: Бандит"
))

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
