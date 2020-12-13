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
	unit_name = "прочая компьютерная часть"
	export_types = list(/obj/item/computer_hardware)
	include_subtypes = TRUE

//Processors.

/datum/export/modular_part/processor
	cost = CARGO_CRATE_VALUE * 0.2
	unit_name = "компьютерный процессор"
	export_types = list(/obj/item/computer_hardware/processor_unit)
	include_subtypes = FALSE

/datum/export/modular_part/processor/photoic
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "усовершенствованный компьютерный процессор"
	export_types = list(/obj/item/computer_hardware/processor_unit)
	include_subtypes = FALSE

//Batteries.

/datum/export/modular_part/battery
	cost = CARGO_CRATE_VALUE * 0.2
	unit_name = "ячейка питания компьютера"
	export_types = list(/obj/item/stock_parts/cell/computer/nano)
	include_subtypes = FALSE


/datum/export/modular_part/battery/upgraded
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "модернизированная ячейка питания компьютера"
	export_types = list(/obj/item/stock_parts/cell/computer/micro)
	include_subtypes = FALSE


/datum/export/modular_part/battery/advanced
	cost = CARGO_CRATE_VALUE * 0.75
	unit_name = "усовершенствованный компьютерный элемент питания"
	export_types = list(/obj/item/stock_parts/cell/computer)
	include_subtypes = FALSE

//Hard Drives.

/datum/export/modular_part/harddrive
	cost = CARGO_CRATE_VALUE * 0.05
	unit_name = "крошечный жесткий диск компьютера"
	export_types = list(/obj/item/computer_hardware/hard_drive/micro)
	include_subtypes = TRUE

/datum/export/modular_part/harddrive/small
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "жесткий диск для небольшого компьютера"
	export_types = list(/obj/item/computer_hardware/hard_drive/small)
	include_subtypes = FALSE

/datum/export/modular_part/harddrive/normal
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "жесткий диск компьютера"
	export_types = list(/obj/item/computer_hardware/hard_drive)
	include_subtypes = FALSE

//Networking/Card Parts
/datum/export/modular_part/networkcard
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "компьютерная сетевая карта"
	export_types = list(/obj/item/computer_hardware/network_card)
	include_subtypes = TRUE

/datum/export/modular_part/idcard
	cost = CARGO_CRATE_VALUE * 0.1
	unit_name = "слот для идентификационной карты компьютера"
	export_types = list(/obj/item/computer_hardware/card_slot)
	include_subtypes = TRUE

/datum/export/modular_part/intellicard
	cost = CARGO_CRATE_VALUE * 0.2
	unit_name = "компьютерный слот для intellicard"
	export_types = list(/obj/item/computer_hardware/ai_slot)
	include_subtypes = TRUE
