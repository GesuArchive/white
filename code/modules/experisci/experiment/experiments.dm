/datum/experiment/scanning/points/slime
	name = "Базовая слаймология"
	required_points = 1

/datum/experiment/scanning/points/slime/hard
	name = "Сложное слаймологическое исследование"
	description = "Другая станция бросила вызов вашей исследовательской группе, чтобы собрать несколько сложных экстрактов слаймов, \
		справитесь ли вы с этой задачей?"
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/bluespace = 1,
		/obj/item/slime_extract/sepia = 1,
		/obj/item/slime_extract/cerulean = 1,
		/obj/item/slime_extract/pyrite = 1,
		/obj/item/slime_extract/red = 2,
		/obj/item/slime_extract/green = 2,
		/obj/item/slime_extract/pink = 2,
		/obj/item/slime_extract/gold = 2)

/datum/experiment/scanning/points/slime/expert
	name = "Экспертное слаймологическое исследование"
	description = "Межгалактическое общество ксенобиологов в настоящее время ищет образцы самых сложных экстрактов слаймов, мы просим вашу станцию предоставить им все необходимое."
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/adamantine = 1,
		/obj/item/slime_extract/oil = 1,
		/obj/item/slime_extract/black = 1,
		/obj/item/slime_extract/lightpink = 1,
		/obj/item/slime_extract/rainbow = 10)

/datum/experiment/scanning/random/cytology/easy
	name = "Базовый цитологический эксперимент"
	description = "Ученым нужны подопытные крысы для тестирования, используйте цитологическое оборудование, чтобы вырастить парочку из этих тварей!"
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(/mob/living/simple_animal/hostile/cockroach, /datum/micro_organism/cell_line/mouse)

/datum/experiment/scanning/random/cytology/medium
	name = "Продвинутый цитологический эксперимент"
	description = "Нам нужно понимать, как функционирует организмы некоторых животных с самых ранних моментов. Некоторые цитологические эксперименты помогут нам получить это понимание."
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/retaliate/poison/snake, /mob/living/simple_animal/pet/cat, /mob/living/simple_animal/pet/dog/corgi, /mob/living/simple_animal/cow, /mob/living/simple_animal/chicken)

/datum/experiment/scanning/random/cytology/medium/one
	name = "Продвинутый цитологический эксперимент - 1"

/datum/experiment/scanning/random/cytology/medium/two
	name = "Продвинутый цитологический эксперимент - 2"

/datum/experiment/scanning/random/janitor_trash
	name = "Санэпидем надзор"
	description = "Необходимо идентифицировать наиболее заразные точки станции. Проверьте коридоры и технические помещения сканером на предмет заражения."
	possible_types = list(/obj/effect/decal/cleanable/vomit,
	/obj/effect/decal/cleanable/blood)
	total_requirement = 3

/datum/experiment/explosion/calibration
	name = "Эта штука работает?"
	description = "Инженеры из прошлой смены оставили нам уведомление о том, что доплеровская матрица, похоже, работает со сбоями. \
		Не могли бы вы проверить, что он все еще работает? Подойдет абсолютно любой взрыв!"
	required_light = 1

/datum/experiment/explosion/maxcap
	name = "Я стал смертью, разрушителем миров"
	description = "Недавняя вспышка кровавого культа в соседнем секторе требует разработки мощного взрывчатого вещества. \
		Создайте достаточно мощный взрыв, мы будем наблюдать с безопасного расстояния."

/datum/experiment/explosion/medium
	name = "Эксперимент со взрывчатым веществом"
	description = "Ладно, имеем ли мы право действительно называть себя профессионалами, если не можем заставить дерьмо взорваться?"
	required_heavy = 2
	required_light = 6

/datum/experiment/explosion/maxcap/New()
	required_devastation = GLOB.MAX_EX_DEVESTATION_RANGE
	required_heavy = GLOB.MAX_EX_HEAVY_RANGE
	required_light = GLOB.MAX_EX_LIGHT_RANGE

/datum/experiment/scanning/random/material/meat
	name = "Эксперимент по сканированию биологического материала"
	description = "Они говорят нам, что мы не можем делать стулья из всех материалов в мире. Вы здесь для того, чтобы доказать, что те, кто говорит \"нет\", неправы."
	possible_material_types = list(/datum/material/meat)

/datum/experiment/scanning/random/material/easy
	name = "Эксперимент по сканированию базовых материалов"
	description = "Сопромат - это основа всего, что касается базового понимания Вселенной и того, как она устроена. Чтобы понять как сделать что-то достаточно качественное, для начала надо понять как это сломать."
	total_requirement = 6
	possible_types = list(/obj/structure/chair, /obj/structure/toilet, /obj/structure/table)
	possible_material_types = list(/datum/material/iron, /datum/material/glass)

