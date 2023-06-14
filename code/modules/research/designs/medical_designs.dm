/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

/datum/design/healthanalyzer
	name = "Анализатор здоровья"
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента."
	id = "healthanalyzer"
	build_type =  PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/healthanalyzer
	category = list("Медицинские разработки", "Медицинское снаряжение")
	sub_category = list("Диагностика и мониторинг")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/mmi
	name = "MMI"
	desc = "Мягкое сокращение Воина, MMI, скрывает истинный ужас этого чудовища, которое, тем не менее, стало стандартным для станций NanoTrasen."
	id = "mmi"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	construction_time = 75
	build_path = /obj/item/mmi
	category = list("Медицинские разработки", "Медицинское снаряжение", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/posibrain
	name = "Позитронный мозг"
	desc = "Сияющий куб из металла, размером он четыре дюйма и весь в красивых впалых узорах. Чудо."
	id = "mmi_posi"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 1700, /datum/material/glass = 1350, /datum/material/gold = 500) //Gold, because SWAG.
	construction_time = 75
	build_path = /obj/item/mmi/posibrain
	category = list("Медицинские разработки", "Медицинское снаряжение", "Научное снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluespacebeaker
	name = "Блюспейс химический стакан"
	desc = "химический стакан разработанный с использованием экспериментальной блюспейс технологии, вмещает до 300 единиц."
	id = "bluespacebeaker"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 5000, /datum/material/plastic = 3000, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
	category = list("Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noreactbeaker
	name = "Криостатический химический стакан"
	desc = "Химический стакан криостазиса, позволяющий хранить химикаты не начиная реакцию. Вместимость до 50 единиц."
	id = "splitbeaker"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	category = list("Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/xlarge_beaker
	name = "Огромный химический стакан"
	desc = "Огромный химический стакан, вместимостью до 120 единиц."
	id = "xlarge_beaker"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/glass = 2500, /datum/material/plastic = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/plastic
	category = list("Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")

/datum/design/meta_beaker
	name = "Метаматериальный химический стакан"
	desc = "Громадный химический стакан, вместимостью до 180 единиц."
	id = "meta_beaker"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/glass = 2500, /datum/material/plastic = 3000, /datum/material/gold = 1000, /datum/material/titanium = 1000)
	build_path = /obj/item/reagent_containers/glass/beaker/meta
	category = list("Медицинские разработки", "Фармацевтика", "Научное снаряжение", "Снаряжение сервиса")
	sub_category = list("Химическая посуда")

/datum/design/ph_meter
	name = "Химический анализатор"
	desc = "Электрод, прикрепленный к небольшой коробке, на которой будут отображаться детали раствора. Можно переключить, чтобы предоставить описание каждого из реагентов. На данный момент на экране ничего не отображается."
	id = "ph_meter"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/glass = 2500, /datum/material/gold = 1000, /datum/material/titanium = 1000)
	build_path = /obj/item/ph_meter
	category = list("Медицинские разработки", "Медицинское снаряжение")
	sub_category = list("Диагностика и мониторинг")

/datum/design/bluespacesyringe
	name = "Блюспейс-шприц"
	desc = "Эта малышка может хранить 60 единиц в себе."
	id = "bluespacesyringe"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 2000, /datum/material/plasma = 1000, /datum/material/diamond = 1000, /datum/material/bluespace = 500)
	build_path = /obj/item/reagent_containers/syringe/bluespace
	category = list("Медицинские разработки", "Фармацевтика", "Научное снаряжение")
	sub_category = list("Инъекции")

	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/dna_disk
	name = "ДНК диск"
	desc = "Хранит в себе данные о геноме подопытного."
	id = "dna_disk"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100, /datum/material/silver = 50)
	build_path = /obj/item/disk/data
	category = list("Медицинские разработки", "Медицинское снаряжение", "Научное снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/piercesyringe
	name = "Бронебойный шприц"
	desc = "Шприц с алмазным наконечником. Может хранить примерно 10 единиц."
	id = "piercesyringe"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 2000, /datum/material/diamond = 1000)
	build_path = /obj/item/reagent_containers/syringe/piercing
	category = list("Медицинские разработки", "Фармацевтика")
	sub_category = list("Инъекции")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/bluespacebodybag
	name = "Блюспейс мешок для трупов"
	desc = "Морг переполнен, а трупы уже некуда складывать? Благодаря блюспейс технологии это больше не является проблемой."
	id = "bluespacebodybag"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 3000, /datum/material/plasma = 2000, /datum/material/diamond = 500, /datum/material/bluespace = 500)
	build_path = /obj/item/bodybag/bluespace
	category = list("Медицинские разработки", "Медицинское снаряжение", "Научное снаряжение", "Снаряжение СБ")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluespacebodybag/serv
	id = "bluespacebodybag_serv"
	category = list("Рабочие инструменты     ")
	sub_category = list("Инвентарь уборщика")

