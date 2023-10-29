/obj/item/ammo_box/magazine/m10mm
	name = "10мм магазин"
	desc = "Содержит обычные патроны калибра 10мм. Используется в пистолете Таннер М41."
	icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m10mm/fire
	name = "10мм магазин: Зажигательный"
	desc = "Содержит пули поджигающие цель. Немного слабее стандартных пуль. Используется в пистолете Таннер М41."
	icon_state = "9x19pI"
	ammo_type = /obj/item/ammo_casing/c10mm/fire

/obj/item/ammo_box/magazine/m10mm/hp
	name = "10мм магазин: Экспансивный"
	desc = "Содержит пули со смещенным центром тяжести. Наносят повышенный урон, однако заметно хуже пробивают броню. Используется в пистолете Таннер М41."
	icon_state = "9x19pH"
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/m10mm/ap
	name = "10мм магазин: Бронебойный"
	desc = "Содержит пули с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолете Таннер М41."
	icon_state = "9x19pA"
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/m45
	name = "магазин .45 калибра"
	desc = "Содержит обычные патроны .45 калибра. Используется в пистолете M1911."
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 8

/obj/item/ammo_box/magazine/m45/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "45-8"
	else
		icon_state = "45-[ammo_count()]"

/obj/item/ammo_box/magazine/m9mm
	name = "9мм магазин"
	desc = "Содержит обычный патроны калибра 9мм. Используется в пистолете Макарова."
	icon_state = "9x19p-8"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 8

/obj/item/ammo_box/magazine/m9mm/update_icon()
	..()
	icon_state = "9x19p-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m9mm/fire
	name = "9мм магазин: Зажигательный"
	desc = "Содержит патроны поджигающие цель. Немного слабее стандартных пуль. Используется в пистолете Макарова."
	icon_state = "9x19pI"
	ammo_type = /obj/item/ammo_casing/c9mm/fire

/obj/item/ammo_box/magazine/m9mm/hp
	name = "9мм магазин: Экспансивный"
	desc = "Содержит патроны со смещенным центром тяжести. Наносят повышенный урон, однако заметно хуже пробивают броню. Используется в пистолете Макарова."
	icon_state = "9x19pH"
	ammo_type = /obj/item/ammo_casing/c9mm/hp

/obj/item/ammo_box/magazine/traumatic
	name = "9мм магазин: Травматический"
	desc = "Боевая пуля в них заменена на резиновую болванку. Практически не наносит урона, однако валит с пары-тройки попаданий."
	icon_state = "45-10"
	ammo_type = /obj/item/ammo_casing/c9mm/traumatic
	caliber = "9mm"
	max_ammo = 10

/obj/item/ammo_box/magazine/traumatic/update_icon()
	..()
	if (ammo_count() >= 10)
		icon_state = "45-10"
	else
		icon_state = "45-[ammo_count()]"

/obj/item/ammo_box/magazine/m9mm/ap
	name = "9мм магазин: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолете Макарова."
	icon_state = "9x19pA"
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_box/magazine/m9mm_aps
	name = "удлиненный 9мм магазин"
	desc = "Содержит обычные патроны калибра 9мм. Используется в АПС."
	icon_state = "9mmaps-15"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 20

/obj/item/ammo_box/magazine/m9mm_aps/update_icon()
	. = ..()
	icon_state = "9mmaps-[round(ammo_count(),5)]"

/obj/item/ammo_box/magazine/m9mm_aps/fire
	name = "удлиненный 9мм магазин: Зажигательный"
	desc = "При удачном попадании поджигает цель. Немного слабее стандартных пуль. Используется в АПС"
	ammo_type = /obj/item/ammo_casing/c9mm/fire
	max_ammo = 20

/obj/item/ammo_box/magazine/m9mm_aps/hp
	name = "удлиненный 9мм магазин: Экспансивный"
	desc = "Содержит патроны со смещенным центром тяжести. Наносят повышенный урон, однако заметно хуже пробивают броню. Используется в АПС."
	ammo_type = /obj/item/ammo_casing/c9mm/hp
	max_ammo = 20

/obj/item/ammo_box/magazine/m9mm_aps/ap
	name = "удлиненный 9мм магазин: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в АПС."
	ammo_type = /obj/item/ammo_casing/c9mm/ap
	max_ammo = 20

/obj/item/ammo_box/magazine/m50
	name = "магазин .50АЕ калибра"
	desc = "Содержит обычные патроны калибра 10мм. Используется в пистолете Пустынный Орел."
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/a50ae
	caliber = ".50"
	max_ammo = 7
	multiple_sprites = AMMO_BOX_PER_BULLET
