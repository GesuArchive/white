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
	to_chat(owner, "<span class='notice'>[pick("Чувствую, как мысли сосредотачиваются на этой фразе... Не могу выбросить это из головы.",\
												"Голова болит, но это все, о чем можно думать. Это жизненно важно.",\
												"Чувствую, как часть разума повторяет это снова и снова. Нужно следовать этим словам.",\
												"В этих словах сокрыта истина... это правильно, по какой-то причине. Чувствую, что нужно следовать этим словам.",\
												"Эти слова продолжают эхом отдаваться в сознании. Они полностью завладели моим разумом.")]</span>")
	to_chat(owner, "<span class='boldwarning'>Меня загипнотизировало это предложениее. Требуется следовать этим словам. Если это не четкий приказ, то можно свободно интерпретировать указание,\
										пока приказ действует, вести себя так, как будто слова являются моим высшим приоритетом.</span>")
	var/atom/movable/screen/alert/hypnosis/hypno_alert = owner.throw_alert("hypnosis", /atom/movable/screen/alert/hypnosis)
	hypno_alert.desc = "\"[hypnotic_phrase]\"... разум, похоже, зациклен на этой фразе."
	..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] больше не загипнотизирован фразой '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] больше не загипнотизирован фразой '[hypnotic_phrase]'.")
	to_chat(owner, span_userdanger("Внезапно выхожу из состояния гипноза. Фраза '[hypnotic_phrase]' больше не кажется важной."))
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

/datum/brain_trauma/surg_hypnosis
	name = "Внушённая подмена понятий"
	desc = "Подсознание пациента полностью захвачено определенным приказом. Он будет следовать ему несмотря ни на что."
	scan_desc = "<b>внушенной подмены понятий</b>"
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY
