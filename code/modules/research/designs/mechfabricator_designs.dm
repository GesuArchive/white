//Cyborg
/datum/design/borg_suit
	name = "Эндоскелет киборга"
	desc = "Сложный металлический каркас со стандартными гнездами для конечностей и креплениями синтетических псевдо-мышц."
	id = "borg_suit"
	build_type = MECHFAB
	build_path = /obj/item/robot_suit
	materials = list(/datum/material/iron=15000)
	construction_time = 500
	category = list("Киборги")

/datum/design/borg_chest
	name = "Туловище киборга"
	desc = "Тяжело укрепленный корпус, содержащий логические платы киборга, с отверстием под стандартную ячейку питания."
	id = "borg_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/robot
	materials = list(/datum/material/iron=40000)
	construction_time = 350
	category = list("Киборги")

/datum/design/borg_head
	name = "Голова киборга"
	desc = "Стандартная укрепленная черепная коробка, с подключаемой к позвоночнику нейронным сокетом и сенсорными стыковочными узлами."
	id = "borg_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/robot
	materials = list(/datum/material/iron=5000)
	construction_time = 350
	category = list("Киборги")

/datum/design/borg_l_arm
	name = "Левая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	id = "borg_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/l_arm/robot
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list("Киборги")

/datum/design/borg_r_arm
	name = "Правая рука киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	id = "borg_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/r_arm/robot
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list("Киборги")

/datum/design/borg_l_leg
	name = "Левая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	id = "borg_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/l_leg/robot
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list("Киборги")

/datum/design/borg_r_leg
	name = "Правая нога киборга"
	desc = "Скелетная конечность, обернутая в псевдомышцы с низкопроводимостью."
	id = "borg_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/r_leg/robot
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list("Киборги")

//Ripley
/datum/design/ripley_chassis
	name = "Каркас экзокостюма (АПЛУ \"Рипли\")"
	id = "ripley_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/ripley
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Рипли")

/datum/design/ripley_torso
	name = "Торс экзокостюма (АПЛУ \"Рипли\")"
	desc = "Центральная часть АПЛУ Рипли. Содержит блок питания, процессорное ядро и системы жизнеобеспечения."
	id = "ripley_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 7500)
	construction_time = 200
	category = list("Рипли")

/datum/design/ripley_left_arm
	name = "Левая рука экзокостюма (АПЛУ \"Рипли\")"
	id = "ripley_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Рипли")

/datum/design/ripley_right_arm
	name = "Правая рука экзокостюма (АПЛУ \"Рипли\")"
	id = "ripley_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Рипли")

/datum/design/ripley_left_leg
	name = "Левая нога экзокостюма (АПЛУ \"Рипли\")"
	id = "ripley_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Рипли")

/datum/design/ripley_right_leg
	name = "Правая нога экзокостюма (АПЛУ \"Рипли\")"
	id = "ripley_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Рипли")

//Odysseus
/datum/design/odysseus_chassis
	name = "Каркас экзокостюма (\"Одиссей\")"
	id = "odysseus_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/odysseus
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Одиссей")

/datum/design/odysseus_torso
	name = "Торс экзокостюма (\"Одиссей\")"
	id = "odysseus_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	materials = list(/datum/material/iron=12000)
	construction_time = 180
	category = list("Одиссей")

/datum/design/odysseus_head
	name = "Голова экзокостюма (\"Одиссей\")"
	id = "odysseus_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_head
	materials = list(/datum/material/iron=6000,/datum/material/glass = 10000)
	construction_time = 100
	category = list("Одиссей")

/datum/design/odysseus_left_arm
	name = "Левая рука экзокостюма (\"Одиссей\")"
	id = "odysseus_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	materials = list(/datum/material/iron=6000)
	construction_time = 120
	category = list("Одиссей")

/datum/design/odysseus_right_arm
	name = "Правая рука экзокостюма (\"Одиссей\")"
	id = "odysseus_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	materials = list(/datum/material/iron=6000)
	construction_time = 120
	category = list("Одиссей")

/datum/design/odysseus_left_leg
	name = "Левая нога экзокостюма (\"Одиссей\")"
	id = "odysseus_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	materials = list(/datum/material/iron=7000)
	construction_time = 130
	category = list("Одиссей")

