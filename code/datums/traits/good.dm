//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Устойчивость к алкоголю"
	desc = "Пьянею медленнее и на меня меньше действует алкоголь."
	value = 4
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = span_notice("Чувствую, что с лёгкостью могу выпить целую бутылку!")
	lose_text = span_danger("Больше не чувствую свою стойкость к алкоголю. Как-то.")
	medical_record_text = "Пациент демонстрирует сильную устойчивость к алкоголю."

/datum/quirk/apathetic
	name = "Апатичный"
	desc = "Влияние на ваше настроение будет слегка уменьшено."
	value = 4
	mood_quirk = TRUE
	medical_record_text = "Пациенту было назначено проверить свою Шкалу Оценки Апатии, но он даже не начинал её..."

/datum/quirk/apathetic/add()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	if(quirk_holder)
		var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
		if(mood)
			mood.mood_modifier += 0.2

/datum/quirk/drunkhealing
	name = "Лечение от алкоголя"
	desc = "Ничего, кроме очередной хорошей выпивки не будет придавать мне чувство, что вы находитесь на вершине мира. Когда вы пьяны, то медленно будете регенерировать повреждения."
	value = 8
	mob_trait = TRAIT_DRUNK_HEALING
	gain_text = span_notice("Чувствую, что алкоголь может принести мне пользу.")
	lose_text = span_danger("Больше не могу чувствовать, как алкоголь лечит меня!")
	medical_record_text = "Пациент имеет необычную эффективность метаболизма печени лечить его от ран, употребляя алкогольные напитки."

/datum/quirk/drunkhealing/on_process(delta_time)
	var/mob/living/carbon/C = quirk_holder
	switch(C.drunkenness)
		if (6 to 40)
			C.adjustBruteLoss(-0.1*delta_time, FALSE)
			C.adjustFireLoss(-0.05*delta_time, FALSE)
		if (41 to 60)
			C.adjustBruteLoss(-0.4*delta_time, FALSE)
			C.adjustFireLoss(-0.2*delta_time, FALSE)
		if (61 to INFINITY)
			C.adjustBruteLoss(-0.8*delta_time, FALSE)
			C.adjustFireLoss(-0.4*delta_time, FALSE)

/datum/quirk/empath
	name = "Эмпатия"
	desc = "Или шестое чувство, или просто тщательное изучение языка тела, но мне просто будет достаточно взгляда на кого-нибудь, чтобы понять, как он себя чувствует."
	value = 8
	mob_trait = TRAIT_EMPATH
	gain_text = span_notice("Чувствую себя в гармонии с теми, кто окружает меня.")
	lose_text = span_danger("Чувствую себя изолированными ото всех.")
	medical_record_text = "Пациент очень восприимчив и чувствителен к социальным сигналам, или возможно имеет экстрасенсорные способности. Необходимо дальнейшее изучение."

/datum/quirk/fan_clown
	name = "Фанат клоунов"
	desc = "Меня веселят клоуны. Моё настроение повышается, если я ношу на груди значок с их изображением."
	value = 2
	mob_trait = TRAIT_FAN_CLOWN
	gain_text = span_notice("Теперь я большой фанат клоунов.")
	lose_text = span_danger("Мне кажется, что клоуны-то не особо смешны...")
	medical_record_text = "Пациент утверждает, что он является фанатом клоунов."

/datum/quirk/fan_clown/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/accessory/fan_clown_pin/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(H)

/datum/quirk/fan_mime
	name = "Фанат мимов"
	desc = "Меня нравится мимы. Моё настроение повышается, если я ношу на груди значок с их изображением."
	value = 2
	mob_trait = TRAIT_FAN_MIME
	gain_text = span_notice("Теперь я большой фанат мимов..")
	lose_text = span_danger("Мне кажется, что мимы слишком скучны...")
	medical_record_text = "Пациент утверждает, что он является фанатом мимов."

/datum/quirk/fan_mime/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/accessory/fan_mime_pin/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(H)

/datum/quirk/freerunning
	name = "Паркурист"
	desc = "Могу быстрее забираться на столы, а также буду получать сниженный урон от падения."
	value = 8
	mob_trait = TRAIT_FREERUNNING
	gain_text = span_notice("Чувствую гибкость своих ног!")
	lose_text = span_danger("Чувствую себя неуклюжим.")
	medical_record_text = "Пациент набрал большое количество очков в кардио-тестах."

/datum/quirk/friendly
	name = "Дружелюбный"
	desc = "Я умею обниматься, особенно это будет заметно при повышенном настроении."
	value = 4
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("Хочу кого-нибудь обнять.")
	lose_text = span_danger("Больше не чувствую необходимость обнимать кого-то.")
	mood_quirk = TRUE
	medical_record_text = "Пациент демонстрирует довольно низкие ограничения физического контакта."

