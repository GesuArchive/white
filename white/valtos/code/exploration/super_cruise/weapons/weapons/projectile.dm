//Chain Cannon

/obj/machinery/shuttle_weapon/point_defense
	name = "пулеметная турель \"Аид\" MK.I"
	desc = "Настенная а	втоматическая пулеметная турель с ограниченной способностью разрушать корпус, но чрезвычайно мощная для уничтожения экипажей и техники. Предназначен для использования на шаттлах."
	icon_state = "chaincannon_on"
	base_icon_state = "chaincannon"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/point_defense
	cooldown = 80
	innaccuracy = 2
	shots = 8
	shot_time = 1
	strength_rating = 5

/obj/item/wallframe/shuttle_weapon/point_defense
	name = "рама пулеметной турели"
	desc = "Настенная а	втоматическая пулеметная турель с ограниченной способностью разрушать корпус, но чрезвычайно мощная для уничтожения экипажей и техники. Предназначен для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/point_defense

/obj/machinery/shuttle_weapon/point_defense/upgraded
	name = "пулеметная турель \"Аид\" MK.II"
	desc = "Модернизированная версия \"Аида\" первой марки. Хотя он менее точен и медленнее перезаряжается, зато имеет больший размер залпа. Предназначен для использования на шаттлах."
	icon_state = "chaincannon_mk2_on"
	base_icon_state = "chaincannon_mk2"
	cooldown = 140
	innaccuracy = 3
	shots = 14
	strength_rating = 15

/obj/item/wallframe/shuttle_weapon/point_defense/upgraded
	name = "рама пулеметной турели MK.II"
	desc = "Модернизированная версия \"Аида\" первой марки. Хотя он менее точен и медленнее перезаряжается, зато имеет больший размер залпа. Предназначен для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/point_defense/upgraded

//Scatter shot

/obj/machinery/shuttle_weapon/scatter
	name = "рассеивающее орудие \"Арей\""
	desc = "Мощная зенитная пушка, выпускающая 8 снарядов одновременно. Предназначена для использования на шаттлах."
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
	name = "рама рассеивающего орудия"
	desc = "Мощная зенитная пушка, выпускающая 8 снарядов одновременно. Предназначена для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/scatter

//Railgun

/obj/machinery/shuttle_weapon/railgun
	name = "рельсотрон \"Зевс\" MK.I"
	desc = "Кинетическое оружие, предназначенное для точных выстрелов на большие расстояния. Предназначено для использования на шаттлах."
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
	name = "рама ресольтрона"
	desc = "Кинетическое оружие, предназначенное для точных выстрелов на большие расстояния. Предназначено для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/railgun

/obj/machinery/shuttle_weapon/railgun/anti_crew
	name = "противопехотный рельсотрон \"Зевс\" MK.II"
	desc = "Кинетическое оружие, стреляющее магнитными снарядами с урановым покрытием. Предназначено для точных выстрелов на большие расстояния. Предназначено для использования на шаттлах."
	icon_state = "railgun_mk2_on"
	base_icon_state = "railgun_mk2"
	projectile_type = /obj/projectile/bullet/shuttle/ballistic/guass/uranium
	cooldown = 180
	innaccuracy = 2
	strength_rating = 90
	hit_chance = 60
	miss_chance = 80

/obj/item/wallframe/shuttle_weapon/railgun/anti_crew
	name = "рама противопехотного ресольтрона"
	desc = "Кинетическое оружие, стреляющее магнитными снарядами с урановым покрытием. Предназначено для точных выстрелов на большие расстояния. Предназначено для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/railgun/anti_crew
