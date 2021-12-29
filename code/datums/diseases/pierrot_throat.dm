/datum/disease/pierrot_throat
	name = "Горло Пьеро"
	max_stages = 4
	spread_text = "Воздушное"
	cure_text = "Банановые продукты, особенно банановый хлеб."
	cures = list(/datum/reagent/consumable/banana)
	cure_chance = 50
	agent = "H0NI<42 вирус"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "Если его не лечить, он, вероятно, доведет других до безумия."
	severity = DISEASE_SEVERITY_MEDIUM


/datum/disease/pierrot_throat/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю себя немного глупо."))
		if(2)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Вижу радуги."))
		if(3)
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("Мысли прерываются громким <b>ХОНКОМ!</b>"))
		if(4)
			if(DT_PROB(2.5, delta_time))
				affected_mob.say( pick( list("ХОНК!", "Хонк!", "Хонк.", "Хонк?", "Хонк!!", "Хонк?!", "Хонк...")) , forced = "pierrot's throat")


/datum/disease/pierrot_throat/after_add()
	RegisterSignal(affected_mob, COMSIG_MOB_SAY, .proc/handle_speech)


/datum/disease/pierrot_throat/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	var/list/split_message = splittext(message, " ") //List each word in the message
	var/applied = 0
	for (var/i in 1 to length(split_message))
		if(prob(3 * stage)) //Stage 1: 3% Stage 2: 6% Stage 3: 9% Stage 4: 12%
			if(findtext(split_message[i], "*") || findtext(split_message[i], ";") || findtext(split_message[i], ":"))
				continue
			split_message[i] = "ХОНК"
			if (applied++ > stage)
				break
	if (applied)
		speech_args[SPEECH_SPANS] |= SPAN_CLOWN // a little bonus
	message = jointext(split_message, " ")
	speech_args[SPEECH_MESSAGE] = message


/datum/disease/pierrot_throat/Destroy()
	UnregisterSignal(affected_mob, COMSIG_MOB_SAY)
	return ..()

/datum/disease/pierrot_throat/remove_disease()
	UnregisterSignal(affected_mob, COMSIG_MOB_SAY)
	return ..()
