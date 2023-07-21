// 10mm

/obj/item/ammo_casing/c10mm
	name = "10мм патрон"
	desc = "Обычный патрон калибра 10мм. Используется в пистолетах и пистолет-пулеметах."
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/c10mm

/obj/item/ammo_casing/c10mm/ap
	name = "бронебойный 10мм патрон"
	desc = "Содержит пулю с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолетах и пистолет-пулеметах."
	projectile_type = /obj/projectile/bullet/c10mm_ap

/obj/item/ammo_casing/c10mm/hp
	name = "экспансивный 10мм патрон"
	desc = "Снаряжен пулей со смещенным центром тяжести. Наносит повышенный урон, однако заметно хуже пробивает броню. Используется в пистолетах и пистолет-пулеметах."
	projectile_type = /obj/projectile/bullet/c10mm_hp

/obj/item/ammo_casing/c10mm/fire
	name = "зажигательный 10мм патрон"
	desc = "При удачном попадании поджигает цель. Немного слабее стандартных пуль. Используется в пистолетах и пистолет-пулеметах."
	projectile_type = /obj/projectile/bullet/incendiary/c10mm

// 9mm (Makarov and Stechkin APS)

/obj/item/ammo_casing/c9mm
	name = "9мм патрон"
	desc = "Обычный патрон калибра 9мм. Используется в пистолетах и пистолет-пулеметах."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/c9mm

/obj/item/ammo_casing/c9mm/ap
	name = "бронебойный 9мм патрон"
	desc = "Содержит пулю с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолетах и пистолет-пулеметах."
	projectile_type =/obj/projectile/bullet/c9mm_ap

/obj/item/ammo_casing/c9mm/hp
	name = "экспансивный 9мм патрон"
	desc = "Снаряжен пулей со смещенным центром тяжести. Наносит повышенный урон, однако заметно хуже пробивает броню. Используется в пистолетах и пистолет-пулеметах."
	projectile_type = /obj/projectile/bullet/c9mm_hp

/obj/item/ammo_casing/c9mm/fire
	name = "зажигательный 9мм патрон"
	desc = "При удачном попадании поджигает цель. Немного слабее стандартных пуль. Используется в пистолетах и пистолет-пулеметах."
	projectile_type = /obj/projectile/bullet/incendiary/c9mm

/obj/item/ammo_casing/c9mm/traumatic
	name = "травматический 9мм патрон"
	desc = "Боевая пуля заменена на резиновую болванку. Практически не наносит урона, однако валит с пары-тройки попаданий."
	projectile_type = /obj/projectile/bullet/traumatic

// .50AE (Desert Eagle)

/obj/item/ammo_casing/a50ae
	name = "патрон .50AE калибра"
	desc = "Обычный патрон калибра 50AE. Используется в пистолете Пустынный Орел."
	caliber = ".50"
	projectile_type = /obj/projectile/bullet/a50ae
