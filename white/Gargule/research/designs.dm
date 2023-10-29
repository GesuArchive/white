/datum/design/cyberimp_surgical_alien
	name = "Имплант инопланетных инструментов"
	desc = "Набор инопланетных хирургических инструментов скрывающийся за скрытой панелью на руке пользователя."
	id = "ci-aliensurgery"
	build_type = PROTOLATHE | MECHFAB
	materials = list (/datum/material/iron = 2500, /datum/material/glass = 1500, /datum/material/silver = 1500, /datum/material/plasma = 500, /datum/material/titanium = 1500)
	construction_time = 200
	build_path = /obj/item/organ/cyberimp/arm/alien
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/circular_saw_folding
	name = "Раскладная пила"
	id = "circular_saw_folding"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/circular_saw/folding
	category = list("initial", "Медицина")

/datum/design/optable_folding
	name = "Раскладной операционный стол"
	desc = "Компактный операционный стол для полевой хирургии"
	id = "optable_folding"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 3000, /datum/material/silver = 2000)
	build_path = /obj/item/optable
	construction_time = 50
	category = list("initial", "Медицина", "Медицинское снаряжение")
	sub_category = list("Прочее")

/datum/design/cyberimp_science_hud
	name = "Имплант научного интерфейса"
	desc = "Выводит научный интерфейс поверх всего что вы видите. Сканирует реагенты и предметы."
	id = "ci-scihud"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 500, /datum/material/gold = 500)
	build_path = /obj/item/organ/cyberimp/eyes/hud/science
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Дополненая реальность")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_diagnostic_hud
	name = "Имплант диагностического интерфейса"
	desc = "Выводит диагностический интерфейс поверх всего что вы видите. Сканирует технику: мехов, киборгов, наниты и шлюзы."
	id = "ci-diaghud"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 500, /datum/material/gold = 500)
	build_path = /obj/item/organ/cyberimp/eyes/hud/diagnostic
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Дополненая реальность")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
