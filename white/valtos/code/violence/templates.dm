
/datum/map_template/violence
	// описание карты
	var/description = ""
	// вес карты. Больше - выше шанс, что эта карта будет выбрана
	var/weight = 0
	// минимальное число игроков ОНЛАЙН
	var/min_players = 0
	// максимальное число игроков ОНЛАЙН
	var/max_players = 0
	// тема карты, должна быть существующая, иначе всё сломается
	var/theme = VIOLENCE_THEME_STD
	// цвет света на карте
	var/map_color = COLOR_LIGHT_GRAYISH_RED
	// альфа света на карте
	var/map_alpha = 255

/datum/map_template/violence/default
	name = "Карак"
	description = "Бойня в пустынном бункере."
	mappath = "_maps/violence/violence1.dmm"
	weight = 5
	min_players = 0
	max_players = 24
	theme = VIOLENCE_THEME_STD

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/violence/violence2.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = VIOLENCE_THEME_KATANA

/datum/map_template/violence/centralpolygon
	name = "Тренировочный Центр"
	description = "Здесь проходят обучение все офицеры Нанотрейзен."
	mappath = "_maps/violence/violence3.dmm"
	weight = 4
	min_players = 24
	max_players = 64
	theme = VIOLENCE_THEME_WARFARE

/datum/map_template/violence/de_dust2
	name = "de_dust2"
	description = "Здесь происходит что-то странное на польском языке."
	mappath = "_maps/violence/violence4.dmm"
	weight = 2
	min_players = 24
	max_players = 64
	theme = VIOLENCE_THEME_WARFARE

/datum/map_template/violence/dunes
	name = "Дюны"
	description = "Не кормите червей!"
	mappath = "_maps/violence/violence5.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = VIOLENCE_THEME_STD
	map_color = "#050509"
	map_alpha = 50

/datum/map_template/violence/cyberspess
	name = "Киберпространство"
	description = "Поиграем? Наши киберкотлеты готовы к бою!"
	mappath = "_maps/violence/violence6.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = VIOLENCE_THEME_CYBER

/datum/map_template/violence/trahov
	name = "Краков"
	description = "Нанотрейзен и Синдикат не поделили последний мешок сахара. Поможете им разобраться с этим недоразумением?"
	mappath = "_maps/violence/violence7.dmm"
	weight = 4
	min_players = 16
	max_players = 64
	theme = VIOLENCE_THEME_WARFARE
	map_color = "#f2ac99"
	map_alpha = 255

/datum/map_template/violence/koridorovo
	name = "Коридоры"
	description = "Город состоящий из коридоров. Кто это придумал?"
	mappath = "_maps/violence/violence8.dmm"
	weight = 5
	min_players = 24
	max_players = 64
	theme = VIOLENCE_THEME_HOTLINE

/datum/map_template/violence/okinawa
	name = "Окинава"
	description = "Борьба за последний клочок земли происходит именно здесь."
	mappath = "_maps/violence/violence9.dmm"
	weight = 8
	min_players = 12
	max_players = 32
	theme = VIOLENCE_THEME_KATANA

/datum/map_template/violence/pool
	name = "Бассейн"
	description = "Плыли мы по морю, ветер мачту рвал..."
	mappath = "_maps/violence/violence10.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = VIOLENCE_THEME_STD

/datum/map_template/violence/desert
	name = "Пустыня"
	description = "Черви проголодались и... ушли из этой зоны боевых действий, ну дела!"
	mappath = "_maps/violence/violence11.dmm"
	weight = 9
	min_players = 16
	max_players = 64
	theme = VIOLENCE_THEME_STD
	map_color = "#f1e5af"
	map_alpha = 200

/datum/map_template/violence/portalovo
	name = "Портальная авантюра"
	description = "Нанотрейзен хочет протестировать новую портальную технологию в бою. Что может пойти не так?"
	mappath = "_maps/violence/violence12.dmm"
	weight = 8
	min_players = 16
	max_players = 32
	theme = VIOLENCE_THEME_PORTAL

/datum/map_template/violence/cyberwarfare
	name = "Кибербойня"
	description = "Киберпространство расширено. Кто выживет в этой бессмысленной схватке?"
	mappath = "_maps/violence/violence13.dmm"
	weight = 15
	min_players = 16
	max_players = 32
	theme = VIOLENCE_THEME_CYBER

/datum/map_template/violence/caveforest
	name = "Лесные пещеры"
	description = "Пещеры?"
	mappath = "_maps/violence/violence14.dmm"
	weight = 5
	min_players = 16
	max_players = 32
	theme = VIOLENCE_THEME_STD
	map_color = "#050509"
	map_alpha = 5

/datum/map_template/violence/iwannaplayagame
	name = "I wanna play a game"
	description = "Ну типо карта. Там чёт есть. Даже есть укрытия. И дофига мешающего дерьма. Потому что тот, кто играет в вайленс, должен страдать."
	mappath = "_maps/violence/violence15.dmm"
	weight = 5
	min_players = 32
	max_players = 64
	theme = VIOLENCE_THEME_STD

/datum/map_template/violence/battleforsaratov
	name = "Битва в Саратове"
	description = "В центре карты находится многоквартирный дом, всего 8 комнат + \"Приватный\" Туалет. По углам есть грядки с семенами пшеницы, лужей воды и пустой бутылкой. Каждая комната обустроена под отдельного человека — Наркоман, Агент Синдиката, Виабушник, Людоед, Коммунист, Учëный, Программист и Культист. По карте расставлены мешки с песком и в некоторых комнатах находится рандомное оружие. Это мой первый опыт создания карт. Вдохновлялся Хотлайном, и квартирами в Халф Лайф 2."
	mappath = "_maps/violence/violence16.dmm"
	weight = 5
	min_players = 32
	max_players = 64
	theme = VIOLENCE_THEME_HOTLINE

/datum/map_template/violence/bottlewar
	name = "Устранение Конкуренции"
	description = "2 пекарни пытаются устранить конкурентов."
	mappath = "_maps/violence/violence17.dmm"
	weight = 5
	min_players = 32
	max_players = 64
	theme = VIOLENCE_THEME_STD
