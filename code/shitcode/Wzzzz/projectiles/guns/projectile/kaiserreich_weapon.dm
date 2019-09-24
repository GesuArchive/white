/obj/item/weapon/gun/projectile/luger
	name = "Luger P08"
	desc = "German 9mm pistol."
	icon_state = "luger"
	w_class = ITEM_SIZE_SMALL
	max_shells = 8
	caliber = "9mm"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/luger/rubber
	allowed_magazines = /obj/item/ammo_magazine/luger

/obj/item/weapon/gun/projectile/mauser
	name = "Mauser C96"
	desc = "German 9mm pistol. Still da, ihr Redner! Du hast das Wort, rede, Genosse Mauser!"
	icon_state = "c96"
	w_class = ITEM_SIZE_SMALL
	max_shells = 10
	caliber = "9mm"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mauser/rubber
	allowed_magazines = /obj/item/ammo_magazine/mauser

/obj/item/weapon/gun/projectile/automatic/mp40
	name = "MP-40"
	desc = "German submachinegun chambered in 9x19 Parabellum, with a 32 magazine magazine layout. Standard issue amongst most troops."
	icon_state = "mp40"
	item_state = "mp40"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	caliber = "9mm"
	magazine_type = /obj/item/ammo_magazine/mp40
	allowed_magazines = /obj/item/ammo_magazine/mp40
	one_hand_penalty = 2

	firemodes = list(
		list(mode_name="single shot",	burst=1, burst_delay=1.5, move_delay=2, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="short bursts",	burst=3, burst_delay=1.5, move_delay=4, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=5, burst_delay=1.5, move_delay=6, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)


/obj/item/weapon/gun/projectile/automatic/mp40/update_icon()
	icon_state = (ammo_magazine)? "mp40" : "mp400"
	wielded_item_state = (ammo_magazine)? "mp40-w" : "mp400"
	..()

/// Идет калибр, который не хочет арбайтен!!!
/// ШАЙЗЕ, АРБАЙТЕН!

/obj/item/weapon/gun/projectile/automatic/stg
	name = "STG-44"
	desc = "German assault rifle with a 30 round magazine, chambered in 7.92x33mm Kurz ammunition. It is a devastating weapon."
	icon_state = "stg"
	item_state = "stg"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	caliber = "a792x33"
	fire_sound = 'sound/weapons/stg.ogg'
	reload_sound = 'sound/weapons/stg_reload.ogg'
	magazine_type = /obj/item/ammo_magazine/stg
	allowed_magazines = /obj/item/ammo_magazine/stg
	one_hand_penalty = 3

/obj/item/weapon/gun/projectile/automatic/stg/update_icon()
	icon_state = (ammo_magazine)? "stg" : "stg0"
	wielded_item_state = (ammo_magazine)? "stg-w" : "stg0"
	..()


/obj/item/weapon/gun/projectile/automatic/mg34
	name = "MG-34"
	desc = "German light machinegun chambered in 7.92x57mm Mauser ammunition. An utterly devastating support weapon."
	icon_state = "mg34"
	item_state = "mg34"
	w_class = ITEM_SIZE_HUGE
	force = 10
	max_shells = 50
	caliber = "a792x57"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762
	allowed_magazines = /obj/item/ammo_magazine/a762
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'

	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=6, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=8, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	var/cover_open = FALSE

/obj/item/weapon/gun/projectile/automatic/mg34/special_check(mob/user)
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/automatic/mg34/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/mg34/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, TRUE)
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, TRUE)
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/mg34/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to unload [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/kar98k
	name = "Kar-98K"
	desc = "German bolt-action rifle chambered modified in 7.92x57mm Mauser ammunition. It looks clean and well-fabricated."
	icon_state = "kar98k"
	item_state = "kar98k"
	caliber = "a792x57"
	w_class = ITEM_SIZE_HUGE
	var/bolt_open = 0
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	one_hand_penalty = 2
	fire_sound = 'sound/weapons/kar_shot.ogg'
	magazine_type = /obj/item/ammo_magazine/kar98k
	allowed_magazines = /obj/item/ammo_magazine/kar98k

//This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
/obj/item/weapon/gun/projectile/shotgun/kar98k/update_icon(var/add_scope = FALSE)
	if(add_scope)
		if(bolt_open)
			icon_state = "kar98k_scope_open"
			item_state = "kar98k_scope"
			return
		else
			icon_state = "kar98k_scope"
			item_state = "kar98k_scope"
			return
	if(bolt_open)
		if(!findtext(icon_state, "_open"))
			icon_state = addtext(icon_state, "_open") //open
	else if(icon_state == "kar98k_scope_open") //closed
		icon_state = "kar98k_scope"
	else if(icon_state == "kar98k_scope")
		return
	else
		icon_state = "kar98k"