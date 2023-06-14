//Chain Cannon

/obj/machinery/shuttle_weapon/point_defense
	name = "Автопушка МК-I \"Муха\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 80, погрешность 2, кол-во выстрелов 8. Поворот осуществляется гаечным ключом."
	icon_state = "chaincannon_on"
	base_icon_state = "chaincannon"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/point_defense
	cooldown = 80
	innaccuracy = 2
	shots = 8
	shot_time = 1
	strength_rating = 5

/obj/item/wallframe/shuttle_weapon/point_defense
	name = "Автопушка МК-I \"Муха\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 80, погрешность 2, кол-во выстрелов 8. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/point_defense

/obj/machinery/shuttle_weapon/point_defense/upgraded
	name = "Автопушка МК-II \"Стрекоза\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 140, погрешность 3, кол-во выстрелов 14. Поворот осуществляется гаечным ключом."
	icon_state = "chaincannon_mk2_on"
	base_icon_state = "chaincannon_mk2"
	cooldown = 140
	innaccuracy = 3
	shots = 14
	strength_rating = 15

/obj/item/wallframe/shuttle_weapon/point_defense/upgraded
	name = "Автопушка МК-II \"Стрекоза\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 140, погрешность 3, кол-во выстрелов 14. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/point_defense/upgraded

//Scatter shot

/obj/machinery/shuttle_weapon/scatter
	name = "Зенитное орудие МК-I \"Дождь\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 90, погрешность 4, кол-во выстрелов 8. Поворот осуществляется гаечным ключом."
	icon_state = "scatter_on"
	base_icon_state = "scatter"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/point_defense
	cooldown = 90
	simultaneous_shots = 8
	miss_chance = 80
	hit_chance = 0
	innaccuracy = 4
	strength_rating = 10

/obj/item/wallframe/shuttle_weapon/scatter
	name = "Зенитное орудие МК-I \"Дождь\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Урон 15, перезарядка 90, погрешность 4, кол-во выстрелов 8. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/scatter

//Railgun

/obj/machinery/shuttle_weapon/railgun
	name = "Рельсотрон МК-I \"Швея\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Бронепробитие, Урон 50, перезарядка 160, погрешность 1, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	icon = 'icons/obj/supercruise/supercruise_weapons_long.dmi'
	icon_state = "railgun_on"
	base_icon_state = "railgun"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/guass
	cooldown = 160
	innaccuracy = 1
	strength_rating = 70
	hit_chance = 80
	miss_chance = 60

/obj/item/wallframe/shuttle_weapon/railgun
	name = "Рельсотрон МК-I \"Швея\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Бронепробитие, Урон 50, перезарядка 160, погрешность 1, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/railgun

/obj/machinery/shuttle_weapon/railgun/anti_crew
	name = "Рельсотрон МК-II \"Чернобыль\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Бронепробитие, Оглушение, Заражение, Урон 80, перезарядка 180, погрешность 2, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	icon_state = "railgun_mk2_on"
	base_icon_state = "railgun_mk2"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/guass/uranium
	cooldown = 180
	innaccuracy = 2
	strength_rating = 90
	hit_chance = 60
	miss_chance = 80

/obj/item/wallframe/shuttle_weapon/railgun/anti_crew
	name = "Рельсотрон МК-II \"Чернобыль\""
	desc = "Система вооружения баллистического типа, установленная на шаттле. Бронепробитие, Оглушение, Заражение, Урон 80, перезарядка 180, погрешность 2, кол-во выстрелов 1. Поворот осуществляется гаечным ключом."
	result_path = /obj/machinery/shuttle_weapon/railgun/anti_crew
