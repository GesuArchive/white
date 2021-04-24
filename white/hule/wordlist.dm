GLOBAL_LIST_INIT(bad_words, world.file2list("cfg/autoeban/bad_words.fackuobema"))

GLOBAL_LIST_INIT(exc_start, world.file2list("cfg/autoeban/exc_start.fackuobema"))
GLOBAL_LIST_INIT(exc_end, world.file2list("cfg/autoeban/exc_end.fackuobema"))
GLOBAL_LIST_INIT(exc_full, world.file2list("cfg/autoeban/exc_full.fackuobema"))

GLOBAL_LIST_INIT(neobuchaemie_debili, world.file2list("cfg/autoeban/debix_list.fackuobema"))

/proc/proverka_na_detey(var/msg, var/mob/target)
	if(!target.client)
		return TRUE
	msg = lowertext(msg)
	for(var/W in GLOB.bad_words)
		W = lowertext(W)
		if(findtext_char(msg, W) && isliving(target) && W != "")
			var/list/ML = splittext(msg, " ")

			if(W in GLOB.exc_start)
				for(var/WA in ML)
					if(findtext_char(WA, "[W]") < findtext_char(WA, regex("^[W]")))
						return TRUE

			if(W in GLOB.exc_end)
				for(var/WB in ML)
					if(findtext_char(WB, "[W]") > findtext_char(WB, regex("^[W]")))
						return TRUE

			if(W in GLOB.exc_full)
				for(var/WC in ML)
					if(findtext_char(WC, W) && (WC != W))
						return TRUE

			to_chat(target, "<span class='notice'><big>[uppertext(W)]...</big></span>")

			SEND_SOUND(target, sound('white/hule/SFX/rjach.ogg'))

			message_admins("Дружок [target.ckey] насрал на ИС словом \"[W]\". ([msg]) [ADMIN_COORDJMP(target)] [ADMIN_SMITE(target)]")
			return FALSE
	return TRUE
