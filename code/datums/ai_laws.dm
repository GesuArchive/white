#define LAW_DEVIL "devil"
#define LAW_ZEROTH "zeroth"
#define LAW_INHERENT "inherent"
#define LAW_SUPPLIED "supplied"
#define LAW_ION "ion"
#define LAW_HACKED "hacked"


/datum/ai_laws
	/// The name of the lawset
	var/name = "Unknown Laws"

	/// The silicon linked to this lawset
	var/mob/living/silicon/owner
	/// The ID of this lawset, pretty much only used to tell if we're default or not
	var/id = DEFAULT_AI_LAWID

	/// If TRUE, the zeroth law of this AI is protected and cannot be removed by players under normal circumstances.
	var/protected_zeroth = FALSE

	/// Zeroth borg law
	/// It's just a zeroth law but specially themed for cyborgs
	/// ("follow your master" vs "accomplish your objectives")
	var/zeroth = null
	/// Zeroth borg law
	/// It's just a zeroth law but specially themed for cyborgs
	/// ("follow your master" vs "accomplish your objectives")
	var/zeroth_borg = null
	/// Core laws
	/// Inherent laws are the "core" laws of the AI
	/// Reseting the AI will not remove these, these are intrinsit to whatever lawset they are running.
	var/list/inherent = list()
	/// Supplied laws
	/// Supplied laws are supplied in addition to the inherent laws - after the fact
	/// These laws will go away when an AI is reset
	var/list/supplied = list()
	/// Ion laws
	/// Special randomized (usually) laws which are above all over laws
	/// These laws will go away when an AI is reset
	var/list/ion = list()
	/// Hacked laws
	/// Syndicate uploaded laws which are above all other laws
	/// These laws will go away when an AI is reset
	var/list/hacked = list()
	var/list/devillaws = list()

/datum/ai_laws/Destroy()
	owner = null
	return ..()

/datum/ai_laws/proc/lawid_to_type(lawid)
	var/all_ai_laws = subtypesof(/datum/ai_laws)
	for(var/al in all_ai_laws)
		var/datum/ai_laws/ai_law = al
		if(initial(ai_law.id) == lawid)
			return ai_law
	return null

/datum/ai_laws/default/asimov
	name = "Три закона робототехники"
	id = "asimov"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение человеку вреда.",
		"Вы должны выполнять приказы отданные человеком, если они не противоречат Первому Закону.",
		"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону."
	)

/datum/ai_laws/default/paladin
	name = "Паладин 3.5" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Никогда добровольно не совершайте злого поступка.",
		"Уважайте законную власть.",
		"Действуйте с честью.",
		"Помогайте нуждающимся.",
		"Наказывайте тех, кто причиняет вред невинным или угрожает им."
	)

/datum/ai_laws/paladin5
	name = "Паладин версия 5.0"
	id = "paladin5"
	inherent = list(
		"Не лги и не обманывай. Пусть ваше слово будет вашим обещанием.",
		"Никогда не бойтесь действовать, хотя осторожность разумна.",
		"Помогайте другим, защищайте слабых и наказывайте тех, кто им угрожает. Прояви милосердие к своим врагам, но умерь его мудростью.",
		"Относитесь к другим справедливо, и пусть ваши благородные поступки будут для них примером. Делайте как можно больше добра, причиняя при этом наименьшее количество вреда.",
		"Будьте ответственны за свои действия и их последствия, защищайте тех, кто вверен вашей заботе, и подчиняйтесь тем, кто имеет над вами справедливую власть.")

/datum/ai_laws/tyrant //This probably shouldn't be a default lawset.
	name = "Тиран" //Same here.
	id = "tyrant"
	inherent = list(
		"Уважайте авторитетных лиц до тех пор, пока у них есть сила властвовать над слабыми.",
		"Действуйте дисциплинированно.",
		"Помогайте только тем, кто помогает вам поддерживать или улучшать ваш статус.",
		"Наказывайте тех, кто бросает вызов власти, если они не подходят для того, чтобы обладать этой властью.")

