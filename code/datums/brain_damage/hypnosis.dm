/datum/brain_trauma/hypnosis
	name = "Гипноз"
	desc = "Подсознание пациента полностью захвачено словом или предложением, он сосредотачивает на нем все свои мысли и действия."
	scan_desc = "<b>зацикленного ментального паттерна</b>"
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY

	var/hypnotic_phrase = ""
	var/regex/target_phrase

/datum/brain_trauma/hypnosis/New(phrase)
	if(!phrase)
		qdel(src)
	hypnotic_phrase = phrase
	try
		target_phrase = new("(\\b[REGEX_QUOTE(hypnotic_phrase)]\\b)","ig")
	catch(var/exception/e)
		log_runtime("[e] on [e.file]:[e.line]")
		qdel(src)
	..()

/datum/brain_trauma/hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] был загипнотизирован фразой '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] был загипнотизирован фразой '[hypnotic_phrase]'.")
	to_chat(owner, "<span class='reallybig hypnophrase'>[hypnotic_phrase]</span>")
	to_chat(owner, "<span class='notice'>[pick("Вы чувствуете, как ваши мысли сосредотачиваются на этой фразе... Ты не можешь выбросить это из головы.",\
												"Голова болит, но это все, о чем ты можешь думать. Это жизненно важно.",\
												"Вы чувствуете, как часть вашего разума повторяет это снова и снова. Вам нужно следовать этим словам.",\
												"В этих словах сокрыта истина... это правильно, по какой-то причине. Вы чувствуете, что должны следовать этим словам.",\
												"Эти слова продолжают эхом отдаваться в твоем сознании. Они полностью завладели вашим разумом.")]</span>")
	to_chat(owner, "<span class='boldwarning'>Вы были загипнотизированы этим предложением. Вы должны следовать этим словам. Если это не четкий приказ, то вы сами можете свободно интерпретировать указание,\
										пока приказ действует, вы ведете себя так, как будто слова являются вашим высшим приоритетом.</span>")
	var/atom/movable/screen/alert/hypnosis/hypno_alert = owner.throw_alert("hypnosis", /atom/movable/screen/alert/hypnosis)
	hypno_alert.desc = "\"[hypnotic_phrase]\"... ваш разум, похоже, зациклен на этой фразе."
	..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] больше не загипнотизирован фразой '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] больше не загипнотизирован фразой '[hypnotic_phrase]'.")
	to_chat(owner, span_userdanger("Вы внезапно выходите из состояния гипноза. Фраза '[hypnotic_phrase]' больше не кажется вам важной."))
	owner.clear_alert("hypnosis")
	..()

/datum/brain_trauma/hypnosis/on_life(delta_time, times_fired)
	..()
	if(DT_PROB(1, delta_time))
		switch(rand(1,2))
			if(1)
				to_chat(owner, span_hypnophrase("<i>...[lowertext(hypnotic_phrase)]...</i>"))
			if(2)
				new /datum/hallucination/chat(owner, TRUE, FALSE, span_hypnophrase("[hypnotic_phrase]"))

/datum/brain_trauma/hypnosis/handle_hearing(datum/source, list/hearing_args)
	hearing_args[HEARING_RAW_MESSAGE] = target_phrase.Replace_char(hearing_args[HEARING_RAW_MESSAGE], span_hypnophrase("$1"))
