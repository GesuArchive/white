// Для 513 в самый раз
// Люммокс пидорас

/proc/cp1252_to_utf8(text) //Временный прок. Транслирует не всё, но оно и не нужно
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a < 224 || a > 255)
			t += ascii2text(a)
			continue
		t += ascii2text(a + 848)
	return t

/proc/up2ph(text) // реальный рабочий костыль для плеерпанели, желательно не трогать
	for(var/s in GLOB.rus_unicode_conversion)
		text = replacetext(text, s, "&#[GLOB.rus_unicode_conversion[s]];")
	return text

/proc/r_jobgen(text)
	var/list/strip_chars = list("_"," ","(",")")
	for(var/char in strip_chars)
		text = replacetext_char(text, char, "")
	return lowertext(text)

/proc/pointization(text)
	if (!text)
		return
	if (copytext_char(text,1,2) == "*") //Emotes allowed.
		return text
	if (copytext_char(text,-1) in list("!", "?", ".", ":", ";", ","))
		return text
	text += "."
	return text

/proc/r_antidaunize(t as text)
	if(t)
		t = lowertext(t[1]) + copytext(t, 1 + length(t[1]))
	return t

/proc/r_json_decode(text) //now I'm stupid
	for(var/s in GLOB.rus_unicode_conversion_hex)
		text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", s)
	return json_decode(text)

/proc/ru_comms(freq)
	if(freq == "Common")
		return "Основной"
	else if (freq == "Security")
		return "Безопасность"
	else if (freq == "Engineering")
		return "Инженерия"
	else if (freq == "Command")
		return "Командование"
	else if (freq == "Science")
		return "Научный"
	else if (freq == "Medical")
		return "Медбей"
	else if (freq == "Supply")
		return "Снабжение"
	else if (freq == "Service")
		return "Обслуживание"
	else if (freq == "Exploration")
		return "Рейнджеры"
	else if (freq == "AI Private")
		return "Приватный ИИ"
	else if (freq == "Syndicate")
		return "Синдикат"
	else if (freq == "CentCom")
		return "ЦентКом"
	else if (freq == "Red Team")
		return "Советы"
	else if (freq == "Blue Team")
		return "Нацисты"
	else if (freq == "Green Team")
		return "Чечня"
	else if (freq == "Yellow Team")
		return "Хохлы"
	else if (freq == "Yohei")
		return "Криптосвязь"
	else
		return freq

/proc/r_stutter(text) //ненавижу пиндосов
	var/list/soglasnie = list(	"б","в","г","д","ж","з","к","л","м","н","п","р","с","т","ф","х","ц","ч","ш","щ",
								"Б","В","Г","Д","Ж","З","К","Л","М","Н","П","Р","С","Т","Ф","Х","Ц","Ч","Ш","Щ",
								"b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z",
								"B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z")
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (prob(80) && (ascii2text(a) in soglasnie))
			if (prob(10))
				t += text("[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]")
			else
				if (prob(20))
					t += text("[ascii2text(a)]-[ascii2text(a)]-[ascii2text(a)]")
				else
					if (prob(5))
						t += ""
					else
						t += text("[ascii2text(a)]-[ascii2text(a)]")
		t += ascii2text(a)
	return copytext_char(sanitize(t),1,MAX_MESSAGE_LEN * length(ascii2text(text2ascii(t))))

/proc/kartavo(message)
	message = replacetextEx(message, "р", "л")
	message = replacetextEx(message, "Р", "Л")
	return message

/proc/asiatish(message)
	message = replacetext_char(message, "ра", "ля")
	message = replacetext_char(message, "ла", "ля")
	message = replacetext_char(message, "ло", "льо")
	message = replacetext_char(message, "да", "тя")
	message = replacetext_char(message, "бо", "по")
	message = replacetext_char(message, "за", "ся")
	message = replacetext_char(message, "чу", "сю")
	message = replacetext_char(message, "та", "тя")
	message = replacetext_char(message, "же", "се")
	message = replacetext_char(message, "хо", "ха")
	message = replacetext_char(message, "гд", "кт")
	message = replacetextEx(message, "д", "т")
	message = replacetextEx(message, "ч", "с")
	message = replacetextEx(message, "з", "с")
	message = replacetextEx(message, "р", "л")
	message = replacetextEx(message, "ы", "и")
	message = replacetextEx(message, "Д", "Т")
	message = replacetextEx(message, "Ч", "С")
	message = replacetextEx(message, "З", "С")
	message = replacetextEx(message, "Р", "Л")
	message = replacetextEx(message, "Ы", "И")
	return message

/datum/quirk/asiat
	name = "Азиат"
	desc = "Долгое время работы в рисовых полях и жара палящего сверху солнца даровала вам этот прекрасный акцент."
	value = 0
	mob_trait = TRAIT_ASIAT
	gain_text = span_notice("Чиньг-чоньг!.")
	lose_text = span_danger("Аниме говно.")
	medical_record_text = "Пациент - азиат."

/datum/quirk/kartavii
	name = "Картавый"
	desc = "Вы не знаете, как проговаривать букву \"Р\"."
	value = 0
	mob_trait = TRAIT_KARTAVII
	gain_text = span_notice("Забываю как проговаривать букву \"Р\".")
	lose_text = span_danger("Вспоминаю как проговаривать букву \"Р\".")
	medical_record_text = "Пациент не может проговаривать букву \"Р\"."


/mob/living/carbon/human/proc/get_race_text()
	switch(skin_tone)
		if("asian1", "asian2")
			return pick("ускоглазый", "узкопленочный", "чалма", "чурка", "чучмек", "кырдым-бырдым", "самурай")
		if("arab")
			return pick("хач", "сарацин", "палестинец")
		if("indian")
			return pick("цыган", "индус")
		if("african1", "african2")
			return pick("негр", "черномазый", "уголёк", "черножопая гнида", "негативчик", "сникерс", "черный", "копченый", "негритос", "мумба-юмба", "трюфель")
		else
			return null

/mob/living/carbon/human/proc/get_age_text()
	switch(age)
		if(-INFINITY to 16)
			return "ребёнок"
		if(17 to 21)
			return "подросток"
		if(22 to 35)
			return gender == FEMALE ? "девушка" : "парень"
		if(36 to 44)
			return gender == FEMALE ? "женщина" : "мужчина"
		if(45 to 60)
			return gender == FEMALE ? "зрелая женщина" : "зрелый мужчина"
		if(61 to 75)
			return gender == FEMALE ? "пожилая женщина" : "пожилой мужчина"
		if(76 to INFINITY)
			return gender == FEMALE ? "старушка" : "старик"

/proc/ddlc_text(text)
	var/t = ""
	for(var/i = 1, i <= length_char(text), i++)
		t += pick(GLOB.ddlc_chars)
	return t
