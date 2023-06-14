
/////////////////////////////////////////
/////////////////Tools///////////////////
/////////////////////////////////////////

/datum/design/handdrill
	name = "Шуруповерт"
	desc = "Удобный и компактный инструмент со сменными насадками."
	id = "handdrill"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3500, /datum/material/silver = 1500, /datum/material/titanium = 2500)
	build_path = /obj/item/screwdriver/power
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/jawsoflife
	name = "Гидравлические ножницы"
	desc = "Спасательный инструмент для выламывания и перекусывания конструкций, форсированного открытия шлюзов и демонтажа оборудования."
	id = "jawsoflife" // added one more requirment since the Jaws of Life are a bit OP
	build_path = /obj/item/crowbar/power
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4500, /datum/material/silver = 2500, /datum/material/titanium = 3500)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/exwelder
	name = "Экспериментальный сварочный аппарат"
	desc = "Экспериментальный сварочный аппарат, способный самостоятельно генерировать топливо и менее вредный для глаз."
	id = "exwelder"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/plasma = 1500, /datum/material/uranium = 200)
	build_path = /obj/item/weldingtool/experimental
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/tricorder
	name = "Трикодер"
	desc = "Многофункциональное устройство, которое может выполнять огромный спектр задач."
	id = "tricorder"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/silver = 300, /datum/material/gold = 300)
	build_path = /obj/item/multitool/tricorder
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rpd
	name = "РПД - портативный раздатчик труб"
	desc = "Компактный и удобный инструмент для прокладки любых коммуникаций."
	id = "rpd_loaded"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75000, /datum/material/glass = 37500)
	build_path = /obj/item/pipe_dispenser
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты   ")
	sub_category = list("Монтажные комплексы")
	departmental_flags =  DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/rcd_loaded
	name = "РЦД - автоматический строительный комплекс"
	desc = "Многофункциональный инструмент для быстрого строительства и разбора базовых конструкций, можно загрузить дополнительные чертежи."
	id = "rcd_loaded"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 60000, /datum/material/glass = 5000)  // costs more than what it did in the autolathe, this one comes loaded.
	build_path = /obj/item/construction/rcd/loaded
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты   ")
	sub_category = list("Монтажные комплексы")
	departmental_flags =  DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO


/datum/design/rcd_upgrade/frames
	name = "Диск с чертежами для РЦД - Машиностроение"
	desc = "Он содержит чертежи для машинных и компьютерных каркасов."
	id = "rcd_upgrade_frames"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500, /datum/material/silver = 1500, /datum/material/titanium = 2000)
	build_path = /obj/item/rcd_upgrade/frames
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Обслуживание монтажных комплексов")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rcd_upgrade/simple_circuits
	name = "Диск с чертежами для РЦД - Контролеры"
	desc = "Он чертежи для плат пожарных шлюзов, контролера АТМОСа, пожарной сигнализации, контролера электропитания и даже синтеза примитивных батарей."
	id = "rcd_upgrade_simple_circuits"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500, /datum/material/silver = 1500, /datum/material/titanium = 2000)
	build_path = /obj/item/rcd_upgrade/simple_circuits
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Обслуживание монтажных комплексов")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rcd_upgrade/furnishing
	name = "Диск с чертежами для РЦД - Мебель"
	desc = "Он содержит дизайн стульев, табуреток, столов и стеклянных столов."
	id = "rcd_upgrade_furnishing"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500, /datum/material/silver = 1500, /datum/material/titanium = 2000)
	build_path = /obj/item/rcd_upgrade/furnishing
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Обслуживание монтажных комплексов")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rcd_upgrade/silo_link
	name = "Диск с чертежами для РЦД - Сило-линк"
	desc = "Он содержит обновление для прямого подключения к хранилищу ресурсов. Связь осуществляется мультитулом."
	id = "rcd_upgrade_silo_link"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 2500, /datum/material/silver = 2500, /datum/material/titanium = 2500, /datum/material/bluespace = 2500)
	build_path = /obj/item/rcd_upgrade/silo_link
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Обслуживание монтажных комплексов")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rpd_upgrade/unwrench
	name = "Диск с чертежами для РПД - Деконструкция"
	desc = "Добавляет режим обратного ключа в RPD. Внимание, из-за сокращения бюджета режим жестко связан с кнопкой управления режимом уничтожения."
	id = "rpd_upgrade_unwrench"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/rpd_upgrade/unwrench
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Обслуживание монтажных комплексов")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/rld_mini
	name = "РЛД - Светопостановщик"
	desc = "Устройство для быстрого монтажа импровизированного освещения. Чертежи выкуплены у компании Б.Е.П.И.С."
	id = "rld"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 20000, /datum/material/glass = 10000, /datum/material/plastic = 8000, /datum/material/gold = 2000)
	build_path = /obj/item/construction/rld
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ", "Рабочие инструменты   ", "Рабочие инструменты     ")
	sub_category = list("Монтажные комплексы")
	departmental_flags =  DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/geneshears
	name = "Ботаногенетические ножницы"
	desc = "Высокотехнологичные ножницы, которые позволяет вырезать гены из растения"
	id = "gene_shears"
	build_path = /obj/item/geneshears
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron=4000, /datum/material/uranium=1500, /datum/material/silver=500)
	category = list("Рабочие инструменты", "Снаряжение сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/crystal_stabilizer
	name = "Стабилизатор Суперматерии"
	desc = "Используется, когда Матрица Сверхматерии начинает достигать точки разрушения."
	id = "crystal_stabilizer"
	build_path = /obj/item/crystal_stabilizer
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 4500, /datum/material/silver = 2500)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plumbing_rcd_sci
	name = "Хим-фаб конструктор (научный)"
	desc = "Тип Хим-фаб конструктора, предназначенный для быстрого развертывания машин, необходимых для проведения цитологических исследований."
	id = "plumbing_rcd_sci"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 75000, /datum/material/glass = 37500, /datum/material/plastic = 1000)
	build_path = /obj/item/construction/plumbing/research
	category = list("Рабочие инструменты", "Научное оборудование")
	sub_category = list("Хим-фабрика")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/biopsy_tool
	name = "Инструмент для биопсии"
	desc = "Не волнуйся, это не будет больно."
	id = "biopsy_tool"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 3000)
	build_path = /obj/item/biopsy_tool
	category = list("Рабочие инструменты", "Рабочие инструменты  ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/////////////////////////////////////////
//////////////Alien Tools////////////////
/////////////////////////////////////////

/datum/design/alienwrench
	name = "Инопланетный гаечный ключ"
	desc = "Поляризованный ключ. Это приводит к тому, что все, что находится между полюсами, поворачивается."
	id = "alien_wrench"
	build_path = /obj/item/wrench/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/alienwirecutters
	name = "Инопланетные кусачки"
	desc = "Очень острые канаторезы, изготовленные из серебристо-зеленого металла."
	id = "alien_wirecutters"
	build_path = /obj/item/wirecutters/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/alienscrewdriver
	name = "Инопланетная отвёртка"
	desc = "Похожа на экспериментальную сверхзвуковую отвертку."
	id = "alien_screwdriver"
	build_path = /obj/item/screwdriver/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/aliencrowbar
	name = "Инопланетный лом"
	desc = "Жесткий лёгкий ломик. Похоже, он работает сам по себе, даже не нужно прилагать никаких усилий."
	id = "alien_crowbar"
	build_path = /obj/item/crowbar/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/alienwelder
	name = "Инопланетная сварка"
	desc = "Инопланетный сварочный инструмент. Какое бы топливо он ни использовал, оно у него никогда не заканчивается."
	id = "alien_welder"
	build_path = /obj/item/weldingtool/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 5000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/alienmultitool
	name = "Инопланетный мультитул"
	desc = "Омни-технологический интерфейс."
	id = "alien_multitool"
	build_path = /obj/item/multitool/abductor
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/silver = 2500, /datum/material/plasma = 5000, /datum/material/titanium = 2000, /datum/material/diamond = 2000)
	category = list("Рабочие инструменты", "Рабочие инструменты ", "Рабочие инструменты  ")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/////////////////////////////////////////
