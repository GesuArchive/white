/datum/antagonist/dreamer_orbital
	name = "Дример с Л*****ба"
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	show_in_antagpanel = TRUE
	roundend_category = "Orbital Ruin Antags"
	antagpanel_category = "Other"
	var/greet_text = 	"И вот, после долгих скитаний по заброшенным станциям, подходящее место с порталом наконец найдено. \
						Чудом удалось оторваться от прошлой группы охотников, но новая наверняка не заставит себя ждать. \
						Нужно как можно быстрее активировать портал на Лаваленд и убить мою цель. Риск несомненно велик, но награда еще больше!"

/datum/antagonist/dreamer_orbital/proc/forge_objectives()
	var/datum/objective/slay/slay = new
	slay.owner = owner
	slay.reward = 100
	objectives += slay

	var/datum/objective/limited/limit = new
	limit.set_time(2 HOURS)
	limit.owner = owner
	limit.reward = 50
	objectives += limit

/datum/antagonist/dreamer_orbital/on_gain()
	forge_objectives()
	owner.special_role = "Dreamer"
	. = ..()

/datum/antagonist/dreamer_orbital/greet()
	to_chat(owner.current, greet_text)
	antag_memory += greet_text
	. = ..()
