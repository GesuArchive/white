////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////
/datum/design/board/electrolyzer
	name = "Электролизер"
	desc = "Благодаря быстрому и динамическому реагированию наших электролизеров производство водорода на месте гарантировано. Гарантия недействительна при использовании клоунами."
	id = "electrolyzer"
	build_path = /obj/item/circuitboard/machine/electrolyzer
	category = list ("Инженерное оборудование")
	sub_category = list("АТМОС")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/smes
	name = "Сверхмощный аккумуляторный каскад (СМЕС)"
	desc = "Огромная батарея аккумуляторов, предназначеная для длительного хранения энергии, получаемой от источника питания и ее дальнейшего распределения по электрической сети."
	id = "smes"
	build_path = /obj/item/circuitboard/machine/smes
	category = list ("Инженерное оборудование")
	sub_category = list("Энергоснабжение")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
/*
/datum/design/board/enernet_control
	name = "Консоль управления энергоконцентратором"
	desc = "Используется для регулирования поступления продаваемой в общую сеть энергии."
	id = "enernet_control"
	build_path = /obj/item/circuitboard/computer/enernet_control
	category = list ("Инженерное оборудование")
	sub_category = list("Энергоснабжение")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/enernet_coil
	name = "Энергоконцентратор"
	desc = "Аккумулирует поступающую в него энергию. Требует консоль для работы."
	id = "enernet_coil"
	build_path = /obj/item/circuitboard/machine/enernet_coil
	category = list ("Инженерное оборудование")
	sub_category = list("Энергоснабжение")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
*/

