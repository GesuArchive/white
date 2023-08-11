/obj/item/gun/ballistic/crossbow
	name = "арбалет"
	desc = "Мощный арбалет, который умеет стрелять металлическими стержнями. Очень полезен в целях охоты."
	icon = 'white/valtos/icons/weapons/crossbow.dmi'
	icon_state = "crossbow_body"
	inhand_icon_state = "crossbow_body"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	fire_sound = 'white/valtos/sounds/rodgun_fire.ogg'
	var/charge = 0
	var/max_charge = 3
	var/charging = FALSE
	var/charge_time = 10
	var/draw_sound = 'sound/weapons/draw_bow.ogg'
	var/insert_sound = 'sound/weapons/magin.ogg'
	var/bow_type_overlay = null
	var/rod_type = /obj/item/ammo_casing/rod
	weapon_weight = WEAPON_MEDIUM
	spawnwithmagazine = FALSE
	casing_ejector = FALSE

/obj/item/gun/ballistic/crossbow/attackby(obj/item/A, mob/living/user, params)
	if (!chambered)
		if (charge > 0)
			if (istype(A, /obj/item/stack/rods))
				var/obj/item/stack/rods/R = A
				if (R.use(1))
					chambered = new rod_type
					var/obj/projectile/rod/PR = chambered.loaded_projectile

					if (PR)
						PR.range = PR.range * charge
						PR.damage = PR.damage * charge
						PR.charge = charge
						if(charge == 3)
							PR.AddElement(/datum/element/impaling, 2, 3*MOVE_FORCE_DEFAULT, TRUE)

					playsound(user, insert_sound, 50, 1)

					user.visible_message(span_notice("[user] аккуратно устанавливает [chambered.loaded_projectile] в [src].") , \
                                         span_notice("Аккуратно устанавливаю [chambered.loaded_projectile] в [src]."))
		else
			to_chat(user, span_warning("Стоит натянуть тетиву перед установкой снаряда!"))
	else
		to_chat(user, span_warning("Здесь уже есть [chambered.loaded_projectile] внутри!"))

	update_icon()
	return

