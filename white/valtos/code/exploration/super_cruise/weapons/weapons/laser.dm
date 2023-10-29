//Single Laser

/obj/machinery/shuttle_weapon/laser
	name = "лазерная пушка"
	desc = "Настенная лазерная пушка, предназначенная для использования на шаттлах."
	icon_state = "laser_on"
	base_icon_state = "laser"
	projectile_type = /obj/projectile/bullet/shuttle/beam/laser
	cooldown = 60
	innaccuracy = 1
	strength_rating = 10

/obj/item/wallframe/shuttle_weapon/laser
	name = "рама лазерной пушки"
	result_path = /obj/machinery/shuttle_weapon/laser

//Triple Laser

/obj/machinery/shuttle_weapon/laser/triple
	name = "лазерная пушка серийного огня MK.I"
	icon_state = "laser_tri_on"
	base_icon_state = "laser_tri"
	cooldown = 80
	innaccuracy = 1
	shots = 3
	strength_rating = 25

/obj/item/wallframe/shuttle_weapon/laser/triple
	name = "рама лазерной пушка серийного огня MK.I"
	result_path = /obj/machinery/shuttle_weapon/laser/triple

//Mark 2 Laser

/obj/machinery/shuttle_weapon/laser/triple/mark2
	name = "лазерная пушка серийного огня MK.II"
	desc = "Модернизированная версия настенной лазерной пушки, предназначенная для использования на шаттлах."
	icon_state = "laser_tri_mk2_on"
	base_icon_state = "laser_tri_mk2"
	cooldown = 160
	innaccuracy = 2
	shots = 5
	strength_rating = 45

/obj/item/wallframe/shuttle_weapon/laser/triple/mark2
	name = "рама лазерной пушки серийного огня MK.II"
	desc = "Модернизированная версия настенной лазерной пушки, предназначенная для использования на шаттлах."
	result_path = /obj/machinery/shuttle_weapon/laser/triple/mark2