/datum/design/plasmarefiller
	name = "Картридж огнетушителя плазмена"
	desc = "Картридж для перезарядки встроенного огнетушителя в комбинезоне плазменов."
	id = "plasmarefiller" //Why did this have no plasmatech
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/plasma = 1000)
	build_path = /obj/item/extinguisher_refill
	category = list("Медицинские разработки", "Прочее")


/datum/design/crewpinpointer
	name = "Продвинутый поисковый навигатор"
	desc = "Дает четкое направление на членов экипажа с подключенными датчиками жизни."
	id = "crewpinpointer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 1500, /datum/material/gold = 500)
	build_path = /obj/item/pinpointer/crew
	category = list("Медицинские разработки", "Медицинское снаряжение", "Снаряжение СБ")
	sub_category = list("Диагностика и мониторинг")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/crewpinpointerprox
	name = "Поисковый навигатор"
	desc = "Показывает приблизительное направление на членов экипажа с включенными датчиками жизни по принципу тепло-холодно."
	id = "crewpinpointerprox"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1200, /datum/material/glass = 300, /datum/material/gold = 200)
	build_path = /obj/item/pinpointer/crew/prox
	category = list("Медицинские разработки", "Медицинское снаряжение", "Снаряжение СБ")
	sub_category = list("Диагностика и мониторинг")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defibrillator
	name = "Дефибриллятор"
	desc = "Устройство генерирует короткий высоковольтный импульс, форсировано вызывающий полное сокращение миокарда. После этого сердце может продолжить работать в нормальном ритме самостоятельно."
	id = "defibrillator"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	build_path = /obj/item/defibrillator
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 4000, /datum/material/silver = 3000, /datum/material/gold = 1500)
	category = list("Медицинские разработки", "Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defibrillator_mount
	name = "Крепеж для дефибриллятора"
	desc = "Рама для закрепления дефибриллятора на стене."
	id = "defibmountdefault"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/wallframe/defib_mount
	category = list("Медицинские разработки", "Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defibrillator_mount_charging
	name = "Крепеж для дефибриллятора PENLITE"
	desc = "Рама для закрепления дефибриллятора на стене. Подключает устройство к станционной энергосети."
	id = "defibmount"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000, /datum/material/silver = 500)
	build_path = /obj/item/wallframe/defib_mount/charging
	category = list("Медицинские разработки", "Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defibrillator_compact
	name = "Компактный дефибриллятор"
	desc = "Более компактная и продвинутая версия дефибриллятора. Можно носить на поясе."
	id = "defibrillator_compact"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	build_path = /obj/item/defibrillator/compact
	materials = list(/datum/material/iron = 16000, /datum/material/glass = 8000, /datum/material/silver = 6000, /datum/material/gold = 3000)
	category = list("Медицинские разработки", "Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/genescanner
	name = "Анализатор ДНК"
	desc = "Позволяет проводить генетический анализ на лету. Если соединить это с консолью ДНК, то устройство будет получать новые данные о мутациях."
	id = "genescanner"
	build_path = /obj/item/sequence_scanner
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	category = list("Медицинские разработки", "Медицинское снаряжение", "Научное снаряжение")
	sub_category = list("Диагностика и мониторинг")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/healthanalyzer_advanced
	name = "Продвинутый анализатор здоровья"
	desc = "Ручной медицинский сканер для определения жизненных показателей пациента с более высокой точностью."
	id = "healthanalyzer_advanced"
	build_path = /obj/item/healthanalyzer/advanced
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500, /datum/material/silver = 2000, /datum/material/gold = 1500)
	category = list("Медицинские разработки", "Медицинское снаряжение")
	sub_category = list("Диагностика и мониторинг")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/medigel
	name = "Медицинский аэрозоль (пустой)"
	desc = "Аппликатор спроектированный для быстрого и точечного нанесения лекарственного состава в виде аэрозоля."
	id = "medigel"
	build_path = /obj/item/reagent_containers/medigel
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 500)
	category = list("Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/surgical_drapes
	name = "Хирургическая простыня"
	desc = "Хирургические простыни марки NanoTrasen обеспечивают оптимальную безопасность и защиту от инфекций."
	id = "surgical_drapes"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/surgical_drapes
	category = list("Медицинские разработки", "Хирургические инструменты")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/laserscalpel
	name = "Лазерный скальпель"
	desc = "Усовершенствованный скальпель, который использует лазерную технологию для резки. Переключателем можно увеличить мощность излучателя для работы с костью."
	id = "laserscalpel"
	build_path = /obj/item/scalpel/advanced
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 1500, /datum/material/silver = 2000, /datum/material/gold = 1500, /datum/material/diamond = 200, /datum/material/titanium = 4000)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/mechanicalpinches
	name = "Механический зажим"
	desc = "Сложный инструмент состоящий из шестеренок и манипуляторов."
	id = "mechanicalpinches"
	build_path = /obj/item/retractor/advanced
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 12000, /datum/material/glass = 4000, /datum/material/silver = 4000, /datum/material/titanium = 5000)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/searingtool
	name = "Лазерный прижигатель"
	desc = "Устройство, используемое для дезинфекции и прижигания раны за счёт излучения низкочастотного лазерного луча. Так же можно сфокусирувать луч до мощности небольшого зубного сверла."
	id = "searingtool"
	build_path = /obj/item/cautery/advanced
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 2000, /datum/material/plasma = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 3000)
	category = list("Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Продвинутые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/medical_spray_bottle
	name = "Медицинский спрей (пустой)"
	desc = "Бутылочка с распылителем жидкости вместо крышки."
	id = "med_spray_bottle"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/reagent_containers/spray/medical
	category = list("Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")

/datum/design/chem_pack
	name = "Химпакет (пустой)"
	desc = "Пластиковый пакет под давлением, также известный как 'химпакет' используемый для внутривенного введения медикаментов. Он снабжен термостойкой полосой. Объем 100 единиц."
	id = "chem_pack"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/reagent_containers/chem_pack
	category = list("Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")

/datum/design/blood_pack
	name = "Пакет крови (пустой)"
	desc = "Хранит кровь используемую при переливании. Должн быть зафиксирован на капельнице. Объем 200 единиц."
	id = "blood_pack"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/plastic = 1000)
	build_path = /obj/item/reagent_containers/blood
	category = list("Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")

