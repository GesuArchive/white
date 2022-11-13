
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
	var/theme = "std"

/datum/map_template/violence/default
	name = "Карак"
	description = "Бойня в пустынном бункере."
	mappath = "_maps/map_files/Warfare/violence1.dmm"
	weight = 5
	min_players = 0
	max_players = 24
	theme = "std"

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/map_files/Warfare/violence2.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = "katana"

/datum/map_template/violence/centralpolygon
	name = "Тренировочный Центр"
	description = "Здесь проходят обучение все офицеры Нанотрейзен."
	mappath = "_maps/map_files/Warfare/violence3.dmm"
	weight = 4
	min_players = 24
	max_players = 64
	theme = "warfare"

/datum/map_template/violence/de_dust2
	name = "de_dust2"
	description = "Здесь происходит что-то странное на польском языке."
	mappath = "_maps/map_files/Warfare/violence4.dmm"
	weight = 2
	min_players = 24
	max_players = 64
	theme = "warfare"

/datum/map_template/violence/dunes
	name = "Дюны"
	description = "Не кормите червей!"
	mappath = "_maps/map_files/Warfare/violence5.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = "std"

/datum/map_template/violence/cyberspess
	name = "Киберпространство"
	description = "Поиграем? Наши киберкотлеты готовы к бою!"
	mappath = "_maps/map_files/Warfare/violence6.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = "cyber"

/datum/map_template/violence/trahov
	name = "Краков"
	description = "Нанотрейзен и Синдикат не поделили последний мешок сахара. Поможете им разобраться с этим недоразумением?"
	mappath = "_maps/map_files/Warfare/violence7.dmm"
	weight = 4
	min_players = 16
	max_players = 64
	theme = "warfare"

/datum/map_template/violence/koridorovo
	name = "Коридоры"
	description = "Город состоящий из коридоров. Кто это придумал?"
	mappath = "_maps/map_files/Warfare/violence8.dmm"
	weight = 5
	min_players = 24
	max_players = 64
	theme = "hotline"

/datum/map_template/violence/okinawa
	name = "Окинава"
	description = "Борьба за последний клочок земли происходит именно здесь."
	mappath = "_maps/map_files/Warfare/violence9.dmm"
	weight = 8
	min_players = 12
	max_players = 32
	theme = "katana"

/datum/map_template/violence/pool
	name = "Бассейн"
	description = "Плыли мы по морю, ветер мачту рвал..."
	mappath = "_maps/map_files/Warfare/violence10.dmm"
	weight = 6
	min_players = 0
	max_players = 16
	theme = "std"

/datum/map_template/violence/desert
	name = "Пустыня"
	description = "Черви проголодались и... ушли из этой зоны боевых действий, ну дела!"
	mappath = "_maps/map_files/Warfare/violence11.dmm"
	weight = 9
	min_players = 16
	max_players = 64
	theme = "std"

/datum/map_template/violence/portalovo
	name = "Портальная авантюра"
	description = "Нанотрейзен хочет протестировать новую портальную технологию в бою. Что может пойти не так?"
	mappath = "_maps/map_files/Warfare/violence12.dmm"
	weight = 8
	min_players = 16
	max_players = 32
	theme = "portal"

/datum/map_template/violence/cyberwarfare
	name = "Кибербойня"
	description = "Киберпространство расширено. Кто выживет в этой бессмысленной схватке?"
	mappath = "_maps/map_files/Warfare/violence13.dmm"
	weight = 15
	min_players = 16
	max_players = 32
	theme = "cyber"
