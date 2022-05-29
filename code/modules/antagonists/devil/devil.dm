#define BLOOD_THRESHOLD 3 //How many souls are needed per stage.
#define TRUE_THRESHOLD 7
#define ARCH_THRESHOLD 12

#define BASIC_DEVIL 0
#define HORNY_MAN 1
#define TRUE_DEVIL 2
#define ARCH_DEVIL 3

#define LOSS_PER_DEATH 2

#define SOULVALUE soulsOwned.len-reviveNumber

#define DEVILRESURRECTTIME 600

GLOBAL_LIST_EMPTY(allDevils)
GLOBAL_LIST_INIT(lawlorify, list (
		LORE = list(
			OBLIGATION_FOOD = "Этот дьявол, всегда предлагает своим жертвам еду, прежде чем атаковать их.",
			OBLIGATION_FIDDLE = "Этот дьявол никогда не откажется от музыкального поединка.",
			OBLIGATION_DANCEOFF = "Этот дьявол никогда не откажется от танца.",
			OBLIGATION_GREET = "Этот дьявол, может разговаривать только с людьми, имя которых он знает.",
			OBLIGATION_PRESENCEKNOWN = "Этот дьявол, не может атаковать из засады.",
			OBLIGATION_SAYNAME = "Он всегда будет повторять свое имя, убивая кого-то.",
			OBLIGATION_ANNOUNCEKILL = "Этот дьявол всегда громко объявляет о своих убийствах, чтобы весь мир услышал.",
			OBLIGATION_ANSWERTONAME = "Этот дьявол всегда откликается на свое истинное имя.",
			BANE_SILVER = "Серебро, может серьёзно навредить этому дьяволу.",
			BANE_SALT = "Бросание соли в этого дьявола временно помешает ему использовать адские силы.",
			BANE_LIGHT = "Яркие вспышки дезориентируют дьявола, что, вероятно, заставит его сбежать.",
			BANE_IRON = "Хладное железо будет медленно убивать его, пока полностью не выйдет из его организма.",
			BANE_WHITECLOTHES = "Ношение чистой белой одежды поможет избавиться от этого дьявола.",
			BANE_HARVEST = "Представление сбора урожая дезориентирует дьявола.",
			BANE_TOOLBOX = "То, что содержит средства творения, также содержит средства уничтожения дьявола.",
			BAN_HURTWOMAN = "Этот дьявол, похоже, предпочитает охотиться на мужчин.",
			BAN_CHAPEL = "Этот дьявол избегает святых мест.",
			BAN_HURTPRIEST = "Духовные люди, по-видимому, невосприимчивы к его силам.",
			BAN_AVOIDWATER = "Хоть вода и безвредна для этого дьявола, однако он старается ее избегать.",
			BAN_STRIKEUNCONSCIOUS = "Этот дьявол не проявляет интереса к спящим и лицам находящимся без сознания.",
			BAN_HURTLIZARD = "Этот дьявол никогда не нападет на человека-ящера первым.",
			BAN_HURTANIMAL = "Этот дьявол избегает причинения вреда животным.",
			BANISH_WATER = "Чтобы изгнать дьявола, вы должны наполнить его тело святой водой.",
			BANISH_COFFIN = "Дьявол вернется к жизни, если его останки не будут погребены.",
			BANISH_FORMALDYHIDE = "Чтобы изгнать дьявола, вы должны ввести в его безжизненное тело бальзамирующую жидкость.",
			BANISH_RUNES = "Этот дьявол воскреснет после смерти, если только его останки не окажутся на руне.",
			BANISH_CANDLES = "Большое количество зажженных поблизости свечей помешает дьяволу воскреснуть.",
			BANISH_DESTRUCTION = "Его труп должен быть полностью уничтожен, чтобы предотвратить воскрешение.",
			BANISH_FUNERAL_GARB = "Если этот дьявол будет облачен в погребальные одежды, он не сможет воскреснуть.  Если одежда не подойдет, аккуратно положите ее поверх трупа дьявола."
		),
		LAW = list(
			OBLIGATION_FOOD = "Прежде чем напасть, я всегда предложу своей жертве последнюю трапезу, что может быть лучше чем отдаться греху чревоугодия перед смертью.",
			OBLIGATION_FIDDLE = "Если меня вызывают на музыкальную дуэль и в данный момент мне не угрожает непосредственная опасность, я всегда приму вызов. Однако смертные меня утомляют и я не приму более одного вызова от одного человека.",
			OBLIGATION_DANCEOFF = "Если меня вызывают на танцевальный поединок и в данный момент мне не угрожает непосредственная опасность, я всегда приму вызов. Однако смертные меня утомляют и я не приму более одного вызова от одного человека.",
			OBLIGATION_GREET = "Как настоящий бизнесмен, я всегда поприветствую своего собеседника по фамилии прежде чем заговорю с ним.",
			OBLIGATION_PRESENCEKNOWN = "Нападать исподтишка удел низших бесов, и перед моим нападением смертные должны всецело осознать кто перед ними.",
			OBLIGATION_SAYNAME = "Ты всегда должен называть свое истинное имя после того, как убьешь кого-то.",
			OBLIGATION_ANNOUNCEKILL = "Удел смертных это страх. Если от моих рук погибнет один из них, то остальные обязаны узнать об этом любыми доступными средствами.",
			OBLIGATION_ANSWERTONAME = "Мое Имя это гордость Ада! И я всегда откликнусь его упоминание!",
			BAN_HURTWOMAN = "Владычица Лилит приглядывает за своими неразумными дочерьми, и поэтому я никогда не приченю вреда любой женщине, кроме как в целях самообороны.",
			BAN_CHAPEL = "Я никогда по своей воле не ступлю в церковь.",
			BAN_HURTPRIEST = "Во избежание привлечения внимания со стороны высших сущностей я никогда не вступлю в бой со священником.",
			BAN_AVOIDWATER = "Вода это непреодолимая преграда истощающая мои силы, я никогда не ступлю на мокрую поверхность.",
			BAN_STRIKEUNCONSCIOUS = "Спящие и бессознательные тела скучны и не представляют никакого интереса для меня.",
			BAN_HURTLIZARD = "Я чувствую в этих ящерах родственную душу, поэтому мне не хотелось бы причинять им вред, кроме как в целях самообороны.",
			BAN_HURTANIMAL = "Я испытываю некую жалось к этим неразумным животным и роботам. Мне не хотелось бы причинять им вред, кроме как в целях самообороны.",
			BANE_SILVER = "Серебро во всех его проявлениях моя погибель.",
			BANE_SALT = "Соль отрезает меня от пламени Ада и блокирует мои магические способности.",
			BANE_LIGHT = "Ослепляющий свет опаляет меня и не позволяет атаковать.",
			BANE_IRON = "Хладное железо это яд для меня.",
			BANE_WHITECLOTHES = "И было мне предсказано, что погибель мне принесет человек одетый в белые одежды.",
			BANE_HARVEST = "The fruits of the harvest shall be your downfall.",
			BANE_TOOLBOX = "Ящики с инструментами напоминают мне о моей постыдной юности в виде низшего беса, когда меня частенько побивали оными по голове и хребтине. Этот страх остался со мной и по сей день.",
			BANISH_WATER = "Святая вода может помешать моей реинкарнации.",
			BANISH_COFFIN = "Будучи погребенным в гробу я не смогу воскреснуть.",
			BANISH_FORMALDYHIDE = "Если мое тело будет наполнено бальзамирующей жидкостью, я не смогу воскреснуть..",
			BANISH_RUNES = "Руны начертанные под мои телом могут помешать моему воскрешению.",
			BANISH_CANDLES = "Зажженные свечи подле моего тела не дадут мне вернуться в этот мир.",
			BANISH_DESTRUCTION = "Только полное уничтожение моей оболочки может помешать мне вернуться в этот мир.",
			BANISH_FUNERAL_GARB = "Если мое тело будет одето или же покрыто погребальными одеждами, то я не смогу вернуться в этот мир."
		)
	))

