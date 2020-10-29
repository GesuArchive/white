///////SMELTABLE ALLOYS///////

/datum/design/plasteel_alloy
	name = "Плазма + Железо"
	id = "plasteel"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT, /datum/material/plasma = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasteel
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50


/datum/design/plastitanium_alloy
	name = "Плазма + Титан"
	id = "plastitanium"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/titanium = MINERAL_MATERIAL_AMOUNT, /datum/material/plasma = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/plastitanium
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50

/datum/design/plaglass_alloy
	name = "Плазма + Стекло"
	id = "plasmaglass"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmaglass
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50

/datum/design/plasmarglass_alloy
	name = "Плазма + Железо + Стекло"
	id = "plasmareinforcedglass"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.5,  /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmarglass
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50

/datum/design/titaniumglass_alloy
	name = "Титан + Стекло"
	id = "titaniumglass"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/titanium = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/titaniumglass
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50

/datum/design/plastitaniumglass_alloy
	name = "Плазма + Титан + Стекло"
	id = "plastitaniumglass"
	build_type = SMELTER | PROTOLATHE
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/titanium = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plastitaniumglass
	category = list("initial", "Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
	maxstack = 50

/datum/design/alienalloy
	name = "Чужеродный сплав"
	desc = "A sheet of reverse-engineered alien alloy."
	id = "alienalloy"
	build_type = PROTOLATHE | SMELTER
	materials = list(/datum/material/iron = 4000, /datum/material/plasma = 4000)
	build_path = /obj/item/stack/sheet/mineral/abductor
	category = list("Запчасти обрудования")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
