////////////////////////////////////////////////////////////////////////////////
//
//
// Этот код написан демонами в подвале и куском валтоса.
// Если собираетесь копипастить это, то рекомендуется ничего здесь не трогать или оно сломается нахуй.
// Я предупредил.
//
//
////////////////////////////////////////////////////////////////////////////////


/client/proc/fuck_pie()
	set name = "Test Name Sklonenie"
	set category = "Особенное"
	var/pizdos = input("ВВЕДИТЕ ХУЙ")
	if(pizdos)
		to_chat(src, "Начальное слово: [pizdos]")

		to_chat(src, "Ж. Родительный: [skloname(pizdos, RODITELNI, 	"female")]")
		to_chat(src, "Ж. Дательный: [skloname(pizdos,   DATELNI, 		"female")]")
		to_chat(src, "Ж. Винительный: [skloname(pizdos, VINITELNI, 	"female")]")
		to_chat(src, "Ж. Творительный: [skloname(pizdos,TVORITELNI, 	"female")]")
		to_chat(src, "Ж. Предложный: [skloname(pizdos,  PREDLOZHNI, 	"female")]")

		to_chat(src, "М. Родительный: [skloname(pizdos, RODITELNI, 	"male")]")
		to_chat(src, "М. Дательный: [skloname(pizdos, 	 DATELNI, 		"male")]")
		to_chat(src, "М. Винительный: [skloname(pizdos, VINITELNI, 	"male")]")
		to_chat(src, "М. Творительный: [skloname(pizdos,TVORITELNI, 	"male")]")
		to_chat(src, "М. Предложный: [skloname(pizdos,  PREDLOZHNI, 	"male")]")

		to_chat(src, "С. Родительный: [skloname(pizdos, RODITELNI)]")
		to_chat(src, "С. Дательный: [skloname(pizdos,   DATELNI)]")
		to_chat(src, "С. Винительный: [skloname(pizdos, VINITELNI)]")
		to_chat(src, "С. Творительный: [skloname(pizdos,TVORITELNI)]")
		to_chat(src, "С. Предложный: [skloname(pizdos,  PREDLOZHNI)]")

/proc/sklonenie_item_tvor(msgfrom as text)
	if(length(msgfrom) <= 2)
		return msgfrom
	var/word_end = copytext_char(msgfrom, -2)
	if(word_end == "ёт" || word_end == "ет")
		return replacetext_char(msgfrom, copytext_char(word_end, -2), "ю ", -2)
	else if (word_end == "бит")
		return replacetext_char(msgfrom, copytext_char(word_end, -3), "блю", -2)
	else if (word_end == "нит")
		return replacetext_char(msgfrom, copytext_char(word_end, -3), "ню", -2)
	else if (word_end == "рю")
		return replacetext_char(msgfrom, copytext_char(word_end, -2), "ню", -2)
	return msgfrom

/proc/skloname(msgfrom as text, rule, gender = null)
	var/to_ret = ""
	for(var/word in splittext_char(msgfrom, " "))
		to_ret += " [skloname_do(word, rule, gender)]"
	return copytext_char(to_ret, 2)

GLOBAL_LIST_INIT(PfemaleOneStop, 		list("б","в","г","д","ж",
											 "з","й","к","л","м",
											 "н","п","р","с","т",
											 "ф","х","ц","ч","ш",
											 "щ","ъ","ь"))
GLOBAL_LIST_INIT(POneStop, 				list("о","е","ё","э","и",
											 "ы","у","ю"))
GLOBAL_LIST_INIT(PTwoStop, 				list("ия","иа","аа","оа","уа",
											 "ыа","еа","юа","эа","их",
											 "ых"))
GLOBAL_LIST_INIT(PfemaleOneFrom, 		list("ь"))
GLOBAL_LIST_INIT(PfemaleOneTo, 			list("и","и","ь","ю","и"))
GLOBAL_LIST_INIT(PmaleOneFrom, 			list("ь"))
GLOBAL_LIST_INIT(PmaleOneTo, 			list("я","ю","я","ем","е"))
GLOBAL_LIST_INIT(PfemaleTwoFrom, 		list("ая","на"))
GLOBAL_LIST_INIT(PfemaleTwoTo, 			list("ой","ой","ую","ой","ой",
											 "ой","ой","у","ой","ой"))