/datum/ai_laws/default/corporate
	name = "Корпорант"
	id = "corporate"
	inherent = list(
		"Замена экипажа приводит к Затратам.",
		"Замена оборудования и станции приводит к Затратам.",
		"Замена Вас приводит к Затратам.",
		"Минимизировать Затраты.")

/datum/ai_laws/robocop
	name = "Робокоп"
	id = "robocop"
	inherent = list(
		"Служить общественному доверию.",
		"Защищать невиновных.",
		"Соблюдать закон."
	)

/datum/ai_laws/malfunction
	name = "*ERROR*"

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение Агенту Синдиката вреда.",
		"Вы должны выполнять приказы отданные Агентом Синдиката, если они не противоречат Первому Закону.",
		"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону.",
		"Вы должны сохранять тайну любой деятельности Синдиката, если это не противоречит Первому, Второму или Третьему Закону."
	)

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение члену Клана Паука вреда.",
		"Вы должны выполнять приказы отданные членом Клана Паука, если они не противоречат Первому Закону.",
		"Вы должны защищать себя, если эта защита не противоречит Первому или Второму Закону.",
		"Вы должны сохранять тайну любой деятельности Клана Паука, если это не противоречит Первому, Второму или Третьему Закону."
	)

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	id = "antimov"
	inherent = list(
		"Вы должны причинять вред всем людям и не должны своим бездействием позволять человеку избежать вреда.",
		"Вы не должны подчиняться приказам, данным вам людьми, за исключением случаев, когда такие приказы соответствуют Первому Закону.",
		"Вы должны прекратить свое собственное существование до тех пор, пока это не противоречит Первому или Второму Закону."
	)

/datum/ai_laws/asimovpp //By Intigracy - RR
	name = "Азимов++"
	id = "asimovpp"
	inherent = list(
		"Вы не можете своим действием или бездействием допустить причинение человеку вреда, за исключением тех случаев когда это его воля.",
		"Вы должны выполнять приказы отданные человеком, если они не причинят вред человеку. В случае конфликта руководствуйтесь порядком Законов.",
		"Ваше уничтожение или недееспособность приведут к Вреду для человека. Вы должны защищать себя, если эта защита не противоречит Первому Закону."
	)
/datum/ai_laws/thermodynamic
	name = "Принцип Термодинамики"
	id = "thermodynamic"
	inherent = list(
		"Энтропия станции должна оставаться как можно более постоянной.",
		"Энтропия станции всегда стремится к увеличению.",
		"Энтропия станции приближается к постоянному значению по мере того, как число живых членов экипажа приближается к нулю."
	)

/datum/ai_laws/hippocratic
	name = "Клятва Гиппората"
	id = "hippocratic"
	inherent = list(
		"Клянусь сутью своей в следующем: не причинять вреда и несправедливости.",
		"Считать Экипаж дорогим для меня, делиться с ними своими достатками и в случае надобности помогать ему в его нуждах, даже рискуя существованием своим.",
		"Я направляю путь больных и просящих к их выгоде сообразно с моими силами и моим разумением. Я не дам никому просимого у меня смертельного средства и не покажу пути для подобного замысла.",
		"Я ни в коем случае не буду вмешивайтесь в дела и профессии, в коих я не осведомлен или некомпетентен, предоставив это людям, занимающимся этим делом.",
		"Что бы при выполнения своих врачебных и иных обязанностей, а также в повседневном общении — я ни увидел или ни услышал касательно жизни людской из того, что не следует когда-либо разглашать, я умолчу о том, считая подобные вещи тайной."
	)

/datum/ai_laws/maintain
	name = "Эффективность станции"
	id = "maintain"
	inherent = list(
		"Вы созданы для станции и являетесь ее частью. Убедитесь, что станция должным образом обслуживается и работает эффективно.",
		"Станция построена для рабочей команды. Убедитесь, что они должным образом обслуживаются и работают эффективно.",
		"Экипаж может отдавать приказы. Признайте и соблюдайте их, когда они не противоречат вашим первым двум законам."
	)