/datum/experiment/scanning/random/material/medium
	name = "Эксперимент по сканированию материалов среднего качества"
	description = "Иногда помимо прочности от материалов требуются и другие физические свойства. Изучите данные материалы и посмотрите, что делает их полезными для нашей электроники и оборудования."
	possible_material_types = list(/datum/material/silver, /datum/material/gold, /datum/material/plastic, /datum/material/titanium)

/datum/experiment/scanning/random/material/medium/one
	name = "Эксперимент по сканированию материалов среднего качества - 1"

/datum/experiment/scanning/random/material/medium/two
	name = "Эксперимент по сканированию материалов среднего качества - 2"

/datum/experiment/scanning/random/material/medium/three
	name = "Эксперимент по сканированию материалов среднего качества - 3"

/datum/experiment/scanning/random/material/hard
	name = "Эксперимент по сканированию высококачественных материалов"
	description = "Нанотрейзен никогда не жалеет средств на науку, и всегда готово оценить характеристики даже самых редких ресурсов в качестве строительных материалов первой бытовой необходимости."
	possible_material_types = list(/datum/material/diamond, /datum/material/plasma, /datum/material/uranium)

/datum/experiment/scanning/random/material/hard/one
	name = "Эксперимент по сканированию высококачественных материалов - 1"

/datum/experiment/scanning/random/material/hard/two
	name = "Эксперимент по сканированию высококачественных материалов - 2"

/datum/experiment/scanning/random/material/hard/three
	name = "Эксперимент по сканированию высококачественных материалов - 3"

/datum/experiment/scanning/random/plants/wild
	name = "Образец Мутации Дикой Биоматерии"
	description = "По ряду причин (солнечные лучи, диета, состоящая только из нестабильного мутагена, энтропия) растения с более низким уровнем нестабильности могут иногда мутировать без особых причин. Отсканируйте для нас один из этих образцов."
	performance_hint = "было зарегистрировано, что \"Дикие\" мутации происходят если растения набирают более чем 30 единиц нестабильности, в то время как видовые мутации происходят при достижении более чем 60 единиц нестабильности."
	total_requirement = 1

/datum/experiment/scanning/random/plants/traits
	name = "Уникальный Образец Мутации Биоматерии"
	description = "Центральное командование, ищет редкие и экзотические растения с уникальными свойствами, которыми можно похвастаться перед нашими акционерами. В настоящее время мы ищем образец с очень специфическими генами."
	performance_hint = "Большинство растений на станции после прохождения мутаций несет в себе различные черты, некоторые из которых уникальны для них. Найдите растения, которые могут мутировать во что-то интересное."
	total_requirement = 3
	possible_plant_genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/cell_charge, /datum/plant_gene/trait/glow/shadow, /datum/plant_gene/trait/teleport, /datum/plant_gene/trait/brewing, /datum/plant_gene/trait/juicing, /datum/plant_gene/trait/eyes, /datum/plant_gene/trait/sticky)