/datum/design/odysseus_right_leg
	name = "Правая нога экзокостюма (\"Одиссей\")"
	id = "odysseus_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	materials = list(/datum/material/iron=7000)
	construction_time = 130
	category = list("Одиссей")

//Gygax
/datum/design/gygax_chassis
	name = "Каркас экзокостюма (\"Гигакс\")"
	id = "gygax_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/gygax
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Гигакс")

/datum/design/gygax_torso
	name = "Торс экзокостюма (\"Гигакс\")"
	id = "gygax_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 10000,/datum/material/gold=2000, /datum/material/silver=2000)
	construction_time = 300
	category = list("Гигакс")

/datum/design/gygax_head
	name = "Голова экзокостюма (\"Гигакс\")"
	id = "gygax_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_head
	materials = list(/datum/material/iron=10000,/datum/material/glass = 5000, /datum/material/gold=2000, /datum/material/silver=2000)
	construction_time = 200
	category = list("Гигакс")

/datum/design/gygax_left_arm
	name = "Левая рука экзокостюма (\"Гигакс\")"
	id = "gygax_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	materials = list(/datum/material/iron=15000, /datum/material/gold=1000, /datum/material/silver=1000)
	construction_time = 200
	category = list("Гигакс")

/datum/design/gygax_right_arm
	name = "Правая рука экзокостюма (\"Гигакс\")"
	id = "gygax_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	materials = list(/datum/material/iron=15000, /datum/material/gold=1000, /datum/material/silver=1000)
	construction_time = 200
	category = list("Гигакс")

/datum/design/gygax_left_leg
	name = "Левая нога экзокостюма (\"Гигакс\")"
	id = "gygax_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	materials = list(/datum/material/iron=15000, /datum/material/gold=2000, /datum/material/silver=2000)
	construction_time = 200
	category = list("Гигакс")

/datum/design/gygax_right_leg
	name = "Правая нога экзокостюма (\"Гигакс\")"
	id = "gygax_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	materials = list(/datum/material/iron=15000, /datum/material/gold=2000, /datum/material/silver=2000)
	construction_time = 200
	category = list("Гигакс")

/datum/design/gygax_armor
	name = "Броня экзокостюма (\"Гигакс\")"
	id = "gygax_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_armor
	materials = list(/datum/material/iron=15000,/datum/material/gold=10000, /datum/material/silver=10000, /datum/material/titanium=10000)
	construction_time = 600
	category = list("Гигакс")

//Durand
/datum/design/durand_chassis
	name = "Каркас экзокостюма (\"Дюранд\")"
	id = "durand_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/durand
	materials = list(/datum/material/iron=25000)
	construction_time = 100
	category = list("Дюранд")

/datum/design/durand_torso
	name = "Торс экзокостюма (\"Дюранд\")"
	id = "durand_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_torso
	materials = list(/datum/material/iron=25000, /datum/material/glass = 10000,/datum/material/silver=10000)
	construction_time = 300
	category = list("Дюранд")

/datum/design/durand_head
	name = "Голова экзокостюма (\"Дюранд\")"
	id = "durand_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_head
	materials = list(/datum/material/iron=10000,/datum/material/glass = 15000,/datum/material/silver=2000)
	construction_time = 200
	category = list("Дюранд")

/datum/design/durand_left_arm
	name = "Левая рука экзокостюма (\"Дюранд\")"
	id = "durand_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	materials = list(/datum/material/iron=10000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Дюранд")

/datum/design/durand_right_arm
	name = "Правая рука экзокостюма (\"Дюранд\")"
	id = "durand_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	materials = list(/datum/material/iron=10000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Дюранд")

/datum/design/durand_left_leg
	name = "Левая нога экзокостюма (\"Дюранд\")"
	id = "durand_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	materials = list(/datum/material/iron=15000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Дюранд")

/datum/design/durand_right_leg
	name = "Правая нога экзокостюма (\"Дюранд\")"
	id = "durand_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	materials = list(/datum/material/iron=15000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Дюранд")

/datum/design/durand_armor
	name = "Броня экзокостюма (\"Дюранд\")"
	id = "durand_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_armor
	materials = list(/datum/material/iron=30000,/datum/material/uranium=25000,/datum/material/titanium=20000)
	construction_time = 600
	category = list("Дюранд")

