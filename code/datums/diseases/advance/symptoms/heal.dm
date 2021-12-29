/datum/symptom/heal
	name = "Лечение (ничего не делает)" //warning for adminspawn viruses
	desc = "Мудила."
	stealth = 0
	resistance = 0
	stage_speed = 0
	transmittable = 0
	level = 0 //not obtainable
	base_message_chance = 20 //here used for the overlays
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/passive_message = "" //random message to infected but not actively healing people
	threshold_descs = list(
		"Скорость 6" = "Удваивает скорость исцеления.",
		"Скрытность 4" = "Исцеление больше не будет видно посторонним.",
	)

/datum/symptom/heal/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 6) //stronger healing
		power = 2

/datum/symptom/heal/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			var/effectiveness = CanHeal(A)
			if(!effectiveness)
				if(passive_message && prob(2) && passive_message_condition(M))
					to_chat(M, passive_message)
				return
			else
				Heal(M, A, effectiveness)
	return

/datum/symptom/heal/proc/CanHeal(datum/disease/advance/A)
	return power

/datum/symptom/heal/proc/Heal(mob/living/M, datum/disease/advance/A, actual_power)
	return TRUE

/datum/symptom/heal/proc/passive_message_condition(mob/living/M)
	return TRUE


/datum/symptom/heal/starlight
	name = "Конденсация звездного света"
	desc = "Вирус реагирует на прямой звездный свет, производя регенеративные химические вещества. Лучше всего работает против повреждений, вызванных токсинами."
	stealth = -1
	resistance = -2
	stage_speed = 0
	transmittable = 1
	level = 6
	passive_message = span_notice("Скучаю по ощущению звездного света на коже.")
	var/nearspace_penalty = 0.3
	threshold_descs = list(
		"Скорость 6" = "Увеличивает скорость исцеления.",
		"Передача 6" = "Снимает штраф только за нахождение рядом с космосом.",
	)

/datum/symptom/heal/starlight/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmittable"] >= 6)
		nearspace_penalty = 1
	if(A.properties["stage_rate"] >= 6)
		power = 2

/datum/symptom/heal/starlight/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	if(istype(get_turf(M), /turf/open/space))
		return power
	else
		for(var/turf/T in view(M, 2))
			if(istype(T, /turf/open/space))
				return power * nearspace_penalty

/datum/symptom/heal/starlight/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = actual_power
	if(M.getToxLoss() && prob(5))
		to_chat(M, span_notice("Кожа колется, поскольку звездный свет, кажется, исцеляет меня."))

	M.adjustToxLoss(-(4 * heal_amt)) //most effective on toxins

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()
	return 1

/datum/symptom/heal/starlight/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss() || M.getToxLoss())
		return TRUE
	return FALSE

/datum/symptom/heal/chem
	name = "Токсолиз"
	stealth = 0
	resistance = -2
	stage_speed = 2
	transmittable = -2
	level = 7
	var/food_conversion = FALSE
	desc = "Вирус быстро разрушает любые посторонние химические вещества в кровотоке."
	threshold_descs = list(
		"Сопротивление 7" = "Увеличивает скорость удаления химикатов.",
		"Скорость 6" = "Потребляемые химические вещества питают хозяина.",
	)

/datum/symptom/heal/chem/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 6)
		food_conversion = TRUE
	if(A.properties["resistance"] >= 7)
		power = 2

/datum/symptom/heal/chem/Heal(mob/living/M, datum/disease/advance/A, actual_power)
	for(var/datum/reagent/R in M.reagents.reagent_list) //Not just toxins!
		M.reagents.remove_reagent(R.type, actual_power)
		if(food_conversion)
			M.adjust_nutrition(0.3)
		if(prob(2))
			to_chat(M, span_notice("Кровь очищается, ощущаю при этом легкое тепло."))
	return 1



