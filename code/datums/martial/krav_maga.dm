/datum/martial_art/krav_maga
	name = "Krav Maga"
	id = MARTIALART_KRAVMAGA
	var/datum/action/neck_chop/neckchop = new/datum/action/neck_chop()
	var/datum/action/leg_sweep/legsweep = new/datum/action/leg_sweep()
	var/datum/action/lung_punch/lungpunch = new/datum/action/lung_punch()

/datum/action/neck_chop
	name = "Удар по шее — повреждает шею, на некоторое время лишая жертву возможности говорить."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "neckchop"

/datum/action/neck_chop/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "neck_chop")
		owner.visible_message(span_danger("<b>[owner]</b> становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("<b>[owner]</b> принимает стойку удара по шее!"), "<b><i>Cледующей атакой будет <b>Удар по шее</b>.</i></b>")
		owner.mind.martial_art.streak = "neck_chop"

/datum/action/leg_sweep
	name = "Взмах ногой — сбивает жертву с ног на короткое время."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"

/datum/action/leg_sweep/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "leg_sweep")
		owner.visible_message(span_danger("<b>[owner]</b> становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("<b>[owner]</b> принимает стойку маха ногой!"), "<b><i>Cледующей атакой будет <b>Взмах ногой</b>.</i></b>")
		owner.mind.martial_art.streak = "leg_sweep"

/datum/action/lung_punch//referred to internally as 'quick choke'
	name = "Удар в легкие — наносит сильный удар чуть выше живота жертвы, сдавливая легкие. Пострадавший на короткое время не сможет дышать."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "lungpunch"

/datum/action/lung_punch/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Не могу использовать [name], когда я парализован."))
		return
	if (owner.mind.martial_art.streak == "quick_choke")
		owner.visible_message(span_danger("[owner] становится в нейтральную стойку."), "<b><i>Выхожу из боевой стойки.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] принимает стойку удара в лёгкие!"), "<b><i>Cледующей атакой будет <b>Удар в легкие</b>.</i></b>")
		owner.mind.martial_art.streak = "quick_choke"//internal name for lung punch

/datum/martial_art/krav_maga/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_userdanger("Теперь я знаю искусство [name]!"))
		to_chat(owner, span_danger("Наведитесь курсором на иконку приёма, чтобы узнать о нём подробнее."))
		neckchop.Grant(owner)
		legsweep.Grant(owner)
		lungpunch.Grant(owner)

/datum/martial_art/krav_maga/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("Внезапно забываю искусство [name]..."))
	neckchop.Remove(owner)
	legsweep.Remove(owner)
	lungpunch.Remove(owner)

