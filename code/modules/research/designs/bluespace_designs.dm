
/////////////////////////////////////////
///////////////Bluespace/////////////////
/////////////////////////////////////////

/datum/design/beacon
	name = "Телепортационный маяк"
	desc = "Миниатюрное устройство служащее фокусирующим маяком для ручных и стационарных телепортов."
	id = "beacon"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150, /datum/material/glass = 100)
	build_path = /obj/item/beacon
	category = list("Блюспейс разработки", "Инженерное снаряжение", "Научное снаряжение", "Карго снаряжение", "Снаряжение СБ")
	sub_category = list("Связь и навигация")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SECURITY

/datum/design/bag_holding
	name = "Инертная блюспейс сумка"
	desc = "То, что в настоящее время представляет собой просто громоздкий металлический блок со слотом, готовым принять ядро блюспейс аномалии."
	id = "bag_holding"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/gold = 3000, /datum/material/diamond = 1500, /datum/material/uranium = 250, /datum/material/bluespace = 2000)
	build_path = /obj/item/bag_of_holding_inert
	category = list("Блюспейс разработки", "Научное снаряжение")
	sub_category = list("Экипировка")
	dangerous_construction = TRUE
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluebutt
	name = "Блюспейс задница"
	desc = "Высокотехнологичный протез задницы с подпространственным карманом для хранения предметов."
	id = "bluebutt"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/gold = 2000, /datum/material/diamond = 1250, /datum/material/uranium = 250, /datum/material/bluespace = 2000)
	build_path = /obj/item/organ/butt/bluebutt
	category = list("Блюспейс разработки", "Научное снаряжение")
	sub_category = list("Экипировка")

/datum/design/bluespace_crystal
	name = "Синтетический блюспейс кристалл"
	desc = "Искусственно сделанный блюспейс кристалл, выглядит изысканно."
	id = "bluespace_crystal"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/diamond = 1500, /datum/material/plasma = 1500)
	build_path = /obj/item/stack/ore/bluespace_crystal/artificial
	category = list("Блюспейс разработки", "Сплавы и синтез")
	sub_category = list("Синтез")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/telesci_gps
	name = "GPS - глобальная система позиционирования"
	desc = "Помогает потерянным космонавтам найти дорогу домой с 2016 года."
	id = "telesci_gps"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/gps
	category = list("Блюспейс разработки", "Инженерное снаряжение", "Научное снаряжение", "Карго снаряжение", "Снаряжение СБ")
	sub_category = list("Связь и навигация")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/desynchronizer
	name = "Десинхронизатор"
	desc = "Технология позволяющая грубо вмешаться в структуру блюспейс пространства и способная повлиять на пространственно-временной континиум. Строго запрещена космической академией наук."
	id = "desynchronizer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/silver = 1500, /datum/material/bluespace = 1000)
	build_path = /obj/item/desynchronizer
	category = list("Блюспейс разработки", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/miningsatchel_holding
	name = "Бездонная сумка для руды"
	desc = "Революция в удобстве: этот рюкзак позволяет хранить огромное количество руды. Он оборудован мерами безопасности от сбоев."
	id = "minerbag_holding"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/gold = 250, /datum/material/uranium = 500) //quite cheap, for more convenience
	build_path = /obj/item/storage/bag/ore/holding
	category = list("Блюспейс разработки", "Карго снаряжение")
	sub_category = list("Горнопромышленное снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/swapper
	name = "Квантовый инвертор"
	desc = "Экспериментальное устройство, которое способно менять местами местоположения двух объектов, изменяя значения их частиц. Для корректной работы должен быть синхронизирован с другим таким же устройством."
	id = "swapper"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000, /datum/material/bluespace = 2000, /datum/material/gold = 1500, /datum/material/silver = 1000)
	build_path = /obj/item/swapper
	category = list("Блюспейс разработки", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluemine
	name = "Блюспейс майнинг"
	desc = "Благодаря совместным усилиям Bluespace-A.S.S Technologies теперь можно добывать тонкую струйку ресурсов с помощью Блюспейс магии..."
	id = "bluemine"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/gold = 500, /datum/material/silver = 500, /datum/material/bluespace = 500) //quite cheap, for more convenience
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list("Блюспейс разработки", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO
