// 7.62 (Nagant Rifle)

/obj/item/ammo_casing/a762
	name = "патрон калибра 7.62мм"
	desc = "Обычный патрон калибра 7.62мм. Используется в различных винтовках."
	icon_state = "762-casing"
	caliber = "a762"
	projectile_type = /obj/projectile/bullet/a762

/obj/item/ammo_casing/a762/enchanted
	name = "травматический патрон калибра 7.62мм"
	desc = "Стандартная пуля заменена на резиновую болванку. Урон значительно снижен, однако такие попадания сильно изматывают цель, а пули могут рекошетить от стен. Используется в различных винтовках."
	projectile_type = /obj/projectile/bullet/a762_enchanted

// 5.56mm (M-90gl Carbine)

/obj/item/ammo_casing/a556
	name = "патрон калибра 5.56мм"
	desc = "Обычный патрон калибра 5.56мм. Используется в различных винтовках."
	caliber = "a556"
	projectile_type = /obj/projectile/bullet/a556

/obj/item/ammo_casing/a556/phasic
	name = "блюспейс патрон калибра 5.56мм"
	desc = "Снаряжен пулей способой проходить сквозь препятствия, однако ее урон значительно снижен. Используется в различных винтовках."
	projectile_type = /obj/projectile/bullet/a556/phasic

// 40mm (Grenade Launcher)

/obj/item/ammo_casing/a40mm
	name ="40мм граната"
	desc = "Боевая фугасная граната, которая может быть активирована только при выстрела из гранатомета."
	caliber = "40mm"
	icon_state = "40mmHE"
	projectile_type = /obj/projectile/bullet/a40mm