//H.O.N.K
/datum/design/honk_chassis
	name = "Каркас экзокостюма (\"Х.О.Н.К\")"
	id = "honk_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/honker
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Х.О.Н.К")

/datum/design/honk_torso
	name = "Торс экзокостюма (\"Х.О.Н.К\")"
	id = "honk_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 10000,/datum/material/bananium=10000)
	construction_time = 300
	category = list("Х.О.Н.К")

/datum/design/honk_head
	name = "Голова экзокостюма (\"Х.О.Н.К\")"
	id = "honk_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_head
	materials = list(/datum/material/iron=10000,/datum/material/glass = 5000,/datum/material/bananium=5000)
	construction_time = 200
	category = list("Х.О.Н.К")

/datum/design/honk_left_arm
	name = "Левая рука экзокостюма (\"Х.О.Н.К\")"
	id = "honk_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_left_arm
	materials = list(/datum/material/iron=15000,/datum/material/bananium=5000)
	construction_time = 200
	category = list("Х.О.Н.К")

/datum/design/honk_right_arm
	name = "Правая рука экзокостюма (\"Х.О.Н.К\")"
	id = "honk_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_right_arm
	materials = list(/datum/material/iron=15000,/datum/material/bananium=5000)
	construction_time = 200
	category = list("Х.О.Н.К")

/datum/design/honk_left_leg
	name = "Левая нога экзокостюма (\"Х.О.Н.К\")"
	id = "honk_left_leg"
	build_type = MECHFAB
	build_path =/obj/item/mecha_parts/part/honker_left_leg
	materials = list(/datum/material/iron=20000,/datum/material/bananium=5000)
	construction_time = 200
	category = list("Х.О.Н.К")

/datum/design/honk_right_leg
	name = "Правая нога экзокостюма (\"Х.О.Н.К\")"
	id = "honk_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_right_leg
	materials = list(/datum/material/iron=20000,/datum/material/bananium=5000)
	construction_time = 200
	category = list("Х.О.Н.К")


//Phazon
/datum/design/phazon_chassis
	name = "Каркас экзокостюма (\"Фазон\")"
	id = "phazon_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/phazon
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Фазон")

/datum/design/phazon_torso
	name = "Торс экзокостюма (\"Фазон\")"
	id = "phazon_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_torso
	materials = list(/datum/material/iron=35000,/datum/material/glass = 10000,/datum/material/plasma=20000)
	construction_time = 300
	category = list("Фазон")

/datum/design/phazon_head
	name = "Голова экзокостюма (\"Фазон\")"
	id = "phazon_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_head
	materials = list(/datum/material/iron=15000,/datum/material/glass = 5000,/datum/material/plasma=10000)
	construction_time = 200
	category = list("Фазон")

/datum/design/phazon_left_arm
	name = "Левая рука экзокостюма (\"Фазон\")"
	id = "phazon_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_left_arm
	materials = list(/datum/material/iron=20000,/datum/material/plasma=10000)
	construction_time = 200
	category = list("Фазон")

/datum/design/phazon_right_arm
	name = "Правая рука экзокостюма (\"Фазон\")"
	id = "phazon_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_right_arm
	materials = list(/datum/material/iron=20000,/datum/material/plasma=10000)
	construction_time = 200
	category = list("Фазон")

/datum/design/phazon_left_leg
	name = "Левая нога экзокостюма (\"Фазон\")"
	id = "phazon_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_left_leg
	materials = list(/datum/material/iron=20000,/datum/material/plasma=10000)
	construction_time = 200
	category = list("Фазон")

/datum/design/phazon_right_leg
	name = "Правая нога экзокостюма (\"Фазон\")"
	id = "phazon_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_right_leg
	materials = list(/datum/material/iron=20000,/datum/material/plasma=10000)
	construction_time = 200
	category = list("Фазон")

/datum/design/phazon_armor
	name = "Броня экзокостюма (\"Фазон\")"
	id = "phazon_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_armor
	materials = list(/datum/material/iron=25000,/datum/material/plasma=20000,/datum/material/titanium=20000)
	construction_time = 300
	category = list("Фазон")

