//Command

/obj/item/circuitboard/machine/bsa/back
	name = "Генератор орудия"
	desc = "Генерирует пушечный импульс. Должен быть соединен с фузором."
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/back //No freebies!
	req_components = list(
		/obj/item/stock_parts/capacitor/quadratic = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/front
	name = "Ствол орудия"
	desc = "Не стойте перед пушкой во время выстрела. Должен быть соединен с фузором."
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/front
	req_components = list(
		/obj/item/stock_parts/manipulator/femto = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/middle
	name = "Фузор орудия"
	desc = "Содержание засекречено командованием Нанотрейзен. Должен быть соеденен с другим частями БСА с помощью мультитула."
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/middle
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 20,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/dna_vault
	name = "Банк ДНК"
	desc = "Разбить стекло в случае апокалипсиса."
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/dna_vault //No freebies!
	req_components = list(
		/obj/item/stock_parts/capacitor/super = 5,
		/obj/item/stock_parts/manipulator/pico = 5,
		/obj/item/stack/cable_coil = 2)

//Engineering

/obj/item/circuitboard/machine/announcement_system
	name = "Автоматизированная Система Оповещений"
	desc = "Автоматизированная Система Оповещений делает важные оповещения в радиоканалах, пока ты не трогаешь её своими грязными руками."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/announcement_system
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/autolathe
	name = "автолат"
	desc = "Производит изделия из металла и стекла."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/autolathe
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/grounding_rod
	name = "Заземлитель"
	desc = "Защищает окружающее оборудование и людей от поджаривания Проклятием Эдисона."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/grounding_rod
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE


/obj/item/circuitboard/machine/telecomms/broadcaster
	name = "Подпространственный вещатель"
	desc = "Машина в форме тарелки, используемая для передачи обработанных подпространственных сигналов."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/broadcaster
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/telecomms/bus
	name = "Мэйнфрейм шины"
	desc = "Мощное аппаратное обеспечение, используемое для быстрой передачи огромных объемов данных и связывание машин в общую сеть."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/bus
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/telecomms/hub
	name = "Телекоммуникационный узел"
	desc = "Мощное аппаратное обеспечение, используемое для отправки / приема огромных объемов данных."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/hub
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/message_server
	name = "Сервер месенджера"
	desc = "Машина, которая обрабатывает и маршрутизирует сообщения КПК и запрашивает консольные сообщения."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/message_server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 3)

/obj/item/circuitboard/machine/telecomms/processor
	name = "Процессорный блок"
	desc = "Эта машина используется для обработки больших объемов информации."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/processor
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 2,
		/obj/item/stock_parts/subspace/analyzer = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/amplifier = 1)

/obj/item/circuitboard/machine/telecomms/receiver
	name = "Подпространственный приемник"
	desc = "Эта машина имеет форму тарелкообразной приемной антенны и зеленые огоньки. Предназначена для приема и обработки подпространственного радиосигнала."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/receiver
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/telecomms/relay
	name = "Телекоммуникационный ретранслятор"
	desc = "Мощное аппаратное обеспечение, используемое для передачи огромных объемов данных на огромное расстояние."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/relay
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/server
	name = "Телекоммуникационный сервер"
	desc = "Машина, используемая для хранения данных и сетевой статистики."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/tesla_coil
	name = "Катушка Теслы"
	desc = "Преобразует удары шаровой молнии в энергию. Используйте отвертку для переключения между режимами производства электроэнергии и очков исследования."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/tesla_coil
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/cell_charger
	name = "зарядник батарей"
	desc = "Заряжает аккумуляторные батареи, не подходит для вооружения."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/cell_charger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/circulator
	name = "турбина ТЭГа"
	desc = "Газовый циркулятор с теплообменником."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/binary/circulator
	req_components = list()

/obj/item/circuitboard/machine/emitter
	name = "излучатель"
	desc = "Мощный промышленный лазер, часто используемый в области силовых полей и производства электроэнергии."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/emitter
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/generator
	name = "термоэлектрический генератор (ТЭГ)"
	desc = "Высокоэффективный газовый термоэлектрический генератор."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/generator
	req_components = list()

/obj/item/circuitboard/machine/ntnet_relay
	name = "Квантовое реле NTNet"
	desc = "Очень сложный маршрутизатор и передатчик, способный соединять вместе беспроводные электронные устройства. Выглядит хрупким."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/ntnet_relay
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/pacman
	name = "П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на плазме."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/port_gen/pacman
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pacman/super
	name = "С.У.П.Е.Р.П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на уране."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/port_gen/pacman/super

/obj/item/circuitboard/machine/pacman/mrs
	name = "М.И.С.И.С.П.А.К.М.А.Н. - портативный генератор"
	desc = "Портативный генератор для аварийного резервного питания. Работает на алмазах."
	build_path = /obj/machinery/power/port_gen/pacman/mrs

/obj/item/circuitboard/machine/power_compressor
	name = "компрессор турбины"
	desc = "Компрессорная ступень газотурбинного генератора."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/compressor
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/manipulator = 6)

/obj/item/circuitboard/machine/power_turbine
	name = "газотурбинный генератор"
	desc = "Газовая турбина, используемая для резервного производства электроэнергии."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/turbine
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 6)

/obj/item/circuitboard/machine/protolathe/department/engineering
	name = "Departmental Protolathe (Оборудование) - Engineering"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/rnd/production/protolathe/department/engineering

