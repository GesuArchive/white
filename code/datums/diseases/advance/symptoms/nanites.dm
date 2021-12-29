/datum/symptom/nano_boost
	name = "Наносимбиоз"
	desc = "Вирус реагирует на наниты в кровотоке хозяина, усиливая цикл их репликации."
	stealth = 0
	resistance = 2
	stage_speed = 2
	transmittable = -1
	level = 7
	severity = 0
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/reverse_boost = FALSE
	threshold_descs = list(
		"Передача 5" = "Увеличивает скорость роста вируса при наличии нанитов.",
		"Скорость 7" = "Увеличивает ускорение репликации."
	)

/datum/symptom/nano_boost/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmittable"] >= 5) //reverse boost
		reverse_boost = TRUE
	if(A.properties["stage_rate"] >= 7) //more nanites
		power = 2

/datum/symptom/nano_boost/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, 0.5 * power)
	if(reverse_boost && SEND_SIGNAL(M, COMSIG_HAS_NANITES))
		if(prob(A.stage_prob))
			A.stage = min(A.stage + 1,A.max_stages)

/datum/symptom/nano_destroy
	name = "Силиколиз"
	desc = "Вирус реагирует на наниты в кровотоке хозяина, атакуя и потребляя их."
	stealth = 0
	resistance = 4
	stage_speed = -1
	transmittable = 1
	level = 7
	severity = 0
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/reverse_boost = FALSE
	threshold_descs = list(
		"Скорость 5" = "Увеличивает скорость роста вируса при наличии нанитов.",
		"Сопротивление 7" = "Сильно увеличивает скорость разрушения нанитов."
	)

/datum/symptom/nano_destroy/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 5) //reverse boost
		reverse_boost = TRUE
	if(A.properties["resistance"] >= 7) //more nanites
		power = 3

/datum/symptom/nano_destroy/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, -0.4 * power)
	if(reverse_boost && SEND_SIGNAL(M, COMSIG_HAS_NANITES))
		if(prob(A.stage_prob))
			A.stage = min(A.stage + 1,A.max_stages)
