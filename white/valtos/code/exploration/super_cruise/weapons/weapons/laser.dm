//Single Laser

/obj/machinery/shuttle_weapon/laser
	name = "Лазерная установка МК-I \"Блик\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 60, погрешность 1, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	icon_state = "laser_on"
	base_icon_state = "laser"
	projectile_type = /obj/projectile/bullet/shuttle/beam/laser
	cooldown = 60
	innaccuracy = 1
	strength_rating = 10

/obj/item/wallframe/shuttle_weapon/laser
	name = "Лазерная установка МК-I \"Блик\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 60, погрешность 1, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/laser

//Triple Laser

/obj/machinery/shuttle_weapon/laser/triple
	name = "Лазерная установка МК-II \"Засвет\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 80, погрешность 1, кол-во выстрелов 3. Поворот осуществляется гаечным ключом."
	icon_state = "laser_tri_on"
	base_icon_state = "laser_tri"
	cooldown = 80
	innaccuracy = 1
	shots = 3
	strength_rating = 25

/obj/item/wallframe/shuttle_weapon/laser/triple
	name = "Лазерная установка МК-II \"Засвет\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 80, погрешность 1, кол-во выстрелов 3. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/laser/triple

//Mark 2 Laser

/obj/machinery/shuttle_weapon/laser/triple/mark2
	name = "Импульсный лазер МК-III \"Зарница\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 160, погрешность 2, кол-во выстрелов 5. Поворот осуществляется гаечным ключом."
	icon_state = "laser_tri_mk2_on"
	base_icon_state = "laser_tri_mk2"
	cooldown = 160
	innaccuracy = 2
	shots = 5
	strength_rating = 45

/obj/item/wallframe/shuttle_weapon/laser/triple/mark2
	name = "Импульсный лазер МК-III \"Зарница\""
	desc = "Система вооружения лазерного типа, установленная на шаттле. Урон 40, перезарядка 160, погрешность 2, кол-во выстрелов 5. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/laser/triple/mark2
