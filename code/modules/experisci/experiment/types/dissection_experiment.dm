/datum/experiment/dissection
	name = "Эксперимент по вскрытию"
	description = "Эксперимент по патологоанатомическому вскрытию мертвого тела."
	exp_tag = "Вскрытие"
	performance_hint = "Выполните операцию вскрытия на операционном столе с подключенным операционным компьютером."

/datum/experiment/dissection/is_complete()
	return completed

/datum/experiment/dissection/perform_experiment_actions(datum/component/experiment_handler/experiment_handler, mob/target)
	if (is_valid_dissection(target))
		completed = TRUE
		return TRUE
	else
		return FALSE

/datum/experiment/dissection/proc/is_valid_dissection(mob/target)
	return TRUE

/datum/experiment/dissection/human
	name = "Эксперимент по вскрытию человека"
	description = "Патологоанатомическое вскрытие - это основа основ хирургического вмешательства, к которой вы всегда будете возвращаться в попытках понять где же была допущена ошибка при лечении или диагностике."

/datum/experiment/dissection/human/is_valid_dissection(mob/target)
	return ishumanbasic(target)

/datum/experiment/dissection/nonhuman
	name = "Эксперимент по вскрытию не человека"
	description = "Нет предела человеческому любопытству. Вы уже досконально знаете как устроен человек, но вам всегда было интересно как устроены другие виды? Например обезьяны?"

/datum/experiment/dissection/nonhuman/is_valid_dissection(mob/target)
	return ishuman(target) && !ishumanbasic(target)

/datum/experiment/dissection/xenomorph
	name = "Эксперимент по вскрытию ксеноморфа"
	description = "Проведя сотни часов за операционным столом вы можете однозначно констатировать - биология и природа цикличны и даже во всем своем многообразии они придерживаются строгой системы. Но что если пред вами порождение чуждой природы?"

/datum/experiment/dissection/xenomorph/is_valid_dissection(mob/target)
	return isalien(target)
