/datum/disease/parasite
	form = "Паразит"
	name = "Паразитарная инфекция"
	max_stages = 4
	cure_text = "Хирургическое удаление печени."
	agent = "Поедание живых паразитов"
	spread_text = "Небиологическое"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	desc = "Если не лечить, субъект пассивно теряет питательные вещества и, в конечном итоге, теряет печень."
	severity = DISEASE_SEVERITY_HARMFUL
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	required_organs = list(/obj/item/organ/liver)
	bypasses_immunity = TRUE


/datum/disease/parasite/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	var/obj/item/organ/liver/affected_liver = affected_mob.getorgan(/obj/item/organ/liver)
	if(!affected_liver)
		affected_mob.visible_message(span_notice("<B>Печень [affected_mob] покрыта крошечными личинками! Они быстро сморщиваются и умирают после пребывания на открытом воздухе.</B>"))
		cure()
		return FALSE

	switch(stage)
		if(1)
			if(DT_PROB(2.5, delta_time))
				affected_mob.emote("cough")
		if(2)
			if(DT_PROB(5, delta_time))
				if(prob(50))
					to_chat(affected_mob, span_notice("Ощущаю потерю веса!"))
				affected_mob.adjust_nutrition(-3)
		if(3)
			if(DT_PROB(10, delta_time))
				if(prob(20))
					to_chat(affected_mob, span_notice("Я... ОЧЕНЬ лёгкий."))
				affected_mob.adjust_nutrition(-6)
		if(4)
			if(DT_PROB(16, delta_time))
				if(affected_mob.nutrition >= 100)
					if(prob(10))
						to_chat(affected_mob, span_warning("Теряю вес на глазах!"))
					affected_mob.adjust_nutrition(-12)
				else
					to_chat(affected_mob, span_warning("Ощущаю НЕВЕРОЯТНУЮ лёгкость тела!"))
					affected_mob.vomit(20, TRUE)
					affected_liver.Remove(affected_mob)
					affected_liver.forceMove(get_turf(affected_mob))
					cure()
					return FALSE
