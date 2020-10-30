//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Устойчивость к алкоголю"
	desc = "Я пьянею медленнее и на меня меньше воздействует алкоголь."
	value = 1
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = "<span class='notice'>Я чувствую, что с лёгкостью могу выпить целую бутылку!</span>"
	lose_text = "<span class='danger'>Я больше не чувствую свою стойкость к алкоголю. Как-то.</span>"
	medical_record_text = "Пациент демонстрирует сильную устойчивость к алкоголю."

/datum/quirk/apathetic
	name = "Апатичный"
	desc = "Вам просто плевать на всё, что творится вокруг вас, в отличие от других. Наверное, это может быть весьма хорошей вещью в таком месте."
	value = 1
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
	desc = "Ничего, кроме очередной хорошей выпивки не придаёт вам чувство, что вы находитесь на вершине мира. Когда вы пьяны, то медленно исцеляетесь от ран."
	value = 2
	mob_trait = TRAIT_DRUNK_HEALING
	gain_text = "<span class='notice'>Я чувствую, что алкоголь может принести мне пользу.</span>"
	lose_text = "<span class='danger'>Я больше не могу чувствовать, как алкоголь лечит меня!</span>"
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
	desc = "Будь то шестым чувством, или просто тщательное изучение языка тела, но вам просто достаточно взгляда на кого-нибудь, чтобы понять чьи-то чувства."
	value = 2
	mob_trait = TRAIT_EMPATH
	gain_text = "<span class='notice'>Я чувствую себя в гармонии с теми, кто окружает меня.</span>"
	lose_text = "<span class='danger'>Я чувствую себя изолированными ото всех.</span>"
	medical_record_text = "Пациент очень восприимчив и чувствителен к социальным сигналам, или возможно имеет экстрасенсорные способности. Необходимо дальнейшее изучение."

/datum/quirk/fan_clown
	name = "Фанат клоунов"
	desc = "Меня веселят всякие выходки клоунов! Мое настроение повышается, если я ношу на груди значок с их изображением."
	value = 1
	mob_trait = TRAIT_FAN_CLOWN
	gain_text = "<span class='notice'>Вы большой фанат клоунов.</span>"
	lose_text = "<span class='danger'>Вам кажется, что клоуны-то не особо смешны...</span>"
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
	fan.add_hud_to(H)

/datum/quirk/fan_mime
	name = "Фанат мимов"
	desc = "Мне нравится трюки мимов! Мое настроение повышается, если я ношу на груди значок с их изображением."
	value = 1
	mob_trait = TRAIT_FAN_MIME
	gain_text = "<span class='notice'>Вы большой фанат мимов..</span>"
	lose_text = "<span class='danger'>Вам кажется, что мимы слишком скучны...</span>"
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
	fan.add_hud_to(H)

/datum/quirk/freerunning
	name = "Паркурист"
	desc = "Вы являетесь довольно ловким в своих движениях! Вы можете более быстрее забираться на столы, а также получаете сниженный урон от падения."
	value = 2
	mob_trait = TRAIT_FREERUNNING
	gain_text = "<span class='notice'>Я чувствую гибкость своих ног!</span>"
	lose_text = "<span class='danger'>Я чувствую себя неуклюжим.</span>"
	medical_record_text = "Пациент набрал большое количество очков в кардио-тестах."

/datum/quirk/friendly
	name = "Дружелюбный"
	desc = "Я хорошо обнимаюсь, особенно когда у меня хорошее настроение."
	value = 1
	mob_trait = TRAIT_FRIENDLY
	gain_text = "<span class='notice'>Я хочу кого-нибудь обнять.</span>"
	lose_text = "<span class='danger'>Я больше не чувствую необходимость обнимать кого-то.</span>"
	mood_quirk = TRUE
	medical_record_text = "Пациент демонстрирует довольно низкие ограничения физического контакта."

/datum/quirk/jolly
	name = "Оптимист"
	desc = "Иногда я чувствую себя счастливым, без ведомой на то причины."
	value = 1
	mob_trait = TRAIT_JOLLY
	mood_quirk = TRUE
	medical_record_text = "Пациент демонстрирует постоянную эвтимию, нерегулярную для окружающей среды. Если быть честным, это даже немного слишком."

/datum/quirk/jolly/on_process(delta_time)
	if(DT_PROB(0.05, delta_time))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "jolly", /datum/mood_event/jolly)

/datum/quirk/light_step
	name = "Легкий шаг"
	desc = "Вы ходите аккуратно; будете тише наступать на острые предметы, а наносимый вам урон от этого будет меньше. Также вы не оставляете после себя следов."
	value = 1
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = "<span class='notice'>Я хожу с немного большей гибкостью.</span>"
	lose_text = "<span class='danger'>Я начинаю делать такие шаги, словно какой-то варвар.</span>"
	medical_record_text = "Пациент демонстрирует хорошо развитые стопы."

/datum/quirk/light_step/on_spawn()
	var/datum/component/footstep/C = quirk_holder.GetComponent(/datum/component/footstep)
	if(C)
		C.volume *= 0.6
		C.e_range -= 2

