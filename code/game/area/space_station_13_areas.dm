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
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | NO_ALERTS
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	ambientsounds = SPACE

	flags_1 = CAN_BE_DIRTY_1
	enabled_area_tension = FALSE
	sound_environment = SOUND_AREA_SPACE

/area/space/nearstation
	icon_state = "space_near"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED //DYNAMIC_LIGHTING_IFSTARLIGHT
	enabled_area_tension = FALSE

/area/start
	name = "Лобби"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY
	enabled_area_tension = FALSE


/area/testroom
	requires_power = FALSE
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
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
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
	name = "Техтоннели: Кормовые"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Техтоннели: Верхние кормовые"

/area/maintenance/aft/secondary
	name = "Техтоннели: Вторичные кормовые"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Техтоннели: Центр"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Техтоннели: Вторичный центр"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Техтоннели: Носовые"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Техтоннели: Верхние носовые"

/area/maintenance/fore/secondary
	name = "Техтоннели: Вторичные носовые"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Техтоннели: Правый борт"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Техтоннели: Верхний правый борт"

/area/maintenance/starboard/central
	name = "Техтоннели: Центральный правый борт"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Техтоннели: Вторичный правый борт"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Техтоннели: Кормовой правый борт"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Техтоннели: Вторичный кормовой правый борт"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Техтоннели: Носовой правый борт"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Техтоннели: Порт"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Техтоннели: Центральный порт"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Техтоннели: Кормовой порт"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Техтоннели: Носовой порт"
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
	name = "Техтоннели: Портовые подтрамвайные"
	icon_state = "mainttramL"

/area/maintenance/tram/mid
	name = "Техтоннели: Центральные подтрамвайные"
	icon_state = "mainttramM"

/area/maintenance/tram/right
	name = "Техтоннели: Правобортовые подтрамвайные"
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
	name = "Коридоры: Кормовые"
	icon_state = "hallA"

/area/hallway/primary/fore
	name = "Коридоры: Носовые"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Коридоры: Правый борт"
	icon_state = "hallS"

/area/hallway/primary/port
	name = "Коридоры: Порт"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Коридоры: Центральный"
	icon_state = "hallC"

/area/hallway/primary/upper
	name = "Коридоры: Верхний центральный"
	icon_state = "hallC"

/area/hallway/primary/tram
	name = "Коридоры: Метро"

/area/hallway/primary/tram/left
	name = "Коридоры: Порт метро"
	icon_state = "halltramL"

/area/hallway/primary/tram/center
	name = "Коридоры: Центр метро"
	icon_state = "halltramM"

/area/hallway/primary/tram/right
	name = "Коридоры: Правый борт метро"
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
	name = "Коридоры: Зал ожидания"
	icon_state = "escape_lounge"

/area/hallway/secondary/entry
	name = "Коридоры: Шаттл прибытия"
	icon_state = "entry"

/area/hallway/secondary/service
	name = "Коридоры: Обслуга"
	icon_state = "hall_service"

//Command

/area/bridge
	name = "Мостик"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/bridge/meeting_room
	name = "Мостик: Комната встреч"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/meeting_room/council
	name = "Мостик: Зал совета"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/showroom/corporate
	name = "Мостик: Выставочный зал"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/crew_quarters/heads
	airlock_wires = /datum/wires/airlock/command

/area/crew_quarters/heads/captain
	name = "Каюты: Офис капитана"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/captain/private
	name = "Каюты: Капитан"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/chief
	name = "Каюты: Старший инженер"
	icon_state = "ce_office"

/area/crew_quarters/heads/cmo
	name = "Каюты: Главный врач"
	icon_state = "cmo_office"

/area/crew_quarters/heads/hop
	name = "Каюты: Кадровик"
	icon_state = "hop_office"

/area/crew_quarters/heads/hos
	name = "Каюты: Начальник охраны"
	icon_state = "hos_office"

/area/crew_quarters/heads/hor
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

/area/crew_quarters
	name = "Зона отдыха"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/crew_quarters/dorms
	name = "Зона отдыха: Дормитории"
	icon_state = "dorms"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA

/area/crew_quarters/dorms/barracks
	name = "Зона отдыха: Бараки"

/area/crew_quarters/dorms/barracks/male
	name = "Зона отдыха: Мужские бараки"
	icon_state = "dorms_male"

/area/crew_quarters/dorms/barracks/female
	name = "Зона отдыха: Женские бараки"
	icon_state = "dorms_female"

/area/crew_quarters/toilet
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/toilet/auxiliary
	name = "Зона отдыха: Вспомогательные туалеты"
	icon_state = "toilet"

/area/crew_quarters/toilet/locker
	name = "Зона отдыха: Туалеты раздевалки"
	icon_state = "toilet"

/area/crew_quarters/toilet/restrooms
	name = "Зона отдыха: Туалеты"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Зона отдыха: Раздевалка"
	icon_state = "locker"

