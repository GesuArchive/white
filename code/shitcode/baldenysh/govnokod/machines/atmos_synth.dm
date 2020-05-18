/obj/machinery/power/atmos_synthesizer
	name = "собиратель приколов"
	desc = "собирает приколы из прикольных газов"
	anchored = FALSE
	density = TRUE
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN
	icon = 'icons/obj/atmos.dmi'
	icon_state = "electrolyzer-off"
	max_integrity = 250
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 10)
	//circuit = /obj/item/circuitboard/machine/electrolyzer
	use_power = NO_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100

	var/synth_type = /obj/item/stack/sheet/cotton
	var/list/gas_moles_per_synth = list(
										/datum/gas/carbon_dioxide = 0.5,
										/datum/gas/hydrogen = 0.1
										)

/obj/machinery/power/atmos_synthesizer/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/atmos_synthesizer/Destroy()
	disconnect_from_network()
	return ..()