/obj/item/gun/ballistic/crossbow/process_chamber(empty_chamber = FALSE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	chambered = null
	charge = 0
	update_icon()
	return

/obj/item/gun/ballistic/crossbow/chamber_round(replace_new_round = FALSE)
	return

/obj/item/gun/ballistic/crossbow/can_shoot()
	if (!chambered)
		return

	if (charge <= 0)
		return

	return (chambered.loaded_projectile ? 1 : 0)

/obj/item/gun/ballistic/crossbow/attack_self(mob/living/user)
	if (!chambered)
		if (charge < 3)
			if (charging)
				return
			charging = TRUE
			playsound(user, draw_sound, 50, 1)

			if (do_after(user, charge_time, target = src, timed_action_flags = IGNORE_USER_LOC_CHANGE) && charging)
				charge = charge + 1
				charging = FALSE
				var/draw = "немножечко"

				if (charge > 2)
					draw = "на максимум"
				else if (charge > 1)
					draw = "дальше"
				user.visible_message(span_notice("[user] натягивает тетиву [draw].") , \
	                                     span_notice("Натягиваю тетиву [draw]."))
			else
				charging = FALSE
		else
			to_chat(user, span_warning("Тетива натянута, милорд!"))
	else
		user.visible_message(span_notice("[user] достаёт [chambered.loaded_projectile] из [src].") , \
							span_notice("Достаю [chambered.loaded_projectile] из [src]."))
		user.put_in_hands(new /obj/item/stack/rods)
		chambered = null
		playsound(user, insert_sound, 50, 1)
	update_icon()
	charging = FALSE
	return

/obj/item/gun/ballistic/crossbow/examine(mob/user)
	. = ..()
	. += "<br>Тетива "
	switch(charge)
		if(0)
			. += " в покое."
		if(2 to INFINITY)
			. += "в полной боевой готовности"
		if (1 to 2)
			. += "натянута на половину"
		if (0 to 1)
			. += "слабо натянута"

	. += "[charge > 2 ? "!" : "."]<br>"

	if (chambered?.loaded_projectile)
		. += "[capitalize(chambered.loaded_projectile)] установлен."

/obj/item/gun/ballistic/crossbow/update_icon()
	..()
	cut_overlays()
	if (charge >= max_charge)
		add_overlay("[bow_type_overlay]charge_[max_charge]")
	else if (charge < 1)
		add_overlay("[bow_type_overlay]charge_0")
	else
		add_overlay("[bow_type_overlay]charge_[charge]")
	if (chambered && charge > 0)
		if (charge >= max_charge)
			add_overlay("[bow_type_overlay]rod_[max_charge]")
		else
			add_overlay("[bow_type_overlay]rod_[charge]")
	return

/obj/item/gun/ballistic/crossbow/improv
	name = "импровизированный арбалет"
	desc = "Арбалет собранный из хлама, вероятнее всего не сможет навредить кому-то."
	icon_state = "crossbow_body_improv"
	inhand_icon_state = "crossbow_body_improv"
	charge_time = 20

/datum/crafting_recipe/crossbow_improv
	name = "Импровизированный арбалет"
	result = /obj/item/gun/ballistic/crossbow/improv
	reqs = list(/obj/item/stack/rods = 3,
		        /obj/item/stack/cable_coil = 10,
		        /obj/item/weaponcrafting/stock = 1)
	tool_paths = list(/obj/item/weldingtool,
		         /obj/item/screwdriver)
	time = 150
	category = CAT_WEAPON_RANGED

/obj/projectile/rod
	name = "металлический стержень"
	icon = 'white/valtos/icons/weapons/crossbow.dmi'
	icon_state = "rod_proj"
	suppressed = TRUE
	damage = 6 // multiply by how drawn the bow string is
	range = 12 // also multiply by the bow string
	damage_type = BRUTE
	flag = BULLET
	hitsound = null // We use our own for different circumstances
	var/impale_sound = 'white/valtos/sounds/rodgun_pierce.ogg'
	var/hitsound_override = 'sound/weapons/pierce.ogg'
	var/charge = 0 // How much power is in the bolt, transferred from the crossbow

/obj/projectile/rod/on_range()
	// we didn't hit anything, place a rod here
	new /obj/item/stack/rods(get_turf(src))
	..()

/obj/projectile/rod/proc/Impale(mob/living/carbon/human/H)
	if (H)
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		var/obj/item/bent_rod/R = new(H.loc, 1, FALSE)

		if (istype(BP))
			R.add_blood_DNA(GET_ATOM_BLOOD_DNA(H))
			R.embedding = list("pain_mult" = 4, "embed_chance" = 90, "fall_chance" = 10)
			R.updateEmbedding()
			R.tryEmbed(BP, TRUE, TRUE)
			H.update_damage_overlays()
			visible_message(span_warning("<b>[capitalize(R.name)]</b> проникает в [ru_parse_zone(BP)] <b>[H]</b>!") ,
							span_userdanger("Ох! <b>[capitalize(R.name)]</b> проникает в <b>[ru_parse_zone(BP)]</b>!"))
			playsound(H, impale_sound, 50, 1)
			H.emote("agony")

/obj/projectile/rod/on_hit(atom/target, blocked = FALSE)
	..()
	var/volume = vol_by_damage()
	if (istype(target, /mob))
		playsound(target, impale_sound, volume, 1, -1)
		if (ishuman(target) && charge > 2) // Only fully charged shots can impale
			var/mob/living/carbon/human/H = target
			Impale(H)
		else
			new /obj/item/bent_rod(get_turf(src))
	else
		playsound(target, hitsound_override, volume, 1, -1)
		new /obj/item/bent_rod(get_turf(src))
	qdel(src)

/obj/item/ammo_casing/rod
	projectile_type = /obj/projectile/rod

/obj/item/bent_rod
	name = "погнутый металлический стержень"
	desc = "Надо-бы выгнуть."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "rods-1"
	custom_materials = list(/datum/material/iron = 1000)
	embedding = list()
	force = 9
	throwforce = 10
	throw_speed = 3
	throw_range = 7

/obj/item/bent_rod/attack_self(mob/user)
	. = ..()
	new /obj/item/stack/rods(get_turf(user))
	qdel(src)

/obj/item/bent_rod/handle_fall(mob/faller)
	. = ..()
	disableEmbedding()

/obj/item/gun/ballistic/crossbow/energy
	name = "энергетический арбалет"
	desc = "Совершенство технологий и больной ум позволили создать это."
	icon_state = "crossbow_body_energy"
	inhand_icon_state = "crossbow_body_improv"
	insert_sound = 'white/valtos/sounds/rodgun_reload.ogg'
	bow_type_overlay = "e_"
	charge_time = 5
	rod_type = /obj/item/ammo_casing/rod/energy

/obj/item/gun/ballistic/crossbow/energy/attack_self(mob/living/user)
	charge_time = initial(charge_time)
	switch(charge)
		if(0)
			charge_time = 10
		if(1)
			charge_time = 14
		if(2)
			charge_time = 18
		if(3)
			charge_time = 22
	. = ..()


/obj/item/ammo_casing/rod/energy
	projectile_type = /obj/projectile/rod/energy

/obj/projectile/rod/energy
	name = "раскалённый металлический стержень"
	icon = 'white/valtos/icons/weapons/crossbow.dmi'
	icon_state = "e_rod_proj"
	damage = 10
	range = 12
