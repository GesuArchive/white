/*
//////////////////////////////////////

Hallucigen

	Very noticable.
	Lowers resistance considerably.
	Decreases stage speed.
	Reduced transmittable.
	Critical Level.

Bonus
	Makes the affected mob be hallucinated for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/hallucigen
	name = "Галлюциген"
	desc = "Вирус стимулирует мозг, время от времени вызывая галлюцинации."
	stealth = -1
	resistance = -3
	stage_speed = -3
	transmittable = -1
	level = 5
	severity = 2
	base_message_chance = 25
	symptom_delay_min = 25
	symptom_delay_max = 90
	var/fake_healthy = FALSE
	threshold_descs = list(
		"Скорость 7" = "Увеличивает количество галлюцинаций.",
		"Скрытность 4" = "Вирус имитирует положительные симптомы.",
	)

/datum/symptom/hallucigen/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4) //fake good symptom messages
		fake_healthy = TRUE
		base_message_chance = 50
	if(A.properties["stage_rate"] >= 7) //stronger hallucinations
		power = 2

/datum/symptom/hallucigen/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	var/list/healthy_messages = list("Лёгким стало лучше.", "Можно не дышать.", "Я могу и не дышать вовсе.",\
					"Глазам стало лучше.", "Ушам стало лучше.", "Можно не моргать.")
	switch(A.stage)
		if(1, 2)
			if(prob(base_message_chance))
				if(!fake_healthy)
					to_chat(M, span_notice("[pick("Что-то появляется в периферийном зрении, а затем гаснет.", "Кто-то что-то шепчет.", "Голова болит.")]"))
				else
					to_chat(M, span_notice("[pick(healthy_messages)]"))
		if(3, 4)
			if(prob(base_message_chance))
				if(!fake_healthy)
					to_chat(M, span_danger("[pick("Кто-то идёт за мной.", "Кто-то смотрит на меня.", "Кто-то шепчет мне что-то на ухо.", "Кто-то идёт по моим пятам.")]"))
				else
					to_chat(M, span_notice("[pick(healthy_messages)]"))
		else
			if(prob(base_message_chance))
				if(!fake_healthy)
					to_chat(M, span_userdanger("[pick("Ох, голова...", "Моя голова разрывается.", "ОНИ ПОВСЮДУ! Бежим!", "Что-то затаилось в тенях...")]"))
				else
					to_chat(M, span_notice("[pick(healthy_messages)]"))
			M.hallucination += (45 * power)
