/datum/antagonist/dreamer_orbital
	name = "Дример с Л*****ба"
	show_in_antagpanel = TRUE
	roundend_category = "Orbital Ruin Antags"
	antagpanel_category = "Other"

/datum/antagonist/dreamer_orbital/proc/forge_objectives()
	var/datum/objective/slay/slay = new
	slay.owner = owner
	slay.reward = 150
	objectives += slay

	var/datum/objective/limited/limit = new
	limit.set_time(2 HOURS)
	limit.owner = owner
	limit.reward = 20
	objectives += limit

/datum/antagonist/dreamer_orbital/on_gain()
	forge_objectives()
	owner.special_role = "Dreamer"
	. = ..()

/datum/antagonist/dreamer_orbital/greet()
	to_chat(owner, "<span class='boldannounce'>И вот, после долгих скитаний по заброшенным станциям, ты наконец прибываешь на подходящее место. \
				Тебе удалось оторваться от прошлой группы охотников, но новая наверняка не заставит себя ждать. \
				Нужно как можно быстрее активировать портал на Лаваленд и убить тварь!</span>")
	owner.announce_objectives()
