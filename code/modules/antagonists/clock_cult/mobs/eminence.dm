/mob/living/simple_animal/eminence
	name = "Преосвященство"
	desc = "Светящийся шарик."
	icon = 'icons/effects/clockwork_effects.dmi'
	icon_state = "eminence"
	mob_biotypes = list(MOB_SPIRIT)
	incorporeal_move = INCORPOREAL_MOVE_EMINENCE
	invisibility = INVISIBILITY_OBSERVER
	health = INFINITY
	maxHealth = INFINITY
	layer = GHOST_LAYER
	healable = FALSE
	sight = SEE_SELF
	throwforce = 0

	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	unsuitable_atmos_damage = 0
	damage_coeff = list(BRUTE = 0, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	harm_intent_damage = 0
	status_flags = 0
	wander = FALSE
	density = FALSE
	movement_type = FLYING
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_TINY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	speed = 1
	unique_name = FALSE
	hud_possible = list(ANTAG_HUD)
	hud_type = /datum/hud/revenant

	var/mob/living/selected_mob = null

	var/obj/effect/proc_holder/spell/targeted/eminence/reebe/spell_reebe
	var/obj/effect/proc_holder/spell/targeted/eminence/station/spell_station
	var/obj/effect/proc_holder/spell/targeted/eminence/mass_recall/mass_recall
	var/obj/effect/proc_holder/spell/targeted/eminence/reagent_purge/reagent_purge
	var/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond/linked_abscond

/mob/living/simple_animal/eminence/ClickOn(atom/A, params)
	. = ..()
	if(!.)
		A.eminence_act(src)

/mob/living/simple_animal/eminence/UnarmedAttack(atom/A)
	return FALSE

/mob/living/simple_animal/eminence/start_pulling(atom/movable/AM, state, force = move_force, supress_message = FALSE)
	return FALSE

/mob/living/simple_animal/eminence/Initialize()
	. = ..()
	GLOB.clockcult_eminence = src
	spell_reebe = new
	AddSpell(spell_reebe)
	spell_station = new
	AddSpell(spell_station)
	mass_recall = new
	AddSpell(mass_recall)
	reagent_purge = new
	AddSpell(reagent_purge)
	linked_abscond = new
	AddSpell(linked_abscond)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/mob/living/simple_animal/eminence/Login()
	. = ..()
	var/datum/antagonist/servant_of_ratvar/S = add_servant_of_ratvar(src, silent=TRUE)
	S.prefix = CLOCKCULT_PREFIX_EMINENCE
	to_chat(src, span_large_brass("Я Преосвященство!"))
	to_chat(src, span_brass("Кликаем на разные штуки и они начинают работать!"))
	to_chat(src, span_brass("Большая часть заклинаний требует цель. Клик для выбора цели!"))

/mob/living/simple_animal/eminence/say_verb(message as text)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Не могу говорить."))
		return
	if(message)
		hierophant_message(message, src, span="<span class='large_brass'>", say=FALSE)

/mob/living/simple_animal/eminence/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	return FALSE

/mob/living/simple_animal/eminence/Move(atom/newloc, direct)
	if(istype(get_area(newloc), /area/service/chapel))
		to_chat(usr, span_warning("Не могу покинуть святые земли!"))
		return
	. = ..()

/mob/living/simple_animal/eminence/bullet_act(obj/projectile/Proj)
	return BULLET_ACT_FORCE_PIERCE

//Eminence abilities

/obj/effect/proc_holder/spell/targeted/eminence
	invocation = "none"
	invocation_type = "none"
	action_icon = 'icons/mob/actions/actions_clockcult.dmi'
	action_icon_state = "ratvarian_spear"
	action_background_icon_state = "bg_clock"
	clothes_req = FALSE
	charge_max = 0
	cooldown_min = 0
	range = -1
	include_user = TRUE

//=====Warp to Reebe=====
/obj/effect/proc_holder/spell/targeted/eminence/reebe
	name = "Вернуться на Риби"
	desc = "Телепортирует меня на Риби."
	action_icon_state = "Abscond"

/obj/effect/proc_holder/spell/targeted/eminence/reebe/cast(mob/living/user)
	var/obj/structure/destructible/clockwork/massive/celestial_gateway/G = GLOB.celestial_gateway
	if(G)
		user.forceMove(get_turf(G))
		SEND_SOUND(user, sound('sound/magic/magic_missile.ogg'))
		flash_color(user, flash_color = "#AF0AAF", flash_time = 25)
	else
		to_chat(user, span_warning("Ой-ой!"))

//=====Warp to station=====
/obj/effect/proc_holder/spell/targeted/eminence/station
	name = "Перейти к станции"
	desc = "Телепортировать себя к станции."
	action_icon_state = "warp_down"

/obj/effect/proc_holder/spell/targeted/eminence/station/cast(mob/living/user)
	if(!is_station_level(user.z))
		user.forceMove(get_turf(pick(GLOB.generic_event_spawns)))
		SEND_SOUND(user, sound('sound/magic/magic_missile.ogg'))
		flash_color(user, flash_color = "#AF0AAF", flash_time = 25)
	else
		to_chat(user, span_warning("Да я уже на станции!"))

//=====Mass Recall=====
/obj/effect/proc_holder/spell/targeted/eminence/mass_recall
	name = "Инициировать массовый призыв"
	desc = "Инициирует массовый призыв, возвращая всех к ковчегу."
	action_icon_state = "Spatial Gateway"

/obj/effect/proc_holder/spell/targeted/eminence/mass_recall/cast(list/targets, mob/living/user)
	var/obj/structure/destructible/clockwork/massive/celestial_gateway/C = GLOB.celestial_gateway
	if(!C)
		return
	C.begin_mass_recall()
	user.RemoveSpell(src)

//=====Purge Reagents=====
/obj/effect/proc_holder/spell/targeted/eminence/reagent_purge
	name = "Вычистить реагенты"
	desc = "Вычищает все лишние реагенты из цели. Нужно выбрать цель конечно же."
	action_icon_state = "Mending Mantra"
	charge_max = 300

/obj/effect/proc_holder/spell/targeted/eminence/reagent_purge/can_cast(mob/user)
	if(!..())
		return FALSE
	var/mob/living/simple_animal/eminence/E = user
	if(!istype(E))
		return FALSE
	if(E.selected_mob && is_servant_of_ratvar(E.selected_mob))
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/targeted/eminence/reagent_purge/cast(list/targets, mob/living/user)
	var/mob/living/simple_animal/eminence/E = user
	if(!istype(E))
		revert_cast(user)
		return FALSE
	if(!E.selected_mob || !is_servant_of_ratvar(E.selected_mob))
		E.selected_mob = null
		to_chat(user, span_neovgre("Нужна правильная цель."))
		revert_cast(user)
		return FALSE
	var/mob/living/L = E.selected_mob
	if(!istype(L))
		revert_cast(user)
		return FALSE
	L.reagents?.clear_reagents()
	to_chat(user, span_inathneq("Очищаю [L]!"))
	to_chat(L, span_inathneq("Преосвященство очищает мою кровь!"))
	return TRUE

//=====Linked Abscond=====
/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond
	name = "Связанное возвышение"
	desc = "Телепортирует цель на Риби, если она не будет двигаться 7 секунд."
	action_icon_state = "Linked Abscond"
	charge_max = 1800

/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond/can_cast(mob/user)
	if(!..())
		return FALSE
	var/mob/living/simple_animal/eminence/E = user
	if(!istype(E))
		return FALSE
	if(E.selected_mob && is_servant_of_ratvar(E.selected_mob))
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond/cast(list/targets, mob/living/user)
	var/mob/living/simple_animal/eminence/E = user
	if(!istype(E))
		to_chat(E, span_brass("Я Преосвященство! (ЧТО-ТО СЛОМАЛОСЬ)"))
		revert_cast(user)
		return FALSE
	if(!E.selected_mob || !is_servant_of_ratvar(E.selected_mob))
		E.selected_mob = null
		to_chat(user, span_neovgre("Нужно бы выбрать цель для начала."))
		revert_cast(user)
		return FALSE
	var/mob/living/L = E.selected_mob
	if(!istype(L))
		to_chat(E, span_brass("Не могу взаимодействовать с этим!"))
		revert_cast(user)
		return FALSE
	to_chat(E, span_brass("Начинаю процесс возвышения [L]..."))
	to_chat(L, span_brass("Преосвященство возвышает меня..."))
	L.visible_message(span_warning("[L] вспыхивает."))
	if(do_after(E, 70, target=L))
		L.visible_message(span_warning("[L] исчезает!"))
		var/turf/T = get_turf(pick(GLOB.servant_spawns))
		try_warp_servant(L, T, FALSE)
		return TRUE
	else
		to_chat(E, span_brass("Не вышло возвысить [L]."))
		revert_cast(user)
		return FALSE

/mob/living/eminence_act(mob/living/simple_animal/eminence/eminence)
	if(is_servant_of_ratvar(src) && !iseminence(src))
		eminence.selected_mob = src
		to_chat(eminence, "<span class='brass'>Выбираю [src].</span>")

/obj/machinery/light_switch/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, "<span class='brass'>Начинаю манипулировать с [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		interact(eminence)

/obj/machinery/flasher/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, "<span class='brass'>Начинаю манипулировать с [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		if(anchored)
			flash()

/obj/machinery/button/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, "<span class='brass'>Начинаю манипулировать с [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		attack_hand(eminence)

/obj/machinery/firealarm/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, "<span class='brass'>Начинаю манипулировать с [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		attack_hand(eminence)

/obj/machinery/power/apc/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	ui_interact(eminence)

/obj/machinery/door/airlock/eminence_act(mob/living/simple_animal/eminence/eminence)
	..()
	to_chat(usr, "<span class='brass'>Начинаю манипулировать с [src]!</span>")
	if(do_after(eminence, 20, target=get_turf(eminence)))
		if(welded)
			to_chat(eminence, text("Шлюз заварен!"))
		else if(locked)
			to_chat(eminence, text("Болты опущены!"))
		else if(!density)
			close()
		else
			open()