/obj/item/circuitboard/machine/rad_collector
	name = "радиационный коллекторный массив"
	desc = "Устройство, которое использует излучение Хокинга и плазму для производства энергии."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/rad_collector
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/sheet/plasmarglass = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/rtg
	name = "RTG (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/rtg
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/sheet/mineral/uranium = 10) // We have no Pu-238, and this is the closest thing to it.

/obj/item/circuitboard/machine/rtg/advanced
	name = "Advanced RTG (Оборудование)"
	build_path = /obj/machinery/power/rtg/advanced
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/stack/sheet/mineral/plasma = 5)

/obj/item/circuitboard/machine/scanner_gate
	name = "сканирующая арка"
	desc = "Устройство сканирующее проходящих сквозь него пользователей и подающее звуковой сигнал при заданных параметрах."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/scanner_gate
	req_components = list(
		/obj/item/stock_parts/scanning_module = 3)

/obj/item/circuitboard/machine/smes
	name = "Сверхмощный аккумуляторный каскад (СМЕС)"
	desc = "Огромная батарея аккумуляторов, предназначеная для длительного хранения энергии, получаемой от источника питания и ее дальнейшего распределения по электрической сети."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/smes
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/capacitor = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high/empty)

/obj/item/circuitboard/machine/techfab/department/engineering
	name = "\improper Departmental Techfab (Оборудование) - Engineering"
	build_path = /obj/machinery/rnd/production/techfab/department/engineering

/obj/item/circuitboard/machine/thermomachine
	name = "Термомашина"
	desc = "Нагревает или охлаждает газ в трубах. Потребляет очень много энергии."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/thermomachine/freezer
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/thermomachine/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [pipe_layer]."))

/obj/item/circuitboard/machine/thermomachine/examine()
	. = ..()
	. += "<hr><span class='notice'>It is set to layer [pipe_layer].</span>"

/obj/item/circuitboard/machine/HFR_fuel_input
	name = "Термоядерный реактор - Топливный порт"
	desc = "Входной порт термоядерного реактора, принимает исключительно водород и тритий в газообразной форме."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/fuel_input
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_waste_output
	name = "Термоядерный реактор - Порт вывода"
	desc = "Выпускной порт термоядерного реактора, предназначенный для вывода горячих отработанных газов, сбрасываемых из активной зоны машины."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/waste_output
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_moderator_input
	name = "Термоядерный реактор - Порт регулятора"
	desc = "Порт регулятора термоядерного реактора, предназначенный для охлаждения и управления протекания реакции."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/moderator_input
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_core
	name = "Термоядерный реактор - Ядро"
	desc = "Ядро термоядерного реактора, передовая технология для точной настройки протекания реакции внутри машины. Он имеет ввод-вывод для охлаждения газов."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/core
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 10)

/obj/item/circuitboard/machine/HFR_corner
	name = "Термоядерный реактор - Корпус"
	desc = "Конструктивная часть машины."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/hypertorus/corner
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_interface
	name = "Термоядерный реактор - Интерфейс"
	desc = "Интерфейс термоядерного реактора для управления протекания реакции."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/hypertorus/interface
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/crystallizer
	name = "кристаллизатор"
	desc = "Используется для кристаллизации или солидификации газов."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/binary/crystallizer
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/bluespace_sender
	name = "Bluespace Sender"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/bluespace_sender
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 5)

//Generic

/obj/item/circuitboard/machine/circuit_imprinter
	name = "Схемопринтер"
	desc = "Производит печатные платы для создания оборудования."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/circuit_imprinter
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/circuit_imprinter/department
	name = "схемопринтер отдела"
	desc = "Производит печатные платы для создания оборудования."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department

/obj/item/circuitboard/machine/holopad
	name = "голопад ИИ"
	desc = "Напольное устройство для проецирования голографических изображений."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/holopad
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE //wew lad
	var/secure = FALSE

/obj/item/circuitboard/machine/holopad/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_MULTITOOL)
		if(secure)
			build_path = /obj/machinery/holopad
			secure = FALSE
		else
			build_path = /obj/machinery/holopad/secure
			secure = TRUE
		to_chat(user, span_notice("You [secure? "en" : "dis"]able the security on the [src]"))
	. = ..()

/obj/item/circuitboard/machine/holopad/examine(mob/user)
	. = ..()
	. += "<hr>There is a connection port on this board that could be <b>pulsed</b>"
	if(secure)
		. += "\nThere is a red light flashing next to the word \"secure\""

/obj/item/circuitboard/machine/launchpad
	name = "Локальный блюспейс телепад"
	desc = "Блюспейс телепад, способный перемещать материю сквозь блюспейс. Не требует фактических координат, работает на смещении координат относительно консоли. Дальность работы зависит от деталей."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/launchpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/manipulator = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/paystand
	name = "Плата Терминала оплаты"
	desc = "Налоговый сбор проверен и одобрен корпорацией Нано-Трейзен."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/paystand
	req_components = list()

/obj/item/circuitboard/machine/protolathe
	name = "Протолат"
	desc = "Превращает сырье в полезные предметы."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/protolathe
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/protolathe/department
	name = "Departmental Protolathe (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/protolathe/department

