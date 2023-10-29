/mob/var/suiciding = FALSE

/mob/proc/set_suicide(suicide_state)
	suiciding = suicide_state
	if(suicide_state)
		add_to_mob_suicide_list()
	else
		remove_from_mob_suicide_list()

/mob/living/carbon/set_suicide(suicide_state) //you thought that box trick was pretty clever, didn't you? well now hardmode is on, boyo.
	. = ..()
	var/obj/item/organ/brain/B = get_organ_slot(ORGAN_SLOT_BRAIN)
	if(B)
		B.suicided = suicide_state

/mob/living/silicon/robot/set_suicide(suicide_state)
	. = ..()
	if(mmi)
		if(mmi.brain)
			mmi.brain.suicided = suicide_state
		if(mmi.brainmob)
			mmi.brainmob.suiciding = suicide_state

/mob/living/carbon/human/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/oldkey = ckey
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(ckey != oldkey)
		return
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE) //need to be called before calling suicide_act as fuck knows what suicide_act will do with your suicider
		var/obj/item/held_item = get_active_held_item()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				if(damagetype & SHAME)
					adjustStaminaLoss(200)
					set_suicide(FALSE)
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "shameful_suicide", /datum/mood_event/shameful_suicide)
					return

				if(damagetype & MANUAL_SUICIDE_NONLETHAL) //Make sure to call the necessary procs if it does kill later
					set_suicide(FALSE)
					return

				inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")

				suicide_log()

				var/damage_mod = 0
				for(var/T in list(BRUTELOSS, FIRELOSS, TOXLOSS, OXYLOSS))
					damage_mod += (T & damagetype) ? 1 : 0
				damage_mod = max(1, damage_mod)

				//Do 200 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(200/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(200/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(200/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(200/damage_mod)

				if(damagetype & MANUAL_SUICIDE)	//Assume the object will handle the death.
					return

				//If something went wrong, just do normal oxyloss
				if(!(damagetype & (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS) ))
					adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				death(FALSE)
				ghostize(FALSE)	// Disallows reentering body and disassociates mind

				return

		var/suicide_message

		if(a_intent == INTENT_DISARM)
			if(prob(25))
				disarm_suicide()	// Snowflake suicide for a tired joke.
				return	//above proc handles logging and death
			suicide_message = pick("[src] is attempting to push [ru_ego()] own head off [ru_ego()] shoulders! It looks like [p_theyre()] trying to commit suicide.", \
								"[src] is pushing [ru_ego()] thumbs into [ru_ego()] eye sockets! It looks like [p_theyre()] trying to commit suicide.")
		else if(a_intent == INTENT_GRAB)
			suicide_message = pick("[src] is attempting to pull [ru_ego()] own head off! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is aggressively grabbing [ru_ego()] own neck! It looks like [p_theyre()] trying to commit suicide.", \
									"[src] is pulling [ru_ego()] eyes out of their sockets! It looks like [p_theyre()] trying to commit suicide.")
		else if(a_intent == INTENT_HELP)
			var/obj/item/organ/brain/userbrain = getorgan(/obj/item/organ/brain)
			if(userbrain?.damage >= 75)
				suicide_message = "[src] pulls both arms outwards in front of [ru_ego()] chest and pumps them behind [ru_ego()] back, repeats this motion in a smaller range of motion \
						down to [ru_ego()] hips two times once more all while sliding [ru_ego()] legs in a faux walking motion, claps [ru_ego()] hands together \
						in front of [ru_na()] while both [ru_ego()] knees knock together, pumps [ru_ego()] arms downward, pronating [ru_ego()] wrists and abducting \
						[ru_ego()] fingers outward while crossing [ru_ego()] legs back and forth, repeats this motion again two times while keeping [ru_ego()] shoulders low\
						and hunching over, does finger guns with right hand and left hand bent on [ru_ego()] hip while looking directly forward and putting [ru_ego()] left leg forward then\
						crossing [ru_ego()] arms and leaning back a little while bending [ru_ego()] knees at an angle! It looks like [p_theyre()] trying to commit suicide."
			else
				suicide_message = pick("[src] is hugging [ru_na()]self to death! It looks like [p_theyre()] trying to commit suicide.", \
							"[src] is high-fiving [ru_na()]self to death! It looks like [p_theyre()] trying to commit suicide.", \
							"[src] is getting too high on life! It looks like [p_theyre()] trying to commit suicide.")
		else
			suicide_message = pick("[src] is attempting to bite [ru_ego()] tongue off! It looks like [p_theyre()] trying to commit suicide.", \
								"[src] is jamming [ru_ego()] thumbs into [ru_ego()] eye sockets! It looks like [p_theyre()] trying to commit suicide.", \
								"[src] is twisting [ru_ego()] own neck! It looks like [p_theyre()] trying to commit suicide.", \
								"[src] is holding [ru_ego()] breath! It looks like [p_theyre()] trying to commit suicide.")

		visible_message(span_danger("[suicide_message]") , span_userdanger("[suicide_message]"))

		suicide_log()

		adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/brain/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(!canSuicide())
		return
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		set_suicide(TRUE)
		visible_message(span_danger("Мозг [capitalize(src.name)] начинает размякать и расслабляться. Похоже, что [ru_who(TRUE)] потерял желание жить.") , \
						span_userdanger("Мозг [capitalize(src.name)] начинает размякать и расслабляться. Похоже, что [ru_who(TRUE)] потерял желание жить.."))

		suicide_log()

		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/silicon/ai/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(!canSuicide())
		return
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		set_suicide(TRUE)
		visible_message(span_danger("[capitalize(src.name)] отключается. Похоже, что [p_theyre()] пытается покончить с собой.") , \
				span_userdanger("[capitalize(src.name)] отключается. Похоже, что [p_theyre()] пытается покончить с собой."))

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/silicon/robot/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(!canSuicide())
		return
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		set_suicide(TRUE)
		visible_message(span_danger("[capitalize(src.name)] отключается. Похоже, что [p_theyre()] пытается покончить с собой.") , \
				span_userdanger("[capitalize(src.name)] отключается. Похоже, что [p_theyre()] пытается покончить с собой."))

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/silicon/pai/verb/suicide()
	set hidden = TRUE
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		var/turf/T = get_turf(src.loc)
		T.visible_message(span_notice("[capitalize(src.name)] высвечивает сообщение на весь экран: \"Удаление файлов ядра личности. Пожалуйста, загрузите новую личность чтобы продолжить использовать персональный ИИ.\"") , null, \
			span_notice("[capitalize(src.name)] бипает."))

		suicide_log()

		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind
	else
		to_chat(src, "Отмена попытки самоубийства.")

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(!canSuicide())
		return
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		set_suicide(TRUE)
		visible_message(span_danger("[capitalize(src.name)] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.") , \
				span_userdanger("[capitalize(src.name)] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.") , \
				span_hear("You hear thrashing."))

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(200 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/simple_animal/verb/suicide()
	set hidden = TRUE
	if(!canSuicide())
		return
	var/confirm = tgui_alert(usr,"Are you sure you want to commit suicide?", "Confirm Suicide", list("Yes", "No"))
	if(!canSuicide())
		return
	if(confirm == "Yes")
		inc_metabalance(src, METACOIN_SUICIDE_REWARD, reason="За всё нужно платить.")
		set_suicide(TRUE)
		visible_message(span_danger("[capitalize(src.name)] начинает падать. Похоже, что [p_theyve()] потерял желание жить.") , \
						span_userdanger("[capitalize(src.name)] начинает падать. Похоже, что [p_theyve()] потерял желание жить."))

		suicide_log()

		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind

/mob/living/proc/suicide_log()
	log_message("committed suicide as [src.type]", LOG_ATTACK)

/mob/living/carbon/human/suicide_log()
	log_message("(job: [src.job ? "[src.job]" : "None"]) committed suicide", LOG_ATTACK)

/mob/living/proc/canSuicide()
	var/area/A = get_area(src)
	if(A.area_flags & BLOCK_SUICIDE)
		to_chat(src, span_warning("Нельзя убить себя здесь! Если хочется, то можно стать призраком."))
		return
	switch(stat)
		if(CONSCIOUS)
			return TRUE
		if(SOFT_CRIT)
			to_chat(src, span_warning("Нельзя убить себя, находясь в критическом состоянии!"))
		if(UNCONSCIOUS, HARD_CRIT)
			to_chat(src, span_warning("Нужно быть в сознании, чтобы убить себя!"))
		if(DEAD)
			to_chat(src, span_warning("Ты уже мёртв!"))
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!(mobility_flags & MOBILITY_USE))	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		to_chat(src, span_warning("Говорят, что большая часть суицидов происходит под диким давлением. Да?"))
		return
	return TRUE
