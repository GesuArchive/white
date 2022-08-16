/datum/design/integrated_circuit
	name = "Интегральная схема"
	desc = "Поместив внутрь батарею, пару компонентов, настроив их и запихнувших все это оболочку, любой может претендовать на звание программиста."
	id = "integrated_circuit"
	build_path = /obj/item/integrated_circuit
	build_type = IMPRINTER | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Ядро", "Интегральные схемы")
	sub_category = list("Ядро")
	materials = list(/datum/material/glass = 1000, /datum/material/iron = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/circuit_multitool
	name = "Схемотул"
	desc = "Мультитул для схем. Используется для отметки объектов, которые затем могут быть загружены в компоненты, нажав кнопку загрузки на порту. \
	В остальном действует как обычный мультитул. Используйте в руке, чтобы очистить отмеченный объект, чтобы вы могли отметить другой объект."
	id = "circuit_multitool"
	build_path = /obj/item/multitool/circuit
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Ядро", "Интегральные схемы")
	sub_category = list("Ядро")
	materials = list(/datum/material/glass = 1000, /datum/material/iron = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/usb_cable
	name = "USB кабель"
	desc = "Кабель, который может подключать интегральные схемы к чему-либо с USB-портом, например к компьютерам и машинам."
	id = "usb_cable"
	build_path = /obj/item/usb_cable
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Ядро", "Интегральные схемы")
	sub_category = list("Ядро")
	// Yes, it would make sense to make them take plastic, but then less people would make them, and I think they're cool
	materials = list(/datum/material/iron = 2500)
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/component
	name = "Component ( NULL ENTRY )"
	desc = "Компонент, входящий в интегральную схему."
	build_type = IMPRINTER | COMPONENT_PRINTER | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
	category = list("Схемотехника", "Компоненты", "Интегральные схемы")
	sub_category = list("Компоненты")

/datum/design/component/New()
	. = ..()
	if(build_path)
		var/obj/item/circuit_component/component_path = build_path
		desc = initial(component_path.desc)

/datum/design/component/arithmetic
	name = "Арифметика"
	id = "comp_arithmetic"
	build_path = /obj/item/circuit_component/arithmetic

/datum/design/component/clock
	name = "Тактовый генератор"
	id = "comp_clock"
	build_path = /obj/item/circuit_component/clock

/datum/design/component/comparison
	name = "Сравнение"
	id = "comp_comparison"
	build_path = /obj/item/circuit_component/compare/comparison

/datum/design/component/logic
	name = "Логика"
	id = "comp_logic"
	build_path = /obj/item/circuit_component/compare/logic

/datum/design/component/delay
	name = "Задержка"
	id = "comp_delay"
	build_path = /obj/item/circuit_component/delay

/datum/design/component/format
	name = "Format List Component"
	id = "comp_format"
	build_path = /obj/item/circuit_component/format

/datum/design/component/format_assoc
	name = "Format Associative List Component"
	id = "comp_format_assoc"
	build_path = /obj/item/circuit_component/format/assoc

/datum/design/component/index
	name = "Индексатор"
	id = "comp_index"
	build_path = /obj/item/circuit_component/index

/datum/design/component/index_assoc
	name = "Index Associative List Component"
	id = "comp_index_assoc"
	build_path = /obj/item/circuit_component/index/assoc_string

/datum/design/component/length
	name = "Длина"
	id = "comp_length"
	build_path = /obj/item/circuit_component/length

/datum/design/component/light
	name = "Светодиод"
	id = "comp_light"
	build_path = /obj/item/circuit_component/light

/datum/design/component/not
	name = "Не"
	id = "comp_not"
	build_path = /obj/item/circuit_component/not

/datum/design/component/random
	name = "Генератор случайных чисел"
	id = "comp_random"
	build_path = /obj/item/circuit_component/random

/datum/design/component/binary_conversion
	name = "Binary Conversion Component"
	id = "comp_binary_convert"
	build_path = /obj/item/circuit_component/binary_conversion

/datum/design/component/decimal_conversion
	name = "Decimal Conversion Component"
	id = "comp_decimal_convert"
	build_path = /obj/item/circuit_component/decimal_conversion

/datum/design/component/species
	name = "Генетический сканер"
	id = "comp_species"
	build_path = /obj/item/circuit_component/species

/datum/design/component/speech
	name = "Динамик"
	id = "comp_speech"
	build_path = /obj/item/circuit_component/speech

/datum/design/component/laserpointer
	name = "Лазерная указка"
	id = "comp_laserpointer"
	build_path = /obj/item/circuit_component/laserpointer

/datum/design/component/timepiece
	name = "Timepiece Component"
	id = "comp_timepiece"
	build_path = /obj/item/circuit_component/timepiece

/datum/design/component/tostring
	name = "В строку"
	id = "comp_tostring"
	build_path = /obj/item/circuit_component/tostring

/datum/design/component/tonumber
	name = "В цифру"
	id = "comp_tonumber"
	build_path = /obj/item/circuit_component/tonumber

/datum/design/component/typecheck
	name = "Проверка типа"
	id = "comp_typecheck"
	build_path = /obj/item/circuit_component/compare/typecheck

/datum/design/component/concat
	name = "Объединение"
	id = "comp_concat"
	build_path = /obj/item/circuit_component/concat

/datum/design/component/textcase
	name = "Текстовый регистр"
	id = "comp_textcase"
	build_path = /obj/item/circuit_component/textcase

/datum/design/component/hear
	name = "Микрофон"
	id = "comp_hear"
	build_path = /obj/item/circuit_component/hear

/datum/design/component/contains
	name = "Поиск слова"
	id = "comp_string_contains"
	build_path = /obj/item/circuit_component/compare/contains

/datum/design/component/self
	name = "Оболочка (возврат)"
	id = "comp_self"
	build_path = /obj/item/circuit_component/self

/datum/design/component/radio
	name = "Радио"
	id = "comp_radio"
	build_path = /obj/item/circuit_component/radio

/datum/design/component/gps
	name = "GPS маячок"
	id = "comp_gps"
	build_path = /obj/item/circuit_component/gps

/datum/design/component/direction
	name = "Получить направление"
	id = "comp_direction"
	build_path = /obj/item/circuit_component/direction

/datum/design/component/reagentscanner
	name = "Reagents Scanner"
	id = "comp_reagents"
	build_path = /obj/item/circuit_component/reagentscanner

/datum/design/component/health
	name = "Мед сканер"
	id = "comp_health"
	build_path = /obj/item/circuit_component/health

/datum/design/component/matscanner
	name = "Material Scanner"
	id = "comp_matscanner"
	build_path = /obj/item/circuit_component/matscanner

/datum/design/component/split
	name = "Разделитель"
	id = "comp_split"
	build_path = /obj/item/circuit_component/split

/datum/design/component/pull
	name = "Захват"
	id = "comp_pull"
	build_path = /obj/item/circuit_component/pull

/datum/design/component/soundemitter
	name = "Пищалка"	// С любовью для Шрум-Шрума
	id = "comp_soundemitter"
	build_path = /obj/item/circuit_component/soundemitter

/datum/design/component/mmi
	name = "MMI"
	id = "comp_mmi"
	build_path = /obj/item/circuit_component/mmi

/datum/design/component/router
	name = "Маршрутизатор"
	id = "comp_router"
	build_path = /obj/item/circuit_component/router

/datum/design/component/multiplexer
	name = "Мультиплексор"
	id = "comp_multiplexer"
	build_path = /obj/item/circuit_component/router/multiplexer

/datum/design/component/get_column
	name = "Получить столбец"
	id = "comp_get_column"
	build_path = /obj/item/circuit_component/get_column

/datum/design/component/index_table
	name = "Индексный поиск"
	id = "comp_index_table"
	build_path = /obj/item/circuit_component/index_table

/datum/design/component/concat_list
	name = "Объединить список"
	id = "comp_concat_list"
	build_path = /obj/item/circuit_component/concat_list

/datum/design/component/list_add
	name = "List Add"
	id = "comp_list_add"
	build_path = /obj/item/circuit_component/variable/list/listadd

/datum/design/component/list_remove
	name = "List Remove"
	id = "comp_list_remove"
	build_path = /obj/item/circuit_component/variable/list/listremove

/datum/design/component/list_clear
	name = "List Clear"
	id = "comp_list_clear"
	build_path = /obj/item/circuit_component/variable/list/listclear

/datum/design/component/element_find
	name = "Element Find"
	id = "comp_element_find"
	build_path = /obj/item/circuit_component/listin

/datum/design/component/select_query
	name = "Селектор"
	id = "comp_select_query"
	build_path = /obj/item/circuit_component/select

/datum/design/component/pathfind
	name = "Навигатор"
	id = "comp_pathfind"
	build_path = /obj/item/circuit_component/pathfind

/datum/design/component/tempsensor
	name = "Датчик Температуры"
	id = "comp_tempsensor"
	build_path = /obj/item/circuit_component/tempsensor

/datum/design/component/pressuresensor
	name = "Датчик Давления"
	id = "comp_pressuresensor"
	build_path = /obj/item/circuit_component/pressuresensor

/datum/design/component/module
	name = "Модуль"
	id = "comp_module"
	build_path = /obj/item/circuit_component/module

/datum/design/component/ntnet_receive
	name = "Приемник NTNet"
	id = "comp_ntnet_receive"
	build_path = /obj/item/circuit_component/ntnet_receive

/datum/design/component/ntnet_send
	name = "Передатчик NTNet"
	id = "comp_ntnet_send"
	build_path = /obj/item/circuit_component/ntnet_send

/datum/design/component/list_literal
	name = "Текстовый список"
	id = "comp_list_literal"
	build_path = /obj/item/circuit_component/list_literal

/datum/design/component/list_assoc_literal
	name = "Associative List Literal"
	id = "comp_list_assoc_literal"
	build_path = /obj/item/circuit_component/assoc_literal

/datum/design/component/typecast
	name = "Классификация"
	id = "comp_typecast"
	build_path = /obj/item/circuit_component/typecast

/datum/design/component/pinpointer
	name = "Proximity Pinpointer Component"
	id = "comp_pinpointer"
	build_path = /obj/item/circuit_component/pinpointer

/datum/design/component/bci
	category = list("Схемотехника", "BCI Components", "Интегральные схемы")
	sub_category = list("Интерфейс Человек-Машина (ИЧМ)")

/datum/design/component/bci/bci_action
	name = "ИЧМ активация"
	id = "comp_bci_action"
	build_path = /obj/item/circuit_component/bci_action

/datum/design/component/bci/object_overlay
	name = "Оверлей"
	id = "comp_object_overlay"
	build_path = /obj/item/circuit_component/object_overlay

/datum/design/component/bci/bar_overlay
	name = "Оверлей полосы состояния"
	id = "comp_bar_overlay"
	build_path = /obj/item/circuit_component/object_overlay/bar

/datum/design/component/bci/vox
	name = "VOX Announcement Component"
	id = "comp_vox"
	build_path = /obj/item/circuit_component/vox

/datum/design/component/bci/thought_listener
	name = "Thought Listener Component"
	id = "comp_thought_listener"
	build_path = /obj/item/circuit_component/thought_listener

/datum/design/component/bci/target_intercept
	name = "ИЧМ целеуказатель"
	id = "comp_target_intercept"
	build_path = /obj/item/circuit_component/target_intercept

/datum/design/component/bci/counter_overlay
	name = "Оверлей счетчика"
	id = "comp_counter_overlay"
	build_path = /obj/item/circuit_component/counter_overlay

/datum/design/component/foreach
	name = "For Each Component"
	id = "comp_foreach"
	build_path = /obj/item/circuit_component/foreach

/datum/design/component/filter_list
	name = "Filter List Component"
	id = "comp_filter_list"
	build_path = /obj/item/circuit_component/filter_list

/datum/design/component/mod_action
	name = "MOD Action Component"
	id = "comp_mod_action"
	build_path = /obj/item/circuit_component/equipment_action/mod

/datum/design/component/id_getter
	name = "ID Getter Component"
	id = "comp_id_getter"
	build_path = /obj/item/circuit_component/id_getter

/datum/design/component/id_info_reader
	name = "ID Info Reader Component"
	id = "comp_id_info_reader"
	build_path = /obj/item/circuit_component/id_info_reader

/datum/design/component/id_access_reader
	name = "ID Access Reader Component"
	id = "comp_id_access_reader"
	build_path = /obj/item/circuit_component/id_access_reader

/datum/design/component/setter_trigger
	name = "Set Variable Trigger"
	id = "comp_set_variable_trigger"
	build_path = /obj/item/circuit_component/variable/setter/trigger

/datum/design/component/view_sensor
	name = "View Sensor Component"
	id = "comp_view_sensor"
	build_path = /obj/item/circuit_component/view_sensor

/datum/design/component/access_checker
	name = "Access Checker Component"
	id = "comp_access_checker"
	build_path = /obj/item/circuit_component/compare/access

/datum/design/compact_remote_shell
	name = "Пульт"
	desc = "Портативная оболочка с одной большой кнопкой. Используется для приема по удаленной связи входных данных от оболочки. <b>Используйте оболочку в руке</b>, чтобы отправить выходной сигнал."
	id = "compact_remote_shell"
	build_path = /obj/item/compact_remote
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 5000)
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/controller_shell
	name = "Контроллер"
	desc = "Портативная оболочка с несколькими кнопками. Используется для приема входных данных от оболочки контроллера. <b>Используйте оболочку в руке</b>, чтобы запустить выходной сигнал. <b>Alt+клик</b> для получения альтернативного сигнала. <b>ПКМ</b> для получения дополнительного сигнала."
	id = "controller_shell"
	build_path = /obj/item/controller
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 7000)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/scanner_shell
	name = "Сканер"
	desc = "Оболочка портативного сканера, который может сканировать объекты для получения входных данных."
	id = "scanner_shell"
	build_path = /obj/item/wiremod_scanner
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 7000)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/gun_shell
	name = "Оружие"
	desc = "Оболочка в виде пистолета способного вести огонь сканирующими лучами. Используется для приема входных данных, от объектов пораженных \"выстрелами\" из оружия. Работает на паразитном питании от подключенной цепи."
	id = "gun_shell"
	build_path = /obj/item/gun/energy/wiremod_gun
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 10000, /datum/material/plasma = 100)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/bot_shell
	name = "Бот"
	desc = "Неподвижная оболочка, которая хранит другие компоненты. Имеет USB-порт для подключения к компьютерам и машинам. Срабатывает, когда кто-то взаимодействует с ботом."
	id = "bot_shell"
	build_path = /obj/item/shell/bot
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 10000)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/money_bot_shell
	name = "Денежный бот"
	desc = "Неподвижная оболочка, похожая на обычную оболочку бота, но принимающая денежные вводы и также способная выдавать деньги. Деньги берутся из внутреннего хранилища денег."
	id = "money_bot_shell"
	build_path = /obj/item/shell/money_bot
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 10000, /datum/material/gold = 50)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/drone_shell
	name = "Дрон"
	desc = "Оболочка, способная к самостоятельному передвижению. Внутренний контролер используется для отправки выходных сигналов движения на оболочку дрона"
	id = "drone_shell"
	build_path = /obj/item/shell/drone
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	materials = list(
		/datum/material/glass = 2000,
		/datum/material/iron = 11000,
		/datum/material/gold = 500,
	)
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/server_shell
	name = "Сервер"
	desc = "Очень большая оболочка, которую можно перемещать только после откручивания от пола. Совместима сбольшинством компонентов."
	id = "server_shell"
	materials = list(
		/datum/material/glass = 5000,
		/datum/material/iron = 15000,
		/datum/material/gold = 1500,
	)
	build_path = /obj/item/shell/server
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/airlock_shell
	name = "Шлюз"
	desc = "Оболочка шлюза с схемотехническим интерфейсом, которую нельзя перемещать в собранном виде."
	id = "door_shell"
	materials = list(
		/datum/material/glass = 5000,
		/datum/material/iron = 15000,
	)
	build_path = /obj/item/shell/airlock
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/dispenser_shell
	name = "Dispenser Shell"
	desc = "A dispenser shell that can dispense items."
	id = "dispenser_shell"
	materials = list(
		/datum/material/glass = 5000,
		/datum/material/iron = 15000,
	)
	build_path = /obj/item/shell/dispenser
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	category = list("Схемотехника", "Оболочки")

