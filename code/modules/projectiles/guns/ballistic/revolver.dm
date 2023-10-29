/obj/item/gun/ballistic/revolver
	name = "револьвер .357 калибра"
	desc = "Подозрительный револьвер, использующий .357 патроны." //usually used by syndicates
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 90
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	var/spin_delay = 10
	var/recent_spin = 0
	var/last_fire = 0

/obj/item/gun/ballistic/revolver/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	..()
	last_fire = world.time

/obj/item/gun/ballistic/revolver/chamber_round(keep_bullet, spin_cylinder = TRUE, replace_new_round)
	if(!magazine) //if it mag was qdel'd somehow.
		CRASH("revolver tried to chamber a round without a magazine!")
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round()

/obj/item/gun/ballistic/revolver/AltClick(mob/user)
	..()
	spin()

/obj/item/gun/ballistic/revolver/fire_sounds()
	var/frequency_to_use = sin((90/magazine?.max_ammo) * get_ammo(TRUE, FALSE)) // fucking REVOLVERS
	var/click_frequency_to_use = 1 - frequency_to_use * 0.75
	var/play_click = sqrt(magazine?.max_ammo) > get_ammo(TRUE, FALSE)
	if(suppressed)
		playsound(src, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0, frequency = click_frequency_to_use)
	else
		playsound(src, fire_sound, fire_sound_volume, vary_fire_sound)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', fire_sound_volume, vary_fire_sound, frequency = click_frequency_to_use)

/obj/item/gun/ballistic/revolver/verb/spin()
	set name = "барабан"
	set category = "Объект"
	set desc = "Щелкните кнопкой мыши, чтобы покрутить барабан у револьвера."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if (recent_spin > world.time)
		return
	recent_spin = world.time + spin_delay

	if(do_spin())
		playsound(usr, "revolver_spin", 30, FALSE)
		usr.visible_message(span_notice("<b>[usr]</b> крутит барабан <b>[src.name]</b>.") , span_notice("Кручу барабан <b>[src.name]</b>."))
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(spin_cylinder = FALSE)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "<hr>[live_ammo ? "Осталось [live_ammo]" : "Не осталось"] нестреляных патронов."
	if (current_skin)
		. += "\nЕго можно покрутить используя <b>Alt+клик</b>"

/obj/item/gun/ballistic/revolver/ignition_effect(atom/A, mob/user)
	if(last_fire && last_fire + 15 SECONDS > world.time)
		. = span_notice("[user] притрагивается раскалённым концом [src.name] к [A.name].")

/obj/item/gun/ballistic/revolver/detective
	name = "специальный кольт детектива"
	desc = "Классическое, пусть и немного устаревшее, но верное правоохранительное оружие. Использует .38 спецпатроны."
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	icon_state = "detective"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	obj_flags = UNIQUE_RENAME
	unique_reskin = list(
		"Default" = "detective",
		"Fitz Special" = "detective_fitz",
		"Police Positive Special" = "detective_police",
		"Blued Steel" = "detective_blued",
		"Stainless Steel" = "detective_stainless",
		"Gold Trim" = "detective_gold",
		"Leopard Spots" = "detective_leopard",
		"The Peacemaker" = "detective_peacemaker",
		"Black Panther" = "detective_panther"
	)

	/// Used to avoid some redundancy on a revolver loaded with 357 regarding misfiring while being wrenched.
	var/skip_357_missfire_check = FALSE

/obj/item/gun/ballistic/revolver/detective/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(magazine && magazine.caliber != initial(magazine.caliber) && chambered.loaded_projectile && !skip_357_missfire_check)
		if(prob(70 - (magazine.ammo_count() * 10)))	//minimum probability of 10, maximum of 60
			to_chat(user, span_userdanger("<b>[capitalize(src)]</b> приставил к лицу!"))
			if(user.get_item_for_held_index(1) == src)
				user.dropItemToGround(src)
				return ..(user, user, FALSE, null, BODY_ZONE_L_ARM)
			else if(user.get_item_for_held_index(2) == src)
				user.dropItemToGround(src)
				return ..(user, user, FALSE, null, BODY_ZONE_R_ARM)
	return ..()

/obj/item/gun/ballistic/revolver/detective/wrench_act(mob/living/user, obj/item/I)
	if(!user.is_holding(src))
		to_chat(user, span_notice("You need to hold [src] to modify its barrel."))
		return TRUE
	to_chat(user, span_notice("You begin to loosen the barrel of [src]..."))
	I.play_tool_sound(src)
	if(!I.use_tool(src, user, 3 SECONDS))
		return TRUE
	if(magazine.ammo_count()) //If it has any ammo inside....
		user.visible_message(span_danger("[capitalize(src.name)] hammer drops while you're handling it!")) //...you learn an important lesson about firearms safety.
		var/drop_the_gun_it_actually_fired = chambered.loaded_projectile ? TRUE : FALSE //Is a live round chambered?
		skip_357_missfire_check = TRUE //We set this true, then back to false after process_fire, to reduce redundacy of a round "misfiring" when it's already misfiring from wrench_act
		process_fire(user, user, FALSE)
		skip_357_missfire_check = FALSE
		if(drop_the_gun_it_actually_fired) //We do it like this instead of directly checking chambered.loaded_projectile here because process_fire will cycle the chamber.
			user.dropItemToGround(src)
		return TRUE
	if(magazine.caliber == "38")
		magazine.caliber = "357"
		fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
		desc = "Классическое, если не устаревшее, правоохранительное оружие. \nБарабан модифицирован под .357."
		to_chat(user, span_notice("Ослабляю барабан [src.name]. Теперь он использует патроны калибра .357."))
	else
		magazine.caliber = "38"
		fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
		desc = initial(desc)
		to_chat(user, span_notice("Затягиваю барабан [src.name]. Теперь он использует патроны калибра .38."))


