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
	name = "лобби"
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
	name = "Технические тоннели"
	ambience_index = AMBIENCE_MAINT
	ambientsounds = MAINTENANCE
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

//Departments

/area/maintenance/department/chapel
	name = "Техтоннели церкви"
	icon_state = "maint_chapel"

/area/maintenance/department/chapel/monastery
	name = "Техтоннели монастыря"
	icon_state = "maint_monastery"

/area/maintenance/department/crew_quarters/bar
	name = "Техтоннели бара"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/maintenance/department/crew_quarters/dorms
	name = "Техтоннели дормиториев"
	icon_state = "maint_dorms"

/area/maintenance/department/eva
	name = "Техтоннели ЕВА"
	icon_state = "maint_eva"

/area/maintenance/department/electrical
	name = "Техтоннели обслуживания"
	icon_state = "maint_electrical"

/area/maintenance/department/engine/atmos
	name = "Атмосферные техтоннели"
	icon_state = "maint_atmos"

/area/maintenance/department/security
	name = "Техтоннели безопасности"
	icon_state = "maint_sec"

/area/maintenance/department/security/upper
	name = "Верхние техтоннели безопасности"

/area/maintenance/department/security/brig
	name = "Техтоннели брига"
	icon_state = "maint_brig"

/area/maintenance/department/medical
	name = "Техтоннели медбея"
	icon_state = "medbay_maint"

/area/maintenance/department/medical/central
	name = "Техтоннели центральной части медбея"
	icon_state = "medbay_maint_central"

/area/maintenance/department/medical/morgue
	name = "Техтоннели морга"
	icon_state = "morgue_maint"

/area/maintenance/department/science
	name = "Техтоннели научного отдела"
	icon_state = "maint_sci"

/area/maintenance/department/science/central
	name = "Техтоннели центра научного отдела"
	icon_state = "maint_sci_central"

/area/maintenance/department/cargo
	name = "Техтоннели снабжения"
	icon_state = "maint_cargo"

/area/maintenance/department/bridge
	name = "Техтоннели мостика"
	icon_state = "maint_bridge"

/area/maintenance/department/engine
	name = "Техтоннели инженерного отдела"
	icon_state = "maint_engi"

/area/maintenance/department/science/xenobiology
	name = "Техтоннели ксенобиологии"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE


//Maintenance - Generic

/area/maintenance/aft
	name = "Кормовые техтоннели"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Верхние кормовые техтоннели"

/area/maintenance/aft/secondary
	name = "Кормовые техтоннели"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Центральные техтоннели"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Центральные техтоннели"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Носовые техтоннели"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Верхние носовые техтоннели"

/area/maintenance/fore/secondary
	name = "Носовые техтоннели"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Техтоннели правого борта"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Верхние техтоннели правого борта"

/area/maintenance/starboard/central
	name = "Центральные техтоннели правого борта"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Дополнительные техтоннели правого борта"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Кормовые техтоннели правого борта"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Кормовые дополнительные техтоннели правого борта"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Носовые техтоннели правого борта"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Техтоннели порта"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Центральные техтоннели порта"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Кормовые техтоннели порта"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Носовые техтоннели порта"
	icon_state = "fpmaint"

/area/maintenance/disposal
	name = "Утилизация отходов"
	icon_state = "disposal"

/area/maintenance/disposal/incinerator
	name = "Сжигатель"
	icon_state = "incinerator"

/area/maintenance/space_hut
	name = "Космическая хижина"
	icon_state = "spacehut"

/area/maintenance/space_hut/cabin
	name = "Заброшенная хижина"

/area/maintenance/space_hut/plasmaman
	name = "Заброшенный домик дружелюбного плазмамена"

/area/maintenance/space_hut/observatory
	name = "Космическая обсерватория"

//Hallway
/area/hallway
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/hallway/primary
	name = "Основной коридор"

/area/hallway/primary/aft
	name = "Кормовой основной коридор"
	icon_state = "hallA"

/area/hallway/primary/fore
	name = "Носовой основной коридор"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Основной коридор правого борта"
	icon_state = "hallS"

