/datum/design/board/telepad
	name = "Телепад"
	desc = "Блюспейс катапульта в масштабах космоса. Для использования нужно ввести точные координаты с поправкой в консоль телепада."
	id = "telepad"
	build_path = /obj/item/circuitboard/machine/telesci_pad
	category = list ("Телепортация", "Инженерное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/obj/item/circuitboard/machine/telesci_pad
	name = "телепад"
	desc = "Блюспейс катапульта в масштабах космоса. Для использования нужно ввести точные координаты с поправкой в консоль телепада."
	build_path = /obj/machinery/telepad
	req_components = list(
							/obj/item/stack/ore/bluespace_crystal = 2,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

//////////////////////////////////////////////////////////

/datum/design/board/telesci_console
	name = "Консоль телепада"
	desc = "Для работы необходимо связать с телепадом и поместить в консоль блюспейс кристаллы. Нуждается в калибровке."
	id = "telesci_console"
	build_path = /obj/item/circuitboard/computer/telesci_console
	category = list("Телепортация", "Инженерное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/obj/item/circuitboard/computer/telesci_console
	name = "Консоль телепада"
	desc = "Для работы необходимо связать с телепадом и поместить в консоль блюспейс кристаллы. Нуждается в калибровке."
	build_path = /obj/machinery/computer/telescience

//////////////////////////////////////////////////////////

/datum/techweb_node/telesci
	id = "telesci"
	display_name = "Теленаука"
	description = "Позволяет строить продвинутые телепортационные установки."
	prereq_ids = list("adv_datatheory")
	design_ids = list("telepad", "telesci_console")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
