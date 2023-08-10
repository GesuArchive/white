
// CENTCOM

// Side note, be sure to change the network_root_id of any areas that are not a part of centcom
// and just using the z space as safe harbor.  It shouldn't matter much as centcom z is isolated
// from everything anyway

/area/centcom
	name = "ЦК"
	icon_state = "centcom"
	static_lighting = TRUE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE

/area/centcom/control
	name = "ЦК"

/area/centcom/circus
	name = "Блядский цирк"
	luminosity = 1
	base_lighting_alpha = 255
	static_lighting = TRUE
	has_gravity = TRUE

/area/centcom/outdoors/circus
	name = "Блядский цирк"

/area/centcom/evac
	name = "ЦК: Эвакуационный док"

/area/centcom/supply
	name = "ЦК: Док торгового шаттла"

/area/centcom/ferry
	name = "ЦК: Док десантного шаттла"

/area/centcom/prison
	name = "ЦК: Тюрьма"

/area/centcom/holding
	name = "ЦК: Удержание"

/area/centcom/debug
	name = "ЦК: Дебаг"

/area/centcom/scp
	name = "SCP"

/area/centcom/scp/labyrinth
	name = "SCP: Лабиринт"
	map_generator = /datum/map_generator/labyrinth

/area/centcom/brief
	name = "ЦК: Брифинг"

/area/centcom/that_zone
	name = "ЦК: Эта зона"

/area/centcom/outdoors
	name = "ЦК: Поверхность"
	static_lighting = TRUE
	has_gravity = TRUE

/area/centcom/office
	name = "ЦК: Офис"

/area/centcom/office/living
	name = "ЦК: Жилое помещение"

/area/centcom/officetwo
	name = "ЦК: Офицерский кабинет"

/area/centcom/supplypod/supplypod_temp_holding
	name = "Дропподы ЦК: Канал полёта"
	icon_state = "supplypod_flight"

/area/centcom/supplypod
	name = "Дропподы ЦК"
	icon_state = "supplypod"
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255

/area/centcom/supplypod/pod_storage
	name = "Дропподы ЦК: Хранилище"
	icon_state = "supplypod_holding"

/area/centcom/supplypod/loading
	name = "Дропподы ЦК: Загрузка"
	icon_state = "supplypod_loading"
	var/loading_id = "fuck"

/area/centcom/supplypod/loading/Initialize(mapload)
	. = ..()
	if(!loading_id)
		CRASH("[type] created without a loading_id")
	if(GLOB.supplypod_loading_bays[loading_id])
		CRASH("Duplicate loading bay area: [type] ([loading_id])")
	GLOB.supplypod_loading_bays[loading_id] = src

/area/centcom/supplypod/loading/one
	name = "Дропподы ЦК: Док #1"
	loading_id = "1"

/area/centcom/supplypod/loading/two
	name = "Дропподы ЦК: Док #2"
	loading_id = "2"

/area/centcom/supplypod/loading/three
	name = "Дропподы ЦК: Док #3"
	loading_id = "3"

/area/centcom/supplypod/loading/four
	name = "Дропподы ЦК: Док #4"
	loading_id = "4"

/area/centcom/supplypod/loading/ert
	name = "Дропподы ЦК: Десант"
	loading_id = "5"
//THUNDERDOME

/area/tdome
	name = "Thunderdome"
	icon_state = "yellow"
	static_lighting = TRUE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/tdome/arena
	name = "Thunderdome Arena"
	icon_state = "thunder"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE

/area/tdome/arena_source
	name = "Thunderdome Arena Template"
	icon_state = "thunder"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "green"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"


//ENEMY

//Wizard
/area/wizard_station
	name = "Логово волшебника"
	icon_state = "yellow"
	static_lighting = TRUE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE
	network_root_id = "MAGIC_NET"

//Abductors
/area/abductor_ship
	name = "Корабль похитителей"
	icon_state = "yellow"
	requires_power = FALSE
	area_flags = UNIQUE_AREA | NOTELEPORT

	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	network_root_id = "ALIENS"

//Syndicates
/area/syndicate_mothership
	name = "Синдикат"
	icon_state = "syndie-ship"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	network_root_id = SYNDICATE_NETWORK_ROOT

/area/syndicate_mothership/control
	name = "Синдикат: Комната управления"
	icon_state = "syndie-control"
	static_lighting = TRUE
	network_root_id = SYNDICATE_NETWORK_ROOT

/area/syndicate_mothership/expansion_bombthreat
	name = "Синдикат: Исследование токсинов"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	network_root_id = SYNDICATE_NETWORK_ROOT
	area_flags = NOTELEPORT
	ambience_index = AMBIENCE_ENGI

/area/syndicate_mothership/expansion_bioterrorism
	name = "Синдикат: Биологическое оружие"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	network_root_id = SYNDICATE_NETWORK_ROOT
	area_flags = NOTELEPORT
	ambience_index = AMBIENCE_MEDICAL

/area/syndicate_mothership/expansion_chemicalwarfare
	name = "Синдикат: Химическое оружие"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	network_root_id = SYNDICATE_NETWORK_ROOT
	area_flags = NOTELEPORT
	ambience_index = AMBIENCE_REEBE

/area/syndicate_mothership/expansion_fridgerummage
	name = "Синдикат: Кухня"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	network_root_id = SYNDICATE_NETWORK_ROOT
	area_flags = NOTELEPORT

/area/syndicate_mothership/elite_squad
	name = "Синдикат: Элитный отряд"
	icon_state = "syndie-elite"
	network_root_id = SYNDICATE_NETWORK_ROOT

//CAPTURE THE FLAG

/area/ctf
	name = "Захват флага"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = UNIQUE_AREA | NOTELEPORT

/area/ctf/control_room
	name = "Захват флага: Комната управления A"

/area/ctf/control_room2
	name = "Захват флага: Комната управления B"

/area/ctf/central
	name = "Захват флага: Центр"

/area/ctf/main_hall
	name = "Захват флага: Основной коридор A"

/area/ctf/main_hall2
	name = "Захват флага: Основной коридор B"

/area/ctf/corridor
	name = "Захват флага: Коридор A"

/area/ctf/corridor2
	name = "Захват флага: Коридор B"

/area/ctf/flag_room
	name = "Захват флага: Флаг A"

/area/ctf/flag_room2
	name = "Захват флага: Флаг B"

// REEBE

/area/reebe
	name = "Reebe"
	icon_state = "yellow"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = HIDDEN_AREA | NOTELEPORT
	ambientsounds = REEBE
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255

/area/reebe/city_of_cogs
	name = "Reebe - City of Cogs"
	icon_state = "purple"
	area_flags = NOTELEPORT
	var/playing_ambience = FALSE
	ambientsounds = REEBE

/area/reebe/Initialize(mapload)
	. = ..()
	spawn(5 SECONDS)
		update_base_lighting()

/area/tournament
	name = "Турнирная арена"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