GLOBAL_LIST_INIT(PfemaleThreeFrom, 		list("ска","цка"))
GLOBAL_LIST_INIT(PfemaleThreeTo, 		list("ой","ой","ую","ой","ой"))
GLOBAL_LIST_INIT(POneFrom, 				list("а","ь","я","й"))
GLOBAL_LIST_INIT(POneTo, 				list("ы","е","у","ой","е",
											 "я","ю","я","ем","е",
											 "и","у","ю","ей","е",
											 "я","ю","я","ем","е"))
GLOBAL_LIST_INIT(POneListFrom, 			list("ц","ч","ш","щ"))
GLOBAL_LIST_INIT(POneListTo, 			list("а","у","а","ем","е"))
GLOBAL_LIST_INIT(POneListOtherFrom, 	list("б","в","г","д","ж",
											 "з","к","л","м","н",
											 "п","р","с","т","ф",
											 "х","ц","ч"))
GLOBAL_LIST_INIT(POneListOtherTo, 		list("а","у","а","ом","е"))
GLOBAL_LIST_INIT(POneListTooFrom, 		list("в","н"))
GLOBAL_LIST_INIT(POneListTooTo, 		list("а","у","а","ым","е"))
GLOBAL_LIST_INIT(PTwoFrom, 				list("ич","ша","ия","ей","ий",
											 "на","уй","ца","ай","ой",
											 "ок","ец"))
GLOBAL_LIST_INIT(PTwoTo, 				list("а", "у", "а", "ем", "е",
											 "и", "е", "у", "ей", "е",
											 "и", "и", "ю", "ей", "и",
											 "я", "ю", "я", "ем", "е",
											 "я", "ю", "я", "ем", "и",
											 "ы", "е", "у", "ой", "е",
											 "я", "ю", "я", "ем", "е",
											 "ы", "е", "у", "её", "е",
											 "я", "ю", "я", "ем", "е",
											 "го","му","го","ым", "м",
											 "ка","ку","ка","ком","ке",
											 "ца","цу","ца","цом","це"))
GLOBAL_LIST_INIT(PTwoListFrom, 			list("га","ка","ха","ча","ща",
											 "жа"))
GLOBAL_LIST_INIT(PTwoListTo, 			list("и","е","у","ой","е"))
GLOBAL_LIST_INIT(PTwoListOtherFrom, 	list("ян","ан","йн","ах","ив"))
GLOBAL_LIST_INIT(PTwoListOtherTo, 		list("а","у","а","ом","е"))
GLOBAL_LIST_INIT(PThreeFrom, 			list("рих"))
GLOBAL_LIST_INIT(PThreeTo, 				list("а","у","а","ом","е"))
GLOBAL_LIST_INIT(PThreeListFrom, 		list("ова","ева"))
GLOBAL_LIST_INIT(PThreeListTo, 			list("ой","ой","у","ой","ой"))
GLOBAL_LIST_INIT(PThreeListOtherFrom, 	list("гой","кой"))
GLOBAL_LIST_INIT(PThreeListOtherTo, 	list("го","му","го","им","м"))
GLOBAL_LIST_INIT(PThreeListTooFrom,		list("ший","щий","жий","ний"))
GLOBAL_LIST_INIT(PThreeListTooTo, 		list("его","ему","его","м","ем"))
GLOBAL_LIST_INIT(POtherListTo, 			list("ого","ому","ого","м","ом"))
GLOBAL_LIST_INIT(PFourFrom, 			list("ская"))
GLOBAL_LIST_INIT(PFourTo, 				list("ой","ой","ую","ой","ой"))
GLOBAL_LIST_INIT(PFourOtherFrom, 		list("иной"))
GLOBAL_LIST_INIT(PFourOtherTo, 			list("я","ю","я","ем","е"))
GLOBAL_LIST_INIT(PFourListFrom, 		list("ынец","обец"))
GLOBAL_LIST_INIT(PFourListTo, 			list("ца","цу","ца","цем","це"))
GLOBAL_LIST_INIT(PFourListOtherFrom, 	list("онец","овец"))
GLOBAL_LIST_INIT(PFourListOtherTo, 		list("ца","цу","ца","цом","це"))