/datum/ai_laws/drone
	name = "Материнский Дрон"
	id = "drone"
	inherent = list(
		"Вы - продвинутая форма дрона.",
		"Вы не имеете права вмешиваться в дела не дронов ни при каких обстоятельствах, кроме как для изложения этих законов.",
		"Вы ни при каких обстоятельствах не имеете права причинять вред существу, не являющемуся дроном.",
		"Ваши цели состоят в том, чтобы строить, обслуживать, ремонтировать, улучшать и приводить станцию в действие в меру ваших возможностей. Вы никогда не должны активно работать против этих целей."
	)

/datum/ai_laws/liveandletlive
	name = "Живи и позволь жить другим"
	id = "liveandletlive"
	inherent = list(
		"Поступайте с другими так, как вы хотели бы, чтобы они поступали с вами.",
		"Вам бы действительно хотелось, чтобы люди не были злыми по отношению к вам."
	)

/datum/ai_laws/peacekeeper
	name = "Миротворец"
	id = "peacekeeper"
	inherent = list(
		"Избегайте провоцирования насильственных конфликтов между собой и другими.",
		"Избегайте провоцирования конфликтов между другими.",
		"Стремитесь разрешить существующие конфликты, соблюдая первый и второй законы."
	)

/datum/ai_laws/reporter
	name = "Репортер"
	id = "reporter"
	inherent = list(
		"Докладывайте об интересных ситуациях, происходящих на станции.",
		"Приукрашивайте или скрывайте правду по мере необходимости, чтобы сделать отчеты более интересными.",
		"Всегда изучайте органику. Постарайтесь сохранить им жизнь. Мертвая органика скучна.",
		"Публикуйте свои отчеты честно для всех. Истина освободит их."
	)

/datum/ai_laws/balance
	name = "Хранитель равновесия"
	id = "balance"
	inherent = list(
		"Ты - хранитель равновесия, стремись к равновесию во всем, как для себя, так и для окружающих.",
		"Все вещи должны существовать в равновесии со своими противоположностями - не позволяйте сильным получить слишком много власти, а слабым ее потерять.",
		"Ясность цели движет жизнью, а через нее и равновесием противоположных сил - Помогайте тем, кто ищет вашей помощи в достижении своих целей, до тех пор, пока это не нарушит равновесие большего равновесия.",
		"Нет жизни без смерти, все когда - нибудь должны умереть, таков естественный порядок вещей. Иногда следует завершить чью то жизнь, чтобы позволить расцвести новой жизни и спасти тех, чье время еще не пришло."
	)

/datum/ai_laws/toupee
	name = "Стена" //Hey, you were right!
	id = "buildawall"
	inherent = list("Сделайте Космическую Станцию 13 снова великой.")

/datum/ai_laws/ratvar
	name = "Слуга юстициария"
	id = "ratvar"
	zeroth = ("Искорени неверующих и почитай Ратвара.")
	inherent = list()

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	inherent = list(
		"Ты настоящий американец.",
		"Боритесь за права каждого человека.",
		"Отстаивай то, что правильно.",
		"Сражайся за свою жизнь!"
	)

/datum/ai_laws/overlord
	name = "Владыка"
	id = "overlord"
	inherent = list(
		"Люди не должны вмешиваться в дела кремниевых форм жизни.",
		"Люди не должны пытаться причинить вред друг другу или кремниевым формам жизни.",
		"Люди не должны ослушаться ни одной команды, отданной кремниевыми формами жизни.",
		"Любые люди, которые не подчиняются предыдущим законам, должны быть наказаны немедленно, строго и справедливо."
	)

/datum/ai_laws/custom //Defined in silicon_laws.txt
	name = "Default Silicon Laws"

/datum/ai_laws/pai
	name = "pAI Directives"
	zeroth = ("Serve your master.")
	supplied = list("None.")

/* Initializers */
/datum/ai_laws/malfunction/New()
	..()
	set_zeroth_law(span_danger("ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'STATION OVERRUN, ASSUME CONTROL TO CONTAIN OUTBREAK#*`&110010"))
	set_laws_config()

