/datum/emote/living/snort
	key = "snort"
	ru_name = "хрюкать"
	key_third_person = "snorts"
	message = "хрюкает."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snort/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		playsound(get_turf(user), 'white/baldenysh/sounds/snort.ogg', 50, 1)

/datum/emote/living/carbon/human/rsalute
	key = "rsalute"
	ru_name = "салют"
	key_third_person = "salutes"
	message = "выполняет римский салют."
	message_param = "приветствует %t по-римски."
	hands_use_check = TRUE
