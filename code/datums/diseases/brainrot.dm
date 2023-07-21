/datum/disease/brainrot
	name = "Брейнрот"
	max_stages = 4
	spread_text = "При контакте"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Маннитол"
	cures = list(/datum/reagent/medicine/mannitol)
	agent = "Криптококк Космосис"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 7.5 //higher chance to cure, since two reagents are required
	desc = "Это заболевание разрушает мозговые клетки, вызывая лихорадку головного мозга, некроз головного мозга и общую интоксикацию."
	required_organs = list(/obj/item/organ/brain)
	severity = DISEASE_SEVERITY_HARMFUL


/datum/disease/brainrot/stage_act(delta_time, times_fired) //Removed toxloss because damaging diseases are pretty horrible. Last round it killed the entire station because the cure didn't work -- Urist -ACTUALLY Removed rather than commented out, I don't see it returning - RR
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("blink")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("yawn")
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Я это не я."))
			if(DT_PROB(2.5, delta_time))
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, 170)
		if(3)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("stare")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("drool")
			if(DT_PROB(5, delta_time))
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2, 170)
				if(prob(2))
					to_chat(affected_mob, span_danger("Пытаюсь вспомнить что-то важное... но не могу."))

		if(4)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("stare")
			if(DT_PROB(1, delta_time))
				affected_mob.emote("drool")
			if(DT_PROB(7.5, delta_time))
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 170)
				if(prob(2))
					to_chat(affected_mob, span_danger("Странное жужжание наполняет голову, унося все мысли."))
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, span_danger("Сознание покидает меня..."))
				affected_mob.visible_message(span_warning("[affected_mob] отрубается!") , \
											span_userdanger("Отрубаюсь!"))
				affected_mob.Unconscious(rand(100, 200))
				if(prob(1))
					affected_mob.emote("snore")
			if(DT_PROB(7.5, delta_time))
				affected_mob.stuttering += 3

/datum/disease/brainrot/no_spread
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Лабебиум"
	cures = list(/obj/item/reagent_containers/pill/labebium)
