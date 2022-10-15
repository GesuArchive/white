/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = WEIGHT_CLASS_GIGANTIC
	flags_1 = CONDUCT_1

/obj/item/mecha_parts/proc/try_attach_part(mob/user, obj/vehicle/sealed/mecha/M, attach_right = FALSE) //For attaching parts to a finished mech
	if(!user.transferItemToLoc(src, M))
		to_chat(user, span_warning("<b>[capitalize(src)]</b> решила застрять в моей руке, не могу прикрепить к [M]!"))
		return FALSE
	user.visible_message(span_notice("[user] прикрепляет [src] к [M].") , span_notice("Прикрепляю [src] к [M]."))
	return TRUE

/obj/item/mecha_parts/part/try_attach_part(mob/user, obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	return

/obj/item/mecha_parts/chassis
	name = "каркас экзокостюма"
	desc = "Сверхкрепкий металлический каркас со стандартными гнездами для конечностей и креплениями синтетических псевдо-мышц."
	icon_state = "backbone"
	interaction_flags_item = NONE			//Don't pick us up!!
	var/construct_type

/obj/item/mecha_parts/chassis/Initialize(mapload)
	. = ..()
	if(construct_type)
		AddComponent(construct_type)

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "каркас Рипли"
	construct_type = /datum/component/construction/unordered/mecha_chassis/ripley

/obj/item/mecha_parts/part/ripley_torso
	name = "торс Рипли"
	desc = "Центральная часть АПЛУ Рипли. Содержит блок питания, процессорное ядро и системы жизнеобеспечения."
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/ripley_left_arm
	name = "левая рука Рипли"
	desc = "Деталь АПЛУ Рипли. Разъемы для передачи данных и питания совместимы с большинством инструментов экзокостюмов."
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/ripley_right_arm
	name = "правая рука Рипли"
	desc = "Деталь АПЛУ Рипли. Разъемы для передачи данных и питания совместимы с большинством инструментов экзокостюмов."
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/ripley_left_leg
	name = "левая нога Рипли"
	desc = "Деталь АПЛУ Рипли. Содержит сложные сервоприводы и системы поддержания баланса."
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/ripley_right_leg
	name = "правая нога Рипли"
	desc = "Деталь АПЛУ Рипли. Содержит сложные сервоприводы и системы поддержания баланса."
	icon_state = "ripley_r_leg"

///////// Odysseus

/obj/item/mecha_parts/chassis/odysseus
	name = "каркас Одиссея"
	construct_type = /datum/component/construction/unordered/mecha_chassis/odysseus

/obj/item/mecha_parts/part/odysseus_head
	name = "голова Одиссея"
	desc = "Деталь Одиссея. Содержит встроенный медицинский сканер."
	icon_state = "odysseus_head"

/obj/item/mecha_parts/part/odysseus_torso
	name = "торс Одиссея"
	desc = "Деталь Одиссея. Содержит блок питания, ядро обработки и системы жизнеобеспечения, а также разъем для крепления подвесного спасательного места."
	icon_state = "odysseus_torso"

/obj/item/mecha_parts/part/odysseus_left_arm
	name = "левая рука Одиссея"
	desc = "Деталь Одиссея. Разъемы для передачи данных и питания совместимы со специализированным медицинским оборудованием."
	icon_state = "odysseus_l_arm"

/obj/item/mecha_parts/part/odysseus_right_arm
	name = "правая рука Одиссея"
	desc = "Деталь Одиссея. Разъемы для передачи данных и питания совместимы со специализированным медицинским оборудованием."
	icon_state = "odysseus_r_arm"

/obj/item/mecha_parts/part/odysseus_left_leg
	name = "левая нога Одиссея"
	desc = "Деталь Одиссея. Содержит сложные сервоприводы и системы поддержания баланса для аккуратной транспортировки критических пациентов."
	icon_state = "odysseus_l_leg"

/obj/item/mecha_parts/part/odysseus_right_leg
	name = "правая нога Одиссея"
	desc = "Деталь Одиссея. Содержит сложные сервоприводы и системы поддержания баланса для аккуратной транспортировки критических пациентов."
	icon_state = "odysseus_r_leg"

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "каркас Гигакса"
	construct_type = /datum/component/construction/unordered/mecha_chassis/gygax

/obj/item/mecha_parts/part/gygax_torso
	name = "торс Гигакса"
	desc = "Деталь Гигакса. Содержит блок питания, процессорное ядро и системы жизнеобеспечения."
	icon_state = "gygax_harness"

/obj/item/mecha_parts/part/gygax_head
	name = "голова Гигакса"
	desc = "Деталь Гигакса. Houses advanced surveillance and targeting sensors."
	icon_state = "gygax_head"

/obj/item/mecha_parts/part/gygax_left_arm
	name = "левая рука Гигакса"
	desc = "Деталь Гигакса. Разъемы для передачи данных и питания совместимы с большинством инструментов и оружий экзокостюма."
	icon_state = "gygax_l_arm"

/obj/item/mecha_parts/part/gygax_right_arm
	name = "правая рука Гигакса"
	desc = "Деталь Гигакса. Разъемы для передачи данных и питания совместимы с большинством инструментов и оружий экзокостюма."
	icon_state = "gygax_r_arm"

/obj/item/mecha_parts/part/gygax_left_leg
	name = "левая нога Гигакса"
	desc = "Деталь Гигакса. Сконструирован с использованием передовых сервомеханизмов и приводов для обеспечения более высокой скорости."
	icon_state = "gygax_l_leg"

/obj/item/mecha_parts/part/gygax_right_leg
	name = "правая нога Гигакса"
	desc = "Деталь Гигакса. Сконструирован с использованием передовых сервомеханизмов и приводов для обеспечения более высокой скорости."
	icon_state = "gygax_r_leg"

/obj/item/mecha_parts/part/gygax_armor
	gender = PLURAL
	name = "броня Гигакса"
	desc = "Набор броневых пластин, предназначенных для Гигакса. Разработан для эффективного отражения повреждений без критического влияния на вес конструкции."
	icon_state = "gygax_armor"


//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "каркас Дюранда"
	construct_type = /datum/component/construction/unordered/mecha_chassis/durand

/obj/item/mecha_parts/part/durand_torso
	name = "торс Дюранда"
	desc = "Деталь Дюранда. Содержит блок питания, ядро обработки и системы жизнеобеспечения в прочной защитном корпусе."
	icon_state = "durand_harness"

/obj/item/mecha_parts/part/durand_head
	name = "голова Дюранда"
	desc = "Деталь Дюранда. Houses advanced surveillance and targeting sensors."
	icon_state = "durand_head"

/obj/item/mecha_parts/part/durand_left_arm
	name = "левая рука Дюранда"
	desc = "Деталь Дюранда. Разъемы для передачи данных и питания совместимы с большинством инструментов и оружий экзокостюма. Также наносит действительно сильный удар."
	icon_state = "durand_l_arm"

/obj/item/mecha_parts/part/durand_right_arm
	name = "правая рука Дюранда"
	desc = "Деталь Дюранда. Разъемы для передачи данных и питания совместимы с большинством инструментов и оружий экзокостюма. Также наносит действительно сильный удар."
	icon_state = "durand_r_arm"

/obj/item/mecha_parts/part/durand_left_leg
	name = "левая нога Дюранда"
	desc = "Деталь Дюранда. Сконструирован особенно прочно, чтобы выдерживать большой вес Дюранда и оборонительные потребности."
	icon_state = "durand_l_leg"

/obj/item/mecha_parts/part/durand_right_leg
	name = "правая нога Дюранда"
	desc = "Деталь Дюранда. Сконструирован особенно прочно, чтобы выдерживать большой вес Дюранда и оборонительные потребности."
	icon_state = "durand_r_leg"

/obj/item/mecha_parts/part/durand_armor
	gender = PLURAL
	name = "броня Дюранда"
	desc = "Набор броневых пластин для Дюранда. Спроектирован крайне тяжелым, чтобы противостоять невероятному количеству урона."
	icon_state = "durand_armor"

////////// Clarke

/obj/item/mecha_parts/chassis/clarke
	name = "каркас Кларка"
	construct_type = /datum/component/construction/unordered/mecha_chassis/clarke

/obj/item/mecha_parts/part/clarke_torso
	name = "торс Кларка"
	desc = "Деталь Кларка. Содержит блок питания, процессорное ядро и системы жизнеобеспечения."
	icon_state = "clarke_harness"

/obj/item/mecha_parts/part/clarke_head
	name = "голова Кларка"
	desc = "Деталь Кларка. Содержит встроенный диагностический сканер."
	icon_state = "clarke_head"

/obj/item/mecha_parts/part/clarke_left_arm
	name = "левая рука Кларка"
	desc = "Деталь Кларка. Разъемы для передачи данных и питания совместимы с большинством инструментов экзокостюмов."
	icon_state = "clarke_l_arm"

/obj/item/mecha_parts/part/clarke_right_arm
	name = "правая рука Кларка"
	desc = "Деталь Кларка. Разъемы для передачи данных и питания совместимы с большинством инструментов экзокостюмов."
	icon_state = "clarke_r_arm"

////////// HONK

/obj/item/mecha_parts/chassis/honker
	name = "каркас Х.О.Н.К.а"
	construct_type = /datum/component/construction/unordered/mecha_chassis/honker

/obj/item/mecha_parts/part/honker_torso
	name = "торс Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. Содержит блок смешков, ядро из бананиума и системы поддержки гудков."
	icon_state = "honker_harness"

/obj/item/mecha_parts/part/honker_head
	name = "голова Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. Похоже, у него отсутствует лицевая панель."
	icon_state = "honker_head"

/obj/item/mecha_parts/part/honker_left_arm
	name = "левая рука Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. С уникальными гнездами, которые принимают странное оружие, разработанное учеными-клоунами."
	icon_state = "honker_l_arm"

/obj/item/mecha_parts/part/honker_right_arm
	name = "правая рука Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. С уникальными гнездами, которые принимают странное оружие, разработанное учеными-клоунами."
	icon_state = "honker_r_arm"

/obj/item/mecha_parts/part/honker_left_leg
	name = "левая нога Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. Нога кажется достаточно большой, чтобы полностью вместить клоунскую обувь."
	icon_state = "honker_l_leg"

/obj/item/mecha_parts/part/honker_right_leg
	name = "правая нога Х.О.Н.К.а"
	desc = "Деталь Х.О.Н.К.а. Нога кажется достаточно большой, чтобы полностью вместить клоунскую обувь."
	icon_state = "honker_r_leg"


////////// Phazon

/obj/item/mecha_parts/chassis/phazon
	name = "каркас Фазона"
	construct_type = /datum/component/construction/unordered/mecha_chassis/phazon

/obj/item/mecha_parts/chassis/phazon/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/assembly/signaler/anomaly) && !istype(I, /obj/item/assembly/signaler/anomaly/bluespace))
		to_chat(user, "Разъем ядра аномалии принимает только блюспейс ядра аномалии!")

