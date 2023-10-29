//  Оверлей Церебрала

/obj/item/organ/cyberimp/eyes/hud/psih
	name = "имплант интерфейса психолога"
	desc = "Эти кибернетический чип выводит медицинский интерфейс поверх всего что вы видите, так так же распознает микромимику."
	HUD_type = DATA_HUD_PSIH
	HUD_trait = TRAIT_MEDICAL_HUD

// Вариант №2 Гипноз

/obj/item/hypno_watch
	name = "карманные часы"
	desc = "Красивая реплика старинных механических часов на цепочке. Корпус выполнен из золота и ярко блестит при свете ламп. В этом блеске есть что-то гипнотически завораживающее..."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "hypno_watch"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "clamps"
	custom_materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000, /datum/material/gold = 2000)
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY

	var/psychotherapy_cd = 60 SECONDS
	var/cast_time = 36
	var/cast_process = FALSE
	var/dialog_turn = FALSE
	var/list/valid_areas = list(/area/medical/psychology, /area/service/chapel, /area/security/main/sb_med, /area/service/theater)

	var/dialog_user = list(
		"Загляните в свой разум, поделитесь тем, что вас беспокоит прямо сейчас.",
		"Расскажите, что привело вас ко мне?",
		"Сбросьте тот груз, что отягощает ваши плечи.",
		"Освободите себя от призраков прошлого.",
		"То что нас не убивает, делает нас сильнее.",
		"Закройте глаза. Вдохните глубоко. Почувствуйте кончики своих пальцев…",
		"Всё будет хорошо...",
		"Вам следует сфокусироваться на своей работе...",
		"Переключитесь на другое занятие...",
		"Вам следует отвлечься от проблем.",
		"Вы не виновны в ваших проблемах...",
		"Все образуется.",
		"Вы можете положиться на меня...",
		"Здесь вы в безопасности.",
		"Расслабьтесь.",
		"Закройте глаза... Загляните в своё подсознание...",
		"Не стоит принимать это слишком близко к сердцу.",
		"Корень вашей проблемы, сокрыт в вашем подсознании.",
		"Вспомните что-нибудь приятное из детства.",
		"Представьте бескрайний луг... Присядьте... Потрогайте траву...",
		"У каждого в жизни бывают трудные моменты... Это нормально.",
		"Ощутите спокойствие...",
		"Ваши проблемы растворяются в глубине космоса...",
		"М-м-пнятненько...",
		"Вам не стоит зацикливаться на этом.",
		"И тебя вылечат...",
		"Зато не в дурдоме...",
		"Если вы чувствуете боль - вы все еще живы.",
		"Слушайте мой голос...",
		"Не прекращайте говорить...",
		"Все что вас интересует сейчас - это часы перед вашими глазами...",
		"Прислушайтесь к тиканью часов...",
		"Ваши страхи уходят...",
		"Тик-так, тик-так...",
		"Прислушайтесь к голосу чистого разума...",
		"Есть только голос...",
		"Спокойствие... Гармония... Безмятежность...",
		"С каждым тиком часов ваши проблемы уходят...",
		"Как только вы поделитесь вашими проблемами, вы забудете их.",
		"Ваши проблемы больше не беспокоят вас.",
		"Забудьте негатив...",
		"Отпустите проблемы...",
		"Отдайтесь на волю течению...",
		"Есть только космос...",
		"Ваш разум словно храм...",
		"Блеск, что вы сейчас видите это отблеск далекой звезды...",
		"Примите и отпустите...",
		"Время не важно...",
		"Вы не одни...",
		"Блеск смывает страх...",
		"Ваши кошмары это порождения вашего же разума, вы способны их контролировать.",
	)

	var/dialog_target = list(
		"Всё становится ужасным!",
		"Я плохо сплю. Что-то тревожит меня, но я не понимаю, что...",
		"Эта станция... Она ужасна... Мне кажется мы все умрем здесь...",
		"Иногда мне кажется, что все вокруг не настоящее... Это как будто какая-то симуляция...",
		"Каждый раз когда я смотрю в открытый космос, мне кажется что-кто-то смотрит на меня в ответ...",
		"У меня такое ощущение что я попал в петлю, что все вокруг повторяется...",
		"Когда я смотрю на себя в зеркало, я нахожу все новые и новые шрамы... Но я не помню когда я их получил...",
		"Иногда мне кажется что я был кем-то другим, с иным цветом кожи, прической, полом и даже именем... А иногда даже и не человеком...",
		"Иногда мне кажется, что убить человека... это же не так страшно? Что в этом такого? Это не правильно, но я не чувствую отторжения при этой мысли..",
		"Я помню как я умирал... я помню эту боль... как я задыхался... как мне вскрывали грудь лазерным мечем... как меня расстреливали из лазеров...",
		"Иногда меня охватывает неконтролируемая ярость, я готов убить по самому надуманному поводу... за обычный толчок или глупую фразу...",
		"Когда я берусь за какую-либо работу, я иногда просто не понимаю откуда я все это знаю? Я же никогда в своей жизни этим не занимался!",
		"Я ощущаю себя марионеткой.",
		"Иногда я теряю счет времени... я даже не знаю какой сегодня день недели...",
		"Как только я ступил на эту станцию, я осознал, что тут есть кто-то кто замыслил что-то чудовищное против меня или окружающих...",
		"Клоун пугает меня... мне часто кажется, что под этой улыбчивой маской находится чудовищное кожистое лицо... а может эта маска и есть его лицо?",
		"Почему этот черно-белый человек в подтяжках постоянно смотрит на меня? Он не двигается, не говорит, он просто смотрит прямо в душу...",
		"Мне кажется что я никому не могу доверять, мне постоянно кажется, что все они могут предать меня...",
		"За что мне все это? Я просто искал работу...",
		"Иногда я просто бесцельно начинаю слоняться по станции...",
		"Иногда я замечаю за собой желание, найти какое-нибудь оружие... Словно скоро произойдет что-то ужасное...",
		"Меня кто-то преследует... и явно не с добрыми намерияниями.",
		"Я иногда не узнаю себя в отражении зеркала...",
		"Я ощущаю себя бездушным механизмом в какой-то странной системе...",
		"Меня посещают странные мысли, настолько чужеродные, что они пугают меня самого...",
		"У меня непрекращающееся чувство дежавю...",
		"Я сегодня не такой как вчера...",
		"Я иногда забываю как меня зовут...",
		"Мне очень трудно вспоминать события из моей жизни, предшествующие тому, как я попал на эту станцию...",
		"Иногда мне кажется что за пределами этой станции ничего не существует...",
		"В определенные случайные моменты, я могу просто потерять интерес ко всему происходящему... просто лечь прямо на пол... и уснуть...",
		"Как только эвакуационный шаттл пристыкуется к ЦК... я кого-то точно убью...",
		"Мне кажется как только мы прибудем на ЦК все это закончится...",
		"Я заметил, что я совершенно не ценю свою жизнь, я готов иногда умереть просто ради шутки...",
		"Оскорбления стали для меня болезненнее, чем физические травмы...",
		"Я чувствую себя куклой в руках ребенка...",
		"Кто такой Валера?!",
		"Я иногда путаюсь в своих руках...",
		"Хоть меня и ужасают все эти раны, на самом деле я совершенно не чувствую боли...",
		"У меня есть мечта... далекая... светлая... белая мечта...",
		"Все вокруг меня фальшивое... как это вообще может работать?",
		"Все вокруг какое-то плоское...",
		"Этот мир состоит из квадратов... и точек...",
		"Я не слышу голоса... я их вижу...",
		"У меня такое ощущение, что тут нет потолка...",
		"Я не верю всем, кто работает или просто ходит рядом со мной, даже если я знаю, что он благожелателен ко мне и не причинит зла. Что со мной? ",
		"Иногда я не понимаю окружающих людей... они говорят непонятные вещи...",
		"Я не верю вашим словам.",
		"Я хочу ощутить под ногами реальную землю... Я хочу вдохнуть настоящий нефильтрованный воздух...",
		"Вокруг вроде как много людей... и они меня даже не избегают... но я все равно чувствую себя очень одиноким...",
		"Я постоянно чувствую себя виноватым во всем негативном что происходит вокруг меня... даже если я был прав или вообще был жертвой...",
	)


