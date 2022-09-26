/obj/item/ammo_box/magazine/sniper_rounds
	name = "магазин .50 калибра"
	desc = "Содержит обычные патроны .50 калибра. Используется в крупнокалиберных снайперских винтовках."
	icon_state = ".50mag"
	ammo_type = /obj/item/ammo_casing/p50
	max_ammo = 6
	caliber = ".50"

/obj/item/ammo_box/magazine/sniper_rounds/update_icon()
	..()
	if(ammo_count())
		icon_state = "[initial(icon_state)]-ammo"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/ammo_box/magazine/sniper_rounds/soporific
	name = "магазин .50 калибра: Транквилизатор"
	desc = "Содержат патроны .50 специализирующийся на отправке цели в сон, а не в ад. Используется в крупнокалиберных снайперских винтовках."
	icon_state = "soporific"
	ammo_type = /obj/item/ammo_casing/p50/soporific
	max_ammo = 3
	caliber = ".50"

/obj/item/ammo_box/magazine/sniper_rounds/penetrator
	name = "магазин .50 калибра: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в крупнокалиберных снайперских винтовках."
	ammo_type = /obj/item/ammo_casing/p50/penetrator
	max_ammo = 5

/obj/item/ammo_box/magazine/sniper_rounds/marksman
	name = "магазин .50 калибра: Высокоточный"
	desc = "Содержат высококачественные патроны, пуля из которых с высокой вероятностью рикошетит и доводится на противника. Используется в крупнокалиберных снайперских винтовках."
	ammo_type = /obj/item/ammo_casing/p50/marksman
	max_ammo = 5
