/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

//	РЕВОЛЬВЕР
/datum/design/c38/sec
	id = "sec_38"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_trac
	name = "Скорозарядник .38 калибра: Следящий"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Содержит в себе следящий микроимплант. Сильно слабее стандартных пуль."
	id = "c38_trac"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/silver = 5000, /datum/material/gold = 1000)
	build_path = /obj/item/ammo_box/c38/trac
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_bouncy
	name = "Cкорозарядник .38 калибра: Травматический"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Высококачественный НЕ ЛЕТАЛЬНЫЙ патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника."
	id = "c38_bouncy"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/plastic = 5000)
	build_path = /obj/item/ammo_box/c38/match/bouncy
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_dumdum
	name = "Cкорозарядник .38 калибра: Экспансивный"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Наносит повышенный урон, однако заметно хуже пробивает броню."
	id = "c38_dumdum"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000)
	build_path = /obj/item/ammo_box/c38/dumdum
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_match
	name = "Cкорозарядник .38 калибра: Самонаводящиеся"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Высококачественный патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника."
	id = "c38_match"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/titanium = 5000)
	build_path = /obj/item/ammo_box/c38/match/bouncy
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_hotshot
	name = "Скорозарядник .38 калибра: Зажигательный"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. При удачном попадании поджигает цель. Немного слабее стандартных пуль."
	id = "c38_hotshot"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/plasma = 5000)
	build_path = /obj/item/ammo_box/c38/hotshot
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/c38_iceblox
	name = "Скорозарядник .38 калибра: Замораживающий"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. При удачном попадании замораживает цель. Немного слабее стандартных пуль."
	id = "c38_iceblox"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10000, /datum/material/plasma = 5000)
	build_path = /obj/item/ammo_box/c38/iceblox
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Револьвер .38 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

//  РУЖЬЯ
/datum/design/rubbershot/sec
	name = "12 Калибр: Резиновая картечь"
	id = "sec_rshot"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/beanbag_slug/sec
	name = "12 Калибр: Резиновая пуля"
	id = "sec_beanbag_slug"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/shotgun_slug/sec
	id = "sec_slug"
	build_type = MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/buckshot_shell/sec
	id = "sec_bshot"
	build_type = MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/shotgun_dart/sec
	id = "sec_dart"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/incendiary_slug/sec
	id = "sec_Islug"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 10
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
/*
/datum/design/stunshell
	name = "12 Калибр: Электрошок"
	desc = "Останавливающая пуля с живительным зарядом энергии внутри."
	id = "stunshell"
	build_type = MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 3000, /datum/material/gold = 1000)
	build_path = /obj/item/ammo_casing/shotgun/stunslug
	category = list("Аммуниция", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
*/

/datum/design/techshell
	name = "12 Калибр: Высокотехнологичный"
	desc = "Пустой высокотехнологичный патрон, для создания уникальных боеприпасов."
	id = "techshotshell"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 500)
	build_path = /obj/item/ammo_casing/shotgun/techshell
	category = list("Аммуниция", "Научное снаряжение", "Боеприпасы")
	sub_category = list("Ружья: 12 калибра")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE

