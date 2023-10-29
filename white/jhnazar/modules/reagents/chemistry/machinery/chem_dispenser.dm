/obj/machinery/chem_dispenser/botany
	name = "ботанический хим-раздатчик"
	desc = "Создает и выдает ботанические химикаты."

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
		/datum/reagent/toxin/mutagen,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/toxin/pestkiller,
		)
	upgrade_reagents = list(
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/plantnutriment/eznutriment,
		/datum/reagent/plantnutriment/left4zednutriment,
		/datum/reagent/plantnutriment/robustharvestnutriment,
		/datum/reagent/plantnutriment/endurogrow,
		/datum/reagent/plantnutriment/liquidearthquake,
		/datum/reagent/toxin/plantbgone/weedkiller,
		/datum/reagent/toxin/pestkiller/organic
		)
	emagged_reagents = list(
		/datum/reagent/medicine/strange_reagent
		)

/obj/machinery/chem_dispenser/gunpowder
	name = "генератор пороха"
	desc = "Создаёт порох..."
	anchored = TRUE
	color = "#999999"
	circuit = /obj/item/circuitboard/machine/chem_dispenser/gunpowder

	dispensable_reagents = list(
		/datum/reagent/gunpowder
		)
	upgrade_reagents = list(
		/datum/reagent/drug/zvezdochka
		)
	emagged_reagents = list(
		/datum/reagent/drug/labebium
		)