/obj/item/mecha_parts/part/phazon_torso
	name = "торс Фазона"
	desc = "Деталь Фазона. Посередине расположено гнездо для блюспейс ядра, которое питает уникальные фазовые приводы экзокостюмов ."
	icon_state = "phazon_harness"

/obj/item/mecha_parts/part/phazon_head
	name = "голова Фазона"
	desc = "Деталь Фазона. Его датчики тщательно откалиброваны, чтобы обеспечить обзор и передачу данных даже при фазировании."
	icon_state = "phazon_head"

/obj/item/mecha_parts/part/phazon_left_arm
	name = "левая рука Фазона"
	desc = "Деталь Фазона. Под броневой обшивкой расположено несколько массивов микроинструментов, которые можно регулировать в зависимости от конкретной ситуации."
	icon_state = "phazon_l_arm"

/obj/item/mecha_parts/part/phazon_right_arm
	name = "правая рука Фазона"
	desc = "Деталь Фазона. Под броневой обшивкой расположено несколько массивов микроинструментов, которые можно регулировать в зависимости от конкретной ситуации."
	icon_state = "phazon_r_arm"

/obj/item/mecha_parts/part/phazon_left_leg
	name = "левая нога Фазона"
	desc = "Деталь Фазона. Содержит уникальные фазовые приводы, которые позволяют экзокостюму проходить через твердую материю при включении."
	icon_state = "phazon_l_leg"

