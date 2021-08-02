/obj/item/gun/ballistic/automatic/fallout/railgun
	name = "Бластер Б-7 \"Козырь\""
	desc = "Высокоточное оружие, которое используется в основном на фронте. Одного выстрела достаточно, чтобы распилить станцию напополам."
	icon_state = "railgun"
	inhand_icon_state = "railgun"
	mag_type = /obj/item/ammo_box/magazine/fallout/railgun
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/tribeam/tribeam1.ogg'
	load_sound = 'white/valtos/sounds/ebutt.ogg'
	load_empty_sound = 'white/valtos/sounds/ebutt.ogg'
	rack_sound = 'white/valtos/sounds/ebutt.ogg'
	eject_sound = 'white/valtos/sounds/ebutt.ogg'
	eject_empty_sound = 'white/valtos/sounds/ebutt.ogg'
	bolt_drop_sound = 'white/valtos/sounds/ebutt.ogg'
	empty_alarm_sound = 'white/valtos/sounds/ebutt.ogg'
	can_suppress = FALSE
	burst_size = 5
	fire_delay = 1
	extra_damage = 1500
	extra_penetration = 1500
	force = 1500
	spread = 0
	recoil = 0
	automatic = 1

/obj/item/ammo_box/magazine/fallout/railgun
	name = "БРХС-1000ПВ"
	desc = "Магазин к бластеру. Боезапас, к сожалению, ограничен."
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "railgun"
	ammo_type = /obj/item/ammo_casing/fallout/railgun
	caliber = "railgun"
	max_ammo = 1000
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/fallout/railgun
	name = "гильза"
	desc = "Вроде?"
	caliber = "railgun"
	projectile_type = /obj/projectile/bullet/fallout/railgun

/obj/projectile/bullet/fallout/railgun
	icon_state = "gauss_silenced"
	speed = 2
	damage = 1500
	armour_penetration = 1500
	range = 150
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/bullet/fallout/railgun/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (!QDELETED(target) && (isturf(target) || istype(target, /obj/structure/)))
		if(isobj(target))
			SSexplosions.med_mov_atom += target
		else
			SSexplosions.medturf += target
