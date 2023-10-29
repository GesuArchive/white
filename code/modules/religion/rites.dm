/datum/religion_rites
	/// name of the religious rite
	var/name = "religious rite"
	/// Description of the religious rite
	var/desc = "immm gonna rooon"
	/// length it takes to complete the ritual
	var/ritual_length = (10 SECONDS) //total length it'll take
	/// list of invocations said (strings) throughout the rite
	var/list/ritual_invocations //strings that are by default said evenly throughout the rite
	/// message when you invoke
	var/invoke_msg
	var/favor_cost = 0
	/// does the altar auto-delete the rite
	var/auto_delete = TRUE

/datum/religion_rites/New()
	. = ..()
	if(!GLOB?.religious_sect)
		return
	LAZYADD(GLOB.religious_sect.active_rites, src)

/datum/religion_rites/Destroy()
	if(!GLOB?.religious_sect)
		return
	LAZYREMOVE(GLOB.religious_sect.active_rites, src)
	return ..()

/datum/religion_rites/proc/can_afford(mob/living/user)
	if(GLOB.religious_sect?.favor < favor_cost)
		to_chat(user, span_warning("Этот ритуал требует больше благосклонности!"))
		return FALSE
	return TRUE

///Called to perform the invocation of the rite, with args being the performer and the altar where it's being performed. Maybe you want it to check for something else?
/datum/religion_rites/proc/perform_rite(mob/living/user, atom/religious_tool)
	if(!can_afford(user))
		return FALSE
	to_chat(user, span_notice("Вы начинаете выполнять ритуал [name]..."))
	if(!ritual_invocations)
		if(do_after(user, target = user, delay = ritual_length))
			return TRUE
		return FALSE
	var/first_invoke = TRUE
	for(var/i in ritual_invocations)
		if(first_invoke) //instant invoke
			user.say(i)
			first_invoke = FALSE
			continue
		if(!ritual_invocations.len) //we divide so we gotta protect
			return FALSE
		if(!do_after(user, target = user, delay = ritual_length/ritual_invocations.len))
			return FALSE
		user.say(i)
	if(!do_after(user, target = user, delay = ritual_length/ritual_invocations.len)) //because we start at 0 and not the first fraction in invocations, we still have another fraction of ritual_length to complete
		return FALSE
	if(invoke_msg)
		user.say(invoke_msg)
	return TRUE


///Does the thing if the rite was successfully performed. return value denotes that the effect successfully (IE a harm rite does harm)
/datum/religion_rites/proc/invoke_effect(mob/living/user, atom/religious_tool)
	SHOULD_CALL_PARENT(TRUE)
	GLOB.religious_sect.on_riteuse(user,religious_tool)
	return TRUE


/**** Mechanical God ****/

/datum/religion_rites/synthconversion
	name = "синтетическое преобразование"
	desc = "Превратите человека или нечто похожее на человека, в (превосходного) андроида."
	ritual_length = 30 SECONDS
	ritual_invocations = list(
		"Внутренней сутью нашего бога ...",
		"... Взываем к тебе, пред лицом невзгод ...",
		"... возвысить нас, убрав, что помешает ..."
	)
	invoke_msg = "... Восстань, наш чемпион! Стань тем, чего жаждет твоя душа, живи в этом мире, в своей истинной форме!!"
	favor_cost = 1000

/datum/religion_rites/synthconversion/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning("Для этого ритуала требуется религиозное устройство, к которому можно пристегнуть человека."))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(!LAZYLEN(movable_reltool.buckled_mobs))
		. = FALSE
		if(!movable_reltool.can_buckle) //yes, if you have somehow managed to have someone buckled to something that now cannot buckle, we will still let you perform the rite!
			to_chat(user, span_warning("Для этого ритуала требуется религиозное устройство, к которому можно пристегнуть человека."))
			return
		to_chat(user, span_warning("Этот ритуал требует, чтобы человек был пристегнут к [movable_reltool]."))
		return
	return ..()

