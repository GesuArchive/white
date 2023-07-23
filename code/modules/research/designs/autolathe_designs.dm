///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////

/datum/design/bucket
	name = "Ведро"
	id = "bucket"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/reagent_containers/glass/bucket
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Инвентарь уборщика")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/mop
	name = "Швабра"
	id = "mop"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/mop
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Инвентарь уборщика")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/broom
	name = "Метла"
	id = "pushbroom"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/pushbroom
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Инвентарь уборщика")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/crowbar
	name = "Карманный ломик"
	id = "crowbar"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/crowbar
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/flashlight
	name = "Фонарик"
	id = "flashlight"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/flashlight
	category = list("initial","Инструменты", "Медицинское снаряжение", "Инженерное снаряжение", "Научное снаряжение", "Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Прочее")

/datum/design/extinguisher
	name = "Огнетушитель"
	id = "extinguisher"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 90)
	build_path = /obj/item/extinguisher
	category = list("initial","Инструменты","Инженерное снаряжение","Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")

/datum/design/pocketfireextinguisher
	name = "Карманный огнетушитель"
	id = "pocketfireextinguisher"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	build_path = /obj/item/extinguisher/mini
	category = list("initial","Инструменты","Инженерное снаряжение","Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")

/datum/design/multitool
	name = "Мультитул"
	id = "multitool"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/multitool
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/analyzer
	name = "Газоанализатор"
	id = "analyzer"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/analyzer
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/tscanner
	name = "Терагерцовый сканер"
	id = "tscanner"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/t_scanner
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/weldingtool
	name = "Сварочный аппарат"
	id = "welding_tool"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 70, /datum/material/glass = 20)
	build_path = /obj/item/weldingtool
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/mini_weldingtool
	name = "Аварийный сварочный аппарат"
	id = "mini_welding_tool"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30, /datum/material/glass = 10)
	build_path = /obj/item/weldingtool/mini
	category = list("initial","Инструменты")

/datum/design/screwdriver
	name = "Отвёртка"
	id = "screwdriver"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/screwdriver
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/wirecutters
	name = "Кусачки"
	id = "wirecutters"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/wirecutters
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/wrench
	name = "Гаечный ключ"
	id = "wrench"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/wrench
	category = list("initial","Инструменты","Рабочие инструменты","Рабочие инструменты ","Рабочие инструменты  ","Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/plunger
	name = "Вантуз"
	desc = "Не для унитаза!"
	id = "plunger"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/plunger
	construction_time = 40
	category = list("initial","Инструменты","Рабочие инструменты", "Фармацевтика", "Инженерное оборудование","Научное оборудование")
	sub_category = list("Хим-фабрика")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/welding_helmet
	name = "Сварочная маска"
	id = "welding_helmet"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1750, /datum/material/glass = 400)
	build_path = /obj/item/clothing/head/welding
	category = list("initial","Инструменты","Инженерное снаряжение")
	sub_category = list("Экипировка")

/datum/design/cable_coil
	name = "Моток кабеля"
	id = "cable_coil"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10, /datum/material/glass = 5)
	build_path = /obj/item/stack/cable_coil
	category = list("initial","Инструменты","Рабочие инструменты")
	maxstack = MAXCOIL
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/toolbox
	name = "Ящик с инструментами"
	id = "tool_box"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 500)
	build_path = /obj/item/storage/toolbox
	category = list("initial","Инструменты")

/datum/design/toolbox/mechfab
	id = "tool_box_mechfab"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	category = list("Прочее")

