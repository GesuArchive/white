/area/holodeck
	name = "Голодек"
	icon_state = "Holodeck"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT | HIDDEN_AREA
	sound_environment = SOUND_ENVIRONMENT_PADDED_CELL

	var/obj/machinery/computer/holodeck/linked
	var/restricted = FALSE // if true, program goes on emag list
	network_root_id = "HOLODECK"
/*
	Power tracking: Use the holodeck computer's power grid
	Asserts are to avoid the inevitable infinite loops
*/

/area/holodeck/powered(chan)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return A.powered(chan)

/area/holodeck/addStaticPower(value, powerchannel)
	if(!linked)
		return
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return ..()

/area/holodeck/use_power(amount, chan)
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/holodeck))
	return ..()


/*
	This is the standard holodeck.  It is intended to allow you to
	blow off steam by doing stupid things like laying down, throwing
	spheres at holes, or bludgeoning people.
*/
/area/holodeck/rec_center
	name = "Голодек: Центр"

/area/holodeck/rec_center/offline
	name = "Голодек: Оффлайн"

/area/holodeck/rec_center/court
	name = "Голодек: Пустое поле"

/area/holodeck/rec_center/dodgeball
	name = "Голодек: Поле доджбола"

/area/holodeck/rec_center/basketball
	name = "Голодек: Поле баскетбола"

/area/holodeck/rec_center/thunderdome
	name = "Голодек: Арена тандердома"

/area/holodeck/rec_center/beach
	name = "Голодек: Пляж"

/area/holodeck/rec_center/lounge
	name = "Голодек: Гостиная"

/area/holodeck/rec_center/pet_lounge
	name = "Голодек: Парк животных"

/area/holodeck/rec_center/firingrange
	name = "Голодек: Тир"

/area/holodeck/rec_center/school
	name = "Голодек: Аниме-школа"

/area/holodeck/rec_center/chapelcourt
	name = "Голодек: Пыточная церкви"

/area/holodeck/rec_center/spacechess
	name = "Голодек: Космошахматы"

/area/holodeck/rec_center/spacecheckers
	name = "Голодек: Космошашки"

/area/holodeck/rec_center/kobayashi
	name = "Голодек: Кобаяши Мару"

/area/holodeck/rec_center/winterwonderland
	name = "Голодек: Зимняя сказка"

/area/holodeck/rec_center/photobooth
	name = "Голодек: Фотокабина"

/area/holodeck/rec_center/skatepark
	name = "Голодек: Скейт-парк"

// Bad programs

/area/holodeck/rec_center/medical
	name = "Голодек: Медбей"
	restricted = TRUE

/area/holodeck/rec_center/thunderdome1218
	name = "Голодек: 1218 AD"
	restricted = TRUE

/area/holodeck/rec_center/burn
	name = "Голодек: Тест Атмоса"
	restricted = TRUE

/area/holodeck/rec_center/wildlife
	name = "Голодек: Моделирование дикой природы"
	restricted = TRUE

/area/holodeck/rec_center/bunker
	name = "Голодек: Бункер защиты"
	restricted = TRUE

/area/holodeck/rec_center/anthophila
	name = "Голодек: Антофилия"
	restricted = TRUE

/area/holodeck/rec_center/refuel
	name = "Голодек: Заправочная станция"
	restricted = TRUE