/datum/experiment/scanning/points/machinery_tiered_scan/tier2_lathes
	name = "Расширенный эталонный тест машинных деталей"
	description = "Наши недавно разработанные усовершенствованные компоненты оборудования требуют практических испытаний для получения намеков на возможные дальнейшие усовершенствования, а также общего подтверждения правильного направления исследования."
	required_points = 6
	required_atoms = list(
		/obj/machinery/rnd/production/protolathe/department/science = 1,
		/obj/machinery/rnd/production/protolathe/department/engineering = 1,
		/obj/machinery/rnd/production/techfab/department/cargo = 1,
		/obj/machinery/rnd/production/techfab/department/medical = 1,
		/obj/machinery/rnd/production/techfab/department/security = 1,
		/obj/machinery/rnd/production/techfab/department/service = 1,
		/obj/machinery/mecha_part_fabricator/med = 2,
		/obj/machinery/mecha_part_fabricator/engi = 2,
		/obj/machinery/mecha_part_fabricator/sci = 2,
		/obj/machinery/mecha_part_fabricator/cargo = 2,
		/obj/machinery/mecha_part_fabricator/sb = 2,
		/obj/machinery/mecha_part_fabricator/service = 2
	)
	required_tier = 2

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_bluespacemachines
	name = "Настройка оборудования блюспейс"
	description = "Технология телепортации с использованием возможностей блюспейс является важным преимуществом для нашей компании, но угроза критического сбоя в процедурах калибровки была весьма неприятным сюрпризом. Поскольку наш отдел РнД уже частично обратился в людей-мух, то возможно, сотрудники будут более успешны и аккуратны в исследованиях телепортации."
	required_points = 4
	required_atoms = list(
		/obj/machinery/teleport/hub = 1,
		/obj/machinery/teleport/station = 1
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_variety
	name = "Испытание высокоэффективных деталей на практике"
	description = "Мы требуем дальнейшего тестирования продвинутых деталей, чтобы еще больше повысить их эффективность и рыночную цену."
	required_points = 15
	required_atoms = list(
		/obj/machinery/autolathe = 1,
		/obj/machinery/rnd/production/circuit_imprinter/department/science = 1,
		/obj/machinery/monkey_recycler = 1,
		/obj/machinery/processor/slime = 1,
		/obj/machinery/processor = 2,
		/obj/machinery/reagentgrinder = 2,
		/obj/machinery/hydroponics = 2,
		/obj/machinery/biogenerator = 3,
		/obj/machinery/gibber = 3,
		/obj/machinery/chem_master = 3,
		/obj/machinery/atmospherics/components/unary/cryo_cell = 3,
		/obj/machinery/harvester = 5,
		/obj/machinery/quantumpad = 5
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay
	name = "Мех-док военного класса"
	description = "Создание боевых экзоскелетов - дорогостоящее занятие. Убедитесь, что у вас есть эффективная производственная установка, и мы вышлем вам некоторые из наших проектных документов."
	required_points = 6
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/mech_bay_recharge_port = 1,
		/obj/machinery/recharge_station = 1
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_microlaser
	name = "Калибровка мощных микролазеров"
	description = "Наша ультра-мощная офисная лазерная указка Нанотрейзен™ еще недостаточно мощна, чтобы поражать воздушные Синдидроны в небе. Найдите нам несколько модификаций для диодов, чтобы получить советы о том, как их улучшить!"
	required_points = 10
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/dna_scannernew = 1,
		/obj/machinery/microwave = 2,
		/obj/machinery/deepfryer = 2,
		/obj/machinery/chem_heater = 3,
		/obj/machinery/power/emitter = 3
	)
	required_stock_part = /obj/item/stock_parts/micro_laser/high

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_capacitors
	name = "Усовершенствованный эталон конденсаторов"
	description = "Дальнейшее повышение мощности устройств по всей станции является следующим шагом на пути к важному проекту, отмеченному как КРИТИЧЕСКИ-ВАЖНЫЙ: моторизованные инвалидные коляски, работающие на блюспейс-ядерной энергии."
	required_points = 12
	required_atoms = list(
		/obj/machinery/recharge_station = 1,
		/obj/machinery/cell_charger = 1,
		/obj/machinery/mech_bay_recharge_port = 1,
		/obj/machinery/recharger = 2,
		/obj/machinery/power/smes = 2,
		/obj/machinery/chem_dispenser = 3,
		/obj/machinery/chem_dispenser/drinks = 3, /*actually having only the chem dispenser works for scanning soda/booze dispensers but im not quite sure how would i go about actually pointing that out w/o these two lines*/
		/obj/machinery/chem_dispenser/drinks/beer = 3
	)
	required_stock_part = /obj/item/stock_parts/capacitor/adv

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_scanmodules
	name = "Расширенная калибровка сканирующих модулей"
	description = "Несмотря на очевидное отсутствие использования сканирующих модулей на наших станциях, мы по-прежнему ожидаем, что вы проведете тесты производительности на них, на всякий случай, если мы придумаем новаторский способ установки 6 сканирующих модулей в экзокостюм."
	required_points = 6
	required_atoms = list(
		/obj/machinery/dna_scannernew = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/medical_kiosk = 2,
		/obj/machinery/piratepad/civilian = 2,
		/obj/machinery/rnd/bepis = 3
	)
	required_stock_part = /obj/item/stock_parts/scanning_module/adv

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_cells
	name = "Проверка емкости аккумуляторных батарей"
	description = "У Нанотрейзен есть две основные проблемы с их новой силовой установкой, работающей на хомяках: избыток производимой мощности и яростные протесты активистов Консорциума по защите прав животных по поводу генетической модификации хомяков геном Халка. Мы возлагаем большие надежды на то, чтобы разобраться с последним!"
	required_points = 8
	required_atoms = list(
		/obj/machinery/recharge_station = 1,
		/obj/machinery/chem_dispenser = 1,
		/obj/machinery/chem_dispenser/drinks = 1,
		/obj/machinery/chem_dispenser/drinks/beer = 1,
		/obj/machinery/power/smes = 2
	)
	required_stock_part = /obj/item/stock_parts/cell/hyper

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_microlaser
	name = "Калибровка микролазеров сверхвысокой мощности"
	description = "Мы очень близки к тому, чтобы превзойти хирургов прошлого, изобретя лазерные инструменты, достаточно точные для проведения операций на винограде. Помогите нам довести диоды до совершенства!"
	required_points = 10
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/microwave = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/atmospherics/components/unary/thermomachine/freezer = 2,
		/obj/machinery/power/emitter = 2,
		/obj/machinery/chem_heater = 2,
		/obj/machinery/chem_mass_spec = 3
	)
	required_stock_part = /obj/item/stock_parts/micro_laser/ultra
