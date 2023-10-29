/datum/design/biocorrector
	name = "Биокорректор"
	desc = "Вправляет кости и чистит кровь. Может синтезировать костный гель."
	id = "biocorrector"
	build_path = /obj/item/bonesetter/advanced
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 5000, /datum/material/silver = 2000, /datum/material/titanium = 6000)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/medbot_carrier
	name = "Переноска для медботов"
	desc = "Разгрузка для транспортировки медботов."
	id = "medbot_carrier"
	build_path = /obj/item/medbot_carrier
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1000, /datum/material/plastic = 2000)
	category = list("Снаряжение", "Медицинское снаряжение", "Научное снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/teeth_box_32
	name = "Комплект зубных коронок"
	desc = "Стоматологический набор универсальных зубных протезов. Не очень удобные, сомнительного стального цвета, однако весьма дешевых, что положительно сказывается на стоимости медицинской страховки."
	id = "teeth_box_32"
	build_path = /obj/item/storage/box/teeth_box_32
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 6000)
	category = list("Кибернетика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

// 	Плохие конечности

/datum/design/robot_low_arm_left
	name = "Бюджетный протез левой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_arm_left"
	build_path = /obj/item/bodypart/l_arm/robot/surplus
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика")
	sub_category = list("Базовые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_arm_right
	name = "Бюджетный протез правой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_arm_right"
	build_path = /obj/item/bodypart/r_arm/robot/surplus
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика")
	sub_category = list("Базовые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_leg_left
	name = "Бюджетный протез левой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_leg_left"
	build_path = /obj/item/bodypart/l_leg/robot/surplus
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика")
	sub_category = list("Базовые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_leg_right
	name = "Бюджетный протез правой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_leg_right"
	build_path = /obj/item/bodypart/r_leg/robot/surplus
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика")
	sub_category = list("Базовые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

// 	Хорошие конечности

/datum/design/robot_good_arm_left
	name = "Продвинутый протез левой руки"
	desc = "Металлическая кибер-конечность. По физическим показателям она явно превосходит органику."
	id = "robot_good_arm_left"
	build_path = /obj/item/bodypart/l_arm/robot
	build_type = MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron=10000)
	category = list("Кибернетика")
	sub_category = list("Продвинутые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_good_arm_right
	name = "Продвинутый протез правой руки"
	desc = "Металлическая кибер-конечность. По физическим показателям она явно превосходит органику."
	id = "robot_good_arm_right"
	build_path = /obj/item/bodypart/r_arm/robot
	build_type = MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron=10000)
	category = list("Кибернетика")
	sub_category = list("Продвинутые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_good_leg_left
	name = "Продвинутый протез левой ноги"
	desc = "Металлическая кибер-конечность. По физическим показателям она явно превосходит органику."
	id = "robot_good_leg_left"
	build_path = /obj/item/bodypart/l_leg/robot
	build_type = MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron=10000)
	category = list("Кибернетика")
	sub_category = list("Продвинутые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_good_leg_right
	name = "Продвинутый протез правой ноги"
	desc = "Металлическая кибер-конечность. По физическим показателям она явно превосходит органику."
	id = "robot_good_leg_right"
	build_path = /obj/item/bodypart/r_leg/robot
	build_type = MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron=10000)
	category = list("Кибернетика")
	sub_category = list("Продвинутые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_head
	name = "Протез головы"
	desc = "Стандартная укрепленная черепная коробка, с подключаемой к позвоночнику нейронным сокетом и сенсорными стыковочными узлами."
	id = "robot_head"
	build_path = /obj/item/bodypart/head/robot
	build_type = MECHFAB
	construction_time = 80
	materials = list(/datum/material/iron=5000)
	category = list("Кибернетика")
	sub_category = list("Продвинутые протезы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/body_bag
	name = "Мешок для трупов"
	desc = "Полиэтиленовый пакет, предназначенный для хранения и транспортировки трупов."
	id = "body_bag"
	build_path = /obj/item/bodybag
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 2000)
	category = list("Медицинское снаряжение", "Снаряжение СБ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/body_bag/serv
	id = "body_bag_serv"
	category = list("Рабочие инструменты     ")
	sub_category = list("Инвентарь уборщика")

/datum/design/rollerbed
	name = "Каталка"
	desc = "Сборная кровать для транспортировки людей."
	id = "rollerbed"
	build_path = /obj/item/roller
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000)
	category = list("Медицинское снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/iv_drip_tele
	name = "Капельница"
	desc = "Складная капельница для переливания крови и лекарств. Весьма удобно лежит в двух руках."
	id = "iv_drip_tele"
	build_path = /obj/item/iv_drip_item
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000, /datum/material/plastic = 2000)
	category = list("Медицинское снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/breathing_bag
	name = "Дыхательная груша"
	desc = "Она же мешок Амбу — механическое ручное устройство для выполнения искусственной вентиляции лёгких."
	id = "breathing_bag"
	build_path = /obj/item/breathing_bag
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000, /datum/material/plastic = 4000)
	category = list("Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/gloves_latex
	name = "Латексные перчатки"
	desc = "Дешевые стерильные перчатки из латекса. Передают парамедицинские знания пользователю через бюджетные наночипы."
	id = "gloves_latex"
	build_path = /obj/item/clothing/gloves/color/latex
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000)
	category = list("Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/gloves_nitrile
	name = "Нитриловые перчатки"
	desc = "Дорогие стерильные перчатки из нитрила. Передаёт через наночипы знания, эквивалентные нескольким годам обучения в передовой медицинской академии."
	id = "gloves_nitrile"
	build_path = /obj/item/clothing/gloves/color/latex/nitrile
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/plastic = 3000)
	category = list("Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/gloves_polymer
	name = "Полимерные перчатки"
	desc = "Продвинутые медицинские перчатки изготовленные из винил-неопренового полимера. Содержит наночипы третьего порядка, корректирующие тонкую моторику носителя при переноске тел и хирургических операциях."
	id = "gloves_polymer"
	build_path = /obj/item/clothing/gloves/color/latex/nitrile/polymer
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 3000, /datum/material/plastic = 4000, /datum/material/silver = 3000)
	category = list("Медицинское снаряжение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pill_bottle_big
	name = "Большая баночка для таблеток"
	desc = "Вмещает в себя много пилюлек и таблеток."
	id = "pill_bottle_big"
	build_type = MECHFAB
	construction_time = 30
	materials = list(/datum/material/plastic = 40, /datum/material/glass = 200)
	build_path = /obj/item/storage/pill_bottle/big
	category = list("initial", "Медицина", "Фармацевтика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pill_bottle_ultra
	name = "Таблетница"
	desc = "Вмещает в себя очень много пилюлек и таблеток."
	id = "pill_bottle_ultra"
	build_type = MECHFAB
	construction_time = 30
	materials = list(/datum/material/plastic = 1000, /datum/material/glass = 500)
	build_path = /obj/item/storage/pill_bottle/ultra
	category = list("initial", "Медицина", "Фармацевтика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/handbeltsmodif
	name = "Комплект модернизации: Энергетические захваты"
	desc = "Комплект для установки комплекса хардлайт-прожекторов на стазисную кровать. Прожекторы создают хардлайт-ремни, фиксирующие пациента на стазис-кровати и не дающие ему встать, пока лечащий врач не разрешит. Или пока энергия не закончится."
	id = "handbeltsmodif"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/plastic = 4000, /datum/material/glass = 2000)
	build_path = /obj/item/handbeltsmodif
	category = list("Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/painkillermodif
	name = "Комплект модернизации: Обезболивающее"
	desc = "Комплект для подключения мягкой анестезии, пациент не будет ощущать боли и станет легче переносить тяжелое состояние."
	id = "painkillermodif"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/plastic = 4000, /datum/material/glass = 2000)
	build_path = /obj/item/painkillermodif
	category = list("Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/ivlmodif
	name = "Комплект модернизации: Аппарат ИВЛ"
	desc = "Комплект для установки аппарата ИВЛ, стабильно поддерживающий нормальный уровень кислорода."
	id = "ivlmodif"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/plastic = 4000, /datum/material/glass = 2000)
	build_path = /obj/item/ivlmodif
	category = list("Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/medipenal
	name = "Пенал для медипенов"
	desc = "Компактный и очень удобный пенал вмещающий до 5 медипенов, специальная клипса позволяет закрепить его на карманах или поясе, а с его маленькими габаритами он поместится в коробке или аптечке."
	id = "medipenal"
	build_path = /obj/item/storage/belt/medipenal
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000, /datum/material/plastic = 2000)
	category = list("Медицинское снаряжение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/hypno_watch
	name = "Карманные часы"
	desc = "Красивая реплика старинных механических часов на цепочке. Корпус выполнен из золота и ярко блестит при свете ламп. В этом блеске есть что-то гипнотически завораживающее..."
	id = "hypno_watch"
	build_path = /obj/item/hypno_watch
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000, /datum/material/gold = 2000)
	category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/solnce
	name = "МК-Солнце"
	desc = "Многофункциональный медицинский комплекс \"Солнце\". Передовая военная разработка в области экстренной полевой медицины. Для начала работы необходимо нажать кнопку инициации выбора модуля, после чего установить соответствующие расходные материалы."
	id = "solnce"
	build_path = /obj/item/solnce
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000, /datum/material/gold = 2000, /datum/material/silver = 3000, /datum/material/titanium = 1000, /datum/material/uranium = 500, /datum/material/plasma = 1000, /datum/material/bluespace = 1000, /datum/material/plastic = 2000)
	category = list("Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/biomonitor
	name = "Имплант биомонитора"
	desc = "Этот кибернетический мозговой имплант подключается к кровеносной и нервной системе носителя для определения его физического состояния и химанализа крови. Для активации необходимо мысленно <b>ОСМОТРЕТЬ СЕБЯ</b>."
	id = "ci-biomonitor"
	build_path = /obj/item/organ/cyberimp/brain/biomonitor
	build_type = MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 400)
	category = list("Импланты")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

// Операции

/*
/datum/design/surgery/toxin_healing //PLEASE ACCOUNT FOR UNIQUE HEALING BRANCHES IN THE hptech HREF (currently 2 for Brute/Burn; Combo is bonus)
	name = "Фильтрация лимфы (токсины)"
	desc = "Продвинутая версия операции."
	id = "surgery_healing_base" //holder because CI cries otherwise. Not used in techweb unlocks.
	surgery = /datum/surgery/healing
	research_icon_state = "surgery_chest"
*/
/datum/design/surgery/healing/toxin
	name = "Фильтрация лимфы (токсины, Продвинутое)"
	surgery = /datum/surgery/toxin_healing/toxin/upgraded
	id = "surgery_toxin_heal_toxin_upgrade"

/datum/design/surgery/healing/toxin_2
	name = "Фильтрация лимфы (токсины, Экспертное)"
	surgery = /datum/surgery/toxin_healing/toxin/femto
	id = "surgery_toxin_heal_toxin_upgrade_femto"

/datum/design/surgery/nanite_extraction
	name = "Удаление нанитов"
	desc = "Фильтрация крови пациента для механического извлечения нанитов из организма носителя."
	id = "surgery_nanite_extraction"
	surgery = /datum/surgery/nanite_extraction