/obj/item/circuitboard/machine/reagentgrinder
	name = "Плата Миксера"
	desc = "От BlenderTech. Замиксуется? Давайте узнаем!"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/reagentgrinder/constructed
	req_components = list(
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/smartfridge
	name = "умный холодильник"
	desc = "Сохраняет холодные вещи холодными, а горячие... тоже холодными."
	build_path = /obj/machinery/smartfridge
	req_components = list(/obj/item/stock_parts/matter_bin = 1)
	var/static/list/fridges_name_paths = list(/obj/machinery/smartfridge = "plant produce",
		/obj/machinery/smartfridge/food = "food",
		/obj/machinery/smartfridge/drinks = "drinks",
		/obj/machinery/smartfridge/extract = "slimes",
		/obj/machinery/smartfridge/organ = "organs",
		/obj/machinery/smartfridge/chemistry = "chems",
		/obj/machinery/smartfridge/chemistry/virology = "viruses",
		/obj/machinery/smartfridge/disks = "disks",
		/obj/machinery/smartfridge/ai_laws =  "ai_laws")
	needs_anchored = FALSE
	var/is_special_type = FALSE

/obj/item/circuitboard/machine/smartfridge/apply_default_parts(obj/machinery/smartfridge/M)
	build_path = M.base_build_path
	if(!fridges_name_paths.Find(build_path, fridges_name_paths))
		name = "[initial(M.name)] (Оборудование)" //if it's a unique type, give it a unique name.
		is_special_type = TRUE
	return ..()

/obj/item/circuitboard/machine/smartfridge/attackby(obj/item/I, mob/user, params)
	if(!is_special_type && I.tool_behaviour == TOOL_SCREWDRIVER)
		var/position = fridges_name_paths.Find(build_path, fridges_name_paths)
		position = (position == fridges_name_paths.len) ? 1 : (position + 1)
		build_path = fridges_name_paths[position]
		to_chat(user, span_notice("You set the board to [fridges_name_paths[build_path]]."))
	else
		return ..()

/obj/item/circuitboard/machine/smartfridge/examine(mob/user)
	. = ..()
	if(is_special_type)
		return
	. += "<hr><span class='info'>[capitalize(src.name)] is set to [fridges_name_paths[build_path]]. You can use a screwdriver to reconfigure it.</span>"


/obj/item/circuitboard/machine/space_heater
	name = "обогреватель"
	desc = "Обогреватель/охладитель, сделанный космическими амишами с использованием традиционных космических технологий, гарантированно не подожжет станцию. Гарантия аннулируется при использовании в двигателях."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/space_heater
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/cable_coil = 3)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/electrolyzer
	name = "электролизер"
	desc = "Благодаря быстрому и динамическому реагированию наших электролизеров производство водорода на месте гарантировано. Гарантия недействительна при использовании клоунами."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/electrolyzer
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1)

	needs_anchored = FALSE


/obj/item/circuitboard/machine/techfab
	name = "\improper Techfab (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/techfab
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/techfab/department
	name = "\improper Departmental Techfab (Оборудование)"
	build_path = /obj/machinery/rnd/production/techfab/department

/obj/item/circuitboard/machine/vendor
	name = "частный торговый автомат"
	desc = "Комерция в действии! Вид торгового автомата можно изменить при помощи отвертки."
	custom_premium_price = PAYCHECK_ASSISTANT * 1.5
	build_path = /obj/machinery/vending/custom
	req_components = list(/obj/item/vending_refill/custom = 1)

	var/static/list/vending_names_paths = list(
		/obj/machinery/vending/boozeomat = "Booze-O-Mat",
		/obj/machinery/vending/coffee = "Solar's Best Hot Drinks",
		/obj/machinery/vending/snack = "Getmore Chocolate Corp",
		/obj/machinery/vending/cola = "Robust Softdrinks",
		/obj/machinery/vending/cigarette = "ShadyCigs Deluxe",
		/obj/machinery/vending/games = "\improper Good Clean Fun",
		/obj/machinery/vending/autodrobe = "AutoDrobe",
		/obj/machinery/vending/tool = "YouTool",
		/obj/machinery/vending/custom = "частный торговый автомат",
		/obj/machinery/vending/chetverochka/pharma = "Аптечный вендомат (ОАО Четверочка-вендиг)",
		/obj/machinery/vending/chetverochka = "Продуктовый вендомат (ОАО Четверочка-вендиг)",
		/obj/machinery/vending/wardrobe/sec_wardrobe = "SecDrobe",
		/obj/machinery/vending/wardrobe/det_wardrobe = "DetDrobe",
		/obj/machinery/vending/wardrobe/medi_wardrobe = "MediDrobe",
		/obj/machinery/vending/wardrobe/engi_wardrobe = "EngiDrobe",
		/obj/machinery/vending/wardrobe/atmos_wardrobe = "AtmosDrobe",
		/obj/machinery/vending/wardrobe/cargo_wardrobe = "CargoDrobe",
		/obj/machinery/vending/wardrobe/robo_wardrobe = "RoboDrobe",
		/obj/machinery/vending/wardrobe/science_wardrobe = "SciDrobe",
		/obj/machinery/vending/wardrobe/hydro_wardrobe = "HyDrobe",
		/obj/machinery/vending/wardrobe/curator_wardrobe = "CuraDrobe",
		/obj/machinery/vending/wardrobe/bar_wardrobe = "BarDrobe",
		/obj/machinery/vending/wardrobe/chef_wardrobe = "ChefDrobe",
		/obj/machinery/vending/wardrobe/jani_wardrobe = "JaniDrobe",
		/obj/machinery/vending/wardrobe/law_wardrobe = "LawDrobe",
		/obj/machinery/vending/wardrobe/chap_wardrobe = "ChapDrobe",
		/obj/machinery/vending/wardrobe/chem_wardrobe = "ChemDrobe",
		/obj/machinery/vending/wardrobe/gene_wardrobe = "GeneDrobe",
		/obj/machinery/vending/wardrobe/viro_wardrobe = "ViroDrobe",
		/obj/machinery/vending/clothing = "ClothesMate",
		/obj/machinery/vending/medical = "NanoMed Plus",
		/obj/machinery/vending/drugs = "NanoDrug Plus",
		/obj/machinery/vending/wallmed = "NanoMed",
		/obj/machinery/vending/assist  = "Vendomat",
		/obj/machinery/vending/engivend = "Engi-Vend",
		/obj/machinery/vending/hydronutrients = "NutriMax",
		/obj/machinery/vending/hydroseeds = "MegaSeed Servitor",
		/obj/machinery/vending/sustenance = "Sustenance Vendor",
		/obj/machinery/vending/dinnerware = "Plasteel Chef's Dinnerware Vendor",
		/obj/machinery/vending/cart = "PTech",
		/obj/machinery/vending/robotics = "Robotech Deluxe",
		/obj/machinery/vending/engineering = "Robco Tool Maker",
		/obj/machinery/vending/sovietsoda = "BODA",
		/obj/machinery/vending/security = "SecTech",
		/obj/machinery/vending/modularpc = "Deluxe Silicate Selections",
		/obj/machinery/vending/custom = "Custom Vendor")

