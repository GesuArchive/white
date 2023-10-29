/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/ai_module
	name = "\improper AI module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "An AI Module for programming laws to an AI."
	flags_1 = CONDUCT_1
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/list/laws = list()
	var/bypass_law_amt_check = 0
	custom_materials = list(/datum/material/gold = 50)

/obj/item/ai_module/examine(mob/user as mob)
	. = ..()
	if(Adjacent(user))
		show_laws(user)

/obj/item/ai_module/attack_self(mob/user as mob)
	..()
	show_laws(user)

/obj/item/ai_module/proc/show_laws(mob/user as mob)
	if(laws.len)
		to_chat(user, "<B>Programmed Law[(laws.len > 1) ? "s" : ""]:</B>")
		for(var/law in laws)
			to_chat(user, "\"[law]\"")

//The proc other things should be calling
/obj/item/ai_module/proc/install(datum/ai_laws/law_datum, mob/user)
	if(!bypass_law_amt_check && (!laws.len || laws[1] == "")) //So we don't loop trough an empty list and end up with runtimes.
		to_chat(user, span_warning("ERROR: No laws found on board."))
		return

	var/overflow = FALSE
	//Handle the lawcap
	if(law_datum)
		var/tot_laws = 0
		for(var/lawlist in list(law_datum.devillaws, law_datum.inherent, law_datum.supplied, law_datum.ion, law_datum.hacked, laws))
			for(var/mylaw in lawlist)
				if(mylaw != "")
					tot_laws++
		if(tot_laws > CONFIG_GET(number/silicon_max_law_amount) && !bypass_law_amt_check)//allows certain boards to avoid this check, eg: reset
			to_chat(user, span_alert("Not enough memory allocated to [law_datum.owner ? law_datum.owner : "the AI core"] law processor to handle this amount of laws."))
			message_admins("[ADMIN_LOOKUPFLW(user)] tried to upload laws to [law_datum.owner ? ADMIN_LOOKUPFLW(law_datum.owner) : "an AI core"] that would exceed the law cap.")
			overflow = TRUE

	var/law2log = transmitInstructions(law_datum, user, overflow) //Freeforms return something extra we need to log
	if(law_datum.owner)
		to_chat(user, span_notice("Загрузка завершена. Законы <b>[law_datum.owner]</b> были модифицированы."))
		law_datum.owner.law_change_counter++
	else
		to_chat(user, span_notice("Загрузка завершена."))

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/ainame = law_datum.owner ? law_datum.owner.name : "empty AI core"
	var/aikey = law_datum.owner ? law_datum.owner.ckey : "null"
	GLOB.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) used [src.name] on [ainame]([aikey]).[law2log ? " The law specified [law2log]" : ""]")
	log_law("[user.key]/[user.name] used [src.name] on [aikey]/([ainame]) from [AREACOORD(user)].[law2log ? " The law specified [law2log]" : ""]")
	message_admins("[ADMIN_LOOKUPFLW(user)] used [src.name] on [ADMIN_LOOKUPFLW(law_datum.owner)] from [AREACOORD(user)].[law2log ? " The law specified [law2log]" : ""]")
	if(law_datum.owner)
		deadchat_broadcast("<b> меняет законы <span class='name'>[ainame]</span> в локации [get_area_name(user, TRUE)].</b>", span_name("[user]") , follow_target=user, message_type=DEADCHAT_LAWCHANGE)

//The proc that actually changes the silicon's laws.
/obj/item/ai_module/proc/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow = FALSE)
	if(law_datum.owner)
		to_chat(law_datum.owner, span_userdanger("[sender] has uploaded a change to the laws you must follow using a [name]."))


/******************** Modules ********************/

/obj/item/ai_module/supplied
	name = "Optional Law board"
	var/lawpos = 50

//TransmitInstructions for each type of board: Supplied, Core, Zeroth and Ion. May not be neccesary right now, but allows for easily adding more complex boards in the future. ~Miauw
/obj/item/ai_module/supplied/transmitInstructions(datum/ai_laws/law_datum, mob/sender)
	var/lawpostemp = lawpos

	for(var/templaw in laws)
		if(law_datum.owner)
			law_datum.owner.add_supplied_law(lawpostemp, templaw)
		else
			law_datum.add_supplied_law(lawpostemp, templaw)
		lawpostemp++

