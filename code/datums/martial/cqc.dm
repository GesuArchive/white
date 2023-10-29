#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/cqc
	name = "CQC"
	id = MARTIALART_CQC
	help_verb = /mob/living/proc/CQC_help
	block_chance = 75
	smashes_tables = TRUE
	var/old_grab_state = null
	var/mob/restraining_mob
	display_combos = TRUE

/datum/martial_art/cqc/reset_streak(mob/living/new_target)
	if(new_target && new_target != restraining_mob)
		restraining_mob = null
	return ..()

/datum/martial_art/cqc/proc/check_streak(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(findtext(streak,SLAM_COMBO))
		reset_streak()
		return Slam(A,D)
	if(findtext(streak,KICK_COMBO))
		reset_streak()
		return Kick(A,D)
	if(findtext(streak,RESTRAIN_COMBO))
		reset_streak()
		return Restrain(A,D)
	if(findtext(streak,PRESSURE_COMBO))
		reset_streak()
		return Pressure(A,D)
	if(findtext(streak,CONSECUTIVE_COMBO))
		reset_streak()
		return Consecutive(A,D)
	return FALSE

/datum/martial_art/cqc/proc/Slam(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(D.body_position == STANDING_UP)
		D.visible_message(span_danger("[A] укладывает [D] на пол!"), \
						span_userdanger("[A] укладывает меня на пол!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
		to_chat(A, span_danger("Укладываю [D] на пол!"))
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, TRUE, -1)
		D.apply_damage(10, BRUTE)
		D.Paralyze(12 SECONDS)
		log_combat(A, D, "slammed (CQC)")
		return TRUE

/datum/martial_art/cqc/proc/Kick(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(!D.stat || !D.IsParalyzed())
		D.visible_message(span_danger("[A] пинает [D] в спину!"), \
						span_userdanger("[A] пинает меня в спину!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Пинаю [D] в спину!"))
		playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
		var/atom/throw_target = get_edge_target_turf(D, A.dir)
		D.throw_at(throw_target, 1, 14, A)
		D.apply_damage(10, A.get_attack_type())
		log_combat(A, D, "kicked (CQC)")
		. = TRUE
	if(D.IsParalyzed() && !D.stat)
		log_combat(A, D, "knocked out (Head kick)(CQC)")
		D.visible_message(span_danger("[A] лупит по голове [D], принуждая отрубиться!"), \
						span_userdanger("[A] лупит меня по голове!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
		to_chat(A, span_danger("Луплю [D], принуждая отрубиться!"))
		playsound(get_turf(A), 'sound/weapons/genhit1.wav', 50, TRUE, -1)
		D.SetSleeping(30 SECONDS)
		D.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 150)
		. = TRUE

/datum/martial_art/cqc/proc/Pressure(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	log_combat(A, D, "pressured (CQC)")
	D.visible_message(span_danger("[A] бьёт [D] в шею!"), \
					span_userdanger("[A] бьёт меня в шею!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью в шею [D]!"))
	D.adjustStaminaLoss(60)
	playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/cqc/proc/Restrain(mob/living/A, mob/living/D)
	if(restraining_mob)
		return
	if(!can_use(A))
		return FALSE
	if(!D.stat)
		log_combat(A, D, "restrained (CQC)")
		D.visible_message(span_warning("[A] фиксирует [D] в удерживающем положении!"), \
						span_userdanger("[A] фиксирует меня жёстко!"), span_hear("Слышу потасовку и тихий рёв!"), null, A)
		to_chat(A, span_danger("Фиксирую [D] в удерживающем положении!"))
		D.adjustStaminaLoss(20)
		D.Stun(10 SECONDS)
		restraining_mob = D
		addtimer(VARSET_CALLBACK(src, restraining_mob, null), 50, TIMER_UNIQUE)
		return TRUE

/datum/martial_art/cqc/proc/Consecutive(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(!D.stat)
		log_combat(A, D, "consecutive CQC'd (CQC)")
		D.visible_message(span_danger("[A] лупит [D] в живот, шею и спину последовательно!"), \
						span_userdanger("Мой живот, шея и спина были последовательно наказаны ударами [A]!"), span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Бью живот, шею и спину [D] последовательно!"))
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
		var/obj/item/I = D.get_active_held_item()
		if(I && D.temporarilyRemoveItemFromInventory(I))
			A.put_in_hands(I)
		D.adjustStaminaLoss(50)
		D.apply_damage(25, A.get_attack_type())
		return TRUE

/datum/martial_art/cqc/grab_act(mob/living/A, mob/living/D)
	if(A.a_intent == INTENT_GRAB && A!=D && can_use(A)) // A!=D prevents grabbing yourself
		add_to_streak("G",D)
		if(check_streak(A,D)) //if a combo is made no grab upgrade is done
			return TRUE
		old_grab_state = A.grab_state
		D.grabbedby(A, 1)
		if(old_grab_state == GRAB_PASSIVE)
			D.drop_all_held_items()
			A.setGrabState(GRAB_AGGRESSIVE) //Instant agressive grab if on grab intent
			log_combat(A, D, "grabbed", addition="aggressively")
			D.visible_message(span_warning("[A] берёт в захват [D]!"), \
							span_userdanger("[A] берёт меня в захват!"), span_hear("Слышу звуки агрессивной потасовки!"), COMBAT_MESSAGE_RANGE, A)
			to_chat(A, span_danger("Беру в захват [D]!"))
		return TRUE
	else
		return FALSE

/datum/martial_art/cqc/harm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "attacked (CQC)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("CQCрует", "Биг Боссит")
	var/bonus_damage = 13
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "втаптывает в пол"
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "пинает" || picked_hit_type == "втаптывает в пол")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
	else
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
	D.visible_message(span_danger("[A] [picked_hit_type] [D]!"), \
					span_userdanger("[A] [picked_hit_type] меня!"), span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Моя атака [picked_hit_type] [D]!"))
	log_combat(A, D, "[picked_hit_type]s (CQC)")
	if(A.resting && !D.stat && !D.IsParalyzed())
		D.visible_message(span_danger("[A] сбивает с ног [D]!"), \
						span_userdanger("[A] сбивает меня с ног!"), span_hear("Слышу звук разрывающейся плоти!") , null, A)
		to_chat(A, span_danger("Сбиваю [D] с ног!"))
		playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
		D.apply_damage(10, BRUTE)
		D.Paralyze(60)
		log_combat(A, D, "sweeped (CQC)")
	return TRUE

/datum/martial_art/cqc/disarm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("D",D)
	var/obj/item/I = null
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "disarmed (CQC)", "[I ? " grabbing <b>[I]</b>" : ""]")
	if(restraining_mob && A.pulling == restraining_mob)
		log_combat(A, D, "knocked out (Chokehold)(CQC)")
		D.visible_message(span_danger("[A] хватает [D] за шею!"), \
						span_userdanger("[A] хватает меня за шею!"), span_hear("Слышу шорох и приглушенный стон!"), null, A)
		to_chat(A, span_danger("Беру [D] в удушающий захват!"))
		D.SetSleeping(40 SECONDS)
		restraining_mob = null
		if(A.grab_state < GRAB_NECK && !HAS_TRAIT(A, TRAIT_PACIFISM))
			A.setGrabState(GRAB_NECK)
		return TRUE
	if(prob(65))
		if(!D.stat || !D.IsParalyzed() || !restraining_mob)
			I = D.get_active_held_item()
			D.visible_message(span_danger("[A] лупит по челюсти [D]!"), \
							span_userdanger("[A] бьёт меня по челюсти, мне плохо!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
			to_chat(A, span_danger("Бью в [D] челюсть, от чего тот пошатывается!"))
			playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, TRUE, -1)
			if(I && D.temporarilyRemoveItemFromInventory(I))
				A.put_in_hands(I)
			D.Jitter(2)
			D.apply_damage(5, A.get_attack_type())
	else
		D.visible_message(span_danger("[A] проваливает попытку обезоружить [D]!"), \
						span_userdanger("Почти получилось обезоружить [A]!"), span_hear("Слышу взмах!"), COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_warning("Не вышло обезоружить [D]!"))
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
	return TRUE

/mob/living/proc/CQC_help()
	set name = "Вспомнить приёмы"
	set category = "CQC"
	to_chat(usr, "<b><i>Пытаюсь вспомнить базовую программу CQC.</i></b>")

	to_chat(usr, "<span class='notice'>Уложить</span>: Захват Удар. Роняет противника на пол, обездвиживая его.")
	to_chat(usr, "<span class='notice'>Удар CQC</span>: Удар Удар. Отталкивает противника. Вырубает поверженных противников.")
	to_chat(usr, "<span class='notice'>Удержать</span>: Захват Захват. Удерживает противника, обезоруживание возьмёт противника в удушающий захват.")
	to_chat(usr, "<span class='notice'>Давление</span>: Обезоружить Захват. Заставляет противника выдохнуться.")
	to_chat(usr, "<span class='notice'>Последовательный CQC</span>: Обезоружить Обезоружить Удар. Наносит противнику огромный урон и заставляет его выдохнуться.")

///Subtype of CQC. Only used for the chef.
/datum/martial_art/cqc/under_siege
	name = "Close Quarters Cooking"
	var/list/valid_areas = list(/area/service/kitchen)

///Prevents use if the cook is not in the kitchen.
/datum/martial_art/cqc/under_siege/can_use(mob/living/owner) //this is used to make chef CQC only work in kitchen
	if(!is_type_in_list(get_area(owner), valid_areas))
		return FALSE
	return ..()