/area/hallway/primary/port
	name = "Основной коридор порта"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Центральный основной коридор"
	icon_state = "hallC"

/area/hallway/primary/upper
	name = "Верхний центральный основной коридор"
	icon_state = "hallC"


/area/hallway/secondary/command
	name = "Командный коридор"
	icon_state = "bridge_hallway"

/area/hallway/secondary/construction
	name = "Строительная площадка"
	icon_state = "construction"

/area/hallway/secondary/exit
	name = "Эвакуационный коридор"
	icon_state = "escape"

/area/hallway/secondary/exit/departure_lounge
	name = "Зал ожидания"
	icon_state = "escape_lounge"

/area/hallway/secondary/entry
	name = "Коридор шаттла прибытия"
	icon_state = "entry"

/area/hallway/secondary/service
	name = "Коридор обслуги"
	icon_state = "hall_service"

//Command

/area/bridge
	name = "Мостик"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/bridge/meeting_room
	name = "Комната встреч"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/meeting_room/council
	name = "Зал совета"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/showroom/corporate
	name = "Корпоративный выставочный зал"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/crew_quarters/heads
	airlock_wires = /datum/wires/airlock/command

/area/crew_quarters/heads/captain
	name = "Офис капитана"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/captain/private
	name = "Каюта капитана"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/chief
	name = "Офис старшего инженера"
	icon_state = "ce_office"

/area/crew_quarters/heads/cmo
	name = "Офис главного врача"
	icon_state = "cmo_office"

/area/crew_quarters/heads/hop
	name = "Офис кадровика"
	icon_state = "hop_office"

/area/crew_quarters/heads/hos
	name = "Офис начальника охраны"
	icon_state = "hos_office"

/area/crew_quarters/heads/hor
	name = "Офис научного руководителя"
	icon_state = "rd_office"

/area/comms
	name = "Реле связи"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/server
	name = "Серверная комната обмена сообщениями"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION

//Crew

/area/crew_quarters
	name = "Жилые помещения экипажа"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/crew_quarters/dorms
	name = "Дормитории"
	icon_state = "dorms"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA

/area/crew_quarters/dorms/barracks
	name = "Бараки"

/area/crew_quarters/dorms/barracks/male
	name = "Мужские бараки"
	icon_state = "dorms_male"

/area/crew_quarters/dorms/barracks/female
	name = "Женские бараки"
	icon_state = "dorms_female"

/area/crew_quarters/toilet
	name = "Туалеты дормитория"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/toilet/auxiliary
	name = "Вспомогательные туалеты"
	icon_state = "toilet"

/area/crew_quarters/toilet/locker
	name = "Туалеты раздевалки"
	icon_state = "toilet"

/area/crew_quarters/toilet/restrooms
	name = "Туалеты"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Раздевалка"
	icon_state = "locker"

/area/crew_quarters/lounge
	name = "Гостиная"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/crew_quarters/fitness
	name = "Фитнес-зал"
	icon_state = "fitness"

/area/crew_quarters/fitness/locker_room
	name = "Раздевалка унисекс"
	icon_state = "locker"

/area/crew_quarters/fitness/locker_room/male
	name = "Мужская раздевалка"
	icon_state = "locker_male"

/area/crew_quarters/fitness/locker_room/female
	name = "Женская раздевалка"
	icon_state = "locker_female"


/area/crew_quarters/fitness/recreation
	name = "Зона отдыха"
	icon_state = "rec"

/area/crew_quarters/cafeteria
	name = "Кафетерий"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Кухня"
	icon_state = "kitchen"
	airlock_wires = /datum/wires/airlock/service

/area/crew_quarters/kitchen/coldroom
	name = "Морозильная камера кухни"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/bar
	name = "Бар"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>Обожаю отдохнуть в баре!\n</span>"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/bar/atrium
	name = "Атриум"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/electronic_marketing_den
	name = "Кабинет электронного маркетинга"
	icon_state = "abandoned_m_den"

