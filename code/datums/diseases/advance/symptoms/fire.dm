/*
//////////////////////////////////////

Spontaneous Combustion

	Slightly hidden.
	Lowers resistance tremendously.
	Decreases stage tremendously.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	Ignites infected mob.

//////////////////////////////////////
*/

/datum/symptom/fire

	name = "Случайное возгорание"
	desc = "Вирус превращает жир в чрезвычайно легковоспламеняющееся соединение и повышает температуру тела, в результате чего хозяин самопроизвольно загорается."
	stealth = -1
	resistance = -4
	stage_speed = -3
	transmittable = -4
	level = 6
	severity = 5
	base_message_chance = 20
	symptom_delay_min = 20
	symptom_delay_max = 75
	var/infective = FALSE
	threshold_descs = list(
		"Скорость 4" = "Увеличивает интенсивность пламени.",
		"Скорость 8" = "Еще больше увеличивает интенсивность пламени.",
		"Передача 8" = "Хозяин будет распространять вирус через чешуйки кожи, когда вспыхивает.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным..",
	)

/datum/symptom/fire/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 4)
		power = 1.5
	if(A.properties["stage_rate"] >= 8)
		power = 2
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE
	if(A.properties["transmittable"] >= 8) //burning skin spreads the virus through smoke
		infective = TRUE

/datum/symptom/fire/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(3)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("Жарко.", "Что-то щёлкает.", "Пахнет дымом.")]"))
		if(4)
			Firestacks_stage_4(M, A)
			M.IgniteMob()
			to_chat(M, span_userdanger("КОЖА ГОРИТ!"))
			M.emote("agony")
		if(5)
			Firestacks_stage_5(M, A)
			M.IgniteMob()
			to_chat(M, span_userdanger("Моя кожа буквально пылает!"))
			M.emote("agony")

/datum/symptom/fire/proc/Firestacks_stage_4(mob/living/M, datum/disease/advance/A)
	M.adjust_fire_stacks(1 * power)
	M.take_overall_damage(burn = 3 * power, required_status = BODYPART_ORGANIC)
	if(infective)
		A.spread(2)
	return 1

/datum/symptom/fire/proc/Firestacks_stage_5(mob/living/M, datum/disease/advance/A)
	M.adjust_fire_stacks(3 * power)
	M.take_overall_damage(burn = 5 * power, required_status = BODYPART_ORGANIC)
	if(infective)
		A.spread(4)
	return 1

/*
//////////////////////////////////////

Alkali perspiration

	Hidden.
	Lowers resistance.
	Decreases stage speed.
	Decreases transmittablity.
	Fatal Level.

Bonus
	Ignites infected mob.
	Explodes mob on contact with water.

//////////////////////////////////////
*/

/datum/symptom/alkali

	name = "Щелочной пот"
	desc = "Вирус прикрепляется к потовым железам, синтезируя химическое вещество, которое загорается при реакции с водой, что приводит к самосожжению."
	stealth = 2
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 7
	severity = 6
	base_message_chance = 100
	symptom_delay_min = 30
	symptom_delay_max = 90
	var/chems = FALSE
	var/explosion_power = 1
	threshold_descs = list(
		"Сопротивление 9" = "Удваивает интенсивность эффекта жертвоприношения, но снижает частоту всех эффектов этого симптома.",
		"Скорость 8" = "Увеличивает радиус взрыва и урон от взрыва хозяину, когда он мокрый.",
		"Передача 8" = "Дополнительно внутри хозяина синтезирует трифторид хлора и напалм. Если достигнут порог устойчивости 9, синтезируется больше химикатов."
	)

/datum/symptom/alkali/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 9) //intense but sporadic effect
		power = 2
		symptom_delay_min = 50
		symptom_delay_max = 140
	if(A.properties["stage_rate"] >= 8) //serious boom when wet
		explosion_power = 2
	if(A.properties["transmittable"] >= 8) //extra chemicals
		chems = TRUE

/datum/symptom/alkali/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(3)
			if(prob(base_message_chance))
				to_chat(M, span_warning("[pick("Вены кипят.", "Жарко.", "Кто-то готовит мясо.")]"))
		if(4)
			if(M.fire_stacks < 0)
				M.visible_message(span_warning("Потная кожа [M] шипит и трескается при контакте с водой!"))
				explosion(get_turf(M),-1,(-1 + explosion_power),(2 * explosion_power))
			Alkali_fire_stage_4(M, A)
			M.IgniteMob()
			to_chat(M, span_userdanger("Ваш пот загорается!"))
			M.emote("agony")
		if(5)
			if(M.fire_stacks < 0)
				M.visible_message(span_warning("Потная кожа [M] шипит и трескается при контакте с водой!"))
				explosion(get_turf(M),-1,(-1 + explosion_power),(2 * explosion_power))
			Alkali_fire_stage_5(M, A)
			M.IgniteMob()
			to_chat(M, span_userdanger("Моя кожа буквально пылает!"))
			M.emote("agony")

/datum/symptom/alkali/proc/Alkali_fire_stage_4(mob/living/M, datum/disease/advance/A)
	var/get_stacks = 6 * power
	M.adjust_fire_stacks(get_stacks)
	M.take_overall_damage(burn = get_stacks / 2, required_status = BODYPART_ORGANIC)
	if(chems)
		M.reagents.add_reagent(/datum/reagent/clf3, 2 * power)
	return 1

/datum/symptom/alkali/proc/Alkali_fire_stage_5(mob/living/M, datum/disease/advance/A)
	var/get_stacks = 8 * power
	M.adjust_fire_stacks(get_stacks)
	M.take_overall_damage(burn = get_stacks, required_status = BODYPART_ORGANIC)
	if(chems)
		M.reagents.add_reagent_list(list(/datum/reagent/napalm = 4 * power, /datum/reagent/clf3 = 4 * power))
	return 1
