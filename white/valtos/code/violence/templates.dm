
/datum/map_template/violence
	var/description = ""
	var/weight = 0
	var/max_players = 0
	var/theme = "std"

/datum/map_template/violence/default
	name = "Карак"
	description = "Бойня в пустынном бункере."
	mappath = "_maps/map_files/Warfare/violence1.dmm"
	weight = 5
	max_players = 24

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/map_files/Warfare/violence2.dmm"
	weight = 6
	max_players = 16

/datum/map_template/violence/centralpolygon
	name = "Тренировочный Центр"
	description = "Здесь проходят обучение все офицеры Нанотрейзен."
	mappath = "_maps/map_files/Warfare/violence3.dmm"
	weight = 4
	max_players = 64
	theme = "warfare"

/datum/map_template/violence/de_dust2
	name = "de_dust2"
	description = "Здесь происходит что-то странное на польском языке."
	mappath = "_maps/map_files/Warfare/violence4.dmm"
	weight = 2
	max_players = 64
	theme = "warfare"

/datum/map_template/violence/dunes
	name = "Дюны"
	description = "Не кормите червей!"
	mappath = "_maps/map_files/Warfare/violence5.dmm"
	weight = 6
	max_players = 16

/datum/map_template/violence/cyberspess
	name = "Киберпространство"
	description = "Поиграем? Наши киберкотлеты готовы к бою!"
	mappath = "_maps/map_files/Warfare/violence6.dmm"
	weight = 6
	max_players = 16
	theme = "cyber"

/datum/map_template/violence/trahov
	name = "Краков"
	description = "Нанотрейзен и Синдикат не поделили последний мешок сахара. Поможете им разобраться с этим недоразумением?"
	mappath = "_maps/map_files/Warfare/violence7.dmm"
	weight = 6
	max_players = 32
	theme = "warfare"