/datum/religion_rites/synthconversion/invoke_effect(mob/living/user, atom/religious_tool)
	..()
	if(!ismovable(religious_tool))
		CRASH("[name] perform_rite had a movable atom that has somehow turned into a non-movable!")
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool?.buckled_mobs?.len)
		return FALSE
	var/mob/living/carbon/human/human2borg
	for(var/i in movable_reltool.buckled_mobs)
		if(istype(i,/mob/living/carbon/human))
			human2borg = i
			break
	if(!human2borg)
		return FALSE
	human2borg.set_species(/datum/species/android)
	human2borg.visible_message(span_notice("[human2borg] был обращен ритуалом [name]!"))
	return TRUE

/datum/religion_rites/machine_blessing
	name = "получить благословение"
	desc = "Получите благословение от Бога-Машины для дальнейшего вознесения."
	ritual_length = 5 SECONDS
	ritual_invocations = list(
		"Пусть твоя воля питает наши кузницы...",
		"...Помоги нам в нашем великом завоевании!"
	)
	invoke_msg = "Конец плоти близок!"
	favor_cost = 2000

/datum/religion_rites/machine_blessing/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/blessing = pick(
					/obj/item/organ/cyberimp/arm/surgery,
					/obj/item/organ/cyberimp/eyes/hud/diagnostic,
					/obj/item/organ/cyberimp/eyes/hud/medical,
					/obj/item/organ/cyberimp/mouth/breathing_tube,
					/obj/item/organ/cyberimp/chest/thrusters,
					/obj/item/organ/eyes/robotic/glow)
	new blessing(altar_turf)
	return TRUE
/**** Pyre God ****/

///apply a bunch of fire immunity effect to clothing
/datum/religion_rites/fireproof/proc/apply_fireproof(obj/item/clothing/fireproofed)
	fireproofed.name = "unmelting [fireproofed.name]"
	fireproofed.max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	fireproofed.heat_protection = chosen_clothing.body_parts_covered
	fireproofed.resistance_flags |= FIRE_PROOF

/datum/religion_rites/fireproof
	name = "негорящая защита"
	desc = "Дает иммунитет к огню любому предмету одежды."
	ritual_length = 15 SECONDS
	ritual_invocations = list("Дабы поддержать хранителя Вечногорящей Свечи...",
	"... позволь этому недостойному одеянию служить тебе ...",
	"... сотвори его достаточно сильным, чтобы несгорать тысячи раз ...")
	invoke_msg = "... Примите свою новую форму и присоединитесь к Богу единого истинного пламени!"
	favor_cost = 1000
///the piece of clothing that will be fireproofed, only one per rite
	var/obj/item/clothing/chosen_clothing

/datum/religion_rites/fireproof/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/clothing/apparel in get_turf(religious_tool))
		if(apparel.max_heat_protection_temperature >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
			continue //we ignore anything that is already fireproof
		chosen_clothing = apparel //the apparel has been chosen by our lord and savior
		return ..()
	return FALSE

/datum/religion_rites/fireproof/invoke_effect(mob/living/user, atom/religious_tool)
	..()
	if(!QDELETED(chosen_clothing) && get_turf(religious_tool) == chosen_clothing.loc) //check if the same clothing is still there
		if(istype(chosen_clothing,/obj/item/clothing/suit/hooded) || istype(chosen_clothing,/obj/item/clothing/suit/space/hardsuit ))
			for(var/obj/item/clothing/head/integrated_helmet in chosen_clothing.contents) //check if the clothing has a hood/helmet integrated and fireproof it if there is one.
				apply_fireproof(integrated_helmet)
		apply_fireproof(chosen_clothing)
		playsound(get_turf(religious_tool), 'sound/magic/fireball.ogg', 50, TRUE)
		chosen_clothing = null //our lord and savior no longer cares about this apparel
		return TRUE
	chosen_clothing = null
	to_chat(user, span_warning("Одежды, выбранной для ритуала, больше нет на алтаре!"))
	return FALSE


/datum/religion_rites/burning_sacrifice
	name = "горящее подношение"
	desc = "Пожертвуйте горящим трупом для получения благосклонности, чем больше ожоговых повреждений, тем больше благосклонности вы получите."
	ritual_length = 20 SECONDS
	ritual_invocations = list("Горящее тело ...",
	"... очищенное пламенем ...",
	"... мы все были созданы из огня ...",
	"... и для этого ...")
	invoke_msg = "... МЫ ВЕРНУЛИСЬ! "
///the burning corpse chosen for the sacrifice of the rite
	var/mob/living/carbon/chosen_sacrifice

/datum/religion_rites/burning_sacrifice/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning("Для этого обряда требуется религиозное устройство, к которому можно пристегнуть человека."))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(!LAZYLEN(movable_reltool.buckled_mobs))
		to_chat(user, span_warning("Ничего не пристегнуто к алтарю!"))
		return FALSE
	for(var/corpse in movable_reltool.buckled_mobs)
		if(!iscarbon(corpse))// only works with carbon corpse since most normal mobs can't be set on fire.
			to_chat(user, span_warning("Только углеродные формы жизни могут быть правильно сожжены для жертвоприношения.!"))
			return FALSE
		chosen_sacrifice = corpse
		if(chosen_sacrifice.stat != DEAD)
			to_chat(user, span_warning("Приносить в жертву можно только мертвые тела, этот еще жив!"))
			return FALSE
		if(!chosen_sacrifice.on_fire)
			to_chat(user, span_warning("Этот труп должен гореть, чтобы принести его в жертву!"))
			return FALSE
		return ..()