/obj/item/gun/ballistic/revolver/mateba
	name = "Unica 6 автоматический револьвер"
	desc = "Мощный револьвер выполненный в ретро стиле, обычно используемый офицерами новой России. Использует .357 патроны."
	icon_state = "mateba"

/obj/item/gun/ballistic/revolver/golden
	name = "золотой револьвер"
	desc = "Раритетное оружие, использующее патроны .357."
	icon_state = "goldrevolver"
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	recoil = 8
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/nagant
	name = "наган"
	desc = "Старая модель револьвера, использововшая в России. Можно нацепить глушитель. Использует патроны калибра 7.62x38mmR."
	icon_state = "nagant"
	can_suppress = TRUE

	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev762


// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/gun/ballistic/revolver/russian
	name = "русский револьвер"
	desc = "Сделано для пьяных игр тупыми пиндосами. Использует .357 патроны, можно начинать крутить барабан и ставить в рот."
	icon_state = "russianrevolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = FALSE

/obj/item/gun/ballistic/revolver/russian/do_spin()
	. = ..()
	if(.)
		spun = TRUE

/obj/item/gun/ballistic/revolver/russian/attackby(obj/item/A, mob/user, params)
	..()
	if(get_ammo() > 0)
		spin()
	update_icon()
	A.update_icon()
	return

/obj/item/gun/ballistic/revolver/russian/attack_self(mob/user)
	if(!spun)
		spin()
		spun = TRUE
		return
	..()

/obj/item/gun/ballistic/revolver/russian/afterattack(atom/target, mob/living/user, flag, params)
	. = ..(null, user, flag, params)

	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.a_intent == INTENT_HARM) // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		if(ismob(target))
			to_chat(user, span_warning("Хитрый механизм препятствует стрелять в других. Может в себя?"))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			to_chat(user, span_warning("Стоит покрутить барабан <b>[src.name]</b> сначала!"))
			return

		spun = FALSE

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire_casing(user, user))
				playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
				var/zone = check_zone(user.zone_selected)
				var/obj/item/bodypart/affecting = H.get_bodypart(zone)
				if(zone == BODY_ZONE_HEAD || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH)
					shoot_self(user, affecting)
				else
					user.visible_message(span_danger("<b>[user.name]</b> трусливо стреляет <b>[src.name]</b> в [user.ru_ego()] [affecting.name]!") , span_userdanger("Трусливо стреляю из <b>[src.name]</b> в свой [affecting.name]!") , span_hear("Слышу выстрел!"))
				chambered = null
				return

		user.balloon_alert_to_viewers("*щёлк*")
		playsound(src, dry_fire_sound, 30, TRUE)

/obj/item/gun/ballistic/revolver/russian/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	add_fingerprint(user)
	playsound(src, dry_fire_sound, 30, TRUE)
	user.visible_message(span_danger("<b>[user.name]</b> пытается выстрелить из <b>[src.name]</b>, но выглядит как еблан.") , span_danger("Механизм <b>[src.name]</b> не позволяет выстрелить!"))

/obj/item/gun/ballistic/revolver/russian/proc/shoot_self(mob/living/carbon/human/user, affecting = BODY_ZONE_HEAD)
	user.apply_damage(300, BRUTE, affecting)
	user.visible_message(span_danger("<b>[user.name]</b> стреляет из <b>[src.name]</b> себе в голову!") , span_userdanger("Стреляю из <b>[src.name]</b> себе в голову!") , span_hear("Слышу выстрел!"))

/obj/item/gun/ballistic/revolver/russian/soul
	name = "проклятый русский револьвер"
	desc = "Чтобы играть с этим револьвером, нужно отыграть свою душу."

/obj/item/gun/ballistic/revolver/russian/soul/shoot_self(mob/living/user)
	..()
	var/obj/item/soulstone/anybody/revolver/stone = new /obj/item/soulstone/anybody/revolver(get_turf(src))
	if(!stone.capture_soul(user, forced = TRUE)) //Something went wrong
		qdel(stone)
		return
	user.visible_message(span_danger("Душа <b>[user.name]</b> теперь принадлежит <b>[src.name]</b>!") , span_userdanger("Азартная игра проиграна вместе с душой!"))

/obj/item/gun/ballistic/revolver/reverse //Fires directly at its user... unless the user is a clown, of course.
	clumsy_check = FALSE

/obj/item/gun/ballistic/revolver/reverse/can_trigger_gun(mob/living/user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) || (user.mind && user.mind.assigned_role == JOB_CLOWN))
		return ..()
	if(process_fire(user, user, FALSE, null, BODY_ZONE_HEAD))
		user.visible_message(span_warning("<b>[user]</b> стреляет себе в лицо!") , span_userdanger("Стреляю себе в лицо"))
		user.emote("agony")
		user.drop_all_held_items()
		user.Paralyze(80)
