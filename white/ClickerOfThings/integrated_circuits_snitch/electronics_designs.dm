/datum/design/integrated_printer
	name = "Принтер интегральных схем"
	desc = "Портативная машина, предназначенная для печати крошечных модульных интегральных схем."
	id = "icprinter"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 5000, /datum/material/iron = 10000)
	build_path = /obj/item/integrated_circuit_printer
	category = list("Электроника", "Интегральные схемы")
	sub_category = list("Интегральные схемы модели TGOld")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/IC_printer_upgrade_advanced
	name = "Модернизация принтера интегральных схем - расширенное ПО"
	desc = "Содержит новые, усовершенствованные дизайны схем."
	id = "icupgadv"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 10000, /datum/material/iron = 10000)
	build_path = /obj/item/disk/integrated_circuit_old/upgrade/advanced
	category = list("Электроника", "Интегральные схемы")
	sub_category = list("Интегральные схемы модели TGOld")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/IC_printer_upgrade_clone
	name = "Модернизация принтера интегральных схем - клонирование"
	desc = "Позволяет принтеру мгновенно дублировать сборки интегральных схем."
	id = "icupgclo"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 10000, /datum/material/iron = 10000)
	build_path = /obj/item/disk/integrated_circuit_old/upgrade/clone
	category = list("Электроника", "Интегральные схемы")
	sub_category = list("Интегральные схемы модели TGOld")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
