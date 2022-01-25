GLOBAL_LIST_INIT(bad_words, world.file2list("cfg/autoeban/bad_words.fackuobema"))

GLOBAL_LIST_INIT(exc_start, world.file2list("cfg/autoeban/exc_start.fackuobema"))
GLOBAL_LIST_INIT(exc_end, world.file2list("cfg/autoeban/exc_end.fackuobema"))
GLOBAL_LIST_INIT(exc_full, world.file2list("cfg/autoeban/exc_full.fackuobema"))

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

			target.overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, 6)
			addtimer(CALLBACK(target, /mob.proc/clear_fullscreen, "brute", 10), 10)

			to_chat(target, span_notice("<big>[uppertext(W)]...</big>"))

			SEND_SOUND(target, sound('sound/effects/singlebeat.ogg'))

			message_admins("[ADMIN_LOOKUPFLW(target)] попытался насрать на ИС словом \"[W]\". ([strip_html(msg)]) [ADMIN_SMITE(target)]")
			return FALSE
	return TRUE
