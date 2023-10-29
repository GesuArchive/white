/obj/item/gun/ballistic/automatic/pistol/traumatic
	name = "Блюститель T46"	//добавлен в карго
	desc = "Современный пистолет используемый частными охранными компаниями для задержания преступников. Обычно снаряжается травматическими боеприпасами."
	icon = 'white/valtos/icons/gun.dmi'
	icon_state = "enforcer"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/traumatic
	can_suppress = TRUE
	var/boltcolor
	var/list/possible_colors = list("black", "green", "tan", "red", "grey")

/obj/item/gun/ballistic/automatic/pistol/traumatic/Initialize(mapload)
	icon_state = "enforcer_[pick(possible_colors)]"
	if (!boltcolor)
		boltcolor = pick(possible_colors)
	. = ..()

/obj/item/gun/ballistic/automatic/pistol/traumatic/update_icon()
	if (QDELETED(src))
		return
	..()
	cut_overlays()
	if (bolt_type == BOLT_TYPE_LOCKING)
		add_overlay("[icon_state]_[boltcolor]_bolt[bolt_locked ? "_locked" : ""]")
	if (suppressed)
		add_overlay("[icon_state]_supp")

/obj/item/gun/ballistic/automatic/pistol/traumatic/no_mag
	spawnwithmagazine = FALSE
