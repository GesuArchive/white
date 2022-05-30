/datum/design/experi_scanner
	name = "Экспериментальный сканер"
	desc = "Позволяет анализировать и фиксировать данные полученные из результатов экспериментов."
	id = "experi_scanner"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 500, /datum/material/iron = 500)
	build_path = /obj/item/experi_scanner
	category = list("Снаряжение", "Научное снаряжение")
	sub_category = list("Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
