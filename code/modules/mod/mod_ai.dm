/obj/item/mod/control/transfer_ai(interaction, mob/user, mob/living/silicon/ai/intAI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return
	if(!open) //mod must be open
		balloon_alert(user, "Для установки протокола удаленного доступа скафандр должен быть открыт!")
		return
	switch(interaction)
		if(AI_TRANS_TO_CARD)
			if(!ai)
				balloon_alert(user, "ИИ отсутствует!")
				return
			balloon_alert(user, "Перенос на карту...")
			if(!do_after(user, 5 SECONDS, target = src))
				balloon_alert(user, "Прервано!")
				return
			if(!ai)
				return
			intAI = ai
			intAI.ai_restore_power()//So the AI initially has power.
			intAI.control_disabled = TRUE
			intAI.radio_enabled = FALSE
			intAI.disconnect_shell()
			intAI.forceMove(card)
			card.AI = intAI
			for(var/datum/action/action as anything in actions)
				action.Remove(intAI)
			intAI.controlled_equipment = null
			intAI.remote_control = null
			balloon_alert(intAI, "Перенос на интелкарту успешен")
			balloon_alert(user, "Перенос ИИ на интелкарту успешен")
			ai = null

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to the suit.
			intAI = card.AI
			if(!intAI)
				balloon_alert(user, "Нет ИИ в интелкарте!")
				return
			if(ai)
				balloon_alert(user, "Уже имеет ИИ!")
				return
			if(intAI.deployed_shell) //Recall AI if shelled so it can be checked for a client
				intAI.disconnect_shell()
			if(intAI.stat || !intAI.client)
				balloon_alert(user, "ИИ не реагирует!")
				return
			balloon_alert(user, "Перенос в скафандр...")
			if(!do_after(user, 5 SECONDS, target = src))
				balloon_alert(user, "Прервано!")
				return
			if(ai)
				return
			balloon_alert(user, "ИИ перенесён в скафандр")
			ai_enter_mod(intAI)
			card.AI = null

/obj/item/mod/control/proc/ai_enter_mod(mob/living/silicon/ai/new_ai)
	new_ai.control_disabled = FALSE
	new_ai.radio_enabled = TRUE
	new_ai.ai_restore_power()
	new_ai.cancel_camera()
	new_ai.controlled_equipment = src
	new_ai.remote_control = src
	new_ai.forceMove(src)
	ai = new_ai
	balloon_alert(new_ai, "Перенос в скафандр успешен")
	for(var/datum/action/action as anything in actions)
		action.Grant(new_ai)

#define MOVE_DELAY 2
#define WEARER_DELAY 1
#define LONE_DELAY 5
#define CHARGE_PER_STEP DEFAULT_CHARGE_DRAIN * 2.5
#define AI_FALL_TIME 1 SECONDS

/obj/item/mod/control/relaymove(mob/user, direction)
	if((!active && wearer) || get_charge() < CHARGE_PER_STEP  || user != ai || !COOLDOWN_FINISHED(src, cooldown_mod_move) || (wearer?.pulledby?.grab_state > GRAB_PASSIVE))
		return FALSE
	var/timemodifier = MOVE_DELAY * (ISDIAGONALDIR(direction) ? SQRT_2 : 1) * (wearer ? WEARER_DELAY : LONE_DELAY)
	if(wearer && !wearer.Process_Spacemove(direction))
		return FALSE
	else if(!wearer && (!has_gravity() || !isturf(loc)))
		return FALSE
	COOLDOWN_START(src, cooldown_mod_move, movedelay * timemodifier + slowdown_active)
	subtract_charge(CHARGE_PER_STEP)
	playsound(src, 'sound/mecha/mechmove01.ogg', 25, TRUE)
	if(ismovable(wearer?.loc))
		return wearer.loc.relaymove(wearer, direction)
	else if(wearer)
		ADD_TRAIT(wearer, TRAIT_FORCED_STANDING, MOD_TRAIT)
		addtimer(CALLBACK(src, PROC_REF(ai_fall)), AI_FALL_TIME, TIMER_UNIQUE | TIMER_OVERRIDE)
	var/atom/movable/mover = wearer || src
	return step(mover, direction)

#undef MOVE_DELAY
#undef WEARER_DELAY
#undef LONE_DELAY
#undef CHARGE_PER_STEP

/obj/item/mod/control/proc/ai_fall()
	if(!wearer)
		return
	REMOVE_TRAIT(wearer, TRAIT_FORCED_STANDING, MOD_TRAIT)

/obj/item/mod/ai_minicard
	name = "Мини-интелкарта"
	desc = "Небольшая карта, предназначенная для извлечения деактивированных ИИ и их последующего восстановления."
	icon = 'icons/obj/aicards.dmi'
	icon_state = "minicard"
	var/datum/weakref/stored_ai

/obj/item/mod/ai_minicard/Initialize(mapload, mob/living/silicon/ai/ai)
	. = ..()
	if(!ai)
		return
	ai.apply_damage(150, BURN)
	INVOKE_ASYNC(ai, TYPE_PROC_REF(/mob/living/silicon/ai, death))
	ai.forceMove(src)
	stored_ai = WEAKREF(ai)
	icon_state = "minicard-filled"

/obj/item/mod/ai_minicard/Destroy()
	QDEL_NULL(stored_ai)
	return ..()

/obj/item/mod/ai_minicard/examine(mob/user)
	. = ..()
	. += span_notice("Внутри [stored_ai.resolve() || "нет ИИ"]")

/obj/item/mod/ai_minicard/transfer_ai(interaction, mob/user, mob/living/silicon/ai/intAI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return
	if(interaction != AI_TRANS_TO_CARD)
		return
	var/mob/living/silicon/ai/ai = stored_ai.resolve()
	if(!ai)
		balloon_alert(user, "ИИ не обнаружен!")
		return
	balloon_alert(user, "Перенос на карту...")
	if(!do_after(user, 5 SECONDS, target = src) || !ai)
		balloon_alert(user, "Прервано!")
		return
	icon_state = "minicard"
	ai.forceMove(card)
	card.AI = ai
	ai.notify_ghost_cloning("АКТИВИРОВАН ПРОТОКОЛ РЕЗЕРВНОГО КОПИРОВАНИЯ ДАННЫХ!", source = card)
	balloon_alert(user, "ИИ передан на карту")
	stored_ai = null
