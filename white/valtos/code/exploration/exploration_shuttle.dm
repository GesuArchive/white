/obj/machinery/computer/shuttle_flight/exploration
	name = "управление шаттлом рейнджеров"
	desc = "Для сам знаешь чего."
	circuit = /obj/item/circuitboard/computer/exploration_shuttle
	shuttleId = "exploration"
	possible_destinations = "exploration_home"
	var/list/banned_types = list(
		/mob/living/carbon/alien,
		/obj/item/clothing/mask/facehugger,
		/obj/item/organ/body_egg/alien_embryo,
		/obj/item/organ/zombie_infection
	)

/obj/machinery/computer/shuttle_flight/exploration/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override)
	return

/obj/machinery/computer/shuttle_flight/exploration/ui_interact(mob/user, datum/tgui/ui)
	if(isliving(user))
		if(check_banned_contents())
			say("Пидарас, ты ксенохуйню с шаттла выкинь, тогда побазарим.")
			return
	. = ..()

/obj/machinery/computer/shuttle_flight/exploration/ui_act(action, params)
	if(check_banned_contents())
		say("Пидарас, ты ксенохуйню с шаттла выкинь, тогда побазарим.")
		return
	. = ..()

/obj/machinery/computer/shuttle_flight/exploration/proc/check_banned_contents()
	var/obj/docking_port/mobile/port = SSshuttle.getShuttle(shuttleId)
	for(var/area/A in port.shuttle_areas)
		var/list/obj/area_contents = A.contents
		for(var/mob/living/carbon/C in A.contents)
			area_contents |= C.internal_organs
			area_contents |= C.get_contents()
		for(var/obj/structure/closet/CL in A.contents)
			area_contents |= CL.contents

		for(var/obj/O in area_contents)
			for(var/type in banned_types)
				if(istype(O, type))
					return TRUE

