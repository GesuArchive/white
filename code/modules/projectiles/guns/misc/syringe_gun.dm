/obj/item/gun/syringe
	name = "шприцемёт"
	desc = "Пружинное оружие сконструированное для заряда шприцов, используется для выведения неуправляемых пациентов на расстоянии."
	icon = 'icons/obj/guns/syringegun.dmi'
	icon_state = "medicalsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_icon_state = "medicalsyringegun"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throw_speed = 3
	throw_range = 7
	force = 6
	base_pixel_x = -4
	pixel_x = -4
	custom_materials = list(/datum/material/iron=2000)
	clumsy_check = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	var/load_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	var/list/syringes = list()
	var/max_syringes = 1 ///The number of syringes it can store.
	var/has_syringe_overlay = TRUE ///If it has an overlay for inserted syringes. If true, the overlay is determined by the number of syringes inserted into it.
	var/semi_automatic = FALSE
	var/pneumo_load = TRUE

/obj/item/gun/syringe/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/syringegun(src)
	recharge_newshot()

/obj/item/gun/syringe/handle_atom_del(atom/A)
	. = ..()
	if(A in syringes)
		syringes.Remove(A)

/obj/item/gun/syringe/recharge_newshot()
	if(!syringes.len)
		return
	chambered.newshot()

/obj/item/gun/syringe/can_shoot()
	return syringes.len

/obj/item/gun/syringe/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	if(chambered && !chambered.loaded_projectile) //we just fired
		recharge_newshot()
	update_icon()

/obj/item/gun/syringe/examine(mob/user)
	. = ..()
	. += "<hr>Магазин [syringes.len]/[max_syringes] шприцев."

/obj/item/gun/syringe/attack_self(mob/living/user)
	if(semi_automatic)
		if(!pneumo_load)
			pneumo_load = TRUE
			icon_state = "adv_syringegun"
			playsound(user, 'white/Feline/sounds/nasos.ogg', 80, TRUE)
			update_icon()
			return TRUE
	if(!syringes.len)
		to_chat(user, span_warning("[capitalize(src.name)] пуст!"))
		return FALSE

	var/obj/item/reagent_containers/syringe/S = syringes[syringes.len]

	if(!S)
		return FALSE
	user.put_in_hands(S)

	syringes.Remove(S)
	to_chat(user, span_notice("Извлекаю [S] из <b>[src.name]</b>."))
	update_icon()

	return TRUE

/obj/item/gun/syringe/attackby(obj/item/A, mob/user, params, show_msg = TRUE)
	if(istype(A, /obj/item/weaponcrafting/gunkit/adv_syringegun))
		if(!semi_automatic)
			to_chat(user, span_notice("Начинаю модернизацию шприцемета."))
			if(!do_after(user, 30, user))
				to_chat(user, span_warning("Не получается!"))
				return
			. = ..()
			playsound(user,'white/Feline/sounds/suppressor_toggle.ogg', 80, TRUE)
			var/obj/item/gun/syringe/adv_syringegun/I = new()
			user.put_in_hands(I)
			qdel(A)
			qdel(src)
		else
			to_chat(user, span_notice("Этот шприцемет уже модернизирован!"))
			return

	if(istype(A, /obj/item/reagent_containers/syringe/bluespace))
		to_chat(user, span_notice("[A] слишком большой и не помещается в [src]."))
		return TRUE
	if(istype(A, /obj/item/reagent_containers/syringe))
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(A, src))
				return FALSE
			to_chat(user, span_notice("Заряжаю [A] в <b>[src.name]</b>."))
			syringes += A
			recharge_newshot()
			update_icon()
			playsound(loc, load_sound, 40)
			return TRUE
		else
			to_chat(user, span_warning("В [capitalize(src.name)] не поместятся еще шприцы!"))
	return FALSE

/obj/item/gun/syringe/update_overlays()
	. = ..()
	if(!has_syringe_overlay)
		return
	var/syringe_count = syringes.len
	. += "[initial(icon_state)]_[syringe_count ? clamp(syringe_count, 1, initial(max_syringes)) : "empty"]"

/obj/item/gun/syringe/adv_syringegun
	name = "продвинутый шприцемет"
	desc = "Модифицированная версия шприцемета с использованием пневматического баллона и магазина, способного вместить до трех шприцов."
	icon_state = "adv_syringegun"
	max_syringes = 3
	semi_automatic = TRUE

/obj/item/gun/syringe/adv_syringegun/can_shoot()
	if(pneumo_load  && syringes.len)
		pneumo_load = FALSE
		icon_state = "adv_syringegun_np"
		return TRUE
	else
		if(!pneumo_load)
			to_chat(usr, span_notice("Пневмомеханизм не взведен."))
		if(syringes.len == 0)
			to_chat(usr, span_notice("Нет шприцев."))
		return FALSE

/obj/item/gun/syringe/rapidsyringe
	name = "многозарядный шприцемет"
	desc = "Модификация шприцевого пистолета с использованием вращающегося барабана, способного вместить до шести шприцов."
	icon_state = "rapidsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "syringegun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	max_syringes = 6
	force = 4

/obj/item/gun/syringe/syndicate
	name = "дротикомет"
	desc = "Небольшой пружинный пистолет, по принципу работы идентичный шприцевому пистолету."
	icon_state = "dartsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "gun" //Smaller inhand
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 2 //Also very weak because it's smaller
	suppressed = TRUE //Softer fire sound
	can_unsuppress = FALSE //Permanently silenced
	syringes = list(new /obj/item/reagent_containers/syringe())

/obj/item/gun/syringe/dna
	name = "модифицированный шприцемёт"
	desc = "Шприцевой пистолет модифицированный для использования инжекторов ДНК, вместо обычных шприцов."
	icon_state = "dnasyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "syringegun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 4

/obj/item/gun/syringe/dna/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/dnainjector(src)
	update_appearance()
	playsound(loc, load_sound, 40)

/obj/item/gun/syringe/dna/attackby(obj/item/A, mob/user, params, show_msg = TRUE)
	if(istype(A, /obj/item/dnainjector))
		var/obj/item/dnainjector/D = A
		if(D.used)
			to_chat(user, span_warning("Данный инжектор израсходован!"))
			return
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(D, src))
				return FALSE
			to_chat(user, span_notice("Зарядил [D] в <b>[src.name]</b>."))
			syringes += D
			recharge_newshot()
			return TRUE
		else
			to_chat(user, span_warning("[capitalize(src.name)] не вместит больше шприцов!"))
	return FALSE

/obj/item/gun/syringe/blowgun
	name = "blowgun"
	desc = "Стреляет шприцами на небольшой дистанции."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "blowgun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "blowgun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	has_syringe_overlay = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 4

/obj/item/gun/syringe/blowgun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	visible_message(span_danger("[user] прицеливается своим blowgun!"))
	if(do_after(user, 25, target = src))
		user.adjustStaminaLoss(20)
		user.adjustOxyLoss(20)
		return ..()
