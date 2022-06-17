/obj/item/gun/ballistic/automatic/pistol/traumatic
	name = "Еnforcer T46"
	desc = "Эти штуки были взяты буквально с боем. Теперь это обыденность."
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

/obj/item/ammo_box/magazine/traumatic
	name = "handgun traumatic magazine (9mm)"
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/traumatic
	caliber = "9mm"
	max_ammo = 8

/obj/item/ammo_box/magazine/traumatic/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "45-8"
	else
		icon_state = "45-[ammo_count()]"

/obj/item/ammo_casing/traumatic
	name = "9mm traumatic bullet casing"
	desc = "A 9mm traumatic bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/traumatic

/obj/projectile/bullet/traumatic
	name = "9mm traumatic bullet"
	damage = 3 //наша резина делает больно, не более
	stamina = 90