//Саванна-Иванов
/datum/design/savannah_ivanov_chassis
	name = "Каркас экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/savannah_ivanov
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_torso
	name = "Торс экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 7500)
	construction_time = 200
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_head
	name = "Голова экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_head
	materials = list(/datum/material/iron=6000,/datum/material/glass = 10000)
	construction_time = 100
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_left_arm
	name = "Левая рука экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_left_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_right_arm
	name = "Правая рука экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_right_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_left_leg
	name = "Левая нога экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_left_leg
	materials = list(/datum/material/iron=15000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_right_leg
	name = "Правая нога экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_right_leg
	materials = list(/datum/material/iron=15000,/datum/material/silver=4000)
	construction_time = 200
	category = list("Саванна-Иванов")

/datum/design/savannah_ivanov_armor
	name = "Броня экзокостюма (\"Саванна-Иванов\")"
	id = "savannah_ivanov_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_armor
	materials = list(/datum/material/iron=30000,/datum/material/uranium=25000,/datum/material/titanium=20000)
	construction_time = 600
	category = list("Саванна-Иванов")

//Clarke
/datum/design/clarke_chassis
	name = "Каркас экзокостюма (\"Кларк\")"
	id = "clarke_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/clarke
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Кларк")

/datum/design/clarke_torso
	name = "Торс экзокостюма (\"Кларк\")"
	id = "clarke_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 7500)
	construction_time = 200
	category = list("Кларк")

/datum/design/clarke_head
	name = "Голова экзокостюма (\"Кларк\")"
	id = "clarke_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_head
	materials = list(/datum/material/iron=6000,/datum/material/glass = 10000)
	construction_time = 100
	category = list("Кларк")

/datum/design/clarke_left_arm
	name = "Левая рука экзокостюма (\"Кларк\")"
	id = "clarke_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_left_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Кларк")

/datum/design/clarke_right_arm
	name = "Правая рука экзокостюма (\"Кларк\")"
	id = "clarke_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_right_arm
	materials = list(/datum/material/iron=15000)
	construction_time = 150
	category = list("Кларк")

//Exosuit Equipment
/datum/design/ripleyupgrade
	name = "Комплект модернизации Рипли МК-2"
	desc = "Комплект модернизации корпуса АПЛУ \"Рипли\" МК-1 в МК-2, предоставляет полную защиту от окружающей среды, в том числе космического вакуума, ценой замедления ходовой части. Модернизация не подлежит деконструкции."
	id = "ripleyupgrade"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/ripleyupgrade
	materials = list(/datum/material/iron=10000,/datum/material/plasma=10000)
	construction_time = 100
	category = list("Модули экзокостюмов")
	sub_category = list("Рипли")

/datum/design/mech_hydraulic_clamp
	name = "Гидравлический манипулятор"
	desc = "Оборудование для инженерных экзокостюмов. Поднимает предметы и загружает их в хранилище."
	id = "mech_hydraulic_clamp"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp
	materials = list(/datum/material/iron=10000)
	construction_time = 100
	category = list("Модули экзокостюмов")
	sub_category = list("Рипли")

/datum/design/mech_drill
	name = "Бур экзокостюма"
	desc = "Оборудование для инженерных и боевых экзокостюмов. Для бурения породы и прочего."
	id = "mech_drill"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/drill
	materials = list(/datum/material/iron=10000)
	construction_time = 100
	category = list("Модули экзокостюмов")
	sub_category = list("Инженерные системы")

/datum/design/mech_mining_scanner
	name = "Рудный сканер для экзокостюма"
	desc = "Оборудование для рабочих экзокостюмов. Он автоматически проверит окружающую породу на наличие полезных ископаемых."
	id = "mech_mscanner"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/mining_scanner
	materials = list(/datum/material/iron=5000,/datum/material/glass = 2500)
	construction_time = 50
	category = list("Модули экзокостюмов")
	sub_category = list("Инженерные системы")

/datum/design/mech_extinguisher
	name = "Огнетушитель экзокостюма"
	desc = "Оборудование для инженерных экзокостюмов. Быстродействующий огнетушитель большой мощности."
	id = "mech_extinguisher"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/extinguisher
	materials = list(/datum/material/iron=10000)
	construction_time = 100
	category = list("Модули экзокостюмов")
	sub_category = list("Инженерные системы")

