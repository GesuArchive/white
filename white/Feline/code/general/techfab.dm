//Фабрикаторы

/**
 * Для корректной работы у /datum/design/предмет должен быть флаг build_type = MECHFAB (можно совмещать с другими)
 * У фабрикатора в отличии от протолата по другому задается время производства: construction_time = 40 равняется 4 секундам с деталями Т1 и 1 секунде с деталями Т4
 * Так же должен быть проставлен category = list() в соответствии с пунктами фабрикатора. Если такого пункта нет - отображатся он там не будет
 * Флагов отделов у фабрикатора нет, поэтому все пункты в разных фабрикаторах должны быть уникальными или будет дубликация (если это и не есть цель)
 * Чтобы этого избежать можно добавлять пробелы, например "Рабочие инструменты" и "Рабочие инструменты ", но лучше этим не злоупотреблять как я...
 * Для подкласса необходимо проставить в датумах sub_category = list() если этого не сделать, то отображение будет в виде общего списка с названием "Снаряжение"
 * Для создание новых подклассов объявлять их не нужно, достаточно лишь вписать новое значение в датум предмета, после чего он сгруппирует их со схожими.
 * Порядок отображения подклассов зависит от порядка исследования в нодах, стартовые можно менять смещая их относительно друг друга.
 */

//	Медицинский фабрикатор

/obj/machinery/mecha_part_fabricator/med
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "медицинский фабрикатор"
	desc = "Используется для создания медицинского оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/med
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Рабочие инструменты    ",		// "Базовые инструменты", "Прочее"
		"Хирургические инструменты",	// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Прочее"
		"Медицинское снаряжение",		// "Диагностика и мониторинг","Экипировка", "Прочее", "Датчики и Сигнальные устройства"
		"Фармацевтика",					// "Химическая посуда", "Инъекции", "Хим-фабрика", "Прочее"
		"Кибернетика",					// "Базовые кибернетические органы", "Базовые протезы", "Продвинутые протезы", "Стандартные кибернетические органы", "Продвинутые кибернетические органы", "Сенсорика"
		"Импланты",						// "Кибер Импланты", "Микро Импланты", "Дополненая реальность"
		"Медицинское оборудование",		// "Програмное обеспечение", "Терморегуляция", "Химпроизводство", "Автохирургия", "Реанимация и хирургия", "Биоманипулирование", "Прочее"
		"Гранаты",						//
		"Прочее"						//
	)

/obj/item/circuitboard/machine/mechfab/med
	name = "плата медицинского фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/mecha_part_fabricator/med

/obj/machinery/mecha_part_fabricator/med/Initialize(mapload)
	. = ..()
	add_overlay("med")

/obj/machinery/mecha_part_fabricator/med/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Инженерный фабрикатор

/obj/machinery/mecha_part_fabricator/engi
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "инженерный фабрикатор"
	desc = "Используется для создания инженерного оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/engi
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Рабочие инструменты ",			// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Монтажные комплексы", "Обслуживание монтажных комплексов", "Прочее"
		"Инженерное снаряжение",		// "Огнетушители и газовые баллоны", "Экипировка", "Маркировщики", "Датчики и Сигнальные устройства", "Связь и навигация", "Диагностика и мониторинг"
		"Строительство",				// "Контролеры", "Настенные конструкции", "Напольные конструкции"
		"Инженерное оборудование",		//	"Терморегуляция", "Портативные генераторы", "Консоли", "Производство", "АТМОС", "Энергоснабжение", "ТЭГ", "Газовая турбина", "Телепортация", "Химпроизводство", "Сингулярность, тесла и суперматерия", "Прочее",
		"Детали машин",					//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
		"Детали машин - х10",			//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
		"Подпространственная связь",	//	"Радиорелейные платы", "Радиорелейные детали"
		"Энергетические разработки",	//
		"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
		"Спейсподы и шаттлостроение",	//	"Производство", "Броня", "Системы вооружения", "Добыча полезных ископаемых", "Вспомогательные системы", "Шаттлостроение"
		"Персональные компьютеры",		//	"Основа", "Жесткие диски", "Сетевые карты", "Внешние накопители", "Слоты карт", "Утилитарные модули", "Питание и батареи", "Процессоры"
		"Интегральные схемы",			//	"Ядро", "Компоненты", "Оболочки"
		"Прочее"						//
	)

