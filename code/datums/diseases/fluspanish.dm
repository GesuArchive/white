/datum/disease/fluspanish
	name = "Грипп Испанской инквизиции"
	max_stages = 3
	spread_text = "Воздушное"
	cure_text = "Космоциллин и антитела к простому гриппу"
	cures = list(/datum/reagent/medicine/spaceacillin)
	cure_chance = 5
	agent = "1nqu1s1t10n вирион гриппа"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "Если не лечить, субъект сгорит за то, что был еретиком."
	severity = DISEASE_SEVERITY_DANGEROUS


/datum/disease/fluspanish/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			affected_mob.adjust_bodytemperature(5 * delta_time)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("sneeze")
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("cough")
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("Горю изнутри!"))
				affected_mob.take_bodypart_damage(0, 5, updating_health = FALSE)

		if(3)
			affected_mob.adjust_bodytemperature(10 * delta_time)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("sneeze")
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("cough")
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_danger("Горю изнутри!"))
				affected_mob.take_bodypart_damage(0, 5, updating_health = FALSE)
