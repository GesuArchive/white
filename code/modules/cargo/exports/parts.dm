// Circuit boards, spare parts, etc.

/datum/export/solar/assembly
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "солнечная панель"
	export_types = list(/obj/item/solar_assembly)

/datum/export/solar/tracker_board
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "плата отслеживателя солнечных лучей"
	export_types = list(/obj/item/electronics/tracker)

/datum/export/solar/control_board
	cost = CARGO_CRATE_VALUE * 0.75
	unit_name = "плата консоли управления солнечными панелями"
	export_types = list(/obj/item/circuitboard/computer/solar_control)

//Computer Tablets and Parts
/datum/export/modular_part
	cost = CARGO_CRATE_VALUE * 0.075
	unit_name = "любое компьютерное оборудование"
	export_types = list(/obj/item/computer_hardware)
	include_subtypes = TRUE

//Batteries.

/datum/export/modular_part/battery
	cost = CARGO_CRATE_VALUE * 0.2
	unit_name = "Нано батарея ПК"
	export_types = list(/obj/item/stock_parts/cell/computer/nano)
	include_subtypes = FALSE


/datum/export/modular_part/battery/upgraded
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Микро батарея ПК"
	export_types = list(/obj/item/stock_parts/cell/computer/micro)
	include_subtypes = FALSE


/datum/export/modular_part/battery/advanced
	cost = CARGO_CRATE_VALUE * 0.75
	unit_name = "Стандартная батарея ПК"
	export_types = list(/obj/item/stock_parts/cell/computer)
	include_subtypes = FALSE