/obj/item/circuitboard/machine/mechfab/engi
	name = "плата инженерного фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/mecha_part_fabricator/engi

/obj/machinery/mecha_part_fabricator/engi/Initialize(mapload)
	. = ..()
	add_overlay("engi")

/obj/machinery/mecha_part_fabricator/engi/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Научный фабрикатор

/obj/machinery/mecha_part_fabricator/sci
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "научный фабрикатор"
	desc = "Используется для создания научного оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/sci
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Хирургические инструменты",	// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Прочее"
		"Рабочие инструменты  ",		// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Монтажные комплексы", "Обслуживание монтажных комплексов", "Прочее"
		"Научное снаряжение",			// "Огнетушители и газовые баллоны", "Экипировка", "Маркировщики", "Датчики и Сигнальные устройства", "Связь и навигация", "Диагностика и мониторинг"
		"Научное оборудование",			//	"Терморегуляция", "Портативные генераторы", "Консоли", "Производство", "АТМОС", "Энергоснабжение", "ТЭГ", "Газовая турбина", "Телепортация", "Химпроизводство", "Сингулярность, тесла и суперматерия", "Прочее",
		"Детали машин",					//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
		"Детали машин - х10",			//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
		"Подпространственная связь",	//	"Радиорелейные платы", "Радиорелейные детали"
		"Энергетические разработки",	//
		"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
		"Спейсподы и шаттлостроение",	//	"Производство", "Броня", "Системы вооружения", "Добыча полезных ископаемых", "Вспомогательные системы", "Шаттлостроение"
		"Персональные компьютеры",		//	"Основа", "Жесткие диски", "Сетевые карты", "Внешние накопители", "Слоты карт", "Утилитарные модули", "Питание и батареи", "Процессоры"
		"Интегральные схемы",			//	"Ядро", "Компоненты", "Оболочки"
		"Прочее"						//
	)

/obj/item/circuitboard/machine/mechfab/sci
	name = "плата научного фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mecha_part_fabricator/sci

/obj/machinery/mecha_part_fabricator/sci/Initialize(mapload)
	. = ..()
	add_overlay("sci")

/obj/machinery/mecha_part_fabricator/sci/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Карго фабрикатор

/obj/machinery/mecha_part_fabricator/cargo
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "карго фабрикатор"
	desc = "Используется для создания карго оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/cargo
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Рабочие инструменты   ",		// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Монтажные комплексы", "Обслуживание монтажных комплексов", "Прочее"
		"Карго снаряжение",				// "Огнетушители и газовые баллоны", "Экипировка", "Маркировщики", "Датчики и Сигнальные устройства", "Связь и навигация", "Диагностика и мониторинг"
		"Карго оборудование",			//	"Терморегуляция", "Портативные генераторы", "Консоли", "Производство", "АТМОС", "Энергоснабжение", "ТЭГ", "Газовая турбина", "Телепортация", "Химпроизводство", "Сингулярность, тесла и суперматерия", "Прочее",
		"Энергетические разработки",	//
		"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
		"Спейсподы и шаттлостроение",	//	"Производство", "Броня", "Системы вооружения", "Добыча полезных ископаемых", "Вспомогательные системы", "Шаттлостроение"
		"Прочее"						//
	)

/obj/item/circuitboard/machine/mechfab/cargo
	name = "плата карго фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mecha_part_fabricator/cargo

/obj/machinery/mecha_part_fabricator/cargo/Initialize()
	. = ..()
	add_overlay("cargo")

/obj/machinery/mecha_part_fabricator/cargo/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	СБ фабрикатор

