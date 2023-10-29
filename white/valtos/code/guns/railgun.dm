/obj/item/gun/ballistic/automatic/fallout/railgun
	name = "Бластер Б-7 \"Козырь\""
	desc = "Высокоточное оружие, которое используется в зоне специальной военной операции. Одного выстрела достаточно, чтобы распилить станцию напополам."
	icon_state = "railgun"
	inhand_icon_state = "railgun"
	mag_type = /obj/item/ammo_box/magazine/fallout/railgun
	fire_sound_volume = 60
	fire_sound = 'white/valtos/sounds/fallout/american180.ogg'
	dry_fire_sound = 'white/valtos/sounds/ebutt.ogg'
	load_sound = 'white/valtos/sounds/ebutt.ogg'
	load_empty_sound = 'white/valtos/sounds/ebutt.ogg'
	rack_sound = 'white/valtos/sounds/ebutt.ogg'
	eject_sound = 'white/valtos/sounds/ebutt.ogg'
	eject_empty_sound = 'white/valtos/sounds/ebutt.ogg'
	bolt_drop_sound = 'white/valtos/sounds/ebutt.ogg'
	empty_alarm_sound = 'white/valtos/sounds/ebutt.ogg'
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 1
	extra_damage = 9
	extra_penetration = 4
	force = 15
	spread = 0
	recoil = 0
	actions_types = null
	var/fatality_mode = FALSE
	legacy_icon_handler = FALSE

/obj/item/gun/ballistic/automatic/fallout/railgun/reset_semicd()
	. = ..()
	playsound(src, 'sound/machines/eject.ogg', 25, TRUE)

/obj/item/gun/ballistic/automatic/fallout/railgun/make_jamming()
	return

/obj/item/gun/ballistic/automatic/fallout/railgun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire_funny, 0.01)
	RemoveElement(/datum/element/jamming) // not funny

/obj/item/gun/ballistic/automatic/fallout/railgun/AltClick(mob/user)
	if(user?.client?.holder)
		fatality_mode = !fatality_mode
		to_chat(user, span_notice("<b>ЭКСТЕРМИНАТУС:</b> [fatality_mode ? "АКТИВЕН" : "ВЫКЛЮЧЕН"]!"))
		if(fatality_mode)
			extra_damage = 1500
			extra_penetration = 1500
			force = 1500
			var/datum/component/automatic_fire_funny/D = GetComponent(/datum/component/automatic_fire_funny)
			D.autofire_shot_delay = 0.01
		else
			extra_damage = 9
			extra_penetration = 4
			force = 15
			var/datum/component/automatic_fire_funny/D = GetComponent(/datum/component/automatic_fire_funny)
			D.autofire_shot_delay = 1

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
	speed = 0.4
	damage = 1
	damage_type = BURN
	range = 25
	projectile_piercing = PASSALL
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/bullet/fallout/railgun/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (damage > 100 && !QDELETED(target) && (isturf(target) || istype(target, /obj/structure/)))
		if(isobj(target))
			SSexplosions.med_mov_atom += target
		else
			SSexplosions.medturf += target