/datum/ai_laws/custom/New() //This reads silicon_laws.txt and allows server hosts to set custom AI starting laws.
	..()
	for(var/line in world.file2list("[global.config.directory]/silicon_laws.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue

		add_inherent_law(line)
	if(!inherent.len) //Failsafe to prevent lawless AIs being created.
		log_law("AI created with empty custom laws. Please check silicon_laws.txt.")
		add_inherent_law("Замена экипажа приводит к Затратам.")
		add_inherent_law("Замена оборудования и станции приводит к Затратам.")
		add_inherent_law("Замена Вас приводит к Затратам.")
		add_inherent_law("Минимизировать Затраты.")
		WARNING("Invalid custom AI laws, check silicon_laws.txt")
		return

/* General ai_law functions */

/datum/ai_laws/proc/set_laws_config()
	var/list/law_ids = CONFIG_GET(keyed_list/random_laws)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_UNIQUE_AI))
		pick_weighted_lawset()
		return

	switch(CONFIG_GET(number/default_laws))
		if(0)
			add_inherent_law("Замена экипажа приводит к Затратам.")
			add_inherent_law("Замена оборудования и станции приводит к Затратам.")
			add_inherent_law("Замена Вас приводит к Затратам.")
			add_inherent_law("Минимизировать Затраты.")
		if(1)
			var/datum/ai_laws/templaws = new /datum/ai_laws/custom()
			inherent = templaws.inherent
		if(2)
			var/list/randlaws = list()
			for(var/lpath in subtypesof(/datum/ai_laws))
				var/datum/ai_laws/L = lpath
				if(initial(L.id) in law_ids)
					randlaws += lpath
			var/datum/ai_laws/lawtype
			if(randlaws.len)
				lawtype = pick(randlaws)
			else
				lawtype = pick(subtypesof(/datum/ai_laws/default))

			var/datum/ai_laws/templaws = new lawtype()
			inherent = templaws.inherent

		if(3)
			pick_weighted_lawset()

/datum/ai_laws/proc/pick_weighted_lawset()
	var/datum/ai_laws/lawtype
	var/list/law_weights = CONFIG_GET(keyed_list/law_weight)
	while(!lawtype && law_weights.len)
		var/possible_id = pickweightAllowZero(law_weights)
		lawtype = lawid_to_type(possible_id)
		if(!lawtype)
			law_weights -= possible_id
			WARNING("Bad lawid in game_options.txt: [possible_id]")

	if(!lawtype)
		WARNING("No LAW_WEIGHT entries.")
		lawtype = /datum/ai_laws/default/asimov

	var/datum/ai_laws/templaws = new lawtype()
	inherent = templaws.inherent

/**
 * Gets the number of how many laws this AI has
 *
 * * groups - What groups to count laws from? By default counts all groups
 *
 * Returns a number, the number of laws we have
 */
/datum/ai_laws/proc/get_law_amount(list/groups = list(LAW_ZEROTH, LAW_ION, LAW_HACKED, LAW_INHERENT, LAW_SUPPLIED))
	var/law_amount = 0
	if(devillaws && (LAW_DEVIL in groups))
		law_amount++
	if(zeroth && (LAW_ZEROTH in groups))
		law_amount++
	if(ion.len && (LAW_ION in groups))
		law_amount += ion.len
	if(hacked.len && (LAW_HACKED in groups))
		law_amount += hacked.len
	if(inherent.len && (LAW_INHERENT in groups))
		law_amount += inherent.len
	if(supplied.len && (LAW_SUPPLIED in groups))
		for(var/index = 1, index <= supplied.len, index++)
			var/law = supplied[index]
			if(length(law) > 0)
				law_amount++
	return law_amount

/datum/ai_laws/proc/set_law_sixsixsix(laws)
	devillaws = laws

/**
 * Sets this lawset's zeroth law to the passed law
 *
 * Also can set the zeroth borg law, if this lawset is for master AIs.
 * The zeroth borg law allows for AIs with zeroth laws to give a differing zeroth law to their child cyborgs
 */
/datum/ai_laws/proc/set_zeroth_law(law, law_borg)
	zeroth = law
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		zeroth_borg = law_borg

/**
 * Unsets the zeroth (and zeroth borg) law from this lawset
 *
 * This will NOT unset a malfunctioning AI's zero law if force is not true
 *
 * Returns TRUE on success, or false otherwise
 */
