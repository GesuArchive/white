/obj/machinery/rnd/production/protolathe/department
	name = "протолат отдела"
	desc = "Специальный протолат со встроенным интерфейсом, предназначенный для использования в отделах, со встроенными приемниками ExoSync, позволяющими печатать исследованные проекты, соответствующие типу отдела, закодированному в ROM."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe/department

/obj/machinery/rnd/production/protolathe/department/engineering
	name = "протолат отдела (Инженерный)"
	allowed_department_flags = DEPARTMENTAL_FLAG_ENGINEERING
	department_tag = "Инженерный"
	circuit = /obj/item/circuitboard/machine/protolathe/department/engineering

/obj/machinery/rnd/production/protolathe/department/service
	name = "протолат отдела (Сервис)"
	allowed_department_flags = DEPARTMENTAL_FLAG_SERVICE
	department_tag = "Сервисный"
	circuit = /obj/item/circuitboard/machine/protolathe/department/service

/obj/machinery/rnd/production/protolathe/department/medical
	name = "протолат отдела (Медбей)"
	allowed_department_flags = DEPARTMENTAL_FLAG_MEDICAL
	department_tag = "Медицинский"
	circuit = /obj/item/circuitboard/machine/protolathe/department/medical

/obj/machinery/rnd/production/protolathe/department/cargo
	name = "протолат отдела (Снабжение)"
	allowed_department_flags = DEPARTMENTAL_FLAG_CARGO
	department_tag = "Снабженский"
	circuit = /obj/item/circuitboard/machine/protolathe/department/cargo

/obj/machinery/rnd/production/protolathe/department/science
	name = "протолат отдела (Научный)"
	allowed_department_flags = DEPARTMENTAL_FLAG_SCIENCE
	department_tag = "Научный"
	circuit = /obj/item/circuitboard/machine/protolathe/department/science

/obj/machinery/rnd/production/protolathe/department/security
	name = "протолат отдела (Охрана)"
	allowed_department_flags = DEPARTMENTAL_FLAG_SECURITY
	department_tag = "Охраны"
	circuit = /obj/item/circuitboard/machine/protolathe/department/security
