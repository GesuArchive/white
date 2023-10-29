/datum/disease/anxiety
	name = "Сильное беспокойство"
	form = "Инфекционное заболевание"
	max_stages = 4
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Этанол"
	cures = list(/datum/reagent/consumable/ethanol)
	agent = "Избыток лепидоптицидов"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Если не лечить, у субъекта будут извергаться бабочки."
	severity = DISEASE_SEVERITY_MINOR


/datum/disease/anxiety/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2) //also changes say, see say.dm
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_notice("Беспокойно."))
		if(3)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_notice("Живот трепещет."))
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_notice("Паника накатывает."))
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("ПАНИКУЮ!"))
				affected_mob.add_confusion(rand(2,3))
		if(4)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю бабочек в своём животе."))
			if(DT_PROB(2.5, delta_time))
				affected_mob.visible_message(span_danger("[affected_mob] спотыкается в панике.") , \
												span_userdanger("ПАНИЧЕСКАЯ АТАКА!"))
				affected_mob.add_confusion(rand(6,8))
				affected_mob.jitteriness += (rand(6,8))
			if(DT_PROB(1, delta_time))
				affected_mob.visible_message(span_danger("[affected_mob] выкашливает бабочек!") , \
													span_userdanger("Выкашливаю бабочек!"))
				new /mob/living/simple_animal/butterfly(affected_mob.loc)
				new /mob/living/simple_animal/butterfly(affected_mob.loc)