/datum/design/portable_chem_mixer
	name = "Портативный химмастер"
	desc = "Портативное устройство для хранения и смешивания химикатов. Изначально пуст и все необходимые вещества необходимо помещать внутрь при помощи хим-стаканов."
	id = "portable_chem_mixer"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 80
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/plastic = 5000, /datum/material/iron = 10000, /datum/material/glass = 3000)
	build_path = /obj/item/storage/portable_chem_mixer
	category = list("Снаряжение", "Медицинское снаряжение")
	sub_category = list("Экипировка")

/////////////////////////////////////////
//////////Cybernetic Implants////////////
/////////////////////////////////////////

/datum/design/cyberimp_welding
	name = "Кибернетические глаза"
	desc = "Встроенные светофильтры защитят вас от сварки и вспышек, не ограничивая обзор."
	id = "ci-welding"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600, /datum/material/glass = 400)
	build_path = /obj/item/organ/eyes/robotic/shield
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_gloweyes
	name = "Люминесцирующие глаза"
	desc = "Особые светящиеся глаза, так же играют роль фонариков, однако не могут быть выключены. Цвет свечения можно изменять."
	id = "ci-gloweyes"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600, /datum/material/glass = 1000)
	build_path = /obj/item/organ/eyes/robotic/glow
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_breather
	name = "Имплант дыхательной трубки"
	desc = "Этот простой имплант добавляет к вашей спине внутренний соединитель, позволяющий использовать внутренние компоненты без маски и защищающий вас от удушья."
	id = "ci-breather"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 35
	materials = list(/datum/material/iron = 600, /datum/material/glass = 250)
	build_path = /obj/item/organ/cyberimp/mouth/breathing_tube
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_surgical
	name = "Имплант хирургических инструментов"
	desc = "Набор хирургических инструментов скрывающийся за скрытой панелью на руке пользователя."
	id = "ci-surgery"
	build_type = PROTOLATHE | MECHFAB
	materials = list (/datum/material/iron = 2500, /datum/material/glass = 1500, /datum/material/silver = 1500)
	construction_time = 100
	build_path = /obj/item/organ/cyberimp/arm/surgery
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_toolset
	name = "Имплант механических инструментов"
	desc = "Урезанная версия набора инструментов инженерного киборга, сконструированная для установки в руку. Содержит улучшенные версии всех инструментов."
	id = "ci-toolset"
	build_type = PROTOLATHE | MECHFAB
	materials = list (/datum/material/iron = 2500, /datum/material/glass = 1500, /datum/material/silver = 1500)
	construction_time = 100
	build_path = /obj/item/organ/cyberimp/arm/toolset
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_medical_hud
	name = "Имплант медицинского интерфейса"
	desc = "Выводит медицинский интерфейс поверх всего что вы видите."
	id = "ci-medhud"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 500, /datum/material/gold = 500)
	build_path = /obj/item/organ/cyberimp/eyes/hud/medical
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Дополненая реальность")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_security_hud
	name = "Имплант интерфейса службы безопасности"
	desc = "Выводит интерфейс службы безопасности поверх всего что вы видите."
	id = "ci-sechud"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 750, /datum/material/gold = 750)
	build_path = /obj/item/organ/cyberimp/eyes/hud/security
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Дополненая реальность")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_diagnostic_hud
	name = "Имплант диагностического интерфейса"
	desc = "Выводит интерфейс диагностики поверх всего что вы видите."
	id = "ci-diaghud"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 600, /datum/material/gold = 600)
	build_path = /obj/item/organ/cyberimp/eyes/hud/diagnostic
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Дополненая реальность")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_xray
	name = "Рентгеновские глаза"
	desc = "Эти кибернетические глаза дадут вам рентгеновское зрение. Моргать бесполезно."
	id = "ci-xray"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 600, /datum/material/gold = 600, /datum/material/plasma = 1000, /datum/material/uranium = 1000, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	build_path = /obj/item/organ/eyes/robotic/xray
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_thermals
	name = "Термальные глаза"
	desc = "Эти кибернетические глазные имплантаты дадут вам тепловое зрение. Зрачок с вертикальной щелью включен."
	id = "ci-thermals"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 600, /datum/material/gold = 600, /datum/material/plasma = 1000, /datum/material/diamond = 2000)
	build_path = /obj/item/organ/eyes/robotic/thermals
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_basic_eyes
	name = "Базовые кибернетические глаза"
	desc = "Примитивный прототип протеза глаз способный видеть мир лишь в черно-белых оттенках, однако люди полностью лишенные зрения будут рады и такому."
	id = "ci-basic_eyes"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 600)
	build_path = /obj/item/organ/eyes/robotic/basic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_antidrop
	name = "Имплант крепкого хвата"
	desc = "Этот кибернетический мозговой имплант заставит мышцы ваших рук сократиться, предотвращая падение предметов. Подергайте ухом, чтобы переключиться."
	id = "ci-antidrop"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 400, /datum/material/gold = 400)
	build_path = /obj/item/organ/cyberimp/brain/anti_drop
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_antistun
	name = "Имплант перезагрузки ЦНС"
	desc = "Этот имплант автоматически вернет вам контроль над центральной нервной системой, сократив время паралича при оглушении."
	id = "ci-antistun"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/silver = 500, /datum/material/gold = 1000)
	build_path = /obj/item/organ/cyberimp/brain/anti_stun
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_nutriment
	name = "Имплант питательного насоса"
	desc = "Этот имплант синтезирует и закачаивает в ваш кровосток небольшое количество питательных веществ и жидкости если вы голодаете."
	id = "ci-nutriment"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/gold = 500)
	build_path = /obj/item/organ/cyberimp/chest/nutriment
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_nutriment_plus
	name = "Имплант питательный насос ПЛЮС"
	desc = "Этот имплант полностью перекрывает все потребности в пище и жидкости."
	id = "ci-nutrimentplus"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/gold = 500, /datum/material/uranium = 750)
	build_path = /obj/item/organ/cyberimp/chest/nutriment/plus
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_reviver
	name = "Имплант реаниматор"
	desc = "Этот имплант постарается привести вас в чуство и исцелить если вы потеряете сознание. Для слабонервных!"
	id = "ci-reviver"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(/datum/material/iron = 800, /datum/material/glass = 800, /datum/material/gold = 300, /datum/material/uranium = 500)
	build_path = /obj/item/organ/cyberimp/chest/reviver
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_thrusters
	name = "Имплант маневровых двигателей"
	desc = "Имлпантируевый набор маневровых портов. Они используют газ из окружения или внутренных органов субъекта для движения в условиях нулевой гравитации."
	id = "ci-thrusters"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 80
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 2000, /datum/material/silver = 1000, /datum/material/diamond = 1000)
	build_path = /obj/item/organ/cyberimp/chest/thrusters
	category = list("Импланты", "Медицинские разработки")
	sub_category = list("Кибер Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/////////////////////////////////////////
////////////Regular Implants/////////////
/////////////////////////////////////////

/datum/design/implanter
	name = "Имплантер"
	desc = "Стерильный автоматический инъектор микроимплантов."
	id = "implanter"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 600, /datum/material/glass = 200)
	build_path = /obj/item/implanter
	category = list("Импланты", "Медицинские разработки", "Снаряжение СБ")
	sub_category = list("Микро Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/implantcase
	name = "Кейс микроимпланта"
	desc = "Удобное хранилище для имплантов."
	id = "implantcase"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/implantcase
	category = list("Импланты", "Медицинские разработки", "Снаряжение СБ")
	sub_category = list("Микро Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/implant_sadtrombone
	name = "Микроимплант - 'Грустный тромбон'"
	desc = "Добавьте чуточку драмы."
	id = "implant_trombone"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/glass = 500, /datum/material/bananium = 500)
	build_path = /obj/item/implantcase/sad_trombone
	category = list("Импланты", "Медицинские разработки", "Снаряжение СБ")
	sub_category = list("Микро Импланты")


/datum/design/implant_chem
	name = "Микроимплант - 'Химическая мина'"
	desc = "По команде вводит содержащиеся в нем химические вещества носителю."
	id = "implant_chem"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/glass = 700)
	build_path = /obj/item/implantcase/chem
	category = list("Импланты", "Медицинские разработки", "Снаряжение СБ")
	sub_category = list("Микро Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/implant_tracking
	name = "Микроимплант - 'Слежка'"
	desc = "Содержит имплант для отслеживания позиции."
	id = "implant_tracking"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/implantcase/tracking
	category = list("Импланты", "Медицинские разработки", "Снаряжение СБ")
	sub_category = list("Микро Импланты")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

//Cybernetic organs

/datum/design/cybernetic_liver
	name = "Базовая кибернетическая печень"
	desc = "Очень простое устройство, имитирующее функции печени человека. Переносит токсины несколько хуже, чем органическая печень."
	id = "cybernetic_liver"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/liver/cybernetic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Базовые кибернетические органы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cybernetic_liver/tier2
	name = "Кибернетическая печень"
	desc = "Электронное устройство, имитирующее функции печени человека. Справляется с токсинами немного лучше, чем органическая печень."
	id = "cybernetic_liver_tier2"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/liver/cybernetic/tier2
	sub_category = list("Стандартные кибернетические органы")

/datum/design/cybernetic_liver/tier3
	name = "Продвинутая кибернетическая печень"
	desc = "Усовершенствованная версия кибернетической печени, предназначенная для дальнейшего улучшения органической печени. Он устойчив к отравлению алкоголем и превосходно фильтрует токсины."
	id = "cybernetic_liver_tier3"
	construction_time = 50
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver=500)
	build_path = /obj/item/organ/liver/cybernetic/tier3
	sub_category = list("Продвинутые кибернетические органы")