//These are also used in the codex gigas, so let's declare them globally.
GLOBAL_LIST_INIT(devil_pre_title, list("Тёмный ", "Адский ", "Падший ", "Пламенный ", "Грешный ", "Кровавый ", "Пушистый "))
GLOBAL_LIST_INIT(devil_title, list("Лорд ", "Прелат ", "Граф ", "Виконт ", "Визирь ", "Старейшина ", "Адепт "))
GLOBAL_LIST_INIT(devil_syllable, list("хэл", "и", "одр", "нетто", "ки", "куон", "мяу", "форт", "рен", "грей", "хилл", "ниет", "два", "фи", "цао"))
GLOBAL_LIST_INIT(devil_suffix, list(" Красный", " Бездушный", " Мастер", ", Владыка всего сущего", ", Мл."))
/datum/antagonist/devil
	name = "Дьявол"
	roundend_category = "devils"
	antagpanel_category = "Devil"
	job_rank = ROLE_DEVIL
	antag_hud_name = "devil"
	show_to_ghosts = TRUE
	greentext_reward = 20
	var/obligation
	var/ban
	var/bane
	var/banish
	var/truename
	var/list/datum/mind/soulsOwned = new
	var/reviveNumber = 0
	var/form = BASIC_DEVIL
	var/static/list/devil_spells = typecacheof(list(
		/obj/effect/proc_holder/spell/aimed/fireball/hellish,
		/obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork,
		/obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork/greater,
		/obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork/ascended,
		/obj/effect/proc_holder/spell/targeted/infernal_jaunt,
		/obj/effect/proc_holder/spell/targeted/sintouch,
		/obj/effect/proc_holder/spell/targeted/sintouch/ascended,
		/obj/effect/proc_holder/spell/targeted/summon_contract,
		/obj/effect/proc_holder/spell/targeted/conjure_item/violin,
		/obj/effect/proc_holder/spell/targeted/summon_dancefloor))
	var/ascendable = FALSE

