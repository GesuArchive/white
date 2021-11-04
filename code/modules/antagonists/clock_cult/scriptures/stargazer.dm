//==================================//
// !      Stargazer     ! //
//==================================//
/datum/clockcult/scripture/create_structure/stargazer
	name = "Звездочет"
	desc = "Позволяет наложить чары на ваше оружие и доспехи, однако наложение чар может иметь опасные побочные эффекты."
	tip = "Сделайте свое снаряжение более мощным, очаровав его звездочётом."
	button_icon_state = "Stargazer"
	power_cost = 300
	invokation_time = 80
	invokation_text = list("Свет Дви'гателя усилит мое вооружение!")
	summoned_structure = /obj/structure/destructible/clockwork/gear_base/stargazer
	cogs_required = 2
	category = SPELLTYPE_STRUCTURES

//Stargazer light

/obj/effect/stargazer_light
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "stargazer_closed"
	pixel_y = 10
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 160
	var/active_timer

/obj/effect/stargazer_light/ex_act()
	return

/obj/effect/stargazer_light/Destroy(force)
	cancel_timer()
	. = ..()

/obj/effect/stargazer_light/proc/finish_opening()
	icon_state = "stargazer_light"
	active_timer = null

/obj/effect/stargazer_light/proc/finish_closing()
	icon_state = "stargazer_closed"
	active_timer = null

/obj/effect/stargazer_light/proc/open()
	icon_state = "stargazer_opening"
	cancel_timer()
	active_timer = addtimer(CALLBACK(src, .proc/finish_opening), 2, TIMER_STOPPABLE | TIMER_UNIQUE)

/obj/effect/stargazer_light/proc/close()
	icon_state = "stargazer_closing"
	cancel_timer()
	active_timer = addtimer(CALLBACK(src, .proc/finish_closing), 2, TIMER_STOPPABLE | TIMER_UNIQUE)

/obj/effect/stargazer_light/proc/cancel_timer()
	if(active_timer)
		deltimer(active_timer)

#define STARGAZER_COOLDOWN 1800

//Stargazer structure
/obj/structure/destructible/clockwork/gear_base/stargazer
	name = "звездочёт"
	desc = "Небольшой пьедестал, светящийся божественной энергией."
	clockwork_desc = "Небольшой пьедестал, светящийся божественной энергией. Используется для придания предметам особых способностей."
	default_icon_state = "stargazer"
	anchored = TRUE
	break_message = span_warning("The stargazer collapses.")
	var/cooldowntime = 0
	var/mobs_in_range = FALSE
	var/fading = FALSE
	var/obj/effect/stargazer_light/sg_light

/obj/structure/destructible/clockwork/gear_base/stargazer/Initialize()
	. = ..()
	sg_light = new(get_turf(src))
	START_PROCESSING(SSobj, src)

/obj/structure/destructible/clockwork/gear_base/stargazer/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(!QDELETED(sg_light))
		qdel(sg_light)
	. = ..()

/obj/structure/destructible/clockwork/gear_base/stargazer/process()
	if(QDELETED(sg_light))
		return
	var/mob_nearby = FALSE
	for(var/mob/living/M in viewers(2, get_turf(src)))
		if(is_servant_of_ratvar(M))
			mob_nearby = TRUE
			break
	if(mob_nearby && !mobs_in_range)
		sg_light.open()
		mobs_in_range = TRUE
	else if(!mob_nearby && mobs_in_range)
		mobs_in_range = FALSE
		sg_light.close()