/obj/item/circuitboard/machine/vendor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/static/list/display_vending_names_paths
		if(!display_vending_names_paths)
			display_vending_names_paths = list()
			for(var/path in vending_names_paths)
				display_vending_names_paths[vending_names_paths[path]] = path
		var/choice =  tgui_input_list(user, "Choose a new brand", "Select an Item", sort_list(display_vending_names_paths))
		set_type(display_vending_names_paths[choice])
	else
		return ..()

/obj/item/circuitboard/machine/vendor/proc/set_type(obj/machinery/vending/typepath)
	build_path = typepath
	name = "[vending_names_paths[build_path]] Vendor (Оборудование)"
	req_components = list(initial(typepath.refill_canister) = 1)

/obj/item/circuitboard/machine/vendor/apply_default_parts(obj/machinery/M)
	for(var/typepath in vending_names_paths)
		if(istype(M, typepath))
			set_type(typepath)
			break
	return ..()

/obj/item/circuitboard/machine/vending/donksofttoyvendor
	name = "торговый автомат игрушек DonkSoft"
	desc = "Утвержденный поставщик игрушек в возрасте от 8 лет и старше."
	build_path = /obj/machinery/vending/donksofttoyvendor
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/vending/syndicatedonksofttoyvendor
	name = "Syndicate Donksoft Toy Vendor (Оборудование)"
	build_path = /obj/machinery/vending/toyliberationstation
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/bountypad
	name = "гражданская платформа отправки"
	desc = "Используется для отправки груза на ЦК."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/piratepad/civilian
	req_components = list(
		/obj/item/stock_parts/card_reader = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/micro_laser = 1
	)

/obj/item/circuitboard/machine/accounting
	name = "Регистратор учетных записей"
	desc = "Машина, которая позволяет ХоПу подключать банковский счет к новым ID-картам."
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/accounting
	req_components = list(
		/obj/item/stock_parts/card_reader = 1,
		/obj/item/stock_parts/scanning_module = 1
	)

/obj/item/circuitboard/machine/fax
	name = "факс"
	desc = "Блюспейс технологии применённые во имя бюрократии."
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/fax
	req_components = list(
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,)

//Medical

/obj/item/circuitboard/machine/chem_dispenser
	name = "плата хим-раздатчика"
	desc = "Создает и выдает химикаты."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_dispenser
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_mass_spec
	name = "химический хроматограф"
	desc = "Машина разделяющая реагенты основываясь на молярной массе"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_mass_spec
	req_components = list(
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_dispenser/fullupgrade
	build_path = /obj/machinery/chem_dispenser/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/mutagensaltpeter
	build_path = /obj/machinery/chem_dispenser/mutagensaltpeter
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/abductor
	name = "Reagent Synthesizer (Abductor Machine Board)"
	icon_state = "abductor_mod"
	build_path = /obj/machinery/chem_dispenser/abductor
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_heater
	name = "плата реакционной камеры"
	desc = "Миниатюрная термомашина способная быстро изменять и удерживать температуру состава, а так же мануально контролировать баланс ПШ."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_heater
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_master
	name = "плата хим-мастера 3000"
	desc = "Используется для разделения химикатов и их распределения в различных состояниях. Режим изменяет отверткой."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_master
	req_components = list(
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_master/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/new_name = "ChemMaster"
		var/new_path = /obj/machinery/chem_master

		if(build_path == /obj/machinery/chem_master)
			new_name = "CondiMaster"
			new_path = /obj/machinery/chem_master/condimaster

		build_path = new_path
		name = "[new_name] 3000 (Оборудование)"
		to_chat(user, span_notice("You change the circuit board setting to \"[new_name]\"."))
	else
		return ..()

/obj/item/circuitboard/machine/cryo_tube
	name = "Плата Криокамеры"
	desc = "Огромная стеклянная колба использующая целительные свойства холода."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/atmospherics/components/unary/cryo_cell
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 4)

/obj/item/circuitboard/machine/fat_sucker
	name = "Плата Авто-Экстрактора липидов МК IV"
	desc = "Безопасно и эффективно удаляет лишний жир."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/fat_sucker
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
		/obj/item/kitchen/fork = 1)

