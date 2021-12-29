/datum/disease/flu
	name = "Грипп"
	max_stages = 3
	spread_text = "Воздушное"
	cure_text = "Космоцилин"
	cures = list(/datum/reagent/medicine/spaceacillin)
	cure_chance = 5
	agent = "H13N1 вирион гриппа"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "Если не лечить, субъект будет плохо себя чувствовать."
	severity = DISEASE_SEVERITY_MINOR


/datum/disease/flu/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("sneeze")
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("cough")
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("У меня болят мышцы."))
				if(prob(20))
					affected_mob.take_bodypart_damage(1, updating_health = FALSE)
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("У меня болит живот."))
				if(prob(20))
					affected_mob.adjustToxLoss(1, FALSE)
			if(affected_mob.body_position == LYING_DOWN && DT_PROB(10, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				stage--
				return

		if(3)
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("sneeze")
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("cough")
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("У меня болят мышцы."))
				if(prob(20))
					affected_mob.take_bodypart_damage(1, updating_health = FALSE)
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("У меня болит живот."))
				if(prob(20))
					affected_mob.adjustToxLoss(1, FALSE)
			if(affected_mob.body_position == LYING_DOWN && DT_PROB(7.5, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				stage--
				return