/obj/structure/destructible/clockwork/gear_base/stargazer/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent != INTENT_HELP)
		. = ..()
		return
	if(!anchored)
		to_chat(user, span_brass("Нужно прикрутить [src] к полу."))
		return
	if(cooldowntime > world.time)
		to_chat(user, span_brass("[src] всё ещё нагревается, всё будет готово через [DisplayTimeText(cooldowntime - world.time)]."))
		return
	if(HAS_TRAIT(I, TRAIT_STARGAZED))
		to_chat(user, span_brass("[I] уже улучшена!"))
		return
	to_chat(user, span_brass("Начинаю устанавливать [I] на [src]."))
	if(do_after(user, 60, target=I))
		if(cooldowntime > world.time)
			to_chat(user, span_brass("[src] всё ещё нагревается, всё будет готово через [DisplayTimeText(cooldowntime - world.time)]."))
			return
		if(HAS_TRAIT(I, TRAIT_STARGAZED))
			to_chat(user, span_brass("[I] уже улучшена!"))
			return
		if(istype(I, /obj/item))
			upgrade_weapon(I, user)
			cooldowntime = world.time + STARGAZER_COOLDOWN
			return
		to_chat(user, span_brass("Не могу улучшить [I]."))

/obj/structure/destructible/clockwork/gear_base/stargazer/proc/upgrade_weapon(obj/item/I, mob/living/user)
	ADD_TRAIT(I, TRAIT_STARGAZED, STARGAZER_TRAIT)
	switch(rand(1, 10))
		if(1)
			to_chat(user, span_neovgre("[I] прилипает к моей руке."))
			ADD_TRAIT(I, TRAIT_NODROP, STARGAZER_TRAIT)
			return
		if(2)
			to_chat(user, span_neovgre("[I] теперь может пробить что угодно."))
			I.force += 6
			return
		if(3)
			I.w_class = WEIGHT_CLASS_TINY
			to_chat(user, span_neovgre("[I] уменьшается!"))
			return
		if(4)
			I.light_power = 3
			I.light_range = 2
			I.light_color = LIGHT_COLOR_CLOCKWORK
			to_chat(user, span_neovgre("[I] начинает светиться!"))
			return
		if(5)
			I.damtype = BURN
			I.force += 2
			I.light_power = 1.5
			I.light_range = 2
			I.light_color = LIGHT_COLOR_FIRE
			to_chat(user, span_neovgre("[I] начинает гореть ярким пламенем!"))
			return
		if(6)
			I.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
			to_chat(user, span_neovgre("[I] теперь невозможно сломать!"))
			return
		if(7)
			to_chat(user, span_neovgre("Ощущаю как [I] хочет поговорить со мной."))
			var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хочешь быть духом [user.real_name] в [I]?", ROLE_PAI, null, 100, POLL_IGNORE_POSSESSED_BLADE)
			if(LAZYLEN(candidates))
				var/mob/dead/observer/C = pick(candidates)
				var/mob/living/simple_animal/shade/S = new(src)
				S.ckey = C.ckey
				S.fully_replace_character_name(null, "Дух [name]")
				S.status_flags |= GODMODE
				S.copy_languages(user, LANGUAGE_MASTER)	//Make sure the sword can understand and communicate with the user.
				S.update_atom_languages()
				S.grant_all_languages(FALSE, FALSE, TRUE)	//Grants omnitongue
				var/input = sanitize_name(stripped_input(S,"Как там тебя зовут?", ,"", MAX_NAME_LEN))

				if(src && input)
					name = input
					S.fully_replace_character_name(null, "Дух [input]")
			else
				to_chat(user, span_neovgre("Ох, [I] прекращает со мной говорить..."))
			return
		if(8)
			to_chat(user, span_neovgre("[I] затупляется."))
			I.force = max(I.force - 4, 0)
			return
		if(9)
			to_chat(user, span_neovgre("Священные писания оборачиваются вокруг [I], теперь ей не страшна магия!"))
			I.AddComponent(/datum/component/anti_magic, TRUE, TRUE)
			return
		if(10)
			to_chat(user, span_neovgre("[I] трансфорируется, обретая магические свойства шунгита, теперь эта штука защитит меня от всех бед!"))
			I.AddElement(/datum/element/empprotection)
			I.AddComponent(/datum/component/anti_magic, TRUE, TRUE)
			I.color = COLOR_ALMOST_BLACK
			return
