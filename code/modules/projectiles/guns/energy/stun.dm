/obj/item/gun/energy/taser
	name = "тазер"
	desc = "Энергетический электрошокер малой мощности, используемый группами безопасности для подавления целей на расстоянии."
	icon_state = "taser"
	inhand_icon_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	ammo_x_offset = 3

/obj/item/gun/ballistic/rifle/boltaction/taser
	name = "тазер"
	desc = "Устройство для запуска шаров сжатой болевой энергии по живым целям."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "painser"
	inhand_icon_state = "painser"
	fire_sound = 'sound/weapons/taser.ogg'
	inhand_icon_state = "painser"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/taser
	can_be_sawn_off = FALSE

/obj/item/gun/ballistic/rifle/boltaction/taser/update_overlays()
	. = ..()
	. = null

/obj/item/gun/energy/tesla_revolver
	name = "тесла пушка"
	desc = "Экспериментальная пушка, основанная на экспериментальном двигателе, с такой же вероятностью убьет своего оператора, как и цель."
	icon_state = "tesla"
	inhand_icon_state = "tesla"
	ammo_type = list(/obj/item/ammo_casing/energy/tesla_revolver)
	shaded_charge = 1

/obj/item/gun/energy/e_gun/advtaser
	name = "гибридный тазер"
	desc = "Двухрежимный тазер, предназначенный для стрельбы как мощными электродами ближнего радиуса действия, так и лучами дальнего действия."
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2
	fire_delay = 10

/obj/item/gun/energy/e_gun/advtaser/cyborg
	name = "тазер киборга"
	desc = "Интегрированный гибридный электрошокер, который берет прямо из силовой ячейки киборга. Оружие содержит ограничитель для предотвращения перегрева силовой ячейки киборга."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/e_gun/advtaser/cyborg/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/advtaser/cyborg/make_jamming()
	return

/obj/item/gun/energy/disabler
	name = "усмиритель"
	desc = "Оружие самообороны, которое истощает органические цели, ослабляя их, пока они не упадут."
	icon_state = "disabler"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2
	fire_delay = 2

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/disabler/cyborg
	name = "усмиритель киборга"
	desc = "Встроенный блокировщик, который питается от силовой ячейки киборга. Это оружие содержит ограничитель для предотвращения перегрева силовой ячейки киборга."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/disabler/cyborg/make_jamming()
	return

/obj/item/gun/energy/taser/triser
	name = "тризер"
	desc = "Энергетический электрошокер средней мощности, используемый группами безопасности для подавления целей на расстоянии. Этот должен работать наверняка."
	icon = 'white/valtos/icons/objects.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	fire_sound = 'white/valtos/sounds/rapidslice.ogg'
	icon_state = "taser"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	cell_type = "/obj/item/stock_parts/cell/pulse/pistol"
	ammo_x_offset = 3
	fire_delay = 2
	burst_size = 3