/datum/symptom/heal/metabolism
	name = "Метаболический импульс"
	stealth = -1
	resistance = -2
	stage_speed = 2
	transmittable = 1
	level = 7
	var/triple_metabolism = FALSE
	var/reduced_hunger = FALSE
	desc = "Вирус заставляет метаболизм хозяина быстро ускоряться, заставляя его обрабатывать химические вещества в два раза быстрее, но также вызывает усиление голода."
	threshold_descs = list(
		"Скрытность 3" = "Снижает уровень голода.",
		"Скорость 10" = "Химический метаболизм увеличивается втрое, а не вдвое.",
	)

/datum/symptom/heal/metabolism/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 10)
		triple_metabolism = TRUE
	if(A.properties["stealth"] >= 3)
		reduced_hunger = TRUE

/datum/symptom/heal/metabolism/Heal(mob/living/carbon/C, datum/disease/advance/A, actual_power)
	if(!istype(C))
		return
	var/metabolic_boost = triple_metabolism ? 2 : 1
	C.reagents.metabolize(C, metabolic_boost * SSMOBS_DT, 0, can_overdose=TRUE) //this works even without a liver; it's intentional since the virus is metabolizing by itself
	C.overeatduration = max(C.overeatduration - 4 SECONDS, 0)
	var/lost_nutrition = 9 - (reduced_hunger * 5)
	C.adjust_nutrition(-lost_nutrition * HUNGER_FACTOR) //Hunger depletes at 10x the normal speed
	if(prob(2))
		to_chat(C, span_notice("Чувствуете странное бульканье в животе, как будто оно работает намного быстрее, чем обычно."))
	return 1

/datum/symptom/heal/darkness
	name = "Ночная регенерация"
	desc = "Вирус способен лечить плоть хозяина в условиях низкой освещенности, устраняя физические повреждения. Более эффективен против грубого урона."
	stealth = 2
	resistance = -1
	stage_speed = -2
	transmittable = -1
	level = 6
	passive_message = span_notice("Чувствую покалывание на коже при прохождении через нее света.")
	threshold_descs = list(
		"Скорость 8" = "Удваивает скорость исцеления.",
	)

/datum/symptom/heal/darkness/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 8)
		power = 2

/datum/symptom/heal/darkness/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	var/light_amount = 0
	if(isturf(M.loc)) //else, there's considered to be no light
		var/turf/T = M.loc
		light_amount = min(1,T.get_lumcount()) - 0.5
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			return power

/datum/symptom/heal/darkness/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = 2 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	if(prob(5))
		to_chat(M, span_notice("Тьма успокаивает и лечит раны."))

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len * 0.5, null, BODYPART_ORGANIC)) //more effective on brute
			M.update_damage_overlays()
	return 1

/datum/symptom/heal/darkness/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss())
		return TRUE
	return FALSE

/datum/symptom/heal/coma
	name = "Регенеративная кома"
	desc = "Вирус заставляет хозяина впадать в смертельную кому при серьезном повреждении, а затем быстро устраняет повреждения."
	stealth = 0
	resistance = 2
	stage_speed = -3
	transmittable = -2
	level = 8
	passive_message = span_notice("Боль от ран заставляет чувствовать странную сонливость...")
	var/deathgasp = FALSE
	var/stabilize = FALSE
	var/active_coma = FALSE //to prevent multiple coma procs
	threshold_descs = list(
		"Скрытность 2" = "Хозяин, кажется, умирает при впадении в кому.",
		"Сопротивление 4" = "Вирус также стабилизирует хозяина, пока он находится в критическом состоянии.",
		"Скорость 7" = "Увеличивает скорость исцеления.",
	)

/datum/symptom/heal/coma/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 7)
		power = 1.5
	if(A.properties["resistance"] >= 4)
		stabilize = TRUE
	if(A.properties["stealth"] >= 2)
		deathgasp = TRUE

/datum/symptom/heal/coma/on_stage_change(datum/disease/advance/A)  //mostly copy+pasted from the code for self-respiration's TRAIT_NOBREATH stuff
	if(!..())
		return FALSE
	if(A.stage >= 4 && stabilize)
		ADD_TRAIT(A.affected_mob, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)
	else
		REMOVE_TRAIT(A.affected_mob, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)
	return TRUE

