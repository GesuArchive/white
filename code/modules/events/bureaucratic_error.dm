/datum/round_event_control/bureaucratic_error
	name = "Bureaucratic Error"
	typepath = /datum/round_event/bureaucratic_error
	max_occurrences = 1
	weight = 5

/datum/round_event/bureaucratic_error
	announceWhen = 1

/datum/round_event/bureaucratic_error/announce(fake)
	priority_announce("Недавняя бюрократическая ошибка в Департаменте Органических Ресурсов может привести к кадровой нехватке в одних департаментах и избыточному укомплектованию штатов в других.", "Бюрократическая тревога")

/datum/round_event/bureaucratic_error/start()
	SSjob.set_overflow_role(pick(get_all_jobs()))
