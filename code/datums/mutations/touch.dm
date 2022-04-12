/datum/mutation/human/shock
	name = "Электрошок"
	desc = "Позволяет накапливать крайне высокий заряд статического электричества и при желании разряжаться на выбраную цель при касании."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = span_notice("Между моими пальцами пробегают разряды молний.")
	text_lose_indication = span_notice("Энергия утекает.")
	power = /obj/effect/proc_holder/spell/targeted/touch/shock
	instability = 30

/obj/effect/proc_holder/spell/targeted/touch/shock
	name = "Электрошок"
	desc = "Позволяет накапливать крайне высокий заряд статического электричества и при желании разряжаться на выбраную цель при касании."
	drawmessage = "Руку трясет от переполнявшего ее напряжения."
	dropmessage = "Сбрасываю заряд."
	hand_path = /obj/item/melee/touch_attack/shock
	charge_max = 100
	clothes_req = FALSE
	action_icon_state = "zap"

/obj/item/melee/touch_attack/shock
	name = "Электрошок"
	desc = "Карманная молния"
	catchphrase = null
	on_use_sound = 'sound/weapons/zapbang.ogg'
	icon_state = "zapper"
	inhand_icon_state = "zapper"

/obj/item/melee/touch_attack/shock/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.electrocute_act(15, user, 1, SHOCK_NOGLOVES | SHOCK_NOSTUN))//doesnt stun. never let this stun
			C.dropItemToGround(C.get_active_held_item())
			C.dropItemToGround(C.get_inactive_held_item())
			C.add_confusion(15)
			C.visible_message(span_danger("[user] ударяет [target] током!") ,span_userdanger("[user] ударяет меня током!"))
			return ..()
		else
			user.visible_message(span_warning("[user] fails to electrocute [target]!"))
			return ..()
	else if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(15, user, 1, SHOCK_NOSTUN)
		L.visible_message(span_danger("[user] ударяет [target] током!") ,span_userdanger("[user] ударяет меня током!"))
		return ..()
	else
		to_chat(user,span_warning("The electricity doesn't seem to affect [target]..."))
		return ..()