/obj/machinery/mecha_part_fabricator/sb
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "СБ фабрикатор"
	desc = "Используется для создания медицинского оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/sb
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Рабочие инструменты    ",		// "Базовые инструменты", "Прочее"
		"Снаряжение СБ",				// "Диагностика и мониторинг","Экипировка", "Прочее", "Датчики и Сигнальные устройства", "Фортификация и блокировка", "Связь и навигация", "Огнетушители и газовые баллоны", "Электроника", "Микро Импланты", "Щиты и бронепластины"
		"Оборудование СБ",				//
		"Боеприпасы",					// "Револьвер .38 калибра", Ружья: 12 калибра", "Пистолеты, ПП, Револьверы","Прочее"
		"Оружейное дело",				// "Бойки", "Модернизация энергооружия"
		"Гранаты",						//
		"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
		"Прочее"						//
		)

/obj/item/circuitboard/machine/mechfab/sb
	name = "плата фабрикатора СБ"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/mecha_part_fabricator/sb

/obj/machinery/mecha_part_fabricator/sb/Initialize(mapload)
	. = ..()
	add_overlay("sb")

/obj/machinery/mecha_part_fabricator/sb/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Сервисный фабрикатор

/obj/machinery/mecha_part_fabricator/service
	icon = 'white/Feline/icons/techfab.dmi'
	icon_state = "fab-idle"
	name = "сервисный фабрикатор"
	desc = "Используется для создания сервисного оборудования."
	circuit = /obj/item/circuitboard/machine/mechfab/service
	drop_zone = FALSE
	part_sets = list(					// Подклассы:
		"Рабочие инструменты     ",		// "Базовые инструменты", "Прочее"
		"Снаряжение сервиса",			// "Ботаника", "Розыгрыши", "Уборка", "Экипировка", "Прочее", "Датчики и Сигнальные устройства"
		"Оборудование сервиса",			//
		"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
		"Прочее"						//
		)

/obj/item/circuitboard/machine/mechfab/service
	name = "плата фабрикатора сервиса"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/mecha_part_fabricator/service

/obj/machinery/mecha_part_fabricator/service/Initialize(mapload)
	. = ..()
	add_overlay("serv")

/obj/machinery/mecha_part_fabricator/service/update_icon_state()
	. = ..()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Коробка с проводами

/obj/item/cable_coil_box
	name = "комплект проводов"
	desc = "Бухта проводов в пластиковой упаковке. Содержит 30 метров кабеля."
	icon = 'icons/obj/power.dmi'
	icon_state = "coil_box"
	w_class = WEIGHT_CLASS_TINY

/obj/item/cable_coil_box/attack_self(mob/user)
	var/obj/item/stack/cable_coil/A = new
	to_chat(user, span_notice("Разрываю упаковку на кусочки и достаю провода."))
	playsound(get_turf(user), 'white/valtos/sounds/rip1.ogg', 40, TRUE)
	qdel(src)
	user.put_in_hands(A)

/datum/design/cable_coil_box
	name = "Комплект проводов"
	id = "cable_coil_box"
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 900, /datum/material/glass = 450)
	build_path = /obj/item/cable_coil_box
	category = list("Рабочие инструменты ","Рабочие инструменты  ", "Рабочие инструменты   ", "Рабочие инструменты    ", "Рабочие инструменты     ")
	sub_category = list("Прочее")

//	Пакеты с деталями

/obj/item/storage/part_replacer/stock_parts_box_x10
	name = "пакет с деталями"
	desc = "Содержит детали для постройки машин."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidence"
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_TINY
	pshoom_or_beepboopblorpzingshadashwoosh = 'sound/items/screwdriver.ogg'
	var/ripsound = 'white/valtos/sounds/rip1.ogg'
	var/item_type = null

/obj/item/storage/part_replacer/stock_parts_box_x10/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 10

