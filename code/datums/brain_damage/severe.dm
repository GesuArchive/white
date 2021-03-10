//Severe traumas, when your brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They cannot be cured with chemicals, and require brain surgery to solve.

/datum/brain_trauma/severe
	resilience = TRAUMA_RESILIENCE_SURGERY

/datum/brain_trauma/severe/mute
	name = "Mutism"
	desc = "Пациент совершенно не может говорить."
	scan_desc = "обширное повреждение речевого центра мозга"
	gain_text = "<span class='warning'>А как говорить?!</span>"
	lose_text = "<span class='notice'>Ага, вот так вот можно говорить.</span>"

/datum/brain_trauma/severe/mute/on_gain()
	ADD_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/mute/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/aphasia
	name = "Aphasia"
	desc = "Пациент не может говорить или понимать какой-либо язык."
	scan_desc = "обширное повреждение языкового центра мозга"
	gain_text = "<span class='warning'>Проблемы с формированием слов в голове...</span>"
	lose_text = "<span class='notice'>А, вот как работают слова.</span>"

/datum/brain_trauma/severe/aphasia/on_gain()
	owner.add_blocked_language(subtypesof(/datum/language/) - /datum/language/aphasia, LANGUAGE_APHASIA)
	owner.grant_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_APHASIA)
	..()

/datum/brain_trauma/severe/aphasia/on_lose()
	owner.remove_blocked_language(subtypesof(/datum/language/), LANGUAGE_APHASIA)
	owner.remove_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_APHASIA)
	..()

/datum/brain_trauma/severe/blindness
	name = "Cerebral Blindness"
	desc = "Мозг пациента больше не связан с его глазами."
	scan_desc = "обширное повреждение затылочной доли головного мозга"
	gain_text = "<span class='warning'>Ничерта не вижу!</span>"
	lose_text = "<span class='notice'>Зрение возвращается.</span>"

/datum/brain_trauma/severe/blindness/on_gain()
	owner.become_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/blindness/on_lose()
	owner.cure_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/paralysis
	name = "Paralysis"
	desc = "Мозг пациента больше не может контролировать часть своих двигательных функций."
	scan_desc = "церебральный паралич"
	gain_text = ""
	lose_text = ""
	var/paralysis_type
	var/list/paralysis_traits = list()
	//for descriptions

/datum/brain_trauma/severe/paralysis/New(specific_type)
	if(specific_type)
		paralysis_type = specific_type
	if(!paralysis_type)
		paralysis_type = pick("full","left","right","arms","legs","r_arm","l_arm","r_leg","l_leg")
	var/subject
	switch(paralysis_type)
		if("full")
			subject = "своё тело"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("left")
			subject = "левую сторону тела"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)
		if("right")
			subject = "правую сторону тела"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG)
		if("arms")
			subject = "руки"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM)
		if("legs")
			subject = "ноги"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("r_arm")
			subject = "правую руку"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM)
		if("l_arm")
			subject = "левую руку"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM)
		if("r_leg")
			subject = "правую ногу"
			paralysis_traits = list(TRAIT_PARALYSIS_R_LEG)
		if("l_leg")
			subject = "левую ногу"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG)

	gain_text = "<span class='warning'>Больше не чувствую [subject]!</span>"
	lose_text = "<span class='notice'>Снова могу чувствовать [subject]!</span>"

/datum/brain_trauma/severe/paralysis/on_gain()
	..()
	for(var/X in paralysis_traits)
		ADD_TRAIT(owner, X, "trauma_paralysis")


/datum/brain_trauma/severe/paralysis/on_lose()
	..()
	for(var/X in paralysis_traits)
		REMOVE_TRAIT(owner, X, "trauma_paralysis")


/datum/brain_trauma/severe/paralysis/paraplegic
	random_gain = FALSE
	paralysis_type = "legs"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/narcolepsy
	name = "Нарколепсия"
	desc = "Пациент может непроизвольно заснуть во время обычных занятий."
	scan_desc = "травматическая нарколепсия"
	gain_text = "<span class='warning'>Пора спать...</span>"
	lose_text = "<span class='notice'>Бодрячком.</span>"

/datum/brain_trauma/severe/narcolepsy/on_life()
	..()
	if(owner.IsSleeping())
		return
	var/sleep_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		sleep_chance += 2
	if(owner.drowsyness)
		sleep_chance += 3
	if(prob(sleep_chance))
		to_chat(owner, "<span class='warning'>You fall asleep.</span>")
		owner.Sleeping(60)
	else if(!owner.drowsyness && prob(sleep_chance * 2))
		to_chat(owner, "<span class='warning'>You feel tired...</span>")
		owner.drowsyness += 10

/datum/brain_trauma/severe/monophobia
	name = "Monophobia"
	desc = "Пациент чувствует себя больным и расстроенным, когда его нет рядом с другими людьми, что приводит к потенциально смертельному стрессу."
	scan_desc = "монофобия"
	gain_text = ""
	lose_text = "<span class='notice'>Похоже можно побыть и в одиночестве.</span>"
	var/stress = 0

