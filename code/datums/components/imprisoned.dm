/datum/component/imprisoned
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/movement_detector/move_tracker
	var/timerid

/datum/component/imprisoned/Initialize(mapload)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	timerid = addtimer(CALLBACK(src, PROC_REF(clean_reputation)), 30 MINUTES, TIMER_STOPPABLE)
	move_tracker = new(parent, CALLBACK(src,PROC_REF(check_area)))

/datum/component/imprisoned/proc/check_area()
	var/atom/movable/AM = parent
	var/area/current = get_area(AM)
	if(istype(current, /area/security/prison))
		qdel(src)
		return

/datum/component/imprisoned/proc/clean_reputation()
	if(!isliving(parent))
		qdel(src)
		return

	var/mob/living/L = parent

	L?.mind?.remove_all_antag()

	if(L?.client && L.client.get_metabalance() < 0)
		to_chat(L, "<b><big>Это заключение излечило мой аутизм.</big></b>")
		message_admins("[ADMIN_LOOKUPFLW(L)] обнуляет метакэш в перме.")
		log_game("[key_name(L)] обнуляет метакэш в перме.")
		L.client.set_metacoin_count(0)
		qdel(src)
		return

/datum/component/imprisoned/Destroy(force, silent)
	QDEL_NULL(move_tracker)
	QDEL_NULL(timerid)
	. = ..()