/////////Alien Surgical Tools////////////
/////////////////////////////////////////

/datum/design/alienscalpel
	name = "Инопланетный скальпель"
	desc = "Сверкающий острый нож, сделанный из серебристо-зеленого металла."
	id = "alien_scalpel"
	build_path = /obj/item/scalpel/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 1500, /datum/material/plasma = 500, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/alienhemostat
	name = "Инопланетный зажим"
	desc = "Как эта штука вообще работает?"
	id = "alien_hemostat"
	build_path = /obj/item/hemostat/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 1500, /datum/material/plasma = 500, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/alienretractor
	name = "Инопланетный расширитель"
	desc = "Вы точно не хотите знать как эта штука работает."
	id = "alien_retractor"
	build_path = /obj/item/retractor/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 1500, /datum/material/plasma = 500, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/aliensaw
	name = "Инопланетная пила"
	desc = "Уберите это от меня!"
	id = "alien_saw"
	build_path = /obj/item/circular_saw/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/aliendrill
	name = "Инопланетная дрель"
	desc = "Может хотя бы инопланетяне знают зачем нужна хирургическая дрель?"
	id = "alien_drill"
	build_path = /obj/item/surgicaldrill/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/silver = 2500, /datum/material/plasma = 1000, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/aliencautery
	name = "Инопланетный прижигатель"
	desc = "Зачем вообще инопланетянам инструмент для остановки кровотечений? Разве только для..."
	id = "alien_cautery"
	build_path = /obj/item/cautery/alien
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 1500, /datum/material/plasma = 500, /datum/material/titanium = 1500)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Инопланетные инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/discoveryscanner
	name = "Нюхер"
	desc = "Используется учёными для сканирования различных артефактов и неизвестных форм жизни."
	id = "discovery_scanner"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200, /datum/material/glass = 50)
	build_path = /obj/item/discovery_scanner
	category = list("Рабочие инструменты", "Рабочие инструменты  ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/shuttlecreator
	name = "Набор сделай сам - \"шаттлостроение\""
	desc = "Устройство, используемое для определения области, необходимой для нестандартных судов. Использует блюспейс кристаллы для создания космических кораблей."
	id = "shuttle_creator"
	build_path = /obj/item/shuttle_creator
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 8000, /datum/material/titanium = 5000, /datum/material/bluespace = 5000)
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/navmap
	name = "Голо-навигационная карта"
	desc = "Голографическая карта-планшет, показывающая информацию об окружающем вас пространстве."
	id = "orbital_map"
	build_path = /obj/item/navigation_map
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/plastic = 1000)
	category = list("Карго снаряжение")
	sub_category = list("Экипировка")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO
