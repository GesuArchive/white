/datum/export/large/crate
	cost = CARGO_CRATE_VALUE
	k_elasticity = 0
	unit_name = "Ящик"
	export_types = list(/obj/structure/closet/crate)
	exclude_types = list(/obj/structure/closet/crate/large, /obj/structure/closet/crate/wooden, /obj/structure/closet/crate/mail)

/datum/export/large/crate/total_printout(datum/export_report/ex, notes = TRUE) // That's why a goddamn metal crate costs that much.
	. = ..()
	if(. && notes)
		. += " Благодарим за участие в программе переработки ящиков НТ."

/datum/export/large/crate/wooden
	cost = CARGO_CRATE_VALUE/5
	unit_name = "Большой деревянный ящик"
	export_types = list(/obj/structure/closet/crate/large)
	exclude_types = list()

/datum/export/large/crate/wooden/ore
	unit_name = "Ящик для руды"
	export_types = list(/obj/structure/ore_box)

/datum/export/large/crate/wood
	cost = CARGO_CRATE_VALUE * 0.48
	unit_name = "Деревянный ящик"
	export_types = list(/obj/structure/closet/crate/wooden)
	exclude_types = list()

/datum/export/large/crate/coffin
	cost = CARGO_CRATE_VALUE/2 //50 wooden crates cost 2000 points, and you can make 10 coffins in seconds with those planks. Each coffin selling for 250 means you can make a net gain of 500 points for wasting your time making coffins.
	unit_name = "Гроб"
	export_types = list(/obj/structure/closet/crate/coffin)

/datum/export/large/reagent_dispenser
	cost = CARGO_CRATE_VALUE * 0.5 // +0-400 depending on amount of reagents left
	var/contents_cost = 4

/datum/export/large/reagent_dispenser/get_cost(obj/O)
	var/obj/structure/reagent_dispensers/D = O
	var/ratio = D.reagents.total_volume / D.reagents.maximum_volume

	return ..() + round(contents_cost * ratio)

/datum/export/large/reagent_dispenser/water
	unit_name = "Бак с водой"
	export_types = list(/obj/structure/reagent_dispensers/watertank)
	contents_cost = 2

/datum/export/large/reagent_dispenser/fuel
	unit_name = "Топливный бак"
	export_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/export/large/reagent_dispenser/beer
	unit_name = "Пивная кега"
	contents_cost = CARGO_CRATE_VALUE * 3.5
	export_types = list(/obj/structure/reagent_dispensers/beerkeg)

/*
/datum/export/large/pipedispenser
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "Диспенсер труб"
	export_types = list(/obj/machinery/pipedispenser)
*/
/datum/export/large/emitter
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "Излучатель"
	export_types = list(/obj/machinery/power/emitter)

/datum/export/large/field_generator
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "Генератор поля"
	export_types = list(/obj/machinery/field/generator)

/datum/export/large/collector
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "Радиационный коллекторный массив"
	export_types = list(/obj/machinery/power/rad_collector)

/datum/export/large/tesla_coil
	cost = CARGO_CRATE_VALUE * 2.25
	unit_name = "Катушка Теслы"
	export_types = list(/obj/machinery/power/tesla_coil)

/datum/export/large/pa
	cost = CARGO_CRATE_VALUE * 3
	unit_name = "Часть ускорителя частиц"
	export_types = list(/obj/structure/particle_accelerator)

/datum/export/large/pa/controls
	cost = CARGO_CRATE_VALUE * 5
	unit_name = "Консоль ускорителя частиц"
	export_types = list(/obj/machinery/particle_accelerator/control_box)

/datum/export/large/supermatter
	cost = CARGO_CRATE_VALUE * 16
	unit_name = "Осколок суперматерии"
	export_types = list(/obj/machinery/power/supermatter_crystal/shard)

/datum/export/large/grounding_rod
	cost = CARGO_CRATE_VALUE * 1.2
	unit_name = "Заземлитель"
	export_types = list(/obj/machinery/power/grounding_rod)

/datum/export/large/tesla_gen
	cost = CARGO_CRATE_VALUE * 4
	unit_name = "Инициатор Тесла-аномалии"
	export_types = list(/obj/machinery/the_singularitygen/tesla)

/datum/export/large/singulo_gen
	cost = CARGO_CRATE_VALUE * 4
	unit_name = "Инициатор гравитационной сингулярности"
	export_types = list(/obj/machinery/the_singularitygen)
	include_subtypes = FALSE

/datum/export/large/iv
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "Капельница"
	export_types = list(/obj/item/iv_drip_item, /obj/machinery/iv_drip)

/datum/export/large/barrier
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "Барьерная граната"
	export_types = list(/obj/item/grenade/barrier, /obj/structure/barricade/security)

/datum/export/large/gas_canister
	cost = CARGO_CRATE_VALUE * 0.05 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Канистра с газом"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
	k_elasticity = 0.00033

/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = cost
	var/datum/gas_mixture/canister_mix = C.return_air()
	var/canister_gas = canister_mix.gases
	var/list/gases_to_check = list(
								/datum/gas/bz,
								/datum/gas/nitrium,
								/datum/gas/hypernoblium,
								/datum/gas/miasma,
								/datum/gas/tritium,
								/datum/gas/pluoxium,
								/datum/gas/freon,
								/datum/gas/hydrogen,
								/datum/gas/healium,
								/datum/gas/proto_nitrate,
								/datum/gas/zauker,
								/datum/gas/helium,
								/datum/gas/antinoblium,
								/datum/gas/halon,
								)

	for(var/gasID in gases_to_check)
		canister_mix.assert_gas(gasID)
		if(canister_gas[gasID][MOLES] > 0)
			worth += get_gas_value(gasID, canister_gas[gasID][MOLES])

	canister_mix.garbage_collect()
	return worth

/datum/export/large/gas_canister/proc/get_gas_value(datum/gas/gasType, moles)
	var/baseValue = initial(gasType.base_value)
	return round((baseValue/k_elasticity) * (1 - NUM_E**(-1 * k_elasticity * moles)))

/datum/export/large/enernet_coil
	cost = CARGO_CRATE_VALUE
	unit_name = "Энергоконцентратор"
	export_types = list(/obj/machinery/enernet_coil)
	k_elasticity = 0.01

/datum/export/large/enernet_coil/get_cost(obj/O)
	var/obj/machinery/enernet_coil/e_coil = O
	return e_coil.cur_acc
