/datum/disease/cold
	name = "Холод"
	max_stages = 3
	cure_text = "Отдых и космоцилин"
	cures = list(/datum/reagent/medicine/spaceacillin)
	agent = "XY-риновирус"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.5
	desc = "Если не лечить, субъект заразится гриппом."
	severity = DISEASE_SEVERITY_NONTHREAT


/datum/disease/cold/stage_act(delta_time, times_fired)
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
				to_chat(affected_mob, span_danger("У меня болит горло."))
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("Чувствую мокроту в горле, похоже, слизистая раздражена."))
			if((affected_mob.body_position == LYING_DOWN && DT_PROB(23, delta_time)) || DT_PROB(0.025, delta_time))  //changed FROM prob(10) until sleeping is fixed // Has sleeping been fixed yet?
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
		if(3)
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("sneeze")
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("cough")
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("У меня болит горло."))
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("Чувствую мокроту в горле, похоже, слизистая раздражена."))
			if(DT_PROB(0.25, delta_time) && !LAZYFIND(affected_mob.disease_resistances, /datum/disease/flu))
				var/datum/disease/Flu = new /datum/disease/flu()
				affected_mob.ForceContractDisease(Flu, FALSE, TRUE)
				cure()
				return FALSE
			if((affected_mob.body_position == LYING_DOWN && DT_PROB(12.5, delta_time)) || DT_PROB(0.005, delta_time))  //changed FROM prob(5) until sleeping is fixed
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
