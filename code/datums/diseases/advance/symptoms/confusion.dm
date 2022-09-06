/*
//////////////////////////////////////

Confusion

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Not very transmissibile.
	Intense Level.

Bonus
	Makes the affected mob be confused for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/confusion
	name = "Спутанность сознания"
	desc = "Вирус нарушает нормальное функционирование нервной системы, вызывая приступы замешательства и беспорядочные движения."
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmittable = 0
	level = 4
	severity = 2
	base_message_chance = 25
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/brain_damage = FALSE
	threshold_descs = list(
		"Сопротивление 6" = "Со временем вызывает повреждение мозга.",
		"Передача 6" = "Увеличивает продолжительность и силу замешательства.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным..",
	)

/datum/symptom/confusion/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 6)
		brain_damage = TRUE
	if(A.properties["transmittable"] >= 6)
		power = 1.5
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE

/datum/symptom/confusion/End(datum/disease/advance/A)
	A.affected_mob.set_confusion(0)
	return ..()

/datum/symptom/confusion/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("Голова болит.", "Разум на мгновение остался пустым.")]"))
		else
			to_chat(M, span_userdanger("Не могу думать!"))
			M.add_confusion(16 * power)
			if(brain_damage)
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * power, 80)
				M.updatehealth()

	return