/datum/brain_trauma/severe/monophobia/on_gain()
	..()
	if(check_alone())
		to_chat(owner, "<span class='warning'>Мне так одиноко...</span>")
	else
		to_chat(owner, "<span class='notice'>Я в безопасности, пока рядом есть люди.</span>")

/datum/brain_trauma/severe/monophobia/on_life()
	..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && (prob(5)))
			stress_reaction()
	else
		stress = max(stress - 4, 0)

/datum/brain_trauma/severe/monophobia/proc/check_alone()
	if(owner.is_blind())
		return TRUE
	for(var/mob/M in oview(owner, 7))
		if(!isliving(M)) //ghosts ain't people
			continue
		if((istype(M, /mob/living/simple_animal/pet)) || M.ckey)
			return FALSE
	return TRUE

/datum/brain_trauma/severe/monophobia/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Мне плохо...</span>")
			else
				to_chat(owner, "<span class='warning'>Мне правда плохо от одиночества!</span>")
			addtimer(CALLBACK(owner, /mob/living/carbon.proc/vomit, high_stress), 50) //blood vomit if high stress
		if(2)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Не могу перестать шататься...</span>")
				owner.dizziness += 20
				owner.add_confusion(20)
				owner.Jitter(20)
			else
				to_chat(owner, "<span class='warning'>Ощущаю себя слабым и беззащитным! Если бы только я был не один...</span>")
				owner.dizziness += 20
				owner.add_confusion(20)
				owner.Jitter(20)
				owner.adjustStaminaLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Мне очень одиноко...</span>")
			else
				to_chat(owner, "<span class='warning'>Схожу с ума от одиночества!</span>")
				owner.hallucination += 30

		if(5)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Моё сердце замирает на мгновение.</span>")
				owner.adjustOxyLoss(8)
			else
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					H.set_heartattack(TRUE)
					to_chat(H, "<span class='userdanger'>О-О-О! МОЁ СЕРДЦЕ!!!</span>")
				else
					to_chat(owner, "<span class='userdanger'>Моё сердце хочет вырваться из груди...</span>")
					owner.adjustOxyLoss(8)

/datum/brain_trauma/severe/discoordination
	name = "Discoordination"
	desc = "Пациент не может использовать сложные инструменты или оборудование."
	scan_desc = "крайняя дискоординация"
	gain_text = "<span class='warning'>Едва могу контролировать свои руки!</span>"
	lose_text = "<span class='notice'>Руки снова работают как надо.</span>"

/datum/brain_trauma/severe/discoordination/on_gain()
	ADD_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/discoordination/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism
	name = "Traumatic Non-Violence"
	desc = "Пациент крайне не желает насильственно причинять вред другим."
	scan_desc = "тихоокеанский синдром"
	gain_text = "<span class='notice'>Чувствую себя на удивление спокойно.</span>"
	lose_text = "<span class='notice'>Больше не чувствую себя обязанным не причинять вреда.</span>"

/datum/brain_trauma/severe/pacifism/on_gain()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism/on_lose()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/hypnotic_stupor
	name = "Hypnotic Stupor"
	desc = "Пациент склонен к приступам сильного ступора, что делает его чрезвычайно внушаемым."
	scan_desc = "онейрическая петля обратной связи"
	gain_text = "<span class='warning'>Я немного ошеломлен.</span>"
	lose_text = "<span class='notice'>Туман уходит из моей головы.</span>"

/datum/brain_trauma/severe/hypnotic_stupor/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_stupor/on_life()
	..()
	if(prob(1) && !owner.has_status_effect(/datum/status_effect/trance))
		owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)

/datum/brain_trauma/severe/hypnotic_trigger
	name = "Hypnotic Trigger"
	desc = "У пациента в подсознании есть триггерная фраза, которая вызывает внушаемое состояние, подобное трансу."
	scan_desc = "онейрическая петля обратной связи"
	gain_text = "<span class='warning'>Что-то забыл... Что-то важное?</span>"
	lose_text = "<span class='notice'>Груз сняли с моего ума. Чудно.</span>"
	random_gain = FALSE
	var/trigger_phrase = "Нанотрейзен"

/datum/brain_trauma/severe/hypnotic_trigger/New(phrase)
	..()
	if(phrase)
		trigger_phrase = phrase

/datum/brain_trauma/severe/hypnotic_trigger/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_trigger/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear())
		return
	if(owner == hearing_args[HEARING_SPEAKER])
		return

	var/regex/reg = new("(\\b[REGEX_QUOTE(trigger_phrase)]\\b)","ig")

	if(findtext(hearing_args[HEARING_RAW_MESSAGE], reg))
		addtimer(CALLBACK(src, .proc/hypnotrigger), 10) //to react AFTER the chat message
		hearing_args[HEARING_RAW_MESSAGE] = reg.Replace(hearing_args[HEARING_RAW_MESSAGE], "<span class='hypnophrase'>*********</span>")

/datum/brain_trauma/severe/hypnotic_trigger/proc/hypnotrigger()
	to_chat(owner, "<span class='warning'>Слова вызывают что-то глубокое внутри, сознание ускользает...</span>")
	owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)