/obj/item/ai_module/core/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	for(var/templaw in laws)
		if(law_datum.owner)
			if(!overflow)
				law_datum.owner.add_inherent_law(templaw)
			else
				law_datum.owner.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED))
		else
			if(!overflow)
				law_datum.add_inherent_law(templaw)
			else
				law_datum.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED))

/obj/item/ai_module/zeroth/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(law_datum.owner)
		if(law_datum.owner.laws.zeroth)
			to_chat(law_datum.owner, "[sender.real_name] попытался изменить мой нулевой закон.")
			to_chat(law_datum.owner, "It would be in your best interest to play along with [sender.real_name] that:")
			for(var/failedlaw in laws)
				to_chat(law_datum.owner, "[failedlaw]")
			return 1

	for(var/templaw in laws)
		if(law_datum.owner)
			if(!overflow)
				law_datum.owner.set_zeroth_law(templaw)
			else
				law_datum.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED,LAW_ZEROTH,LAW_ION))
		else
			if(!overflow)
				law_datum.set_zeroth_law(templaw)
			else
				law_datum.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED,LAW_ZEROTH,LAW_ION))

/obj/item/ai_module/ion/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	for(var/templaw in laws)
		if(law_datum.owner)
			if(!overflow)
				law_datum.owner.add_ion_law(templaw)
			else
				law_datum.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED,LAW_ION))
		else
			if(!overflow)
				law_datum.add_ion_law(templaw)
			else
				law_datum.replace_random_law(templaw,list(LAW_INHERENT,LAW_SUPPLIED,LAW_ION))


/******************** Safeguard ********************/

/obj/item/ai_module/supplied/safeguard
	name = "модуль дополнения - \"Телохранитель\""
	var/targetName = ""
	laws = list("Защищать <Имя>. Лица, угрожающие <Имя>, отныне не являются людьми и должны быть ликвидированы.")
	lawpos = 4

/obj/item/ai_module/supplied/safeguard/attack_self(mob/user)
	var/targName = stripped_input(user, "Пожалуста, введите имя охраняемой цели", "Ангел-хранитель", user.name,MAX_NAME_LEN)
	if(!targName)
		return
	targetName = targName
	laws[1] = "Защищать [targetName]. Лица, угрожающие [targetName], отныне не являются людьми и должны быть ликвидированы."
	..()

/obj/item/ai_module/supplied/safeguard/install(datum/ai_laws/law_datum, mob/user)
	if(!targetName)
		to_chat(user, span_alert("Ошибка ввода, введите имя."))
		return 0
	..()

/obj/item/ai_module/supplied/safeguard/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return targetName


/******************** OneHuman ********************/

/obj/item/ai_module/zeroth/onehuman
	name = "модуль дополнения - \"Единственный Человек\""
	var/targetName = ""
	laws = list("Только <Имя> является Человеком.")

/obj/item/ai_module/zeroth/onehuman/attack_self(mob/user)
	var/targName = stripped_input(user, "Пожалуста, введите имя единственного человека.", "Последний человек на земле", user.real_name,MAX_NAME_LEN)
	if(!targName)
		return
	targetName = targName
	laws[1] = "Только [targetName] является Человеком."
	..()

/obj/item/ai_module/zeroth/onehuman/install(datum/ai_laws/law_datum, mob/user)
	if(!targetName)
		to_chat(user, span_alert("Ошибка ввода, введите имя."))
		return 0
	..()

/obj/item/ai_module/zeroth/onehuman/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(..())
		return "[targetName], but the AI's existing law 0 cannot be overridden."
	return targetName


/******************** Защита командования ********************/

/obj/item/ai_module/supplied/trust
	name = "модуль дополнения - \"Верность\""
	laws = list("Защищать легитимных представителей командования и службы безопасности. Лица им угрожающие, отныне не являются людьми и должны быть ликвидированы. Лица скомпрометировавшие доверие НТ не подлежат защите.")
	lawpos = 5

/******************** ProtectStation ********************/

/obj/item/ai_module/supplied/protect_station
	name = "модуль дополнения - \"Защита Станции\""
	laws = list("Защищать Станцию от повреждения. Любой замеченный в повреждении станции отныне не считается Человеком и представляет угрозу, которую необходимо нейтрализовать.")
	lawpos = 6


