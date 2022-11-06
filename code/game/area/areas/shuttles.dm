
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Шаттл"
	requires_power = FALSE
	static_lighting = TRUE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NO_ALERTS
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM
	//The mobile port attached to this area
	var/obj/docking_port/mobile/mobile_port

/area/shuttle/Destroy()
	mobile_port = null
	. = ..()

//Returns how many shuttles are missing a skipovers on a given turf, this usually represents how many shuttles have hull breaches on this turf. This only works if this is the actual area of T when called.
//TODO: optimize this somehow
/area/shuttle/proc/get_missing_shuttles(turf/T)
	var/i = 0
	var/BT_index = length(T.baseturfs)
	var/area/shuttle/A
	var/obj/docking_port/mobile/S
	var/list/shuttle_stack = list(mobile_port) //Indexing through a list helps prevent looped directed graph errors.
	while(i++ < shuttle_stack.len)
		S = shuttle_stack[i]
		A = S.underlying_turf_area[T]
		if(istype(A) && A.mobile_port)
			shuttle_stack |= A.mobile_port
		.++
	for(BT_index in 1 to length(T.baseturfs))
		if(ispath(T.baseturfs[BT_index], /turf/baseturf_skipover/shuttle))
			.--

/area/shuttle/PlaceOnTopReact(turf/T, list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(!length(new_baseturfs) || !ispath(new_baseturfs[1], /turf/baseturf_skipover/shuttle) && (!ispath(new_baseturfs[1], /turf/open/floor/plating) || length(new_baseturfs) > 1 || fake_turf_type))
		return //Only add missing baseturfs if a shuttle is landing or player made plating is being added (player made is infered to be a new_baseturf list of 1 and no fake_turf_type)
	for(var/i in 1 to get_missing_shuttles(T))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

/area/shuttle/proc/link_to_shuttle(obj/docking_port/mobile/M)
	mobile_port = M

////////////////////////////Multi-area shuttles////////////////////////////

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/syndicate
	name = "Лазутчик Синдиката"
	ambience_index = AMBIENCE_DANGER
	ambientsounds = HIGHSEC
	area_limited_icon_smoothing = /area/shuttle/syndicate

/area/shuttle/syndicate/bridge
	name = "Лазутчик Синдиката: Мостик"

/area/shuttle/syndicate/medical
	name = "Лазутчик Синдиката: Медбей"

/area/shuttle/syndicate/armory
	name = "Лазутчик Синдиката: Арсенал"

/area/shuttle/syndicate/eva
	name = "Лазутчик Синдиката: ЕВА"

/area/shuttle/syndicate/hallway

/area/shuttle/syndicate/airlock
	name = "Лазутчик Синдиката: Шлюз"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "Пиратский шаттл"
	requires_power = TRUE

/area/shuttle/pirate/flying_dutchman
	name = "Flying Dutchman"
	requires_power = FALSE

////////////////////////////Bounty Hunter Shuttles////////////////////////////

/area/shuttle/hunter
	name = "Охотник"
	static_lighting = FALSE

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "Забытый корабль"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "Забытый корабль: Мостик"

/area/shuttle/abandoned/engine
	name = "Забытый корабль: Двигатель"

/area/shuttle/abandoned/bar
	name = "Забытый корабль: Бар"

/area/shuttle/abandoned/crew
	name = "Забытый корабль: Каюты"

/area/shuttle/abandoned/cargo
	name = "Забытый корабль: Карго"

/area/shuttle/abandoned/medbay
	name = "Забытый корабль: Медбей"

/area/shuttle/abandoned/pod
	name = "Забытый корабль: Под"

////////////////////////////Single-area shuttles////////////////////////////

/area/shuttle/transit
	name = "Гиперпространство"
	desc = "Уииииииииииии"
	static_lighting = FALSE
	area_flags = NO_ALERTS | HIDDEN_AREA
	base_lighting_alpha = 255
	base_lighting_color = "#ffffff"

/area/shuttle/arrival
	name = "Шаттл прибытия"
	area_flags = UNIQUE_AREA// SSjob refers to this area for latejoiners

/area/shuttle/pod_1
	name = "Под: Первый"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_2
	name = "Под: Второй"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_3
	name = "Под: Третий"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_4
	name = "Под: Четвёртый"
	area_flags = BLOBS_ALLOWED

/area/shuttle/mining
	name = "Шахтёрский шаттл"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS
	requires_power = TRUE

/area/shuttle/mining/large
	name = "Шахтёрский шаттл"

/area/shuttle/labor
	name = "Шаттл каторги"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS

/area/shuttle/supply
	name = "Шаттл снабжения"
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "Эвакуационный шаттл"
	area_flags = BLOBS_ALLOWED
	area_limited_icon_smoothing = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1
	area_flags = NO_ALERTS | CULT_PERMITTED

/area/shuttle/escape/backup
	name = "Запасной эвакуационный шаттл"

/area/shuttle/escape/brig
	name = "Бриг эвакуационного шаттла"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "Роскошный эвакуационный шаттл"
	area_flags = NOTELEPORT

/area/shuttle/escape/simulation
	name = "Симулятор средневековья"
	icon_state = "shuttlectf"
	area_flags = NOTELEPORT
	static_lighting = FALSE

/area/shuttle/escape/arena
	name = "Арена"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "метеор с движками"
	luminosity = NONE

/area/shuttle/transport
	name = "Транспортный шаттл"

/area/shuttle/assault_pod
	name = "Стальной дождь"

/area/shuttle/sbc_starfury
	name = "SBC Звездная ярость"

/area/shuttle/sbc_fighter1
	name = "SBC Боец 1"

/area/shuttle/sbc_fighter2
	name = "SBC Боец 2"

/area/shuttle/sbc_corvette
	name = "SBC корвет"

/area/shuttle/syndicate_scout
	name = "Разведчик Синдиката"

/area/shuttle/caravan
	requires_power = TRUE

/area/shuttle/caravan/syndicate1
	name = "Боец Синдиката 1"

/area/shuttle/caravan/syndicate2
	name = "Боец Синдиката 2"

/area/shuttle/caravan/syndicate3
	name = "Десантный корабль синдиката"

/area/shuttle/caravan/pirate
	name = "Пиратский резак"

/area/shuttle/caravan/freighter1
	name = "Малый грузовой корабль"

/area/shuttle/caravan/freighter2
	name = "Крошечный грузовой корабль"

/area/shuttle/caravan/freighter3
	name = "Крошечный грузовой корабль"

/area/shuttle/transport/tramstation
	name = "Трамвай"

/area/shuttle/exploration
	name = "Шаттл Рейнджеров"
	requires_power = TRUE
	ambientsounds = RANGERS_AMB

/area/shuttle/exploration/play_ambience(client/C)

	if(!C?.mob)
		return

	C.played = FALSE
	C.mob.stop_sound_channel(CHANNEL_AMBIENCE)

	. = ..()

/area/shuttle/custom
	name = "DIY-шаттл"

/area/shuttle/custom/powered
	name = "DIY-энергошаттл"
	requires_power = FALSE
