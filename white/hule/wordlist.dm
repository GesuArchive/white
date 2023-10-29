GLOBAL_LIST_INIT(bad_words, world.file2list("cfg/autoeban/bad_words.fackuobema"))

GLOBAL_LIST_INIT(exc_start, world.file2list("cfg/autoeban/exc_start.fackuobema"))
GLOBAL_LIST_INIT(exc_end, world.file2list("cfg/autoeban/exc_end.fackuobema"))
GLOBAL_LIST_INIT(exc_full, world.file2list("cfg/autoeban/exc_full.fackuobema"))

GLOBAL_VAR_INIT(apply_execution_protocol, FALSE)

/mob/proc/check_for_brainrot(msg)
	if(!client)
		return msg
	var/corrected_message = msg

	msg = lowertext(msg)

	var/list/words = splittext(msg, " ")

	for(var/replacement in GLOB.ic_autocorrect)
		if(replacement in words)
			corrected_message = replacetext_char(corrected_message, uppertext(replacement), GLOB.ic_autocorrect[replacement])

	for(var/bad_word in GLOB.bad_words)
		bad_word = lowertext(bad_word)
		if(findtext_char(msg, bad_word) && isliving(src) && bad_word != "")
			if(bad_word in GLOB.exc_start)
				for(var/word in words)
					if(findtext_char(word, "[bad_word]") < findtext_char(word, regex("^[bad_word]")))
						return corrected_message

			if(bad_word in GLOB.exc_end)
				for(var/word in words)
					if(findtext_char(word, "[bad_word]") > findtext_char(word, regex("^[bad_word]")))
						return corrected_message

			if(bad_word in GLOB.exc_full)
				for(var/word in words)
					if(findtext_char(word, bad_word) && (word != bad_word))
						return corrected_message

			apply_execution(bad_word, msg)

			return corrected_message
	return corrected_message

/mob/proc/apply_execution(for_what, msg)
	client.bad_word_counter += 1
	message_admins("[ADMIN_LOOKUPFLW(src)], возможно, насрал на ИЦ словом \"[for_what]\". Это его [client.bad_word_counter]-й раз в этом раунде.<br>(<u>[strip_html(msg)]</u>) [ADMIN_SMITE(src)] [client.bad_word_counter > 1 ? "Возможно, он заслужил смайт." : ""]")
	if(GLOB.apply_execution_protocol)
		var/mob/living/L = src
		L.adjust_fire_stacks(5)
		L.adjustFireLoss(5)
		L.ignite_mob()

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/tongue/tongue = H.get_organ_slot(ORGAN_SLOT_TONGUE)
			if(tongue)
				tongue.Remove(H, special = TRUE)
				playsound(get_turf(H), 'white/valtos/sounds/gibpart.ogg', 80, TRUE)

		INVOKE_ASYNC(L, TYPE_PROC_REF(/mob, emote), "agony")
		to_chat(src, span_userdanger("... [uppertext(for_what)] ..."))
	else if(client.bad_word_counter == 1)
		to_chat(src, span_boldnotice("...Возможно, мне не стоит говорить такие \"смешные\" слова, как \"[uppertext(for_what)]\"..."))
	else
		to_chat(src, span_boldnotice("...Чувствую, что мне за \"[uppertext(for_what)]\" скоро влетит..."))

/client
	var/bad_word_counter = 0

GLOBAL_LIST_INIT(ic_autoemote, list(
	")" = "smile", "(" = "frown",
	"))" = "laugh", "((" = "cry",
	"лол" = "laugh", "lol" = "laugh",
	"лмао" = "laugh", "lmao" = "laugh",
	"рофл" = "laugh", "rofl" = "laugh",
	"кек" = "giggle", "kek" = "giggle",
	"хз" = "shrug", "hz" = "shrug",
	"мяу" = "moan", "meow" = "moan",
))

GLOBAL_LIST_INIT(ic_autocorrect, list(
	//"бог" = "НАУКА", "god" = "SCIENCE",
	//"боги" = "НАУКА", "gods" = "SCIENCE",
	//"богов" = "НАУКИ", "богами" = "НАУКОЙ",
	//"рцд" = "автоматический строительный комплекс", "rcd" = "rapid construction device",
	//"рпд" = "портативный раздатчик труб", "rpd" = "rapid pipe dispenser",
	//"секс" = "танец", "sex" = "dance",
	//"смо" = "главный врач", "cmo" = "chief medical officer",
	//"хос" = "начальник охраны", "hos" = "head of security",
	//"рд" = "научный руководитель", "rd" = "research director",
	//"се" = "старший инженер", "ce" = "chief engineer",
	//"км" = "квартирмейстер", "qm" = "quartermaster",
	//"хоп" = "глава персонала", "hop" = "head of personnel",
	//"гп" = "глава персонала", "врио" = "заместитель",
	//"гсб" = "хос хуесос",
	"шатл" = "шаттл"

))