/datum/antagonist/devil/can_be_owned(datum/mind/new_owner)
	. = ..()
	return . && (ishuman(new_owner.current) || iscyborg(new_owner.current))

/datum/antagonist/devil/get_admin_commands()
	. = ..()
	.["Переключить возможность вознесения"] = CALLBACK(src,.proc/admin_toggle_ascendable)


/datum/antagonist/devil/proc/admin_toggle_ascendable(mob/admin)
	ascendable = !ascendable
	message_admins("[key_name_admin(admin)] set [key_name_admin(owner)] devil ascendable to [ascendable]")
	log_admin("[key_name_admin(admin)] set [key_name(owner)] devil ascendable to [ascendable])")

/datum/antagonist/devil/admin_add(datum/mind/new_owner,mob/admin)
	switch(alert(admin,"Вознести до истинного дьявола?",,"Да","Нет","Отменить"))
		if("Да")
			ascendable = TRUE
		if("Нет")
			ascendable = FALSE
		else
			return
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has devil'ed [key_name_admin(new_owner)]. [ascendable ? "(Ascendable)":""]")
	log_admin("[key_name(admin)] has devil'ed [key_name(new_owner)]. [ascendable ? "(Ascendable)":""]")

/datum/antagonist/devil/antag_listing_name()
	return ..() + "([truename])"

/proc/devilInfo(name)
	if(GLOB.allDevils[lowertext(name)])
		return GLOB.allDevils[lowertext(name)]
	else
		var/datum/fake_devil/devil = new /datum/fake_devil(name)
		GLOB.allDevils[lowertext(name)] = devil
		return devil

/proc/randomDevilName()
	var/name = ""
	if(prob(65))
		if(prob(35))
			name = pick(GLOB.devil_pre_title)
		name += pick(GLOB.devil_title)
	var/probability = 100
	name += pick(GLOB.devil_syllable)
	while(prob(probability))
		name += pick(GLOB.devil_syllable)
		probability -= 20
	if(prob(40))
		name += pick(GLOB.devil_suffix)
	return name

