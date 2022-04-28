//Фабрикаторы

/**
 * Для корректной работы у /datum/design/предмет должен быть флаг build_type = MECHFAB (можно совмещать с другими)
 * У фабрикатора в отличии от протолата по другому задается время производства: construction_time = 40 равняется 4 секундам с деталями Т1 и 1 секунде с деталями Т4
 * Так же должен быть проставлен category = list() в соответствии с пунктами фабрикатора. Если такого пункта нет - отображатся он там не будет
 * Флагов отделов у фабрикатора нет, поэтому все пункты в разных фабрикаторах должны быть уникальными или будет дубликация (если это и не есть цель)
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
	part_sets = list(											// Подклассы:
								"Хирургические инструменты",	// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Прочее"
								"Медицинское снаряжение",		// "Диагностика и мониторинг","Экипировка", "Прочее", "Датчики и Сигнальные устройства"
								"Фармацевтика",					// "Химическая посуда", "Инъекции", "Хим-фабрика", "Прочее"
								"Кибернетика",					// "Базовые кибернетические органы", "Протезирование", "Стандартные кибернетические органы", "Продвинутые кибернетические органы", "Сенсорика"
								"Импланты",						// "Кибер Импланты", "Микро Импланты", "Дополненая реальность"
								"Медицинское оборудование",		// "Програмное обеспечение", "Терморегуляция", "Химпроизводство", "Автохирургия", "Реанимация и хирургия", "Биоманипулирование", "Прочее"
								"Вооружение",					//
								"Прочее"						//
								)

/obj/item/circuitboard/machine/mechfab/med
	name = "Плата Медицинского фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	icon_state = "medical"
	build_path = /obj/machinery/mecha_part_fabricator/med

/obj/machinery/mecha_part_fabricator/med/Initialize()
	. = ..()
	add_overlay("med")

/obj/machinery/mecha_part_fabricator/med/update_icon_state()
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
	part_sets = list(											// Подклассы:
								"Рабочие инструменты ",			// "Базовые инструменты", "Продвинутые инструменты", "Инопланетные инструменты", "Монтажные комплексы", "Обслуживание монтажных комплексов", "Прочее"
								"Инженерное снаряжение",		// "Огнетушители и газовые баллоны", "Экипировка", "Маркировщики", "Датчики и Сигнальные устройства", "Связь и навигация", "Диагностика и мониторинг"
								"Строительство",				// "Контролеры", "Освещение и наблюдение", "Настенные конструкции", "Напольные конструкции"
								"Инженерное оборудование",		//	"Терморегуляция", "Портативные генераторы", "Консоли", "Производство", "АТМОС", "Энергоснабжение", "ТЭГ", "Газовая турбина", "Телепортация", "Химпроизводство", "Сингулярность, тесла и суперматерия", "Прочее",
								"Детали машин",					//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
								"Детали машин - х10",			//	"Базовые компоненты", "Продвинутые компоненты", "Супер компоненты", "Ультра компоненты", "Неевклидовые компоненты"
								"Подпространственная связь",	//	"Радиорелейные платы", "Радиорелейные детали"
								"Энергетические разработки",	//
								"Сплавы и синтез",				//	"Сплавы металлов", "Силикатные сплавы", "Синтез"
								"Спейсподы и шатлостроение",	//	"Производство", "Броня", "Системы вооружения", "Добыча полезных ископаемых", "Вспомогательные системы", "Шатлостроение"
								"Персональные компьютеры",		//	"Основа", "Жесткие диски", "Сетевые карты", "Внешние накопители", "Слоты карт", "Утилитарные модули", "Питание и батареи", "Процессоры"
								"Интегральные схемы",			//	"Ядро", "Компоненты", "Оболочки"
								"Прочее"						//
								)

/obj/item/circuitboard/machine/mechfab/engi
	name = "Плата Инженерного фабрикатора"
	desc = "Продвинутая версия протолата с удобным визуальным интерфейсом."
	icon_state = "engineering"
	build_path = /obj/machinery/mecha_part_fabricator/engi

/obj/machinery/mecha_part_fabricator/engi/Initialize()
	. = ..()
	add_overlay("engi")

/obj/machinery/mecha_part_fabricator/engi/update_icon_state()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

//	Коробка с проводами

/obj/item/cable_coil_box
	name = "Комплект проводов"
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
	category = list("Рабочие инструменты ")
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
	component_type = /datum/component/storage/concrete/rped/x10
	var/ripsound = 'white/valtos/sounds/rip1.ogg'

/datum/component/storage/concrete/rped/x10
	max_items = 10

/obj/item/storage/part_replacer/stock_parts_box_x10/Initialize()
	. = ..()
	if(contents.len)
		var/obj/item/I = contents[1]
		if (istype(I, /obj/item/stock_parts/scanning_module/noneuclid) || istype(I, /obj/item/stock_parts/micro_laser/quadultra))
			var/mutable_appearance/part_overlay = new(I)
			part_overlay.plane = FLOAT_PLANE
			part_overlay.layer = FLOAT_LAYER
			part_overlay.pixel_x = base_pixel_x + rand(-2, 2)
			part_overlay.pixel_y = base_pixel_y + rand(-2, 2)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-2, 2)
			part_overlay.pixel_y = base_pixel_y + rand(-2, 2)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-2, 2)
			part_overlay.pixel_y = base_pixel_y + rand(-2, 2)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-2, 2)
			part_overlay.pixel_y = base_pixel_y + rand(-2, 2)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-2, 2)
			part_overlay.pixel_y = base_pixel_y + rand(-2, 2)
			add_overlay(part_overlay)
			add_overlay("evidence")
		else
			var/mutable_appearance/part_overlay = new(I)
			part_overlay.plane = FLOAT_PLANE
			part_overlay.layer = FLOAT_LAYER
			part_overlay.pixel_x = base_pixel_x + rand(-5, 5)
			part_overlay.pixel_y = base_pixel_y + rand(-5, 5)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-5, 5)
			part_overlay.pixel_y = base_pixel_y + rand(-5, 5)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-5, 5)
			part_overlay.pixel_y = base_pixel_y + rand(-5, 5)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-5, 5)
			part_overlay.pixel_y = base_pixel_y + rand(-5, 5)
			add_overlay(part_overlay)
			part_overlay.pixel_x = base_pixel_x + rand(-5, 5)
			part_overlay.pixel_y = base_pixel_y + rand(-5, 5)
			add_overlay(part_overlay)
			add_overlay("evidence")

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

//	Детали Т1 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t1

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t1/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t1

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t1/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/scanning_module(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t1

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t1/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/manipulator(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t1

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t1/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/micro_laser(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t1

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t1/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/matter_bin(src)


//	Детали Т2 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t2

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/adv(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t2

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/scanning_module/adv(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t2

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/manipulator/nano(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t2

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/micro_laser/high(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t2

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t2/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/matter_bin/adv(src)


//	Детали Т3 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t3

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t3/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/super(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t3

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t3/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/scanning_module/phasic(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t3

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t3/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/manipulator/pico(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t3

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t3/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/micro_laser/ultra(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t3

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t3/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/matter_bin/super(src)


//	Детали Т4 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t4

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/quadratic(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t4

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/scanning_module/triphasic(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t4

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/manipulator/femto(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t4

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/micro_laser/quadultra(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t4

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/matter_bin/bluespace(src)


//	Детали Т5 х10

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t5

/obj/item/storage/part_replacer/stock_parts_box_x10/capacitor_t5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/noneuclid(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t5

/obj/item/storage/part_replacer/stock_parts_box_x10/scanning_module_t5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/scanning_module/noneuclid(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t5

/obj/item/storage/part_replacer/stock_parts_box_x10/manipulator_t5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/manipulator/noneuclid(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t5

/obj/item/storage/part_replacer/stock_parts_box_x10/micro_laser_t5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/micro_laser/noneuclid(src)


/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t5

/obj/item/storage/part_replacer/stock_parts_box_x10/bin_t5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/matter_bin/noneuclid(src)


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

/obj/item/stack/sheet/mineral/plastitanium/x10
	amount = 10

/obj/item/stack/sheet/plasmaglass/x10
	amount = 10

/obj/item/stack/sheet/plasmarglass/x10
	amount = 10

/obj/item/stack/sheet/titaniumglass/x10
	amount = 10

/obj/item/stack/sheet/plastitaniumglass/x10
	amount = 10

/obj/item/stack/sheet/mineral/abductor/x10
	amount = 10

/obj/item/stack/sheet/rglass/x10
	amount = 10

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