/obj/item/circuitboard/machine/harvester
	name = "Плата Авто-Потрошителя МК II"
	desc = "Извлекает из тела ВСЁ лишнее, включая органы, конечности и голову."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/harvester
	req_components = list(/obj/item/stock_parts/micro_laser = 4)

/obj/item/circuitboard/machine/medical_kiosk
	name = "Плата Медицинского киоска"
	desc = "За небольшую плату поможет продиагностировать пациента на основные виды повреждений и заболеваний."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/medical_kiosk
	var/custom_cost = 10
	req_components = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/medical_kiosk/multitool_act(mob/living/user)
	. = ..()
	var/new_cost = input("Set a new cost for using this medical kiosk.","New cost", custom_cost) as num|null
	if(!new_cost || (loc != user))
		to_chat(user, span_warning("You must hold the circuitboard to change its cost!"))
		return
	custom_cost = clamp(round(new_cost, 1), 10, 1000)
	to_chat(user, span_notice("The cost is now set to [custom_cost]."))

/obj/item/circuitboard/machine/medical_kiosk/examine(mob/user)
	. = ..()
	. += "<hr>The cost to use this kiosk is set to [custom_cost]."

/obj/item/circuitboard/machine/limbgrower
	name = "Плата Биосинтезатора"
	desc = "Выращивает органы и конечности из синтетической плоти."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/limbgrower
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/protolathe/department/medical
	name = "Departmental Protolathe (Оборудование) - Medical"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/rnd/production/protolathe/department/medical

/obj/item/circuitboard/machine/sleeper
	name = "Sleeper (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/sleeper
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 2)

/obj/item/circuitboard/machine/smoke_machine
	name = "Плата Дымогенератора"
	desc = "Аппарат с установленной внутри центрифугой. Производит дым с любыми реагентами, помещенными в него вами."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/smoke_machine
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/stasis
	name = "Плата Стазисной кровати"
	desc = "Не очень комфортная кровать, которая постоянно жужжит, однако она помещает пациента в стазис с надеждой, что когда-нибудь он все-таки дождется помощи."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/stasis
	req_components = list(
		/obj/item/stack/cable_coil = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/capacitor = 1)

/obj/item/circuitboard/machine/medipen_refiller
	name = "Плата Наполнителя медипенов"
	desc = "Машина, производящая пустые медипены, а так же перезаряжающая их химикатами. Внимание! Перезарядка осуществляется только для медипенов одобренных медицинской ассоциацией Нанотрейзен. Химический состав наполнителя должен строго соответствовать маркировке, в противном случае операция будет прервана."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/medipen_refiller
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/techfab/department/medical
	name = "\improper Departmental Techfab (Оборудование) - Medical"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/rnd/production/techfab/department/medical

//Science

/obj/item/circuitboard/machine/circuit_imprinter/department/science
	name = "схемопринтер отдела РнД"
	desc = "Производит печатные платы для создания оборудования."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/science

/obj/item/circuitboard/machine/cyborgrecharger
	name = "Станция зарядки киборгов"
	desc = "Устройство, заряжающее киборгов и переснаряжающая их материалами."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/recharge_station
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stock_parts/manipulator = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)

/obj/item/circuitboard/machine/destructive_analyzer
	name = "деструктивный анализатор"
	desc = "Если ты хочешь понять как работают вещи, тебе придется их сломать."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/destructive_analyzer
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/experimentor
	name = "Э.К.С.П.Е.Р.И.Ментор"
	desc = "\"Альтернативная\" версия деструктивного анализатора с небольшой тенденцией к катастрофическому выходу из строя."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/experimentor
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/mech_recharger
	name = "порт питания мехдока"
	desc = "Этот порт заряжает внутреннюю силовую ячейку меха."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mech_bay_recharge_port
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 5)

/obj/item/circuitboard/machine/mechfab
	name = "фабрикатор экзокостюмов"
	desc = "Сложный производственный комплекс изготавливающий киборгов и огромные экзокостюмы."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mecha_part_fabricator
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/monkey_recycler
	name = "переработчик обезьян"
	desc = "Полезная машина, перерабатывающая мертвых обезьян в обезьяньи кубики."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/monkey_recycler
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/nanite_chamber
	name = "Нанитная камера"
	desc = "Устройство для инъекции, мониторинга и базовой настройки нанитных облаков."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_chamber
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_program_hub
	name = "Программный центр нанитов"
	desc = "Компилирует нанитные программы с веб-серверов и записывает их на диски."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_program_hub
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_programmer
	name = "Программатор нанитов"
	desc = "Устройство для изменения настроек нанитных программ хранимых на дисках."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_programmer
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/processor/slime
	name = "Slime Processor (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/processor/slime

/obj/item/circuitboard/machine/protolathe/department/science
	name = "Departmental Protolathe (Оборудование) - Science"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/protolathe/department/science