/area/crew_quarters/abandoned_gambling_den
	name = "Заброшенный игорный дом"
	icon_state = "abandoned_g_den"

/area/crew_quarters/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/crew_quarters/theatre
	name = "Театр"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/theatre/abandoned
	name = "Заброшенный театр"
	icon_state = "abandoned_theatre"

/area/library
	name = "Библиотека"
	icon_state = "library"
	flags_1 = CULT_PERMITTED_1
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/library/lounge
	name = "Гостинная библиотеки"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/library/artgallery
	name = "Галерея искусств"
	icon_state = "library_gallery"

/area/library/private
	name = "Личный кабинет библиотеки"
	icon_state = "library_gallery_private"

/area/library/upper
	name = "Верхняя библиотека"
	icon_state = "library"

/area/library/printer
	name = "Комната принтеров библиотеки"
	icon_state = "library"

/area/library/abandoned
	name = "Заброшенная библиотека"
	icon_state = "abandoned_library"
	flags_1 = CULT_PERMITTED_1

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
	name = "Док церковь"
	icon_state = "construction"

/area/lawoffice
	name = "Адвокатская контора"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR


//Engineering

/area/engine
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_smes
	name = "Инженерные СНМЭ"
	icon_state = "engine_smes"

/area/engine/engineering
	name = "Инженерия"
	icon_state = "engine"

/area/engine/atmos
	name = "Атмосферный отсек"
	icon_state = "atmos"
	flags_1 = CULT_PERMITTED_1

/area/engine/atmos/upper
	name = "Верхний атмосферный отсек"

/area/engine/atmospherics_engine
	name = "Двигатель атмосферного отсека"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_room //donut station specific
	name = "Машинное отделение"
	icon_state = "atmos_engine"

/area/engine/lobby
	name = "Инженерное лобби"
	icon_state = "engi_lobby"

/area/engine/engine_room/external
	name = "Внешний доступ к суперматерии"
	icon_state = "engine_foyer"

/area/engine/supermatter
	name = "Двигатель суперматерии"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/break_room
	name = "Инженерное фойе"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/gravity_generator
	name = "Комната генератора гравитации"
	icon_state = "grav_gen"

/area/engine/storage
	name = "Инженерное хранилище"
	icon_state = "engi_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/storage_shared
	name = "Общее инженерное хранилище"
	icon_state = "engi_storage"

/area/engine/transit_tube
	name = "Транзитная труба"
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
	name = "Носовой солнечный массив"
	icon_state = "yellow"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/solar/aft
	name = "Кормовой солнечный массив"
	icon_state = "yellow"

/area/solar/aux/port
	name = "Портовый солнечный массив"
	icon_state = "panelsA"

/area/solar/aux/starboard
	name = "Запасной солнечный массив правого борта"
	icon_state = "panelsA"

/area/solar/starboard
	name = "Солнечный массив правого борта"
	icon_state = "panelsS"

/area/solar/starboard/aft
	name = "Кормовой солнечный массив правого борта"
	icon_state = "panelsAS"

/area/solar/starboard/fore
	name = "Носовой солнечный массив правого борта"
	icon_state = "panelsFS"

/area/solar/port
	name = "Портовый солнечный массив"
	icon_state = "panelsP"

/area/solar/port/aft
	name = "Кормовой портовый солнечный массив"
	icon_state = "panelsAP"

/area/solar/port/fore
	name = "Носовой портовый солнечный массив"
	icon_state = "panelsFP"

/area/solar/aisat
	name = "Солнечный массив ИИ"
	icon_state = "yellow"


//Solar Maint

/area/maintenance/solars
	name = "Техтоннели солнечного массива"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Портовые техтоннели солнечного массива"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Кормовые портовые техтоннели солнечного массива"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Носовые портовые техтоннели солнечного массива"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Техтоннели солнечного массива правого борта"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Кормовые техтоннели солнечного массива правого борта"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Носовые техтоннели солнечного массива правого борта"
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
	name = "Заброшенный медбей"
	icon_state = "abandoned_medbay"
	ambientsounds = list('sound/ambience/signal.ogg')
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/medbay/central
	name = "Центр медбея"
	icon_state = "med_central"