/datum/design/apc_board
	name = "Контролер энергощитка АПЦ"
	id = "power control"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/electronics/apc
	category = list("initial", "Электроника","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airlock_board
	name = "Контролер шлюза"
	id = "airlock_board"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airlock
	category = list("initial", "Электроника","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/firelock_board
	name = "Контролер пожарного шлюза"
	id = "firelock_board"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firelock
	category = list("initial", "Электроника","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airalarm_electronics
	name = "Контролер АТМОСа"
	id = "airalarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airalarm
	category = list("initial", "Электроника","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/firealarm_electronics
	name = "Контролер пожарной сигнализации"
	id = "firealarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firealarm
	category = list("initial", "Электроника","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/trapdoor_electronics
	name = "Контролер люка-ловушки"
	id = "trapdoor_electronics"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/assembly/trapdoor
	category = list("initial", "Электроника", "Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/camera
	name = "Фотокамера"
	id = "camera"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 100)
	build_path = /obj/item/camera
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Экипировка")

/datum/design/camera_film
	name = "Фотопленка"
	id = "camera_film"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10, /datum/material/glass = 10)
	build_path = /obj/item/camera_film
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Экипировка")

/datum/design/earmuffs
	name = "Защитные наушники"
	id = "earmuffs"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/ears/earmuffs
	category = list("initial", "Разное","Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Экипировка")

/datum/design/pipe_painter
	name = "Маркировщик труб"
	id = "pipe_painter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)
	build_path = /obj/item/pipe_painter
	category = list("initial","Инструменты","Рабочие инструменты","Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airlock_painter
	name = "Маркировщик шлюзов"
	id = "airlock_painter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter
	category = list("initial","Инструменты","Рабочие инструменты","Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/airlock_painter/decal
	name = "Красильщик пола"
	id = "decal_painter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter/decal
	category = list("initial","Инструменты","Рабочие инструменты","Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/airlock_painter/decal/tile
	name = "Полокрас"
	id = "tile_sprayer"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter/decal/tile
	category = list("initial","Инструменты","Рабочие инструменты", "Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/emergency_oxygen
	name = "Аварийный кислородный баллон"
	id = "emergency_oxygen"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/tank/internals/emergency_oxygen/empty
	category = list("initial","Разное","Снаряжение","Инженерное снаряжение", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")

/datum/design/emergency_oxygen_engi
	name = "Карманный кислородный баллон"
	id = "emergency_oxygen_engi"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 750)
	build_path = /obj/item/tank/internals/emergency_oxygen/engi/empty
	category = list("hacked","Разное","Снаряжение","Инженерное снаряжение","Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/plasmaman_tank_belt
	name = "Плазма-дыхательный баллон"
	id = "plasmaman_tank_belt"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 800)
	build_path = /obj/item/tank/internals/plasmaman/belt/empty
	category = list("hacked","Разное","Снаряжение","Инженерное снаряжение","Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/generic_gas_tank
	name = "Газовый баллон"
	id = "generic_tank"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/tank/internals/generic
	category = list("initial","Разное","Снаряжение","Инженерное снаряжение","Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/iron
	name = "Железо"
	id = "iron"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/iron
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/glass
	name = "Стекло"
	id = "glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/glass
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/rglass
	name = "Армированное стекло"
	id = "rglass"
	build_type = AUTOLATHE | SMELTER | PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list("initial","Конструкции","Запчасти оборудования")
	maxstack = 50

/datum/design/rods
	name = "Железные стержни"
	id = "rods"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/stack/rods
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/rcd_ammo
	name = "Малый картридж спрессованной материи"
	id = "rcd_ammo"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron = 12000, /datum/material/glass = 8000)
	build_path = /obj/item/rcd_ammo
	category = list("initial","Конструкции","Рабочие инструменты ","Рабочие инструменты   ")
	sub_category = list("Обслуживание монтажных комплексов")

/datum/design/rcd_ammo_large
	name = "Большой картридж спрессованной материи"
	id = "rcd_ammo_large"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 200
	materials = list(/datum/material/iron = 48000, /datum/material/glass = 32000)
	build_path = /obj/item/rcd_ammo/large
	category = list("initial","Конструкции","Рабочие инструменты ","Рабочие инструменты   ")
	sub_category = list("Обслуживание монтажных комплексов")

/datum/design/kitchen_knife
	name = "Кухонный нож"
	id = "kitchen_knife"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/kitchen/knife
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/plastic_knife
	name = "Пластиковый нож"
	id = "plastic_knife"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/plastic = 100)
	build_path = /obj/item/kitchen/knife/plastic
	category = list("initial", "Рабочие инструменты","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/fork
	name = "Вилка"
	id = "fork"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/kitchen/fork
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/plastic_fork
	name = "Пластиковая вилка"
	id = "plastic_fork"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/plastic = 80)
	build_path = /obj/item/kitchen/fork/plastic
	category = list("initial", "Рабочие инструменты", "Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/spoon
	name = "Ложка"
	id = "spoon"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 120)
	build_path = /obj/item/kitchen/spoon
	category = list("initial", "Рабочие инструменты", "Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/plastic_spoon
	name = "Пластиковая ложка"
	id = "plastic_spoon"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/plastic = 120)
	build_path = /obj/item/kitchen/spoon/plastic
	category = list("initial", "Рабочие инструменты", "Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/tray
	name = "Поднос"
	id = "servingtray"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/cafeteria_tray
	name = "Поднос кафетерия"
	id = "foodtray"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray/cafeteria
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/bowl
	name = "Миска"
	id = "bowl"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/bowl
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/drinking_glass
	name = "Стакан"
	id = "drinking_glass"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/shot_glass
	name = "Шот"
	id = "shot_glass"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/shaker
	name = "Шейкер"
	id = "shaker"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/reagent_containers/food/drinks/shaker
	category = list("initial","Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/cultivator
	name = "Тяпка"
	id = "cultivator"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron=50)
	build_path = /obj/item/cultivator
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/plant_analyzer
	name = "Анализатор растений"
	id = "plant_analyzer"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/plant_analyzer
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/shovel
	name = "Лопата"
	id = "shovel"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/shovel/cargo
	id = "shovel_cargo"
	build_type = MECHFAB
	category = list("Шахтёрское оборудование", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")

/datum/design/spade
	name = "Лопаточка"
	id = "spade"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel/spade
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/hatchet
	name = "Топорик"
	id = "hatchet"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/hatchet
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/secateurs
	name = "Секатор"
	id = "secateurs"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/secateurs
	category = list("initial","Разное", "Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/foilhat
	name = "Шапочка из фольги"
	id = "tinfoil_hat"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5500)
	build_path = /obj/item/clothing/head/foilhat
	category = list("hacked", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/blood_filter
	name = "Фильтр крови"
	desc = "Для фильтрации крови и лимфы."
	id = "blood_filter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1500, /datum/material/silver = 500)
	build_path = /obj/item/blood_filter
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/scalpel
	name = "Скальпель"
	desc = "Очень острое лезвие с микронной заточкой."
	id = "scalpel"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000)
	build_path = /obj/item/scalpel
	category = list("initial", "Медицина", "Рабочие инструменты", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/circular_saw
	name = "Циркулярная пила"
	desc = "Для работы с костью при полостных операциях."
	id = "circular_saw"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/circular_saw
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bonesetter
	name = "Костоправ"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	id = "bonesetter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000,  /datum/material/glass = 2500)
	build_path = /obj/item/bonesetter
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/surgicaldrill
	name = "Хирургическая дрель"
	desc = "Можно просверлить с помощью этого что-то. Или пробурить?"
	id = "surgicaldrill"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/surgicaldrill
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/retractor
	name = "Расширитель"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	id = "retractor"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000)
	build_path = /obj/item/retractor
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/cautery
	name = "Прижигатель"
	desc = "Останавливает кровотечения и дезинфецирует рабочую зону после завершения операции."
	id = "cautery"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 750)
	build_path = /obj/item/cautery
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/hemostat
	name = "Зажим"
	desc = "Используется для манипуляций в рабочей области и остановки внутренних кровотечений."
	id = "hemostat"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/hemostat
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/stethoscope
	name = "Стетоскоп"
	desc = "Устаревший медицинский аппарат для прослушивания звуков человеческого тела. Это также заставляет вас выглядеть так, как будто вы знаете, что делаете."
	id = "stethoscope"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/clothing/neck/stethoscope
	category = list("initial", "Медицина", "Рабочие инструменты", "Медицинское снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/beaker
	name = "Химический стакан"
	desc = "Химический стакан, вместимостью до 50 единиц."
	id = "beaker"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/beaker
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE

/datum/design/large_beaker
	name = "Большой химический стакан"
	desc = "Большой химический стакан, вместимостью до 100 единиц."
	id = "large_beaker"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2500)
	build_path = /obj/item/reagent_containers/glass/beaker/large
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE

/datum/design/pillbottle
	name = "Баночка для таблеток"
	desc = "Хранит в себе разноцветные пилюльки и таблетки."
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/plastic = 20, /datum/material/glass = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/beanbag_slug
	name = "12 Калибр: Резиновая пуля"
	id = "beanbag_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	category = list("initial", "Безопасность")

/datum/design/rubbershot
	name = "12 Калибр: Резиновая картечь"
	id = "rubber_shot"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/ammo_casing/shotgun/rubbershot
	category = list("initial", "Безопасность")

/datum/design/c38
	name = "Скорозарядник .38 калибра"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Содержит в себе обычные патроны .38 калибра."
	id = "c38"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10000)
	build_path = /obj/item/ammo_box/c38
	category = list("initial", "Безопасность")

/datum/design/recorder
	name = "Диктофон"
	id = "recorder"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 60, /datum/material/glass = 30)
	build_path = /obj/item/taperecorder/empty
	category = list("initial", "Разное", "Снаряжение СБ")
	sub_category = list("Расследование")

/datum/design/tape
	name = "Магнитная касета"
	id = "tape"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/tape/random
	category = list("initial", "Разное", "Снаряжение СБ")
	sub_category = list("Расследование")

/datum/design/igniter
	name = "Воспламенитель"
	id = "igniter"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 10
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/igniter
	category = list("initial", "Разное", "Инженерное снаряжение","Научное снаряжение")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/condenser
	name = "Конденсатор"
	id = "condenser"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 10
	materials = list(/datum/material/iron=250, /datum/material/glass=300)
	build_path = /obj/item/assembly/igniter/condenser
	category = list("initial", "Разное", "Инженерное снаряжение","Научное снаряжение")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/signaler
	name = "Сигналер"
	id = "signaler"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400, /datum/material/glass = 120)
	build_path = /obj/item/assembly/signaler
	category = list("initial", "Телекомы", "Инженерное снаряжение","Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/radio_headset
	name = "Гарнитура"
	id = "radio_headset"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/radio/headset
	category = list("initial", "Телекомы", "Инженерное снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Связь и навигация")

/datum/design/bounced_radio
	name = "Рация"
	id = "bounced_radio"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/radio/off
	category = list("initial", "Телекомы", "Инженерное снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Связь и навигация")

/datum/design/intercom_frame
	name = "Каркас интеркома"
	id = "intercom_frame"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/wallframe/intercom
	category = list("initial", "Телекомы", "Строительство", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/infrared_emitter
	name = "Инфракрасный излучатель"
	id = "infrared_emitter"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	build_path = /obj/item/assembly/infra
	category = list("initial", "Разное", "Инженерное снаряжение", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/health_sensor
	name = "Датчик жизни"
	desc = "Следит за основными жизненными показателями пользователя, может отправлять сигналы при смерти или критическом состоянии носителя."
	id = "health_sensor"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/health
	category = list("initial", "Медицина", "Медицинское снаряжение", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/timer
	name = "Таймер"
	id = "timer"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/timer
	category = list("initial", "Разное", "Инженерное снаряжение", "Научное снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/voice_analyser
	name = "Анализатор голоса"
	id = "voice_analyser"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/voice
	category = list("initial", "Разное", "Инженерное снаряжение", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/light_tube
	name = "Лампа дневного света"
	id = "light_tube"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/light/tube
	category = list("initial", "Конструкции", "Строительство", "Карго оборудование" ,"Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/light_bulb
	name = "Лампочка"
	id = "light_bulb"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/light/bulb
	category = list("initial", "Конструкции", "Строительство", "Карго оборудование" ,"Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/camera_assembly
	name = "Каркас камеры"
	id = "camera_assembly"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400, /datum/material/glass = 250)
	build_path = /obj/item/wallframe/camera
	category = list("initial", "Конструкции", "Строительство" ,"Карго оборудование" ,"Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/newscaster_frame
	name = "Рама новостника"
	id = "newscaster_frame"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 14000, /datum/material/glass = 8000)
	build_path = /obj/item/wallframe/newscaster
	category = list("initial", "Конструкции", "Строительство", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/syringe
	name = "Шприц"
	desc = "Может содержать 15 единиц."
	id = "syringe"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10, /datum/material/glass = 20)
	build_path = /obj/item/reagent_containers/syringe
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Инъекции")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/dropper
	name = "Пипетка"
	desc = "Пипетка, вместимостью до 5 единиц."
	id = "dropper"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 10, /datum/material/plastic = 30)
	build_path = /obj/item/reagent_containers/dropper
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Инъекции")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/prox_sensor
	name = "Датчик движения"
	id = "prox_sensor"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/prox_sensor
	category = list("initial", "Разное", "Медицинское снаряжение", "Инженерное снаряжение","Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Датчики и Сигнальные устройства")

/datum/design/prox_sensor2	//	Дубль для мехфаба без подкласса
	name = "Датчик движения"
	id = "prox_sensor2"
	build_type = MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/prox_sensor
	category = list("Батареи и прочее")

/datum/design/foam_dart
	name = "Упаковка пенных дротиков"
	desc = "Детям от восьми лет и старше."
	id = "foam_darts"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/ammo_box/foambox
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

//hacked autolathe recipes
/datum/design/flamethrower
	name = "Огнемет"
	id = "flamethrower"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/flamethrower/full
	category = list("hacked", "Безопасность", "Снаряжение СБ")
	sub_category = list("Прочее")

/datum/design/electropack
	name = "Электропак"
	id = "electropack"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2500)
	build_path = /obj/item/electropack
	category = list("hacked", "Инструменты", "Снаряжение СБ")
	sub_category = list("Задержание и сдерживание")

/datum/design/large_welding_tool
	name = "Индустриальный сварочный аппарат"
	id = "large_welding_tool"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 70, /datum/material/glass = 60)
	build_path = /obj/item/weldingtool/largetank
	category = list("hacked", "Инструменты","Рабочие инструменты ")
	sub_category = list("Базовые инструменты")

/datum/design/handcuffs
	name = "Наручники"
	id = "handcuffs"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/restraints/handcuffs
	category = list("hacked", "Безопасность", "Снаряжение СБ")
	sub_category = list("Задержание и сдерживание")

/datum/design/receiver
	name = "Модульный приёмник"
	id = "receiver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/weaponcrafting/receiver
	category = list("hacked", "Безопасность")

/datum/design/shotgun_slug
	name = "12 Калибр: Пулевой"
	desc = "Свинцовая пуля для ружей 12 калибра."
	id = "shotgun_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/ammo_casing/shotgun
	category = list("hacked", "Безопасность")

/datum/design/buckshot_shell
	name = "12 Калибр: Картечь"
	desc = "Крупная картечь 12 калибра."
	id = "buckshot_shell"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/ammo_casing/shotgun/buckshot
	category = list("hacked", "Безопасность")

/datum/design/shotgun_dart
	name = "12 Калибр: Дротик"
	desc = "Дротик для использования в ружьях. Может вводить до 30 единиц любого химического вещества."
	id = "shotgun_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/ammo_casing/shotgun/dart
	category = list("hacked", "Безопасность")

/datum/design/incendiary_slug
	name = "12 Калибр: Зажигательный"
	desc = "При удачном попадании поджигает цель. Немного слабее стандартных пуль."
	id = "incendiary_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/ammo_casing/shotgun/incendiary
	category = list("hacked", "Безопасность")

/datum/design/riot_darts
	name = "Упаковка резиновый пенчиков"
	desc = "Повышенного останавливающего возздействия. Детям от восьми лет и старше."
	id = "riot_darts"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 20000) //Comes with 40 darts
	build_path = /obj/item/ammo_box/foambox/riot
	category = list("hacked", "Безопасность", "Боеприпасы")
	sub_category = list("Прочее")

/datum/design/a357
	name = "Пуля .357 калибра"
	desc = "Обычный патрон .357 калибра. Используется в крупнокалиберных револьверах."
	id = "a357"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 10
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/a357
	category = list("hacked", "Безопасность", "Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/c9mm
	name = "Упаковка 9мм патронов"
	desc = "Обычные патроны калибра 9мм. Используется в пистолетах и пистолет-пулеметах."
	id = "c9mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c9mm
	category = list("hacked", "Безопасность")

/datum/design/c9mm/sec
	id = "c9mm_sec"
	build_type = MECHFAB
	construction_time = 40
	category = list("Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/c9mm_traumatic
	name = "Упаковка травматических 9мм патронов"
	desc = "Боевая пуля в них заменена на резиновую болванку. Практически не наносит урона, однако валит с пары-тройки попаданий."
	id = "c9mm_traumatic"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000,/datum/material/plastic = 5000)
	build_path = /obj/item/ammo_box/c9mm_traumatic
	category = list("Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/c10mm
	name = "Упаковка 10мм патронов"
	desc = "Обычные патроны калибра 10мм. Используется в пистолетах."
	id = "c10mm"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 35000)
	build_path = /obj/item/ammo_box/c10mm
	category = list("hacked", "Безопасность", "Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/c45
	name = "Упаковка патронов .45 калибра"
	desc = "Обычные патроны калибра .45мм. Используется в пистолетах и пистолет-пулеметах."
	id = "c45"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 35000)
	build_path = /obj/item/ammo_box/c45
	category = list("hacked", "Безопасность", "Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/a50ae
	name = "Упаковка патронов калибра .50AE"
	desc = "Обычные патроны калибра 50AE. Используется в пистолете Пустынный Орел."
	id = "a50ae"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 40000)
	build_path = /obj/item/ammo_box/a50ae
	category = list("Боеприпасы")
	sub_category = list("Пистолеты, ПП, Револьверы")

/datum/design/cleaver
	name = "Тесак мясника"
	id = "cleaver"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 18000)
	build_path = /obj/item/kitchen/knife/butcher
	category = list("hacked", "Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/spraycan
	name = "Баллончик с краской"
	id = "spraycan"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/toy/crayon/spraycan
	category = list("initial","Инструменты","Рабочие инструменты", "Инженерное снаряжение" ,"Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/desttagger
	name = "Этикетировщик назначения"
	id = "desttagger"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 250, /datum/material/glass = 125)
	build_path = /obj/item/dest_tagger
	category = list("initial", "Электроника", "Инженерное снаряжение" ,"Карго снаряжение")
	sub_category = list("Маркировщики")

/datum/design/salestagger
	name = "Этикетировщик скидок"
	id = "salestagger"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 700, /datum/material/glass = 200)
	build_path = /obj/item/sales_tagger
	category = list("initial", "Электроника", "Инженерное снаряжение","Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SERVICE

/datum/design/handlabeler
	name = "Этикетировщик"
	desc = "Комбинированный принтер этикеток, аппликатор и съемник - все в одном портативном устройстве. Разработанный, чтобы быть простым в эксплуатации и использовании."
	id = "handlabel"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150, /datum/material/glass = 125)
	build_path = /obj/item/hand_labeler
	category = list("initial", "Электроника", "Фармацевтика", "Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/geiger
	name = "Счётчик гейгера"
	id = "geigercounter"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150, /datum/material/glass = 150)
	build_path = /obj/item/geiger_counter
	category = list("initial", "Инструменты","Рабочие инструменты ", "Рабочие инструменты    ", "Рабочие инструменты  ")
	sub_category = list("Прочее")

/datum/design/turret_control_frame
	name = "Рама контролера турели"
	id = "turret_control"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/wallframe/turret_control
	category = list("initial", "Конструкции", "Строительство", "Оборудование СБ")
	sub_category = list("Настенные конструкции")

/datum/design/conveyor_belt
	name = "Конвейерная лента"
	id = "conveyor_belt"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/stack/conveyor
	category = list("initial", "Конструкции", "Электроника", "Кларк", "Инженерное оборудование" ,"Карго снаряжение")
	sub_category = list("Гусеничные конструкции")
	maxstack = 30
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/conveyor_switch
	name = "Переключатель конвейерной ленты"
	id = "conveyor_switch"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 450, /datum/material/glass = 190)
	build_path = /obj/item/conveyor_switch_construct
	category = list("initial", "Конструкции", "Электроника", "Инженерное оборудование" ,"Карго снаряжение")
	sub_category = list("Гусеничные конструкции")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/laptop
	name = "Ноутбук (пустой)"
	id = "laptop"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/laptop/buildable
	category = list("initial", "Разное", "Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Основа")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/tablet
	name = "Планшет (пустой)"
	id = "tablet"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/tablet
	category = list("initial", "Разное", "Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Основа")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/slime_scanner
	name = "Анализатор слаймов"
	id = "slime_scanner"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 300, /datum/material/glass = 200)
	build_path = /obj/item/slime_scanner
	category = list("initial", "Разное", "Научное снаряжение")
	sub_category = list("Диагностика и мониторинг")

/datum/design/pet_carrier
	name = "Переноска для животных"
	id = "pet_carrier"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 7500, /datum/material/glass = 100)
	build_path = /obj/item/pet_carrier
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Прочее")

/datum/design/miniature_power_cell
	name = "Батарея аварийного питания"
	id = "miniature_power_cell"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 20)
	build_path = /obj/item/stock_parts/cell/emergency_light
	category = list("initial", "Электроника")

/datum/design/package_wrap
	name = "Оберточная бумага"
	desc = "Оберните пакеты этой праздничной бумагой, чтобы сделать подарки."
	id = "packagewrap"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 5
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200)
	build_path = /obj/item/stack/package_wrap
	category = list("initial", "Разное", "Снаряжение", "Прочее")
	maxstack = 30

/datum/design/holodisk
	name = "Голодиск"
	id = "holodisk"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/disk/holodisk
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Прочее")

/datum/design/circuit
	name = "Синяя электронная плитка"
	id = "circuit"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/circuitgreen
	name = "Зелёная электронная плитка"
	id = "circuitgreen"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/green
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/circuitred
	name = "Красная электронная плитка"
	id = "circuitred"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/red
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/price_tagger
	name = "Этикетировщик цен"
	id = "price_tagger"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 500)
	build_path = /obj/item/price_tagger
	category = list("initial", "Разное" ,"Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")

/datum/design/custom_vendor_refill
	name = "Комплект снабжения вендора"
	id = "custom_vendor_refill"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)
	build_path = /obj/item/vending_refill/custom
	category = list("initial", "Разное" ,"Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Прочее")

/datum/design/ducts
	name = "Набор труб"
	desc = "Используются для передачи жидкости на расстояние."
	id = "fluid_ducts"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/stack/ducts
	category = list("initial", "Конструкции", "Фармацевтика", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Хим-фабрика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	maxstack = 50

/datum/design/toygun
	name = "Игрушечный пистолет"
	id = "toygun"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/toy/gun
	category = list("hacked", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/capbox
	name = "Коробка с пистонами"
	id = "capbox"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/toy/ammo/gun
	category = list("hacked", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/toy_balloon
	name = "Воздушный шарик"
	id = "toy_balloon"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 1200)
	build_path = /obj/item/toy/balloon
	category = list("hacked", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/toy_armblade
	name = "Пенопластовая рука-лезвие"
	id = "toy_armblade"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/toy/foamblade
	category = list("hacked", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/plastic_tree
	name = "Пластиковое дерево"
	id = "plastic_trees"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 8000)
	build_path = /obj/item/kirbyplants/fullysynthetic
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/beads
	name = "Пластиковые бусы"
	id = "plastic_necklace"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/clothing/neck/beads
	category = list("initial", "Разное", "Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/plastic_ring
	name = "Упаковка для содовой"
	id = "ring_holder"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 1200)
	build_path = /obj/item/storage/cans
	category = list("initial", "Кухня", "Снаряжение сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/plastic_box
	name = "Пластиковая коробка"
	id = "plastic_box"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 1000)
	build_path = /obj/item/storage/box/plastic
	category = list("initial", "Разное" ,"Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Прочее")

/datum/design/sticky_tape
	name = "Клейкая лента"
	id = "sticky_tape"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/stack/sticky_tape
	category = list("initial", "Разное" ,"Карго снаряжение")
	sub_category = list("Прочее")

/datum/design/sticky_tape/serv
	id = "sticky_tape_serv"
	build_type = MECHFAB
	category = list("Снаряжение сервиса")
	sub_category = list("Розыгрыши")

/datum/design/sticky_tape/surgical
	name = "Хирургическая лента"
	desc = "Используется для сращивания поломаных костей как и костный гель. Не для пранков."
	id = "surgical_tape"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/stack/sticky_tape/surgical
	category = list("initial", "Медицина", "Хирургические инструменты")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/petridish
	name = "Чаша Петри"
	id = "petri_dish"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/petri_dish
	category = list("initial","Разное","Снаряжение","Научное снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/swab
	name = "Стерильная губка"
	id = "swab"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 200)
	build_path = /obj/item/swab
	category = list("initial","Разное","Снаряжение","Научное снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/chisel
	name = "Стамеска"
	id = "chisel"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/chisel
	category = list("initial","Инструменты","Карго снаряжение")
	sub_category = list("Прочее")

/datum/design/control
	name = "Контролер взрывостойкого шлюза"
	id = "blast"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/assembly/control
	category = list("initial","Разное","Строительство", "Медицинское оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Контролеры")

/datum/design/floor_painter
	name = "Маркировщик пола"
	desc = "Используется для покраски полов. Круто?"
	id = "floor_painter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/floor_painter
	category = list("initial","Инструменты","Рабочие инструменты", "Инженерное снаряжение", "Карго снаряжение", "Снаряжение сервиса")
	sub_category = list("Маркировщики")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/cannon_ball
	name = "Пушечное ядро"
	id = "cannon_ball"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 6000)
	build_path = /obj/item/stack/cannonball
	category = list("hacked","Аммуниция")

/datum/design/cannon_ball_exp
	name = "Разрывное пушечное ядро"
	id = "cannon_ball_exp"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 6000, /datum/material/plasma = 2000)
	build_path = /obj/item/stack/cannonball/shellball
	category = list("hacked","Аммуниция")

/datum/design/cannon_ball_big
	name = "Противотанковое пушечное ядро"
	id = "cannon_ball_big"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000, /datum/material/plasma = 6000)
	build_path = /obj/item/stack/cannonball/the_big_one
	category = list("hacked","Аммуниция")

/datum/design/fishing_rod_basic
	name = "Удочка"
	desc = "Ловись рыбка большая и маленькая."
	id = "fishing_rod"
	build_type = AUTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200)
	build_path = /obj/item/fishing_rod
	category = list("initial", "Разное", "Инструменты", "Прочее")
