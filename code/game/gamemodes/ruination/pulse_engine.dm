/obj/structure/pulse_engine
	name = "импульсный двигатель"
	desc = "Массивная конструкция для выведения с орбит непригодных станций... погоди, а что он делает на нашей станции?"
	icon = 'white/valtos/icons/32x64.dmi'
	icon_state = "peoff"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_FOV_HIDDEN
	density = TRUE
	var/engine_power = 0
	var/minimum_power = 25
	var/engine_active = FALSE
	var/datum/looping_sound/pulse_engine/soundloop

/obj/structure/pulse_engine/examine(mob/user)
	. = ..()
	. += span_danger("<hr>Текущая мощность: [engine_power]%")
	. += span_danger("\nМинимальная мощность: [minimum_power]%")
	. += span_notice("<hr>Похоже, если его неплохо так поколотить, то он станет работать <b>намного [(user?.mind?.has_antag_datum(/datum/antagonist/traitor/ruiner) || user?.mind?.has_antag_datum(/datum/antagonist/ert)) ? "лучше" : "хуже"]</b>.")

/obj/structure/pulse_engine/Initialize(mapload)
	. = ..()
	soundloop = new(src, engine_active)

/obj/structure/pulse_engine/Destroy()
	GLOB.pulse_engines -= src
	QDEL_NULL(soundloop)
	. = ..()

/obj/structure/pulse_engine/attack_hand(mob/user)
	. = ..()
	if((user?.mind?.has_antag_datum(/datum/antagonist/traitor/ruiner) || user?.mind?.has_antag_datum(/datum/antagonist/ert)) && is_station_level(user.z))
		var/turf/T = get_turf(src)
		var/area/A = get_area(T)
		if(istype(A, /area/space) || isinspace())
			add_overlay("peoverlay")
			to_chat(user, span_danger("ДВИГАТЕЛЬ ВКЛЮЧЁН!"))
			playsound(T, 'sound/vehicles/rocketlaunch.ogg', 80, TRUE, 20)
			animate(src, pixel_z = -300, time = 30, easing = LINEAR_EASING)
			QDEL_IN(src, 30)
			return
		if(engine_active)
			to_chat(user, span_danger("Уже включён."))
			return
		GLOB.pulse_engines += src
		engine_active = TRUE
		anchored = TRUE
		flick("peactivate", src)
		spawn(66)
			icon_state = "peon"
			add_overlay("peoverlay")
			soundloop.start()
			START_PROCESSING(SSmachines, src)
			priority_announce("Был обнаружен импульсный двигатель в локации [get_area_name(src, TRUE)].", null, sound('white/valtos/sounds/trevoga2.ogg'), "Priority")
			set_light(8, 2, "#f79947")
		to_chat(user, span_notice("Включаю двигатель."))

/obj/structure/pulse_engine/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.force)
		if(user?.mind?.has_antag_datum(/datum/antagonist/traitor/ruiner))
			engine_power += min(I.force, 25)
			engine_power = min(engine_power, 100)
		else
			engine_power -= min(I.force, 25)
			engine_power = max(engine_power, minimum_power)

/obj/structure/pulse_engine/process(delta_time)
	engine_power = max(engine_power - 0.2, minimum_power)
