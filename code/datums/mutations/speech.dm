//These are all minor mutations that affect your speech somehow.
//Individual ones aren't commented since their functions should be evident at a glance

/datum/mutation/human/nervousness
	name = "Нервозность"
	desc = "Вызывает заикание."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("Я в-в-в п-п-по-рядке!")

/datum/mutation/human/nervousness/on_life(delta_time, times_fired)
	if(DT_PROB(5, delta_time))
		owner.stuttering = max(10, owner.stuttering)


/datum/mutation/human/wacky
	name = "Чокнутый"
	desc = "Нет... Ты не клоун... Ты весь цирк в одном лице..."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_sans("Вы чувствуете прикольное ощущение в своем голосовом аппарате.")
	text_lose_indication = span_notice("Речь приходит в норму.")

/datum/mutation/human/wacky/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/wacky/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/wacky/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/mutation/human/mute
	name = "Немота"
	desc = "Полностью подавляет речевой отдел мозга."
	quality = NEGATIVE
	text_gain_indication = span_danger("А как говорить?")
	text_lose_indication = span_danger("Могу свободно выражать свои мысли вслух.")

/datum/mutation/human/mute/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/mute/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/unintelligible
	name = "Невнятность"
	desc = "Частично подавляет речевой отдел мозга, сильно искажая речь."
	quality = NEGATIVE
	text_gain_indication = span_danger("Я внезапно потерял осознание того, как из звуков составлять слова!")
	text_lose_indication = span_danger("Выражать свои мысли стало намного проще.")

/datum/mutation/human/unintelligible/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/unintelligible/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/swedish
	name = "Швед"
	desc = "Чудовищная мутация из далекого прошлого. Берет свои корни из инцидента в 2037 году."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("Внезапно осознаю, что я коренной Швед.")
	text_lose_indication = span_notice("Мои Шведские корни ушли в небытие.")

/datum/mutation/human/swedish/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/swedish/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/swedish/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = replacetext(message,"в","у")
		message = replacetext(message,"ж","ю")
		message = replacetext(message,"а",pick("å","ä","æ","a"))
		message = replacetext(message,"бо","бжо")
		message = replacetext(message,"о",pick("ö","ø","o"))
		if(prob(30))
			message += " Борк[pick("",", борк",", борк, борк")]!"
		speech_args[SPEECH_MESSAGE] = trim(message)

/datum/mutation/human/chav
	name = "Феня"
	desc = "Ген случайным образом вырабатывающийся у ассистентов"
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("Ощущаю себя дебилом с окраины?")
	text_lose_indication = span_notice("Что то больше не хочется быть быдлом.")

/datum/mutation/human/chav/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/chav/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/chav/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		message = replacetext(message," суперматерия "," монолит ")
		message = replacetext(message," тэг "," баня ")
		message = replacetext(message," теха "," темная улица ")
		message = replacetext(message," генетик "," контролер ")
		message = replacetext(message," синдикат "," пиндосы ")
		message = replacetext(message," психолог "," мозгокрут ")
		message = replacetext(message," шиз "," стукнутый ")
		message = replacetext(message," ИИ "," Большой Брат ")
		message = replacetext(message," борг "," пылесос ")
		message = replacetext(message," детектив "," пес ")
		message = replacetext(message," адвокат "," стукач ")
		message = replacetext(message," огнетушитель "," петушитель ")
		message = replacetext(message," священник "," патлатый ")
		message = replacetext(message," библиотекарь "," буквоед ")
		message = replacetext(message," морг "," холодная ")
		message = replacetext(message," предатель "," вор в законе ")
		message = replacetext(message," мутант "," кровосос ")
		message = replacetext(message," станция "," хата ")
		message = replacetext(message," смена "," отсидка ")
		message = replacetext(message," поговорим "," побазарим ")
		message = replacetext(message," шаттл "," дизель ")
		message = replacetext(message," уходим "," тикаем ")
		message = replacetext(message," пошли "," мансуем ")
		message = replacetext(message," ты ",pick(" брат "," братан "," братуха "))
		message = replacetext(message," се "," прапор стройбата ")
		message = replacetext(message," убил "," замочил ")
		message = replacetext(message," убийство "," мокруха ")
		message = replacetext(message," ассистент "," босяк ")
		message = replacetext(message," труп "," жмур ")
		message = replacetext(message," бля "," мляяяя ")
		message = replacetext(message," бриг "," зона ")
		message = replacetext(message," рд "," чумак ")
		message = replacetext(message," ученый "," яйцеголовый ")
		message = replacetext(message," рнд "," припять ")
		message = replacetext(message," привет "," вечер в хату ")
		message = replacetext(message," мед "," больничка ")
		message = replacetext(message," инженер "," стройбат ")
		message = replacetext(message," врач "," мурка ")
		message = replacetext(message," варден "," вертухай ")
		message = replacetext(message," смо "," лепила ")
		message = replacetext(message," хоп "," лялька ")
		message = replacetext(message," хос "," начальник ")
		message = replacetext(message," капитан "," хер с горы ")
		message = replacetext(message," сб "," мусора ")
		message = replacetext(message," глава "," бугор ")
		message = replacetext(message," завхоз "," жид ")
		message = replacetext(message," шахтер "," мужик ")
		message = replacetext(message," грузчик "," батрак ")
		message = replacetext(message," оружие "," валына ")
		message = replacetext(message," лазер "," весло ")
		message = replacetext(message," бармен "," бражник ")
		speech_args[SPEECH_MESSAGE] = trim(message)