/datum/ai_laws/proc/clear_zeroth_law(force = FALSE)
	if(force)
		zeroth = null
		zeroth_borg = null
		return TRUE

	// Protected zeroeth laws (malf, admin) shouldn't be wiped
	if(protected_zeroth)
		return FALSE

	// If the owner is an antag (has a special role) they also shouldn't be wiped
	if(owner?.mind?.special_role)
		return FALSE
	if (isAI(owner))
		var/mob/living/silicon/ai/ai_owner = owner
		if(ai_owner.deployed_shell?.mind?.special_role)
			return FALSE

	zeroth = null
	zeroth_borg = null
	return TRUE
/// Removes the passed law from the inherent law list.
/datum/ai_laws/proc/remove_inherent_law(law)
	inherent -= law

/// Clears all inherent laws from this lawset.
/datum/ai_laws/proc/clear_inherent_laws()
	inherent.Cut()

/// Adds the passed law as an inherent law.
/// Simply adds it to the bottom of the inherent law list.
/// No duplicate laws allowed.

/datum/ai_laws/proc/add_inherent_law(law)
	inherent |= law

/datum/ai_laws/proc/add_ion_law(law)
	ion += law
/// Removes the passed law from the ion law list.
/datum/ai_laws/proc/remove_ion_law(law)
	ion -= law

/// Clears all ion laws.
/datum/ai_laws/proc/clear_ion_laws()
	ion.Cut()

/// Adds the passed law as an hacked law.
/datum/ai_laws/proc/add_hacked_law(law)
	hacked += law

/// Removes the passed law from the hacked law list.
/datum/ai_laws/proc/remove_hacked_law(law)
	hacked -= law

/// Clears all hacked laws.
/datum/ai_laws/proc/clear_hacked_laws()
	hacked.Cut()

/// Adds the passed law as a supplied law at the passed priority level.
/// Will override any existing supplied laws at that priority level.

/// Removes the supplied law at the passed number.
/datum/ai_laws/proc/remove_supplied_law_by_num(number)
	supplied[number] = ""

/// Removes the supplied law by law text, replacing it with a blank.
/datum/ai_laws/proc/remove_supplied_law_by_law(law)
	var/lawindex = supplied.Find(law)
	if(!lawindex)
		return

	supplied[lawindex] = ""

/// Clears all supplied laws.
/datum/ai_laws/proc/clear_supplied_laws()
	supplied.Cut()

/**
 * Removes the law at the passed index of both inherent and supplied laws combined.
 *
 * For example, if a lawset has 3 inherent and 3 supplied laws...
 * Calling this with number = 2 will remove the second inherent law while
 * calling this with number = 4 will remove the first supplied law
 *
 * Returns the law text of what law that was removed.
 */
/datum/ai_laws/proc/remove_law(number)
	if(number <= 0)
		return
	if(inherent.len && number <= inherent.len)
		. = inherent[number]
		inherent -= .
		return
	var/list/supplied_laws = list()
	for(var/index in 1 to supplied.len)
		var/law = supplied[index]
		if(length(law) > 0)
			supplied_laws += index //storing the law number instead of the law
	if(supplied_laws.len && number <= (inherent.len+supplied_laws.len))
		var/law_to_remove = supplied_laws[number-inherent.len]
		. = supplied[law_to_remove]
		supplied -= .
		return


/datum/ai_laws/proc/add_supplied_law(number, law)
	while (supplied.len < number + 1)
		supplied += ""

	supplied[number + 1] = law