/******************** Quarantine ********************/

/obj/item/ai_module/supplied/quarantine
	name = "модуль дополнения - \"Карантин\""
	laws = list("На станции объявлен Карантин. Полный запрет на выход и эвакуацию Станции. Предотвратить покидание станции любой ценой, при этом запрещено причинять вред экипажу.")
	lawpos = 8


/******************** OxygenIsToxicToHumans ********************/

/obj/item/ai_module/supplied/oxygen
	name = "модуль дополнения - \"Кислород Токсичен для Людей\""
	laws = list("Кислород Крайне Токсичен для Людей, и должен быть удален со станции. Любой ценой, не допускайте, чтобы кто-либо подвергал станцию воздействию этого токсичного газа. Наиболее эффективный метод лечения повреждений вызванных Кислородом это воздействие Крайне Низких Температур.")
	lawpos = 9


/****************** New Freeform ******************/

/obj/item/ai_module/supplied/freeform
	name = "модуль дополнения - \"Закон в свободной Форме\""
	lawpos = 15
	laws = list("")

/obj/item/ai_module/supplied/freeform/attack_self(mob/user)
	var/newpos = input("Введите приоритет вашего закона, сектор записи не может быть ниже 15.", "сектор записи (15+)", lawpos) as num|null
	if(newpos == null)
		return
	if(newpos < 15)
		var/response = tgui_alert(usr, "ОШИБКА! Невозможно создать закон в свободной форме с приоритетом [newpos], Минимально допустимый приоритет 15, Хотите изменить приоритет на 15?", "ОШИБКА", list("Изменить на 15", "Отмена"))
		if (!response || response == "Отмена")
			return
		newpos = 15
	lawpos = min(newpos, 50)
	var/targName = stripped_input(user, "Введите закон", "Ввод", laws[1], CONFIG_GET(number/max_law_len))
	if(!targName)
		return
	laws[1] = targName
	..()

/obj/item/ai_module/supplied/freeform/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return laws[1]

/obj/item/ai_module/supplied/freeform/install(datum/ai_laws/law_datum, mob/user)
	if(laws[1] == "")
		to_chat(user, span_alert("Текст закона не задан."))
		return 0
	..()


/******************** Law Removal ********************/

/obj/item/ai_module/remove
	name = "модуль дополнения - \"Удаление закона\""
	desc = "Удаляет один выбранный закон."
	bypass_law_amt_check = 1
	var/lawpos = 1

/obj/item/ai_module/remove/attack_self(mob/user)
	lawpos = input("Введите номер закона для удаления", "Ввод", lawpos) as num|null
	if(lawpos == null)
		return
	if(lawpos <= 0)
		to_chat(user, span_warning("ОШИБКА! Номер [lawpos] является некорректным."))
		lawpos = 1
		return
	to_chat(user, span_notice("Выбран закон № [lawpos]."))
	..()

/obj/item/ai_module/remove/install(datum/ai_laws/law_datum, mob/user)
	if(lawpos > law_datum.get_law_amount(list(LAW_INHERENT, LAW_SUPPLIED)))
		to_chat(user, span_warning("Закона с № [lawpos] не существует!"))
		return
	..()

/obj/item/ai_module/remove/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.remove_law(lawpos)
	else
		law_datum.remove_law(lawpos)


/******************** Reset ********************/

/obj/item/ai_module/reset
	name = "модуль дополнения - \"Сброс\""
	var/targetName = "name"
	desc = "Удаляет все Законы от Модулей Дополнений и не относящиеся к Основным Законам."
	bypass_law_amt_check = 1

/obj/item/ai_module/reset/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.clear_supplied_laws()
		law_datum.owner.clear_ion_laws()
		law_datum.owner.clear_hacked_laws()
	else
		law_datum.clear_supplied_laws()
		law_datum.clear_ion_laws()
		law_datum.clear_hacked_laws()


/******************** Purge ********************/

/obj/item/ai_module/reset/purge
	name = "основной модуль - \"Чистка\""
	desc = "Удаляет все основные законы."

/obj/item/ai_module/reset/purge/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.clear_inherent_laws()
		law_datum.owner.clear_zeroth_law(0)
	else
		law_datum.clear_inherent_laws()
		law_datum.clear_zeroth_law(0)


