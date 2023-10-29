// Рубрика Э-э-э-ксперименты

/datum/experiment/scanning/points/ne_bepis/light
	name = "Исследование осветительных приборов"
	description = "У вас появились интересным мысли о расширении зоны применения осветительных приборов."
	required_points = 10
	required_atoms =  list(
		/obj/machinery/light = 1,
		/obj/item/lightreplacer = 10
	)

/datum/experiment/scanning/points/ne_bepis/nanites_replication
	name = "Альтернативные алгоритмы репликации нанитов"
	description = "Интересно, можно ли каким-либо образом ускорить производство нанитов, возможно у меня получится найти наглядные примеры в жизни?"
	required_points = 30
	required_atoms =  list(
		/obj/machinery/mecha_part_fabricator = 3,
		/obj/machinery/computer/cargo = 4,
		/obj/machinery/computer/bank_machine = 15,
		/obj/item/bedsheet = 1
	)

/datum/experiment/scanning/points/ne_bepis/nanites_storage
	name = "Реструктуризация методики накопления нанитов"
	description = "Структура навигации и накопления нанитов не оптимальна, возможно следует ее переосмыслить основываясь на аналогичных задачах решенных природой и технологическим прогрессом?"
	required_points = 30
	required_atoms =  list(
		/obj/effect/decal/cleanable/ants = 3,
		/obj/machinery/modular_computer/console/preset/id = 10,
		/obj/machinery/ore_silo = 10,
		/obj/machinery/rnd/server = 10,
		/obj/structure/ai_core = 10,
		/obj/machinery/computer/libraryconsole = 10
	)

/datum/design/light_tube_autobuild
	name = "Анкерный каркас большой лампы"
	desc = "Используется для быстрого монтажа каркаса и подключения проводки. Лампочка в комплект не входит."
	id = "light_tube_autobuild"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/wallframe/autobuild
	category = list("Строительство", "Карго оборудование" ,"Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")

/datum/design/light_tube_autobuild_small
	name = "анкерный каркас маленькой лампы"
	desc = "Используется для быстрого монтажа каркаса и подключения проводки. Лампочка в комплект не входит."
	id = "light_tube_autobuild_small"
	build_type = MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 300)
	build_path = /obj/item/wallframe/autobuild/small
	category = list("Строительство", "Карго оборудование" ,"Оборудование СБ", "Оборудование сервиса")
	sub_category = list("Настенные конструкции")