/obj/item/circuitboard/machine/public_nanite_chamber
	name = "Публичная нанитная камера"
	desc = "Устройство для автоматической инъекции нанитного облака с заданым номером. Объем вводимых нанитов значительно ниже чем у стандартной камеры."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/public_nanite_chamber
	var/cloud_id = 1
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/public_nanite_chamber/multitool_act(mob/living/user)
	. = ..()
	var/new_cloud = input("Введите номер нанитного облака в диапазоне (1-100).", "Номер облака", cloud_id) as num|null
	if(!new_cloud || (loc != user))
		to_chat(user, span_warning("Я должен держать плату в руках для изменения номера облака!"))
		return
	cloud_id = clamp(round(new_cloud, 1), 1, 100)

/obj/item/circuitboard/machine/public_nanite_chamber/examine(mob/user)
	. = ..()
	. += "<hr>Текущий номер облака \"[cloud_id]\"."

/obj/item/circuitboard/machine/quantumpad
	name = "Квантовый телепад"
	desc = "Квантовый блюспейс телепад, используемый для телепортации объектов на другие квантовые телепады."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/quantumpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/rdserver
	name = "Сервер РнД"
	desc = "Компьютерная система, работающая на развитой нейронной сети, которая обрабатывает произвольную информацию для получения данных, пригодных для разработки новых технологий. С точки зрения компьютерного ботана, оно производит очки исследований."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/server
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/techfab/department/science
	name = "\improper Departmental Techfab (Оборудование) - Science"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/techfab/department/science

/obj/item/circuitboard/machine/teleporter_hub
	name = "телепортационная арка"
	desc = "Открывает проход сквозь блюспейс пространство."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/teleport/hub
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stock_parts/matter_bin = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/teleporter_station
	name = "телепортационная станция"
	desc = "Станция управления питанием блюспейс телепорта. Распределяет силовые нагрузки и калибрует пространственный прокол для предотвращения искажений."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/teleport/station
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/dnascanner
	name = "плата Манипулятора ДНК"
	desc = "При подключении к консоли позволяет видоизменять ДНК подопытного для получения ценной информации и коррекции генетического кода."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/dna_scannernew
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/mechpad
	name = "Mecha Orbital Pad (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mechpad
	req_components = list()

//Security

/obj/item/circuitboard/machine/protolathe/department/security
	name = "Departmental Protolathe (Оборудование) - Security"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/rnd/production/protolathe/department/security

/obj/item/circuitboard/machine/recharger
	name = "оружейный зарядник"
	desc = "Заряжает энергетическое оружие и энергозависимую экипировку."
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/recharger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/security
	name = "\improper Departmental Techfab (Оборудование) - Security"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/rnd/production/techfab/department/security

//Service

/obj/item/circuitboard/machine/biogenerator
	name = "биореактор"
	desc = "Превращает растения в биомассу, которую можно использовать для изготовления полезных предметов."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/biogenerator
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_dispenser/drinks
	name = "раздатчик газировки"
	desc = "Содержит большой резервуар с безалкогольными напитками."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/drinks

/obj/item/circuitboard/machine/chem_dispenser/drinks/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	name = "раздатчик бухлишка"
	desc = "Содержит большой резервуар ништяков."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/drinks/beer

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/beer/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_master/condi
	name = "CondiMaster 3000 (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_master/condimaster

/obj/item/circuitboard/machine/deep_fryer
	name = "фритюрница"
	desc = "Жареное <i>всё</i>."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/deepfryer
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE
/obj/item/circuitboard/machine/griddle
	name = "гридль"
	desc = "Потому что сковородки для жалких лузеров."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/griddle
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/oven
	name = "духовка"
	desc = "Не рекомендуется залезать внутрь."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/oven
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive
	name = "утилизатор тарелок"
	desc = "Кулинарное чудо, которое использует преобразование вещества в энергию для хранения посуды и осколков. Удобно!"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/dish_drive
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2)
	var/suction = TRUE
	var/transmit = TRUE
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Its suction function is [suction ? "enabled" : "disabled"]. Use it in-hand to switch.</span>"
	. += span_notice("\nIts disposal auto-transmit function is [transmit ? "enabled" : "disabled"]. ПКМ it to switch.")

/obj/item/circuitboard/machine/dish_drive/attack_self(mob/living/user)
	suction = !suction
	to_chat(user, span_notice("You [suction ? "enable" : "disable"] the board's suction function."))

/obj/item/circuitboard/machine/dish_drive/AltClick(mob/living/user)
	if(!user.Adjacent(src))
		return
	transmit = !transmit
	to_chat(user, span_notice("You [transmit ? "enable" : "disable"] the board's automatic disposal transmission."))

/obj/item/circuitboard/machine/gibber
	name = "мясорубка"
	desc = "Полагаю в более подробном описании не нуждается."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/gibber
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/hydroponics
	name = "лоток гидропоники"
	desc = "Это самая высокотехнологичная, автоматизированная, автономная грядка которую вы когда-либо видели."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/hydroponics/constructable
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/plantgenes
	name = "манипулятор ДНК растений"
	desc = "Позволяет работать с генетическим кодом растений для увеличения их потенциала."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/plantgenes
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/microwave
	name = "микроволновка"
	desc = "Готовит и варит штуки."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/microwave
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor
	name = "кухонный комбайн"
	desc = "Промышленный измельчитель, используемый для обработки мяса и других продуктов. Во время работы держите руки подальше от приемника."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/processor
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(build_path == /obj/machinery/processor)
			name = "Slime Processor (Оборудование)"
			build_path = /obj/machinery/processor/slime
			to_chat(user, span_notice("Name protocols successfully updated."))
		else
			name = "Food Processor (Оборудование)"
			build_path = /obj/machinery/processor
			to_chat(user, span_notice("Defaulting name protocols."))
	else
		return ..()

