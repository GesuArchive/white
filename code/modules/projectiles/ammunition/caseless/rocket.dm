/obj/item/ammo_casing/caseless/rocket
	name = "ПГ-7ВС"
	desc = "Фугасная 84-миллиметровая Ракета. Повышенная зона поражения."
	caliber = "84mm"
	icon_state = "srm-8"
	projectile_type = /obj/projectile/bullet/a84mm_he

/obj/item/ammo_casing/caseless/rocket/update_icon()
	. = ..()
	icon_state = "[initial(icon_state)]"

/obj/item/ammo_casing/caseless/rocket/hedp
	name = "ПГ-7ВЛ \"Луч\""
	desc = "Кумулятивная 84-миллиметровая Ракета. Повышенное бронепробитие."
	caliber = "84mm"
	icon_state = "84mm-hedp"
	projectile_type = /obj/projectile/bullet/a84mm

/obj/item/ammo_casing/caseless/rocket/weak
	name = "ПГ-7В"
	desc = "Фугасная 84-миллиметровая Ракета. Уменьшенная зона поражения."
	projectile_type = /obj/projectile/bullet/a84mm_weak

/obj/item/ammo_casing/caseless/a75
	desc = "патрон .75 калибра."
	caliber = "75"
	icon_state = "s-casing-live"
	projectile_type = /obj/projectile/bullet/gyro