/obj/item/storage/part_replacer/stock_parts_box_x10/Initialize(mapload)
	. = ..()
	if(contents.len)
		for(var/obj/item/I as() in contents)
			var/rand_size = (istype(I, /obj/item/stock_parts/scanning_module/noneuclid) || istype(I, /obj/item/stock_parts/micro_laser/quadultra)) ? 2 : 5
			var/mutable_appearance/part_overlay = mutable_appearance(I.icon, I.icon_state, FLOAT_LAYER, src, plane = FLOAT_PLANE)
			var/mutable_appearance/evidence_overlay = mutable_appearance(src.icon, src.icon_state, FLOAT_LAYER, src, plane = FLOAT_PLANE)
			part_overlay.pixel_x = base_pixel_x + rand(-rand_size, rand_size)
			part_overlay.pixel_y = base_pixel_y + rand(-rand_size, rand_size)
			add_overlay(part_overlay)
			add_overlay(evidence_overlay)

/obj/item/storage/part_replacer/stock_parts_box_x10/attack_self(mob/user)
	. = ..()
	to_chat(user, span_notice("Разрываю [src] на кусочки."))
	src.emptyStorage()
	playsound(src, ripsound, 40, TRUE)
	qdel(src)

/obj/item/storage/part_replacer/pre_attack(obj/item/storage/part_replacer/stock_parts_box_x10/T, mob/living/user, params)
	if(istype(T))
		T.emptyStorage()
		to_chat(user, span_notice("Разрываю [T] на кусочки."))
		playsound(get_turf(user), 'white/valtos/sounds/rip1.ogg', 40, TRUE)
		qdel(T)
	return ..()

/obj/item/storage/part_replacer/stock_parts_box_x10/PopulateContents()
	for(var/i in 1 to 10)
		new item_type(src)

//	Детали Т1 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t1
	item_type = /obj/item/stock_parts/capacitor

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t1
	item_type = /obj/item/stock_parts/scanning_module

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t1
	item_type = /obj/item/stock_parts/manipulator

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t1
	item_type = /obj/item/stock_parts/micro_laser

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t1
	item_type = /obj/item/stock_parts/matter_bin

//	Детали Т2 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t2
	item_type = /obj/item/stock_parts/capacitor/adv

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t2
	item_type = /obj/item/stock_parts/scanning_module/adv

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t2
	item_type = /obj/item/stock_parts/manipulator/nano

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t2
	item_type = /obj/item/stock_parts/micro_laser/high

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t2
	item_type = /obj/item/stock_parts/matter_bin/adv

//	Детали Т3 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t3
	item_type = /obj/item/stock_parts/capacitor/super

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t3
	item_type = /obj/item/stock_parts/scanning_module/phasic

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t3
	item_type = /obj/item/stock_parts/manipulator/pico

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t3
	item_type = /obj/item/stock_parts/micro_laser/ultra

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t3
	item_type = /obj/item/stock_parts/matter_bin/super

//	Детали Т4 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t4
	item_type = /obj/item/stock_parts/capacitor/quadratic

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t4
	item_type = /obj/item/stock_parts/scanning_module/triphasic

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t4
	item_type = /obj/item/stock_parts/manipulator/femto

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t4
	item_type = /obj/item/stock_parts/micro_laser/quadultra

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t4
	item_type = /obj/item/stock_parts/matter_bin/bluespace

//	Детали Т5 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t5
	item_type = /obj/item/stock_parts/capacitor/noneuclid

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t5
	item_type = /obj/item/stock_parts/scanning_module/noneuclid

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t5
	item_type = /obj/item/stock_parts/manipulator/noneuclid

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t5
	item_type = /obj/item/stock_parts/micro_laser/noneuclid

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t5
	item_type = /obj/item/stock_parts/matter_bin/noneuclid