/area/medical/medbay/lobby
	name = "Лобби медбея"
	icon_state = "med_lobby"

	//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Медбей"
	icon_state = "medbay2"

/area/medical/medbay/aft
	name = "Medbay Aft"
	icon_state = "med_aft"

/area/medical/storage
	name = "Хранилище медбея"
	icon_state = "med_storage"

/area/medical/paramedic
	name = "Фельдшер"
	icon_state = "paramedic"

/area/medical/office
	name = "Офис медбея"
	icon_state = "med_office"

/area/medical/surgery/room_c
	name = "Хирургия C"
	icon_state = "surgery"

/area/medical/surgery/room_d
	name = "Хирургия D"
	icon_state = "surgery"

/area/medical/break_room
	name = "Комната отдыха медбея"
	icon_state = "med_break"

/area/medical/coldroom
	name = "Морозилка медбея"
	icon_state = "kitchen_cold"

/area/medical/patients_rooms
	name = "Палаты"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/medical/patients_rooms/room_a
	name = "Палата пациента A"
	icon_state = "patients"

/area/medical/patients_rooms/room_b
	name = "Палата пациента B"
	icon_state = "patients"

/area/medical/virology
	name = "Вирусология"
	icon_state = "virology"
	flags_1 = CULT_PERMITTED_1

/area/medical/morgue
	name = "Морг"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	ambientsounds = SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/chemistry
	name = "Химия"
	icon_state = "chem"

/area/medical/pharmacy
	name = "Аптека"
	icon_state = "pharmacy"

/area/medical/surgery
	name = "Хирургия"
	icon_state = "surgery"

/area/medical/surgery/room_b
	name = "Хирургия B"
	icon_state = "surgery"

/area/medical/cryo
	name = "Криогеника"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Экзаменационная комната"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Лаборатория генетики"
	icon_state = "genetics"

/area/medical/sleeper
	name = "Лечебный центр медбея"
	icon_state = "exam_room"

/area/medical/psychology
	name = "Офис психолога"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "<span class='nicegreen'>Здесь спокойно.\n</span>"
	ambientsounds = list('sound/ambience/aurora_caelus_short.ogg')

//Security

/area/security
	name = "Безопасность"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/security/main
	name = "Офис охраны"
	icon_state = "security"

/area/security/brig
	name = "Бриг"
	icon_state = "brig"

/area/security/brig/upper
	name = "Верхний бриг"

/area/security/courtroom
	name = "Зал суда"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/security/prison
	name = "Тюремное крыло"
	icon_state = "sec_prison"

/area/security/prison/toilet //radproof
	name = "Тюремный туалет"
	icon_state = "sec_prison_safe"

/area/security/prison/safe //radproof
	name = "Камеры тюремного крыла"
	icon_state = "sec_prison_safe"

/area/security/prison/upper
	name = "Верхнее тюремное крыло"
	icon_state = "prison_upper"

/area/security/prison/visit
	name = "Зона посещения тюрьмы"
	icon_state = "prison_visit"

/area/security/prison/rec
	name = "Тюремная комната отдыха"
	icon_state = "prison_rec"

/area/security/prison/mess
	name = "Тюремная столовая"
	icon_state = "prison_mess"

/area/security/prison/work
	name = "Тюремный цех"
	icon_state = "prison_work"

/area/security/prison/shower
	name = "Тюремный душ"
	icon_state = "prison_shower"

/area/security/prison/workout
	name = "Тюремный спортзал"
	icon_state = "prison_workout"

/area/security/prison/garden
	name = "Тюремный сад"
	icon_state = "prison_garden"

/area/security/processing
	name = "Док шаттла трудового лагеря"
	icon_state = "sec_processing"

/area/security/processing/cremation
	name = "Крематорий охраны"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/security/warden
	name = "Надзор брига"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/detectives_office
	name = "Офис детектива"
	icon_state = "detective"
	ambientsounds = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg')

