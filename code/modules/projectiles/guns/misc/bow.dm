
/obj/item/gun/ballistic/bow
	name = "длинный лук"
	desc = "Не смотря на хорошее качество вы, наверняка, найдете что-то более подходящее для современных реалий."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "bow"
	inhand_icon_state = "bow"
	load_sound = null
	fire_sound = null
	mag_type = /obj/item/ammo_box/magazine/internal/bow
	force = 15
	attack_verb_continuous = list("whipped", "cracked")
	attack_verb_simple = list("whip", "crack")
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	var/drawn = FALSE

/obj/item/gun/ballistic/bow/update_icon()
	. = ..()
	if(!chambered)
		icon_state = "bow"
	else
		icon_state = "bow_[drawn]"

/obj/item/gun/ballistic/bow/proc/drop_arrow()
	drawn = FALSE
	if(!chambered)
		chambered = magazine.get_round(keep = FALSE)
		return
	if(!chambered)
		return
	chambered.forceMove(drop_location())
	update_icon()

/obj/item/gun/ballistic/bow/chamber_round(keep_bullet = FALSE, spin_cylinder, replace_new_round)
	if(chambered || !magazine)
		return
	if(magazine.ammo_count())
		chambered = magazine.get_round(TRUE)
		chambered.forceMove(src)

/obj/item/gun/ballistic/bow/attack_self(mob/user)
	if(chambered)
		to_chat(user, span_notice("[drawn ? "ослабляю натяжение" : "натягиваю тетиву"] [src]."))
		drawn = !drawn
	update_icon()

/obj/item/gun/ballistic/bow/afterattack(atom/target, mob/living/user, flag, params, passthrough = FALSE)
	if(!chambered)
		return
	if(!drawn)
		to_chat(user, "<span clasas='warning'>Стрела падает на землю ввиду не натянутой тетивы.</span>")
		drop_arrow()
		update_icon()
		return
	drawn = FALSE
	. = ..() //fires, removing the arrow
	update_icon()

/obj/item/gun/ballistic/bow/shoot_with_empty_chamber(mob/living/user)
	return //so clicking sounds please

/obj/item/ammo_box/magazine/internal/bow
	name = "тетива"
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	max_ammo = 1
	start_empty = TRUE
	caliber = "arrow"

/obj/item/ammo_casing/caseless/arrow
	name = "стрела"
	desc = "Пыряющий Пырятель!"
	icon_state = "arrow"
	flags_1 = NONE
	throwforce = 1
	projectile_type = /obj/projectile/bullet/reusable/arrow
	firing_effect_type = null
	caliber = "arrow"
	heavy_metal = FALSE

/obj/item/ammo_casing/caseless/arrow/despawning/dropped()
	. = ..()
	addtimer(CALLBACK(src, .proc/floor_vanish), 5 SECONDS)

/obj/item/ammo_casing/caseless/arrow/despawning/proc/floor_vanish()
	if(isturf(loc))
		qdel(src)

/obj/projectile/bullet/reusable/arrow
	name = "стрела"
	desc = "Ай! Вытащи её из меня!"
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	damage = 50
	speed = 1
	range = 25



/obj/item/storage/bag/quiver
	name = "колчан"
	desc = "Вместилище для ваших стрел. Полезен, ведь не смотря на то что стрелы можно носить в карманах это не особо приятно."
	icon_state = "quiver"
	inhand_icon_state = "quiver"
	worn_icon_state = "harpoon_quiver"
	var/arrow_path = /obj/item/ammo_casing/caseless/arrow

/obj/item/storage/bag/quiver/Initialize(mapload)
	. = ..()
	var/datum/component/storage/storage = GetComponent(/datum/component/storage)
	storage.max_w_class = WEIGHT_CLASS_TINY
	storage.max_items = 40
	storage.max_combined_w_class = 100
	storage.set_holdable(list(
		/obj/item/ammo_casing/caseless/arrow
		))

/obj/item/storage/bag/quiver/PopulateContents()
	. = ..()
	for(var/i in 1 to 10)
		new arrow_path(src)

/obj/item/storage/bag/quiver/despawning
	arrow_path = /obj/item/ammo_casing/caseless/arrow/despawning
