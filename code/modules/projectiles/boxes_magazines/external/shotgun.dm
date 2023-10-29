/obj/item/ammo_box/magazine/m12g
	name = "барабанный магазин 12 калибра: Картечь"
	desc = "Содержит крупную картечь 12 калибра. Используется в дробовике Бульдог."
	icon_state = "m12gb"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "shotgun"
	max_ammo = 8

/obj/item/ammo_box/magazine/m12g/update_icon()
	..()
	icon_state = "[initial(icon_state)]-[CEILING(ammo_count(FALSE)/8, 1)*8]"

/obj/item/ammo_box/magazine/m12g/stun
	name = "барабанный магазин 12 калибра: Электрошок"
	desc = "Содержит останавливающие пули с живительным зарядом энергии внутри. Используется в дробовике Бульдог."
	icon_state = "m12gs"
	ammo_type = /obj/item/ammo_casing/shotgun/stunslug

/obj/item/ammo_box/magazine/m12g/slug
	name = "барабанный магазин 12 калибра: Пулевой"
	desc = "Содержит свинцовые пули для ружей 12 калибра. Используется в дробовике Бульдог."
	icon_state = "m12gb"    //this may need an unique sprite
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/magazine/m12g/dragon
	name = "барабанный магазин 12 калибра: Дракон"
	desc = "Выстреливает снопом зажигательных зарядов. Используется в дробовике Бульдог."
	icon_state = "m12gf"
	ammo_type = /obj/item/ammo_casing/shotgun/dragonsbreath

/obj/item/ammo_box/magazine/m12g/bioterror
	name = "барабанный магазин 12 калибра: Биотеррор"
	desc = "Содержит патроны наполненные смертельными токсинами. Используется в дробовике Бульдог."
	icon_state = "m12gt"
	ammo_type = /obj/item/ammo_casing/shotgun/dart/bioterror

/obj/item/ammo_box/magazine/m12g/meteor
	name = "барабанный магазин 12 калибра: Метеор"
	desc = "Содержит пули оснащенные технологией CMC, которая при выстреле запускает массивный снаряд. Используется в дробовике Бульдог."
	icon_state = "m12gbc"
	ammo_type = /obj/item/ammo_casing/shotgun/meteorslug

/obj/item/ammo_box/magazine/m12g/limitka
	name = "барабанный магазин 12 калибра: FRAG-80"
	desc = "Смерть до горизонта. Используется в дробовике Бульдог."
	icon_state = "m12gbc"
	ammo_type = /obj/item/ammo_casing/shotgun/bombslug

/obj/item/ammo_box/magazine/m12g/apslug
	name = "барабанный магазин 12 калибра: Бронебойный"
	desc = "Содержит бронебойные патроны с копьевидной пулей. Используется в дробовике Бульдог."
	icon_state = "m12gb"
	ammo_type = /obj/item/ammo_casing/shotgun/apslug
