/datum/action/changeling/fakedeath
	name = "Восстанавливающий стазис"
	desc = "Мы падаем в стазис, позволяя нам возродиться и обмануть наших врагов. Стоит 15 химикатов."
	button_icon_state = "fake_death"
	chemical_cost = 15
	dna_cost = 0
	req_dna = 1
	req_stat = DEAD
	ignores_fakedeath = TRUE
	var/revive_ready = FALSE

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/datum/action/changeling/fakedeath/sting_action(mob/living/user)
	..()
	if(revive_ready)
		INVOKE_ASYNC(src, .proc/revive, user)
		revive_ready = FALSE
		name = "Восстанавливающий стазис"
		desc = "Мы падаем в стазис, позволяя нам возродиться и обмануть наших врагов."
		button_icon_state = "fake_death"
		UpdateButtonIcon()
		chemical_cost = 15
		to_chat(user, span_notice("Мы оживили себя."))
	else
		to_chat(user, span_notice("Мы начинаем наш стазис, готовя энергию, чтобы возродиться еще раз."))
		user.fakedeath("changeling") //play dead
		addtimer(CALLBACK(src, .proc/ready_to_regenerate, user), LING_FAKEDEATH_TIME, TIMER_UNIQUE)
	return TRUE

/datum/action/changeling/fakedeath/proc/revive(mob/living/user)
	if(!user || !istype(user))
		return
	user.cure_fakedeath("changeling")
	user.revive(full_heal = TRUE, admin_revive = FALSE)
	var/list/missing = user.get_missing_limbs()
	missing -= BODY_ZONE_HEAD // headless changelings are funny
	if(missing.len)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
		user.visible_message(span_warning("Конечности <b>[user]</b> внезапно отрастают, издавая громкие хрустящие звуки!") , span_userdanger("Наши конечности вырастают, издают громкий хрустящий звук и причиняют нам сильную боль!") , span_hear("Слышу, как что-то органическое разрывается!"))
		user.emote("agony")
		user.regenerate_limbs(0, list(BODY_ZONE_HEAD))
	user.regenerate_organs()

/datum/action/changeling/fakedeath/proc/ready_to_regenerate(mob/user)
	if(user?.mind)
		var/datum/antagonist/changeling/C = user.mind.has_antag_datum(/datum/antagonist/changeling)
		if(C?.purchasedpowers)
			to_chat(user, span_notice("Мы готовы возродиться."))
			name = "Возрождение"
			desc = "Мы восстанем ещё раз."
			button_icon_state = "revive"
			UpdateButtonIcon()
			chemical_cost = 0
			revive_ready = TRUE

/datum/action/changeling/fakedeath/can_sting(mob/living/user)
	if(HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, "changeling") && !revive_ready)
		to_chat(user, span_warning("Мы уже восстанавливаемся."))
		return
	if(!user.stat && !revive_ready) //Confirmation for living changelings if they want to fake their death
		switch(tgui_alert("Хотим ли мы устроить иммитацию нашей смерти?",,list("Да", "Нет")))
			if("Нет")
				return
	return ..()
