/datum/action/changeling/linglink
	name = "Привязка к рою"
	desc = "Мы связываем ум нашей жертвы с роем для личного допроса."
	helptext = "Если мы найдем человека достаточно безумным, чтобы поддержать наше дело, это может быть полезным инструментом, чтобы оставаться на связи."
	button_icon_state = "hivemind_link"
	chemical_cost = 0
	dna_cost = 0
	req_human = 1

/datum/action/changeling/linglink/can_sting(mob/living/carbon/user)
	if(!..())
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling.islinking)
		to_chat(user, span_warning("Мы уже сформировали связь с жертвой!"))
		return
	if(!user.pulling)
		to_chat(user, span_warning("Мы должны крепко схватить существо, чтобы связаться с ними!"))
		return
	if(!iscarbon(user.pulling))
		to_chat(user, span_warning("Мы не можем связаться с этим существом!"))
		return
	var/mob/living/carbon/target = user.pulling

	if(!target.mind)
		to_chat(user, span_warning("У жертвы отсутствует разум!"))
		return
	if(target.stat == DEAD)
		to_chat(user, span_warning("Жертва мертва, мы не можем связаться с мертвым разумом!"))
		return
	if(target.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, span_warning("Жертва уже является частью роя!"))
		return
	if(user.grab_state <= GRAB_AGGRESSIVE)
		to_chat(user, span_warning("Мы должны держать это существо крепче!"))
		return
	return changeling.can_absorb_dna(target)

/datum/action/changeling/linglink/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/mob/living/carbon/human/target = user.pulling
	changeling.islinking = 1
	for(var/i in 1 to 3)
		if(do_after_mob(user, target, 2 SECONDS))
			switch(i)
				if(1)
					to_chat(user, span_notice("Существо подходит. Нам нужно не двигаться..."))
				if(2)
					to_chat(user, span_notice("Мы незаметно протыкаем <b>[target]</b> нашим малым хоботком..."))
					to_chat(target, span_userdanger("Испытваю какое-то острое ощущение и в ушах начинает звенеть..."))
				if(3)
					to_chat(user, span_notice("Мы формируем разум <b>[target]</b>, давая жертве способность общаться с роем!"))
					to_chat(target, span_userdanger("Мигрень пульсирует перед глазами, слышу, как я кричу, но рот мой закрыт!"))
					for(var/mi in GLOB.mob_list)
						var/mob/M = mi
						if(M.lingcheck() == LINGHIVE_LING)
							to_chat(M, span_changeling("Мы ощущаем чужое присутствие в рое..."))
					target.mind.linglink = 1
					target.say("[MODE_TOKEN_CHANGELING] Н-Е-Е-Е-Е-Т!")
					to_chat(target, "<span class='changeling bold'>Теперь ты можешь общаться с генокрадами, используй \"[MODE_TOKEN_CHANGELING] сообщение\" для связи!</span>")
			SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]", "[i]"))
		else
			to_chat(user, span_notice("Мы не можем больше поддерживать связь, наша жертва исчезает из роя!"))
			to_chat(target, span_userdanger("Связь больше не поддерживается, моё соединение с роем разорвано!"))
			i = 1



	changeling.islinking = 0