/area/security/detectives_office/private_investigators_office
	name = "Кабинет частного детектива"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/range
	name = "Стрельбище"
	icon_state = "firingrange"

/area/security/execution
	icon_state = "execution_room"

/area/security/execution/transfer
	name = "Трансферный центр"
	icon_state = "sec_processing"

/area/security/execution/education
	name = "Палата тюремного образования"

/area/security/nuke_storage
	name = "Хранилище"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/ai_monitored/nuke_storage
	name = "Хранилище"
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
	name = "Пост охраны - Снабжение"
	icon_state = "checkpoint_supp"

/area/security/checkpoint/engineering
	name = "Пост охраны - Инженерный"
	icon_state = "checkpoint_engi"

/area/security/checkpoint/medical
	name = "Пост охраны - Медбей"
	icon_state = "checkpoint_med"

/area/security/checkpoint/science
	name = "Пост охраны - Научный"
	icon_state = "checkpoint_sci"

/area/security/checkpoint/science/research
	name = "Пост охраны - Научный отдел"
	icon_state = "checkpoint_res"

/area/security/checkpoint/customs
	name = "Таможня"
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
	name = "Офис доставки"
	icon_state = "cargo_delivery"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/quartermaster/warehouse
	name = "Склад"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/warehouse/upper
	name = "Верхний склад"

/area/quartermaster/office
	name = "Офис снабжения"
	icon_state = "cargo_office"

/area/quartermaster/storage
	name = "Грузовой отсек"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/qm
	name = "Офис завхоза"
	icon_state = "quart_office"

/area/quartermaster/qm/perch
	name = "Карниз завхоза"
	icon_state = "quart_perch"

/area/quartermaster/miningdock
	name = "Шахтёрский док"
	icon_state = "mining"

/area/quartermaster/miningoffice
	name = "Шахтёрский офис"
	icon_state = "mining"

/area/janitor
	name = "Уборная"
	icon_state = "janitor"
	flags_1 = CULT_PERMITTED_1
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/hydroponics
	name = "Гидропоника"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/hydroponics/upper
	name = "Верхняя гидропоника"
	icon_state = "hydro"

/area/hydroponics/garden
	name = "Сад"
	icon_state = "garden"

/area/hydroponics/garden/abandoned
	name = "Заброшенный сад"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/hydroponics/garden/monastery
	name = "Монастырский сад"
	icon_state = "hydro"


//Science

/area/science
	name = "Отдел науки"
	icon_state = "science"
	airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/science/lab
	name = "Исследования и разработки"
	icon_state = "research"

/area/science/xenobiology
	name = "Ксенобиологическая лаборатория"
	icon_state = "xenobio"

/area/science/storage
	name = "Хранилище токсинов"
	icon_state = "tox_storage"

/area/science/test_area
	name = "Полигон токсинов"
	icon_state = "tox_test"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/mixing
	name = "Смешиватель токсинов"
	icon_state = "tox_mix"

/area/science/mixing/chamber
	name = "Камера смешивания токсинов"
	icon_state = "tox_mix_chamber"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/genetics
	name = "Лаборатория генетики"
	icon_state = "geneticssci"

/area/science/misc_lab
	name = "Лаборатория тестирования"
	icon_state = "tox_misc"

/area/science/misc_lab/range
	name = "Исследовательский тир"
	icon_state = "tox_range"

/area/science/server
	name = "Серверная комната исследовательского отдела"
	icon_state = "server"

/area/science/explab
	name = "Экспериментальная лаборатория"
	icon_state = "exp_lab"

/area/science/robotics
	name = "Роботика"
	icon_state = "robotics"

/area/science/robotics/mechbay
	name = "Мехдок"
	icon_state = "mechbay"

/area/science/robotics/lab
	name = "Лаборатория робототехники"
	icon_state = "ass_line"

/area/science/research
	name = "Отдел исследований"
	icon_state = "science"

/area/science/research/abandoned
	name = "Заброшенная исследовательская лаборатория"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/science/nanite
	name = "Нанитовая лаборатория"
	icon_state = "nanite"