/obj/item/hypno_watch/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Станционное время: [station_time_timestamp()]</span>"

/obj/item/hypno_watch/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PSIH_HUD))
		if(cast_process)
			to_chat(user, span_warning("Я должен сосредоточиться!"))
			return FALSE

		if(!check_valid_target(target, user))	// Проверка на возможность
			return FALSE

		on_cast_start(target, user)				// Проверка Зоны+Химии, старт
		cast_process = TRUE
		for(var/i in 1 to cast_time)
			if(!dialog(target, user))			// Диалог с проверкой на статичность
				on_cast_stopped(target, user)
				cast_process = FALSE
				return
		on_cast_finished(target, user)				// Работа с церебралами
		cast_process = FALSE

		return TRUE

//	Этап проверки на возможность
/obj/item/hypno_watch/proc/check_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/user)

	if(target == user)
		to_chat(user, span_notice("Красивые часы... блестят..."))
		return FALSE

	if(get_dist(target, user) > 1)
		to_chat(user, span_warning("[target.p_theyre(TRUE)] слишком далеко!"))
		return FALSE

	if(!isliving(target))
		return FALSE

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/t = target
		if(t.psychotherapy_last_time + psychotherapy_cd > world.time)
			to_chat(user, span_warning("Этому пациенту необходим отдых! Лучше не начинать с ним новую сессию раньше чем через [(t.psychotherapy_last_time + psychotherapy_cd - world.time)/10] секунд. Ну или можно поразговаривать с ним на отвлеченные темы."))
			return FALSE
	else
		to_chat(user, span_warning("Я не очень понимаю как вести диалог с... таким... пациентом..."))
		return FALSE

	if(target.stat == DEAD)
		to_chat(user, span_warning("Я не медиум и не способен общаться с мертвыми!"))
		return FALSE
	if(!target.mind)
		to_chat(user, span_warning("Разум этого бедолаги окончательно покинул его сознание, ему уже не помочь!"))
		return FALSE
	if(!target.key)
		to_chat(user, span_warning("Этот пациент впал в кому, ему уже не помочь!"))
		return FALSE

	return TRUE