/datum/design/mech_generator
	name = "Плазменный реактор экзокостюма"
	desc = "Модуль экзокостюма, который вырабатывает энергию, используя твердую плазму в качестве топлива. Загрязняет окружающую среду."
	id = "mech_generator"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(/datum/material/iron=10000,/datum/material/glass = 1000,/datum/material/silver=2000,/datum/material/plasma=5000)
	construction_time = 100
	category = list("Модули экзокостюмов")
	sub_category = list("Вспомогательные энергосистемы")

/datum/design/mech_mousetrap_mortar
	name = "Мышеловкометатель"
	desc = "Оборудование для клоунских экзокостюмов. Запускает заряженные мышеловки."
	id = "mech_mousetrap_mortar"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar
	materials = list(/datum/material/iron=20000,/datum/material/bananium=5000)
	construction_time = 300
	category = list("Модули экзокостюмов")
	sub_category = list("Х.О.Н.К")

/datum/design/mech_banana_mortar
	name = "Бананомет"
	desc = "Оборудование для клоунских экзокостюмов. Запускает банановую кожуру."
	id = "mech_banana_mortar"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar
	materials = list(/datum/material/iron=20000,/datum/material/bananium=5000)
	construction_time = 300
	category = list("Модули экзокостюмов")
	sub_category = list("Х.О.Н.К")

/datum/design/mech_honker
	name = "ХоНкЕР БлАсТ 5000"
	desc = "Оборудование для клоунских экзокостюмов. Распространяет веселье и радость среди всех окружающих. Хонк!"
	id = "mech_honker"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/honker
	materials = list(/datum/material/iron=20000,/datum/material/bananium=10000)
	construction_time = 500
	category = list("Модули экзокостюмов")
	sub_category = list("Х.О.Н.К")

/datum/design/mech_punching_glove
	name = "Оинго-Боинго-Лице-Ломатель"
	desc = "Оборудование для клоунских экзокостюмов. Доставляет удовольствие прямо вам в лицо!"
	id = "mech_punching_face"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove
	materials = list(/datum/material/iron=20000,/datum/material/bananium=7500)
	construction_time = 400
	category = list("Модули экзокостюмов")
	sub_category = list("Х.О.Н.К")

/////////////////////////////////////////
//////////////Borg Upgrades//////////////
/////////////////////////////////////////