/datum/design/bci_shell
	name = "Интерфейс человек-компьютер (ИЧМ)"
	desc = "Имплантат, который может быть помещен в голову пользователя для отправки управляющих сигналов."
	id = "bci_shell"
	materials = list(
		/datum/material/glass = 2000,
		/datum/material/iron = 8000,
	)
	build_path = /obj/item/shell/bci
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/scanner_gate_shell
	name = "Сканирующая арка"
	desc = "Оболочка арки сканера, которая выполняет сканирование людей, проходящих через нее."
	id = "scanner_gate_shell"
	materials = list(
		/datum/material/glass = 4000,
		/datum/material/iron = 12000,
	)
	build_path = /obj/item/shell/scanner_gate
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Оболочки", "Интегральные схемы")
	sub_category = list("Оболочки")

/datum/design/board/bci_implanter
	name = "Камера имплантации ИЧМ"
	desc = "Машина, которая после помещения внутрь интерфейса человек-компьютер (ИЧМ) имплантирует его в голову пользователя. В случае если в машину на момент операции не будет помещен ИЧМ для имплантации, то все интерфейсы человек-компьютер, которые у них установлены в данный момент будут удалены."
	id = "bci_implanter"
	build_path = /obj/item/circuitboard/machine/bci_implanter
	build_type = IMPRINTER | COMPONENT_PRINTER | MECHFAB
	construction_time = 40
	category = list("Схемотехника", "Ядро", "Интегральные схемы")
	sub_category = list("Машины")

/datum/design/assembly_shell
	name = "Assembly Shell"
	desc = "An assembly shell that can be attached to wires and other assemblies."
	id = "assembly_shell"
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 5000)
	build_path = /obj/item/assembly/wiremod
	build_type = PROTOLATHE | COMPONENT_PRINTER | MECHFAB
	category = list("Схемотехника", "Оболочки")
