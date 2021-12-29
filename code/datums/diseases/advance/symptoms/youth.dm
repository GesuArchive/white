/*
//////////////////////////////////////
Eternal Youth

	Moderate stealth boost.
	Increases resistance tremendously.
	Increases stage speed tremendously.
	Reduces transmission tremendously.
	Critical Level.

BONUS
	Gives you immortality and eternal youth!!!
	Can be used to buff your virus

//////////////////////////////////////
*/

/datum/symptom/youth

	name = "Вечная молодость"
	desc = "Вирус становится симбиотически связанным с клетками тела хозяина, предотвращая и обращая вспять старение. Вирус, в свою очередь, становится более устойчивым, быстрее распространяется и его труднее обнаружить, хотя без хозяина он не процветает."
	stealth = 3
	resistance = 4
	stage_speed = 4
	transmittable = -4
	level = 5
	base_message_chance = 100
	symptom_delay_min = 25
	symptom_delay_max = 50

/datum/symptom/youth/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(A.stage)
			if(1)
				if(H.age > 41)
					H.age = 41
					to_chat(H, span_notice("У меня не было столько энергии годами!"))
			if(2)
				if(H.age > 36)
					H.age = 36
					to_chat(H, span_notice("Моё настроение повысилось."))
			if(3)
				if(H.age > 31)
					H.age = 31
					to_chat(H, span_notice("Я более гибкий."))
			if(4)
				if(H.age > 26)
					H.age = 26
					to_chat(H, span_notice("Ощущаю воодушевление."))
			if(5)
				if(H.age > 21)
					H.age = 21
					to_chat(H, span_notice("Пора захватывать мир!"))
