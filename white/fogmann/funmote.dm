/datum/emote/living/fart
	key = "fart"
	ru_name = "пёрнуть"
	key_third_person = "пердит"
	message = "пердит."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/fart/run_emote(mob/user, params)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		message = "жёстко пердит!"
		if(user.key == "Brony_uraj")
			playsound(H, 'white/valtos/sounds/emotes/fart_uraj.ogg', 50, 1)
			for(var/obj/structure/window/W in range(1))
				W.take_damage(25)
			return
		else if(user.key == "Deadman1740")
			to_chat(user, span_red("<b>BACKDOOR INSIDE PIDORI OUTSIDE</b>"))
			playsound(H, 'white/fogmann/vamban.ogg')
			qdel(H)
			return
		else
			playsound(H, pick('white/valtos/sounds/emotes/fart_1.ogg',\
							'white/valtos/sounds/emotes/fart_2.ogg',\
							'white/valtos/sounds/emotes/fart_3.ogg',\
							'white/valtos/sounds/emotes/fart_4.ogg',\
							'white/valtos/sounds/emotes/fart_5.ogg',\
							'white/valtos/sounds/emotes/fart_6.ogg',\
							'white/valtos/sounds/emotes/fart_7.ogg',\
							'white/valtos/sounds/emotes/fart_8.ogg',\
							'white/valtos/sounds/emotes/fart_9.ogg'), 50, 1)