/datum/religion_rites/burning_sacrifice/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	if(!(chosen_sacrifice in religious_tool.buckled_mobs)) //checks one last time if the right corpse is still buckled
		to_chat(user, span_warning("Подношения больше нет на алтаре!"))
		chosen_sacrifice = null
		return FALSE
	if(!chosen_sacrifice.on_fire)
		to_chat(user, span_warning("Жертва больше не горит, она должна гореть до конца обряда!"))
		chosen_sacrifice = null
		return FALSE
	if(chosen_sacrifice.stat != DEAD)
		to_chat(user, span_warning("Жертва должна оставаться мертвой, чтобы обряд сработал!"))
		chosen_sacrifice = null
		return FALSE
	var/favor_gained = 100 + round(chosen_sacrifice.getFireLoss())
	GLOB.religious_sect.adjust_favor(favor_gained, user)
	to_chat(user, span_notice("[GLOB.deity] поглощает горящий труп, любые следы огня исчезают вместе с ним. [GLOB.deity] награждает меня [favor_gained] благосклонности."))
	chosen_sacrifice.dust(force = TRUE)
	playsound(get_turf(religious_tool), 'sound/effects/supermatter.ogg', 50, TRUE)
	chosen_sacrifice = null
	return TRUE



/datum/religion_rites/infinite_candle
	name = "вечные свечи"
	desc = "Создает 5 свечей, в которых никогда не кончается воск."
	ritual_length = 10 SECONDS
	invoke_msg = "Гори ярко, маленькая свечка, ибо ты погаснешь вместе со вселенной."
	favor_cost = 200

/datum/religion_rites/infinite_candle/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	for(var/i in 1 to 5)
		new /obj/item/candle/infinite(altar_turf)
	playsound(altar_turf, 'sound/magic/fireball.ogg', 50, TRUE)
	return TRUE

/*********Greedy God**********/

///all greed rites cost money instead
/datum/religion_rites/greed
	ritual_length = 5 SECONDS
	invoke_msg = "Извини, что опоздал, я просто зарабатывал кучу денег."
	var/money_cost = 0

/datum/religion_rites/greed/can_afford(mob/living/user)
	var/datum/bank_account/account = user.get_bank_account()
	if(!account)
		to_chat(user, span_warning("Вам нужен способ оплаты обряда!"))
		return FALSE
	if(account.account_balance < money_cost)
		to_chat(user, span_warning("Этот обряд требует больше денег!"))
		return FALSE
	return TRUE

/datum/religion_rites/greed/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/datum/bank_account/account = user.get_bank_account()
	if(!account || account.account_balance < money_cost)
		to_chat(user, span_warning("Этот обряд требует больше денег!"))
		return FALSE
	account.adjust_money(-money_cost)
	. = ..()

