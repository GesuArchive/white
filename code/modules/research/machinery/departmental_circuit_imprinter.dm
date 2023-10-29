/obj/machinery/rnd/production/circuit_imprinter/department
	name = "схемопринтер отдела"
	desc = "Производит печатные платы для создания оборудования."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department

/obj/machinery/rnd/production/circuit_imprinter/department/science
	name = "схемопринтер отдела РнД"
	desc = "Производит печатные платы для создания оборудования."
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/department/science
	allowed_department_flags = DEPARTMENTAL_FLAG_SCIENCE
	department_tag = "Научный"