//	Начало сеанса
/obj/item/hypno_watch/proc/on_cast_start(mob/living/carbon/human/target, mob/living/carbon/human/user)

	cast_time = initial(cast_time)
	if(is_type_in_list(get_area(user), valid_areas))
		cast_time = cast_time / 2

	if(target.reagents.has_reagent(/datum/reagent/medicine/neurine) || target.reagents.has_reagent(/datum/reagent/pax) || target.reagents.has_reagent(/datum/reagent/medicine/mannitol) || target.reagents.has_reagent(/datum/reagent/medicine/psicodine) || target.reagents.has_reagent(/datum/reagent/drug/happiness))
		if(cast_time == cast_time / 2)
			cast_time = cast_time / 3
		else
			cast_time = cast_time / 2

	to_chat(target, span_notice("Перед глазами начинает мелькать золотой блеск... мысли замедляются и успокаиваются..."))
	if(!do_after(user, 5 SECONDS, user))
		return FALSE
	to_chat(user, span_notice("Пациент начал погружаться в транс! Теперь главное не потерять концентрацию..."))
	user.say("Слушайте мой голос...", forced=name)

//	Процесс сеанса с диалогом
/obj/item/hypno_watch/proc/dialog(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(dialog_turn)
		if(!do_after(user, 5 SECONDS, user))
			return FALSE
		user.say("[pick(dialog_user)]", forced=name)
	else
		if(!do_after(target, 5 SECONDS, target))
			return FALSE
		target.say("[pick(dialog_target)]", forced=name)
	dialog_turn = !dialog_turn
	return TRUE

//	Преждевременное прерывание сеанса
/obj/item/hypno_watch/proc/on_cast_stopped(mob/living/carbon/human/target, mob/living/carbon/human/user)
	to_chat(target, span_notice("Я как будто просыпаюсь ото сна..."))
	to_chat(user, span_notice("Не удалось удержать концентрацию..."))


//	Удачное завершение сеанса
/obj/item/hypno_watch/proc/on_cast_finished(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	for(var/i in B.traumas)
		var/datum/brain_trauma/trauma = i

		switch(trauma.resilience)
			if(TRAUMA_RESILIENCE_BASIC)
				target.cure_all_traumas(TRAUMA_RESILIENCE_BASIC)
			if(TRAUMA_RESILIENCE_WOUND)
				target.cure_all_traumas(TRAUMA_RESILIENCE_WOUND)
			if(TRAUMA_RESILIENCE_SURGERY)
				trauma.resilience = TRAUMA_RESILIENCE_BASIC
			if(TRAUMA_RESILIENCE_LOBOTOMY)
				trauma.resilience = TRAUMA_RESILIENCE_SURGERY
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	if(target.mind?.has_antag_datum(/datum/antagonist/abductee))
		target.mind.remove_antag_datum(/datum/antagonist/abductee)
	target.psih_hud_set_status()
	target.psychotherapy_last_time = world.time

	user.say("Вы очнетесь по щелчку моих пальцев.", forced=name)
	to_chat(target, span_notice("Медленно выплываю из транса... Не вполне понимаю что произошло, но мне явно стало лучше!"))
	to_chat(user, span_notice("Мне удалось облегчить душевные терзания этого бедолаги..."))
