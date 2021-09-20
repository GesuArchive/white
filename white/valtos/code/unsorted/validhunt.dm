/datum/smite/valid_hunt
	name = "Valid Hunt"

/datum/smite/valid_hunt/effect(client/user, mob/living/target)
	. = ..()
	var/bounty = input("Награда в кредитах:", "Жопа", 50) as num|null

	priority_announce("За голову [target] назначена награда в размере [bounty] кредит[get_num_string(bounty)]. Цель будет подсвечена лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')

/datum/component/bounty
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/bounty_size
	var/datum/beam/ourbeam

/datum/component/bounty/Initialize(_bounty_size)
	bounty_size = _bounty_size
	if(isliving(parent))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/bounty_examine)
		RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/bounty_death)
	else
		return COMPONENT_INCOMPATIBLE

	var/mob/M = parent
	M.add_atom_colour(COLOR_RED, FIXED_COLOUR_PRIORITY)
	M.set_light(1.4, 4, COLOR_RED, TRUE)

	var/turf/T = locate(world.maxx - 1, world.maxy - 1, 2)

	ourbeam = T.Beam(M, icon_state = "sat_beam", time = INFINITY)

/datum/component/bounty/Destroy()
	var/mob/M = parent
	M.remove_atom_colour(FIXED_COLOUR_PRIORITY, COLOR_RED)
	M.set_light(0, 0, 0, 0)
	qdel(ourbeam)
	return ..()

/datum/component/bounty/proc/bounty_examine(datum/source, mob/user, list/out)
	SIGNAL_HANDLER
	var/mob/M = parent
	out = "<hr><span class='warning'>Награда за это тело всего [bounty_size] кредит[get_num_string(bounty_size)]. Чудеса.</span>"

/datum/component/bounty/proc/bounty_death()
	SIGNAL_HANDLER

	var/obj/structure/closet/supplypod/bluespacepod/pod = new()
	new /obj/item/holochip(pod, bounty_size)
	pod.explosionSize = list(0,0,0,0)

	new /obj/effect/pod_landingzone(get_turf(parent), pod)

	qdel(src)