/datum/religion_rites/greed/vendatray
	name = "приобрести торговый лоток"
	desc = "Вызывает торговый лоток. Вы можете использовать его для продажи предметов!"
	invoke_msg = "Мне нужен торговый лоток, чтобы заработать больше денег!"
	money_cost = 1300

/datum/religion_rites/greed/vendatray/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	new /obj/structure/displaycase/forsale(altar_turf)
	playsound(get_turf(religious_tool), 'sound/effects/cashregister.ogg', 60, TRUE)
	return TRUE

/datum/religion_rites/greed/custom_vending
	name = "купить личный торговый автомат"
	desc = "Вызывает специальный торговый автомат. Вы можете использовать его, чтобы продать МНОГО предметов!"
	invoke_msg = "Если я получу личный торговый автомат для своих продуктов, я смогу стать ОЧЕНЬ БОГАТЫМ!"
	money_cost = 3000 //quite a step up from vendatray

/datum/religion_rites/greed/custom_vending/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	new /obj/machinery/vending/custom/greed(altar_turf)
	playsound(get_turf(religious_tool), 'sound/effects/cashregister.ogg', 60, TRUE)
	return TRUE

/*********Honorbound God**********/

///Makes the person holy, but they now also have to follow the honorbound code (CBT). Actually earns favor, convincing others to uphold the code (tm) is not easy
/datum/religion_rites/deaconize
	name = "присоединение к крестовому походу"
	desc = "Обращает кого-то в вашу веру. Он должен желать этого, поэтому первый вызов просто отправит приглашение. \
	Они станут связанными честью, как и вы, а вы получите огромный прирост благосклонности!"
	ritual_length = 30 SECONDS
	ritual_invocations = list(
	"Давно пора бы устроить старый-добрый, благородный крестовый поход против сил зла.",
	"Нам нужны праведники ...",
	"... непоколебимые ...",
	"... и справедливые.",
	"Грешники должны замолчать ...",)
	invoke_msg = "... И кодекс должен соблюдаться!"
	///the invited crusader
	var/mob/living/carbon/human/new_crusader

/datum/religion_rites/deaconize/perform_rite(mob/living/user, atom/religious_tool)
	var/datum/religion_sect/honorbound/sect = GLOB.religious_sect
	if(!ismovable(religious_tool))
		to_chat(user, span_warning("Для этого обряда требуется религиозное устройство, к которому можно пристегнуть человека."))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(!LAZYLEN(movable_reltool.buckled_mobs))
		to_chat(user, span_warning("Ничего не пристегнуто к алтарю!"))
		return FALSE
	for(var/mob/living/carbon/human/possible_crusader in movable_reltool.buckled_mobs)
		if(possible_crusader.stat != CONSCIOUS)
			to_chat(user, span_warning("[possible_crusader] должен быть живым и сознательным, чтобы присоединиться к крестовому походу!"))
			return FALSE
		if(TRAIT_GENELESS in possible_crusader.dna.species.inherent_traits)
			to_chat(user, span_warning("Этот вид вызывает отвращение у [GLOB.deity]! Им никогда не позволят присоединиться к крестовому походу!"))
			return FALSE
		if(possible_crusader in sect.currently_asking)
			to_chat(user, span_warning("Ожидаю, пока он решат, присоединяться к нам или нет!"))
			return FALSE
		if(!(possible_crusader in sect.possible_crusaders))
			INVOKE_ASYNC(sect, TYPE_PROC_REF(/datum/religion_sect/honorbound, invite_crusader), possible_crusader)
			to_chat(user, span_notice("Ему уже была предоставлена возможность подумать о присоединении к крестовому походу. Нужно подождать, пока он решит."))
			return FALSE
		new_crusader = possible_crusader
		return ..()

