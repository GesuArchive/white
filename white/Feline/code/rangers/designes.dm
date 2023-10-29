/datum/design/internals_tactical
	name = "Тактический кислородный баллон"
	desc = "Кислородный баллон военно-космического назначения."
	id = "internals_tactical"
	build_path = /obj/item/tank/internals/tactical
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/titanium = 1000)
	category = list("Снаряжение", "Инженерное снаряжение", "Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Огнетушители и газовые баллоны")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_CARGO

/datum/design/patron_belt
	name = "Патронташ"
	desc = "Компактный и очень удобный подсумок на 7 патронов 12 калибра, специальная клипса позволяет закрепить его на карманах или поясе."
	id = "patron_belt"
	build_path = /obj/item/storage/belt/shotgun
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000)
	category = list("Снаряжение", "Инженерное снаряжение", "Карго снаряжение", "Снаряжение СБ", "Снаряжение сервиса")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_CARGO

/datum/design/riot_shield
	name = "Щит антибунт"
	desc = "Тактический щит из поликарбоната для подавления мятежей. Неплохо блокирует удары в ближнем бою."
	id = "riot_shield"
	build_path = /obj/item/shield/riot
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 8000)
	category = list("Снаряжение", "Снаряжение СБ")
	sub_category = list("Щиты и бронепластины")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pneumatic_seal_sb
	name = "Пневматический замок СБ"
	desc = "Модернизированная скоба, используемая для блокировки шлюза. В отличии от стандартной модели оснащен сканером карт доступа. Офицеры СБ и командный состав могут заблокировать замок своей ID-картой."
	id = "pneumatic_seal_sb"
	build_path = /obj/item/door_seal/sb
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 8000, /datum/material/titanium = 6000, /datum/material/plasma = 5000)
	category = list("Снаряжение СБ")
	sub_category = list("Фортификация и блокировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/kursk
	name = "К.У.Р.С.К"
	desc = "Компактный Универсальный Рубежный Саморазвертывающийся Комплекс. Незаменим для быстрой постройки укреплений."
	id = "kursk"
	build_path = /obj/item/quikdeploy/cade/plasteel
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 30000, /datum/material/glass = 5000, /datum/material/titanium = 10000, /datum/material/plasma = 10000)
	category = list("Снаряжение СБ")
	sub_category = list("Фортификация и блокировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/portable_recharger
	name = "Портативная зарядная станция"
	desc = "Переносной двухпортовый оружейный зарядник. Питание осуществляется от станционной сети. В качестве резервного источника питания используется встроенная батарея. Для начала работы необходимо разложить в любом подходящем месте."
	id = "portable_recharger"
	build_path = /obj/item/circuitboard/machine/portable_recharger
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 1000)
	category = list("Оборудование СБ")
	sub_category = list("Энергоснабжение")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/tactical_recharger
	name = "Тактический оружейный зарядник"
	desc = "Продвинутая переносная зарядная станция для энергетического оружия. Скорость зарядки немного ниже по сравнению с более крупными образцами, однако ее использование все равно значительно расширяет общую потенциальную емкость энергетического оружия."
	id = "tactical_recharger"
	build_path = /obj/item/tactical_recharger
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 30000, /datum/material/glass = 5000, /datum/material/titanium = 10000, /datum/material/plasma = 10000)
	category = list("Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/armor_plate_plasteel
	name = "Пласталевая бронепластина"
	desc = "Ударостойкий броневой лист с демпферным подбоем. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от атак в <B>ближнем бою</B>. Особо эффективна на слабозащищенных комплектах."
	id = "armor_plate_plasteel"
	build_path = /obj/item/stack/sheet/armor_plate/plasteel
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/plasma = 20000, /datum/material/titanium = 2000)
	category = list("Снаряжение", "Снаряжение СБ")
	sub_category = list("Щиты и бронепластины")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/armor_plate_ceramic
	name = "Керамическая бронепластина"
	desc = "Керамическая чешуя закрепленная на пуленепробиваемой основе. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от <B>пуль и взрывов</B>. Особо эффективна на слабозащищенных комплектах."
	id = "armor_plate_ceramic"
	build_path = /obj/item/stack/sheet/armor_plate/ceramic
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/plasma = 10000, /datum/material/iron = 30000,  /datum/material/glass = 20000)
	category = list("Снаряжение", "Снаряжение СБ")
	sub_category = list("Щиты и бронепластины")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/armor_plate_ablative
	name = "Зеркальная бронепластина"
	desc = "Блестящая зеркальная рефракционная сетка с радиаторами. При закреплении на <B>бронежилетах</B> или <B>скафандрах</B> предоставляет дополнительную защиту от <B>лазеров и парализаторов</B>. Особо эффективна на слабозащищенных комплектах."
	id = "armor_plate_ablative"
	build_path = /obj/item/stack/sheet/armor_plate/ablative
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/titanium = 20000, /datum/material/plasma = 20000)
	category = list("Снаряжение", "Снаряжение СБ")
	sub_category = list("Щиты и бронепластины")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
