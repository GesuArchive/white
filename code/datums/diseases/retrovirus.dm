/datum/disease/dna_retrovirus
	name = "Ретровирус"
	max_stages = 4
	spread_text = "Контактное"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Отдых или укол мутадона"
	cure_chance = 3
	agent = ""
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Ретровирус, изменяющий ДНК, который постоянно перемешивает структурные и уникальные ферменты хозяина."
	severity = DISEASE_SEVERITY_HARMFUL
	permeability_mod = 0.4
	stage_prob = 1
	var/restcure = 0

/datum/disease/dna_retrovirus/New()
	..()
	agent = "Класс вируса [pick("A","B","C","D","E","F")][pick("A","B","C","D","E","F")]-[rand(50,300)]"
	if(prob(40))
		cures = list(/datum/reagent/medicine/mutadone)
	else
		restcure = 1

/datum/disease/dna_retrovirus/Copy()
	var/datum/disease/dna_retrovirus/D = ..()
	D.restcure = restcure
	return D

/datum/disease/dna_retrovirus/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(DT_PROB(4, delta_time))
				to_chat(affected_mob, span_danger("Голова болит."))
			if(DT_PROB(4.5, delta_time))
				to_chat(affected_mob, span_danger("Что-то щекочет в груди."))
			if(DT_PROB(4.5, delta_time))
				to_chat(affected_mob, span_danger("Ненавижу всё."))
			if(restcure && affected_mob.body_position == LYING_DOWN && DT_PROB(16, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
		if(2)
			if(DT_PROB(4, delta_time))
				to_chat(affected_mob, span_danger("Кожа спадает."))
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Что-то не так."))
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("ГОЛОВА!"))
				affected_mob.Unconscious(40)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("Живот болит."))
			if(restcure && affected_mob.body_position == LYING_DOWN && DT_PROB(10, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
		if(3)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Всё тело вибрирует."))
			if(DT_PROB(19, delta_time))
				if(prob(50))
					scramble_dna(affected_mob, 1, 0, rand(15,45))
				else
					scramble_dna(affected_mob, 0, 1, rand(15,45))
			if(restcure && affected_mob.body_position == LYING_DOWN && DT_PROB(10, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
		if(4)
			if(DT_PROB(37, delta_time))
				if(prob(50))
					scramble_dna(affected_mob, 1, 0, rand(50,75))
				else
					scramble_dna(affected_mob, 0, 1, rand(50,75))
			if(restcure && affected_mob.body_position == LYING_DOWN && DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_notice("Чувствую себя лучше."))
				cure()
				return FALSE
