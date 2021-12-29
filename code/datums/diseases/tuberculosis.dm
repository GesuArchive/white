/datum/disease/tuberculosis
	form = "Болезнь"
	name = "Грибковый туберкулез"
	max_stages = 5
	spread_text = "Воздушное"
	cure_text = "Космоциллин и конвермол"
	cures = list(/datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/c2/convermol)
	agent = "Грибковая туберкулезная космическая палочка"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 2.5 //like hell are you getting out of hell
	desc = "Редкий высокотрансмиссивный вирулентный вирус. Существует немного образцов, которые, по слухам, были тщательно выращены и культивированы тайными специалистами по биологическому оружию. Вызывает лихорадку, рвоту кровью, повреждение легких, потерю веса и усталость."
	required_organs = list(/obj/item/organ/lungs)
	severity = DISEASE_SEVERITY_BIOHAZARD
	bypasses_immunity = TRUE // TB primarily impacts the lungs; it's also bacterial or fungal in nature; viral immunity should do nothing.

/datum/disease/tuberculosis/stage_act(delta_time, times_fired) //it begins
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("cough")
				to_chat(affected_mob, span_danger("Грудь болит."))
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Желужок жужжит!"))
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_danger("Потею."))
		if(4)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_userdanger("Вижу всего по четыре!"))
				affected_mob.Dizzy(5)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Грудь болит!"))
				affected_mob.adjustOxyLoss(5, FALSE)
				affected_mob.emote("gasp")
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Воздух больно выходит из моих лёгких."))
				affected_mob.adjustOxyLoss(25, FALSE)
				affected_mob.emote("gasp")
		if(5)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_userdanger("[pick("Сердце замедляется...", "Расслабляюсь вместе с сердечным ритмом.")]"))
				affected_mob.adjustStaminaLoss(70, FALSE)
			if(DT_PROB(5, delta_time))
				affected_mob.adjustStaminaLoss(100, FALSE)
				affected_mob.visible_message(span_warning("[affected_mob] ослабевает!") , span_userdanger("Сдаюсь и ощущаю умиротворение..."))
				affected_mob.AdjustSleeping(100)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_userdanger("Мой разум расслабляется и мысли текут!"))
				affected_mob.set_confusion(min(100, affected_mob.get_confusion() + 8))
			if(DT_PROB(5, delta_time))
				affected_mob.vomit(20)
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, span_warning("<i>[pick("Желудок тихо жужжит...", "Живот содрогается в последний раз, безжизненный взгляд застывает...", "Хочу съесть мелок")]</i>"))
				affected_mob.overeatduration = max(affected_mob.overeatduration - (200 SECONDS), 0)
				affected_mob.adjust_nutrition(-100)
			if(DT_PROB(7.5, delta_time))
				to_chat(affected_mob, span_danger("[pick("Слишком жарко...", "Надо расстегнуть костюм...", "Надо снять одежду...")]"))
				affected_mob.adjust_bodytemperature(40)