/obj/item/circuitboard/machine/protolathe/department/service
	name = "Departmental Protolathe - Service (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/rnd/production/protolathe/department/service

/obj/item/circuitboard/machine/recycler
	name = "Мусоропереработчик"
	desc = "Большая дробильная машина, используемая для неэффективной переработки мелких предметов. Сбоку есть индикаторы."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/recycler
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/seed_extractor
	name = "экстрактор семян"
	desc = "Извлекает и упаковывает семена из урожая."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/seed_extractor
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/service
	name = "\improper Departmental Techfab - Service (Оборудование)"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/rnd/production/techfab/department/service

/obj/item/circuitboard/machine/vendatray
	name = "торговая витрина"
	desc = "Витрина со считывателем ID карты. Используйте свою ID карту для покупки содержимого."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/structure/displaycase/forsale
	req_components = list(
		/obj/item/stock_parts/card_reader = 1)

//Supply

/obj/item/circuitboard/machine/mining_equipment_vendor
	name = "Торговый автомат шахтеров"
	desc = "Различное оборудование для бригады шахтеров. Очки добываются за сдачу руды в шахтерскую печь и начисляются на персональный счет шахтера."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/vendor/mining
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 3)

/obj/item/circuitboard/machine/exploration_equipment_vendor
	name = "Торговый автомат рейнджеров"
	desc = "Различное оборудование для команды исследователей глубин космоса. Очки добываются за выполнение миссий и разделяются между исследователями."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/vendor/exploration
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 3)

/obj/item/circuitboard/machine/mining_equipment_vendor/golem
	name = "Golem Ship Equipment Vendor (Оборудование)"
	build_path = /obj/machinery/vendor/golem

/obj/item/circuitboard/machine/ore_redemption
	name = "Шахтерская печь"
	desc = "Машина, которая принимает руду и мгновенно переплавляет ее в листы пригодного для обработки материала. При этом  генерируются баллы за руду, их количество зависит от редкости руды. Полученные балы можно обменять на полезную экипировку в торговом автомате шахтеров."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/ore_redemption
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/assembly/igniter = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/ore_silo
	name = "ресурсный бункер"
	desc = "Универсальная блюспейс система хранения и передачи ресурсов на нужды станции."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/ore_silo
	req_components = list()

/obj/item/circuitboard/machine/protolathe/department/cargo
	name = "Departmental Protolathe (Оборудование) - Cargo"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/protolathe/department/cargo

/obj/item/circuitboard/machine/stacking_machine
	name = "Штабелирующая машина"
	desc = "Машина, которая автоматически упаковывает проезжающие мимо материалы. Управляется консолью."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/stacking_machine
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/circuitboard/machine/stacking_unit_console
	name = "консоль штабелирующей машины"
	desc = "Управляет штабелирующей машиной... в теории."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/stacking_unit_console
	req_components = list(
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/techfab/department/cargo
	name = "Снабженский протолат"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/techfab/department/cargo

/obj/item/circuitboard/machine/bepis
	name = "Б.Е.П.И.С"
	desc = "Высокоточное тестирующее устройство, которое открывает секреты известной вселенной, используя два самых мощных вещества, доступных человеку: чрезмерное количество электричества и деньги."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/bepis
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 1)

//Misc
/obj/item/circuitboard/machine/sheetifier
	name = "листопрокатная машина"
	desc = "Строительный материал из чего угодно."
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/sheetifier
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/restaurant_portal
	name = "портал ресторана"
	desc = "Портал от Всемирной Организации Роботов-Гурманов!"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/restaurant_portal
	needs_anchored = TRUE

/obj/item/circuitboard/machine/abductor
	name = "alien board (Report This)"
	icon_state = "abductor_mod"

/obj/item/circuitboard/machine/abductor/core
	name = "alien board (Void Core)"
	build_path = /obj/machinery/power/rtg/abductor
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/cell/infinite/abductor = 1)
	def_components = list(
		/obj/item/stock_parts/capacitor = /obj/item/stock_parts/capacitor/quadratic,
		/obj/item/stock_parts/micro_laser = /obj/item/stock_parts/micro_laser/quadultra)

/obj/item/circuitboard/machine/hypnochair
	name = "допросная камера"
	desc = "Устройство, используемое для проведения \"допроса с пристрастием\" при помощи инвазивного ментального внедрения."
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/hypnochair
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 2
	)

#define PATH_POWERCOIL /obj/machinery/power/tesla_coil/power
#define PATH_RPCOIL /obj/machinery/power/tesla_coil/research

/obj/item/circuitboard/machine/tesla_coil/Initialize(mapload)
	. = ..()
	if(build_path)
		build_path = PATH_POWERCOIL