/datum/martial_art/krav_maga/proc/check_streak(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	switch(streak)
		if("neck_chop")
			reset_streak(A)
			neck_chop(A,D)
			return TRUE
		if("leg_sweep")
			reset_streak(A)
			leg_sweep(A,D)
			return TRUE
		if("quick_choke")//is actually lung punch
			reset_streak(A)
			quick_choke(A,D)
			return TRUE
	return FALSE

/datum/martial_art/krav_maga/proc/leg_sweep(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(D.stat || D.IsParalyzed())
		return FALSE
	var/obj/item/bodypart/affecting = D.get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = D.run_armor_check(affecting, MELEE)
	D.visible_message(span_warning("<b>[A]</b> сбивает с ног <b>[D]</b>!") , \
					span_userdanger("<b>[A]</b> сметает меня с ног!"), span_hear("Слышу звук разрывающейся плоти!"), null, A)
	to_chat(A, span_danger("Сбиваю <b>[D]</b> с ног!"))
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	D.apply_damage(rand(20,30), STAMINA, affecting, armor_block)
	D.Knockdown(60)
	log_combat(A, D, "leg sweeped")
	return TRUE

/datum/martial_art/krav_maga/proc/quick_choke(mob/living/A, mob/living/D)//is actually lung punch
	if(!can_use(A))
		return FALSE
	D.visible_message(span_warning("<b>[A]</b> долбит в грудь <b>[D]</b>!") , \
					span_userdanger("<b>[A]</b> ударяет меня в грудь! Не могу дышать!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью в грудь <b>[D]</b>!"))
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	if(D.losebreath <= 10)
		D.losebreath = clamp(D.losebreath + 5, 0, 10)
	D.adjustOxyLoss(10)
	log_combat(A, D, "quickchoked")
	return TRUE

/datum/martial_art/krav_maga/proc/neck_chop(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	D.visible_message(span_warning("<b>[A]</b> лупит шею <b>[D]</b> в стиле каратэ!") , \
					span_userdanger("<b>[A]</b> лупит меня в шею в стиле каратэ! Говорить не могу!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Бью шею <b>[D]</b> в стиле каратэ, заставляя [D.ru_ego()] замолчать!"))
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	D.apply_damage(5, A.get_attack_type())
	if (iscarbon(D))
		var/mob/living/carbon/carbon_defender = D
		if(carbon_defender.silent <= 10)
			carbon_defender.silent = clamp(carbon_defender.silent + 10, 0, 10)
	log_combat(A, D, "neck chopped")
	return TRUE

/datum/martial_art/krav_maga/grab_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "grabbed (Krav Maga)")
	..()

/datum/martial_art/krav_maga/harm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "punched")
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, MELEE)
	var/picked_hit_type = pick("бьёт", "пинает")
	var/bonus_damage = 0
	if(D.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "втаптывает"
	D.apply_damage(rand(5,10) + bonus_damage, A.get_attack_type(), affecting, armor_block)
	if(picked_hit_type == "пинает" || picked_hit_type == "втаптывает")
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		playsound(get_turf(D), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		playsound(get_turf(D), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	D.visible_message(span_danger("<b>[A]</b> [picked_hit_type] <b>[D]</b>!"), \
					span_userdanger("<b>[A]</b> [picked_hit_type] меня!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("Моя атака [picked_hit_type] <b>[D]</b>!"))
	log_combat(A, D, "[picked_hit_type] with [name]")
	return TRUE

/datum/martial_art/krav_maga/disarm_act(mob/living/A, mob/living/D)
	if(!can_use(A))
		return FALSE
	if(check_streak(A,D))
		return TRUE
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, MELEE)
	if(D.body_position == STANDING_UP)
		D.visible_message(span_danger("<b>[A]</b> утихомиривает <b>[D]</b>!"), \
					span_userdanger("<b>[A]</b> даёт мощную пощёчину мне!"), span_hear("Слышу звук разрывающейся плоти!"), COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Даю мощного джеба <b>[D]</b>!"))
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		playsound(D, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
		D.apply_damage(rand(5,10), STAMINA, affecting, armor_block)
		log_combat(A, D, "punched nonlethally")
	if(D.body_position == LYING_DOWN)
		D.visible_message(span_danger("<b>[A]</b> утихомиривает <b>[D]</b>!"), \
					span_userdanger("<b>[A]</b> вершит насилие надо мной!"), span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, A)
		to_chat(A, span_danger("Втаптываю <b>[D]</b> поучительно!"))
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		playsound(D, 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
		D.apply_damage(rand(10,15), STAMINA, affecting, armor_block)
		log_combat(A, D, "stomped nonlethally")
	if(prob(D.getStaminaLoss()))
		D.visible_message(span_warning("<b>[D]</b> плюётся и отшатывается от боли!"), span_userdanger("Удар в болевую точку отдаётся по всему телу!"))
		D.drop_all_held_items()
	return TRUE

//Krav Maga Gloves

/obj/item/clothing/gloves/krav_maga
	var/datum/martial_art/krav_maga/style = new

/obj/item/clothing/gloves/krav_maga/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_GLOVES)
		style.teach(user, TRUE)

/obj/item/clothing/gloves/krav_maga/dropped(mob/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		style.remove(user)

/obj/item/clothing/gloves/krav_maga/sec//more obviously named, given to sec
	name = "перчатки krav maga"
	desc = "Эти перчатки могут научить выполнять приёмы krav maga с помощью наночипов."
	icon_state = "fightgloves"
	inhand_icon_state = "fightgloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/krav_maga/combatglovesplus
	name = "боевые перчатки плюс"
	desc = "Эти тактические перчатки огнеупорны и электрически изолированы, а благодаря использованию технологии наночипов научат боевому искусству krav maga."
	icon_state = "black"
	inhand_icon_state = "blackgloves"
	siemens_coefficient = 0
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 80, ACID = 50)