/proc/randomdevilobligation()
	return pick(OBLIGATION_FOOD, OBLIGATION_FIDDLE, OBLIGATION_DANCEOFF, OBLIGATION_GREET, OBLIGATION_PRESENCEKNOWN, OBLIGATION_SAYNAME, OBLIGATION_ANNOUNCEKILL, OBLIGATION_ANSWERTONAME)

/proc/randomdevilban()
	return pick(BAN_HURTWOMAN, BAN_CHAPEL, BAN_HURTPRIEST, BAN_AVOIDWATER, BAN_STRIKEUNCONSCIOUS, BAN_HURTLIZARD, BAN_HURTANIMAL)

/proc/randomdevilbane()
	return pick(BANE_SALT, BANE_LIGHT, BANE_IRON, BANE_WHITECLOTHES, BANE_SILVER, /*BANE_HARVEST,*/ BANE_TOOLBOX)

/proc/randomdevilbanish()
	return pick(BANISH_WATER, BANISH_COFFIN, BANISH_FORMALDYHIDE, BANISH_RUNES, BANISH_CANDLES, BANISH_DESTRUCTION, BANISH_FUNERAL_GARB)

/datum/antagonist/devil/proc/add_soul(datum/mind/soul)
	if(soulsOwned.Find(soul))
		return
	soulsOwned += soul
	owner.current.set_nutrition(NUTRITION_LEVEL_FULL)
	to_chat(owner.current, span_warning("Я чувствую себя сытым, получена новая душа в мою коллекцию."))
	update_hud()
	switch(SOULVALUE)
		if(0)
			to_chat(owner.current, span_warning("Адский огонь во мне снова горит ярко. Твои силы восстановились."))
			give_appropriate_spells()
		if(BLOOD_THRESHOLD)
			increase_horny_man()
		if(TRUE_THRESHOLD)
			increase_true_devil()
		if(ARCH_THRESHOLD)
			increase_arch_devil()

/datum/antagonist/devil/proc/remove_soul(datum/mind/soul)
	if(soulsOwned.Remove(soul))
		check_regression()
		to_chat(owner.current, span_warning("Я чувствую, что одна из захваченных мной душ, выскользнула из моих рук."))
		update_hud()

/datum/antagonist/devil/proc/check_regression()
	if(form == ARCH_DEVIL)
		return //arch devil can't regress
	//Yes, fallthrough behavior is intended, so I can't use a switch statement.
	if(form == TRUE_DEVIL && SOULVALUE < TRUE_THRESHOLD)
		regress_horny_man()
	if(form == HORNY_MAN && SOULVALUE < BLOOD_THRESHOLD)
		regress_humanoid()
	if(SOULVALUE < 0)
		give_appropriate_spells()
		to_chat(owner.current, span_warning("В наказание за мои неудачи все силы, кроме создания контракта, были аннулированы."))

/datum/antagonist/devil/proc/regress_humanoid()
	to_chat(owner.current, span_warning("Мои силы слабеют, мне нужно, чтобы экипаж подписал больше контрактов, и я мог восстановить адскую энергию."))
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		H.set_species(/datum/species/human, 1)
		H.regenerate_icons()
	give_appropriate_spells()
	if(istype(owner.current.loc, /obj/effect/dummy/phased_mob/))
		owner.current.forceMove(get_turf(owner.current))//Fixes dying while jaunted leaving you permajaunted.
	form = BASIC_DEVIL

/datum/antagonist/devil/proc/regress_horny_man()
	var/mob/living/carbon/true_devil/D = owner.current
	to_chat(D, span_warning("Мои силы слабеют, мне нужно, чтобы экипаж подписал больше контрактов, и я мог восстановить адскую энергию."))
	D.oldform.forceMove(D.drop_location())
	owner.transfer_to(D.oldform)
	give_appropriate_spells()
	qdel(D)
	form = HORNY_MAN
	update_hud()


