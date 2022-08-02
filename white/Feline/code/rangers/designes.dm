/datum/design/internals_tactical
	name = "Тактический кислородный баллон"
	desc = "Кислородный баллон военно-космического назначения."
	id = "internals_tactical"
	build_path = /obj/item/tank/internals/tactical
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/titanium = 1000)
	category = list("Снаряжение", "Инженерное снаряжение", "Карго снаряжение")
	sub_category = list("Огнетушители и газовые баллоны")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_CARGO

/datum/design/patron_belt
	name = "Патронташ"
	desc = "Компактный и очень удобный подсумок на 7 патронов 12 калибра, специальная клипса позволяет закрепить его на карманах или поясе."
	id = "patron_belt"
	build_path = /obj/item/storage/belt/shotgun
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000)
	category = list("Снаряжение", "Инженерное снаряжение", "Карго снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_CARGO

/datum/design/riot_shield
	name = "Щит антибунт"
	desc = "Тактический щит из поликарбоната для подавления мятежей. Неплохо блокирует удары в ближнем бою."
	id = "riot_shield"
	build_path = /obj/item/shield/riot
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 8000)
	category = list("Снаряжение", "Снаряжение СБ")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
