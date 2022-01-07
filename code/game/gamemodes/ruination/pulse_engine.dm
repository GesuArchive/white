/obj/structure/pulse_engine
	name = "импульсный двигатель"
	desc = "Массивная конструкция для выведения с орбит непригодных станций... погоди, а что он делает на нашей станции?"
	icon = 'white/valtos/icons/32x64.dmi'
	icon_state = "peoff"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = ABOVE_ALL_MOB_LAYER
	density = TRUE
	var/engine_power = 0
	var/engine_active = FALSE
	var/datum/looping_sound/pulse_engine/soundloop

/obj/structure/pulse_engine/examine(mob/user)
	. = ..()
	. += span_danger("<hr>Текущая мощность: [engine_power]%")
	. += span_notice("<hr>Похоже, если его неплохо так поколотить, то он станет работать <b>намного хуже</b>.")

/obj/structure/pulse_engine/Initialize()
	. = ..()
	soundloop = new(src, engine_active)

/obj/structure/pulse_engine/Destroy()
	GLOB.pulse_engines -= src
	QDEL_NULL(soundloop)
	. = ..()

/obj/structure/pulse_engine/attack_hand(mob/user)
	. = ..()
	if(user?.mind?.has_antag_datum(/datum/antagonist/traitor))
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
		START_PROCESSING(SSfastprocess, src)
		to_chat(user, span_notice("Включаю двигатель."))
		soundloop.start()

/obj/structure/pulse_engine/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.force)
		engine_power -= min(I.force, 15)

/obj/structure/pulse_engine/process(delta_time)
	. = ..()
	engine_power = min(engine_power + 1, 100)
