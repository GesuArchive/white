/datum/disease/fake_gbs
	name = "GBS"
	max_stages = 5
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Синаптизин и сера"
	cures = list(/datum/reagent/medicine/synaptizine,/datum/reagent/sulfur)
	agent = "Гравитокинетические бипотенциальные SADS-"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Если не лечить, наступит смерть."
	severity = DISEASE_SEVERITY_BIOHAZARD


/datum/disease/fake_gbs/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(0.5, delta_time))
				affected_mob.emote("sneeze")
		if(3)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("cough")
			else if(DT_PROB(2.5, delta_time))
				affected_mob.emote("gasp")
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю сильную слабость..."))
		if(4)
			if(DT_PROB(5, delta_time))
				affected_mob.emote("cough")

		if(5)
			if(DT_PROB(5, delta_time))
				affected_mob.emote("cough")