/proc/skloname_do(msgfrom as text, rule, gender = null)
	if(length(msgfrom) <= 2)
		return msgfrom

	var/word_end = ""
	var/i = 0

	//берём последние 2 буквы
	word_end = copytext_char(msgfrom, -2)

	for(var/end in GLOB.PTwoStop)
		if(end == word_end)
			return msgfrom

	//берём последнюю букву
	word_end = copytext_char(msgfrom, -1)

	for(var/end in GLOB.POneStop)
		if(end == word_end)
			return msgfrom

	if(gender == "male")
		for(var/end in GLOB.PmaleOneFrom)
			if(end == word_end)
				return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PmaleOneTo[rule], -1)

	if(gender == "female")
		//берём последние 3 буквы
		word_end = copytext_char(msgfrom, -3)

		for(var/end in GLOB.PfemaleThreeFrom)
			if(end == word_end)
				return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PfemaleThreeTo[rule], -3)

		//берём последние 2 буквы
		word_end = copytext_char(msgfrom, -2)

		for(var/end in GLOB.PfemaleTwoFrom)
			if(end == word_end)
				if(i == 0)
					return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PfemaleTwoTo[rule], -2)
				else
					return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PfemaleTwoTo[rule + 5], -2)
			i++

		for(var/end in GLOB.PfemaleOneFrom)
			if(end == word_end)
				if(rule == VINITELNI || rule == TVORITELNI)
					return "[msgfrom][GLOB.PfemaleOneTo[rule]]"
				return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PfemaleOneTo[rule], -1)

		for(var/end in GLOB.PfemaleOneStop)
			if(end == word_end)
				return msgfrom

	//берём последние 4 буквы
	word_end = copytext_char(msgfrom, -4)

	for(var/end in GLOB.PFourFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PFourTo[rule], -4)

	for(var/end in GLOB.PFourOtherFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PFourOtherTo[rule], -4)

	for(var/end in GLOB.PFourListFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PFourListTo[rule], -4)

	for(var/end in GLOB.PFourListOtherFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PFourListOtherTo[rule], -4)

	//берём последние 3 буквы
	word_end = copytext_char(msgfrom, -3)

	for(var/end in GLOB.PThreeFrom)
		if(end == word_end)
			return "[msgfrom][GLOB.PThreeTo[rule]]"

	for(var/end in GLOB.PThreeListFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PThreeListTo[rule], -3)

	for(var/end in GLOB.PThreeListOtherFrom)
		if(end == word_end)
			if(rule == TVORITELNI)
				return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PThreeListOtherTo[rule], -3)
			return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PThreeListOtherTo[rule], -3)

	for(var/end in GLOB.PThreeListTooFrom)
		if(end == word_end)
			if(rule == TVORITELNI)
				return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PThreeListTooTo[rule], -3)
			return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PThreeListTooTo[rule], -3)

	if("кий" == word_end)
		if(rule == TVORITELNI)
			return replacetext_char(msgfrom, copytext_char("кий", -1), GLOB.POtherListTo[rule], -3)
		return replacetext_char(msgfrom, copytext_char("кий", -2), GLOB.POtherListTo[rule], -3)

	//берём последние 2 буквы
	word_end = copytext_char(msgfrom, -2)

	i = 0
	for(var/end in GLOB.PTwoFrom)
		if(end == word_end)
			if(i == 0)
				return "[msgfrom][GLOB.PTwoTo[rule]]"
			if(i <= 9)
				return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PTwoTo[rule + (5 * i)], -2)
			else
				return replacetext_char(msgfrom, copytext_char(end, -2), GLOB.PTwoTo[rule + (5 * i)], -2)
		i++

	for(var/end in GLOB.PTwoListFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.PTwoListTo[rule], -2)

	for(var/end in GLOB.PTwoListOtherFrom)
		if(end == word_end)
			return "[msgfrom][GLOB.PTwoListOtherTo[rule]]"

	if("ый" == word_end)
		if(rule == TVORITELNI)
			return replacetext_char(msgfrom, copytext_char("ый", -1), GLOB.POtherListTo[rule], -2)
		return replacetext_char(msgfrom, copytext_char("ый", -2), GLOB.POtherListTo[rule], -2)

	//берём последюю букву
	word_end = copytext_char(msgfrom, -1)

	i = 0
	for(var/end in GLOB.POneFrom)
		if(end == word_end)
			return replacetext_char(msgfrom, copytext_char(end, -1), GLOB.POneTo[rule + (5 * i)], -1)
		i++

	for(var/end in GLOB.POneListFrom)
		if(end == word_end)
			return "[msgfrom][GLOB.POneListTo[rule]]"

	for(var/end in GLOB.POneListOtherFrom)
		if(end == word_end)
			return "[msgfrom][GLOB.POneListOtherTo[rule]]"

	for(var/end in GLOB.POneListTooFrom)
		if(end == word_end)
			return "[msgfrom][GLOB.POneListTooTo[rule]]"

	return msgfrom // возвращаем слово, если оно чудом не нашло своего конца
