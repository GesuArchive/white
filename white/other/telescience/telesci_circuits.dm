/datum/design/board/telepad
	name = "Оборудование (Плата Телепада)"
	desc = "Плата космической катапульты."
	id = "telepad"
	build_path = /obj/item/circuitboard/machine/telesci_pad
	category = list ("Телепортация")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/obj/item/circuitboard/machine/telesci_pad
	name = "Телепад (Оборудование)"
	build_path = /obj/machinery/telepad
	req_components = list(
							/obj/item/stack/ore/bluespace_crystal = 2,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

//////////////////////////////////////////////////////////

/datum/design/board/telesci_console
	name = "Дизайн консоли (Плата Консоли Управления Телепадом)"
	desc = "Позволяет построить консоль для управления космической катапультой."
	id = "telesci_console"
	build_path = /obj/item/circuitboard/computer/telesci_console
	category = list("Телепортация")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/obj/item/circuitboard/computer/telesci_console
	name = "Консоль теленауки (Консоль)"
	build_path = /obj/machinery/computer/telescience

//////////////////////////////////////////////////////////

/datum/techweb_node/telesci
	id = "telesci"
	display_name = "Прикол/Временные манипуляции"
	description = "Позволяет строить продвинутые прикольные сооружения."
	prereq_ids = list("adv_datatheory")
	design_ids = list("telepad", "telesci_console")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
