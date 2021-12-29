/datum/disease/adrenal_crisis
	form = "Обстоятельства"
	name = "Кризис надпочечников"
	max_stages = 2
	cure_text = "Травма"
	cures = list(/datum/reagent/determination)
	cure_chance = 10
	agent = "Дерьмовые надпочечники"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	desc = "Если не лечить, субъект будет страдать от летаргии, головокружения и периодической потери сознания."
	severity = DISEASE_SEVERITY_MEDIUM
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	visibility_flags = HIDDEN_PANDEMIC
	bypasses_immunity = TRUE

/datum/disease/adrenal_crisis/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_warning(pick("Голова кружится.", "Ощущаю вялость.")))
		if(2)
			if(DT_PROB(5, delta_time))
				affected_mob.Unconscious(40)

			if(DT_PROB(10, delta_time))
				affected_mob.slurring += 7

			if(DT_PROB(7, delta_time))
				affected_mob.Dizzy(10)

			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_warning(pick("Ощущаю стреляющую боль в ногах!", "Кажется я сейчас потеряю сознание.", "Голова сильно кружится.")))