/datum/antagonist/devil/proc/increase_horny_man()
	to_chat(owner.current, span_warning("Голова начинает чесатся. Мои рога скоро прорежутся на голове!"))
	sleep(50)
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		var/horns = /obj/item/clothing/head/devil_horns
		var/obj/item/clothing/head/devilhorns = new horns(get_turf(H))
		H.unequip_everything()
		H.equip_to_slot_or_del(devilhorns, ITEM_SLOT_HEAD, 1, 1)
	give_appropriate_spells()
	form = HORNY_MAN

/datum/antagonist/devil/proc/increase_true_devil()
	to_chat(owner.current, span_warning("Я чувствую, как будто моя нынешняя форма вот-вот разорвется. Скоро я стану истинным дьяволом!"))
	sleep(50)
	var/mob/living/carbon/true_devil/A = new /mob/living/carbon/true_devil(owner.current.loc)
	A.faction |= "hell"
	owner.current.forceMove(A)
	A.oldform = owner.current
	owner.transfer_to(A)
	A.set_devil_name()
	give_appropriate_spells()
	form = TRUE_DEVIL
	update_hud()

/datum/antagonist/devil/proc/increase_arch_devil()
	if(!ascendable)
		return
	var/mob/living/carbon/true_devil/D = owner.current
	to_chat(D, span_warning("Я чувствую свое скорое вознесение!"))
	sleep(50)
	if(!D)
		return
	D.visible_message(span_warning("Кожа [D] начинает покрыватся шипами.") , \
		span_warning("Моя плоть начинает создавать щит вокруг меня."))
	sleep(100)
	if(!D)
		return
	D.visible_message(span_warning("Рога на голове [D] медленно растут и удлиняются.") , \
		span_warning("Моё тело продолжает мутировать. Телепатические способности растут."))
	sleep(90)
	if(!D)
		return
	D.visible_message(span_warning("Тело [D] начинает яростно растягиваться и корчиться.") , \
		span_warning("Я начинаю разрушать последние барьеры на пути к абсолютной власти."))
	sleep(40)
	if(!D)
		return
	to_chat(D, "<i><b>Да!</b></i>")
	sleep(10)
	if(!D)
		return
	to_chat(D, "<i><b><span class='big'>ДА!!</span></b></i>")
	sleep(10)
	if(!D)
		return
	to_chat(D, "<i><b><span class='reallybig'>Даа--</span></b></i>")
	sleep(1)
	if(!D)
		return
	send_to_playing_players("<font size=5><span class='danger'><b>\"ЛЕНЬ, ГНЕВ, ГОЛОД, АПАТИЯ, ЗАВИСТЬ, ЖАДНОСТЬ, ГОРДЫНЯ! ОГНИ АДА ПРОБУЖДАЮТСЯ!!\"</font></span>")
	sound_to_playing_players('sound/hallucinations/veryfar_noise.ogg')
	give_appropriate_spells()
	D.convert_to_archdevil()
	if(istype(D.loc, /obj/effect/dummy/phased_mob/))
		D.forceMove(get_turf(D))//Fixes dying while jaunted leaving you permajaunted.
	var/area/A = get_area(owner.current)
	if(A)
		notify_ghosts("Архидьявол вознесся в [A.name]. Обратитесь к дьяволу, чтобы он дал вам новую оболочку для вашей души.", source = owner.current, action=NOTIFY_ATTACK)
	sleep(50)
	if(!SSticker.mode.devil_ascended)
		SSshuttle.emergency.request(null, set_coefficient = 0.3)
	SSticker.mode.devil_ascended++
	form = ARCH_DEVIL

/datum/antagonist/devil/proc/remove_spells()
	for(var/X in owner.spell_list)
		var/obj/effect/proc_holder/spell/S = X
		if(is_type_in_typecache(S, devil_spells))
			owner.RemoveSpell(S)