/datum/design/cybernetic_heart
	name = "Базовое кибернетическое сердце"
	desc = "Базовое электронное устройство, имитирующее функции органического человеческого сердца."
	id = "cybernetic_heart"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/heart/cybernetic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Базовые кибернетические органы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cybernetic_heart/tier2
	name = "Кибернетическое сердце"
	desc = "Электронное устройство, имитирующее функции человеческого сердца. Также содержит экстренную дозу адреналина, которая используется автоматически после серьезной травмы."
	id = "cybernetic_heart_tier2"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/heart/cybernetic/tier2
	sub_category = list("Стандартные кибернетические органы")

/datum/design/cybernetic_heart/tier3
	name = "Продвинутое кибернетическое сердце"
	desc = "Электронное устройство, имитирующее функции человеческого сердца. Также содержит экстренную дозу адреналина, которая используется автоматически после серьезной травмы. Эта модернизированная модель может восстанавливать дозу после использования."
	id = "cybernetic_heart_tier3"
	construction_time = 50
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver=500)
	build_path = /obj/item/organ/heart/cybernetic/tier3
	sub_category = list("Продвинутые кибернетические органы")

/datum/design/cybernetic_lungs
	name = "Базовые кибернетические лёгкие"
	desc = "Базовая кибернетическая версия легких, встречающаяся у традиционных гуманоидных существ."
	id = "cybernetic_lungs"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/lungs/cybernetic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Базовые кибернетические органы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cybernetic_lungs/tier2
	name = "Кибернетические лёгкие"
	desc = "Кибернетическая версия легких традиционных гуманоидных существ. Позволяет потреблять больше кислорода, чем органические легкие, требуя немного меньшего давления."
	id = "cybernetic_lungs_tier2"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/lungs/cybernetic/tier2
	sub_category = list("Стандартные кибернетические органы")

