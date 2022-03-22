/datum/design/biocorrector
	name = "Биокорректор"
	desc = "Вправляет кости и чистит кровь. Может синтезировать костный гель."
	id = "biocorrector"
	build_path = /obj/item/bonesetter/advanced
	build_type = PROTOLATHE | MECHFAB
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
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1000, /datum/material/plastic = 2000)
	category = list("Снаряжение", "Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/teeth_box_32
	name = "Комплект зубных коронок"
	desc = "Стоматологический набор универсальных зубных протезов. Не очень удобные, сомнительного стального цвета, однако весьма дешевых, что положительно сказывается на стоимости медицинской страховки."
	id = "teeth_box_32"
	build_path = /obj/item/storage/box/teeth_box_32
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 6000)
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Протезирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_arm_left
	name = "Бюджетный протез левой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_arm_left"
	build_path = /obj/item/bodypart/l_arm/robot/surplus
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Протезирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_arm_right
	name = "Бюджетный протез правой руки"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_arm_right"
	build_path = /obj/item/bodypart/r_arm/robot/surplus
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Протезирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_leg_left
	name = "Бюджетный протез левой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_leg_left"
	build_path = /obj/item/bodypart/l_leg/robot/surplus
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Протезирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/robot_low_leg_right
	name = "Бюджетный протез правой ноги"
	desc = "Скелетообразная кибер-конечность. Устаревшая и хрупкая, но всё же лучше чем ничего."
	id = "robot_low_leg_right"
	build_path = /obj/item/bodypart/r_leg/robot/surplus
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 1000)
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Протезирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/body_bag
	name = "Мешок для трупов"
	desc = "Полиэтиленовый пакет, предназначенный для хранения и транспортировки трупов."
	id = "body_bag"
	build_path = /obj/item/bodybag
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 2000)
	category = list("Медицинское снаряжение", "Медицинские разработки")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/rollerbed
	name = "Каталка"
	desc = "Сборная кровать для транспортировки людей."
	id = "rollerbed"
	build_path = /obj/item/roller
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000)
	category = list("Медицинское снаряжение", "Медицинские разработки")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pill_bottle_big
	name = "Большая баночка для таблеток"
	desc = "Вмещает в себя много пилюлек и таблеток."
	id = "pill_bottle_big"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/plastic = 40, /datum/material/glass = 200)
	build_path = /obj/item/storage/pill_bottle/big
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
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

/datum/design/medipenal
	name = "Пенал для медипенов"
	desc = "Компактный и очень удобный пенал вмещающий до 5 медипенов, специальная клипса позволяет закрепить его на карманах или поясе, а с его маленькими габаритами он поместится в коробке или аптечке."
	id = "medipenal"
	build_path = /obj/item/storage/belt/medipenal
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000, /datum/material/plastic = 2000)
	category = list("Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL


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
	surgery = /datum/surgery/toxin_healing/toxin/upgraded/femto
	id = "surgery_toxin_heal_toxin_upgrade_femto"