/datum/antagonist/devil/proc/give_summon_contract()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_contract(null))
	if(obligation == OBLIGATION_FIDDLE)
		owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/violin(null))
	else if(obligation == OBLIGATION_DANCEOFF)
		owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_dancefloor(null))

/datum/antagonist/devil/proc/give_appropriate_spells()
	remove_spells()
	give_summon_contract()
	if(SOULVALUE >= ARCH_THRESHOLD && ascendable)
		give_arch_spells()
	else if(SOULVALUE >= TRUE_THRESHOLD)
		give_true_spells()
	else if(SOULVALUE >= BLOOD_THRESHOLD)
		give_blood_spells()
	else if(SOULVALUE >= 0)
		give_base_spells()

/datum/antagonist/devil/proc/give_base_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))

/datum/antagonist/devil/proc/give_blood_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))

/datum/antagonist/devil/proc/give_true_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork/greater(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/sintouch(null))

/datum/antagonist/devil/proc/give_arch_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/summon_pitchfork/ascended(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/sintouch/ascended(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))

/datum/antagonist/devil/proc/beginResurrectionCheck(mob/living/body)
	if(SOULVALUE>0)
		to_chat(owner.current, span_userdanger("Твоё тело было повреждено до такой степени, что ты уже не можешь им пользоваться. Ценой части своей силы ты можешь вернуться к жизни. Нужно остаться в теле."))
		sleep(DEVILRESURRECTTIME)
		if (!body ||  body.stat == DEAD)
			if(SOULVALUE>0)
				if(body)
					if(check_banishment(body))
						to_chat(owner.current, span_userdanger("К сожалению, смертные завершили ритуал моего изгнания, воскресить уже не удастся."))
						return -1
					else
						to_chat(owner.current, span_userdanger("Я СНОВА ЖИВ!"))
						return hellish_resurrection(body)
				else
					to_chat(owner.current, span_userdanger("Я СНОВА ЖИВ!"))
					return hellish_resurrection(body)
			else
				to_chat(owner.current, span_userdanger("К моему разочарованию сила, которую я получал из контрактов, угасла. У меня больше нет достаточно сил чтобы воскреснуть."))
				return -1
		else
			to_chat(owner.current, span_danger("Я воскрес, но, похоже, потерял все свои силы."))
	else
		to_chat(owner.current, span_userdanger("Мои адские силы слишком слабы, чтобы я мог воскреснуть."))

/datum/antagonist/devil/proc/check_banishment(mob/living/body)
	switch(banish)
		if(BANISH_WATER)
			if(iscarbon(body))
				var/mob/living/carbon/H = body
				return H.has_reagent(/datum/reagent/water/holywater)
			return FALSE
		if(BANISH_COFFIN)
			return (body && istype(body.loc, /obj/structure/closet/crate/coffin))
		if(BANISH_FORMALDYHIDE)
			if(iscarbon(body))
				var/mob/living/carbon/H = body
				return H.has_reagent(/datum/reagent/toxin/formaldehyde)
			return FALSE
		if(BANISH_RUNES)
			if(body)
				for(var/obj/effect/decal/cleanable/crayon/R in range(0,body))
					if (R.name == "rune")
						return TRUE
			return FALSE
		if(BANISH_CANDLES)
			if(body)
				var/count = 0
				for(var/obj/item/candle/C in range(1,body))
					count += C.lit
				if(count>=4)
					return TRUE
			return FALSE
		if(BANISH_DESTRUCTION)
			if(body)
				return FALSE
			return TRUE
		if(BANISH_FUNERAL_GARB)
			if(ishuman(body))
				var/mob/living/carbon/human/H = body
				if(H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under/misc/burial))
					return TRUE
				return FALSE
			else
				for(var/obj/item/clothing/under/misc/burial/B in range(0,body))
					if(B.loc == get_turf(B)) //Make sure it's not in someone's inventory or something.
						return TRUE
				return FALSE

