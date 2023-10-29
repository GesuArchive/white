
/*
//////////////////////////////////////
Narcolepsy
	Noticeable.
	Lowers resistance
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.

Bonus
	Causes drowsiness and sleep.

//////////////////////////////////////
*/
/datum/symptom/narcolepsy
	name = "Нарколепсия"
	desc = "Вирус вызывает гормональный дисбаланс, вызывая сонливость и нарколепсию."
	stealth = -1
	resistance = -2
	stage_speed = -3
	transmittable = 0
	level = 6
	symptom_delay_min = 30
	symptom_delay_max = 85
	severity = 4
	var/yawning = FALSE
	threshold_descs = list(
		"Передача 4" = "Заставляет хозяина периодически зевать, распространяя вирус аналогично чиханию.",
		"Скорость 10" = "Чаще вызывает нарколепсию, увеличивая вероятность того, что хозяин заснет.",
	)

/datum/symptom/narcolepsy/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmittable"] >= 4) //yawning (mostly just some copy+pasted code from sneezing, with a few tweaks)
		yawning = TRUE
	if(A.properties["stage_speed"] >= 10) //act more often
		symptom_delay_min = 20
		symptom_delay_max = 45

/datum/symptom/narcolepsy/Activate(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1)
			if(prob(50))
				to_chat(M, span_warning("Надо отдохнуть."))
		if(2)
			if(prob(50))
				to_chat(M, span_warning("Надо подремать."))
		if(3)
			if(prob(50))
				to_chat(M, span_warning("Пытаюсь не заснуть."))
			if(M.drowsyness < 70)
				M.drowsyness += 5
		if(4)
			if(prob(50))
				if(yawning)
					to_chat(M, span_warning("Пытаюсь не зевнуть."))
				else
					to_chat(M, span_warning("Засыпаю на мгновение.")) //you can't really yawn while nodding off, can you?
			if(M.drowsyness < 70)
				M.drowsyness += 10
			if(yawning)
				M.emote("yawn")
				if(M.CanSpreadAirborneDisease())
					A.spread(6)
		if(5)
			if(prob(50))
				to_chat(M, span_warning("[pick("Спать...","Очень хочется спать.","Трудно держать глаза открытыми.","Пытаюсь не заснуть.")]"))
			if(M.drowsyness < 70)
				M.drowsyness += 40
			if(yawning)
				M.emote("yawn")
				if(M.CanSpreadAirborneDisease())
					A.spread(6)