//Storage
/area/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/storage/tools
	name = "Вспомогательное хранилище инструментов"
	icon_state = "tool_storage"

/area/storage/primary
	name = "Первичное хранилище инструментов"
	icon_state = "primary_storage"

/area/storage/art
	name = "Хранилище предметов искусства"
	icon_state = "art_storage"

/area/storage/tcom
	name = "Хранилище телекоммуникаций"
	icon_state = "tcom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/storage/eva
	name = "Хранилище ЕВА"
	icon_state = "eva"

/area/storage/emergency/starboard
	name = "Аварийное хранилище правого борта"
	icon_state = "emergency_storage"

/area/storage/emergency/port
	name = "Аварийное хранилище порта"
	icon_state = "emergency_storage"

/area/storage/tech
	name = "Техническое хранилище"
	icon_state = "aux_storage"

/area/storage/mining
	name = "Публичное шахтёрское хранилище"
	icon_state = "mining"

//Construction

/area/construction
	name = "Строительная площадка"
	icon_state = "construction"
	ambience_index = AMBIENCE_ENGI
	ambientsounds = ENGINEERING
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/construction/mining/aux_base
	name = "Строительная площадка вспомогательной базы"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/construction/storage_wing
	name = "Крыло хранилища"
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

//AI

/area/ai_monitored
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/ai_monitored/security/armory
	name = "Арсенал"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/security

/area/ai_monitored/security/armory/upper
	name = "Верхний арсенал"

/area/ai_monitored/storage/eva
	name = "Хранилище ЕВА"
	icon_state = "eva"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC

/area/ai_monitored/storage/eva/upper
	name = "Верхнее хранилище ЕВА"

/area/ai_monitored/storage/satellite
	name = "Техтоннели спутника ИИ"
	icon_state = "ai_storage"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	airlock_wires = /datum/wires/airlock/ai

	//Turret_protected

/area/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/ai_upload
	name = "Комната загрузки ИИ"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai_upload_foyer
	name = "Фойе загрузки ИИ"
	icon_state = "ai_upload_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai
	name = "Комната ИИ"
	icon_state = "ai_chamber"

/area/ai_monitored/turret_protected/aisat
	name = "Спутник ИИ"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ai_monitored/turret_protected/aisat/atmos
	name = "Атмосферный отдел ИИ"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/foyer
	name = "Фойе спутника ИИ"
	icon_state = "ai_foyer"

/area/ai_monitored/turret_protected/aisat/service
	name = "Сервисный отдел спутника ИИ"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/hallway
	name = "Коридор спутника ИИ"
	icon_state = "ai"

/area/aisat
	name = "Внешняя часть спутника ИИ"
	icon_state = "ai"
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/aisat_interior
	name = "Прихожая спутника ИИ"
	icon_state = "ai_interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ai_monitored/turret_protected/ai_sat_ext_as
	name = "Восточная часть спутника ИИ"
	icon_state = "ai_sat_east"

/area/ai_monitored/turret_protected/ai_sat_ext_ap
	name = "Западная часть спутника ИИ"
	icon_state = "ai_sat_west"


// Telecommunications Satellite

/area/tcommsat
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg', 'sound/ambience/ambitech.ogg',\
											'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg', 'sound/ambience/ambimystery.ogg')
	airlock_wires = /datum/wires/airlock/engineering
	network_root_id = STATION_NETWORK_ROOT	// They should of unpluged the router before they left

/area/tcommsat/computer
	name = "Телекоммуникационная диспетчерская"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/tcommsat/server
	name = "Серверная комната телекоммуникаций"
	icon_state = "tcomsatcham"

/area/tcommsat/server/upper
	name = "Верхняя серверная комната телекоммуникаций"

//External Hull Access
/area/maintenance/external
	name = "Внешняя обшивка"
	icon_state = "amaint"

/area/maintenance/external/aft
	name = "Кормовая внешняя обшивка"

/area/maintenance/external/port
	name = "Портовая внешняя обшивка"

/area/maintenance/external/port/bow
	name = "Портовая внешняя обшивка правого борта"
