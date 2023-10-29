/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME   (you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = 'ICON FILENAME' 			(defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to true)
	ambience_index = AMBIENCE_GENERIC   (picks the ambience from an assoc list in ambience.dm)
	ambientsounds = list()				(defaults to ambience_index's assoc on Initialize(). override it as "ambientsounds = list('sound/ambience/signal.ogg')" or by changing ambience_index)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/ai_monitored	//stub defined ai_monitored.dm

/area/ai_monitored/turret_protected

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_STARLIGHT
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | NO_ALERTS | AREA_USES_STARLIGHT
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	ambientsounds = SPACE

	flags_1 = CAN_BE_DIRTY_1
	enabled_area_tension = FALSE
	sound_environment = SOUND_AREA_SPACE

/area/space/nearstation
	icon_state = "space_near"
	area_flags = UNIQUE_AREA | NO_ALERTS | AREA_USES_STARLIGHT
	enabled_area_tension = FALSE

/area/start
	name = "Лобби"
	icon_state = "start"
	requires_power = FALSE
	static_lighting = FALSE
	has_gravity = STANDARD_GRAVITY
	enabled_area_tension = FALSE
	base_lighting_alpha = 255


/area/testroom
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	name = "Тестовая комната"
	icon_state = "storage"
	enabled_area_tension = FALSE

//EXTRA

/area/asteroid
	name = "Астероид"
	icon_state = "asteroid"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = UNIQUE_AREA
	ambience_index = AMBIENCE_MINING
	ambientsounds = MINING
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_ASTEROID

/area/asteroid/nearstation
	static_lighting = TRUE
	ambience_index = AMBIENCE_RUINS
	ambientsounds = RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	area_flags = UNIQUE_AREA | BLOBS_ALLOWED

/area/asteroid/nearstation/bomb_site
	name = "Астероид-полигон"

//STATION13

//Maintenance

/area/maintenance
	name = "Техтоннели"
	ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

//Departments

/area/maintenance/department/chapel
	name = "Техтоннели: Церковь"
	icon_state = "maint_chapel"

/area/maintenance/department/chapel/monastery
	name = "Техтоннели: Монастырь"
	icon_state = "maint_monastery"

/area/maintenance/department/crew_quarters/bar
	name = "Техтоннели: Бар"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/maintenance/department/crew_quarters/dorms
	name = "Техтоннели: Дормитории"
	icon_state = "maint_dorms"

/area/maintenance/department/eva
	name = "Техтоннели: ЕВА"
	icon_state = "maint_eva"

/area/maintenance/department/electrical
	name = "Техтоннели: Обслуживание"
	icon_state = "maint_electrical"

/area/maintenance/department/engine/atmos
	name = "Техтоннели: Атмосферные"
	icon_state = "maint_atmos"

/area/maintenance/department/security
	name = "Техтоннели: Охрана"
	icon_state = "maint_sec"

/area/maintenance/department/security/upper
	name = "Техтоннели: Верхняя охрана"

/area/maintenance/department/security/brig
	name = "Техтоннели: Бриг"
	icon_state = "maint_brig"

/area/maintenance/department/medical
	name = "Техтоннели: Медбей"
	icon_state = "medbay_maint"

/area/maintenance/department/medical/central
	name = "Техтоннели: Центральный медбей"
	icon_state = "medbay_maint_central"

/area/maintenance/department/medical/morgue
	name = "Техтоннели: Морг"
	icon_state = "morgue_maint"

/area/maintenance/department/science
	name = "Техтоннели: Научный отдел"
	icon_state = "maint_sci"

/area/maintenance/department/science/central
	name = "Техтоннели: Центр научного отдела"
	icon_state = "maint_sci_central"

/area/maintenance/department/cargo
	name = "Техтоннели: Снабжение"
	icon_state = "maint_cargo"

/area/maintenance/department/bridge
	name = "Техтоннели: Мостик"
	icon_state = "maint_bridge"

/area/maintenance/department/engine
	name = "Техтоннели: Инженерный"
	icon_state = "maint_engi"

/area/maintenance/department/science/xenobiology
	name = "Техтоннели: Ксенобиология"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE


//Maintenance - Generic

/area/maintenance/aft
	name = "Техтоннели: Южные"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Техтоннели: Верхние южные"

/area/maintenance/aft/secondary
	name = "Техтоннели: Вторичные южные"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Техтоннели: Центральные"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Техтоннели: Вторичные центральные"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Техтоннели: Северные"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Техтоннели: Верхние северные"

/area/maintenance/fore/secondary
	name = "Техтоннели: Вторичные северные"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Техтоннели: Восточные"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Техтоннели: Верхние восточные"

/area/maintenance/starboard/central
	name = "Техтоннели: Центрально-восточные"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Техтоннели: Вторичные восточные"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Техтоннели: Юго-восточные"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Техтоннели: Вторичные юго-восточные"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Техтоннели: Северо-восточные"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Техтоннели: Восточные"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Техтоннели: Центрально-восточные"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Техтоннели: Восточные"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Техтоннели: Северно-восточные"
	icon_state = "fpmaint"

/area/maintenance/disposal
	name = "Техтоннели: Утилизация отходов"
	icon_state = "disposal"

/area/maintenance/disposal/incinerator
	name = "Техтоннели: Сжигатель"
	icon_state = "incinerator"

/area/maintenance/space_hut
	name = "Техтоннели: Космическая хижина"
	icon_state = "spacehut"

/area/maintenance/space_hut/cabin
	name = "Техтоннели: Заброшенная хижина"

/area/maintenance/space_hut/plasmaman
	name = "Техтоннели: Заброшенный домик дружелюбного плазмамена"

/area/maintenance/space_hut/observatory
	name = "Техтоннели: Космическая обсерватория"

/area/maintenance/tram
	name = "Техтоннели: Основные трамвайные"

/area/maintenance/tram/left
	name = "Техтоннели: Западные подтрамвайные"
	icon_state = "mainttramL"

/area/maintenance/tram/mid
	name = "Техтоннели: Центральные подтрамвайные"
	icon_state = "mainttramM"

/area/maintenance/tram/right
	name = "Техтоннели: Восточные подтрамвайные"
	icon_state = "mainttramR"

//Radation storm shelter
/area/maintenance/radshelter
	name = "Противорадиационное убежище"
	icon_state = "green"

/area/maintenance/radshelter/medical
	name = "Противорадиационное убежище: Медбей"

/area/maintenance/radshelter/sec
	name = "Противорадиационное убежище: Охрана"

/area/maintenance/radshelter/service
	name = "Противорадиационное убежище: Обслуга"

/area/maintenance/radshelter/civil
	name = "Противорадиационное убежище: Гражданские"

/area/maintenance/radshelter/sci
	name = "Противорадиационное убежище: Научный отдел"

/area/maintenance/radshelter/cargo
	name = "Противорадиационное убежище: Снабжение"

//Hallway
/area/hallway
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/hallway/primary
	name = "Коридоры"

/area/hallway/primary/aft
	name = "Коридоры: Южные"
	icon_state = "hallA"

/area/hallway/primary/aft/exploration
	name = "Коридоры, низ: Рейнджеры"
	icon_state = "hallAL1"

/area/hallway/primary/aft/restroom
	name = "Коридоры, низ: Южные"
	icon_state = "hallAL2"

/area/hallway/primary/fore
	name = "Коридоры: Северные"
	icon_state = "hallF"

/area/hallway/primary/fore/to_brig
	name = "Коридоры: К бригу"
	icon_state = "hallF1"

/area/hallway/primary/fore/brig_enter
	name = "Коридоры: Бриг вход"
	icon_state = "hallF2"

/area/hallway/primary/starboard
	name = "Коридоры: Восточные"
	icon_state = "hallS"

/area/hallway/primary/starboard/medbay
	name = "Коридоры: Медблок"
	icon_state = "hallS1"

/area/hallway/primary/starboard/botan
	name = "Коридоры: Ботаника"
	icon_state = "hallS2"

/area/hallway/primary/starboard/rnd
	name = "Коридоры: РнД"
	icon_state = "hallS3"

/area/hallway/primary/starboard/low_level_service
	name = "Коридоры, низ: сервис"
	icon_state = "hallSL1"

/area/hallway/primary/port
	name = "Коридоры: Западные"
	icon_state = "hallP"

/area/hallway/primary/port/to_arrival
	name = "Коридоры: К прибытию"
	icon_state = "hallP1"

/area/hallway/primary/port/gate
	name = "Коридоры, низ: Врата"
	icon_state = "hallPL1"

/area/hallway/primary/port/vault
	name = "Коридоры: Ваулт"
	icon_state = "hallP2"

/area/hallway/primary/central
	name = "Коридоры: Центральные"
	icon_state = "hallC"

/area/hallway/primary/central/upload
	name = "Мостик: Турели"
	icon_state = "hallC"

/area/hallway/primary/central/north
	name = "Коридоры: Центр, Север"
	icon_state = "hallC1"

/area/hallway/primary/central/west
	name = "Коридоры: Центр, Запад"
	icon_state = "hallC2"

/area/hallway/primary/central/south
	name = "Коридоры: Центр, Юг"
	icon_state = "hallC3"

/area/hallway/primary/central/east
	name = "Коридоры: Центр, Восток"
	icon_state = "hallC4"

/area/hallway/primary/central/low_level_eva
	name = "Коридоры, низ: ЕВА"
	icon_state = "hallCL1"

/area/hallway/primary/central/low_level_centre
	name = "Коридоры, низ: Центр"
	icon_state = "hallCL2"

/area/hallway/primary/upper
	name = "Коридоры: Верхние центральные"
	icon_state = "hallC"
// this one used at blueshift
/area/hallway/primary/blueshift/plasmaman
	name = "Коридоры: Магазин плазмаменов"
	icon_state = "hallC" // mnee

/area/commons/dorms/sauna
	name = "Зона отдыха: Сауна" // pohui

/area/maintenance/department/electrical/two
	name = "Техтоннели: Второе обслуживание"

/area/security/prison/sauna
	name = "Тюрьма: Сауна"

/area/maintenance/port/central/west
	name = "Техтоннели: Центральные-западные"
	icon_state = "maintcentral"

/area/maintenance/port/central/north
	name = "Техтоннели: Центральные-северные"

/area/maintenance/port/northwest
	name = "Техтоннели: Северо-западные"

/area/maintenance/port/southwest
	name = "Техтоннели: Юго-западные"

/area/maintenance/port/north
	name = "Техтоннели: Северные"

/area/maintenance/starboard/engineering
	name = "Техтоннели: Двигатель"
//
/area/hallway/primary/tram
	name = "Коридоры: Метро"

/area/hallway/primary/tram/left
	name = "Коридоры: Запад метро"
	icon_state = "halltramL"

/area/hallway/primary/tram/center
	name = "Коридоры: Центр метро"
	icon_state = "halltramM"

/area/hallway/primary/tram/right
	name = "Коридоры: Восток метро"
	icon_state = "halltramR"

/area/hallway/secondary/command
	name = "Коридоры: Командование"
	icon_state = "bridge_hallway"

/area/hallway/secondary/construction
	name = "Коридоры: Строительная площадка"
	icon_state = "construction"

/area/hallway/secondary/construction/engineering
	name = "Инженерная стройплощадка"

/area/hallway/secondary/exit
	name = "Коридоры: Эвакуация"
	icon_state = "escape"

/area/hallway/secondary/exit/departure_lounge
	name = "Коридоры, Эвакуация"
	icon_state = "escape_lounge"

/area/hallway/secondary/exit/departure_lounge/botan
	name = "Коридоры, низ: Ботаника"
	icon_state = "escape_lounge"

/area/hallway/secondary/exit/departure_lounge/shop
	name = "Коридоры, низ: Магазин"
	icon_state = "escape_lounge2"

/area/hallway/secondary/exit/departure_lounge/cryo
	name = "Коридоры, низ: Криокапсулы"
	icon_state = "escape_lounge3"

/area/hallway/secondary/entry
	name = "Прибытие: Шаттл"
	icon_state = "entry1"

/area/hallway/secondary/entry/public
	name = "Прибытие: Публичный док"
	icon_state = "entry2"

/area/hallway/secondary/entry/south
	name = "Прибытие: Южный коридор"
	icon_state = "entry3"

/area/hallway/secondary/entry/south_hall
	name = "Прибытие: Южный зал"
	icon_state = "entry4"

/area/hallway/secondary/service
	name = "Коридоры: Обслуга"
	icon_state = "hall_service"

//Command

/area/command
	name = "Командование"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/command/bridge
	name = "Мостик"
	icon_state = "bridge"

/area/command/meeting_room
	name = "Мостик: Комната встреч"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/meeting_room/council
	name = "Мостик: Зал совета"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/corporate_showroom
	name = "Мостик: Выставочный зал"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/heads_quarters
	airlock_wires = /datum/wires/airlock/command

/area/command/heads_quarters/captain
	name = "Каюты: Офис капитана"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/command/heads_quarters/captain/private
	name = "Каюты: Капитан"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/command/heads_quarters/ce
	name = "Каюты: Старший инженер"
	icon_state = "ce_office"

/area/command/heads_quarters/cmo
	name = "Каюты: Главный врач"
	icon_state = "cmo_office"

/area/command/heads_quarters/hop
	name = "Каюты: Кадровик"
	icon_state = "hop_office"

/area/command/heads_quarters/hos
	name = "Каюты: Начальник охраны"
	icon_state = "hos_office"

/area/command/heads_quarters/rd
	name = "Каюты: Научный руководитель"
	icon_state = "rd_office"

/area/comms
	name = "Телекоммуникации: Реле связи"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/server
	name = "Телекоммуникации: Серверная комната обмена сообщениями"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION

//Crew

/area/commons
	name = "Зона отдыха"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/commons/dorms
	name = "Зона отдыха: Дормитории"
	icon_state = "dorms"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA

/area/commons/dorms/one
	name = "Комната: Первая"

/area/commons/dorms/two
	name = "Комната: Вторая"

/area/commons/dorms/three
	name = "Комната: Третья"

/area/commons/dorms/four
	name = "Комната: Четвёртая"

/area/commons/dorms/five
	name = "Комната: Пятая"

/area/commons/dorms/six
	name = "Комната: Шестая"

/area/commons/dorms/seven
	name = "Комната: Седьмая"

/area/commons/dorms/eight
	name = "Комната: Восьмая"

/area/commons/dorms/nine
	name = "Комната: Девятая"

/area/commons/dorms/ten
	name = "Комната: Десятая"

/area/commons/dorms/cabin/one
	name = "Кабина дорм: Первая"

/area/commons/dorms/cabin/two
	name = "Кабина дорм: Вторая"

/area/commons/dorms/cabin/three
	name = "Кабина дорм: Третья"

/area/commons/dorms/cabin/four
	name = "Кабина дорм: Четвертая"

/area/commons/dorms/barracks
	name = "Зона отдыха: Бараки"

/area/commons/dorms/barracks/male
	name = "Зона отдыха: Мужские бараки"
	icon_state = "dorms_male"

/area/commons/dorms/barracks/female
	name = "Зона отдыха: Женские бараки"
	icon_state = "dorms_female"

/area/commons/toilet
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/commons/toilet/auxiliary
	name = "Зона отдыха: Вспомогательные туалеты"
	icon_state = "toilet"

/area/commons/toilet/locker
	name = "Зона отдыха: Туалеты раздевалки"
	icon_state = "toilet"

/area/commons/toilet/restrooms
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"

/area/commons/locker
	name = "Зона отдыха: Раздевалка"
	icon_state = "locker"

/area/commons/lounge
	name = "Зона отдыха: Гостиная"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/commons/fitness
	name = "Зона отдыха: Фитнес-зал"
	icon_state = "fitness"

/area/commons/fitness/locker_room
	name = "Зона отдыха: Раздевалка унисекс"
	icon_state = "locker"

/area/commons/fitness/locker_room/male
	name = "Зона отдыха: Мужская раздевалка"
	icon_state = "locker_male"

/area/commons/fitness/locker_room/female
	name = "Зона отдыха: Женская раздевалка"
	icon_state = "locker_female"

/area/commons/spacepod_docks
	name = "Прибытие: Точка посадки спейсподов"
	icon_state = "locker_female" // впадлу иконку пилить

/area/commons/fitness/recreation
	name = "Зона отдыха"
	icon_state = "rec"

/area/commons/cryopods
	name = "Криоподы"
	icon_state = "cryo"

/area/service/cafeteria
	name = "Зона отдыха: Кафетерий"
	icon_state = "cafeteria"

/area/service/kitchen
	name = "Зона отдыха: Кухня"
	icon_state = "kitchen"
	airlock_wires = /datum/wires/airlock/service

/area/service/kitchen/coldroom
	name = "Зона отдыха: Морозильная камера кухни"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/bar
	name = "Зона отдыха: Бар"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = span_nicegreen("Обожаю отдохнуть в баре!\n")
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/bar/Initialize(mapload)
	. = ..()
	GLOB.bar_areas += src

/area/service/bar/atrium
	name = "Зона отдыха: Атриум"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/electronic_marketing_den
	name = "Зона отдыха: Кабинет электронного маркетинга"
	icon_state = "abandoned_m_den"

/area/service/abandoned_gambling_den
	name = "Зона отдыха: Заброшенный игорный дом"
	icon_state = "abandoned_g_den"

/area/service/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/service/theater
	name = "Зона отдыха: Театр"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/service/theater/abandoned
	name = "Зона отдыха: Заброшенный театр"
	icon_state = "abandoned_theatre"

/area/service/library
	name = "Зона отдыха: Библиотека"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>I love being in the library!</span>\n"
	mood_trait = TRAIT_INTROVERT
	area_flags = CULT_PERMITTED
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/service/library/lounge
	name = "Зона отдыха: Гостинная библиотеки"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/service/library/artgallery
	name = "Зона отдыха: Галерея искусств"
	icon_state = "library_gallery"

/area/service/library/private
	name = "Зона отдыха: Личный кабинет библиотеки"
	icon_state = "library_gallery_private"

/area/service/library/upper
	name = "Зона отдыха: Верхняя библиотека"
	icon_state = "library"

/area/service/library/printer
	name = "Зона отдыха: Комната принтеров библиотеки"
	icon_state = "library"

/area/service/library/abandoned
	name = "Зона отдыха: Заброшенная библиотека"
	icon_state = "abandoned_library"
	area_flags = CULT_PERMITTED

/area/service/chapel
	icon_state = "chapel"
	ambience_index = AMBIENCE_HOLY
	ambientsounds = HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/service/chapel/main
	name = "Церковь"

/area/service/chapel/main/monastery
	name = "Монастырь"

/area/service/chapel/office
	name = "Офис церкви"
	icon_state = "chapeloffice"

/area/service/chapel/asteroid
	name = "Астероид-церковь"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/service/chapel/asteroid/monastery
	name = "Астероид-монастырь"

/area/service/chapel/dock
	name = "Док церкви"
	icon_state = "construction"

/area/lawoffice
	name = "Адвокатская контора"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/service/janitor
	name = "Кладовая уборщика"
	icon_state = "janitor"
	area_flags = CULT_PERMITTED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/janitor/second
	name = "Запасная кладовая уборщика"

/area/service/hydroponics
	name = "Гидропоника"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/service/hydroponics/upper
	name = "Верхняя Гидропоника"
	icon_state = "hydro"

/area/service/hydroponics/garden
	name = "Сад"
	icon_state = "garden"

/area/service/hydroponics/garden/abandoned
	name = "Заброшенный Сад"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/hydroponics/garden/monastery
	name = "Монастырский Сад"
	icon_state = "hydro"

//Engineering

/area/engineering
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engineering/engine_smes
	name = "Инженерный: СМЕСы"
	icon_state = "engine_smes"

/area/engineering/main
	name = "Инженерный"
	icon_state = "engine"

/area/engineering/atmos
	name = "Инженерный: АТМОС"
	icon_state = "atmos1"
	area_flags = CULT_PERMITTED

/area/engineering/atmos/project
	name = "Инженерный: Атмос: Проект"
	icon_state = "atmos1"

/area/engineering/atmos/upper
	name = "Инженерный: АТМОС зал"
	icon_state = "atmos2"

/area/engineering/atmospherics_engine
	name = "Инженерный: Атмосферный двигатель"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engineering/engine_room //donut station specific
	name = "Инженерный: Машинное отделение"
	icon_state = "atmos_engine"

/area/engineering/manufactory
	name = "Инженерный: Фабрика"
	icon_state = "fabrica"

/area/engineering/lobby
	name = "Инженерный: Лобби"
	icon_state = "engi_lobby"

/area/engineering/engine_room/external
	name = "Инженерный: Внешний доступ к суперматерии"
	icon_state = "engine_foyer"

/area/engineering/supermatter
	name = "Инженерный: Двигатель суперматерии"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/break_room
	name = "Инженерный: Фойе"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/gravity_generator
	name = "Инженерный: Генератор Гравитации"
	icon_state = "grav_gen"

/area/engineering/storage
	name = "Инженерный: Хранилище"
	icon_state = "engi_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/storage_shared
	name = "Инженерный: Общее хранилище"
	icon_state = "engi_storage"

/area/engineering/second_engy
	name = "Вторичный инженерный блок"
	icon_state = "engine_room1"

/area/engineering/transit_tube
	name = "Инженерный: Транзитная труба"
	icon_state = "transit_tube"


//Solars

/area/solar
	requires_power = FALSE
	area_flags = UNIQUE_AREA | AREA_USES_STARLIGHT
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE
	base_lighting_alpha = 255

/area/solars/fore
	name = "Солнечные панели: Северные"
	icon_state = "yellow"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/solars/aft
	name = "Солнечные панели: Южные"
	icon_state = "yellow"

/area/solars/aux/port
	name = "Солнечные панели: Запасные"
	icon_state = "panelsA"

/area/solars/aux/starboard
	name = "Солнечные панели: Запасные восточные"
	icon_state = "panelsA"

/area/solars/starboard
	name = "Солнечные панели: Восточные"
	icon_state = "panelsS"

/area/solars/starboard/aft
	name = "Солнечные панели: Юго-восточные"
	icon_state = "panelsAS"

/area/solars/starboard/fore
	name = "Солнечные панели: Северо-восточные"
	icon_state = "panelsFS"

/area/solars/port
	name = "Солнечные панели: Западные"
	icon_state = "panelsP"

/area/solars/port/aft
	name = "Солнечные панели: Юго-западные"
	icon_state = "panelsAP"

/area/solars/port/fore
	name = "Солнечные панели: Северо-западные"
	icon_state = "panelsFP"

/area/solars/aisat
	name = "ИИ: Солнечные панели"
	icon_state = "yellow"


//Solar Maint

/area/maintenance/solars
	name = "Техтоннели: Солнечные панели"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Техтоннели: Солнечные панели: Западные"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Техтоннели: Солнечные панели: Юго-западные"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Техтоннели: Солнечные панели: Северо-западные"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Техтоннели: Солнечные панели: Восточные"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Техтоннели: Солнечные панели: Юго-восточные"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Техтоннели: Солнечные панели: Северо-восточные"
	icon_state = "SolarcontrolFS"

//Teleporter

/area/command/teleporter
	name = "Комната телепорта"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/command

/area/command/gateway
	name = "Звёздные врата"
	icon_state = "gateway"
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

//MedBay

/area/medical
	name = "Медбей"
	icon_state = "medbay1"
	ambience_index = AMBIENCE_MEDICAL
	ambientsounds = MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/medical/abandoned
	name = "Медбей: Заброшенный"
	icon_state = "abandoned_medbay"
	ambientsounds = list('sound/ambience/signal.ogg')
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/medbay/central
	name = "Медбей: Центр"
	icon_state = "med_central"

/area/medical/medbay/lobby
	name = "Медбей: Лобби"
	icon_state = "med_lobby"

	//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Медбей: Дополнительный"
	icon_state = "medbay2"

/area/medical/medbay/aft
	name = "Медбей: Западный"
	icon_state = "med_aft"

/area/medical/storage
	name = "Медбей: Хранилище"
	icon_state = "med_storage"

/area/medical/paramedic
	name = "Медбей: Фельдшер"
	icon_state = "paramedic"

/area/medical/office
	name = "Медбей: Офис"
	icon_state = "med_office"

/area/medical/surgery/room_c
	name = "Медбей: Хирургия C"
	icon_state = "surgery"

/area/medical/surgery/room_d
	name = "Медбей: Хирургия D"
	icon_state = "surgery"

/area/medical/break_room
	name = "Медбей: Комната отдыха"
	icon_state = "med_break"

/area/medical/coldroom
	name = "Медбей: Морозилка"
	icon_state = "kitchen_cold"

/area/medical/patients_rooms
	name = "Медбей: Палаты"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/medical/patients_rooms/room_a
	name = "Медбей: Палата пациента A"
	icon_state = "patients"

/area/medical/patients_rooms/room_b
	name = "Медбей: Палата пациента B"
	icon_state = "patients"

/area/medical/virology
	name = "Медбей: Вирусология"
	icon_state = "virology"
	area_flags = CULT_PERMITTED

/area/medical/morgue
	name = "Медбей: Морг"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	ambientsounds = SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/chemistry
	name = "Медбей: Химия"
	icon_state = "chem"

/area/medical/pharmacy
	name = "Медбей: Аптека"
	icon_state = "pharmacy"

/area/medical/surgery
	name = "Медбей: Хирургия А"
	icon_state = "surgery"

/area/medical/surgery/room_b
	name = "Медбей: Хирургия B"
	icon_state = "surgery"

/area/medical/cryo
	name = "Медбей: Криогеника"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Медбей: Экзаменационная комната"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Медбей: Лаборатория генетики"
	icon_state = "genetics"

/area/medical/sleeper
	name = "Медбей: Лечебный центр"
	icon_state = "exam_room"

/area/medical/psychology
	name = "Медбей: Психолог"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = span_nicegreen("Здесь спокойно.\n")
	ambientsounds = list('sound/ambience/aurora_caelus_short.ogg')

//Security

/area/security
	name = "Охрана"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/security/main
	name = "Охрана: Офис"
	icon_state = "security"

/area/security/main/mechanic
	name = "Охрана: Мастерская"
	icon_state = "security_1"

/area/security/main/lockers
	name = "Охрана: Снаряжение"
	icon_state = "security_2"

/area/security/main/evidence
	name = "Охрана: Хранилище"
	icon_state = "security_3"

/area/security/main/sb_med
	name = "Охрана: Лазарет"
	icon_state = "security_4"

/area/security/main/angar
	name = "Охрана: Ангар"
	icon_state = "security_5"

/area/security/brig
	name = "Охрана: Бриг"
	icon_state = "brig"

/area/security/brig/upper
	name = "Охрана: Верхний бриг"

/area/security/courtroom
	name = "Охрана: Зал суда"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/security/prison
	name = "Тюрьма"
	icon_state = "sec_prison"
	mood_bonus = -2
	mood_message = span_deadsay("Я здесь точно сгнию...\n")

/area/security/prison/Entered(atom/movable/arrived, area/old_area)
	. = ..()

	if(!ishuman(arrived))
		return

	if(istype(old_area, /area/security/prison))
		return

	arrived.AddComponent(/datum/component/imprisoned)

/area/security/prison/toilet //radproof
	name = "Тюрьма: Туалет"
	icon_state = "sec_prison_safe"

/area/security/prison/safe //radproof
	name = "Тюрьма: Камеры"
	icon_state = "sec_prison_safe"

/area/security/prison/upper
	name = "Тюрьма: Верхняя"
	icon_state = "prison_upper"

/area/security/prison/visit
	name = "Тюрьма: Зона посещения"
	icon_state = "prison_visit"

/area/security/prison/rec
	name = "Тюрьма: Комната отдыха"
	icon_state = "prison_rec"

/area/security/prison/mess
	name = "Тюрьма: Столовая"
	icon_state = "prison_mess"

/area/security/prison/work
	name = "Тюрьма: Цех"
	icon_state = "prison_work"

/area/security/prison/shower
	name = "Тюрьма: Душ"
	icon_state = "prison_shower"

/area/security/prison/workout
	name = "Тюрьма: Спортзал"
	icon_state = "prison_workout"

/area/security/prison/garden
	name = "Тюрьма: Сад"
	icon_state = "prison_garden"

/area/security/processing
	name = "Тюрьма: Док"
	icon_state = "sec_processing"

/area/security/processing/cremation
	name = "Охрана: Крематорий"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/security/warden
	name = "Охрана: Надзиратель"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/detectives_office
	name = "Охрана: Детектив"
	icon_state = "detective"
	ambientsounds = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg')

/area/security/detectives_office/private_investigators_office
	name = "Кабинет частного детектива"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/range
	name = "Охрана: Стрельбище"
	icon_state = "firingrange"

/area/security/execution
	icon_state = "execution_room"

/area/security/execution/transfer
	name = "Охрана: Трансфер"
	icon_state = "sec_processing"

/area/security/execution/education
	name = "Охрана: Школа"

/area/ai_monitored/command/nuke_storage
	name = "Охрана: Хранилище"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/security/checkpoint
	name = "Пост охраны"
	icon_state = "checkpoint1"

/area/security/checkpoint/auxiliary
	icon_state = "checkpoint_aux"

/area/security/checkpoint/escape
	icon_state = "checkpoint_esc"

/area/security/checkpoint/supply
	name = "Пост охраны: Снабжение"
	icon_state = "checkpoint_supp"

/area/security/checkpoint/engineering
	name = "Пост охраны: Инженерный"
	icon_state = "checkpoint_engi"

/area/security/checkpoint/medical
	name = "Пост охраны: Медбей"
	icon_state = "checkpoint_med"

/area/security/checkpoint/science
	name = "Пост охраны: Научный"
	icon_state = "checkpoint_sci"

/area/security/checkpoint/science/research
	name = "Пост охраны: Научный отдел"
	icon_state = "checkpoint_res"

/area/security/checkpoint/customs
	name = "Охрана: Таможня"
	icon_state = "customs_point"

/area/security/checkpoint/customs/auxiliary
	icon_state = "customs_point_aux"


//Service

/area/cargo
	name = "Завхоз"
	icon_state = "quart"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/cargo/sorting
	name = "Снабжение: Сортировка"
	icon_state = "cargo_delivery"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/cargo/warehouse
	name = "Снабжение: Склад"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/cargo/warehouse/upper
	name = "Снабжение: Верхний склад"

/area/cargo/office
	name = "Снабжение: Офис"
	icon_state = "cargo_office"

/area/cargo/storage
	name = "Снабжение: Грузовой отсек"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/cargo/qm
	name = "Снабжение: Офис завхоза"
	icon_state = "quart_office"

/area/cargo/qm/perch
	name = "Снабжение: Карниз завхоза"
	icon_state = "quart_perch"

/area/cargo/miningdock
	name = "Снабжение: Шахтёрский док"
	icon_state = "mining"

/area/cargo/miningoffice
	name = "Снабжение: Шахтёрский офис"
	icon_state = "mining"

/area/cargo/miningoffice/meteor
	name = "Улавливатель метеоритов"
	icon_state = "mining_meteor"

/area/cargo/meeting_room
	name = "Снабжение: Комната встреч"
	icon_state = "mining"

/area/cargo/exploration_prep
	name = "Снабжение: Подготовка рейнджеров"
	icon_state = "rangers_prep"

/area/cargo/exploration_dock
	name = "Снабжение: Док рейнджеров"
	icon_state = "rangers_dock"

/area/cargo/exploration_mission
	name = "Снабжение: Миссия рейнджеров"
	icon_state = "rangers_mission"
//Science

/area/science
	name = "Наука"
	icon_state = "science"
	airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/science/breakroom
	name = "Наука: Комната отдыха"

/area/science/lab
	name = "Наука: Лаборатория"
	icon_state = "research"

/area/science/xenobiology
	name = "Наука: Ксенобиология"
	icon_state = "xenobio"

/area/science/cytology
	name = "Наука: Цитология"
	icon_state = "cytology"

/area/science/storage
	name = "Наука: Хранилище токсинов"
	icon_state = "tox_storage"

/area/science/test_area
	name = "Наука: Полигон токсинов"
	icon_state = "tox_test"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/mixing
	name = "Наука: Смешиватель токсинов"
	icon_state = "tox_mix"

/area/science/mixing/chamber
	name = "Наука: Камера смешивания токсинов"
	icon_state = "tox_mix_chamber"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/genetics
	name = "Наука: Генетика"
	icon_state = "geneticssci"

/area/science/misc_lab
	name = "Наука: Тестирование"
	icon_state = "tox_misc"

/area/science/misc_lab/range
	name = "Наука: Тир"
	icon_state = "tox_range"

/area/science/server
	name = "Наука: Серверная"
	icon_state = "server"

/area/science/explab
	name = "Наука: Эксперименты"
	icon_state = "exp_lab"

/area/science/robotics
	name = "Наука: Роботика"
	icon_state = "robotics"

/area/science/robotics/mechbay
	name = "Наука: Мехдок"
	icon_state = "mechbay"

/area/science/robotics/lab
	name = "Наука: Робототехника"
	icon_state = "ass_line"

/area/science/research
	name = "Наука: Исследования"
	icon_state = "science"

/area/science/research/abandoned
	name = "Наука: Заброшенная лаборатория"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/science/nanite
	name = "Наука: Наниты"
	icon_state = "nanite"

//Storage
/area/commons/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/commons/storage/tools
	name = "Хранилище: Запасные инструменты"
	icon_state = "tool_storage"

/area/commons/storage/primary
	name = "Хранилище: Инструменты"
	icon_state = "primary_storage"

/area/commons/storage/art
	name = "Хранилище: Искусство"
	icon_state = "art_storage"

/area/commons/storage/tcom
	name = "Хранилище: Телекоммуникации"
	icon_state = "tcom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/ai_monitored/command/storage/eva
	name = "Хранилище: ЕВА"
	icon_state = "eva"

/area/ai_monitored/command/storage/eva/upper
	name = "Хранилище: Верхнее ЕВА"

/area/commons/storage/emergency/starboard
	name = "Хранилище: Восточное"
	icon_state = "emergency_storage"

/area/commons/storage/emergency/port
	name = "Хранилище: Западное"
	icon_state = "emergency_storage"

/area/engineering/storage/backup
	name = "Хранилище: Запасная техника"
	icon_state = "aux_storage"

/area/engineering/storage/tech
	name = "Хранилище: Платы"
	icon_state = "aux_storage"

/area/commons/storage/mining
	name = "Хранилище: Публичное шахтёрское"
	icon_state = "mining"

//Construction

/area/construction
	name = "Строительная площадка"
	icon_state = "construction"
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/construction/mining/aux_base
	name = "Строительная площадка: База"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/construction/storage_wing
	name = "Строительная площадка: Хранилище"
	icon_state = "storage_wing"

// Vacant Rooms
/area/commons/vacant_room
	name = "Свободная комната"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE

/area/commons/vacant_room/office
	name = "Свободный офис"
	icon_state = "vacant_office"

/area/commons/vacant_room/commissary
	name = "Свободный магазин"
	icon_state = "vacant_commissary"

/area/commons/vacant_room/commissary/second
	name = "Нижний магазин"

/area/commons/vacant_room/commissary/third
	name = "Дополнительный магазин"

/area/commons/vacant_room/commissary/fourth
	name = "Интересный магазин"

//AI

/area/ai_monitored
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/ai_monitored/security/armory
	name = "Охрана: Арсенал"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/security

/area/ai_monitored/security/armory/upper
	name = "Охрана: Верхний арсенал"

/area/ai_monitored/storage/eva
	name = "Хранилище: ЕВА"
	icon_state = "eva"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC

/area/ai_monitored/storage/eva/upper
	name = "Хранилище: Верхняя ЕВА"

/area/ai_monitored/storage/satellite
	name = "Спутник ИИ"
	icon_state = "ai_storage"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/ai

	//Turret_protected

/area/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/ai_upload
	name = "ИИ: Комната загрузки"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai_upload_foyer
	name = "ИИ: Фойе загрузки"
	icon_state = "ai_upload_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai
	name = "ИИ: Зал"
	icon_state = "ai_chamber"

/area/ai_monitored/turret_protected/aisat
	name = "Спутник ИИ"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ai_monitored/turret_protected/aisat/atmos
	name = "Спутник ИИ: Атмосферный отдел"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/foyer
	name = "Спутник ИИ: Фойе"
	icon_state = "ai_foyer"

/area/ai_monitored/turret_protected/aisat/service
	name = "Спутник ИИ: Сервисный отдел"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/hallway
	name = "Спутник ИИ: Коридор"
	icon_state = "ai"

/area/aisat
	name = "Спутник ИИ: Обшивка"
	icon_state = "ai"
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/aisat_interior
	name = "Спутник ИИ: Прихожая"
	icon_state = "ai_interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ai_monitored/turret_protected/ai_sat_ext_as
	name = "Спутник ИИ: Восток"
	icon_state = "ai_sat_east"

/area/ai_monitored/turret_protected/ai_sat_ext_ap
	name = "Спутник ИИ: Запад"
	icon_state = "ai_sat_west"


// Telecommunications Satellite

/area/tcommsat
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg', 'sound/ambience/ambitech.ogg',\
											'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg', 'sound/ambience/ambimystery.ogg')
	airlock_wires = /datum/wires/airlock/engineering
	network_root_id = STATION_NETWORK_ROOT	// They should of unpluged the router before they left

/area/tcommsat/computer
	name = "Телекоммуникации: Диспетчерская"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/tcommsat/server
	name = "Телекоммуникации: Серверная"
	icon_state = "tcomsatcham"

/area/tcommsat/server/upper
	name = "Телекоммуникации: Верхняя серверная"

//External Hull Access
/area/maintenance/external
	name = "Обшивка"
	icon_state = "amaint"

/area/maintenance/external/aft
	name = "Обшивка: Западная"

/area/maintenance/external/port
	name = "Обшивка: Восточная"

/area/maintenance/external/port/bow
	name = "Обшивка: Юго-западная"