/datum/quirk/musician
	name = "Музыкант"
	desc = "Я умею настраивать музыкальные инструменты так, что мелодия будет снимать определенные негативные эффекты у окружающих и успокаивать всем душу."
	value = 1
	mob_trait = TRAIT_MUSICIAN
	gain_text = "<span class='notice'>Я знаю всё о музыкальных инструментах.</span>"
	lose_text = "<span class='danger'>Я забываю, как работают музыкальные инструменты.</span>"
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
	desc = "Я могу видеть более чётко в полной темноте, в отличие от других	."
	value = 1
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = "<span class='notice'>Тени кажутся мне менее темными.</span>"
	lose_text = "<span class='danger'>Всё кажется немного темнее.</span>"
	medical_record_text = "Глаза пациента показывают выше-среднюю акклиматизацию к темноте."

/datum/quirk/night_vision/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes || eyes.lighting_alpha)
		return
	eyes.Insert(H)

/datum/quirk/photographer
	name = "Фотограф"
	desc = "Я знаю, как обращаться с камерой, и сокращаю задержку между каждым снимком."
	value = 1
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = "<span class='notice'>Я знаю всё о фотографировании.</span>"
	lose_text = "<span class='danger'>Я забываю, как работают фотоаппараты.</span>"
	medical_record_text = "Пациент упоминал фотографирование как хобби, снимающее стресс."

/datum/quirk/photographer/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/storage/photo_album/photo_album = new(get_turf(H))
	var/list/album_slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(photo_album, album_slots , qdel_on_fail = TRUE)
	photo_album.persistence_id = "personal_[H.mind.key]" // this is a persistent album, the ID is tied to the account's key to avoid tampering
	photo_album.persistence_load()
	photo_album.name = "[H.real_name]'s photo album"
	var/obj/item/camera/camera = new(get_turf(H))
	var/list/camera_slots = list (
		"neck" = ITEM_SLOT_NECK,
		"left pocket" = ITEM_SLOT_LPOCKET,
		"right pocket" = ITEM_SLOT_RPOCKET,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(camera, camera_slots , qdel_on_fail = TRUE)
	H.regenerate_icons()

/datum/quirk/selfaware
	name = "Самоконтроль"
	desc = "Я хорошо знаю своё тело, и могу точно оценить степень нанесенных мне повреждений."
	value = 2
	mob_trait = TRAIT_SELF_AWARE
	medical_record_text = "Пациент демонстрирует невероятное умение самодиагностики."

/datum/quirk/skittish
	name = "Настороженный"
	desc = "Я могу легко скрывать себя от опасности. СRTL+SHIFT+ПКМ по шкафчику, чтобы залезть в него быстро, если у вас имеется доступ."
	value = 2
	mob_trait = TRAIT_SKITTISH
	medical_record_text = "Пациент демонстрирует антипатию к опасности, и описывает свою склонность к скрытию в шкафчиках из-за своего страха."

/datum/quirk/spiritual
	name = "Религиозный"
	desc = "Вы придерживаетесь веры, может быть, в Бога, в природу или в тайные правила Вселенной, но вы чувствуете себя комфортнее от присутствия чего-то святого, и верите в то, что вас обязательно услышат."
	value = 1
	mob_trait = TRAIT_SPIRITUAL
	gain_text = "<span class='notice'>Теперь вы верите в высшую силу.</span>"
	lose_text = "<span class='danger'>Я больше не верую!</span>"
	medical_record_text = "Пациент сообщает о своей вере в некую силу."

/datum/quirk/spiritual/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/candle_box(H), ITEM_SLOT_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/matches(H), ITEM_SLOT_BACKPACK)

/datum/quirk/tagger
	name = "Граффер"
	desc = "В прошлом мне довольно часто доводилось заниматься рисованием граффити. Я умею экономно расходовать количество использований моего баллончика."
	value = 1
	mob_trait = TRAIT_TAGGER
	gain_text = "<span class='notice'>Я знаю, как эффективно расходовать баллончик.</span>"
	lose_text = "<span class='danger'>Я забываю, как правильно расходовать баллончик.</span>"
	medical_record_text = "Пациент был недавно замечен за рисованием граффити на стене."

/datum/quirk/tagger/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/toy/crayon/spraycan/spraycan = new(get_turf(H))
	H.put_in_hands(spraycan)
	H.equip_to_slot(spraycan, ITEM_SLOT_BACKPACK)
	H.regenerate_icons()

/datum/quirk/voracious
	name = "Прожорливый"
	desc = "Ничего не встает на пути между мной и едой. Я ем в два раза быстрее и вполне могу перекусить нездоровой для меня пищей! Быть толстым мне очень подходит."
	value = 1
	mob_trait = TRAIT_VORACIOUS
	gain_text = "<span class='notice'>Я чувствую бурление в желудке.</span>"
	lose_text = "<span class='danger'>Мне кажется, что мой аппетит немного снизился.</span>"
