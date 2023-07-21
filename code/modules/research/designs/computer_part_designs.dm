////////////////////////////////////////
///////////Computer Parts///////////////
////////////////////////////////////////

// Data disks
/datum/design/portabledrive/basic
	name = "Диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных."
	id = "portadrive_basic"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 800)
	build_path = /obj/item/computer_disk
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Внешние накопители")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/portabledrive/advanced
	name = "Продвинутый диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных."
	id = "portadrive_advanced"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 1600)
	build_path = /obj/item/computer_disk/advanced
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Внешние накопители")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/portabledrive/super
	name = "Супер диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных."
	id = "portadrive_super"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 3200)
	build_path = /obj/item/computer_disk/super
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Внешние накопители")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/portabledrive/ultra
	name = "Ультра диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных. Вмещает до 256 ГБ данных."
	id = "portadrive_ultra"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 4800)
	build_path = /obj/item/computer_disk/ultra
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Внешние накопители")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// Card slot
/datum/design/cardslot
	name = "Слот ID-карты"
	desc = "Модуль, позволяющий этому компьютеру считывать или записывать данные на идентификационные карты. Необходимо для правильной работы некоторых программ."
	id = "cardslot"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600)
	build_path = /obj/item/computer_hardware/card_slot
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Слоты карт")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// Batteries
/datum/design/battery/controller
	name = "Контроллер батареи"
	desc = "Контроллер заряда для стандартных ячеек питания, используемых во всех типах модульных компьютеров."
	id = "bat_control"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400)
	build_path = /obj/item/computer_hardware/battery
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/battery/normal
	name = "Стандартная батарея"
	desc = "Стандартный элемент питания, обычно встречающийся в портативных микрокомпьютерах высокого класса или ноутбуках младших моделей."
	id = "bat_normal"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400)
	build_path = /obj/item/stock_parts/cell/computer
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/battery/advanced
	name = "Продвинутая батарея"
	desc = "Продвинутая батарея, часто используемая в большинстве ноутбуков. Она слишком велика для установки в устройства меньшего размера."
	id = "bat_advanced"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 800)
	build_path = /obj/item/stock_parts/cell/computer/advanced
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/battery/super
	name = "Супер баттарея"
	desc = "Продвинутая батарея, часто используемая в ноутбуках высокого класса"
	id = "bat_super"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1600)
	build_path = /obj/item/stock_parts/cell/computer/super
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/battery/nano
	name = "Нано батарея"
	desc = "Крошечная батарея, обычно встречающаяся в портативных микрокомпьютерах младших моделей."
	id = "bat_nano"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/stock_parts/cell/computer/nano
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/battery/micro
	name = "Микро батарея"
	desc = "Маленькая батарея, обычно используемая в большинстве портативных микрокомпьютеров."
	id = "bat_micro"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400)
	build_path = /obj/item/stock_parts/cell/computer/micro
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
