/datum/disease/decloning
	form = "Вирус"
	name = "Клеточная дегенерация"
	max_stages = 5
	stage_prob = 0.5
	cure_text = "Резадон или смерть."
	agent = "Серьезное генетическое повреждение"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = @"Если не лечить, субъект будет [REDACTED]!"
	severity = "Опасный!"
	cures = list(/datum/reagent/medicine/rezadone)
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	process_dead = TRUE

/datum/disease/decloning/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(affected_mob.stat == DEAD)
		cure()
		return FALSE

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("itch")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("yawn")
		if(3)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("itch")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("drool")
			if(DT_PROB(1.5, delta_time))
				affected_mob.adjustCloneLoss(1, FALSE)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Кожа ощущается странно."))

		if(4)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("itch")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("drool")
			if(DT_PROB(2.5, delta_time))
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, 170)
				affected_mob.adjustCloneLoss(2, FALSE)
			if(DT_PROB(7.5, delta_time))
				affected_mob.stuttering += 3
		if(5)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("itch")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("drool")
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_danger("Кожа начинает сползать!"))
			if(DT_PROB(5, delta_time))
				affected_mob.adjustCloneLoss(5, FALSE)
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2, 170)
			if(affected_mob.cloneloss >= 100)
				affected_mob.visible_message(span_danger("Кожа [affected_mob] превращается в пыль!") , span_boldwarning("Моя кожа превращается в пыль!"))
				affected_mob.dust()
				return FALSE
