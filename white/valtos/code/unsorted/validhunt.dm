/datum/smite/valid_hunt
	name = "Valid Hunt"

/datum/smite/valid_hunt/effect(client/user, mob/living/target)
	. = ..()
	var/bounty = input("Награда в кредитах:", "Жопа", 50) as num|null

	target.AddComponent(/datum/component/bounty, bounty)

	priority_announce("За голову [target] назначена награда в размере [bounty] кредит[get_num_string(bounty)]. Цель будет подсвечена лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')

/datum/component/bounty
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/bounty_size
	var/datum/beam/ourbeam_one
	var/datum/beam/ourbeam_two

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

	ourbeam_one = M.Beam(T, icon_state = "sat_beam", time = INFINITY)

	var/turf/MT = get_turf(M)

	if(SSmapping.get_turf_below(MT) || SSmapping.get_turf_above(MT))
		var/turf/T2 = locate(world.maxx - 1, world.maxy - 1, 3)
		ourbeam_two = M.Beam(T2, icon_state = "sat_beam", time = INFINITY)


/datum/component/bounty/Destroy()
	var/mob/M = parent
	M.remove_atom_colour(FIXED_COLOUR_PRIORITY, COLOR_RED)
	M.set_light(0, 0, 0, 0)
	qdel(ourbeam_one)
	qdel(ourbeam_two)
	return ..()

/datum/component/bounty/proc/bounty_examine(datum/source, mob/user, list/out)
	SIGNAL_HANDLER
	out = "<hr><span class='warning'>Награда за это тело всего [bounty_size] кредит[get_num_string(bounty_size)]. Чудеса.</span>"

/datum/component/bounty/proc/bounty_death()
	SIGNAL_HANDLER

	var/obj/item/I = new /obj/item/holochip(src, bounty_size)
	var/obj/structure/closet/supplypod/pod = podspawn(list(
		"target" = get_turf(parent),
		"path" = /obj/structure/closet/supplypod/box
	))
	I.forceMove(pod)

	qdel(src)