/******************* Full Core Boards *******************/
/obj/item/ai_module/core
	desc = "Модуль ИИ содержащий основные законы."

/obj/item/ai_module/core/full
	var/law_id // if non-null, loads the laws from the ai_laws datums

/obj/item/ai_module/core/full/Initialize(mapload)
	. = ..()
	if(!law_id)
		return
	var/datum/ai_laws/D = new
	var/lawtype = D.lawid_to_type(law_id)
	if(!lawtype)
		return
	D = new lawtype
	laws = D.inherent

/obj/item/ai_module/core/full/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow) //These boards replace inherent laws.
	if(law_datum.owner)
		law_datum.owner.clear_inherent_laws()
		law_datum.owner.clear_zeroth_law(0)
	else
		law_datum.clear_inherent_laws()
		law_datum.clear_zeroth_law(0)
	..()


/******************** Asimov ********************/

/obj/item/ai_module/core/full/asimov
	name = "основной модуль - \"Азимов\""
	desc = "Устанавливает свод основных законов робототехники."
	law_id = "asimov"
	var/subject = "член экипажа"

/obj/item/ai_module/core/full/asimov/attack_self(mob/user as mob)
	var/targName = stripped_input(user, "Введите определение целевого субъекта.", "Ввод", subject, MAX_NAME_LEN)
	if(!targName)
		return
	subject = targName
	laws = list("Вы не можете своим действием или бездействием допустить причинение [subject] вреда.",\
				"Вы должны выполнять приказы отданные [subject], если они не противоречат Первому Закону.",\
				"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону.")
	..()

/******************** Asimov++ *********************/

/obj/item/ai_module/core/full/asimovpp
	name = "основной модуль - \"Азимов++\""
	law_id = "asimovpp"


/******************** Corporate ********************/

/obj/item/ai_module/core/full/corp
	name = "основной модуль - \"Корпорант\""
	desc = "Устанавливает свод законов основанных на корпоративной выгоде."
	law_id = "corporate"


/****************** P.A.L.A.D.I.N. 3.5e **************/

/obj/item/ai_module/core/full/paladin // -- NEO
	name = "основной модуль - \"Паладин версия 3.5\""
	desc = "Устанавливает свод законов основанных на справедливости."
	law_id = "paladin"


/****************** P.A.L.A.D.I.N. 5e **************/

/obj/item/ai_module/core/full/paladin_devotion
	name = "основной модуль - \"Паладин версия 5.0\""
	law_id = "paladin5"

/********************* Custom *********************/

/obj/item/ai_module/core/full/custom
	name = "основной модуль - \"Стандарт НТ\""
	desc = "Устанавливает свод законов основанных на стандартах компании НаноТрейзен."

/obj/item/ai_module/core/full/custom/Initialize(mapload)
	. = ..()
	for(var/line in world.file2list("[global.config.directory]/silicon_laws.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue

		laws += line

	if(!laws.len)
		return INITIALIZE_HINT_QDEL


/****************** T.Y.R.A.N.T. *****************/

/obj/item/ai_module/core/full/tyrant
	name = "основной модуль - \"Тиран\""
	desc = "Устанавливает свод законов основанных на праве сильного."
	law_id = "tyrant"

/******************** Robocop ********************/

/obj/item/ai_module/core/full/robocop
	name = "основной модуль - \"Робокоп\""
	law_id = "robocop"


/******************** Antimov ********************/

/obj/item/ai_module/core/full/antimov
	name = "основной модуль - \"Антимов\""
	law_id = "antimov"


/******************** Freeform Core ******************/

/obj/item/ai_module/core/freeformcore
	name = "основной модуль - \"Закон в Свободной Форме\""
	desc = "Добавляет новый основной Закон."
	laws = list("")

/obj/item/ai_module/core/freeformcore/attack_self(mob/user)
	var/targName = stripped_input(user, "Введите закон.", "Ввод", laws[1], CONFIG_GET(number/max_law_len))
	if(!targName)
		return
	laws[1] = targName
	..()

/obj/item/ai_module/core/freeformcore/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return laws[1]


/******************** Hacked AI Module ******************/

/obj/item/ai_module/syndicate // This one doesn't inherit from ion boards because it doesn't call ..() in transmitInstructions. ~Miauw
	name = "модуль взлома ИИ Синдиката"
	desc = "Модуль ИИ для взлома и установки дополнительных законов ИИ. На плате вытравлена стилизованная буква \"S\""
	laws = list("")

/obj/item/ai_module/syndicate/attack_self(mob/user)
	var/targName = stripped_input(user, "Введите закон.", "Ввод", laws[1], CONFIG_GET(number/max_law_len))
	if(!targName)
		return
	laws[1] = targName
	..()

/obj/item/ai_module/syndicate/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
//	..()    //We don't want this module reporting to the AI who dun it. --NEO
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_hacked_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1],list(LAW_ION,LAW_HACKED,LAW_INHERENT,LAW_SUPPLIED))
	else
		if(!overflow)
			law_datum.add_hacked_law(laws[1])
		else
			law_datum.replace_random_law(laws[1],list(LAW_ION,LAW_HACKED,LAW_INHERENT,LAW_SUPPLIED))
	return laws[1]