/datum/symptom/heal/coma/End(datum/disease/advance/A)
	if(!..())
		return
	if(active_coma)
		uncoma()
	REMOVE_TRAIT(A.affected_mob, TRAIT_NOCRITDAMAGE, DISEASE_TRAIT)

/datum/symptom/heal/coma/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	if(HAS_TRAIT(M, TRAIT_DEATHCOMA))
		return power
	if(M.IsSleeping())
		return power * 0.25 //Voluntary unconsciousness yields lower healing.
	switch(M.stat)
		if(UNCONSCIOUS, HARD_CRIT)
			return power * 0.9
		if(SOFT_CRIT)
			return power * 0.5
	if(M.getBruteLoss() + M.getFireLoss() >= 70 && !active_coma)
		to_chat(M, span_warning("Пора спать..."))
		active_coma = TRUE
		addtimer(CALLBACK(src, .proc/coma, M), 60)


/datum/symptom/heal/coma/proc/coma(mob/living/M)
	M.fakedeath("regenerative_coma", !deathgasp)
	addtimer(CALLBACK(src, .proc/uncoma, M), 300)


/datum/symptom/heal/coma/proc/uncoma(mob/living/M)
	if(QDELETED(M) || !active_coma)
		return
	active_coma = FALSE
	M.cure_fakedeath("regenerative_coma")


/datum/symptom/heal/coma/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = 4 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1)

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()

	if(active_coma && M.getBruteLoss() + M.getFireLoss() == 0)
		uncoma(M)

	return 1

/datum/symptom/heal/coma/passive_message_condition(mob/living/M)
	if((M.getBruteLoss() + M.getFireLoss()) > 30)
		return TRUE
	return FALSE

/datum/symptom/heal/water
	name = "Увлажнение тканей"
	desc = "Вирус использует избыток воды внутри и снаружи тела для восстановления поврежденных клеток ткани. Более эффективен при использовании святой воды и против ожогов."
	stealth = 0
	resistance = -1
	stage_speed = 0
	transmittable = 1
	level = 6
	passive_message = span_notice("Кожа очень сухая...")
	var/absorption_coeff = 1
	threshold_descs = list(
		"Сопротивление 5" = "Вода расходуется гораздо медленнее.",
		"Скорость 7" = "Увеличивает скорость исцеления.",
	)

/datum/symptom/heal/water/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 7)
		power = 2
	if(A.properties["resistance"] >= 5)
		absorption_coeff = 0.25

/datum/symptom/heal/water/CanHeal(datum/disease/advance/A)
	. = 0
	var/mob/living/M = A.affected_mob
	if(M.fire_stacks < 0)
		M.set_fire_stacks(min(M.fire_stacks + 1 * absorption_coeff, 0))
		. += power
	if(M.reagents.has_reagent(/datum/reagent/water/holywater, needs_metabolizing = FALSE))
		M.reagents.remove_reagent(/datum/reagent/water/holywater, 0.5 * absorption_coeff)
		. += power * 0.75
	else if(M.reagents.has_reagent(/datum/reagent/water, needs_metabolizing = FALSE))
		M.reagents.remove_reagent(/datum/reagent/water, 0.5 * absorption_coeff)
		. += power * 0.5
	else if(M.hydration)
		M.hydration -= 0.5 * absorption_coeff
		. += power * 0.25

/datum/symptom/heal/water/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = 2 * actual_power

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC) //more effective on burns

	if(!parts.len)
		return

	if(prob(5))
		to_chat(M, span_notice("Чувствую, что впитываю воду вокруг себя, чтобы успокоить поврежденную кожу."))

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len * 0.5, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()

	return 1

/datum/symptom/heal/water/passive_message_condition(mob/living/M)
	if(M.getBruteLoss() || M.getFireLoss())
		return TRUE
	return FALSE

/datum/symptom/heal/plasma
	name = "Плазменная фиксация"
	desc = "Вирус вытягивает плазму из атмосферы и изнутри тела, чтобы лечить и стабилизировать температуру тела."
	stealth = 0
	resistance = 3
	stage_speed = -2
	transmittable = -2
	level = 8
	passive_message = span_notice("Чувствую странную тягу к плазме.")
	var/temp_rate = 1
	threshold_descs = list(
		"Передача 6" = "Увеличивает скорость регулировки температуры.",
		"Скорость 7" = "Увеличивает скорость исцеления.",
	)

/datum/symptom/heal/plasma/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 7)
		power = 2
	if(A.properties["transmittable"] >= 6)
		temp_rate = 4

/datum/symptom/heal/plasma/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	var/datum/gas_mixture/environment

	. = 0

	if(M.loc)
		environment = M.loc.return_air()
	if(environment)
		if(environment.get_moles(/datum/gas/plasma) > GLOB.meta_gas_info[/datum/gas/plasma][META_GAS_MOLES_VISIBLE]) //if there's enough plasma in the air to see
			. += power * 0.5
	if(M.reagents.has_reagent(/datum/reagent/toxin/plasma, needs_metabolizing = TRUE))
		. +=  power * 0.75

/datum/symptom/heal/plasma/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = 4 * actual_power

	if(prob(5))
		to_chat(M, span_notice("Чувствуете, что поглощаю плазму внутри и вокруг себя..."))

	var/target_temp = M.get_body_temp_normal()
	if(M.bodytemperature > target_temp)
		M.adjust_bodytemperature(-20 * temp_rate * TEMPERATURE_DAMAGE_COEFFICIENT, target_temp)
		if(prob(5))
			to_chat(M, span_notice("Уже не так жарко."))
	else if(M.bodytemperature < (M.get_body_temp_normal() + 1))
		M.adjust_bodytemperature(20 * temp_rate * TEMPERATURE_DAMAGE_COEFFICIENT, 0, target_temp)
		if(prob(5))
			to_chat(M, span_notice("Тепло."))

	M.adjustToxLoss(-heal_amt)

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)
	if(!parts.len)
		return
	if(prob(5))
		to_chat(M, span_notice("Боль от ран быстро исчезает."))
	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()
	return 1


/datum/symptom/heal/radiation
	name = "Радиоактивный резонанс"
	desc = "Вирус использует радиацию, чтобы исправить повреждения, вызванные мутациями ДНК."
	stealth = -1
	resistance = -2
	stage_speed = 2
	transmittable = -3
	level = 6
	symptom_delay_min = 1
	symptom_delay_max = 1
	passive_message = span_notice("Кожа на мгновение слегка светится.")
	var/cellular_damage = FALSE
	threshold_descs = list(
		"Передача 6" = "Дополнительно лечит повреждение клеток.",
		"Сопротивление 7" = "Увеличивает скорость исцеления.",
	)

/datum/symptom/heal/radiation/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 7)
		power = 2
	if(A.properties["transmittable"] >= 6)
		cellular_damage = TRUE

/datum/symptom/heal/radiation/CanHeal(datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	switch(M.radiation)
		if(0)
			return FALSE
		if(1 to RAD_MOB_SAFE)
			return 0.25
		if(RAD_MOB_SAFE to RAD_BURN_THRESHOLD)
			return 0.5
		if(RAD_BURN_THRESHOLD to RAD_MOB_MUTATE)
			return 0.75
		if(RAD_MOB_MUTATE to RAD_MOB_KNOCKDOWN)
			return 1
		else
			return 1.5

/datum/symptom/heal/radiation/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/heal_amt = actual_power

	if(cellular_damage)
		M.adjustCloneLoss(-heal_amt * 0.5)

	M.adjustToxLoss(-(2 * heal_amt))

	var/list/parts = M.get_damaged_bodyparts(1,1, null, BODYPART_ORGANIC)

	if(!parts.len)
		return

	if(prob(4))
		to_chat(M, span_notice("Кожа светится тускло, раны понемногу затягиваются."))

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, heal_amt/parts.len, null, BODYPART_ORGANIC))
			M.update_damage_overlays()
	return 1
