// Имя - описание
// Двигатель/Защита/Маневровые

// "Ураган"  - самый быстрый фонсер, с прекрасной маневренностью. Защитное поле минимальное.
// 106/330/103

// "Торнадо" - самый маневренный фонсер, обладающий замечательными скоростными качествами. Защита минимальна.
// 103/330/106

// "Вихрь" 	 - самый защищенный фонсер, но скорость и маневренность оставляют желать лучшего.
// 100/450/100

// "Бриз" 	 - самая распространенная модель фонсера. Все показатели на среднем уровне.
// 97/530/97

/obj/vehicle/sealed/fonser
	name = "Фонсер"

	icon = 'icons/obj/bike.dmi'
	icon_state = "speedbike_black"
	layer = LYING_MOB_LAYER
	var/cover_iconstate = "cover_black"

	bound_width = 32
	bound_height = 32
	base_pixel_x = -16
	base_pixel_y = -16

	movement_type = FLYING

	max_integrity = 330

	generic_canpass = FALSE

	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)

	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG

	var/datum/component/funny_movement/movement

	var/thru = 5
	var/mane = 10

/obj/vehicle/sealed/fonser/Initialize(mapload)
	. = ..()
	add_overlay(image(icon, cover_iconstate, ABOVE_MOB_LAYER))

/obj/vehicle/sealed/fonser/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("<b>Броня:</b> [max_integrity]\n")
	. += span_notice("<b>Скорость:</b> [thru]\n")
	. += span_notice("<b>Манёвренность:</b> [mane]")

/obj/vehicle/sealed/fonser/Move(newloc, move_dir)
	if(occupants.len)
		new /obj/effect/temp_visual/dir_setting/speedbike_trail(loc,move_dir)
	return ..()

/obj/vehicle/sealed/fonser/ComponentInitialize()
	movement = AddComponent(/datum/component/funny_movement)
	movement.icon_dir_num = 1
	movement.maxthrust_forward = -thru
	movement.maxthrust_backward = -thru + 1
	RegisterSignal(movement, COMSIG_FUNNY_MOVEMENT_PROCESSING_FINISH, PROC_REF(funny_movement_moved))

/obj/vehicle/sealed/fonser/proc/funny_movement_moved()
	SIGNAL_HANDLER
	movement.desired_thrust_dir = 0

/obj/vehicle/sealed/fonser/vehicle_move(direction)
	if(direction & NORTH)
		movement.desired_thrust_dir |= NORTH
	if(direction & SOUTH)
		movement.desired_thrust_dir |= SOUTH
	if(direction & WEST)
		movement.desired_angle = movement.angle - mane
	if(direction & EAST)
		movement.desired_angle = movement.angle + mane

/obj/vehicle/sealed/fonser/uragan
	name = "Ураган"
	desc = "Самый быстрый фонсер, с прекрасной маневренностью. Защитное поле минимальное"
	icon_state = "speedbike_red"
	cover_iconstate = "cover_red"

	max_integrity = 330

	thru = 8
	mane = 20

/obj/vehicle/sealed/fonser/tornado
	name = "Торнадо"
	desc = "Самый маневренный фонсер, обладающий замечательными скоростными качествами. Защита минимальна."
	icon_state = "speedbike_blue"
	cover_iconstate = "cover_blue"

	max_integrity = 330

	thru = 7
	mane = 30

/obj/vehicle/sealed/fonser/vihr
	name = "Вихрь"
	desc = "Самый защищенный фонсер, но скорость и маневренность оставляют желать лучшего."
	icon_state = "speedbike_yellow"
	cover_iconstate = "cover_yellow"

	max_integrity = 450

	thru = 6
	mane = 15

/obj/vehicle/sealed/fonser/breeze
	name = "Бриз"
	desc = "Самая распространенная модель фонсера. Все показатели на среднем уровне."
	icon_state = "speedbike_black"
	cover_iconstate = "cover_black"

	max_integrity = 530

	thru = 5
	mane = 10
