//Centaur I

/obj/machinery/shuttle_weapon/missile
	name = "ракетная пушка \"Центавра-I\""
	desc = "Настенная ракетная установка, предназначенная для использования на шаттлах"
	icon_state = "missile_on"
	base_icon_state = "missile"
	projectile_type = /obj/projectile/bullet/shuttle/missile/mini
	cooldown = 180
	innaccuracy = 1
	strength_rating = 50

/obj/item/wallframe/shuttle_weapon/missile
	name = "рама ракетной пушки"
	desc = "Настенная ракетная установка с трехосковыми ракетами, предназначенные для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/missile

//Centaur II

/obj/machinery/shuttle_weapon/missile/tri
	name = "ракетная пушка \"Центавра-II\""
	desc = "Настенная ракетная установка с трехосковыми ракетами, предназначенные для использования на шаттлах."
	icon_state = "missile_mk2_on"
	base_icon_state = "missile_mk2"
	projectile_type = /obj/projectile/bullet/shuttle/missile/mini
	cooldown = 250
	innaccuracy = 3
	shots = 3
	strength_rating = 95

/obj/item/wallframe/shuttle_weapon/missile/tri
	name = "рама ракетной пушки MK.II"
	desc = "Настенная ракетная установка с трехосковыми ракетами, предназначенные для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/missile/tri

//Minotaur

/obj/machinery/shuttle_weapon/missile/breach
	name = "бронебойная ракетная установка"
	desc = "Настенная пусковая установка с бронебойными ракетами, предназначенная для использования на шаттлах."
	icon_state = "missile_breach_on"
	base_icon_state = "missile_breach"
	projectile_type = /obj/projectile/bullet/shuttle/missile/breach
	cooldown = 220
	innaccuracy = 2
	strength_rating = 70

/obj/item/wallframe/shuttle_weapon/missile/breach
	name = "рама бронебойной ракетной установки"
	desc = "Настенная пусковая установка с бронебойными ракетами, предназначенная для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/missile/breach

//Prometheus

/obj/machinery/shuttle_weapon/missile/fire
	name = "зажигательная ракетная установка"
	desc = "Настенная пусковая установка для зажигательных ракет, предназначенная для использования на шаттлах."
	icon_state = "missile_fire_on"
	base_icon_state = "missile_fire"
	projectile_type = /obj/projectile/bullet/shuttle/missile/fire
	cooldown = 200
	innaccuracy = 3
	strength_rating = 30

/obj/item/wallframe/shuttle_weapon/missile/fire
	name = "рама зажигательной ракетной установки"
	desc = "Настенная пусковая установка для зажигательных ракет, предназначенная для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/missile/fire

//Devourer

/*
/obj/machinery/shuttle_weapon/missile/black_hole
	name = "Devourer Missile Launcher"
	projectile_type = /obj/projectile/bullet/shuttle/missile/black_hole
	cooldown = 10000
	hit_chance = 100
	miss_chance = 0
	innaccuracy = 0
	//Please don't spawn me
	strength_rating = 50000

/obj/machinery/shuttle_weapon/missile/black_hole/Initialize(mapload, ndir)
	. = ..()
	priority_announce(
		"A class-5 anomaly weapon has been detected in a local sector. This weapon is capable of producing a gravitational singularity that will dsetroy everything in this sector. Destroy that weapon at all costs.",
		"Nanotrasen Superweapons Division")
	next_shot_world_time = world.time + 2 MINUTES
*/