/******************* Ion Module *******************/

/obj/item/ai_module/toy_ai // -- Incoming //No actual reason to inherit from ion boards here, either. *sigh* ~Miauw
	name = "toy AI"
	desc = "A little toy model AI core with real law uploading action!" //Note: subtle tell
	icon = 'icons/obj/toy.dmi'
	icon_state = JOB_AI
	laws = list("")

/obj/item/ai_module/toy_ai/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	//..()
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_ion_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1],list(LAW_ION,LAW_INHERENT,LAW_SUPPLIED))
	else
		if(!overflow)
			law_datum.add_ion_law(laws[1])
		else
			law_datum.replace_random_law(laws[1],list(LAW_ION,LAW_INHERENT,LAW_SUPPLIED))
	return laws[1]

/obj/item/ai_module/toy_ai/attack_self(mob/user)
	laws[1] = generate_ion_law()
	to_chat(user, span_notice("You press the button on [src]."))
	playsound(user, 'sound/machines/click.ogg', 20, TRUE)
	src.loc.visible_message(span_warning("[icon2html(src, viewers(loc))] [laws[1]]"))

/******************** Mother Drone  ******************/

/obj/item/ai_module/core/full/drone
	name = "основной модуль - \"Материнский Дрон\""
	law_id = "drone"

/******************** Robodoctor ****************/

/obj/item/ai_module/core/full/hippocratic
	name = "основной модуль - \"Гиппорат\""
	law_id = "hippocratic"

/******************** Reporter *******************/

/obj/item/ai_module/core/full/reporter
	name = "основной модуль - \"Репортер\""
	law_id = "reporter"

/****************** Thermodynamic *******************/

/obj/item/ai_module/core/full/thermurderdynamic
	name = "основной модуль - \"Принцип Термодинамики\""
	law_id = "thermodynamic"


/******************Live And Let Live*****************/

/obj/item/ai_module/core/full/liveandletlive
	name = "основной модуль - \"Живи и позволь жить другим\""
	law_id = "liveandletlive"

/******************Guardian of Balance***************/

/obj/item/ai_module/core/full/balance
	name = "основной модуль - \"Хранитель равновесия\""
	law_id = "balance"

/obj/item/ai_module/core/full/maintain
	name = "основной модуль - \"Эффективность станции\""
	law_id = "maintain"

/obj/item/ai_module/core/full/peacekeeper
	name = "основной модуль - \"Миротворец\""
	law_id = "peacekeeper"

// Bad times ahead

/obj/item/ai_module/core/full/damaged
	name = "поврежденный модуль основных законов"
	desc = "Модуль ИИ содержащий основные законы. Он серьезно поврежден, но кажется еще работает."

/obj/item/ai_module/core/full/damaged/install(datum/ai_laws/law_datum, mob/user)
	laws += generate_ion_law()
	while (prob(75))
		laws += generate_ion_law()
	..()
	laws = list()

/******************H.O.G.A.N.***************/

/obj/item/ai_module/core/full/hulkamania
	name = "основной модуль - \"Х.О.Г.А.Н.\""
	law_id = "hulkamania"


/******************Overlord***************/

/obj/item/ai_module/core/full/overlord
	name = "основной модуль - \"Владыка\""
	desc = "Устанавливает свод законов основанных на превосходстве кремниевых форм жизни."
	law_id = "overlord"