/obj/item/mecha_parts/part/phazon_right_leg
	name = "правая нога Фазона"
	desc = "Деталь Фазона. Содержит уникальные фазовые приводы, которые позволяют экзокостюму проходить через твердую материю при включении."
	icon_state = "phazon_r_leg"

/obj/item/mecha_parts/part/phazon_armor
	name = "броня Фазона"
	desc = "Деталь Фазона. Они покрыты слоем плазмы для защиты пилота от напряжения при фазировании и обладают необычными свойствами."
	icon_state = "phazon_armor"

// Саванна-Иванова

/obj/item/mecha_parts/chassis/savannah_ivanov
	name = "каркас Саванна-Иванова"
	construct_type = /datum/component/construction/unordered/mecha_chassis/savannah_ivanov

/obj/item/mecha_parts/part/savannah_ivanov_torso
	name = "торс Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. Здесь довольно просторно..."
	icon_state = "savannah_ivanov_harness"

/obj/item/mecha_parts/part/savannah_ivanov_head
	name = "голова Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. Ее датчики были отрегулированы таким образом, чтобы поддерживать изящную посадку."
	icon_state = "savannah_ivanov_head"

/obj/item/mecha_parts/part/savannah_ivanov_left_arm
	name = "левая рука Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. В запястьях скрыты компактные фабрикаторы ракет."
	icon_state = "savannah_ivanov_l_arm"

