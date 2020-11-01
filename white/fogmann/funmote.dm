/datum/emote/living/fart
	key = "fart"
	key_third_person = "пердит"
	message = "пердит"
	emote_type = EMOTE_AUDIBLE



/datum/emote/living/fart/run_emote(mob/user, params)
	. = ..()
	if(!user.CanFart)
	else
		if(. && ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.dna.species.id == "human")
				message = "жёстко пердит!"
				//H.ex_act(EXPLODE_LIGHT) //нет
				if(user.key == "Brony_uraj")
					playsound(H, 'white/fogmann/fart.ogg', 50, 1)
					for(var/obj/structure/window/W in range(1))
						W.take_damage(25)
				if(user.key == "Deadman1740")
					to_chat(user, "<font color='red'><b>BACKDOOR INSIDE PIDORI OUTSIDE</b></font>")
					playsound(H, 'white/fogmann/vamban.ogg')
					qdel(H)
				else
					playsound(H, 'white/fogmann/fart.ogg', 50, 1)
		user.CanFart = 0; spawn(600) user.CanFart = 1

/mob
	var/CanFart = 1
