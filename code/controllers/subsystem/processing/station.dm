PROCESSING_SUBSYSTEM_DEF(station)
	name = "Станция"
	init_order = INIT_ORDER_STATION
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 5 SECONDS

	///Currently active announcer. Starts as a type but gets initialized after traits are selected
	var/datum/centcom_announcer/announcer = null

/datum/controller/subsystem/processing/station/Initialize(timeofday)

	if(prob(20))
		announcer = new /datum/centcom_announcer/default
	else if(prob(20))
		announcer = new /datum/centcom_announcer/intern
	else
		announcer = new /datum/centcom_announcer/ru_default

	return ..()