/datum/antagonist/devil/proc/hellish_resurrection(mob/living/body)
	message_admins("[key_name_admin(owner)] (true name is: [truename]) is resurrecting using hellish energy.</a>")
	if(SOULVALUE < ARCH_THRESHOLD || !ascendable) // once ascended, arch devils do not go down in power by any means.
		reviveNumber += LOSS_PER_DEATH
		update_hud()
	if(body)
		body.revive(full_heal = TRUE, admin_revive = TRUE) //Adminrevive also recovers organs, preventing someone from resurrecting without a heart.
		if(istype(body.loc, /obj/effect/dummy/phased_mob/))
			body.forceMove(get_turf(body))//Fixes dying while jaunted leaving you permajaunted.
		if(istype(body, /mob/living/carbon/true_devil))
			var/mob/living/carbon/true_devil/D = body
			if(D.oldform)
				D.oldform.revive(full_heal = TRUE, admin_revive = FALSE) // Heal the old body too, so the devil doesn't resurrect, then immediately regress into a dead body.
		if(body.stat == DEAD)
			create_new_body()
	else
		create_new_body()
	check_regression()

/datum/antagonist/devil/proc/create_new_body()
	if(GLOB.blobstart.len > 0)
		var/turf/targetturf = get_turf(pick(GLOB.blobstart))
		var/mob/currentMob = owner.current
		if(!currentMob)
			currentMob = owner.get_ghost()
			if(!currentMob)
				message_admins("[key_name_admin(owner)]'s devil resurrection failed due to client logoff.  Aborting.")
				return -1
		if(currentMob.mind != owner)
			message_admins("[key_name_admin(owner)]'s devil resurrection failed due to becoming a new mob.  Aborting.")
			return -1
		currentMob.change_mob_type( /mob/living/carbon/human, targetturf, null, 1)
		var/mob/living/carbon/human/H = owner.current
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/civilian/lawyer/black(H), ITEM_SLOT_ICLOTHING)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), ITEM_SLOT_FEET)
		H.equip_to_slot_or_del(new /obj/item/storage/briefcase(H), ITEM_SLOT_HANDS)
		H.equip_to_slot_or_del(new /obj/item/pen(H), ITEM_SLOT_LPOCKET)
		if(SOULVALUE >= BLOOD_THRESHOLD)
			var/horns = /obj/item/clothing/head/devil_horns
			var/obj/item/clothing/head/devilhorns = new horns(get_turf(H))
			H.equip_to_slot(devilhorns, ITEM_SLOT_HEAD, 1, 1)
			H.underwear = "Nude"
			H.undershirt = "Nude"
			H.socks = "Nude"
			H.regenerate_icons()
			if(SOULVALUE >= TRUE_THRESHOLD) //Yes, BOTH this and the above if statement are to run if soulpower is high enough.
				var/mob/living/carbon/true_devil/A = new /mob/living/carbon/true_devil(targetturf)
				A.faction |= "hell"
				H.forceMove(A)
				A.oldform = H
				owner.transfer_to(A, TRUE)
				A.set_devil_name()
				if(SOULVALUE >= ARCH_THRESHOLD && ascendable)
					A.convert_to_archdevil()
	else
		CRASH("Unable to find a blobstart landmark for hellish resurrection")


/datum/antagonist/devil/proc/update_hud()
	if(iscarbon(owner.current))
		var/mob/living/C = owner.current
		if(C.hud_used && C.hud_used.devilsouldisplay)
			C.hud_used.devilsouldisplay.update_counter(SOULVALUE)

