////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/basic_cell
	name = "Базовая батарея"
	desc = "Перезаряжаемый электрохимический элемент питания, вмещающий 1 МДж энергии."
	id = "basic_cell"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 700, /datum/material/glass = 50)
	construction_time = 40
	build_path = /obj/item/stock_parts/cell/empty
	category = list("Батареи и прочее","Энергетические разработки","Оборудование","initial")

/datum/design/basic_cell/stock_parts
	id = "basic_cell2"
	build_type = MECHFAB
	category = list("Медицинское оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Базовые компоненты")

/datum/design/high_cell
	name = "Батарея увеличенной емкости"
	desc = "Перезаряжаемый электрохимический элемент питания, вмещающий 10 МДж энергии."
	id = "high_cell"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 700, /datum/material/glass = 60)
	construction_time = 40
	build_path = /obj/item/stock_parts/cell/high/empty
	category = list("Батареи и прочее","Энергетические разработки")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/super_cell
	name = "Батарея сверхувеличенной емкости"
	desc = "Усовершенстованный перезаряжаемый электрохимический элемент питания, вмещающий 20 МДж энергии."
	id = "super_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 700, /datum/material/glass = 70)
	construction_time = 40
	build_path = /obj/item/stock_parts/cell/super/empty
	category = list("Батареи и прочее","Энергетические разработки")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/hyper_cell
	name = "Батарея гиперувеличенной емкости"
	desc = "Усовершенстованный перезаряжаемый электрохимический элемент питания, вмещающий 30 МДж энергии."
	id = "hyper_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 700, /datum/material/gold = 150, /datum/material/silver = 150, /datum/material/glass = 80)
	construction_time = 40
	build_path = /obj/item/stock_parts/cell/hyper/empty
	category = list("Батареи и прочее","Энергетические разработки")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/bluespace_cell
	name = "Блюспейс батарея"
	desc = "Экспериментальный перезаряжаемый межпространственный элемент питания, вмещающий 40 МДж энергии."
	id = "bluespace_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 800, /datum/material/gold = 120, /datum/material/glass = 160, /datum/material/diamond = 160, /datum/material/titanium = 300, /datum/material/bluespace = 100)
	construction_time = 40
	build_path = /obj/item/stock_parts/cell/bluespace/empty
	category = list("Батареи и прочее","Энергетические разработки")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/inducer
	name = "Индуктор"
	desc = "Инструмент для индуктивной зарядки элементов питания, позволяя заряжать их без необходимости извлечения."
	id = "inducer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 1000)
	build_path = /obj/item/inducer/sci
	category = list("Энергетические разработки")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/pacman
	name = "П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на плазме."
	build_type = IMPRINTER | MECHFAB
	construction_time = 100
	id = "pacman"
	build_path = /obj/item/circuitboard/machine/pacman
	category = list("Инженерное оборудование")
	sub_category = list("Портативные генераторы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/pacman/super
	name = "С.У.П.Е.Р.П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на уране."
	build_type = IMPRINTER | MECHFAB
	construction_time = 100
	id = "superpacman"
	build_path = /obj/item/circuitboard/machine/pacman/super
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/pacman/mrs
	name = "М.И.С.И.С.П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на алмазах."
	build_type = IMPRINTER | MECHFAB
	construction_time = 100
	id = "mrspacman"
	build_path = /obj/item/circuitboard/machine/pacman/mrs
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