/area/crew_quarters/lounge
	name = "Зона отдыха: Гостиная"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/crew_quarters/fitness
	name = "Зона отдыха: Фитнес-зал"
	icon_state = "fitness"

/area/crew_quarters/fitness/locker_room
	name = "Зона отдыха: Раздевалка унисекс"
	icon_state = "locker"

/area/crew_quarters/fitness/locker_room/male
	name = "Зона отдыха: Мужская раздевалка"
	icon_state = "locker_male"

/area/crew_quarters/fitness/locker_room/female
	name = "Зона отдыха: Женская раздевалка"
	icon_state = "locker_female"


/area/crew_quarters/fitness/recreation
	name = "Зона отдыха"
	icon_state = "rec"

/area/crew_quarters/cafeteria
	name = "Зона отдыха: Кафетерий"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Зона отдыха: Кухня"
	icon_state = "kitchen"
	airlock_wires = /datum/wires/airlock/service

/area/crew_quarters/kitchen/coldroom
	name = "Зона отдыха: Морозильная камера кухни"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/bar
	name = "Зона отдыха: Бар"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>Обожаю отдохнуть в баре!\n</span>"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/bar/atrium
	name = "Зона отдыха: Атриум"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/electronic_marketing_den
	name = "Зона отдыха: Кабинет электронного маркетинга"
	icon_state = "abandoned_m_den"

/area/crew_quarters/abandoned_gambling_den
	name = "Зона отдыха: Заброшенный игорный дом"
	icon_state = "abandoned_g_den"

/area/crew_quarters/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/crew_quarters/theatre
	name = "Зона отдыха: Театр"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/theatre/abandoned
	name = "Зона отдыха: Заброшенный театр"
	icon_state = "abandoned_theatre"

/area/library
	name = "Зона отдыха: Библиотека"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>I love being in the library!</span>\n"
	mood_trait = TRAIT_INTROVERT
	area_flags = CULT_PERMITTED
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/library/lounge
	name = "Зона отдыха: Гостинная библиотеки"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/library/artgallery
	name = "Зона отдыха: Галерея искусств"
	icon_state = "library_gallery"

/area/library/private
	name = "Зона отдыха: Личный кабинет библиотеки"
	icon_state = "library_gallery_private"

/area/library/upper
	name = "Зона отдыха: Верхняя библиотека"
	icon_state = "library"

/area/library/printer
	name = "Зона отдыха: Комната принтеров библиотеки"
	icon_state = "library"

/area/library/abandoned
	name = "Зона отдыха: Заброшенная библиотека"
	icon_state = "abandoned_library"
	area_flags = CULT_PERMITTED

/area/chapel
	icon_state = "chapel"
	ambience_index = AMBIENCE_HOLY
	ambientsounds = HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/chapel/main
	name = "Церковь"

/area/chapel/main/monastery
	name = "Монастырь"

/area/chapel/office
	name = "Офис церкви"
	icon_state = "chapeloffice"

/area/chapel/asteroid
	name = "Астероид-церковь"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/chapel/asteroid/monastery
	name = "Астероид-монастырь"

/area/chapel/dock
	name = "Док церкви"
	icon_state = "construction"

/area/lawoffice
	name = "Адвокатская контора"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/service/janitor
	name = "Custodial Closet"
	icon_state = "janitor"
	area_flags = CULT_PERMITTED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/service/hydroponics/upper
	name = "Upper Hydroponics"
	icon_state = "hydro"

/area/service/hydroponics/garden
	name = "Garden"
	icon_state = "garden"

/area/service/hydroponics/garden/abandoned
	name = "Abandoned Garden"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/service/hydroponics/garden/monastery
	name = "Monastery Garden"
	icon_state = "hydro"

//Engineering

/area/engine
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_smes
	name = "Инженерный: СНМЭ"
	icon_state = "engine_smes"

/area/engine/engineering
	name = "Инженерный"
	icon_state = "engine"

/area/engine/atmos
	name = "Инженерный: Атмосферный отдел"
	icon_state = "atmos"
	area_flags = CULT_PERMITTED

/area/engine/atmos/upper
	name = "Инженерный: Верхний атмосферный отдел"

/area/engine/atmospherics_engine
	name = "Инженерный: Атмосферный двигатель"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_room //donut station specific
	name = "Инженерный: Машинное отделение"
	icon_state = "atmos_engine"

/area/engine/lobby
	name = "Инженерный: Лобби"
	icon_state = "engi_lobby"

/area/engine/engine_room/external
	name = "Инженерный: Внешний доступ к суперматерии"
	icon_state = "engine_foyer"

/area/engine/supermatter
	name = "Инженерный: Двигатель суперматерии"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/break_room
	name = "Инженерный: Фойе"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/gravity_generator
	name = "Инженерный: Генератор Гравитации"
	icon_state = "grav_gen"

/area/engine/storage
	name = "Инженерный: Хранилище"
	icon_state = "engi_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/storage_shared
	name = "Инженерный: Общее хранилище"
	icon_state = "engi_storage"

