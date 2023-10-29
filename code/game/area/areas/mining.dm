/**********************Mine areas**************************/

/area/mine
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED

/area/mine/explored
	name = "Шахта"
	icon_state = "explored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	outdoors = TRUE
	flags_1 = NONE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NO_ALERTS
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/mine/unexplored
	name = "Шахта: Не исследовано"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	outdoors = TRUE
	flags_1 = NONE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED | NO_ALERTS
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/mine/lobby
	name = "Шахта: Лобби"
	icon_state = "mining_lobby"

/area/mine/storage
	name = "Шахта: Хранилище"
	icon_state = "mining_storage"

/area/mine/production
	name = "Шахта: Порт"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "Шахта: Заброшенная станция"

/area/mine/living_quarters
	name = "Шахта: Порт"
	icon_state = "mining_living"

/area/mine/eva
	name = "Шахта: ЕВА"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "Шахта: Техтоннели"

/area/mine/cafeteria
	name = "Шахта: Кафетерии"
	icon_state = "mining_labor_cafe"

/area/mine/hydroponics
	name = "Шахта: Гидропоника"
	icon_state = "mining_labor_hydro"

/area/mine/sleeper
	name = "Шахта: Слиперы"

/area/mine/mechbay
	name = "Шахта: Мехдок"
	icon_state = "mechbay"

/area/mine/laborcamp
	name = "Каторга"
	icon_state = "mining_labor"

/area/mine/laborcamp/security
	name = "Каторга: Охрана"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC




/**********************Lavaland Areas**************************/

/area/lavaland
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_LAVALAND

/area/lavaland/surface
	name = "Лаваленд"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lavaland/underground
	name = "Лаваленд: Пещеры"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS


/area/lavaland/surface/outdoors
	name = "Лаваленд: Пустоши"
	description = "Время охоты!"
	outdoors = TRUE

/area/lavaland/surface/outdoors/unexplored //monsters and ruins spawn here
	description = null
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | NO_ALERTS

/area/lavaland/surface/outdoors/unexplored/danger //megafauna will also spawn here
	description = "Здесь опасно..."
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
	map_generator = /datum/map_generator/cave_generator/lavaland

/area/lavaland/surface/outdoors/explored
	description = "Руды в этом районе мало, но она точно здесь есть."
	name = "Лаваленд: Каторга"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NO_ALERTS



/**********************Ice Moon Areas**************************/

/area/icemoon
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_ICEMOON

/area/icemoon/surface
	name = "Луна"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS

/area/icemoon/surface/outdoors // weather happens here
	name = "Луна: Пустоши"
	outdoors = TRUE

/area/icemoon/surface/outdoors/labor_camp
	name = "Луна: Каторга"
	area_flags = UNIQUE_AREA | NO_ALERTS

/area/icemoon/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED | NO_ALERTS

/area/icemoon/surface/outdoors/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface

/area/icemoon/surface/outdoors/unexplored/rivers/no_monsters
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED | NO_ALERTS

/area/icemoon/underground
	name = "Луна: Пещеры"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS

/area/icemoon/underground/unexplored // mobs and megafauna and ruins spawn here
	name = "Луна: Не исследовано"
	icon_state = "unexplored"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS

/area/icemoon/underground/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers/deep
	map_generator = /datum/map_generator/cave_generator/icemoon/deep

/area/icemoon/underground/explored // ruins can't spawn here
	name = "Луна: Подземелье"
	area_flags = UNIQUE_AREA | NO_ALERTS
