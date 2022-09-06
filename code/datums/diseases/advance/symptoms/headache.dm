/*
//////////////////////////////////////

Headache

	Noticable.
	Highly resistant.
	Increases stage speed.
	Not transmittable.
	Low Level.

BONUS
	Displays an annoying message!
	Should be used for buffing your disease.

//////////////////////////////////////
*/

/datum/symptom/headache

	name = "Головная боль"
	desc = "Вирус вызывает воспаление внутри мозга, вызывая постоянные головные боли."
	stealth = -1
	resistance = 4
	stage_speed = 2
	transmittable = 0
	level = 1
	severity = 1
	base_message_chance = 100
	symptom_delay_min = 15
	symptom_delay_max = 30
	threshold_descs = list(
		"Скорость 6" = "Головные боли вызывают сильную боль, которая ослабляет хозяина.",
		"Скорость 9" = "Головные боли становятся менее частыми, но гораздо более интенсивными, что не позволяет хозяину выполнять какие-либо действия.",
		"Скрытность 4" = "Уменьшает частоту головной боли до более поздних стадий.",
	)

/datum/symptom/headache/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4)
		base_message_chance = 50
	if(A.properties["stage_rate"] >= 6) //severe pain
		power = 2
	if(A.properties["stage_rate"] >= 9) //cluster headaches
		symptom_delay_min = 30
		symptom_delay_max = 60
		power = 3

/datum/symptom/headache/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(power < 2)
		if(prob(base_message_chance) || A.stage >=4)
			to_chat(M, span_warning("[pick("Голова болит.", "Моя голова разрывается.")]"))
	if(power >= 2 && A.stage >= 4)
		to_chat(M, span_warning("[pick("Моя голова сильно болит.", "Моя голова постоянно разрывается.")]"))
		M.adjustStaminaLoss(25)
	if(power >= 3 && A.stage >= 5)
		to_chat(M, span_userdanger("[pick("Голова болит!", "Чувствую горящий нож в моём мозгу!", "Волна боли заполняет мою голову!")]"))
		M.Stun(35)
