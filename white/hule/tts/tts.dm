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
	"bebey_alt",
	"glados_alt",
	"adventure_core_alt",
	"barni",
	"cicero",
	"cirilla",
	"fact_core_alt",
	"kodlakwhitemane",
	"lambert",
	"sheogorath",
	"space_core_alt",
	"triss",
	"turret_floor",
))

GLOBAL_LIST_INIT(tts_voices, list(
	"aidar" 			 = "Разное: Айдар",
	"baya" 				 = "Разное: Байя",
	"kseniya" 			 = "Разное: Ксения",
	"xenia" 			 = "Разное: Сения",
	"eugene" 			 = "Разное: Евгений",
	"biden" 			 = "Разное: Байден",
	"obama" 			 = "Разное: Обама",
	"trump" 			 = "Разное: Трамп",
	"mykyta" 			 = "Разное: Микита",
	"adolf" 			 = "Разное: Адольф",
	"adolf2" 			 = "Разное: Адольф 2",

	"charlotte" 		 = "Медиа: Шарлотта",
	"bebey" 			 = "Медиа: Бэбэй",
	"papa" 				 = "Медиа: Папич",
	"mana" 				 = "Медиа: Мана",
	"planya" 			 = "Медиа: Планя",
	"amina" 			 = "Медиа: Амина",
	"dbkn" 				 = "Медиа: Добакин",
	"papich_alt"		 = "Медиа: Папич (Альт.)",
	"bebey_alt" 		 = "Медиа: Бэбэй (Альт.)",

	"glados" 		 	 = "Portal: Гладос",
	"adventure_core" 	 = "Portal: Модуль Приключений",
	"space_core" 	 	 = "Portal: Модуль Космоса",
	"fact_core" 	 	 = "Portal: Модуль Фактов",
	"glados_alt" 	 	 = "Portal: Гладос Альт.",
	"adventure_core_alt" = "Portal: Модуль Приключений (Альт.)",
	"fact_core_alt" 	 = "Portal: Модуль Фактов (Альт.)",
	"space_core_alt" 	 = "Portal: Модуль Космоса (Альт.)",
	"turret_floor" 	 	 = "Portal: Турель",

	"sentrybot" 		 = "Fallout: Сентрибот",

	"soldier" 			 = "TF2: Солдат",

	"cicero" 			 = "Скурим: Цицерон",
	"sheogorath" 		 = "Скурим: Шеогорат",
	"kodlakwhitemane" 	 = "Скурим: Колдак Белая Грива",

	"geralt" 			 = "Ведьмак: Геральт",
	"cirilla" 			 = "Ведьмак: Цирилла",
	"triss" 			 = "Ведьмак: Трисс",
	"lambert" 			 = "Ведьмак: Ламберт",

	"neco" 				 = "Аниме: Неко",

	"kleiner" 			 = "HL2: Кляйнер",
	"gman" 				 = "HL2: G-Man",
	"briman" 			 = "HL2: Уоллес Брин",
	"alyx" 				 = "HL2: Аликс Вэнс",
	"kleiner_alt" 		 = "HL2: Айзек Кляйнер (Альт.)",
	"father_grigori"	 = "HL2: Отец Григорий",
	"vance" 			 = "HL2: Илай Вэнс",
	"barni" 			 = "HL2: Барни Калхун",
	"gman_alt" 			 = "HL2: G-Man (Альт.)",
	"mossman" 			 = "HL2: Джудит Моссман",

	"bandit" 			 = "S.T.A.L.K.E.R: Бандит"
))

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
