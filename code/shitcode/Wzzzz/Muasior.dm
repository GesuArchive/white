/obj/item/gun/ballistic/automatic/pistol/luger
	name = "Luger P08"
	desc = "German 9mm pistol."
	icon = 'code/shitcode/Wzzzz/icons/Weea.dmi'
	icon_state = "luger"
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'code/shitcode/Wzzzz/Gunshot_light.ogg'
	mag_type = /obj/item/ammo_box/magazine/luger
	can_suppress = FALSE
	slot_flags = ITEM_SLOT_BELT


/obj/item/ammo_box/magazine/luger
	name = "Luger magazine"
	desc = "A luger magazine."
	icon = 'code/shitcode/Wzzzz/icons/ammo.dmi'
	icon_state = "lugermag"
	item_state = "lugermag"
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/luger
	max_ammo = 8
	multiple_sprites = TRUE

/obj/item/ammo_box/magazine/luger/battle
	name = "Luger magazine (9mm battle)"
	ammo_type = /obj/item/ammo_casing/lugerb


/obj/item/ammo_box/magazine/luger/rubber
	name = "Luger magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/luger

/obj/item/projectile/bullet/pistol/rubber
	name = "rubber bullet"
	damage = 5
	stamina = 25

/obj/item/projectile/bullet/pistol/battle
	name = "9mm bullet"
	damage = 20

/obj/item/ammo_casing/luger
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/lugerb
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol/battle