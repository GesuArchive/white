///////////////////Computer Boards///////////////////////////////////

/datum/design/board
	name = "Дизайн консоли ( NULL ENTRY )"
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000)

/datum/design/board/arcade_battle
	name = "Аркадный автомат"
	desc = "Не поддерживает Пинбол."
	id = "arcade_battle"
	build_path = /obj/item/circuitboard/computer/arcade/battle
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование сервиса")
	sub_category = list("Игровые автоматы")

/datum/design/board/orion_trail
	name = "Пояс Ориона"
	desc = "Узнайте, как наши предки попали на Орион, и получайте удовольствие в процессе!"
	id = "arcade_orion"
	build_path = /obj/item/circuitboard/computer/arcade/orion_trail
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование сервиса")
	sub_category = list("Игровые автоматы")

/datum/design/board/seccamera
	name = "Консоль камер видеонаблюдения"
	desc = "Используется для доступа к различным камерам на станции."
	id = "seccamera"
	build_path = /obj/item/circuitboard/computer/security
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/rdcamera
	name = "Консоль исследовательской камеры"
	desc = "Используется для доступа к различным камерам в РнД."
	id = "rdcamera"
	build_path = /obj/item/circuitboard/computer/research
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/xenobiocamera
	name = "Консоль манипуляции слаймов"
	desc = "Компьютер, используемый для наблюдения и перемещения слаймов."
	id = "xenobioconsole"
	build_path = /obj/item/circuitboard/computer/xenobiology
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/aiupload
	name = "Консоль загрузки законов ИИ"
	desc = "Используется для обновления законов искусственного интеллекта станции."
	id = "aiupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/aiupload
	category = list("Консоли")	//только в схемопринтере
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/borgupload
	name = "Консоль загрузки законов Киборгов"
	desc = "Используется для обновления законов Киборгов станции."
	id = "borgupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/borgupload
	category = list("Консоли")	//только в схемопринтере
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/med_data
	name = "Консоль Медицинских записей"
	desc = "Используется для просмотра больничных карт и биометрических данных членов экипажа."
	id = "med_data"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/computer/med_data
	category = list("Консоли", "Медицинское оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/operating
	name = "Операционный компьютер"
	desc = "Контролирует жизненно важные функции пациента и отображает этапы операции. Может быть загружен хирургическими дисками для выполнения экспериментальных процедур. Автоматически синхронизируется со стазис-кроватями в пределах прямой видимости для улучшения хирургических технологий."
	id = "operating"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/computer/operating
	category = list("Консоли", "Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/pandemic
	name = "П.А.Н.Д.Е.М.И.К.А 2200"
	desc = "Используется при работе с вирусами."
	id = "pandemic"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/computer/pandemic
	category = list("Консоли", "Медицинское оборудование")
	sub_category = list("Биоманипулирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/scan_console
	name = "Консоль сканера ДНК"
	desc = "Отображает визуальную информацию о генетической структуре подопытного, позволяет вносить изменения и синтезировать мутаторы. Для разблокировки полного функционала требует подключения к манипулятору ДНК. Поддерживает синхронизацию с компактным сканером ДНК."
	id = "scan_console"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/computer/scan_consolenew
	category = list("Консоли", "Медицинское оборудование", "Научное оборудование")
	sub_category = list("Биоманипулирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL |DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/comconsole
	name = "Консоль связи"
	desc = "Консоль, используемая для высокоприоритетных объявлений и чрезвычайных ситуаций."
	id = "comconsole"
	build_path = /obj/item/circuitboard/computer/communications
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SECURITY				//Honestly should have a bridge techfab for this sometime.

/datum/design/board/crewconsole
	name = "Консоль мониторинга за экипажем"
	desc = "Используется для контроля активных датчиков здоровья, встроенных в большую часть формы экипажа."
	id = "crewconsole"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/computer/crew
	category = list("Консоли", "Медицинское оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/secdata
	name = "Консоль записей СБ"
	desc = "Используется для просмотра и редактирования записей о правонарушениях и личных дел персонала."
	id = "secdata"
	build_path = /obj/item/circuitboard/computer/secure_data
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/atmosalerts
	name = "Консоль тревог АТМОСа"
	desc = "Используется для контроля воздушной сигнализации станции."
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/computer/atmos_alert
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/atmos_control
	name = "Консоль мониторинга АТМОСа"
	desc = "Используется для мониторинга атмосферных датчиков станции."
	id = "atmos_control"
	build_path = /obj/item/circuitboard/computer/atmos_control
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/robocontrol
	name = "Консоль контроля киборгов"
	desc = "Используется для дистанционного блокирования или подрыва киборгов и ботов."
	id = "robocontrol"
	build_path = /obj/item/circuitboard/computer/robotics
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/slot_machine
	name = "Однорукий бандит"
	desc = "Для самых смелых."
	id = "slotmachine"
	build_path = /obj/item/circuitboard/computer/slot_machine
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование сервиса")
	sub_category = list("Игровые автоматы")


/datum/design/board/powermonitor
	name = "Консоль контроля энергии"
	desc = "Эта консоль показывает состояние энергии на станции."
	id = "powermonitor"
	build_path = /obj/item/circuitboard/computer/powermonitor
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/solarcontrol
	name = "Консоль управления солнечными панелями"
	desc = "Управления азимутом поворота в автоматическом режиме."
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/computer/solar_control
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/prisonmanage
	name = "Консоль мониторинга заключенных"
	desc = "Используется для управления отслеживающими имплантатами, имплантированным преступникам."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/computer/prisoner
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/mechacontrol
	name = "Консоль управления экзоскостюмами"
	desc = "Используется для удаленного отслеживания местоположения или блокировки экзокостюмов с подключенными маячками слежения."
	id = "mechacontrol"
	build_path = /obj/item/circuitboard/computer/mecha_control
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/mechapower
	name = "Консоль зарядки мехдока"
	desc = "Отображает состояние мехов, подключенных к зарядной станции."
	id = "mechapower"
	build_path = /obj/item/circuitboard/computer/mech_bay_power_console
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование", "Научное оборудование", "Оборудование СБ")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/rdconsole
	name = "Консоль РнД"
	desc = "Консоль, используемая для взаимодействия с инструментами РнД."
	id = "rdconsole"
	build_path = /obj/item/circuitboard/computer/rdconsole
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cargo
	name = "Консоль снабжения"
	desc = "Используется для заказа расходных материалов, утверждения заявок и управления шаттлом."
	id = "cargo"
	build_path = /obj/item/circuitboard/computer/cargo
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование", "Карго оборудование")
	sub_category = list("Доставка")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/objective
	name = "Консоль заданий"
	desc = "Консоль, которая загружает список свежих заданий от Центрального Командования."
	id = "objective"
	build_path = /obj/item/circuitboard/computer/objective
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Научное оборудование", "Карго оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cargorequest
	name = "Консоль запросов снабжения"
	desc = "Используется для запроса припасов."
	id = "cargorequest"
	build_path = /obj/item/circuitboard/computer/cargo/request
	category = list("Консоли", "Карго оборудование")
	sub_category = list("Доставка")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/mining
	name = "Консоль камер шахты"
	desc = "Используется для доступа к различным камерам на шахтерском аванпосте."
	id = "mining"
	build_path = /obj/item/circuitboard/computer/mining
	category = list("Консоли", "Карго оборудование", "Оборудование СБ")
	sub_category = list("Консоли")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/comm_monitor
	name = "Консоль мониторинга телекоммуникаций"
	desc = "Отслеживает параметры телекоммуникационной сети, с которой она синхронизирована."
	id = "comm_monitor"
	build_path = /obj/item/circuitboard/computer/comm_monitor
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Подпространственная связь")
	sub_category = list("Радиорелейные платы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/comm_server
	name = "Консоль контроля телекоммуникационных серверов"
	desc = "Содержит полный доступ ко всем данным и записям телекоммуникационной сети, которую контролирует эта консоль."
	id = "comm_server"
	build_path = /obj/item/circuitboard/computer/comm_server
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Подпространственная связь")
	sub_category = list("Радиорелейные платы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/message_monitor
	name = "Консоль монитора сообщений"
	desc = "Используется для отслеживания сообщений КПК экипажа, а также для запроса консольных сообщений."
	id = "message_monitor"
	build_path = /obj/item/circuitboard/computer/message_monitor
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Подпространственная связь")
	sub_category = list("Радиорелейные платы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/aifixer
	name = "Консоль восстановления целостности ИИ"
	desc = "Используется с интелкартами, для восстановления поврежденных ИИ до рабочего состояния."
	id = "aifixer"
	build_path = /obj/item/circuitboard/computer/aifixer
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/libraryconsole
	name = "Консоль для посетителей библиотеки"
	desc = "Выписанные книги ДОЛЖНЫ быть возвращены вовремя."
	id = "libraryconsole"
	build_path = /obj/item/circuitboard/computer/libraryconsole
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование сервиса")
	sub_category = list("Прочее")


/datum/design/board/apc_control
	name = "Консоль управления энергопотреблением"
	desc = "Используется для дистанционного управления подачи электроэнергии в различные части станции."
	id = "apc_control"
	build_path = /obj/item/circuitboard/computer/apc_control
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Инженерное оборудование")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/nanite_chamber_control
	name = "Консоль управления нанитной камерой"
	desc = "Управляет нанитной камерой. Может имплантировать наниты, задавать текущее программное облако и анализировать существующие нанитные программы."
	id = "nanite_chamber_control"
	build_path = /obj/item/circuitboard/computer/nanite_chamber_control
	category = list("Консоли", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/nanite_cloud_control
	name = "Облачный контролер нанитов"
	desc = "Хранит в себе резервные копии облаков нанитных программ. Уничтожение может вызвать массовый отказ нанитов у активных пользователей."
	id = "nanite_cloud_control"
	build_path = /obj/item/circuitboard/computer/nanite_cloud_controller
	category = list("Консоли", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/advanced_camera
	name = "Продвинутая консоль управления камер"
	desc = "Используется для доступа к различным камерам на станции. Продвинутая версия обладает более удобным интерфейсом."
	id = "advanced_camera"
	build_path = /obj/item/circuitboard/computer/advanced_camera
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Оборудование СБ")
	sub_category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/price_controller
	name = "Контроллер цен"
	desc = "Используется для искусственных манипуляций внутренним рынком."
	id = "price_controller"
	build_path = /obj/item/circuitboard/computer/price_controller
	category = list("Консоли", "Инженерное оборудование", "Карго оборудование")
	sub_category = list("Консоли")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/bountypad_control
	name = "Гражданский терминал заказов"
	desc = "Консоль, которая предоставляет персоналу возможность выполнять небольшие поручения, достаточно лишь вставить свою ID-карту."
	id = "bounty_pad_control"
	build_path = /obj/item/circuitboard/computer/bountypad
	category = list("Консоли", "Инженерное оборудование", "Карго оборудование")
	sub_category = list("Доставка")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/bounty
	name = "Консоль заказов с ЦК"
	desc = "Используется для проверки и выполнений заказов ЦК"
	id = "bounty"
	build_path = /obj/item/circuitboard/computer/bounty
	category = list("Консоли", "Инженерное оборудование", "Карго оборудование", "Оборудование сервиса")
	sub_category = list("Доставка")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/exoscanner_console
	name = "Консоль управления массивом сканеров"
	desc = "Используется для сканирования и отправки разведывательных дронов."
	id = "exoscanner_console"
	build_path = /obj/item/circuitboard/computer/exoscanner_console
	category = list("Консоли", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Исследовательские дроны")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/exodrone_console
	name = "Консоль управления исследовательским дроном"
	desc = "Управляйте исследовательскими дронами с межзвездных расстояний. Задержка в комплект не входит."
	id = "exodrone_console"
	build_path = /obj/item/circuitboard/computer/exodrone_console
	category = list("Консоли", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Исследовательские дроны")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/shuttle/flight_control
	name = "Консоль управления шаттлом"
	desc = "Терминал управления шаттлом из комплекта Сделай сам - шаттлостроение."
	id = "shuttle_control"
	build_path = /obj/item/circuitboard/computer/shuttle/flight_control
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Консоли", "Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING
