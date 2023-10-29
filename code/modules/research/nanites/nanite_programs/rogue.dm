//Programs generated through degradation of other complex programs.
//They generally cause minor damage or annoyance.

//Last stop of the error train
/datum/nanite_program/glitch
	name = "Сбой"
	desc = "Сильное повреждение программы, вызывающее стремительное разрушение нанитов."
	use_rate = 1.5
	unique = FALSE
	rogue_types = list()

//Generic body-affecting programs will decay into this
/datum/nanite_program/necrotic
	name = "Некроз"
	desc = "Наниты атакуют внутренние ткани организма, вызывая сильный и распространенный по всему телу урон."
	use_rate = 0.75
	unique = FALSE
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/necrotic/active_effect()
	host_mob.adjustBruteLoss(0.75, TRUE)
	if(prob(1))
		to_chat(host_mob, span_warning("You feel a mild ache from somewhere inside you."))

//Programs that don't directly interact with the body will decay into this
/datum/nanite_program/toxic
	name = "Интоксикация"
	desc = "Наниты начинают медленное, но непрерывное создание токсинов в организме носителя."
	use_rate = 0.25
	unique = FALSE
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/toxic/active_effect()
	host_mob.adjustToxLoss(0.5)
	if(prob(1))
		to_chat(host_mob, span_warning("You feel a bit sick."))

//Generic blood-affecting programs will decay into this
/datum/nanite_program/suffocating
	name = "Гипоксия"
	desc = "Наниты нарушают естественное усваивание кислорода в организме носителя."
	use_rate = 0.75
	unique = FALSE
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/suffocating/active_effect()
	host_mob.adjustOxyLoss(3, 0)
	if(prob(1))
		to_chat(host_mob, span_warning("Я задыхаюсь!"))

//Generic brain-affecting programs will decay into this
/datum/nanite_program/brain_decay
	name = "Нейро-Некроз"
	desc = "Наниты ищут и атакуют клетки мозга, вызывая масштабный урон мозгу."
	use_rate = 0.75
	unique = FALSE
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/brain_decay/active_effect()
	if(prob(4))
		host_mob.hallucination = min(15, host_mob.hallucination)
	host_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)

//Generic brain-affecting programs can also decay into this
/datum/nanite_program/brain_misfire
	name = "Церебральный сбой"
	desc = "Наниты вмешиваются в нейронные соединения, вызывая небольшие психические расстройства.."
	use_rate = 0.50
	unique = FALSE
	rogue_types = list(/datum/nanite_program/brain_decay)

/datum/nanite_program/brain_misfire/active_effect()
	if(prob(10))
		switch(rand(1,4))
			if(1)
				host_mob.hallucination += 15
			if(2)
				host_mob.add_confusion(10)
			if(3)
				host_mob.drowsyness += 10
			if(4)
				host_mob.slurring += 10

//Generic skin-affecting programs will decay into this
/datum/nanite_program/skin_decay
	name = "Дермализис"
	desc = "Наниты атакуют клетки кожи, вызывая раздражение, сыпь и небольшой урон."
	use_rate = 0.25
	unique = FALSE
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/skin_decay/active_effect()
	host_mob.adjustBruteLoss(0.25)
	if(prob(5)) //itching
		var/picked_bodypart = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		var/obj/item/bodypart/bodypart = host_mob.get_bodypart(picked_bodypart)
		var/can_scratch = !host_mob.incapacitated() && get_location_accessible(host_mob, picked_bodypart)

		host_mob.visible_message("[can_scratch ? span_warning("[host_mob] чешет [host_mob.ru_ego()] [bodypart.name].")  : ""]",\
		span_warning("Моя [bodypart.name] чешется. [can_scratch ? " Я чешусь." : ""]"))

//Generic nerve-affecting programs will decay into this
/datum/nanite_program/nerve_decay
	name = "Разрушение нервов"
	desc = "Наниты разрушают нервы носителя, вызывая проблемы с координацией и небольшие приступы паралича."
	use_rate = 1
	unique = FALSE
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/nerve_decay/active_effect()
	if(prob(5))
		to_chat(host_mob, span_warning("Голова кружится!"))
		host_mob.add_confusion(10)
	else if(prob(4))
		to_chat(host_mob, span_warning("Не чувствую рук!"))
		host_mob.drop_all_held_items()
	else if(prob(4))
		to_chat(host_mob, span_warning("Не чувствую ног!"))
		host_mob.Paralyze(30)