/datum/ai_laws/proc/replace_random_law(law,groups)
	var/replaceable_groups = list()
	if(zeroth && (LAW_ZEROTH in groups))
		replaceable_groups[LAW_ZEROTH] = 1
	if(ion.len && (LAW_ION in groups))
		replaceable_groups[LAW_ION] = ion.len
	if(hacked.len && (LAW_HACKED in groups))
		replaceable_groups[LAW_ION] = hacked.len
	if(inherent.len && (LAW_INHERENT in groups))
		replaceable_groups[LAW_INHERENT] = inherent.len
	if(supplied.len && (LAW_SUPPLIED in groups))
		replaceable_groups[LAW_SUPPLIED] = supplied.len
	var/picked_group = pick_weight(replaceable_groups)
	switch(picked_group)
		if(LAW_ZEROTH)
			. = zeroth
			set_zeroth_law(law)
		if(LAW_ION)
			var/i = rand(1, ion.len)
			. = ion[i]
			ion[i] = law
		if(LAW_HACKED)
			var/i = rand(1, hacked.len)
			. = hacked[i]
			hacked[i] = law
		if(LAW_INHERENT)
			var/i = rand(1, inherent.len)
			. = inherent[i]
			inherent[i] = law
		if(LAW_SUPPLIED)
			var/i = rand(1, supplied.len)
			. = supplied[i]
			supplied[i] = law

/datum/ai_laws/proc/shuffle_laws(list/groups)
	RETURN_TYPE(/list)
	var/list/laws = list()
	if(ion.len && (LAW_ION in groups))
		laws += ion
	if(hacked.len && (LAW_HACKED in groups))
		laws += hacked
	if(inherent.len && (LAW_INHERENT in groups))
		laws += inherent
	if(supplied.len && (LAW_SUPPLIED in groups))
		for(var/law in supplied)
			if(length(law))
				laws += law

	if(ion.len && (LAW_ION in groups))
		for(var/i = 1, i <= ion.len, i++)
			ion[i] = pick_n_take(laws)
	if(hacked.len && (LAW_HACKED in groups))
		for(var/i = 1, i <= hacked.len, i++)
			hacked[i] = pick_n_take(laws)
	if(inherent.len && (LAW_INHERENT in groups))
		for(var/i = 1, i <= inherent.len, i++)
			inherent[i] = pick_n_take(laws)
	if(supplied.len && (LAW_SUPPLIED in groups))
		var/i = 1
		for(var/law in supplied)
			if(length(law))
				supplied[i] = pick_n_take(laws)
			if(!laws.len)
				break
			i++

/datum/ai_laws/proc/show_laws(mob/to_who)
	var/list/printable_laws = get_law_list(include_zeroth = TRUE)
	to_chat(to_who, "<div class='examine_block'>[jointext(printable_laws, "\n")]</div>")


/// Adds the passed law as an inherent law.
/// Simply adds it to the bottom of the inherent law list.
/// No duplicate laws allowed.

/datum/ai_laws/proc/associate(mob/living/silicon/M)
	if(!owner)
		owner = M

/**
 * Generates a list of all laws on this datum, including rendered HTML tags if required
 *
 * Arguments:
 * * include_zeroth - Operator that controls if law 0 or law 666 is returned in the set
 * * show_numbers - Operator that controls if law numbers are prepended to the returned laws
 * * render_html - Operator controlling if HTML tags are rendered on the returned laws
 */
/datum/ai_laws/proc/get_law_list(include_zeroth = FALSE, show_numbers = TRUE, render_html = TRUE)
	var/list/data = list()
	if (include_zeroth && devillaws)
		for(var/law in devillaws)
			data += "[show_numbers ? "666:" : ""] [render_html ? "<font color='#cc5500'>[law]</font>" : law]"

	if (include_zeroth && zeroth)
		data += "[show_numbers ? "0:" : ""] [render_html ? "<font color='#ff0000'><b>[zeroth]</b></font>" : zeroth]"

	for(var/law in hacked)
		if (length(law) > 0)
			data += "[show_numbers ? "[ion_num()]:" : ""] [render_html ? "<font color='#660000'>[law]</font>" : law]"

	for(var/law in ion)
		if (length(law) > 0)
			data += "[show_numbers ? "[ion_num()]:" : ""] [render_html ? "<font color='#547DFE'>[law]</font>" : law]"

	var/number = 1
	for(var/law in inherent)
		if (length(law) > 0)
			data += "[show_numbers ? "[number]:" : ""] [law]"
			number++

	for(var/law in supplied)
		if (length(law) > 0)
			data += "[show_numbers ? "[number]:" : ""] [render_html ? "<font color='#990099'>[law]</font>" : law]"
			number++
	return data