/datum/design/borg_upgrade_rename
	name = "Модуль смены имени"
	desc = "Используется для смены позывного у киборга."
	id = "borg_upgrade_rename"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/rename
	materials = list(/datum/material/iron = 5000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Обслуживание Киборгов")

/datum/design/borg_upgrade_restart
	name = "Модуль аварийной перезагрузки"
	desc = "Используется для форсированной перезагрузки киборга после критических повреждений и запуска операционной системы."
	id = "borg_upgrade_restart"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/restart
	materials = list(/datum/material/iron = 20000 , /datum/material/glass = 5000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Обслуживание Киборгов")

/datum/design/borg_upgrade_thrusters
	name = "Ионные двигатели"
	desc = "Модернизация которая позволяет перемещатся в безгравитационном пространстве при помощи миниатюрных двигателей. Потребляет энергию при использовании."
	id = "borg_upgrade_thrusters"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/thrusters
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000, /datum/material/plasma = 5000, /datum/material/uranium = 6000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Универсальные Модули")

/datum/design/borg_upgrade_disablercooler
	name = "Радиатор Усмирителя"
	desc = "Устанавливает дополнительные системы охлаждения, тем самым повышая скорострельность."
	id = "borg_upgrade_disablercooler"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/disablercooler
	materials = list(/datum/material/iron = 20000 , /datum/material/glass = 6000, /datum/material/gold = 2000, /datum/material/diamond = 2000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Киборг Охранник")

/datum/design/borg_upgrade_diamonddrill
	name = "Алмазный бур"
	desc = "Заменяет стандартный бур на его продвинутый аналог."
	id = "borg_upgrade_diamonddrill"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/ddrill
	materials = list(/datum/material/iron=10000, /datum/material/glass = 6000, /datum/material/diamond = 2000)
	construction_time = 80
	category = list("Модули киборгов")
	sub_category = list("Киборг Шахтер")

/datum/design/borg_upgrade_holding
	name = "Безразмерная сумка для руды"
	desc = "Снимает ограничение емкости для Рудной Сумки."
	id = "borg_upgrade_holding"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/soh
	materials = list(/datum/material/iron = 10000, /datum/material/gold = 2000, /datum/material/uranium = 1000)
	construction_time = 40
	category = list("Модули киборгов")
	sub_category = list("Киборг Шахтер")

/datum/design/borg_upgrade_lavaproof
	name = "Лава-стойкие траки"
	desc = "Дает возможность перемещаться по лаве."
	id = "borg_upgrade_lavaproof"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/lavaproof
	materials = list(/datum/material/iron = 10000, /datum/material/plasma = 4000, /datum/material/titanium = 5000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Киборг Шахтер")

/datum/design/borg_syndicate_module
	name = "Модуль нелегальной модернизации"
	desc = "Разблокирует Киборгу нелегальные модернизации, это действие не меняет его Законы, но может нарушить работу других устройств (не обязательно)."
	id = "borg_syndicate_module"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/syndicate
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/diamond = 10000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Универсальные Модули")

/datum/design/borg_transform_clown
	name = "Модуль специализации (Клоун)"
	desc = "Модуль специа@#$# HOONK!"
	id = "borg_transform_clown"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/transform/clown
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/bananium = 1000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Обслуживание Киборгов")

/datum/design/borg_upgrade_selfrepair
	name = "Модуль саморемонта"
	desc = "Позволяет медленно восстанавливать текущую прочность за счет энергии."
	id = "borg_upgrade_selfrepair"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/selfrepair
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000)
	construction_time = 80
	category = list("Модули киборгов")
	sub_category = list("Универсальные Модули")

/datum/design/borg_upgrade_expandedsynthesiser
	name = "Расширенный медицинский гипоспрей"
	desc = "Значительно увеличивает диапазон синтезируемых Медицинский Киборгаментов."
	id = "borg_upgrade_expandedsynthesiser"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/hypospray/expanded
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/plasma = 8000, /datum/material/uranium = 8000)
	construction_time = 80
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_piercinghypospray
	name = "Пробивающий гипоспрей"
	desc = "Позволяет колоть химикаты из Гипоспрея сквозь РИГи или другие прочные материалы. Так же поддерживает другие модели киборгов."
	id = "borg_upgrade_piercinghypospray"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/piercing_hypospray
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/titanium = 5000, /datum/material/diamond = 3000)
	construction_time = 80
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_defibrillator
	name = "Дефибриллятор"
	desc = "Позволяет реанимировать людей."
	id = "borg_upgrade_defibrillator"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/defib
	materials = list(/datum/material/iron = 8000, /datum/material/glass = 5000, /datum/material/silver = 4000, /datum/material/gold = 3000)
	construction_time = 80
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_surgicalprocessor
	name = "Хирургический процессор"
	desc = "После синхронизации с Операционный Компьютером позволяет проводить все операции которые были загружены в него"
	id = "borg_upgrade_surgicalprocessor"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/processor
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 4000, /datum/material/silver = 4000)
	construction_time = 40
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_trashofholding
	name = "Безразмерный мешок для мусора"
	desc = "Снимает ограничение емкости для Мусорного Мешка."
	id = "borg_upgrade_trashofholding"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/tboh
	materials = list(/datum/material/gold = 2000, /datum/material/uranium = 1000)
	construction_time = 40
	category = list("Модули киборгов")
	sub_category = list("Киборг Уборщик")

/datum/design/borg_upgrade_advancedmop
	name = "Экспериментальная швабра"
	desc = "Заменяет швабру на продвинутую, при активации та начинает со временем собирать влагу из воздуха."
	id = "borg_upgrade_advancedmop"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/amop
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000)
	construction_time = 40
	category = list("Модули киборгов")
	sub_category = list("Киборг Уборщик")

