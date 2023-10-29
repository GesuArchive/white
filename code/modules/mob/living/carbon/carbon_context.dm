/mob/living/carbon/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if (!isnull(held_item))
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Предложить предмет"
		return CONTEXTUAL_SCREENTIP_SET

	if (!ishuman(user))
		return .

	var/mob/living/carbon/human/human_user = user

	if (human_user.a_intent == INTENT_HARM)
		context[SCREENTIP_CONTEXT_LMB] = "Атаковать"
	else if (human_user == src)
		context[SCREENTIP_CONTEXT_LMB] = "Проверить раны"
		var/obj/item/bodypart/limb = get_bodypart(human_user.zone_selected)
		if (limb?.get_part_bleed_rate())
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Зажать рану"

	if (human_user != src)
		context[SCREENTIP_CONTEXT_RMB] = "Толкнуть"

		if (human_user.a_intent == INTENT_HELP)
			if (body_position == STANDING_UP)
				if(check_zone(human_user.zone_selected) == BODY_ZONE_HEAD && get_bodypart(BODY_ZONE_HEAD))
					context[SCREENTIP_CONTEXT_LMB] = "Погладить"
				else
					context[SCREENTIP_CONTEXT_LMB] = "Обнять"
			else if (health >= 0 && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
				context[SCREENTIP_CONTEXT_LMB] = "Разбудить"
			else
				context[SCREENTIP_CONTEXT_LMB] = "Искусственное дыхание"

	return CONTEXTUAL_SCREENTIP_SET
