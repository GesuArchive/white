/obj/machinery/rnd/production/techfab/department
	name = "department techfab"
	desc = "An advanced fabricator designed to print out the latest prototypes and circuits researched from Science. Contains hardware to sync to research networks. This one is department-locked and only possesses a limited set of decryption keys."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/techfab/department

/obj/machinery/rnd/production/techfab/department/engineering
	name = "Инженерный фабрикатор"
	allowed_department_flags = DEPARTMENTAL_FLAG_ENGINEERING
	department_tag = "Инженерный"
	circuit = /obj/item/circuitboard/machine/techfab/department/engineering

/obj/machinery/rnd/production/techfab/department/service
	name = "Сервисный фабрикатор"
	allowed_department_flags = DEPARTMENTAL_FLAG_SERVICE
	department_tag = "Сервисный"
	circuit = /obj/item/circuitboard/machine/techfab/department/service

/obj/machinery/rnd/production/techfab/department/medical
	name = "Медицинский фабрикатор"
	allowed_department_flags = DEPARTMENTAL_FLAG_MEDICAL
	department_tag = "Медицинский"
	circuit = /obj/item/circuitboard/machine/techfab/department/medical

/obj/machinery/rnd/production/techfab/department/cargo
	name = "Снабженский фабрикатор"
	allowed_department_flags = DEPARTMENTAL_FLAG_CARGO
	department_tag = "Снабженский"
	circuit = /obj/item/circuitboard/machine/techfab/department/cargo

/obj/machinery/rnd/production/techfab/department/science
	name = "Научный фабрикатор"
	allowed_department_flags = DEPARTMENTAL_FLAG_SCIENCE
	department_tag = "Научный"
	circuit = /obj/item/circuitboard/machine/techfab/department/science

/obj/machinery/rnd/production/techfab/department/security
	name = "Фабрикатор службы безопасности"
	allowed_department_flags = DEPARTMENTAL_FLAG_SECURITY
	department_tag = "Безопасности"
	circuit = /obj/item/circuitboard/machine/techfab/department/security
