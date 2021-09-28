// Для 513 в самый раз
// Люммокс пидорас

// вот этот лист вообще подтверждает мои слова ещё раз

GLOBAL_LIST_INIT(rus_unicode_conversion,list(
	"А" = "1040", "а" = "1072",
	"Б" = "1041", "б" = "1073",
	"В" = "1042", "в" = "1074",
	"Г" = "1043", "г" = "1075",
	"Д" = "1044", "д" = "1076",
	"Е" = "1045", "е" = "1077",
	"Ж" = "1046", "ж" = "1078",
	"З" = "1047", "з" = "1079",
	"И" = "1048", "и" = "1080",
	"Й" = "1049", "й" = "1081",
	"К" = "1050", "к" = "1082",
	"Л" = "1051", "л" = "1083",
	"М" = "1052", "м" = "1084",
	"Н" = "1053", "н" = "1085",
	"О" = "1054", "о" = "1086",
	"П" = "1055", "п" = "1087",
	"Р" = "1056", "р" = "1088",
	"С" = "1057", "с" = "1089",
	"Т" = "1058", "т" = "1090",
	"У" = "1059", "у" = "1091",
	"Ф" = "1060", "ф" = "1092",
	"Х" = "1061", "х" = "1093",
	"Ц" = "1062", "ц" = "1094",
	"Ч" = "1063", "ч" = "1095",
	"Ш" = "1064", "ш" = "1096",
	"Щ" = "1065", "щ" = "1097",
	"Ъ" = "1066", "ъ" = "1098",
	"Ы" = "1067", "ы" = "1099",
	"Ь" = "1068", "ь" = "1100",
	"Э" = "1069", "э" = "1101",
	"Ю" = "1070", "ю" = "1102",
	"Я" = "1071", "я" = "1103",

	"Ё" = "1025", "ё" = "1105"
	))

GLOBAL_LIST_INIT(rus_unicode_conversion_hex,list(
	"А" = "0410", "а" = "0430",
	"Б" = "0411", "б" = "0431",
	"В" = "0412", "в" = "0432",
	"Г" = "0413", "г" = "0433",
	"Д" = "0414", "д" = "0434",
	"Е" = "0415", "е" = "0435",
	"Ж" = "0416", "ж" = "0436",
	"З" = "0417", "з" = "0437",
	"И" = "0418", "и" = "0438",
	"Й" = "0419", "й" = "0439",
	"К" = "041a", "к" = "043a",
	"Л" = "041b", "л" = "043b",
	"М" = "041c", "м" = "043c",
	"Н" = "041d", "н" = "043d",
	"О" = "041e", "о" = "043e",
	"П" = "041f", "п" = "043f",
	"Р" = "0420", "р" = "0440",
	"С" = "0421", "с" = "0441",
	"Т" = "0422", "т" = "0442",
	"У" = "0423", "у" = "0443",
	"Ф" = "0424", "ф" = "0444",
	"Х" = "0425", "х" = "0445",
	"Ц" = "0426", "ц" = "0446",
	"Ч" = "0427", "ч" = "0447",
	"Ш" = "0428", "ш" = "0448",
	"Щ" = "0429", "щ" = "0449",
	"Ъ" = "042a", "ъ" = "044a",
	"Ы" = "042b", "ы" = "044b",
	"Ь" = "042c", "ь" = "044c",
	"Э" = "042d", "э" = "044d",
	"Ю" = "042e", "ю" = "044e",
	"Я" = "042f", "я" = "044f",

	"Ё" = "0401", "ё" = "0451"
	))


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

/proc/difilexish(message)
	if(prob(25))
		message = "Таки... [message]"
	message = replacetextEx(message, "р", "г'")
	message = replacetextEx(message, "Р", "Г'")
	return message

/proc/ukrainish(message)
	message = replacetext_char(message, "здравствуйте", "здрастуйтэ")
	message = replacetext_char(message, "привет", "прывит")
	message = replacetext_char(message, "утро", "ранку")
	message = replacetext_char(message, "как", "як")
	message = replacetext_char(message, "извините", "я выбачаюсь")
	message = replacetext_char(message, "свидания", "побачэння")
	message = replacetext_char(message, "понимаю", "розумию")
	message = replacetext_char(message, "спасибо", "дякую")
	message = replacetext_char(message, "пожалуйста", "будь-ласка")
	message = replacetext_char(message, "зовут", "зваты")
	message = replacetext_char(message, "меня", "мэнэ")
	message = replacetext_char(message, "кто", "хто")
	message = replacetext_char(message, "нибудь", "нэбудь")
	message = replacetext_char(message, "говорит", "розмовляйе")
	message = replacetext_char(message, "заблудился", "заблукав")
	message = replacetext_char(message, "понял", "зрозумил")
	message = replacetext_char(message, "не", "нэ")
	message = replacetext_char(message, "тебя", "тэбе")
	message = replacetext_char(message, "люблю", "кохаю")
	message = replacetextEx(message, "и", "i")
	message = replacetextEx(message, "ы", "и")
	message = replacetextEx(message, "И", "I")
	message = replacetextEx(message, "Ы", "И")
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

/datum/quirk/kartavii
	name = "Картавый"
	desc = "Вы не знаете, как проговаривать букву \"Р\"."
	value = 0
	mob_trait = TRAIT_KARTAVII
	gain_text = span_notice("Забываю как проговаривать букву \"Р\".")
	lose_text = span_danger("Вспоминаю как проговаривать букву \"Р\".")
	medical_record_text = "Пациент не может проговаривать букву \"Р\"."

/datum/quirk/jewish
	name = "Еврей"
	desc = "Я таки умею считать деньги."
	value = 4 // гоев проще наёбывать
	mob_trait = TRAIT_JEWISH
	gain_text = span_notice("Теперь я знаю цену вещам.")
	lose_text = span_danger("Забываю цену вещам.")
	medical_record_text = "Пациент имеет удивительные навыки в оценке стоимости вещей."

/datum/quirk/ukrainish
	name = "Украинец"
	desc = "Бахнуть бы сала..."
	value = 0
	mob_trait = TRAIT_UKRAINISH
	gain_text = span_notice("Дайте мне, будь ласка, сала.")
	lose_text = span_danger("Забываю запах сала.")
	medical_record_text = "Пациент имеет страсть к салу."

/datum/quirk/ukrainish/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(ishumanbasic(H))
		H.grant_language(/datum/language/xoxol)

/datum/quirk/ukrainish/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(ishumanbasic(H))
		H.remove_language(/datum/language/xoxol)

/datum/quirk/asiat
	name = "Азиат"
	desc = "Долгое время работы в рисовых полях и жара палящего сверху солнца даровала вам этот прекрасный акцент."
	value = 0
	mob_trait = TRAIT_ASIAT
	gain_text = span_notice("Чиньг-чоньг!.")
	lose_text = span_danger("Аниме говно.")
	medical_record_text = "Пациент - азиат."

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