/datum/design/borg_upgrade_prt
	name = "Инструмент для ремонта плитки"
	desc = "Позволяет ремонтировать поврежденный пол под собой."
	id = "borg_upgrade_prt"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/prt
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 750) //same price as a cautery
	construction_time = 40
	category = list("Модули киборгов")
	sub_category = list("Киборг Уборщик")

/datum/design/borg_upgrade_expand
	name = "Модуль расширения"
	desc = "Визуально увеличивает Киборга."
	id = "borg_upgrade_expand"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/expand
	materials = list(/datum/material/iron = 200000, /datum/material/titanium = 5000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Универсальные Модули")

/datum/design/boris_ai_controller
	name = "Модуль Б.О.Р.И.С."
	desc = "Подключает модуль удаленного управления для ИИ. Занимает слот Позитронного Мозга и MMI. Киборг становится оболочкой ИИ с открытым каналом связи."
	id = "borg_ai_control"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/ai
	materials = list(/datum/material/iron = 1200, /datum/material/glass = 1500, /datum/material/gold = 200)
	construction_time = 50
	category = list("Управление")
	search_metadata = "boris"

/datum/design/borg_upgrade_rped
	name = "Кибернетический РПЕД"
	desc = "позволяет переносить 50 электронных компонентов, а так же устанавливать их в каркас Машины или Консоли."
	id = "borg_upgrade_rped"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/rped
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Инженерный Киборг")

/datum/design/borg_upgrade_circuit_app
	name = "Манипулятор плат"
	desc = "Позволяет переносить 1 плату, а так же устанавливать ее в каркас Машины или Консоли."
	id = "borg_upgrade_circuitapp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/circuit_app
	materials = list(/datum/material/iron = 2000, /datum/material/titanium = 500)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Инженерный Киборг")

/datum/design/borg_upgrade_beaker_app
	name = "Дополнительный манипулятор хим посуды"
	desc = "Если одного недостаточно."
	id = "borg_upgrade_beakerapp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/beaker_app
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2250) //Need glass for the new beaker too
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_pinpointer
	name = "Монитор жизненных показателей экипажа"
	desc = "Позволяет наблюдать данные с датчиков жизнеобеспечения аналогично Консоли наблюдения за Экипажем, а так же добавляет трекер для поиска Экипажа."
	id = "borg_upgrade_pinpointer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/pinpointer
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Медицинский Киборг")

/datum/design/borg_upgrade_broomer
	name = "Экспериментальный толкатель"
	desc = "При активации позволяет толкать предметы перед собой в большой куче."
	id = "borg_upgrade_broomer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/broomer
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 500)
	construction_time = 120
	category = list("Модули киборгов")
	sub_category = list("Киборг Уборщик")

//Misc
/datum/design/mecha_tracking
	name = "Сигнальный маяк экзокостюма"
	desc = "Устройство, используемое для передачи данных о состоянии экзокостюма и удаленного отключения."
	id = "mecha_tracking"
	build_type = MECHFAB
	build_path =/obj/item/mecha_parts/mecha_tracking
	materials = list(/datum/material/iron=500)
	construction_time = 50
	category = list("Модули экзокостюмов")
	sub_category = list("Системы обслуживания")

/datum/design/mecha_tracking_ai_control
	name = "Маяк удаленного доступа экзокостюма для ИИ"
	desc = "Устройство, используемое для передачи данных экзокостюма. Позволяет ИИ взять экзокостюм под прямой контроль."
	id = "mecha_tracking_ai_control"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_tracking/ai_control
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/silver = 200)
	construction_time = 50
	category = list("Управление")

/datum/design/synthetic_flash
	name = "Вспышка"
	desc = "Мощное и универсальное устройство со вспышкой, предназначенное для различных применений - от дезориентации злоумышленников до использования их в качестве сенсорных рецепторов при производстве роботов."
	id = "sflash"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 750, /datum/material/glass = 750)
	construction_time = 100
	build_path = /obj/item/assembly/flash/handheld
	category = list("Батареи и прочее")

/datum/design/maint_drone
	name = "Технический дрон"
	desc = "Обслуживающий беспилотник, расходный робот, созданный для ремонта станции."
	id = "maint_drone"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 800, /datum/material/glass = 350)
	construction_time = 150
	build_path = /obj/effect/mob_spawn/drone
	category = list("Батареи и прочее")
