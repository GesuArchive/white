/datum/emote/living/snort
	key = "snort"
	key_third_person = "snorts"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snort/run_emote(mob/user, params)
	. = ..()
	playsound(H, 'code/shitcode/baldenysh/sounds/snort.ogg', 50, 1)