/area/engine/transit_tube
	name = "Инженерный: Транзитная труба"
	icon_state = "transit_tube"


//Solars

/area/solar
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	area_flags = UNIQUE_AREA
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE

/area/solar/fore
	name = "Солнечные панели: Носовые"
	icon_state = "yellow"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/solar/aft
	name = "Солнечные панели: Кормовые"
	icon_state = "yellow"

/area/solar/aux/port
	name = "Солнечные панели: Запасной порт"
	icon_state = "panelsA"

/area/solar/aux/starboard
	name = "Солнечные панели: Запасной правый борт"
	icon_state = "panelsA"

/area/solar/starboard
	name = "Солнечные панели: Правый борт"
	icon_state = "panelsS"

/area/solar/starboard/aft
	name = "Солнечные панели: Кормовой правый борт"
	icon_state = "panelsAS"

/area/solar/starboard/fore
	name = "Солнечные панели: Носовой правый борт"
	icon_state = "panelsFS"

/area/solar/port
	name = "Солнечные панели: Порт"
	icon_state = "panelsP"

/area/solar/port/aft
	name = "Солнечные панели: Кормовой порт"
	icon_state = "panelsAP"

/area/solar/port/fore
	name = "Солнечные панели: Носовой порт"
	icon_state = "panelsFP"

/area/solar/aisat
	name = "ИИ: Солнечные панели"
	icon_state = "yellow"


//Solar Maint

/area/maintenance/solars
	name = "Техтоннели: Солнечные панели"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Техтоннели: Солнечные панели: Порт"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Техтоннели: Солнечные панели: Кормовой порт"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Техтоннели: Солнечные панели: Носовой порт"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Техтоннели: Солнечные панели: Правый борт"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Техтоннели: Солнечные панели: Кормовой правый борт"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Техтоннели: Солнечные панели: Носовой правый борт"
	icon_state = "SolarcontrolFS"

//Teleporter

/area/teleporter
	name = "Комната телепорта"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/command

/area/gateway
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
	name = "Медбей: Кормовой"
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
	mood_message = "<span class='nicegreen'>Здесь спокойно.\n</span>"
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
	name = "Охрана: Надзор"
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

/area/security/nuke_storage
	name = "Охрана: Хранилище"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/ai_monitored/nuke_storage
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

/area/quartermaster
	name = "Завхоз"
	icon_state = "quart"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/quartermaster/sorting
	name = "Снабжение: Сортировка"
	icon_state = "cargo_delivery"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/quartermaster/warehouse
	name = "Снабжение: Склад"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/warehouse/upper
	name = "Снабжение: Верхний склад"

/area/quartermaster/office
	name = "Снабжение: Офис"
	icon_state = "cargo_office"

/area/quartermaster/storage
	name = "Снабжение: Грузовой отсек"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/qm
	name = "Снабжение: Офис завхоза"
	icon_state = "quart_office"

/area/quartermaster/qm/perch
	name = "Снабжение: Карниз завхоза"
	icon_state = "quart_perch"

/area/quartermaster/miningdock
	name = "Снабжение: Шахтёрский док"
	icon_state = "mining"

/area/quartermaster/miningoffice
	name = "Снабжение: Шахтёрский офис"
	icon_state = "mining"

/area/quartermaster/meeting_room
	name = "Снабжение: Комната встреч"
	icon_state = "mining"

/area/quartermaster/exploration_prep
	name = "Снабжение: Подготовка рейнджеров"
	icon_state = "mining"

/area/quartermaster/exploration_dock
	name = "Снабжение: Док рейнджеров"
	icon_state = "mining"

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
/area/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/storage/tools
	name = "Хранилище: Запасные инструменты"
	icon_state = "tool_storage"

/area/storage/primary
	name = "Хранилище: Инструменты"
	icon_state = "primary_storage"

/area/storage/art
	name = "Хранилище: Искусство"
	icon_state = "art_storage"

/area/storage/tcom
	name = "Хранилище: Телекоммуникации"
	icon_state = "tcom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/storage/eva
	name = "Хранилище: ЕВА"
	icon_state = "eva"

/area/storage/emergency/starboard
	name = "Хранилище: Правый борт"
	icon_state = "emergency_storage"

/area/storage/emergency/port
	name = "Хранилище: Порт"
	icon_state = "emergency_storage"

/area/storage/tech
	name = "Хранилище: Техника"
	icon_state = "aux_storage"

/area/storage/mining
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
/area/vacant_room
	name = "Свободная комната"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE

/area/vacant_room/office
	name = "Свободный офис"
	icon_state = "vacant_office"

/area/vacant_room/commissary
	name = "Свободный магазин"
	icon_state = "vacant_commissary"

/area/vacant_room/commissary/second
	name = "Нижний магазин"

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
	name = "Обшивка: Кормовая"

/area/maintenance/external/port
	name = "Обшивка: Порт"

/area/maintenance/external/port/bow
	name = "Обшивка: Порт правого борта"
