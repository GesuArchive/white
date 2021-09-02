/datum/action/changeling/fleshmend
	name = "Заживление плоти"
	desc = "Наша плоть быстро восстанавливается, излечивая наши ожоги, ушибы и одышку. Стоит 20 химикатов."
	helptext = "Если мы в огне, лечебный эффект не сработает. Не отращивает конечности и не восстанавливает потерянную кровь. Работает пока мы без сознания."
	button_icon_state = "fleshmend"
	chemical_cost = 20
	dna_cost = 2
	req_stat = HARD_CRIT

//Starts healing you every second for 10 seconds.
//Can be used whilst unconscious.
/datum/action/changeling/fleshmend/sting_action(mob/living/user)
	if(user.has_status_effect(STATUS_EFFECT_FLESHMEND))
		to_chat(user, span_warning("Мы уже заживляем нашу плоть!"))
		return
	..()
	to_chat(user, span_notice("Мы начинаем быстро лечиться."))
	user.apply_status_effect(STATUS_EFFECT_FLESHMEND)
	return TRUE

//Check buffs.dm for the fleshmend status effect code
