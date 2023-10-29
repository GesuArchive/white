/obj/structure/sign/clock
	name = "настенные часы"
	desc = "Это наши заурядные настенные часы, показывающие как местное стандартное время Коалиции, так и галактическое координированное время Договора. Идеально подходит для того, чтобы смотреть вместо того, чтобы работать."
	icon_state = "clock"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/clock, 32)

/obj/structure/sign/clock/examine(mob/user)
	. = ..()
	. += span_info("<hr>Текущее время CST (местное): [station_time_timestamp()].")
	. += span_info("\nТекущее время TCT (галактическое): [time2text(world.realtime, "hh:mm:ss")].")

/obj/structure/sign/calendar
	name = "настенный календарь"
	desc = "Я календарь."
	icon_state = "calendar"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/calendar, 32)

/obj/structure/sign/calendar/examine(mob/user)
	. = ..()
	. += span_info("<hr>Текущая дата: [time2text(world.realtime, "DD/MM")]/[CURRENT_STATION_YEAR].")
	if(SSevents.holidays)
		. += span_info("<hr>Праздники:")
		for(var/holidayname in SSevents.holidays)
			. += span_info("\n[holidayname]")

/**
 * List of delamination counter signs on the map.
 * Required as persistence subsystem loads after the ones present at mapload, and to reset to 0 upon explosion.
 */
GLOBAL_LIST_EMPTY(map_delamination_counters)

/obj/structure/sign/delamination_counter
	name = "счетчик расслоений"
	sign_change_name = "Счётчик Расслоений - Для суперматерии"
	desc = "Счётчик показывает сколько смен прошло с момента последнего случая расслоения кристалла."
	icon_state = "days_since_explosion"
	is_editable = TRUE
	var/since_last = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/delamination_counter, 32)

/obj/structure/sign/delamination_counter/Initialize(mapload)
	. = ..()
	GLOB.map_delamination_counters += src
	if (!mapload)
		update_count(SSpersistence.rounds_since_engine_exploded)

/obj/structure/sign/delamination_counter/Destroy()
	GLOB.map_delamination_counters -= src
	return ..()

/obj/structure/sign/delamination_counter/proc/update_count(new_count)
	since_last = min(new_count, 99)
	update_appearance()

/obj/structure/sign/delamination_counter/update_overlays()
	. = ..()

	var/ones = since_last % 10
	var/mutable_appearance/ones_overlay = mutable_appearance('icons/obj/signs.dmi', "days_[ones]")
	ones_overlay.pixel_x = 4
	. += ones_overlay

	var/tens = (since_last / 10) % 10
	var/mutable_appearance/tens_overlay = mutable_appearance('icons/obj/signs.dmi', "days_[tens]")
	tens_overlay.pixel_x = -5
	. += tens_overlay

/obj/structure/sign/delamination_counter/examine(mob/user)
	. = ..()
	. += span_info("<hr>[since_last] смен без происшествий.")
	switch (since_last)
		if (0)
			. += span_info("\nЕсли ты не заметил.")
		if(1)
			. += span_info("\nДавай постараемся ещё.")
		if(2 to 5)
			. += span_info("\nЛучше некуда.")
		if(6 to 10)
			. += span_info("\nОтличная работа!")
		if(11 to INFINITY)
			. += span_info("\nНевероятно!")