/datum/design/cybernetic_lungs/tier3
	name = "Продвинутые кибернетические лёгкие"
	desc = "Более продвинутая версия штатных кибернетических легких. Отличается способностью отфильтровывать более низкие уровни токсинов и углекислого газа."
	id = "cybernetic_lungs_tier3"
	construction_time = 50
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 500)
	build_path = /obj/item/organ/lungs/cybernetic/tier3
	sub_category = list("Продвинутые кибернетические органы")

/datum/design/cybernetic_stomach
	name = "Базовый кибернетический желудок"
	desc = "Базовое устройство, имитирующее функции человеческого желудка."
	id = "cybernetic_stomach"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/stomach/cybernetic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Базовые кибернетические органы")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cybernetic_stomach/tier2
	name = "Кибернетический желудок"
	desc = "Электронное устройство, имитирующее функции человеческого желудка. Немного лучше справляется с отвратительной едой."
	id = "cybernetic_stomach_tier2"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/organ/stomach/cybernetic/tier2
	sub_category = list("Стандартные кибернетические органы")

/datum/design/cybernetic_stomach/tier3
	name = "Продвинутый кибернетический желудок"
	desc = "Усовершенствованная версия кибернетического желудка, предназначенная для дальнейшего улучшения органических желудков. Отлично справляется с отвратительной едой."
	id = "cybernetic_stomach_tier3"
	construction_time = 50
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 500)
	build_path = /obj/item/organ/stomach/cybernetic/tier3
	sub_category = list("Продвинутые кибернетические органы")

