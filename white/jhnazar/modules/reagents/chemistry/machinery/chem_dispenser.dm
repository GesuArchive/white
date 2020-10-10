/obj/machinery/chem_dispenser/botany
	name = "Botany Chem Dispenser"
	desc = "Creates and dispenses botany chemicals."

	icon = 'white/jhnazar/icons/obj/chemical.dmi'
	icon_state = "botany_dispenser"
	working_state = "botany_dispenser_working"
	nopower_state = "botany_dispenser_nopower"

	anchored = 0

	circuit = /obj/item/circuitboard/machine/chem_dispenser/botany

	dispensable_reagents = list(
		/datum/reagent/ammonia,
		/datum/reagent/diethylamine,
		/datum/reagent/saltpetre,
		/datum/reagent/medicine/c2/multiver,
		/datum/reagent/toxin/mutagen
		)
	upgrade_reagents = list(
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/plantnutriment/eznutriment,
		/datum/reagent/plantnutriment/left4zednutriment,
		/datum/reagent/plantnutriment/robustharvestnutriment
		)
	emagged_reagents = list(
		/datum/reagent/medicine/strange_reagent
		)