//  Ударники
/datum/design/pin_testing
	name = "Боек для практики"
	desc = "Данный ударник позволяет протестировать оружие на тестовой площадке. В ином месте это не будет работать."
	id = "pin_testing"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 500, /datum/material/glass = 300)
	build_path = /obj/item/firing_pin/test_range
	category = list("Бойки", "Оружейное дело")
	sub_category = list("Бойки")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pin_battle
	name = "Боевой боек"
	desc = "Стандартный боек для боевого оружия без каких-либо особенностей."
	id = "pin_battle"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 600, /datum/material/silver = 300)
	build_path = /obj/item/firing_pin
	category = list("Бойки", "Оружейное дело")
	sub_category = list("Бойки")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pin_mindshield
	name = "Боек с щитом разума"
	desc = "Этот защитный ударник позволяет использовать оружие только тем, кто имплантировал себе «щит разума»."
	id = "pin_loyalty"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/silver = 600, /datum/material/diamond = 600, /datum/material/uranium = 200)
	build_path = /obj/item/firing_pin/implant/mindshield
	category = list("Бойки", "Оружейное дело")
	sub_category = list("Бойки")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pin_explorer
	name = "Внестанционный боек"
	desc = "Разрешает стрелять из пушек, когда пушки не на станции. Полезно."
	id = "pin_explorer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/silver = 1000, /datum/material/gold = 1000, /datum/material/iron = 500)
	build_path = /obj/item/firing_pin/off_station
	category = list("Бойки", "Оружейное дело")
	sub_category = list("Бойки")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/stunrevolver
	name = "Комплект деталей пушки тесла"
	desc = "Кейс, содержащий необходимые детали для создания пушки тесла вокруг энергетической аномалии. Применять с соблюдением техники безопасности."
	id = "stunrevolver"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/silver = 10000)
	build_path = /obj/item/weaponcrafting/gunkit/tesla
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/nuclear_gun
	name = "Комплект деталей энергетической винтовки"
	desc = "Кейс, содержащий необходимые детали винтовки для преобразования стандартной энергетической винтовки в продвиную энергетическую винтовку."
	id = "nuclear_gun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 1000)
	build_path = /obj/item/weaponcrafting/gunkit/nuclear
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/tele_shield
	name = "Телескопический щит"
	desc = "Продвинутая версия пластикового щита Антибунт. Может складываться для уменьшения размеров. Значительная защита от ближнего боя, а так же может блокировать часть выстрелов."
	id = "tele_shield"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 4000, /datum/material/silver = 300, /datum/material/titanium = 200)
	build_path = /obj/item/shield/riot/tele
	category = list("Вооружение", "Снаряжение СБ")
	sub_category = list("Щиты и бронепластины")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/beamrifle
	name = "Комплект деталей винтовки ускорения частиц"
	desc = "Переворот в изготовлении оружия. В этом кейсе находится высокоэкспериментальная установка для винтовки ускорения частиц. Требуется энергетическая пушка, стабилизированная энергетическая аномалия и стабилизированная гравитационная аномалия."
	id = "beamrifle"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000, /datum/material/diamond = 5000, /datum/material/uranium = 8000, /datum/material/silver = 4500, /datum/material/gold = 5000)
	build_path = /obj/item/weaponcrafting/gunkit/beam_rifle
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/decloner
	name = "Комплект деталей клеточного дестабилизатора"
	desc = "Комплект деталей для преобразования лазерной пушки в клеточный дестабилизатор."
	id = "decloner"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/gold = 5000,/datum/material/uranium = 10000)
	build_path = /obj/item/weaponcrafting/gunkit/decloner
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/rapidsyringe
	name = "Многозарядный шприцемет"
	desc = "Модификация шприцевого пистолета с использованием вращающегося барабана, способного вместить до шести шприцов."
	id = "rapidsyringe"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 100
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe
	category = list("Вооружение", "Медицинское снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL		//uwu

/datum/design/temp_gun
	name = "Комплект деталей температурной винтовки"
	desc = "Кейс, содержащий необходимые детали винтовки для преобразования стандартной энергетической винтовки в температурный винтовку. Незаменим при противодействии быстро двигающимся противникам и существам чувствительным к перепадам температур."
	id = "temp_gun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 500, /datum/material/silver = 3000)
	build_path = /obj/item/weaponcrafting/gunkit/temperature
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/hell_gun
	name = "Комплект деталей винтовки \"Адское пламя\""
	desc = "Возьмите идеально работающую лазерную винтовку. Разделайте внутреннюю часть винтовки, чтобы она пылала. Теперь у вас есть винтовка \"Адское пламя\". Ты чудовище."
	id = "hell_gun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 500, /datum/material/plasma = 500, /datum/material/silver = 1000)
	build_path = /obj/item/weaponcrafting/gunkit/hellgun
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/flora_gun
	name = "Цветочный луч"
	desc = "Инструмент, который выпускает контролируемое излучение, которое вызывает мутацию в растительных клетках."
	id = "flora_gun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 500, /datum/material/uranium = 2000)
	build_path = /obj/item/gun/energy/floragun
	category = list("Вооружение")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/small_grenade
	name = "Химическая граната"
	desc = "Поддерживает стандартные емкости. При детонации нагревает состав на 10°K."
	id = "small_grenade"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/grenade/chem_grenade
	category = list("Вооружение", "Гранаты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/large_grenade
	name = "Большая химическая граната"
	desc = "Большой каркас химической гранаты. В отличие от обычных каркасов, этот имеет больший радиус взрыва и поддерживает блюспейс или различные экзотичные носители. При детонации нагревает состав на 25°K."
	id = "large_Grenade"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	category = list("Вооружение", "Гранаты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pyro_grenade
	name = "Пиро граната"
	desc = "Экспериментальный каркас химической гранаты. После активации резко нагревает реагенты внутри себя."
	id = "pyro_Grenade"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/plasma = 500)
	build_path = /obj/item/grenade/chem_grenade/pyro
	category = list("Вооружение", "Гранаты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cryo_grenade
	name = "Крио граната"
	desc = "Экспериментальный каркас химической гранаты. После активации резко охлаждает реагенты внутри себя."
	id = "cryo_Grenade"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/grenade/chem_grenade/cryo
	category = list("Вооружение", "Гранаты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/adv_grenade
	name = "Инжекторная граната"
	desc = "Экспериментальный каркас химической гранаты. Может использоваться больше одного раза. При помощи мультитула можно настроить количество выбрасываемого вещества."
	id = "adv_Grenade"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 500)
	build_path = /obj/item/grenade/chem_grenade/adv_release
	category = list("Вооружение", "Гранаты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/xray
	name = "Комплект деталей рентгеновской лазерной винтовки"
	desc = "Кейс с необходимыми деталями для преобразования лазерной винтовки в рентгеновскую лазерную винтовку. ВНИМАНИЕ! РАДИОАКТИВНО! Избегать близкого контакта кейса с паховой областью во время работы!"
	id = "xray_laser"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/gold = 5000, /datum/material/uranium = 4000, /datum/material/iron = 5000, /datum/material/titanium = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/weaponcrafting/gunkit/xray
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/ioncarbine
	name = "Комплект деталей ионного карабина"
	desc = "Лучшее средство для борьбы с техникой противника."
	id = "ioncarbine"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/silver = 6000, /datum/material/iron = 8000, /datum/material/uranium = 2000)
	build_path = /obj/item/weaponcrafting/gunkit/ion
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/wormhole_projector
	name = "Портальная пушка"
	desc = "Проектор, который излучает квантовые блюспейс порталы. Требуется ядро блюспейс аномалии для функционирования."
	id = "wormholeprojector"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/silver = 2000, /datum/material/iron = 5000, /datum/material/diamond = 2000, /datum/material/bluespace = 3000)
	build_path = /obj/item/gun/energy/wormhole_projector
	category = list("Вооружение", "Научное снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/suppressor
	name = "Глушитель"
	desc = "Маленький глушитель для большого шпионажа."
	id = "suppressor"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/suppressor
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модули огнестрельного оружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/gravitygun
	name = "Гравитационная пушка"
	desc = "Экспериментальное многорежимное устройство, которое запускает заряд энергии нулевой точки, вызывая локальные искажения в гравитации. Требуется ядро гравитационной аномалии для функционирования."
	id = "gravitygun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/silver = 8000, /datum/material/uranium = 8000, /datum/material/glass = 12000, /datum/material/iron = 12000, /datum/material/diamond = 3000, /datum/material/bluespace = 3000)
	build_path = /obj/item/gun/energy/gravity_gun
	category = list("Вооружение", "Научное снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/largecrossbow
	name = "Комплект деталей энергетического арбалета"
	desc = "Нелегальный набор для модификации оружия. Позволяет модифицировать стандартный протокинетический ускоритель для создания подобия энергетического арбалета. Почти как настоящий!"
	id = "largecrossbow"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1500, /datum/material/uranium = 1500, /datum/material/silver = 1500)
	build_path = /obj/item/weaponcrafting/gunkit/ebow
	category = list("Вооружение", "Оружейное дело")
	sub_category = list("Модернизация энергооружия")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/cleric_mace
	name = "Cleric Mace"
	desc = "A mace fit for a cleric. Useful for bypassing plate armor, but too bulky for much else."
	id = "cleric_mace"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 12000)
	build_path = /obj/item/melee/cleric_mace
	category = list("Импорт")

/datum/design/stun_boomerang
	name = "ОЗТек Бумеранг"
	desc = "Устройство, изобретенное в 2486 году для великой войны в Космическом Эму конфедерацией Австраликуса, эти высокотехнологичные бумеранги также отлично работают на потрясающих членов экипажа. Просто будьте осторожны, чтобы поймать его, когда брошено!"
	id = "stun_boomerang"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/silver = 10000, /datum/material/gold = 2000)
	build_path = /obj/item/melee/baton/boomerang
	category = list("Вооружение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

//=======================================
// Shuttle Weapons
//=======================================

/datum/design/board/weapons
	name = "Shuttle Weapons Control Computer"
	desc = "A computer board that allows for the control of weapons on a linked shuttle."
	id = "computer_weapons"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/iron = 300)
	build_path = /obj/item/circuitboard/computer/shuttle/weapons
	category = list("Shuttle Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/shuttle_weapon
	name = "Laser Cannon Mount"
	desc = "A wall mounted laser cannon, designed for use on shuttles."
	id = "shuttle_laser"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 25000, /datum/material/glass = 10000)
	category = list("Shuttle Weapons")
	build_path = /obj/item/wallframe/shuttle_weapon/laser
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/shuttle_weapon/laser_triple
	name = "Burst Laser MKI Mount"
	desc=  "A wall mounted burst laser, designed for use on shuttles."
	id = "shuttle_laser_burst"
	materials = list(/datum/material/iron = 35000, /datum/material/glass = 10000, /datum/material/gold = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/laser/triple

/datum/design/shuttle_weapon/laser_triple_mark2
	name = "Burst Laser MKII Mount"
	desc=  "An upgraded version of the wall mounted burst laser, designed for use on shuttles."
	id = "shuttle_laser_burst_two"
	materials = list(/datum/material/iron = 40000, /datum/material/glass = 15000, /datum/material/gold = 10000, /datum/material/titanium = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/laser/triple/mark2

/datum/design/shuttle_weapon/missile
	name = "Centaur I Mount"
	desc=  "A wall mounted missile launcher, designed for use on shuttles."
	id = "shuttle_missile"
	materials = list(/datum/material/iron = 30000, /datum/material/gold = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/missile

/datum/design/shuttle_weapon/tri_missile
	name = "Centaur II Mount"
	desc=  "Wall mounted pods containing tri-firing missiles, designed for use on shuttles."
	id = "shuttle_tri_missile"
	materials = list(/datum/material/iron = 50000, /datum/material/gold = 15000, /datum/material/diamond = 1000)
	build_path = /obj/item/wallframe/shuttle_weapon/missile/tri

/datum/design/shuttle_weapon/breach_missile
	name = "Breaching Missile Mount"
	desc=  "A wall mounted breaching missile launcher, designed for use on shuttles."
	id = "shuttle_breach_missile"
	materials = list(/datum/material/iron = 40000, /datum/material/gold = 10000, /datum/material/titanium = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/missile/breach

/datum/design/shuttle_weapon/fire_missile
	name = "Inferno Missile Mount"
	desc=  "A wall mounted incendiary missile launcher, designed for use on shuttles."
	id = "shuttle_fire_missile"
	materials = list(/datum/material/iron = 40000, /datum/material/gold = 10000, /datum/material/uranium = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/missile/fire

/datum/design/shuttle_weapon/point_defense_one
	name = "Hades MKI Chaincannon Mount"
	desc=  "A wall mounted automatic chain channon with limited capability to destroy hull, but extremely powerful at taking down crews and machinery. Designed for use on shuttles."
	id = "shuttle_point_defense"
	materials = list(/datum/material/iron = 30000, /datum/material/glass = 10000)
	build_path = /obj/item/wallframe/shuttle_weapon/point_defense

/datum/design/shuttle_weapon/point_defense_two
	name = "Hades MKII Chaincannon Mount"
	desc=  "An upgraded version of the MKI Hades. While less accurate and slower to reload, it has a larger volley size. Designed for use on shuttles."
	id = "shuttle_point_defense_upgraded"
	materials = list(/datum/material/iron = 50000, /datum/material/glass = 15000, /datum/material/gold = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/point_defense/upgraded

/datum/design/shuttle_weapon/scatter_shot
	name = "Ares Scattershot Mount"
	desc=  "A powerful flak cannon that fires 8 projectiles at once. Designed for use on shuttles."
	id = "shuttle_scatter_shot"
	materials = list(/datum/material/iron = 80000, /datum/material/glass = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/scatter

/datum/design/shuttle_weapon/railgun
	name = "Zeus MKI Railgun Mount"
	desc=  "A kinetic weapon designed for long ranged precision shots. Designed for use on shuttles."
	id = "shuttle_railgun"
	materials = list(/datum/material/iron = 60000, /datum/material/glass = 20000, /datum/material/plasma = 10000, /datum/material/diamond = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/railgun

/datum/design/shuttle_weapon/railgun_crew
	name = "Zeus MKII Anti-Personnel Railgun Mount"
	desc=  "A kinetic weapon that fired uranium coated magnetic rounds. Designed for long ranged precision shots. Designed for use on shuttles."
	id = "shuttle_railgun_crew"
	materials = list(/datum/material/iron = 60000, /datum/material/glass = 20000, /datum/material/plasma = 10000, /datum/material/diamond = 5000, /datum/material/uranium = 5000)
	build_path = /obj/item/wallframe/shuttle_weapon/railgun/anti_crew