/datum/mutation/human/elvis
	name = "Элвис"
	desc = "Чудовищная мутация названная в честь нулевого пациента."
	quality = MINOR_NEGATIVE
	locked = TRUE
	text_gain_indication = span_notice("Чувствую себя четко.")
	text_lose_indication = span_notice("А... И так сойдет.")

/datum/mutation/human/elvis/on_life(delta_time, times_fired)
	switch(pick(1,2))
		if(1)
			if(DT_PROB(7.5, delta_time))
				var/list/dancetypes = list("swinging", "fancy", "stylish", "20'th century", "jivin'", "rock and roller", "cool", "salacious", "bashing", "smashing")
				var/dancemoves = pick(dancetypes)
				owner.visible_message("<b>[owner]</b> busts out some [dancemoves] moves!")
		if(2)
			if(DT_PROB(7.5, delta_time))
				owner.visible_message("<b>[owner]</b> [pick("jiggles their hips", "rotates their hips", "gyrates their hips", "taps their foot", "dances to an imaginary song", "jiggles their legs", "snaps their fingers")]!")

/datum/mutation/human/elvis/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/elvis/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/elvis/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		message = replacetext(message," i'm not "," I ain't ")
		message = replacetext(message," girl ",pick(" honey "," baby "," baby doll "))
		message = replacetext(message," man ",pick(" son "," buddy "," brother"," pal "," friendo "))
		message = replacetext(message," out of "," outta ")
		message = replacetext(message," thank you "," thank you, thank you very much ")
		message = replacetext(message," thanks "," thank you, thank you very much ")
		message = replacetext(message," what are you "," whatcha ")
		message = replacetext(message," yes ",pick(" sure", "yea "))
		message = replacetext(message," muh valids "," my kicks ")
		speech_args[SPEECH_MESSAGE] = trim(message)


/datum/mutation/human/stoner
	name = "Торчок"
	desc = "Распространенная мутация, которая сильно снижает интеллект."
	quality = NEGATIVE
	locked = TRUE
	text_gain_indication = span_notice("Чувствую себя... да зашибись себя чувствую, чел!")
	text_lose_indication = span_notice("Отпустило.")

/datum/mutation/human/stoner/on_acquiring(mob/living/carbon/human/owner)
	..()
	owner.grant_language(/datum/language/beachbum, TRUE, TRUE, LANGUAGE_STONER)
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)

/datum/mutation/human/stoner/on_losing(mob/living/carbon/human/owner)
	..()
	owner.remove_language(/datum/language/beachbum, TRUE, TRUE, LANGUAGE_STONER)
	owner.remove_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)

/datum/mutation/human/medieval
	name = "Средневековый"
	desc = "Ужасная мутация, происходящая из далекого прошлого, которая, как считается, когда-то была общим геном во всей Европе старого света."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("Настало время приступить к поискам святого грааля!")
	text_lose_indication = span_notice("А что я вообще искал?")

/datum/mutation/human/medieval/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/medieval/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/medieval/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		var/list/medieval_words = strings("medieval_replacement.json", "medieval")
		var/list/startings = strings("medieval_replacement.json", "startings")
		for(var/key in medieval_words)
			var/value = medieval_words[key]
			if(islist(value))
				value = pick(value)
			if(uppertext(key) == key)
				value = uppertext(value)
			if(capitalize(key) == key)
				value = capitalize(value)
			message = replacetextEx(message,regex("\b[REGEX_QUOTE(key)]\b","ig"), value)
		message = trim(message)
		var/chosen_starting = pick(startings)
		message = "[chosen_starting] [message]"

		speech_args[SPEECH_MESSAGE] = message
