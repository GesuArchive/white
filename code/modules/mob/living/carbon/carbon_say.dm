/mob/living/carbon/proc/handle_tongueless_speech(mob/living/carbon/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	var/static/regex/tongueless_lower    = new("\[gdntke]+", "g")
	var/static/regex/tongueless_upper    = new("\[GDNTKE]+", "g")
	var/static/regex/tongueless_lower_ru = new("\[гднтке]+", "g")
	var/static/regex/tongueless_upper_ru = new("\[ГДНТКЕ]+", "g")
	if(message?[1] != "*")
		message = tongueless_lower.Replace_char(message, pick("aa","уу","мм","'"))
		message = tongueless_upper.Replace_char(message, pick("AA","УУ","мм","'"))
		message = tongueless_upper_ru.Replace_char(message, pick("AA","УУ","ММ","'"))
		message = tongueless_upper_ru.Replace_char(message, pick("AA","УУ","ММ","'"))
		speech_args[SPEECH_MESSAGE] = message

/mob/living/carbon/can_speak_vocal(message)
	if(silent)
		if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
			return ..()
		else
			return FALSE
	return ..()

/mob/living/carbon/could_speak_language(datum/language/language)
	var/obj/item/organ/tongue/T = get_organ_slot(ORGAN_SLOT_TONGUE)
	if(T)
		return T.could_speak_language(language)
	else
		return initial(language.flags) & TONGUELESS_SPEECH
