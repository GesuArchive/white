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

	var/calculated_cogs = 0
	var/cogs = 0

	var/mob/living/selected_mob = null

	var/obj/effect/proc_holder/spell/targeted/eminence/reebe/spell_reebe
	var/obj/effect/proc_holder/spell/targeted/eminence/station/spell_station
	var/obj/effect/proc_holder/spell/targeted/eminence/servant_warp/spell_servant_warp
	var/obj/effect/proc_holder/spell/targeted/eminence/mass_recall/mass_recall
	var/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond/linked_abscond
	var/obj/effect/proc_holder/spell/targeted/eminence/trigger_event/trigger_event

/mob/living/simple_animal/eminence/ClickOn(atom/A, params)
	. = ..()
	if(!.)
		A.eminence_act(src)

/mob/living/simple_animal/eminence/proc/cog_change()
	//Calculate cogs
	if(calculated_cogs != GLOB.installed_integration_cogs)
		var/difference = GLOB.installed_integration_cogs - calculated_cogs
		calculated_cogs += difference
		cogs += difference
		to_chat(src, span_brass("Получаю [difference] шестерней!"))

//Cannot gib the eminence.
/mob/living/simple_animal/eminence/gib()
	return

/mob/living/simple_animal/eminence/UnarmedAttack(atom/A)
	return FALSE

/mob/living/simple_animal/eminence/start_pulling(atom/movable/AM, state, force = move_force, supress_message = FALSE)
	return FALSE

/mob/living/simple_animal/eminence/Initialize()
	. = ..()
	GLOB.clockcult_eminence = src
	//Add spells
	spell_reebe = new
	AddSpell(spell_reebe)
	spell_station = new
	AddSpell(spell_station)
	spell_servant_warp = new
	AddSpell(spell_servant_warp)
	mass_recall = new
	AddSpell(mass_recall)
	linked_abscond = new
	AddSpell(linked_abscond)
	trigger_event = new
	AddSpell(trigger_event)
	//Wooooo, you are a ghost
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	cog_change()

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

/mob/living/simple_animal/eminence/proc/run_global_event(datum/round_event_control/E)
	E.preRunEvent()
	E.runEvent()
	SSevents.reschedule()

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
	var/cog_cost

/obj/effect/proc_holder/spell/targeted/eminence/can_cast(mob/user)
	. = ..()
	var/mob/living/simple_animal/eminence/eminence = user
	if(!istype(eminence))
		return FALSE
	if(eminence.cogs < cog_cost)
		return FALSE

/obj/effect/proc_holder/spell/targeted/eminence/proc/consume_cogs(mob/living/simple_animal/eminence/eminence)
	eminence.cogs -= cog_cost

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

//=====Teleport to servant=====
/obj/effect/proc_holder/spell/targeted/eminence/servant_warp
	name = "Перейти к служителю"
	desc = "Телепортировать себя к нему."
	action_icon_state = "Spatial Warp"

/obj/effect/proc_holder/spell/targeted/eminence/servant_warp/cast(list/targets, mob/user)
	//Get a list of all servants
	var/choice = input(user, "Выберем же его", "Перемещение к...", null) in GLOB.all_servants_of_ratvar
	if(!choice)
		return
	for(var/mob/living/L in GLOB.all_servants_of_ratvar)
		if(L.name == choice)
			choice = L
			break
	if(!isliving(choice))
		to_chat(user, span_warning("Не могу!"))
		return
	var/mob/living/M = choice
	if(!is_servant_of_ratvar(M))
		to_chat(user, span_warning("Это больше не служитель Ратвара!"))
		return
	var/turf/T = get_turf(M)
	user.forceMove(get_turf(T))
	SEND_SOUND(user, sound('sound/magic/magic_missile.ogg'))
	flash_color(user, flash_color = "#AF0AAF", flash_time = 25)

//=====Mass Recall=====
/obj/effect/proc_holder/spell/targeted/eminence/mass_recall
	name = "Инициировать массовый призыв"
	desc = "Инициирует массовый призыв, возвращая всех к ковчегу. ОДНОРАЗОВОЕ!"
	action_icon_state = "Spatial Gateway"

/obj/effect/proc_holder/spell/targeted/eminence/mass_recall/cast(list/targets, mob/living/user)
	var/obj/structure/destructible/clockwork/massive/celestial_gateway/C = GLOB.celestial_gateway
	if(!C)
		return
	C.begin_mass_recall()
	user.RemoveSpell(src)

//=====Linked Abscond=====
/obj/effect/proc_holder/spell/targeted/eminence/linked_abscond
	name = "Связанное возвышение"
	desc = "Телепортирует цель на Риби, если она не будет двигаться 7 секунд. Стоит 1 шестерню."
	action_icon_state = "Linked Abscond"
	charge_max = 1800
	cog_cost = 1

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
		consume_cogs(E)
		return TRUE
	else
		to_chat(E, span_brass("Не вышло возвысить [L]."))
		revert_cast(user)
		return FALSE


//Trigger event
/obj/effect/proc_holder/spell/targeted/eminence/trigger_event
	name = "Манипуляция с реальностью"
	desc = "Меняем реальность используя окружение. Стоит 5 шестерёнок."
	action_icon_state = "Geis"
	charge_max = 3000
	cog_cost = 5

/obj/effect/proc_holder/spell/targeted/eminence/trigger_event/cast(list/targets, mob/user)
	var/picked_event = input(user, "Что мы запустим?", "Манипуляция с реальностью", null) in list(
		"Anomaly",
		"Brand Intelligence",
		"Camera Failure",
		"Communications Blackout",
		"Disease Outbreak",
		"Electrical Storm",
		"False Alarm",
		"Grid Check",
		"Mass Hallucination",
		"Processor Overload",
		"Radiation Storm"
	)
	if(!can_cast(user))
		return
	if(!picked_event)
		revert_cast(user)
		return
	if(picked_event == "Anomaly")
		picked_event = pick("Anomaly: Energetic Flux", "Anomaly: Pyroclastic", "Anomaly: Gravitational", "Anomaly: Bluespace")
	//Reschedule events
	//Get the picked event
	for(var/datum/round_event_control/E in SSevents.control)
		if(E.name == picked_event)
			var/mob/living/simple_animal/eminence/eminence = user
			INVOKE_ASYNC(eminence, /mob/living/simple_animal/eminence.proc/run_global_event, E)
			consume_cogs(user)
			return
	revert_cast(user)

/mob/living/eminence_act(mob/living/simple_animal/eminence/eminence)
	if(is_servant_of_ratvar(src) && !iseminence(src))
		eminence.selected_mob = src
		to_chat(eminence, span_brass("Выбираю [src]."))

/obj/machinery/light_switch/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, span_brass("Начинаю манипулировать с [src]!"))
	if(do_after(eminence, 20, target=get_turf(eminence)))
		interact(eminence)

/obj/machinery/flasher/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, span_brass("Начинаю манипулировать с [src]!"))
	if(do_after(eminence, 20, target=get_turf(eminence)))
		if(anchored)
			flash()

/obj/machinery/button/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, span_brass("Начинаю манипулировать с [src]!"))
	if(do_after(eminence, 20, target=get_turf(eminence)))
		attack_hand(eminence)

/obj/machinery/firealarm/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	to_chat(usr, span_brass("Начинаю манипулировать с [src]!"))
	if(do_after(eminence, 20, target=get_turf(eminence)))
		attack_hand(eminence)

/obj/machinery/power/apc/eminence_act(mob/living/simple_animal/eminence/eminence)
	. = ..()
	ui_interact(eminence)

/obj/machinery/door/airlock/eminence_act(mob/living/simple_animal/eminence/eminence)
	..()
	to_chat(usr, span_brass("Начинаю манипулировать с [src]!"))
	if(do_after(eminence, 20, target=get_turf(eminence)))
		if(welded)
			to_chat(eminence, text("Шлюз заварен!"))
		else if(locked)
			to_chat(eminence, text("Болты опущены!"))
		else if(!density)
			close()
		else
			open()
