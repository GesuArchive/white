// TODO: перенести это всё в жсон и добавить кэширование

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

	"glados" 		 	 = "Portal: Гладос",
	"adventure_core" 	 = "Portal: Модуль Приключений",
	"space_core" 	 	 = "Portal: Модуль Космоса",
	"fact_core" 	 	 = "Portal: Модуль Фактов",
	"turret_floor" 	 	 = "Portal: Турель",

	"sentrybot" 		 = "Fallout: Сентрибот",

	"soldier" 			 = "TF2: Солдат",
	"engineer" 			 = "TF2: Инженер",
	"heavy" 			 = "TF2: Хэви",
	"medic" 			 = "TF2: Медик",
	"sniper" 			 = "TF2: Снайпер",
	"spy" 			 	 = "TF2: Шпион",
	"demoman" 			 = "TF2: Подрывник",

	"cicero" 			 = "Скурим: Цицерон",
	"sheogorath" 		 = "Скурим: Шеогорат",
	"kodlakwhitemane" 	 = "Скурим: Колдак Белая Грива",

	"geralt" 			 = "Ведьмак: Геральт",
	"cirilla" 			 = "Ведьмак: Цирилла",
	"triss" 			 = "Ведьмак: Трисс",
	"lambert" 			 = "Ведьмак: Ламберт",

	"neco" 				 = "Аниме: Неко",
	"polina" 		     = "Аниме: Полина",
	"xrenoid" 		     = "Аниме: Хреноид",
	"valtos" 		     = "Аниме: Валтос",

	"arthas" 		     = "Warcraft 3: Артас",
	"rexxar" 		     = "Warcraft 3: Рексар",
	"voljin" 		     = "Warcraft 3: Вол'джин",
	"illidan" 		     = "Warcraft 3: Иллидан",

	"azir" 		     	 = "LoL: Азир",
	"caitlyn" 		     = "LoL: Кэйтлин",
	"ekko" 		     	 = "LoL: Экко",
	"twitch" 		     = "LoL: Твич",
	"ziggs" 		     = "LoL: Зиггс",
	"rexxar" 		     = "LoL: Рексар",

	"tracer" 		     = "Overwatch: Трейсер",

	"kleiner" 			 = "HL2: Кляйнер",
	"gman" 				 = "HL2: G-Man",
	"briman" 			 = "HL2: Уоллес Брин",
	"alyx" 				 = "HL2: Аликс Вэнс",
	"father_grigori"	 = "HL2: Отец Григорий",
	"vance" 			 = "HL2: Илай Вэнс",
	"barni" 			 = "HL2: Барни Калхун",
	"mossman" 			 = "HL2: Джудит Моссман",

	"bandit" 			 = "S.T.A.L.K.E.R: Бандит",
	"sidorovich" 		 = "S.T.A.L.K.E.R: Сидорович",
	"strelok" 		     = "S.T.A.L.K.E.R: Стрелок",
	"forester" 		     = "S.T.A.L.K.E.R: Лесник"
))

GLOBAL_LIST_INIT(hifreq_tts_voices, list(
	"spy",
	"sniper",
	"demoman",
	"medic",
	"heavy",
	"engineer",
	"azir",
	"geralt",
	"glados",
	"mossman",
	"kleiner",
	"father_grigori",
	"briman",
	"valtos"
))

/proc/open_sound_channel_for_tts()
	var/static/next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
	. = ++next_channel
	if(next_channel > CHANNEL_TTS_AVAILABLE)
		next_channel = CHANNEL_BOOMBOX_AVAILABLE + 1
