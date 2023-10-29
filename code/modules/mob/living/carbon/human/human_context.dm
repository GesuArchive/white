/mob/living/carbon/human/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!ishuman(user))
		return .

	if (user == src)
		return .

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		if (user.a_intent == INTENT_GRAB)
			context[SCREENTIP_CONTEXT_LMB] = "Проверить задний карман"
		else if (user.a_intent == INTENT_DISARM)
			context[SCREENTIP_CONTEXT_LMB] = "Шлёпнуть"

	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if (user.a_intent == INTENT_DISARM)
			context[SCREENTIP_CONTEXT_LMB] = "Дать пощёчину"

	if (pulledby == user)
		switch (user.grab_state)
			if (GRAB_PASSIVE)
				context[SCREENTIP_CONTEXT_CTRL_LMB] = "Захват"
			if (GRAB_AGGRESSIVE)
				context[SCREENTIP_CONTEXT_CTRL_LMB] = "Удушающий"
			if (GRAB_NECK)
				context[SCREENTIP_CONTEXT_CTRL_LMB] = "Душить"
			else
				return .
	else
		context[SCREENTIP_CONTEXT_CTRL_LMB] = "Тащить"

	return CONTEXTUAL_SCREENTIP_SET
