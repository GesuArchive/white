GLOBAL_LIST_INIT(bad_words, world.file2list("cfg/autoeban/bad_words.fackuobema"))

GLOBAL_LIST_INIT(exc_start, world.file2list("cfg/autoeban/exc_start.fackuobema"))
GLOBAL_LIST_INIT(exc_end, world.file2list("cfg/autoeban/exc_end.fackuobema"))
GLOBAL_LIST_INIT(exc_full, world.file2list("cfg/autoeban/exc_full.fackuobema"))

/proc/check_for_brainrot(var/msg, var/mob/target)
	if(!target.client)
		return
	msg = lowertext(msg)

	for(var/bad_word in GLOB.bad_words)
		bad_word = lowertext(bad_word)
		if(findtext_char(msg, bad_word) && isliving(target) && bad_word != "")
			var/list/words = splittext(msg, " ")

			if(bad_word in GLOB.exc_start)
				for(var/word in words)
					if(findtext_char(word, "[bad_word]") < findtext_char(word, regex("^[bad_word]")))
						return

			if(bad_word in GLOB.exc_end)
				for(var/word in words)
					if(findtext_char(word, "[bad_word]") > findtext_char(word, regex("^[bad_word]")))
						return

			if(bad_word in GLOB.exc_full)
				for(var/word in words)
					if(findtext_char(word, bad_word) && (word != bad_word))
						return
			

			target.client.bad_word_counter += 1
			message_admins("[ADMIN_LOOKUPFLW(target)], возможно, насрал на ИЦ словом \"[bad_word]\". Это его [target.client.bad_word_counter]-й раз.<br>(<u>[strip_html(msg)]</u>) [ADMIN_SMITE(target)] [target.client.bad_word_counter > 1 ? "Возможно, он заслужил смайт." : ""]")
			return
	return

/client
	var/bad_word_counter = 0

GLOBAL_LIST_INIT(ic_autocorrect, list(	")" = "smile", "(" = "frown", \
										"))" = "laugh", "((" = "cry", \
										"лол" = "laugh", "lol" = "laugh", \
										"лмао" = "laugh", "lmao" = "laugh", \
										"рофл" = "laugh", "rofl" = "laugh", \
										"кек" = "giggle", "kek" = "giggle", \
										"хз" = "shrug", "hz" = "shrug"))
