/**
 * Simple admin tool that enables players to be assigned to a VERY SHITTY, very visually distinct team, quickly and affordably.
 */
/obj/machinery/teambuilder
	name = "машина выбора команды"
	desc = "Машина, которая красит тебя в цвет команды, при проходе через неё. Эта машина красит в цвет нейтральной команды."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "lpad-idle"
	density = FALSE
	can_buckle = FALSE
	resistance_flags = INDESTRUCTIBLE // Just to be safe.
	use_power = NO_POWER_USE
	///What color is your mob set to when crossed?
	var/team_color = COLOR_WHITE
	///What radio station is your radio set to when crossed (And human)?
	var/team_radio = FREQ_COMMON

/obj/machinery/teambuilder/Initialize(mapload)
	. = ..()
	add_filter("teambuilder", 2, list("type" = "outline", "color" = team_color, "size" = 2))
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/teambuilder/examine_more(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Замечаю написанную на скорую руку записку, она гласит '1215-1217, ВЫБЕРИ СТОРОНУ'.</span>"

/obj/machinery/teambuilder/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM.get_filter("teambuilder"))
		return
	if(isliving(AM) && team_color)
		AM.add_filter("teambuilder", 2, list("type" = "outline", "color" = team_color, "size" = 2))
	if(ishuman(AM) && team_radio)
		var/mob/living/carbon/human/human = AM
		var/obj/item/radio/Radio = human.ears
		if(!Radio)
			return
		Radio.set_frequency(team_radio)

/obj/machinery/teambuilder/red
	name = "машина выбора команды (Красная команда)"
	desc = "Машина, которая красит тебя в цвет команды, при проходе через неё. Эта машина красит в цвет красной команды."
	team_color = COLOR_RED
	team_radio = FREQ_CTF_RED

/obj/machinery/teambuilder/blue
	name = "машина выбора команды (Синяя команда)"
	desc = "Машина, которая красит тебя в цвет команды, при проходе через неё. Эта машина красит в цвет синей команды."
	team_color = COLOR_BLUE
	team_radio = FREQ_CTF_BLUE