/datum/religion_rites/deaconize/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	var/mob/living/carbon/human/joining_now = new_crusader
	new_crusader = null
	if(!(joining_now in religious_tool.buckled_mobs)) //checks one last time if the right corpse is still buckled
		to_chat(user, span_warning("Новый последователь больше не на алтаре!"))
		return FALSE
	if(joining_now.stat != CONSCIOUS)
		to_chat(user, span_warning("Новый последователь должен оставаться в живых, чтобы обряд сработал!"))
		return FALSE
	if(!joining_now.mind)
		to_chat(user, span_warning("Новый последователь безмозглый!"))
		return FALSE
	if(joining_now.mind.has_antag_datum(/datum/antagonist/cult))//what the fuck?!
		to_chat(user, span_warning("[GLOB.deity] увидел истинное темное зло в сердце [joining_now], и он был поражен!"))
		playsound(get_turf(religious_tool), 'sound/effects/pray.ogg', 50, TRUE)
		joining_now.gib(TRUE)
		return FALSE
	var/datum/mutation/human/honorbound/honormut = user.dna.check_mutation(HONORBOUND)
	if(joining_now in honormut.guilty)
		honormut.guilty -= joining_now
	GLOB.religious_sect.adjust_favor(200, user)
	to_chat(user, span_notice("[GLOB.deity] принял [joining_now]! Он теперь освящен! (хоть это почти и незаметно)"))
	joining_now.mind.holy_role = HOLY_ROLE_DEACON
	GLOB.religious_sect.on_conversion(joining_now)
	playsound(get_turf(religious_tool), 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

///Mostly useless funny rite for forgiving someone, making them innocent once again.
/datum/religion_rites/forgive
	name = "простить"
	desc = "Прощает кого-то, после этого он не считается виновным. Добрый жест, учитывая все обстоятельства!"
	invoke_msg = "Твой грех прощен."
	var/mob/living/who

/datum/religion_rites/forgive/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	var/datum/mutation/human/honorbound/honormut = user.dna.check_mutation(HONORBOUND)
	if(!honormut)
		return FALSE
	if(!honormut.guilty.len)
		to_chat(user, span_warning("[GLOB.deity] не держит обид."))
		return FALSE
	var/forgiven_choice = tgui_input_list(user, "Выбираю один из грехов перед [GLOB.deity] чтобы простить.", "Простить", honormut.guilty)
	if(!forgiven_choice)
		return FALSE
	who = forgiven_choice
	return ..()

/datum/religion_rites/forgive/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	if(in_range(user, religious_tool))
		return FALSE
	var/datum/mutation/human/honorbound/honormut = user.dna.check_mutation(HONORBOUND)
	if(!honormut) //edge case
		return FALSE
	honormut.guilty -= who
	who = null
	playsound(get_turf(religious_tool), 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

/datum/religion_rites/summon_rules
	name = "призвать законы чести"
	desc = "Вызов бумаги с правилами и положениями Чести."
	invoke_msg = "Явись, Святое Писание!"
	///paper to turn into holy writ
	var/obj/item/paper/writ_target

/datum/religion_rites/summon_rules/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/paper/could_writ in get_turf(religious_tool))
		if(istype(could_writ, /obj/item/paper/holy_writ))
			continue
		if(could_writ.info) //blank paper pls
			continue
		writ_target = could_writ //PLEASE SIGN MY AUTOGRAPH
		return ..()
	to_chat(user, span_warning("Нужно положить чистый лист бумаги на [religious_tool] для этого!"))
	return FALSE

/datum/religion_rites/summon_rules/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/paper/autograph = writ_target
	var/turf/tool_turf = get_turf(religious_tool)
	writ_target = null
	if(QDELETED(autograph) || !(tool_turf == autograph.loc)) //check if the same food is still there
		to_chat(user, span_warning("Ваша цель покинула алтарь!"))
		return FALSE
	autograph.visible_message(span_notice("Слова волшебным образом проявляются на [autograph]!"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	new /obj/item/paper/holy_writ(tool_turf)
	qdel(autograph)
	return TRUE

/obj/item/paper/holy_writ
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	slot_flags = null
	show_written_words = FALSE

	//info set in here because we need GLOB.deity
/obj/item/paper/holy_writ/Initialize(mapload)
	add_filter("holy_outline", 9, list("type" = "outline", "color" = "#fdff6c"))
	name = "Правила Чести [GLOB.deity]!"
	info = {"Правила Чести [GLOB.deity]:
	<br>
	1.) Не нападай на неготовых!<br>
	Те, кто не готов к бою, не должны погибать. Зло этого мира должно проиграть
	в честной битве, для его окончательного изгнания.
	<br>
	<br>
	2.) Не нападай на праведных!<br>
	Те, кто борется за справедливость и добро, не должны пострадать. Безопасность неподкупна и должна
	быть уважаема. Целители зачастую неподкупны, но если вы уверены, что Медицина пала
	во Зло, используйте декларацию зла.
	<br>
	<br>
	3.) Не нападай на невинных!<br>
	Нет никакой чести в сражении, если твой оппонент не погряз во Зле.
	Виновные либо первыми поднимут на тебя оружие, либо ты объявишь их приспешниками Зла.
	<br>
	<br>
	4.) Не используй нечестивую магию!<br>
	Ты не колдун, ты честный воин. Нет ничего более подлого, чем
	мерзкая магия, используемая ведьмами, колдунами и некромантами. Но из этого правила есть исключения.<br>
	Можно использовать святую магию, и, если мим будет завербован, он сможет использовать святую мимекрию. Восстановление также
	разрешено, поскольку это школа, ориентированная на свет и очищение этого мира.
	"}
	. = ..()

/*********Maintenance God**********/

/datum/religion_rites/maint_adaptation
	name = "начальная адаптация"
	desc = "Начните свое преображение в существо, более подходящее для технических туннелей."
	ritual_length = 10 SECONDS
	ritual_invocations = list("Я отрикаюсь от мирского ...",
	"... чтобы стать единым  с глубиной.",
	"Моя форма станет искаженной ...")
	invoke_msg = "... но свой оскал я сохраню!"
	favor_cost = 150 //150u of organic slurry

/datum/religion_rites/maint_adaptation/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	//uses HAS_TRAIT_FROM because junkies are also hopelessly addicted
	if(HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning("Я уже адаптирован.</b>"))
		return FALSE
	return ..()

/datum/religion_rites/maint_adaptation/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_warning("Чувствую, как мои гены трясутся и перекручиваются. <b>Я становлюсь чем-то... иным.</b>"))
	user.emote("laughs")
	ADD_TRAIT(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation")
	//addiction sends some nasty mood effects but we want the maint adaption to be enjoyed like a fine wine
	SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "maint_adaptation", /datum/mood_event/maintenance_adaptation)
	if(iscarbon(user))
		var/mob/living/carbon/vomitorium = user
		vomitorium.vomit()
		var/datum/dna/dna = vomitorium.has_dna()
		dna?.add_mutation(/datum/mutation/human/stimmed) //some fluff mutations
		dna?.add_mutation(/datum/mutation/human/strong)
	user.mind.add_addiction_points(/datum/addiction/maintenance_drugs, 1000)//ensure addiction

/datum/religion_rites/adapted_eyes
	name = "адаптированные глаза"
	desc = "Доступно только после начальной адаптации. Ваши глаза тоже адаптируются, становясь бесполезными на свету."
	ritual_length = 10 SECONDS
	invoke_msg = "Я больше не желаю видеть свет."
	favor_cost = 300 //300u of organic slurry, i'd consider this a reward of the sect

/datum/religion_rites/adapted_eyes/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning("Перед этим мне нужно провести начальную адаптацию."))
		return FALSE
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/adapted = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(adapted && istype(adapted))
		to_chat(user, span_warning("Мои глаза уже адаптированы!"))
		return FALSE
	return ..()

/datum/religion_rites/adapted_eyes/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	var/obj/item/organ/eyes/oldeyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	to_chat(user, span_warning("Чувствую, как глаза адаптируются к темноте."))
	if(oldeyes)
		oldeyes.Remove(user, special = TRUE)
		qdel(oldeyes)//eh
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/neweyes = new
	neweyes.Insert(user, special = TRUE)

/datum/religion_rites/adapted_food
	name = "преобразование пищи"
	desc = "После начальной адаптации вы не сможете есть обычную пищу. Это должно помочь."
	ritual_length = 5 SECONDS
	invoke_msg = "Преобразуйся!"
	favor_cost = 5 //5u of organic slurry
	///the food that will be molded, only one per rite
	var/obj/item/food/mold_target

/datum/religion_rites/adapted_food/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/food/could_mold in get_turf(religious_tool))
		if(istype(could_mold, /obj/item/food/badrecipe/moldy))
			continue
		mold_target = could_mold //moldify this o great one
		return ..()
	to_chat(user, span_warning("Нужно положить еду на [religious_tool] для этого!"))
	return FALSE

/datum/religion_rites/adapted_food/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/food/moldify = mold_target
	mold_target = null
	if(QDELETED(moldify) || !(get_turf(religious_tool) == moldify.loc)) //check if the same food is still there
		to_chat(user, span_warning("Ваша цель покинула алтарь!"))
		return FALSE
	to_chat(user, span_warning("[moldify] преобразовывается!"))
	user.emote("laughs")
	new /obj/item/food/badrecipe/moldy(get_turf(religious_tool))
	qdel(moldify)
	return TRUE

/datum/religion_rites/ritual_totem
	name = "создать ритуальный тотем"
	desc = "Создает Ритуальный Тотем, портативный инструмент для совершения обрядов. Для создания необходимо дерево. Поднять может только священнослужитель."
	favor_cost = 100
	invoke_msg = "Ааджайе!!"//Aajaye – волшебная фраза, часто используется клоунами в волшебном цирке Джея. Смех, смешно, смеемся
	///the food that will be molded, only one per rite
	var/obj/item/stack/sheet/mineral/wood/converted

/datum/religion_rites/ritual_totem/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/stack/sheet/mineral/wood/could_totem in get_turf(religious_tool))
		converted = could_totem //totemify this o great one
		return ..()
	to_chat(user, span_warning("Для этого вам понадобится хотя бы 1 дерево!"))
	return FALSE

/datum/religion_rites/ritual_totem/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/mineral/wood/padala = converted
	converted = null
	if(QDELETED(padala) || !(get_turf(religious_tool) == padala.loc)) //check if the same food is still there
		to_chat(user, span_warning("Ваша цель покинула алтарь!"))
		return FALSE
	to_chat(user, span_warning("[padala] преобразуется в тотем!"))
	if(!padala.use(1))//use one wood
		return
	user.emote("laughs")
	new /obj/item/ritual_totem(altar_turf)
	return TRUE

///sparring god rites

/datum/religion_rites/sparring_contract
	name = "вызов спарринг-контракта"
	desc = "Превращает чистый лист бумаги в спарринг-контракт."
	invoke_msg = "Я буду тренироваться во имя Бога моего."
	///paper to turn into a sparring contract
	var/obj/item/paper/contract_target

/datum/religion_rites/sparring_contract/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/paper/could_contract in get_turf(religious_tool))
		if(could_contract.info) //blank paper pls
			continue
		contract_target = could_contract
		return ..()
	to_chat(user, span_warning("Нужно положить чистый лист бумаги на [religious_tool] для этого!"))
	return FALSE

/datum/religion_rites/sparring_contract/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/paper/blank_paper = contract_target
	var/turf/tool_turf = get_turf(religious_tool)
	contract_target = null
	if(QDELETED(blank_paper) || !(tool_turf == blank_paper.loc)) //check if the same paper is still there
		to_chat(user, span_warning("Ваша цель покинула алтарь!!"))
		return FALSE
	blank_paper.visible_message(span_notice("Слова волшебным образом проявляются на [blank_paper]!"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	if(sect.existing_contract)
		sect.existing_contract.visible_message(span_warning("[src] проваливается в никуда!"))
		qdel(sect.existing_contract)
	sect.existing_contract = new /obj/item/sparring_contract(tool_turf)
	qdel(blank_paper)
	return TRUE

/datum/religion_rites/declare_arena
	name = "объявить арену"
	desc = "Создайте новую зону для спарринга. Вы сможете выбрать ее в спарринг-контрактах."
	ritual_length = 6 SECONDS
	ritual_invocations = list("Я в поисках новых горизонтов ...")
	invoke_msg = "... да будет мой подъем невероятным."
	favor_cost = 1 //only costs one holy battle for a new area
	var/area/area_instance

/datum/religion_rites/declare_arena/perform_rite(mob/living/user, atom/religious_tool)
	var/list/filtered = list()
	for(var/area/unfiltered_area as anything in get_sorted_areas())
		if(istype(unfiltered_area, /area/centcom)) //youuu dont need thaaat
			continue
		if(!(unfiltered_area.area_flags & HIDDEN_AREA))
			filtered += unfiltered_area
	area_instance = tgui_input_list(user, "Выберите область, чтобы создать новую арену!", "Объявление Арены", filtered)
	if(!area_instance)
		return FALSE
	. = ..()

/datum/religion_rites/declare_arena/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	sect.arenas[area_instance.name] = area_instance.type
	to_chat(user, span_warning("[area_instance] теперь можно выбрать в спарринг-контрактах."))

/datum/religion_rites/ceremonial_weapon
	name = "выковать церемониальное оружие"
	desc = "Преобразуйте некоторые материалы в церемониальное оружие. Церемониальные клинки слабы вне спарринга, и их довольно неудобно таскать с собой."
	ritual_length = 10 SECONDS
	invoke_msg = "Клинки во имя Твое! Сражения за нашу кровь!"
	favor_cost = 0
	///the material that will be attempted to be forged into a weapon
	var/obj/item/stack/sheet/converted

/datum/religion_rites/ceremonial_weapon/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/stack/sheet/could_blade in get_turf(religious_tool))
		if(!(GET_MATERIAL_REF(could_blade.material_type) in SSmaterials.materials_by_category[MAT_CATEGORY_ITEM_MATERIAL]))
			continue
		if(could_blade.amount < 5)
			continue
		converted = could_blade
		return ..()
	to_chat(user, span_warning("Нужно как минимум 5 листов материала, из которого будут созданы клинки!"))
	return FALSE

/datum/religion_rites/ceremonial_weapon/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/used_for_blade = converted
	converted = null
	if(QDELETED(used_for_blade) || !(get_turf(religious_tool) == used_for_blade.loc) || used_for_blade.amount < 5) //check if the same food is still there
		to_chat(user, span_warning("Ваша цель покинула алтарь!"))
		return FALSE
	var/material_used = used_for_blade.material_type
	to_chat(user, span_warning("[used_for_blade] преобразуется в церемониальный клинок!"))
	if(!used_for_blade.use(5))//use 5 of the material
		return
	var/obj/item/ceremonial_blade/blade =  new(altar_turf)
	blade.set_custom_materials(list(GET_MATERIAL_REF(material_used) = MINERAL_MATERIAL_AMOUNT * 5))
	return TRUE

/datum/religion_rites/unbreakable
	name = "стать нерушимым"
	desc = "Тренировки сделали тебя нерушимым. В тяжелое, для вас, время вы попытаетесь продолжить бой."
	ritual_length = 10 SECONDS
	invoke_msg = "Моя воля должна быть нерушима. Даруй мне это благо!"
	favor_cost = 4 //4 duels won

/datum/religion_rites/unbreakable/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_UNBREAKABLE, INNATE_TRAIT))
		to_chat(user, span_warning("Твой дух уже несокрушим!"))
		return FALSE
	return ..()

/datum/religion_rites/unbreakable/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen("Ты чувствуешь как желание [GLOB.deity] продолжать битву вливается в вас!"))
	user.AddComponent(/datum/component/unbreakable)

/datum/religion_rites/tenacious
	name = "стать упорным"
	desc = "Тренировки сделали тебя упорным. В тяжелое, для вас, время вы сможете ползти быстрее."
	ritual_length = 10 SECONDS
	invoke_msg = "Даруй мне свое упорство! Я доказал, что достоин!"
	favor_cost = 3 //3 duels won

/datum/religion_rites/tenacious/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_TENACIOUS, INNATE_TRAIT))
		to_chat(user, span_warning("Ваш дух уже упорный!"))
		return FALSE
	return ..()

/datum/religion_rites/tenacious/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen("Ты чувствуешь как упорство [GLOB.deity] вливается в тебя!"))
	user.AddElement(/datum/element/tenacious)