/datum/antagonist/devil/greet()
	to_chat(owner.current, span_warning("<b>Во мне загорается пламя Ада. Я [truename], агент из ада, дьявол. Я были послан в смертный мир с великой целью. Мой удел склонять к греху и убеждать отдаться объятиям Ада.</b>"))
	to_chat(owner.current, span_warning("<b>Однако моя адская форма не лишена недостатков.</b>"))
	to_chat(owner.current, "Я не могу заставить кого-то отдать душу насильственным путем.")
	to_chat(owner.current, "Я не могу прямо и сознательно причинять физический вред другому дьяволу, исключая себя.")
	to_chat(owner.current, GLOB.lawlorify[LAW][bane])
	to_chat(owner.current, GLOB.lawlorify[LAW][ban])
	to_chat(owner.current, GLOB.lawlorify[LAW][obligation])
	to_chat(owner.current, GLOB.lawlorify[LAW][banish])
	to_chat(owner.current, "<span class='warning'>Помните, экипаж может воспользоваться вашими слабыми сторонами, если они узнают ваше дьявольское имя.</span><br>")
	. = ..()

/datum/antagonist/devil/on_gain()
	truename = randomDevilName()
	ban = randomdevilban()
	bane = randomdevilbane()
	obligation = randomdevilobligation()
	banish = randomdevilbanish()
	GLOB.allDevils[lowertext(truename)] = src

	antag_memory += "Твоё настоящее дьявольское имя [truename]<br>[GLOB.lawlorify[LAW][ban]]<br>Вы не можете с помощью насилия заставить кого то продать душу.<br>Вы не можете прямо и сознательно причинять физический вред другому дьяволу, исключая себя.<br>[GLOB.lawlorify[LAW][bane]]<br>[GLOB.lawlorify[LAW][obligation]]<br>[GLOB.lawlorify[LAW][banish]]<br>"
	if(issilicon(owner.current))
		var/mob/living/silicon/robot_devil = owner.current
		var/laws = list("Вы не можете с помощью насилия заставить кого то продать душу.", "Вы не можете прямо и сознательно причинять физический вред другому дьяволу, исключая себя.", GLOB.lawlorify[LAW][ban], GLOB.lawlorify[LAW][obligation], "Достигайте своих целей любой ценой, соблюдая данные вам законы.")
		robot_devil.set_law_sixsixsix(laws)
	sleep(10)
	. = ..()

/datum/antagonist/devil/on_removal()
	to_chat(owner.current, span_userdanger("Адский огонь в моей душе потух! Я больше не дьявол!"))
	. = ..()

/datum/antagonist/devil/apply_innate_effects(mob/living/mob_override)
	give_appropriate_spells()
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, mob_override ? null : "Моя дьявольская натура позволила тебе побороть эту клоунаду.")
	owner.current.grant_all_languages(TRUE, TRUE, TRUE, LANGUAGE_DEVIL)
	update_hud()
	. = ..()

/datum/antagonist/devil/remove_innate_effects(mob/living/mob_override)
	for(var/X in owner.spell_list)
		var/obj/effect/proc_holder/spell/S = X
		if(is_type_in_typecache(S, devil_spells))
			owner.RemoveSpell(S)
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, removing = FALSE)
	owner.current.remove_all_languages(LANGUAGE_DEVIL)
	. = ..()

/datum/antagonist/devil/proc/printdevilinfo()
	var/list/parts = list()
	parts += "Истинное имя дьявола: [truename]"
	parts += "Дьявольские принципы были:"
	parts += "[FOURSPACES][GLOB.lawlorify[LORE][ban]]"
	parts += "[FOURSPACES][GLOB.lawlorify[LORE][bane]]"
	parts += "[FOURSPACES][GLOB.lawlorify[LORE][obligation]]"
	parts += "[FOURSPACES][GLOB.lawlorify[LORE][banish]]"
	return parts.Join("<br>")

/datum/antagonist/devil/roundend_report()
	var/list/parts = list()
	parts += printplayer(owner)
	parts += printdevilinfo()
	parts += printobjectives(objectives)
	return parts.Join("<br>")

//A simple super light weight datum for the codex gigas.
/datum/fake_devil
	var/truename
	var/bane
	var/obligation
	var/ban
	var/banish
	var/ascendable

/datum/fake_devil/New(name = randomDevilName())
	truename = name
	bane = randomdevilbane()
	obligation = randomdevilobligation()
	ban = randomdevilban()
	banish = randomdevilbanish()
	ascendable = prob(25)
