// .50 (Sniper)

/obj/item/ammo_casing/p50
	name = "патрон .50 калибра"
	desc = "Обычный патрон .50 калибра. Используется в крупнокалиберных снайперских винтовках."
	caliber = ".50"
	projectile_type = /obj/projectile/bullet/p50
	icon_state = ".50"

/obj/item/ammo_casing/p50/soporific
	name = "транквилизаторный патрон .50 калибра"
	desc = "Патрон .50 специализирующийся на отправке цели в сон, а не в ад. Используется в крупнокалиберных снайперских винтовках."
	projectile_type = /obj/projectile/bullet/p50/soporific
	icon_state = "sleeper"
	harmful = FALSE

/obj/item/ammo_casing/p50/penetrator
	name = "бронебойный патрон .50 калибра"
	desc = "Содержит пулю с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в крупнокалиберных снайперских винтовках."
	projectile_type = /obj/projectile/bullet/p50/penetrator

/obj/item/ammo_casing/p50/marksman
	name = "высокоточный патрон .50 калибра"
	desc = "Высококачественный патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника. Используется в крупнокалиберных снайперских винтовках."
	projectile_type = /obj/projectile/bullet/p50/marksman