/datum/design/board/circulator
	name = "Турбина ТЭГа"
	desc = "Газовый циркулятор с теплообменником."
	id = "circulator"
	build_path = /obj/item/circuitboard/machine/circulator
	category = list ("Инженерное оборудование")
	sub_category = list("ТЭГ")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/teg
	name = "Термоэлектрический генератор (ТЭГ)"
	desc = "Высокоэффективный газовый термоэлектрический генератор."
	id = "teg"
	build_path = /obj/item/circuitboard/machine/generator
	category = list ("Инженерное оборудование")
	sub_category = list("ТЭГ")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/announcement_system
	name = "Автоматизированная Система Оповещений"
	desc = "Автоматизированная Система Оповещений делает важные оповещения в радиоканалах, пока ты не трогаешь её своими грязными руками."
	id = "automated_announcement"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/announcement_system
	category = list("Подпространственная связь")
	sub_category = list("Радиорелейные платы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/turbine_computer
	name = "Консоль управления газовой турбиной"
	desc = "Компьютер для дистанционного управления газовой турбиной."
	id = "power_turbine_console"
	build_path = /obj/item/circuitboard/computer/turbine_computer
	category = list ("Инженерное оборудование", "Научное оборудование")
	sub_category = list("Газовая турбина")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/emitter
	name = "Излучатель"
	desc = "Мощный промышленный лазер, часто используемый в области силовых полей и производства электроэнергии."
	id = "emitter"
	build_path = /obj/item/circuitboard/machine/emitter
	category = list ("Инженерное оборудование", "Научное оборудование")
	sub_category = list("Сингулярность, тесла и суперматерия")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/power_compressor
	name = "Компрессор турбины"
	desc = "Компрессорная ступень газотурбинного генератора."
	id = "power_compressor"
	build_path = /obj/item/circuitboard/machine/power_compressor
	category = list ("Инженерное оборудование", "Научное оборудование")
	sub_category = list("Газовая турбина")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/power_turbine
	name = "Газотурбинный генератор"
	desc = "Газовая турбина, используемая для резервного производства электроэнергии."
	id = "power_turbine"
	build_path = /obj/item/circuitboard/machine/power_turbine
	category = list ("Инженерное оборудование", "Научное оборудование")
	sub_category = list("Газовая турбина")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/thermomachine
	name = "Термомашина"
	desc = "Нагревает или охлаждает газ в трубах. Потребляет очень много энергии."
	id = "thermomachine"
	build_type = PROTOLATHE | IMPRINTER | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/thermomachine
	category = list ("Инженерное оборудование", "Медицинское оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Терморегуляция")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/space_heater
	name = "Обогреватель"
	desc = "Обогреватель/охладитель, сделанный космическими амишами с использованием традиционных космических технологий, гарантированно не подожжет станцию. Гарантия аннулируется при использовании в двигателях."
	id = "space_heater"
	build_path = /obj/item/circuitboard/machine/space_heater
	build_type = PROTOLATHE | IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование сервиса")
	sub_category = list("Терморегуляция")
	departmental_flags = ALL

/datum/design/board/teleport_station
	name = "Телепортационная станция"
	desc = "Станция управления питанием блюспейс телепорта. Распределяет силовые нагрузки и калибрует пространственный прокол для предотвращения искажений."
	id = "tele_station"
	build_path = /obj/item/circuitboard/machine/teleporter_station
	category = list ("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/teleport_hub
	name = "Телепортационная арка"
	desc = "Открывает проход сквозь блюспейс пространство."
	id = "tele_hub"
	build_path = /obj/item/circuitboard/machine/teleporter_hub
	category = list ("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/quantumpad
	name = "Квантовый телепад"
	desc = "Квантовый блюспейс телепад, используемый для телепортации объектов на другие квантовые телепады."
	id = "quantumpad"
	build_path = /obj/item/circuitboard/machine/quantumpad
	category = list ("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/launchpad
	name = "Локальный блюспейс телепад"
	desc = "Блюспейс телепад, способный перемещать материю сквозь блюспейс. Не требует фактических координат, работает на смещении координат относительно консоли. Дальность работы зависит от деталей."
	id = "launchpad"
	build_path = /obj/item/circuitboard/machine/launchpad
	category = list ("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/launchpad_console
	name = "Консоль управления локального телепада"
	desc = "Используется для калибровки и управления блюспейс телепадом. Не требует фактических координат, работает на смещении координат относительно консоли. Дальность работы зависит от деталей."
	id = "launchpad_console"
	build_path = /obj/item/circuitboard/computer/launchpad_console
	category = list ("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/teleconsole
	name = "Консоль управления телепортом"
	desc = "Используется для управления связанными телепортационной аркой и станцией."
	id = "teleconsole"
	build_path = /obj/item/circuitboard/computer/teleporter
	category = list("Телепортация", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Телепортация")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cryotube
	name = "Криокамера"
	desc = "Огромная стеклянная колба использующая целительные свойства холода."
	id = "cryotube"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/cryo_tube
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Медицинское оборудование", "Инженерное оборудование")
	sub_category = list("Терморегуляция")

/datum/design/board/chem_dispenser
	name = "Хим-раздатчик"
	desc = "Создает и выдает химикаты."
	id = "chem_dispenser"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/chem_dispenser
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Медицинское оборудование", "Инженерное оборудование")
	sub_category = list("Химпроизводство")

/datum/design/board/chem_master
	name = "ХимМастер 3000"
	desc = "Используется для разделения химикатов и их распределения в различных состояниях."
	id = "chem_master"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	build_path = /obj/item/circuitboard/machine/chem_master
	category = list ("Медицинское оборудование", "Инженерное оборудование")
	sub_category = list("Химпроизводство")

/datum/design/board/chem_heater
	name = "Реакционная камера"
	desc = "Миниатюрная термомашина способная быстро изменять и удерживать температуру состава, а так же мануально контролировать баланс ПШ."
	id = "chem_heater"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	build_path = /obj/item/circuitboard/machine/chem_heater
	category = list ("Медицинское оборудование", "Инженерное оборудование")
	sub_category = list("Химпроизводство")

/datum/design/board/chem_mass_spec
	name = "Химический хроматограф"
	desc = "Машина разделяющая реагенты основываясь на молярной массе"
	id = "chem_mass_spec"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	build_path = /obj/item/circuitboard/machine/chem_mass_spec
	category = list ("Медицинское оборудование", "Инженерное оборудование")
	sub_category = list("Химпроизводство")

/datum/design/board/smoke_machine
	name = "Дымогенератор"
	desc = "Аппарат с установленной внутри центрифугой. Производит дым с любыми реагентами, помещенными в него вами."
	id = "smoke_machine"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/smoke_machine
	category = list ("Медицинское оборудование")
	sub_category = list("Химпроизводство")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/reagentgrinder
	name = "Миксер"
	desc = "От BlenderTech. Замиксуется? Давайте узнаем!"
	id = "reagentgrinder"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/reagentgrinder
	category = list ("Медицинское оборудование")
	sub_category = list("Химпроизводство")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/reagentgrinder/serv
	id = "reagentgrinder_serv"
	category = list ("Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/hypnochair
	name = "Допросная камера"
	desc = "Устройство, используемое для проведения \"допроса с пристрастием\" при помощи инвазивного ментального внедрения."
	id = "hypnochair"
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
	build_path = /obj/item/circuitboard/machine/hypnochair
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Различное оборудование", "Оборудование СБ")
	sub_category = list("Бриг")

/datum/design/board/biogenerator
	name = "Биореактор"
	desc = "Превращает растения в биомассу, которую можно использовать для изготовления полезных предметов."
	id = "biogenerator"
	build_path = /obj/item/circuitboard/machine/biogenerator
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/hydroponics
	name = "Лоток гидропоники"
	desc = "Это самая высокотехнологичная, автоматизированная, автономная грядка которую вы когда-либо видели."
	id = "hydro_tray"
	build_path = /obj/item/circuitboard/machine/hydroponics
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/plantgenes
	name = "Манипулятор ДНК растений"
	desc = "Позволяет работать с генетическим кодом растений для увеличения их потенциала."
	id = "plantgenes"
	build_path = /obj/item/circuitboard/machine/plantgenes
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/destructive_analyzer
	name = "Деструктивный анализатор"
	desc = "Если ты хочешь понять как работают вещи, тебе придется их сломать."
	id = "destructive_analyzer"
	build_path = /obj/item/circuitboard/machine/destructive_analyzer
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/experimentor
	name = "Э.К.С.П.Е.Р.И.Ментор"
	desc = "\"Альтернативная\" версия деструктивного анализатора с небольшой тенденцией к катастрофическому выходу из строя."
	id = "experimentor"
	build_path = /obj/item/circuitboard/machine/experimentor
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/bepis
	name = "Б.Е.П.И.С"
	desc = "Высокоточное тестирующее устройство, которое открывает секреты известной вселенной, используя два самых мощных вещества, доступных человеку: чрезмерное количество электричества и деньги."
	id = "bepis"
	build_path = /obj/item/circuitboard/machine/bepis
	category = list("Исследовательское оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/datum/design/board/protolathe
	name = "Протолат"
	desc = "Превращает сырье в полезные предметы."
	id = "protolathe"
	build_path = /obj/item/circuitboard/machine/protolathe
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/circuit_imprinter
	name = "Схемопринтер"
	desc = "Производит печатные платы для создания оборудования."
	id = "circuit_imprinter"
	build_path = /obj/item/circuitboard/machine/circuit_imprinter
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/rdservercontrol
	name = "Серверный контроллер РнД"
	desc = "Используется для доступа к серверам производственно-исследовательских баз данных."
	id = "rdservercontrol"
	build_path = /obj/item/circuitboard/computer/rdservercontrol
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/rdserver
	name = "Сервер РнД"
	desc = "Компьютерная система, работающая на развитой нейронной сети, которая обрабатывает произвольную информацию для получения данных, пригодных для разработки новых технологий. С точки зрения компьютерного ботана, оно производит очки исследований."
	id = "rdserver"
	build_path = /obj/item/circuitboard/machine/rdserver
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/mechfab
	name = "Фабрикатор экзокостюмов"
	desc = "Сложный производственный комплекс изготавливающий киборгов и огромные экзокостюмы."
	id = "mechfab"
	build_path = /obj/item/circuitboard/machine/mechfab
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Производство")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cyborgrecharger
	name = "Станция зарядки киборгов"
	desc = "Устройство, заряжающее киборгов и переснаряжающая их материалами."
	id = "cyborgrecharger"
	build_path = /obj/item/circuitboard/machine/cyborgrecharger
	category = list("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование", "Оборудование СБ")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/mech_recharger
	name = "Порт питания мехдока"
	desc = "Порт, заряжающий внутреннюю силовую ячейку меха."
	id = "mech_recharger"
	build_path = /obj/item/circuitboard/machine/mech_recharger
	category = list("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование", "Оборудование СБ")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/nanite_chamber
	name = "Нанитная камера"
	desc = "Устройство для инъекции, мониторинга и базовой настройки нанитных облаков."
	id = "nanite_chamber"
	build_path = /obj/item/circuitboard/machine/nanite_chamber
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/public_nanite_chamber
	name = "Публичная нанитная камера"
	desc = "Устройство для автоматической инъекции нанитного облака с заданым номером. Объем вводимых нанитов значительно ниже чем у стандартной камеры."
	id = "public_nanite_chamber"
	build_path = /obj/item/circuitboard/machine/public_nanite_chamber
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/nanite_programmer
	name = "Программатор нанитов"
	desc = "Устройство для изменения настроек нанитных программ хранимых на дисках."
	id = "nanite_programmer"
	build_path = /obj/item/circuitboard/machine/nanite_programmer
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/nanite_program_hub
	name = "Программный центр нанитов"
	desc = "Компилирует нанитные программы с веб-серверов и записывает их на диски."
	id = "nanite_program_hub"
	build_path = /obj/item/circuitboard/machine/nanite_program_hub
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Наниты")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/dnascanner
	name = "Манипулятор ДНК"
	desc = "При подключении к консоли позволяет видоизменять ДНК подопытного для получения ценной информации и коррекции генетического кода."
	id = "dnascanner"
	build_type = IMPRINTER | PROTOLATHE | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
	build_path = /obj/item/circuitboard/machine/dnascanner
	category = list("Исследовательское оборудование", "Медицинское оборудование", "Научное оборудование")
	sub_category = list("Биоманипулирование")

/datum/design/board/destructive_scanner
	name = "Экспериментально-деструктивный сканер"
	desc = "Гораздо более крупная версия ручного сканера, обугленная этикетка предупреждает о его разрушительных возможностях."
	id = "destructive_scanner"
	build_path = /obj/item/circuitboard/machine/destructive_scanner
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/doppler_array
	name = "ТДИМ"
	desc = "Тахионно-доплеровский исследовательский массив. Специализированная система обнаружения тахионно-доплеровских бомб, в которой используется сложное бортовое программное обеспечение для записи данных для экспериментов."
	id = "doppler_array"
	build_path = /obj/item/circuitboard/machine/doppler_array
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/tank_compressor
	name = "Компрессор"
	desc = "Сверхмощный экранированный воздушный компрессор, предназначенный для создания давления в резервуарах выше безопасного предела."
	id = "tank_compressor"
	build_path = /obj/item/circuitboard/machine/tank_compressor
	category = list("Исследовательское оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/microwave
	name = "Микроволновка"
	desc = "Готовит и варит штуки."
	id = "microwave"
	build_path = /obj/item/circuitboard/machine/microwave
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")


/datum/design/board/gibber
	name = "Мясорубка"
	desc = "Полагаю в более подробном описании не нуждается."
	id = "gibber"
	build_path = /obj/item/circuitboard/machine/gibber
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/smartfridge
	name = "Умный холодильник"
	desc = "Сохраняет холодные вещи холодными, а горячие... тоже холодными."
	id = "smartfridge"
	build_path = /obj/item/circuitboard/machine/smartfridge
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/monkey_recycler
	name = "Переработчик обезьян"
	desc = "Полезная машина, перерабатывающая мертвых обезьян в обезьяньи кубики."
	id = "monkey_recycler"
	build_path = /obj/item/circuitboard/machine/monkey_recycler
	category = list ("Различное оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/monkey_recycler/serv
	id = "monkey_recycler_serv"
	category = list ("Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/seed_extractor
	name = "Экстрактор семян"
	desc = "Извлекает и упаковывает семена из урожая."
	id = "seed_extractor"
	build_path = /obj/item/circuitboard/machine/seed_extractor
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Ботаника")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/processor
	name = "Кухонный комбайн"
	desc = "Промышленный измельчитель, используемый для обработки мяса и других продуктов. Во время работы держите руки подальше от приемника."
	id = "processor"
	build_path = /obj/item/circuitboard/machine/processor
	category = list ("Различное оборудование", "Научное оборудование")
	sub_category = list("Исследовательское оборудование")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/processor/serv
	id = "processor_serv"
	category = list ("Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/soda_dispenser
	name = "Раздатчик газировки"
	desc = "Содержит большой резервуар с безалкогольными напитками."
	id = "soda_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/beer_dispenser
	name = "Раздатчик бухлишка"
	desc = "Содержит большой резервуар ништяков."
	id = "beer_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/recycler
	name = "Мусоропереработчик"
	desc = "Большая дробильная машина, используемая для неэффективной переработки мелких предметов. Сбоку есть индикаторы."
	id = "recycler"
	build_path = /obj/item/circuitboard/machine/recycler
	category = list("Различное оборудование", "Инженерное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/scanner_gate
	name = "Сканирующая арка"
	desc = "Устройство сканирующее проходящих сквозь него пользователей и подающее звуковой сигнал при заданных параметрах."
	id = "scanner_gate"
	build_path = /obj/item/circuitboard/machine/scanner_gate
	category = list ("Различное оборудование", "Строительство", "Оборудование СБ")
	sub_category = list("Напольные конструкции")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/holopad
	name = "Голопад ИИ"
	desc = "Напольное устройство для проецирования голографических изображений."
	id = "holopad"
	build_path = /obj/item/circuitboard/machine/holopad
	category = list ("Различное оборудование", "Строительство", "Оборудование СБ")
	sub_category = list("Напольные конструкции")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/autolathe
	name = "Автолат"
	desc = "Производит изделия из металла и стекла."
	id = "autolathe"
	build_path = /obj/item/circuitboard/machine/autolathe
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/recharger
	name = "Оружейный зарядник"
	desc = "Заряжает энергетическое оружие и энергозависимую экипировку."
	id = "recharger"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000)
	build_path = /obj/item/circuitboard/machine/recharger
	category = list("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ")
	sub_category = list("Энергоснабжение")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/vendor
	name = "Частный торговый автомат"
	desc = "Комерция в действии! Вид торгового автомата можно изменить при помощи отвертки."
	id = "vendor"
	build_path = /obj/item/circuitboard/machine/vendor
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/ore_redemption
	name = "Шахтерская печь"
	desc = "Машина, которая принимает руду и мгновенно переплавляет ее в листы пригодного для обработки материала. При этом  генерируются баллы за руду, их количество зависит от редкости руды. Полученные балы можно обменять на полезную экипировку в торговом автомате шахтеров."
	id = "ore_redemption"
	build_path = /obj/item/circuitboard/machine/ore_redemption
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/mining_equipment_vendor
	name = "Торговый автомат шахтеров"
	desc = "Различное оборудование для бригады шахтеров. Очки добываются за сдачу руды в шахтерскую печь и начисляются на персональный счет шахтера."
	id = "mining_equipment_vendor"
	build_path = /obj/item/circuitboard/machine/mining_equipment_vendor
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/datum/design/board/exploration_equipment_vendor
	name = "Торговый автомат рейнджеров"
	desc = "Различное оборудование для команды исследователей глубин космоса. Очки добываются за выполнение миссий и разделяются между исследователями."
	id = "exploration_equipment_vendor"
	build_path = /obj/item/circuitboard/machine/exploration_equipment_vendor
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO

/datum/design/board/tesla_coil
	name = "Катушка Теслы"
	desc = "Преобразует удары шаровой молнии в энергию. Используйте отвертку для переключения между режимами производства электроэнергии и очков исследования."
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/machine/tesla_coil
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Сингулярность, тесла и суперматерия")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/rad_collector
	name = "Радиационный коллекторный массив"
	desc = "Устройство, которое использует излучение Хокинга и плазму для производства энергии."
	id = "rad_collector"
	build_path = /obj/item/circuitboard/machine/rad_collector
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Сингулярность, тесла и суперматерия")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/grounding_rod
	name = "Заземлитель"
	desc = "Защищает окружающее оборудование и людей от поджаривания Проклятием Эдисона."
	id = "grounding_rod"
	build_path = /obj/item/circuitboard/machine/grounding_rod
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование")
	sub_category = list("Сингулярность, тесла и суперматерия")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/ntnet_relay
	name = "Квантовое реле NTNet"
	desc = "Очень сложный маршрутизатор и передатчик, способный соединять вместе беспроводные электронные устройства. Выглядит хрупким."
	id = "ntnet_relay"
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/ntnet_relay
	category = list("Подпространственная связь")
	sub_category = list("Радиорелейные платы")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/limbgrower
	name = "Биосинтезатор"
	desc = "Выращивает органы и конечности из синтетической плоти."
	id = "limbgrower"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/limbgrower
	category = list("Медицинское оборудование")
	sub_category = list("Биоманипулирование")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/harvester
	name = "Авто-Потрошитель МК II"
	desc = "Извлекает из тела ВСЁ лишнее, включая органы, конечности и голову."
	id = "harvester"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/harvester
	category = list("Медицинское оборудование")
	sub_category = list("Автохирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/deepfryer
	name = "фритюрница"
	desc = "Жареное <i>всё</i>."
	id = "deepfryer"
	build_path = /obj/item/circuitboard/machine/deep_fryer
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/griddle
	name = "Гридль"
	desc = "Потому что сковородки для жалких лузеров."
	id = "griddle"
	build_path = /obj/item/circuitboard/machine/griddle
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/oven
	name = "Духовка"
	desc = "Не рекомендуется залезать внутрь."
	id = "oven"
	build_path = /obj/item/circuitboard/machine/oven
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/donksofttoyvendor
	name = "Торговый автомат игрушек DonkSoft"
	desc = "Утвержденный поставщик игрушек в возрасте от 8 лет и старше."
	id = "donksofttoyvendor"
	build_path = /obj/item/circuitboard/machine/vending/donksofttoyvendor
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Прочее")


/datum/design/board/cell_charger
	name = "Зарядник батарей"
	desc = "Заряжает аккумуляторные батареи, не подходит для вооружения."
	id = "cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Энергоснабжение")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40


/datum/design/board/dish_drive
	name = "утилизатор тарелок"
	desc = "Кулинарное чудо, которое использует преобразование вещества в энергию для хранения посуды и осколков. Удобно!"
	id = "dish_drive"
	build_path = /obj/item/circuitboard/machine/dish_drive
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/stacking_unit_console
	name = "Консоль штабелирующей машины"
	desc = "Управляет штабелирующей машиной... в теории."
	id = "stack_console"
	build_path = /obj/item/circuitboard/machine/stacking_unit_console
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/stacking_machine
	name = "Штабелирующая машина"
	desc = "Машина, которая автоматически упаковывает проезжающие мимо материалы. Управляется консолью."
	id = "stack_machine"
	build_path = /obj/item/circuitboard/machine/stacking_machine
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/meteor_catcher
	name = "Улавливатель метеоритов"
	desc = "Создаёт небольшое гравитационное поле вокруг себя, которое позволяет притягивать метеоры. Используйте мультитул для смены режима."
	id = "meteor_catcher"
	build_path = /obj/item/circuitboard/machine/meteor_catcher
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/ore_silo
	name = "Ресурсный бункер"
	desc = "Универсальная блюспейс система хранения и передачи ресурсов на нужды станции."
	id = "ore_silo"
	build_path = /obj/item/circuitboard/machine/ore_silo
	category = list ("Исследовательское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/paystand
	name = "Терминал оплаты"
	desc = "Налоговый сбор проверен и одобрен корпорацией Нано-Трейзен."
	id = "paystand"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/paystand
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Прочее")


/datum/design/board/fat_sucker
	name = "Авто-Экстрактор липидов МК IV"
	desc = "Безопасно и эффективно удаляет лишний жир."
	id = "fat_sucker"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/fat_sucker
	category = list ("Различное оборудование", "Медицинское оборудование", "Оборудование сервиса")
	sub_category = list("Автохирургия")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/stasis
	name = "Стазисная кровать"
	desc = "Не очень комфортная кровать, которая постоянно жужжит, однако она помещает пациента в стазис с надеждой, что когда-нибудь он все-таки дождется помощи."
	id = "stasis"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/stasis
	category = list("Медицинское оборудование")
	sub_category = list("Реанимация и хирургия")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/medical_kiosk
	name = "Медицинский киоск"
	desc = "За небольшую плату поможет продиагностировать пациента на основные виды повреждений и заболеваний."
	id = "medical_kiosk"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/medical_kiosk
	category = list ("Медицинское оборудование")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/medipen_refiller
	name = "Наполнитель медипенов"
	desc = "Машина, производящая пустые медипены, а так же перезаряжающая их химикатами. Внимание! Перезарядка осуществляется только для медипенов одобренных медицинской ассоциацией Нанотрейзен. Химический состав наполнителя должен строго соответствовать маркировке, в противном случае операция будет прервана."
	id = "medipen_refiller"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/medipen_refiller
	category = list ("Медицинское оборудование")
	sub_category = list("Химпроизводство")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/plumbing_receiver
	name = "Химический приемник"
	desc = "Принимает химикаты с маяков. Используйте мультитул для связи с маяками через буфер. Для сброса открутите крышку и перекусите главный провод."
	id = "plumbing_receiver"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	build_path = /obj/item/circuitboard/machine/plumbing_receiver
	category = list ("Медицинское оборудование", "Карго оборудование")
	sub_category = list("Химпроизводство")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/sheetifier
	name = "Листопрокатная машина"
	desc = "Строительный материал из чего угодно."
	id = "sheetifier"
	build_path = /obj/item/circuitboard/machine/sheetifier
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/restaurant_portal
	name = "Портал ресторана"
	desc = "Портал от Всемирной Организации Роботов-Гурманов!"
	id = "restaurant_portal"
	build_path = /obj/item/circuitboard/machine/restaurant_portal
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list ("Оборудование гидропоники", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")

/datum/design/board/vendatray
	name = "Торговая витрина"
	desc = "Витрина со считывателем ID карты. Используйте свою ID карту для покупки содержимого."
	id = "vendatray"
	build_path = /obj/item/circuitboard/machine/vendatray
	category = list ("Различное оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование сервиса")
	sub_category = list("Производство")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/bountypad
	name = "Гражданская платформа отправки"
	desc = "Используется для отправки груза на ЦК."
	id = "bounty_pad"
	build_path = /obj/item/circuitboard/machine/bountypad
	category = list ("Различное оборудование", "Инженерное оборудование", "Карго оборудование", "Оборудование сервиса")
	sub_category = list("Доставка")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40

/datum/design/board/skill_station
	name = "Камера имплантации чипов навыков"
	desc = "Осваивайте навыки с всего лишь мизерными шансами на повреждение головного мозга!"
	id = "skill_station"
	build_path = /obj/item/circuitboard/machine/skill_station
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Прочее")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/accounting
	name = "Регистратор учетных записей"
	desc = "Машина, которая позволяет ХоПу подключать банковский счет к новым ID-картам."
	id = "accounting"
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
	build_path = /obj/item/circuitboard/machine/accounting
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Различное оборудование", "Оборудование СБ")
	sub_category = list("Бриг")

/datum/design/board/fax
	name = "Факс"
	desc = "Блюспейс технологии применённые во имя бюрократии."
	id = "fax"
	build_path = /obj/item/circuitboard/machine/fax
	category = list ("Различное оборудование", "Медицинское оборудование", "Инженерное оборудование", "Научное оборудование", "Карго оборудование", "Оборудование СБ", "Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Прочее")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

//Hypertorus fusion reactor designs
/datum/design/board/HFR_core
	name = "Термоядерный реактор - Ядро"
	desc = "Ядро термоядерного реактора, передовая технология для точной настройки протекания реакции внутри машины. Он имеет ввод-вывод для охлаждения газов."
	id = "HFR_core"
	build_path = /obj/item/circuitboard/machine/HFR_core
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/HFR_fuel_input
	name = "Термоядерный реактор - Топливный порт"
	desc = "Входной порт термоядерного реактора, принимает исключительно водород и тритий в газообразной форме."
	id = "HFR_fuel_input"
	build_path = /obj/item/circuitboard/machine/HFR_fuel_input
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/HFR_waste_output
	name = "Термоядерный реактор - Порт вывода"
	desc = "Выпускной порт термоядерного реактора, предназначенный для вывода горячих отработанных газов, сбрасываемых из активной зоны машины."
	id = "HFR_waste_output"
	build_path = /obj/item/circuitboard/machine/HFR_waste_output
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/HFR_moderator_input
	name = "Термоядерный реактор - Порт регулятора"
	desc = "Порт регулятора термоядерного реактора, предназначенный для охлаждения и управления протекания реакции."
	id = "HFR_moderator_input"
	build_path = /obj/item/circuitboard/machine/HFR_moderator_input
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/HFR_corner
	name = "Термоядерный реактор - Корпус"
	desc = "Конструктивная часть машины."
	id = "HFR_corner"
	build_path = /obj/item/circuitboard/machine/HFR_corner
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/HFR_interface
	name = "Термоядерный реактор - Интерфейс"
	desc = "Интерфейс термоядерного реактора для управления протекания реакции."
	id = "HFR_interface"
	build_path = /obj/item/circuitboard/machine/HFR_interface
	category = list ("Инженерное оборудование")
	sub_category = list("Термоядерный реактор")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/crystallizer
	name = "Кристаллизатор"
	desc = "Используется для кристаллизации или солидификации газов."
	id = "crystallizer"
	build_path = /obj/item/circuitboard/machine/crystallizer
	category = list ("Инженерное оборудование")
	sub_category = list("АТМОС")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/exoscanner
	name = "Массив сканеров"
	desc = "Сложная сканирующая матрица. Уязвима к воздействию окружающей среды."
	id = "exoscanner"
	build_path = /obj/item/circuitboard/machine/exoscanner
	category = list ("Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Исследовательские дроны")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/exodrone_launcher
	name = "Пусковая установка дрона"
	desc = "Запускает дрона на исследовательскую миссию."
	id = "exodrone_launcher"
	build_path = /obj/item/circuitboard/machine/exodrone_launcher
	category = list ("Инженерное оборудование", "Научное оборудование", "Карго оборудование")
	sub_category = list("Исследовательские дроны")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/component_printer
	name = "Схемопринтер интегральных схем"
	desc = "Печатает различные штуки для нового типа DIY-электроники."
	id = "component_printer"
	build_path = /obj/item/circuitboard/machine/component_printer
	category = list("Различное оборудование", "Интегральные схемы")
	sub_category = list("Машины")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/module_printer
	name = "Дубликатор модулей"
	desc = "Позволяет дублировать модули, чтобы вам не приходилось создавать их  заново. Отсканируйте модуль на этой машине, чтобы добавить его к печати."
	id = "module_duplicator"
	build_path = /obj/item/circuitboard/machine/module_duplicator
	category = list("Различное оборудование", "Интегральные схемы")
	sub_category = list("Машины")
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/coffeemaker
	name = "Кофеварка"
	desc = "Плата для кофеварки."
	id = "coffeemaker"
	build_path = /obj/item/circuitboard/machine/coffeemaker
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Различное оборудование", "Оборудование сервиса")
	sub_category = list("Кухня и Бар")
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/shuttle/engine/plasma
	name = "Плазменный двигатель"
	desc = "Двигатель, который сжигает плазму, хранящуюся в располагающемся рядом предзажигателе плазменного двигателя."
	id = "engine_plasma"
	build_path = /obj/item/circuitboard/machine/shuttle/engine/plasma
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/shuttle/engine/void
	name = "Пустотный двигатель"
	desc = "Двигатель, использующий технологию для пространственного прорыва для движения."
	id = "engine_void"
	build_path = /obj/item/circuitboard/machine/shuttle/engine/void
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/shuttle/engine/heater
	name = "Предзажигатель двигателя"
	desc = "Направляет энергию в сжатые частицы для приведения в действие присоединенного двигателя."
	id = "engine_heater"
	build_path = /obj/item/circuitboard/machine/shuttle/heater
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/shuttle/engine/ion
	name = "Ионный двигатель"
	desc = "Двигатель, который выбрасывает ионы для создания тяги. Слабый, но простой в обслуживании."
	id = "engine_ion"
	build_path = /obj/item/circuitboard/machine/shuttle/engine/ion
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/shuttle/engine/ion/burst
	name = "Реактивный ионный двигатель"
	desc = "Вариант ионного двигателя, который использует значительно большую мощность для увеличения тяги."
	id = "engine_ion_burst"
	build_path = /obj/item/circuitboard/machine/shuttle/engine/ion/burst
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/shuttle/engine/charger
	name = "Конденсаторная батарея двигателя"
	desc = "Конденсаторная батарея, которая накапливает энергию для высокоэнергетических ионных двигателей."
	id = "engine_capacitors"
	build_path = /obj/item/circuitboard/machine/shuttle/capacitor_bank
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/plasma_refiner
	name = "Плазменный сублиматор"
	desc = "Сублиматор, который перерабатывает плазменные листы в плазменный газ."
	id = "plasma_refiner"
	build_path = /obj/item/circuitboard/machine/plasma_refiner
	build_type = IMPRINTER | MECHFAB
	construction_time = 40
	category = list("Спейсподы и шаттлостроение")
	sub_category = list("Шаттлостроение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE
