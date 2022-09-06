/datum/mutation/human/shock
	name = "Электрошок"
	desc = "Позволяет накапливать крайне высокий заряд статического электричества и при желании разряжаться на выбраную цель при касании."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = span_notice("Между моими пальцами пробегают разряды молний.")
	text_lose_indication = span_notice("Энергия утекает.")
	power_path = /datum/action/cooldown/spell/touch/shock
	instability = 30

/datum/action/cooldown/spell/touch/shock
	name = "Электрошок"
	desc = "Позволяет накапливать крайне высокий заряд статического электричества и при желании разряжаться на выбраную цель при касании."
	draw_message = "Руку трясет от переполнявшего ее напряжения."
	drop_message = "Сбрасываю заряд."
	button_icon_state = "zap"
	sound = 'sound/weapons/zapbang.ogg'
	cooldown_time = 10 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	hand_path = /obj/item/melee/touch_attack/shock

/datum/action/cooldown/spell/touch/shock/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		if(carbon_victim.electrocute_act(15, caster, 1, SHOCK_NOGLOVES | SHOCK_NOSTUN))//doesnt stun. never let this stun
			carbon_victim.dropItemToGround(carbon_victim.get_active_held_item())
			carbon_victim.dropItemToGround(carbon_victim.get_inactive_held_item())
			carbon_victim.add_confusion(15)
			carbon_victim.visible_message(
				span_danger("[caster] ударяет [victim] током!"),
				span_userdanger("[caster] ударяет меня током!"),
			)
			return TRUE

	else if(isliving(victim))
		var/mob/living/living_victim = victim
		if(living_victim.electrocute_act(15, caster, 1, SHOCK_NOSTUN))
			living_victim.visible_message(
				span_danger("[caster] ударяет [victim] током!"),
				span_userdanger("[caster] ударяет меня током!"),
			)
			return TRUE

	to_chat(caster, span_warning("[victim] никак не реагирует..."))
	return TRUE

/obj/item/melee/touch_attack/shock
	name = "Электрошок"
	desc = "Карманная молния"
	icon_state = "zapper"
	inhand_icon_state = "zapper"
