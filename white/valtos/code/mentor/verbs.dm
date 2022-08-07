/client/proc/add_mentor_verbs()
	if(mentor_datum)
		add_verb(src, GLOB.mentor_verbs)

/client/proc/remove_mentor_verbs()
	remove_verb(src, GLOB.mentor_verbs)

/client/verb/mrat()
	set name = "Запросить Присутствие"
	set category = "Адм"

	if(!istype(src.mob, /mob/living/carbon/human))
		to_chat(src, "<span class='notice'>Нужно быть человеком для этого!</span>")
		return

	var/mob/living/carbon/human/M = src.mob

	if(M.stat == DEAD)
		to_chat(src, "<span class='notice'>Надо бы ожить для этого!</span>")
		return

	if(M.has_trauma_type(/datum/brain_trauma/special/imaginary_friend/mrat))
		to_chat(src, "<span class='notice'>Тульпа уже в пути!</span>")
		return

	var/alertresult = tgui_alert(M, "Это призовёт маленького помощника, которого никто не видит кроме ТЕБЯ. Продолжить?", "ЗНАТОК", list("Да", "Нет"))
	if(alertresult == "Нет" || QDELETED(M) || !istype(M) || !M.key)
		return

	M.gain_trauma(/datum/brain_trauma/special/imaginary_friend/mrat)
