/datum/disease/heart_failure
	form = "Обстоятельства"
	name = "Инфаркт миокарда"
	max_stages = 5
	stage_prob = 1
	cure_text = "Операция по замене сердца, чтобы вылечить. Дефибрилляция (или, в крайнем случае, неконтролируемое поражение электрическим током) также может быть эффективной после начала остановки сердца. Пентрит также может смягчить остановку сердца."
	agent = "Дерьмовое сердце"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	desc = "Если не лечить, субъект умрет!"
	severity = "Опасный!"
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	visibility_flags = HIDDEN_PANDEMIC
	required_organs = list(/obj/item/organ/heart)
	bypasses_immunity = TRUE // Immunity is based on not having an appendix; this isn't a virus
	var/sound = FALSE

/datum/disease/heart_failure/Copy()
	var/datum/disease/heart_failure/D = ..()
	D.sound = sound
	return D


/datum/disease/heart_failure/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(!affected_mob.can_heartattack())
		cure()
		return FALSE

	switch(stage)
		if(1 to 2)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_warning("Ощущаю [pick("дискомфорт", "давление", "жжение", "боль")] в груди."))
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_warning("Ощущаю головокружение."))
				affected_mob.add_confusion(6)
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, span_warning("Ощущаю [pick("полноту", "тошноту", "пот", "слабость", "усталость", "нехватку кислорода", "себя плохо")]."))
		if(3 to 4)
			if(!sound)
				affected_mob.playsound_local(affected_mob, 'sound/health/slowbeat.ogg', 40, FALSE, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
				sound = TRUE
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю острую боль в груди!"))
				if(prob(25))
					affected_mob.vomit(95)
				affected_mob.emote("cough")
				affected_mob.Paralyze(40)
				affected_mob.losebreath += 4
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю сильную слабость и головокружение..."))
				affected_mob.add_confusion(8)
				affected_mob.adjustStaminaLoss(40, FALSE)
				affected_mob.emote("cough")
		if(5)
			affected_mob.stop_sound_channel(CHANNEL_HEARTBEAT)
			affected_mob.playsound_local(affected_mob, 'sound/effects/singlebeat.ogg', 100, FALSE, use_reverb = FALSE)
			if(affected_mob.stat == CONSCIOUS)
				affected_mob.visible_message(span_danger("[affected_mob] хватается за [affected_mob.ru_ego()] грудь, так как [affected_mob.ru_ego()] сердце остановилось!") , \
					span_userdanger("Ощущаю ужасную боль в груди, так как сердечко всё!"))
			affected_mob.adjustStaminaLoss(60, FALSE)
			affected_mob.set_heartattack(TRUE)
			affected_mob.reagents.add_reagent(/datum/reagent/medicine/c2/penthrite, 3) // To give the victim a final chance to shock their heart before losing consciousness
			cure()
			return FALSE