/obj/item/circuitboard/machine/tesla_coil/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/obj/item/circuitboard/new_type
		var/new_setting
		switch(build_path)
			if(PATH_POWERCOIL)
				new_type = /obj/item/circuitboard/machine/tesla_coil/research
				new_setting = "Research"
			if(PATH_RPCOIL)
				new_type = /obj/item/circuitboard/machine/tesla_coil/power
				new_setting = "Power"
		name = initial(new_type.name)
		build_path = initial(new_type.build_path)
		I.play_tool_sound(src)
		to_chat(user, span_notice("You change the circuitboard setting to \"[new_setting]\"."))
	else
		return ..()

/obj/item/circuitboard/machine/tesla_coil/power
	name = "Tesla Coil (Оборудование)"
	build_path = PATH_POWERCOIL

/obj/item/circuitboard/machine/tesla_coil/research
	name = "Tesla Corona Researcher (Оборудование)"
	build_path = PATH_RPCOIL

#undef PATH_POWERCOIL
#undef PATH_RPCOIL
/obj/item/circuitboard/machine/plumbing_receiver
	name = "Плата Химического приемника"
	desc = "Принимает химикаты с маяков. Используйте мультитул для связи с маяками через буфер. Для сброса открутите крышку и перекусите главный провод."
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/plumbing/receiver
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/skill_station
	name = "Камера имплантации чипов навыков"
	desc = "Осваивайте навыки с всего лишь мизерными шансами на повреждение головного мозга!"
	build_path = /obj/machinery/skill_station
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 2
	)

/obj/item/circuitboard/machine/destructive_scanner
	name = "экспериментально-деструктивный сканер"
	desc = "Гораздо более крупная версия ручного сканера, обугленная этикетка предупреждает о его разрушительных возможностях."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/destructive_scanner
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 2)

/obj/item/circuitboard/machine/doppler_array
	name = "ТДИМ"
	desc = "Тахионно-доплеровский исследовательский массив. Специализированная система обнаружения тахионно-доплеровских бомб, в которой используется сложное бортовое программное обеспечение для записи данных для экспериментов."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/doppler_array/research
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 4)

/obj/item/circuitboard/machine/exoscanner
	name = "Массив сканеров"
	desc = "Сложная сканирующая матрица. Уязвима к воздействию окружающей среды."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/exoscanner
	req_components = list(
		/obj/item/stock_parts/micro_laser = 4,
		/obj/item/stock_parts/scanning_module = 4)

/obj/item/circuitboard/machine/exodrone_launcher
	name = "пусковая установка дрона"
	desc = "Запускает дрона на исследовательскую миссию."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/exodrone_launcher
	req_components = list(
		/obj/item/stock_parts/micro_laser = 4,
		/obj/item/stock_parts/scanning_module = 4)

/obj/item/circuitboard/machine/tank_compressor
	name = "компрессор"
	desc = "Сверхмощный экранированный воздушный компрессор, предназначенный для создания давления в резервуарах выше безопасного предела."
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/atmospherics/components/binary/tank_compressor
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stock_parts/scanning_module = 4,
		)

/obj/item/circuitboard/machine/coffeemaker
	name = "кофеварка"
	desc = "Кофеварка Modello 3, которая варит кофе и поддерживает его идеальную температуру 176 градусов по Фаренгейту. Изготовлена компанией Piccionaia Home Appliances."
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/coffeemaker
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/water_recycler = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/shuttle/engine	// не используется
	name = "thruster (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/shuttle/engine
	req_components = list()

/obj/item/circuitboard/machine/shuttle/engine/plasma
	name = "плазменный двигатель"
	desc = "Двигатель, который сжигает плазму, хранящуюся в располагающемся рядом предзажигателе плазменного двигателя."
	build_path = /obj/machinery/shuttle/engine/plasma
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/shuttle/engine/void
	name = "пустотный двигатель"
	desc = "Двигатель, использующий технологию для пространственного прорыва для движения."
	build_path = /obj/machinery/shuttle/engine/void
	req_components = list(/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/micro_laser/quadultra = 1)

/obj/item/circuitboard/machine/shuttle/heater
	name = "предзажигатель двигателя"
	desc = "Направляет энергию в сжатые частицы для приведения в действие присоединенного двигателя. Хотя двигатель можно разогнать, залив его тритием, это приведет к аннулированию гарантии."
	build_path = /obj/machinery/atmospherics/components/unary/shuttle/engine_heater
	req_components = list(/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/plasma_refiner
	name = "плазменный сублиматор"
	desc = "Сублиматор, который перерабатывает плазменные листы в плазменный газ."
	build_path = /obj/machinery/atmospherics/components/unary/plasma_refiner
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/assembly/igniter = 1
	)

/obj/item/circuitboard/machine/shuttle/engine/ion
	name = "ионный двигатель"
	desc = "Двигатель, который выбрасывает ионы для создания тяги. Слабый, но простой в обслуживании."
	build_path = /obj/machinery/shuttle/engine/ion
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/shuttle/engine/ion/burst
	name = "реактивный ионный двигатель"
	desc = "Вариант ионного двигателя, который использует значительно большую мощность для увеличения тяги."
	build_path = /obj/machinery/shuttle/engine/ion/burst

/obj/item/circuitboard/machine/shuttle/capacitor_bank
	name = "конденсаторная батарея двигателя"
	desc = "Конденсаторная батарея, которая накапливает энергию для высокоэнергетических ионных двигателей."
	build_path = /obj/machinery/power/engine_capacitor_bank
	req_components = list(
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/micro_laser = 1)