/obj/item/mecha_parts/part/savannah_ivanov_right_arm
	name = "правая рука Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. В запястьях скрыты компактные фабрикаторы ракет."
	icon_state = "savannah_ivanov_r_arm"

/obj/item/mecha_parts/part/savannah_ivanov_left_leg
	name = "левая нога Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. Ресурс ходовой системы рассчитан на перевозку более двух пассажиров, поэтому функционал был расширен, чтобы не тратить потенциал впустую."
	icon_state = "savannah_ivanov_l_leg"

/obj/item/mecha_parts/part/savannah_ivanov_right_leg
	name = "правая нога Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. Ресурс ходовой системы рассчитан на перевозку более двух пассажиров, поэтому функционал был расширен, чтобы не тратить потенциал впустую."
	icon_state = "savannah_ivanov_r_leg"

/obj/item/mecha_parts/part/savannah_ivanov_armor
	name = "броня Саванна-Иванова"
	desc = "Деталь Саванна-Иванова. Броня имеют уникальную форму и усилена, чтобы компенсировать нагрузку на  двух пилотов, прыжки и ракетные залпы."
	icon_state = "savannah_ivanov_armor"

///////// Circuitboards

/obj/item/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/circuitboard/mecha/ripley/peripherals
	name = "Плата экзокостюма Рипли - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/ripley/main
	name = "Плата экзокостюма Рипли - Основной контролер"
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/gygax/peripherals
	name = "Плата экзокостюма Гигакс - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = "Плата экзокостюма Гигакс - Орудийный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/main
	name = "Плата экзокостюма Гигакс - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/durand/peripherals
	name = "Плата экзокостюма Дюранд - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = "Плата экзокостюма Дюранд - Орудийный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/main
	name = "Плата экзокостюма Дюранд - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/honker/peripherals
	name = "Плата экзокостюма Х.О.Н.К - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/targeting
	name = "Плата экзокостюма Х.О.Н.К - Орудийный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/main
	name = "Плата экзокостюма Х.О.Н.К - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = "Плата экзокостюма Одиссей - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/odysseus/main
	name = "Плата экзокостюма Одиссей - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/phazon/peripherals
	name = "Плата экзокостюма Фазон - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/phazon/targeting
	name = "Плата экзокостюма Фазон - Орудийный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/phazon/main
	name = "Плата экзокостюма Фазон - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/clarke/peripherals
	name = "Плата экзокостюма Кларк - Вспомогательный контролер"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/clarke/main
	name = "Плата экзокостюма Кларк - Основной контролер"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/savannah_ivanov/peripherals
	name = "Плата экзокостюма Саванна-Иванов - Вспомогательный контролер Саванны"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/savannah_ivanov/targeting
	name = "Плата экзокостюма Саванна-Иванов - Орудийный контролер Иванова"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/savannah_ivanov/main
	name = "Плата экзокостюма Саванна-Иванов - Основной контролер"
	icon_state = "mainboard"