/datum/design/cybernetic_ears
	name = "Кибернетические уши"
	desc = "Основной кибернетический орган, имитирующий работу ушей."
	id = "cybernetic_ears"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 250, /datum/material/glass = 400)
	build_path = /obj/item/organ/ears/cybernetic
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cybernetic_ears_u
	name = "Продвинутые кибернетические уши"
	desc = "Усовершенствованное кибернетическое ухо, превосходящее по характеристикам обычные уши."
	id = "cybernetic_ears_u"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 500)
	build_path = /obj/item/organ/ears/cybernetic/upgraded
	category = list("Кибернетика", "Медицинские разработки")
	sub_category = list("Сенсорика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/////////////////////
///Surgery Designs///
/////////////////////

/datum/design/surgery
	name = "Surgery Design"
	desc = "what"
	id = "surgery_parent"
	research_icon = 'icons/obj/surgery.dmi'
	research_icon_state = "surgery_any"
	var/surgery

/datum/design/surgery/lobotomy
	name = "Операция на Мозге: Лоботомия"
	desc = "Инвазивная хирургическая процедура, которая гарантированно устраняет большинство травм мозга, но может привести к другому постоянному повреждению."
	id = "surgery_lobotomy"
	surgery = /datum/surgery/advanced/lobotomy
	research_icon_state = "surgery_head"

/datum/design/surgery/pacify
	name = "Операция на Мозге: Усмирение"
	desc = "Хирургическая процедура которая навсегда подавляет центр агрессии мозга, делая пациента неспособным нанести прямой вред."
	id = "surgery_pacify"
	surgery = /datum/surgery/advanced/pacify
	research_icon_state = "surgery_head"

/datum/design/surgery/viral_bonding
	name = "Вирусный Симбиоз"
	desc = "Хирургическая процедура которая устанавливает симбиотические отношения между вирусом и носителем. Пациенту должен быть введен Космоцелин, пища для вирусов и формальдегид."
	id = "surgery_viral_bond"
	surgery = /datum/surgery/advanced/viral_bonding
	research_icon_state = "surgery_chest"

/datum/design/surgery/healing //PLEASE ACCOUNT FOR UNIQUE HEALING BRANCHES IN THE hptech HREF (currently 2 for Brute/Burn; Combo is bonus)
	name = "Tend Wounds"
	desc = "An upgraded version of the original surgery."
	id = "surgery_healing_base" //holder because CI cries otherwise. Not used in techweb unlocks.
	surgery = /datum/surgery/healing
	research_icon_state = "surgery_chest"

/datum/design/surgery/healing/brute_upgrade
	name = "Лечение Ран (Ушибов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при физических ранах. Лечение более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/brute/upgraded
	id = "surgery_heal_brute_upgrade"

/datum/design/surgery/healing/brute_upgrade_2
	name = "Лечение Ран (Ушибов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при физических ранах. Лечение намного более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/brute/femto
	id = "surgery_heal_brute_upgrade_femto"

/datum/design/surgery/healing/burn_upgrade
	name = "Лечение Ран (Ожогов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при ожоговых ранах. Лечение более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/burn/upgraded
	id = "surgery_heal_burn_upgrade"

/datum/design/surgery/healing/burn_upgrade_2
	name = "Лечение Ран (Ожогов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при ожоговых ранах. Лечение намного более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/burn/femto
	id = "surgery_heal_burn_upgrade_femto"

/datum/design/surgery/healing/combo
	name = "Лечение Ран (Смешанных, Основное)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение немного более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/combo/basic
	id = "surgery_heal_combo"

/datum/design/surgery/healing/combo_upgrade
	name = "Лечение Ран (Смешанных, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/combo/upgraded
	id = "surgery_heal_combo_upgrade"

/datum/design/surgery/healing/combo_upgrade_2
	name = "Лечение Ран (Смешанных, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при смешанных физических и ожоговых ранах. Лечение намного более эффективно при серьезных травмах."
	surgery = /datum/surgery/healing/combo/femto
	id = "surgery_heal_combo_upgrade_femto"

/datum/design/surgery/brainwashing
	name = "Операция на Мозге: Промывка мозгов"
	desc = "Хирургическая процедура, которая запечатляет приказ в мозге пациента, делая его основной директивой. Эту директиву можно отменить используя имплант защиты разума."
	id = "surgery_brainwashing"
	surgery = /datum/surgery/advanced/brainwashing
	research_icon_state = "surgery_head"

/datum/design/surgery/nerve_splicing
	name = "Модифицирование: Сращивание Нервов"
	desc = "Хирургическая процедура при которой нервы пациента сращиваются, что увеличивает сопротивление оглушению."
	id = "surgery_nerve_splice"
	surgery = /datum/surgery/advanced/bioware/nerve_splicing
	research_icon_state = "surgery_chest"

/datum/design/surgery/nerve_grounding
	name = "Модифицирование: Заземление Нервов"
	desc = "Хирургическая процедура, позволяющая нервам пациента выступать в качестве заземляющих стержней, защищая их от поражения электрическим током."
	id = "surgery_nerve_ground"
	surgery = /datum/surgery/advanced/bioware/nerve_grounding
	research_icon_state = "surgery_chest"

/datum/design/surgery/vein_threading
	name = "Модифицирование: Переплетение Вен"
	desc = "Хирургическая процедура, которая значительно снижает количество теряемой крови при ранениях."
	id = "surgery_vein_thread"
	surgery = /datum/surgery/advanced/bioware/vein_threading
	research_icon_state = "surgery_chest"

/datum/design/surgery/muscled_veins
	name = "Модифицирование: Венозные Мышцы"
	desc = "Хирургическая процедура которая добавляет к кровеносным сосудам мышечные мембраны, позволяя им перекачивать кровь без участия сердца."
	id = "surgery_muscled_veins"
	surgery = /datum/surgery/advanced/bioware/muscled_veins
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_hook
	name = "Модифицирование: Крючкообразные Связки"
	desc = "Хирургическая процедура, которая изменяет форму соединения между конечностями и туловищем, благодаря чему конечности можно будет прикрепить вручную, если они оторвутся. \
	Однако, это ослабляет соединение, в результате чего конечности легче отрываются."
	id = "surgery_ligament_hook"
	surgery = /datum/surgery/advanced/bioware/ligament_hook
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_reinforcement
	name = "Модифицирование: Укрепление Связок"
	desc = "Хирургическая процедура, добавляющая защитную ткань и костяную клетку вокруг соединений туловища и конечностей, предотвращая расчленение. \
	Однако, в результате нервные соединения легче оборвать, что ведет к большему шансу вывести из строя конечности при получении урона."
	id = "surgery_ligament_reinforcement"
	surgery = /datum/surgery/advanced/bioware/ligament_reinforcement
	research_icon_state = "surgery_chest"

/datum/design/surgery/cortex_imprint
	name = "Модифицирование: Импринтинг Мозга"
	desc = "Хирургическая процедура, которая модифицирует кору большого мозга в повторяющийся нейронный паттерн, позволяющая могзу справляться с трудностями, вызванными небольшими повреждениями мозга."
	id = "surgery_cortex_imprint"
	surgery = /datum/surgery/advanced/bioware/cortex_imprint
	research_icon_state = "surgery_head"

/datum/design/surgery/cortex_folding
	name = "Модифицирование: Сгибание Коры"
	desc = "Хирургическая процедура, при которой кора сгибается в сложную извилину, что открывает возможность образования нестандартных нейронных паттернов."
	id = "surgery_cortex_folding"
	surgery = /datum/surgery/advanced/bioware/cortex_folding
	research_icon_state = "surgery_head"

/datum/design/surgery/necrotic_revival
	name = "Некротическое воскрешение"
	desc = "Экспериментальная хирургическая процедура, которая стимулирует рост опухоли Ромерола внутри мозга пациента. Требует порошок зомби или Резадон."
	id = "surgery_zombie"
	surgery = /datum/surgery/advanced/necrotic_revival
	research_icon_state = "surgery_head"

/datum/design/surgery/wing_reconstruction
	name = "Восстановление Крыльев"
	desc = "Экспериментальная хирургическая процедура, которая восстанавливает поврежденные крылья мотыльков. Требует Синтплоть."
	id = "surgery_wing_reconstruction"
	surgery = /datum/surgery/advanced/wing_reconstruction
	research_icon_state = "surgery_chest"
