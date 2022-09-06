//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Параноидальная шизофрения"
	desc = "Пациент страдает от постоянных слуховых и визуальных галлюцинаций."
	scan_desc = "<b>параноидальной шизофрении</b>"
	gain_text = span_warning("Реальность изменятся...")
	lose_text = span_notice("Теперь могу сосредоточиться и способность отличать реальность от фантазии вернулась ко мне.")

/datum/brain_trauma/mild/hallucinations/on_life(delta_time, times_fired)
	owner.hallucination = min(owner.hallucination + 10, 50)
	..()

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.hallucination = 0
	..()

/datum/brain_trauma/mild/stuttering
	name = "Заикание"
	desc = "Пациент не может нормально говорить."
	scan_desc = "<b>легкого повреждения речевого центра мозга</b>"
	gain_text = span_warning("Говорить ясно становится все труднее.")
	lose_text = span_notice("Чувствую, что наконец-то способен контролировать свою речь.")

/datum/brain_trauma/mild/stuttering/on_life(delta_time, times_fired)
	owner.stuttering = min(owner.stuttering + 5, 25)
	..()

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.stuttering = 0
	..()

/datum/brain_trauma/mild/dumbness
	name = "Даунизм"
	desc = "У пациента снижена мозговая активность, что делает его менее умным."
	scan_desc = "<b>пониженной мозговой активности</b>"
	gain_text = span_warning("Мне кажется, что мир вокруг меня с каждой секундой становится все более сложным для понимания.")
	lose_text = span_notice("Осознаю себя более умным.")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "dumb", /datum/mood_event/oblivious)
	..()

/datum/brain_trauma/mild/dumbness/on_life(delta_time, times_fired)
	owner.derpspeech = min(owner.derpspeech + 5, 25)
	if(DT_PROB(1.5, delta_time))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && DT_PROB(1.5, delta_time))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage")
	..()

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.derpspeech = 0
	SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "dumb")
	..()

/datum/brain_trauma/mild/speech_impediment
	name = "Дефект речи"
	desc = "Пациент не в состоянии составлять сложные, связные предложения."
	scan_desc = "<b>коммуникативного расстройства</b>"
	gain_text = span_danger("Кажется, я не могу сформулировать ни одной связной мысли!")
	lose_text = span_danger("Мой разум становится более ясным.")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Сотрясение мозга"
	desc = "У пациента сотрясение мозга."
	scan_desc = "<b>сотрясения мозга</b>"
	gain_text = span_warning("Голова болит!")
	lose_text = span_notice("Давление в моей голове начинает ослабевать.")

/datum/brain_trauma/mild/concussion/on_life(delta_time, times_fired)
	if(DT_PROB(2.5, delta_time))
		switch(rand(1,11))
			if(1)
				owner.vomit()
			if(2,3)
				owner.dizziness += 10
			if(4,5)
				owner.add_confusion(10)
				owner.blur_eyes(10)
			if(6 to 9)
				owner.slurring += 30
			if(10)
				to_chat(owner, span_notice("А что делать то надо было?"))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("Слабею."))
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/healthy
	name = "Анозогнозия"
	desc = "Пациент всегда чувствует себя здоровым, независимо от своего состояния."
	scan_desc = "<b>нарушения критической самооценки</b>"
	gain_text = span_notice("Прекрасно себя чувствую!")
	lose_text = span_warning("Бльше не чувствую себя совершенно здоровым.")

/datum/brain_trauma/mild/healthy/on_gain()
	owner.set_screwyhud(SCREWYHUD_HEALTHY)
	..()

/datum/brain_trauma/mild/healthy/on_life(delta_time, times_fired)
	owner.set_screwyhud(SCREWYHUD_HEALTHY) //just in case of hallucinations
	owner.adjustStaminaLoss(-2.5 * delta_time) //no pain, no fatigue
	..()

/datum/brain_trauma/mild/healthy/on_lose()
	owner.set_screwyhud(SCREWYHUD_NONE)
	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Мышечная слабость"
	desc = "Пациент время от времени испытывает приступы мышечной слабости."
	scan_desc = "<b>ослабления сигнала двигательного нерва</b>"
	gain_text = span_warning("Мои мышцы внезапно ослабевают.")
	lose_text = span_notice("Мои мышцы вновь полны сил.")

/datum/brain_trauma/mild/muscle_weakness/on_life(delta_time, times_fired)
	var/fall_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(DT_PROB(0.5 * fall_chance, delta_time) && owner.body_position == STANDING_UP)
		to_chat(owner, span_warning("Моя нога подкашивается!"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(DT_PROB(0.5 * drop_chance, delta_time) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("Роняю [I]!"))

	else if(DT_PROB(1.5, delta_time))
		to_chat(owner, span_warning("Чувствую внезапную слабость в мышцах!"))
		owner.adjustStaminaLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "мышечные спазмы"
	desc = "У пациента время от времени возникают мышечные спазмы, заставляющие их непреднамеренно двигаться."
	scan_desc = "<b>нейротического спазма мышц</b>"
	gain_text = span_warning("Мои мышцы самопроизвольно сокращаются.")
	lose_text = span_notice("Снова чувствую контроль над своими мышцами.")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Нервный кашель"
	desc = "Пациент испытывает постоянную потребность в кашле."
	scan_desc = "<b>нервного кашеля</b>"
	gain_text = span_warning("У меня постоянно першит в горле...")
	lose_text = span_notice("Першение в горле наконец то прошло.")

/datum/brain_trauma/mild/nervous_cough/on_life(delta_time, times_fired)
	if(DT_PROB(6, delta_time) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, "<span notice='warning'>[pick("У меня приступ кашля!", "Не могу перестать кашлять!")]</span>")
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, /mob/.proc/emote, "cough"), 6)
			addtimer(CALLBACK(owner, /mob/.proc/emote, "cough"), 12)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Экспрессивная афазия"
	desc = "Пациент страдает частичной потерей речи, приводящей к сокращению словарного запаса."
	scan_desc = "<b>повреждения сенсорно-вербального речевого центра</b>"
	gain_text = span_warning("Теряю понимание сложных слов.")
	lose_text = span_notice("Чувствую, что мой словарный запас снова приходит в норму.")

	var/static/list/common_words = world.file2list("strings/1000_most_common.txt")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = ""
			var/suffix_foundon = 0
			for(var/potential_suffix in list("." , "," , ";" , "!" , ":" , "?"))
				suffix_foundon = findtext(word, potential_suffix, -length(potential_suffix))
				if(suffix_foundon)
					suffix = potential_suffix
					break

			if(suffix_foundon)
				word = copytext_char(word, 1, suffix_foundon)
			word = html_decode(word)

			if(lowertext(word) in common_words)
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("ых","хех")
					break
				else
					var/list/charlist = text2charlist(word)
					charlist.len = round(charlist.len * 0.5, 1)
					shuffle_inplace(charlist)
					new_message += jointext(charlist, "") + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "Эхо разума"
	desc = "Языковые нейроны пациента не заканчиваются должным образом, в результате чего предыдущие речевые паттерны иногда всплывают спонтанно."
	scan_desc = "<b>циклического аудио-вербального нейронного паттерна</b>"
	gain_text = span_warning("Чувствую слабое эхо моих мыслей...")
	lose_text = span_notice("Слабое эхо затихает вдали.")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(owner == hearing_args[HEARING_SPEAKER])
		return
	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_RAW_MESSAGE] = quoted_spoken_message.Replace_char(hearing_args[HEARING_RAW_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]
