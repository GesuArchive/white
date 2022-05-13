////////////////////////////////////////
///////////Computer Parts///////////////
////////////////////////////////////////

/datum/design/disk/normal
	name = "Привод жесткого диска"
	desc = "Небольшой жесткий диск для использования в базовых компьютерах, где требуется энергоэффективность."
	id = "hdd_basic"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400, /datum/material/glass = 100)
	build_path = /obj/item/computer_hardware/hard_drive
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/disk/advanced
	name = "Усовершенствованный привод жёсткого диска"
	desc = "Гибридный жёсткий диск для использования в компьютерах более высокого класса, где требуется баланс между энергоэффективностью и ёмкостью."
	id = "hdd_advanced"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/disk/super
	name = "Суперпривод жёсткого диска"
	desc = "Жёсткий диск большой емкости, используемый для кластерного хранения, где ёмкость важнее энергоэффективности."
	id = "hdd_super"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1600, /datum/material/glass = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/disk/cluster
	name = "Кластерный привод жёсткого диска"
	desc = "Большой кластер хранения, состоящий из нескольких жёстких дисков для использования в выделенных системах хранения."
	id = "hdd_cluster"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3200, /datum/material/glass = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/disk/small
	name = "Твердотельный накопитель"
	desc = "Эффективный твердотельный накопитель для портативных устройств."
	id = "ssd_small"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/disk/micro
	name = "Микротвердотельный накопитель"
	desc = "Высокоэффективный SSD-чип для портативных устройств."
	id = "ssd_micro"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 400, /datum/material/glass = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Жесткие диски")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// Network cards
/datum/design/netcard/basic
	name = "Сетевая карта"
	desc = "Базовая беспроводная сетевая карта для использования со стандартными частотами NTNet."
	id = "netcard_basic"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 250, /datum/material/glass = 100)
	build_path = /obj/item/computer_hardware/network_card
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Сетевые карты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/netcard/advanced
	name = "Продвинутая сетевая карта"
	desc = "Продвинутая сетевая карта для использования со стандартными частотами NTNet. Её передатчик достаточно силен, чтобы подключиться даже за пределами станции."
	id = "netcard_advanced"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 200)
	build_path = /obj/item/computer_hardware/network_card/advanced
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Сетевые карты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/netcard/wired
	name = "Проводная сетевая карта"
	desc = "Продвинутая сетевая карта для использования со стандартными частотами NTNet. Поддерживает исключительно проводное соединение."
	id = "netcard_wired"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 400)
	build_path = /obj/item/computer_hardware/network_card/wired
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Сетевые карты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// Data disks
/datum/design/portabledrive/basic
	name = "Диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных."
	id = "portadrive_basic"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 800)
	build_path = /obj/item/computer_hardware/hard_drive/portable
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
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced
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
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
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

// Intellicard slot
/datum/design/aislot
	name = "Слот Интелкарты ИИ"
	desc = "Модуль, позволяющий этому компьютеру взаимодействовать с наиболее распространенными модулями Интелкарт. Необходимо для правильной работы некоторых программ."
	id = "aislot"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600)
	build_path = /obj/item/computer_hardware/ai_slot
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Слоты карт")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// Mini printer
/datum/design/miniprinter
	name = "Минипринтер"
	desc = "Маленький принтер с модулем переработки бумаги."
	id = "miniprinter"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600)
	build_path = /obj/item/computer_hardware/printer/mini
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Утилитарные модули")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

// APC Link
/datum/design/apc_link
	name = "Модуль паразитного питания"
	desc = "Устройство, которое заряжает подключенное устройство по беспроводной сети от ближайшего АЦП."
	id = "APClink"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/computer_hardware/recharger/apc_recharger
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Питание и батареи")
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

// Processor unit
/datum/design/cpu
	name = "Плата процессора"
	desc = "Стандартная плата центрального процессора, используемая в большинстве компьютеров. Она может запускать до трёх программ одновременно."
	id = "cpu_normal"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 1600)
	build_path = /obj/item/computer_hardware/processor_unit
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Процессоры")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/cpu/small
	name = "Микропроцессор"
	desc = "Миниатюрный процессор, используемый в портативных устройствах. Он может запускать до двух программ одновременно."
	id = "cpu_small"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 800)
	build_path = /obj/item/computer_hardware/processor_unit/small
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Процессоры")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/cpu/photonic
	name = "Плата фотонного процессора"
	desc = "Усовершенствованная экспериментальная плата центрального процесса, в которой вместо обычных схем используется фотонное ядро. Она может запускать до пяти программ одновременно, однако потребляет много энергии."
	id = "pcpu_normal"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 6400, /datum/material/gold = 2000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Процессоры")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/cpu/photonic/small
	name = "Фотонный микропроцессор"
	desc = "Усовершенствованный миниатюрный процессор для использования в портативных устройствах. Он использует фотонное ядро вместо обычных схем. Он может запускать до трёх программ одновременно."
	id = "pcpu_small"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 3200, /datum/material/gold = 1000)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Процессоры")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/sensorpackage
	name = "Сенсорный пакет"
	desc = "Интегрированный пакет датчиков, позволяющий компьютеру снимать показания с окружающей среды. Требуется некоторыми программами."
	id = "sensorpackage"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200, /datum/material/glass = 100, /datum/material/gold = 50, /datum/material/silver = 50)
	build_path = /obj/item/computer_hardware/sensorpackage
	category = list("Компьютерные запчасти", "Персональные компьютеры")
	sub_category = list("Утилитарные модули")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