//Capacitors
/datum/design/basic_capacitor_x10
	name = "Базовый конденсатор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "basic_capacitor_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t1
	category = list("Детали машин - х10")
	sub_category = list("Базовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/adv_capacitor_x10
	name = "Продвинутый конденсатор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "adv_capacitor_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 1500)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t2
	category = list("Детали машин - х10")
	sub_category = list("Продвинутые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/super_capacitor_x10
	name = "Супер конденсатор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "super_capacitor_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/gold = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t3
	category = list("Детали машин - х10")
	sub_category = list("Супер компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/quadratic_capacitor_x10
	name = "Ультра конденсатор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "quadratic_capacitor_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/gold = 1000, /datum/material/diamond = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t4
	category = list("Детали машин - х10")
	sub_category = list("Ультра компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

//Scanning modules
/datum/design/basic_scanning_x10
	name = "Базовый модуль сканирования - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "basic_scanning_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t1
	category = list("Детали машин - х10")
	sub_category = list("Базовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/adv_scanning_x10
	name = "Продвинутый модуль сканирования - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "adv_scanning_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t2
	category = list("Детали машин - х10")
	sub_category = list("Продвинутые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/phasic_scanning_x10
	name = "Супер фазированный модуль сканирования - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "phasic_scanning_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/silver = 600)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t3
	category = list("Детали машин - х10")
	sub_category = list("Супер компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/triphasic_scanning_x10
	name = "Ультра трифазированный модуль сканирования - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "triphasic_scanning_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/diamond = 300, /datum/material/bluespace = 300)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t4
	category = list("Детали машин - х10")
	sub_category = list("Ультра компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

//Maipulators
/datum/design/micro_mani_x10
	name = "Базовый микроманипулятор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "micro_mani_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t1
	category = list("Детали машин - х10")
	sub_category = list("Базовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/nano_mani_x10
	name = "Продвинутый наноманипулятор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "nano_mani_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t2
	category = list("Детали машин - х10")
	sub_category = list("Продвинутые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/pico_mani_x10
	name = "Супер пикоманипулятор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "pico_mani_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t3
	category = list("Детали машин - х10")
	sub_category = list("Супер компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/femto_mani_x10
	name = "Ультра фемтоманипулятор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "femto_mani_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/diamond = 300, /datum/material/titanium = 300)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t4
	category = list("Детали машин - х10")
	sub_category = list("Ультра компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

//Micro-lasers
/datum/design/basic_micro_laser_x10
	name = "Базовый микролазер - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "basic_micro_laser_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t1
	category = list("Детали машин - х10")
	sub_category = list("Базовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/high_micro_laser_x10
	name = "Продвинутый мощный микролазер - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "high_micro_laser_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t2
	category = list("Детали машин - х10")
	sub_category = list("Продвинутые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/ultra_micro_laser_x10
	name = "Супер высокомощный микролазер - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "ultra_micro_laser_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1500, /datum/material/uranium = 600)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t3
	category = list("Детали машин - х10")
	sub_category = list("Супер компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/quadultra_micro_laser_x10
	name = "Ультра квадромощный микролазер - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "quadultra_micro_laser_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/uranium = 1000, /datum/material/diamond = 600)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t4
	category = list("Детали машин - х10")
	sub_category = list("Ультра компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/basic_matter_bin_x10
	name = "Базовый резервуар материи - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "basic_matter_bin_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/bin_t1
	category = list("Детали машин - х10")
	sub_category = list("Базовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/adv_matter_bin_x10
	name = "Продвинутый резервуар материи - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "adv_matter_bin_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/bin_t2
	category = list("Детали машин - х10")
	sub_category = list("Продвинутые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/super_matter_bin_x10
	name = "Супер резервуар материи - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "super_matter_bin_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/bin_t3
	category = list("Детали машин - х10")
	sub_category = list("Супер компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluespace_matter_bin_x10
	name = "Ультра блюспейс резервуар материи - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "bluespace_matter_bin_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2500, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/bin_t4
	category = list("Детали машин - х10")
	sub_category = list("Ультра компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

//	Неевклидовые детали

/datum/design/noneuclid_capacitor_x10
	name = "Неевклидовый конденсатор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "noneuclid_capacitor_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/glass = 20000, /datum/material/gold = 10000, /datum/material/diamond = 1000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t5
	category = list("Детали машин - х10")
	sub_category = list("Неевклидовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_scanning_x10
	name = "Неевклидовый модуль сканирования - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "noneuclid_scanning_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/glass = 20000, /datum/material/diamond = 3000, /datum/material/bluespace = 3000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t5
	category = list("Детали машин - х10")
	sub_category = list("Неевклидовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_mani_x10
	name = "Неевклидовый манипулятор - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "noneuclid_mani_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/diamond = 3000, /datum/material/titanium = 3000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t5
	category = list("Детали машин - х10")
	sub_category = list("Неевклидовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_micro_laser_x10
	name = "Неевклидовый микролазер - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "noneuclid_micro_laser_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/glass = 20000, /datum/material/uranium = 10000, /datum/material/diamond = 6000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t5
	category = list("Детали машин - х10")
	sub_category = list("Неевклидовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_matter_bin_x10
	name = "Неевклидовый резервуар материи - х10"
	desc = "Схемотехнический компонент используемый при сборке машин и приборов."
	id = "noneuclid_matter_bin_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 25000, /datum/material/diamond = 10000, /datum/material/bluespace = 10000)
	build_path = /obj/item/storage/part_replacer/stock_parts_box_x10/bin_t5
	category = list("Детали машин - х10")
	sub_category = list("Неевклидовые компоненты")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

//	Сплавы х10

/obj/item/stack/sheet/plasteel/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/plasteel

/obj/item/stack/sheet/mineral/plastitanium/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/item/stack/sheet/plasmaglass/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/plasmaglass

/obj/item/stack/sheet/plasmarglass/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/plasmarglass

/obj/item/stack/sheet/titaniumglass/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/titaniumglass

/obj/item/stack/sheet/plastitaniumglass/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/plastitaniumglass

/obj/item/stack/sheet/mineral/abductor/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/mineral/abductor

/obj/item/stack/sheet/rglass/x10
	amount = 10
	merge_type = /obj/item/stack/sheet/rglass

/datum/design/plasteel_alloy_x10
	name = "Пласталь: Железо + Плазма"
	desc = "Пласталь является сплавом железа и плазмы. Благодаря отличной прочности и недороговизне этот новомодный сплав завоевал сердца многих инженеров."
	id = "plasteel_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/plasma = 20000)
	build_path = /obj/item/stack/sheet/plasteel/x10
	category = list("Сплавы и синтез")
	sub_category = list("Сплавы металлов")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plastitanium_alloy_x10
	name = "Пластитаниум: Титан + Плазма"
	desc = "Пластитаниум является сплавом титана и плазмы. Довольно крепкий, однако из за новизны ученые еще не спроектировали основные производственные чертежи."
	id = "plastitanium_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/titanium = 20000, /datum/material/plasma = 20000)
	build_path = /obj/item/stack/sheet/mineral/plastitanium/x10
	category = list("Сплавы и синтез")
	sub_category = list("Сплавы металлов")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plaglass_alloy_x10
	name = "Плазмастекло: Стекло + Плазма"
	desc = "Стеклянный лист из плазмосиликатного сплава. Обладает отличной огнестойкостью и повышенной прочностью."
	id = "plasmaglass_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/plasma = 10000, /datum/material/glass = 20000)
	build_path = /obj/item/stack/sheet/plasmaglass/x10
	category = list("Сплавы и синтез")
	sub_category = list("Силикатные сплавы")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plasmarglass_alloy_x10
	name = "Армоплазмастекло: Железо + Стекло + Плазма"
	desc = "Стеклянный лист из плазмосиликатного сплава укрепленный металлической армосеткой. Обладает невероятной огнестойкостью и хорошей прочностью."
	id = "plasmareinforcedglass_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/plasma = 10000, /datum/material/iron = 10000,  /datum/material/glass = 20000)
	build_path = /obj/item/stack/sheet/plasmarglass/x10
	category = list("Сплавы и синтез")
	sub_category = list("Силикатные сплавы")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/titaniumglass_alloy_x10
	name = "Титановое стекло: Титан + Стекло"
	desc = "Стеклянный лист из титаносиликатного сплава."
	id = "titaniumglass_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/titanium = 10000, /datum/material/glass = 20000)
	build_path = /obj/item/stack/sheet/titaniumglass/x10
	category = list("Сплавы и синтез")
	sub_category = list("Силикатные сплавы")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plastitaniumglass_alloy_x10
	name = "Пластитановое стекло: Титан + Стекло + Плазма"
	desc = "Стеклянный лист из плазмотитано-силикатного сплава."
	id = "plastitaniumglass_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/plasma = 10000, /datum/material/titanium = 10000, /datum/material/glass = 20000)
	build_path = /obj/item/stack/sheet/plastitaniumglass/x10
	category = list("Сплавы и синтез")
	sub_category = list("Силикатные сплавы")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/alienalloy_x10
	name = "Инопланетный сплав"
	desc = "Загадочный материал с неизведанными свойствами."
	id = "alienalloy_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 40000, /datum/material/plasma = 40000)
	build_path = /obj/item/stack/sheet/mineral/abductor/x10
	category = list("Сплавы и синтез")
	sub_category = list("Сплавы металлов")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rglass_x10
	name = "Армированное стекло"
	desc = "Стекло, укрепленное металлической арморешеткой."
	id = "rglass_x10"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 20000)
	build_path = /obj/item/stack/sheet/rglass/x10
	category = list("Сплавы и синтез")
	sub_category = list("Силикатные сплавы")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

//  Упаковки ружейный патронов
/datum/design/beanbag_slug/sec/x20
	name = "12 Калибр: Резиновая пуля - 20 шт."
	id = "sec_beanbag_slug_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 40000)
	build_path = /obj/item/storage/box/beanbag
	category = list("Аммуниция", "Боеприпасы", "Снаряжение сервиса")
	sub_category = list("Упаковки патронов 12 калибра")

/datum/design/rubbershot/sec/x20
	name = "12 Калибр: Резиновая картечь - 20 шт."
	id = "sec_rshot_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 40000)
	build_path = /obj/item/storage/box/rubbershot
	category = list("Аммуниция", "Боеприпасы", "Снаряжение сервиса")
	sub_category = list("Упаковки патронов 12 калибра")

/datum/design/shotgun_slug/sec/x20
	name = "12 Калибр: Пулевой - 20 шт."
	id = "sec_slug_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000)
	build_path = /obj/item/storage/box/s12_bullet
	sub_category = list("Упаковки патронов 12 калибра")

/datum/design/buckshot_shell/sec/x20
	name = "12 Калибр: Картечь - 20 шт."
	id = "sec_bshot_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000)
	build_path = /obj/item/storage/box/lethalshot
	sub_category = list("Упаковки патронов 12 калибра")

/datum/design/shotgun_dart/sec/x20
	name = "12 Калибр: Дротик - 20 шт."
	id = "sec_dart_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000)
	build_path = /obj/item/storage/box/battle_dart
	sub_category = list("Упаковки патронов 12 калибра")

/datum/design/incendiary_slug/sec/x20
	name = "12 Калибр: Зажигательный - 20 шт."
	id = "sec_Islug_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000)
	build_path = /obj/item/storage/box/battle_incendiary
	sub_category = list("Упаковки патронов 12 калибра")
/*
/datum/design/stunshell/x20
	name = "12 Калибр: Электрошок - 20 шт."
	id = "stunshell_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000, /datum/material/gold = 20000)
	build_path = /obj/item/storage/box/battle_stunslug
	sub_category = list("Упаковки патронов 12 калибра")
*/

/datum/design/techshell/x20
	name = "12 Калибр: Высокотехнологичный - 20 шт."
	id = "techshotshell_x20"
	construction_time = 40
	materials = list(/datum/material/iron = 60000, /datum/material/glass = 10000)
	build_path = /obj/item/storage/box/battle_techshell
	sub_category = list("Упаковки патронов 12 калибра")