/datum/quirk/jolly
	name = "Оптимист"
	desc = "Иногда вы будете чувствовать себя счастливым, без ведомой на то причины."
	value = 4
	mob_trait = TRAIT_JOLLY
	mood_quirk = TRUE
	medical_record_text = "Пациент демонстрирует постоянную эвтимию, нерегулярную для окружающей среды. Если быть честным, это даже немного слишком."

/datum/quirk/jolly/on_process(delta_time)
	if(DT_PROB(0.05, delta_time))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "jolly", /datum/mood_event/jolly)

/datum/quirk/light_step
	name = "Легкий шаг"
	desc = "Буду ходить аккуратно; буду нежнее наступать на осколки, а наносимый урон от этого будет меньше. Также не оставляю после себя следов."
	value = 4
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = span_notice("Хожу с немного большей гибкостью.")
	lose_text = span_danger("Начинаю делать такие шаги, словно какой-то варвар.")
	medical_record_text = "Пациент демонстрирует хорошо развитые стопы."

/datum/quirk/musician
	name = "Музыкант"
	desc = "Смогу настраивать музыкальные инструменты таким образом, что мелодия будет снимать определенные негативные эффекты у окружающих и успокаивать душу."
	value = 2
	mob_trait = TRAIT_MUSICIAN
	gain_text = span_notice("Знаю всё о музыкальных инструментах.")
	lose_text = span_danger("Забываю, как работают музыкальные инструменты.")
	medical_record_text = "Сканирование мозга пациента показывает высокоразвитые слуховые мышцы."

/datum/quirk/musician/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/choice_beacon/music/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)

/datum/quirk/night_vision
	name = "Ночное видение"
	desc = "Буду видеть в темноте немного лучше."
	value = 4
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = span_notice("Тени кажутся мне менее темными.")
	lose_text = span_danger("Всё кажется немного темнее.")
	medical_record_text = "Глаза пациента показывают выше-среднюю акклиматизацию к темноте."

/datum/quirk/night_vision/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes || eyes.lighting_alpha)
		return
	eyes.refresh()

/datum/quirk/selfaware
	name = "Самоконтроль"
	desc = "Смогу точно оценить степень нанесенных мне повреждений."
	value = 8
	mob_trait = TRAIT_SELF_AWARE
	medical_record_text = "Пациент демонстрирует невероятное умение самодиагностики."

/datum/quirk/skittish
	name = "Настороженный"
	desc = "Можно легко скрывать себя от опасности. СRTL+SHIFT+ПКМ по шкафчику, чтобы залезть в него быстро, если имеется соответствующий доступ."
	value = 8
	mob_trait = TRAIT_SKITTISH
	medical_record_text = "Пациент демонстрирует антипатию к опасности, и описывает свою склонность к скрытию в шкафчиках из-за своего страха."

/datum/quirk/spiritual
	name = "Религиозный"
	desc = "Шанс, что молитвы будут услышаны, будет немного увеличен. Возможно."
	value = 4
	mob_trait = TRAIT_SPIRITUAL
	gain_text = span_notice("Теперь вы верите в высшую силу.")
	lose_text = span_danger("Больше не верую!")
	medical_record_text = "Пациент сообщает о своей вере в некую силу."

/datum/quirk/spiritual/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/candle_box(H), ITEM_SLOT_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/matches(H), ITEM_SLOT_BACKPACK)

/datum/quirk/tagger
	name = "Граффер"
	desc = "В прошлом, довольно часто доводилось заниматься рисованием граффити. Буду экономно расходовать количество использований баллончика."
	value = 4
	mob_trait = TRAIT_TAGGER
	gain_text = span_notice("Знаю, как эффективно расходовать баллончик.")
	lose_text = span_danger("Забываю, как правильно расходовать баллончик.")
	medical_record_text = "Пациент был недавно замечен за рисованием граффити на стене."

/datum/quirk/tagger/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/toy/crayon/spraycan/spraycan = new(get_turf(H))
	H.put_in_hands(spraycan)
	H.equip_to_slot(spraycan, ITEM_SLOT_BACKPACK)
	H.regenerate_icons()

/datum/quirk/voracious
	name = "Прожорливый"
	desc = "Ничего не встает на пути между мной и едой. Буду есть в два раза быстрее и вполне смогу перекусить нездоровой пищей. Быть толстым мне очень подходит."
	value = 4
	mob_trait = TRAIT_VORACIOUS
	gain_text = span_notice("Чувствую бурление в желудке.")
	lose_text = span_danger("Мне кажется, что мой аппетит немного снизился.")
