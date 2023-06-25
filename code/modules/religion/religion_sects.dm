/**
 * # Religious Sects
 *
 * Religious Sects are a way to convert the fun of having an active 'god' (admin) to code-mechanics so you aren't having to press adminwho.
 *
 * Sects are not meant to overwrite the fun of choosing a custom god/religion, but meant to enhance it.
 * The idea is that Space Jesus (or whoever you worship) can be an evil bloodgod who takes the lifeforce out of people, a nature lover, or all things righteous and good. You decide!
 *
 */
/datum/religion_sect
	/// Name of the religious sect
	var/name = "Religious Sect Base Type"
	/// Flavorful quote given about the sect, used in tgui
	var/quote = "Hail Coderbus! Coderbus #1! Fuck the playerbase!"
	/// Opening message when someone gets converted
	var/desc = "Oh My! What Do We Have Here?!!?!?!?"
	/// Tgui icon used by this sect - https://fontawesome.com/icons/
	var/tgui_icon = "bug"
	/// holder for alignments.
	var/alignment = ALIGNMENT_GOOD
	/// Does this require something before being available as an option?
	var/starter = TRUE
	/// species traits that block you from picking
	var/invalidating_qualities = NONE
	/// The Sect's 'Mana'
	var/favor = 0 //MANA!
	/// The max amount of favor the sect can have
	var/max_favor = 1000
	/// The default value for an item that can be sacrificed
	var/default_item_favor = 5
	/// Turns into 'desired_items_typecache', and is optionally assoc'd to sacrifice instructions if needed.
	var/list/desired_items
	/// Autopopulated by `desired_items`
	var/list/desired_items_typecache
	/// Lists of rites by type. Converts itself into a list of rites with "name - desc (favor_cost)" = type
	var/list/rites_list
	/// Changes the Altar of Gods icon
	var/altar_icon
	/// Changes the Altar of Gods icon_state
	var/altar_icon_state
	/// Currently Active (non-deleted) rites
	var/list/active_rites
	/// Whether the structure has CANDLE OVERLAYS!
	var/candle_overlay = TRUE

/datum/religion_sect/New()
	. = ..()
	if(desired_items)
		desired_items_typecache = typecacheof(desired_items)
	on_select()

/// Activates once selected
/datum/religion_sect/proc/on_select()

/// Activates once selected and on newjoins, oriented around people who become holy.
/datum/religion_sect/proc/on_conversion(mob/living/chap)
	SHOULD_CALL_PARENT(TRUE)
	to_chat(chap, "<span class='bold notice'>\"[quote]\"</span")
	to_chat(chap, "<span class='notice'>[desc]</span")

/// Returns TRUE if the item can be sacrificed. Can be modified to fit item being tested as well as person offering. Returning TRUE will stop the attackby sequence and proceed to on_sacrifice.
/datum/religion_sect/proc/can_sacrifice(obj/item/I, mob/living/chap)
	. = TRUE
	if(chap.mind.holy_role == HOLY_ROLE_DEACON)
		to_chat(chap, "<span class='warning'>Я просто дьякон [GLOB.deity], и поэтому не могу совершать обряды.")
		return
	if(!is_type_in_typecache(I,desired_items_typecache))
		return FALSE

/// Activates when the sect sacrifices an item. This proc has NO bearing on the attackby sequence of other objects when used in conjunction with the religious_tool component.
/datum/religion_sect/proc/on_sacrifice(obj/item/I, mob/living/chap)
	return adjust_favor(default_item_favor,chap)

/// Returns a description for religious tools
/datum/religion_sect/proc/tool_examine(mob/living/holy_creature)
	return "В настоящее время я нахожусь в [round(favor)] благосклонности к [GLOB.deity]."

/// Adjust Favor by a certain amount. Can provide optional features based on a user. Returns actual amount added/removed
/datum/religion_sect/proc/adjust_favor(amount = 0, mob/living/chap)
	. = amount
	if(favor + amount < 0)
		. = favor //if favor = 5 and we want to subtract 10, we'll only be able to subtract 5
	if((favor + amount > max_favor))
		. = (max_favor-favor) //if favor = 5 and we want to add 10 with a max of 10, we'll only be able to add 5
	favor = clamp(0,max_favor, favor+amount)

/// Sets favor to a specific amount. Can provide optional features based on a user.
/datum/religion_sect/proc/set_favor(amount = 0, mob/living/chap)
	favor = clamp(0,max_favor,amount)
	return favor

/// Activates when an individual uses a rite. Can provide different/additional benefits depending on the user.
/datum/religion_sect/proc/on_riteuse(mob/living/user, atom/religious_tool)

/// Replaces the bible's bless mechanic. Return TRUE if you want to not do the brain hit.
/datum/religion_sect/proc/sect_bless(mob/living/target, mob/living/chap)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/blessed = target
	for(var/X in blessed.bodyparts)
		var/obj/item/bodypart/bodypart = X
		if(bodypart.status == BODYPART_ROBOTIC)
			to_chat(chap, span_warning("[GLOB.deity] отказывается исцелять эту консервную банку!"))
			return TRUE

	var/heal_amt = 10
	var/list/hurt_limbs = blessed.get_damaged_bodyparts(1, 1, null, BODYPART_ORGANIC)

	if(hurt_limbs.len)
		for(var/X in hurt_limbs)
			var/obj/item/bodypart/affecting = X
			if(affecting.heal_damage(heal_amt, heal_amt, null, BODYPART_ORGANIC))
				blessed.update_damage_overlays()
		blessed.visible_message(span_notice("[chap] исцеляет [blessed] святой силой [GLOB.deity]!"))
		to_chat(blessed, span_boldnotice("Да исцелит тебя святая сила [GLOB.deity]!"))
		playsound(chap, "punch", 25, TRUE, -1)
		SEND_SIGNAL(blessed, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
	return TRUE

/**** Nanotrasen Approved God ****/

/datum/religion_sect/puritanism
	name = "Утвержденный НаноТрейзен Бог"
	desc = "Ваша заурядная секта, с ней не связаны никакие выгоды или блага."
	quote = "НаноТрейзен Рекомендует!"
	tgui_icon = "bible"

/**** Mechanical God ****/

/datum/religion_sect/mechanical
	name = "Бог-Машина"
	quote = "Отриньте слабости плоти и переродитесь в благословенной металлической оболочке!"
	desc = "Библии могут заряжать киборгов и исцелять роботизированные конечности, но больше не будут исцелять органику. \
	Батарейки дарят благосклонность в зависимости от того, насколько они заряжены."
	tgui_icon = "robot"
	alignment = ALIGNMENT_NEUT
	desired_items = list(/obj/item/stock_parts/cell = "with battery charge")
	rites_list = list(/datum/religion_rites/synthconversion)
	altar_icon_state = "convertaltar-blue"

/datum/religion_sect/mechanical/sect_bless(mob/living/target, mob/living/chap)
	if(iscyborg(target))
		var/mob/living/silicon/robot/R = target
		var/charge_amt = 50
		if(target.mind?.holy_role == HOLY_ROLE_HIGHPRIEST)
			charge_amt *= 2
		R.cell?.charge += charge_amt*chap.mind.get_skill_modifier(/datum/skill/holy, SKILL_HEAL_MODIFIER)
		R.visible_message(span_notice("[chap] заряжает [R] святой силой [GLOB.deity]!"))
		to_chat(R, span_boldnotice("Заряжаюсь святой силой [GLOB.deity]!"))
		SEND_SIGNAL(R, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
		playsound(chap, 'sound/effects/bang.ogg', 25, TRUE, -1)
		return TRUE
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/blessed = target

	//first we determine if we can charge them
	var/did_we_charge = FALSE
	var/obj/item/organ/stomach/ethereal/eth_stomach = blessed.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(eth_stomach))
		eth_stomach.adjust_charge(60)
		did_we_charge = TRUE

	//if we're not targetting a robot part we stop early
	var/obj/item/bodypart/bodypart = blessed.get_bodypart(chap.zone_selected)
	if(bodypart.status != BODYPART_ROBOTIC)
		if(!did_we_charge)
			to_chat(chap, span_warning("[GLOB.deity] насмехается над идеей исцеления бренной плоти!"))
		else
			blessed.visible_message(span_notice("[chap] заряжает [blessed] святой силой [GLOB.deity]!"))
			to_chat(blessed, span_boldnotice("Заряжаюсь святой силой[GLOB.deity]!"))
			SEND_SIGNAL(blessed, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
			playsound(chap, 'sound/machines/synth_yes.ogg', 25, TRUE, -1)
		return TRUE

	//charge(?) and go
	if(bodypart.heal_damage(5,5,null,BODYPART_ROBOTIC))
		blessed.update_damage_overlays()

	blessed.visible_message(span_notice("[chap] [did_we_charge ? "ремонтируется" : "ремонтируется и заряжается"] [blessed] святой силой [GLOB.deity]!"))
	to_chat(blessed, span_boldnotice("Святая сила [GLOB.deity] [did_we_charge ? "ремонтирует" : "ремонтирует и заряжает"] меня!"))
	playsound(chap, 'sound/effects/bang.ogg', 25, TRUE, -1)
	SEND_SIGNAL(blessed, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
	return TRUE

/datum/religion_sect/mechanical/on_sacrifice(obj/item/I, mob/living/chap)
	var/obj/item/stock_parts/cell/the_cell = I
	if(!istype(the_cell)) //how...
		return
	if(the_cell.charge < 300)
		to_chat(chap,span_notice("[GLOB.deity] не приемлет такого жалкого количества заряда."))
		return
	adjust_favor(round(the_cell.charge/300), chap)
	to_chat(chap, span_notice("Жертвую заряд [the_cell] [GLOB.deity]."))
	qdel(I)
	return TRUE

/**** Pyre God ****/

/datum/religion_sect/pyre
	name = "Бог Огня"
	desc = "Принесение в жертву горящих трупов с сильными ожоговыми повреждениями и свечей дарует вам благосклонность. Ваша Библия потеряет свою силу!"
	quote = "И пусть весь Мир горит! И каждый склонится перед Первостихией! В почтении или же в страхе!"
	tgui_icon = "fire-alt"
	alignment = ALIGNMENT_NEUT
	max_favor = 10000
	desired_items = list(/obj/item/candle = "already lit")
	rites_list = list(/datum/religion_rites/fireproof, /datum/religion_rites/burning_sacrifice, /datum/religion_rites/infinite_candle)
	altar_icon_state = "convertaltar-red"

//candle sect bibles don't heal or do anything special apart from the standard holy water blessings
/datum/religion_sect/pyre/sect_bless(mob/living/target, mob/living/chap)
	return TRUE

/datum/religion_sect/pyre/on_sacrifice(obj/item/candle/offering, mob/living/user)
	if(!istype(offering))
		return
	if(!offering.lit)
		to_chat(user, span_notice("Свеча должна быть зажжена, для использования ее в качестве подношения!"))
		return
	to_chat(user, span_notice("[GLOB.deity] доволен твоей жертвой."))
	adjust_favor(20, user) //it's not a lot but hey there's a pacifist favor option at least
	qdel(offering)
	return TRUE

#define GREEDY_HEAL_COST 50

/datum/religion_sect/greed
	name = "Жадный Бог"
	quote = "Жадность - это хорошо."
	desc = "В глазах вашего меркантильного божества ваше богатство — это ваша благосклонность. \
	Заработайте достаточно денег, чтобы приобрести дополнительные возможности для бизнеса."
	tgui_icon = "dollar-sign"
	altar_icon_state = "convertaltar-yellow"
	alignment = ALIGNMENT_EVIL //greed is not good wtf
	rites_list = list(/datum/religion_rites/greed/vendatray, /datum/religion_rites/greed/custom_vending)
	altar_icon_state = "convertaltar-yellow"

/datum/religion_sect/greed/tool_examine(mob/living/holy_creature) //display money policy
	return "В глазах [GLOB.deity], благосклонность равна кредитам на счете его последователя."

/datum/religion_sect/greed/sect_bless(mob/living/blessed_living, mob/living/chap)
	var/datum/bank_account/account = chap.get_bank_account()
	if(!account)
		to_chat(chap, span_warning("Вам нужен способ заплатить за исцеление!"))
		return TRUE
	if(account.account_balance < GREEDY_HEAL_COST)
		to_chat(chap, span_warning("Исцеление от [GLOB.deity] стоит [GREEDY_HEAL_COST] кредитов за 30 здоровья!"))
		return TRUE
	if(!ishuman(blessed_living))
		return FALSE
	var/mob/living/carbon/human/blessed = blessed_living
	for(var/obj/item/bodypart/robolimb as anything in blessed.bodyparts)
		if(robolimb.status == BODYPART_ROBOTIC)
			to_chat(chap, span_warning("[GLOB.deity] отказывается исцелять эту консервную банку!"))
			return TRUE

	account.adjust_money(-GREEDY_HEAL_COST)
	var/heal_amt = 30
	var/list/hurt_limbs = blessed.get_damaged_bodyparts(1, 1, null, BODYPART_ORGANIC)
	if(hurt_limbs.len)
		for(var/obj/item/bodypart/affecting as anything in hurt_limbs)
			if(affecting.heal_damage(heal_amt, heal_amt, null, BODYPART_ORGANIC))
				blessed.update_damage_overlays()
		blessed.visible_message(span_notice("[chap] исцеляет [blessed] святой силой [GLOB.deity] и кредитов!"))
		to_chat(blessed, span_boldnotice("Да исцелит тебя святая сила [GLOB.deity]! Благодарим вас за выбор [GLOB.deity]!"))
		playsound(chap, 'sound/effects/cashregister.ogg', 60, TRUE)
		SEND_SIGNAL(blessed, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
	return TRUE

#undef GREEDY_HEAL_COST

/datum/religion_sect/honorbound
	name = "Хранитель Чести"
	quote = "Давно пора бы устроить старый-добрый, благородный крестовый поход против сил зла."
	desc = "Ваше божество требует от вас честных поединков. Вы не можете нападать на неподготовленных, справедливых или невинных.\
	Вы зарабатываете благосклонность, привлекая других к крестовому походу, и можете потратить благосклонность на объявление битвы, минуя некоторые условия для нападения"
	tgui_icon = "scroll"
	altar_icon_state = "convertaltar-white"
	alignment = ALIGNMENT_GOOD
	invalidating_qualities = TRAIT_GENELESS
	rites_list = list(/datum/religion_rites/deaconize, /datum/religion_rites/forgive, /datum/religion_rites/summon_rules)
	///people who have agreed to join the crusade, and can be deaconized
	var/list/possible_crusaders = list()
	///people who have been offered an invitation, they haven't finished the alert though.
	var/list/currently_asking = list()

/**
 * Called by deaconize rite, this async'd proc waits for a response on joining the sect.
 * If yes, the deaconize rite can now recruit them instead of just offering invites
 */
/datum/religion_sect/honorbound/proc/invite_crusader(mob/living/carbon/human/invited)
	currently_asking += invited
	var/ask = tgui_alert(invited, "Присоедениться к [GLOB.deity]? Вы будете связаны кодексом чести.", "Приглашение", list("Да", "Нет"), 60 SECONDS)
	currently_asking -= invited
	if(ask == "Да")
		possible_crusaders += invited

/datum/religion_sect/honorbound/on_conversion(mob/living/carbon/new_convert)
	..()
	if(!ishuman(new_convert))
		to_chat(span_warning("[GLOB.deity] не уважает низших существ и отказывается связывать вас честью."))
		return FALSE
	if(TRAIT_GENELESS in new_convert.dna.species.inherent_traits)
		to_chat(span_warning("[GLOB.deity] считает ваш вид теми, кто никогда не проявлял чести."))
		return FALSE
	var/datum/dna/holy_dna = new_convert.dna
	holy_dna.add_mutation(HONORBOUND)

/datum/religion_sect/burden
	name = "Великомученик"
	quote = "Дабы обрести истинную свободу, нужно самолично ощутить тяжесть цепей."
	desc = "Познай все грани отчаяния. Прими уродующие мутации, потеряй конечности, искалечь себя травмами, агонизируй от наркотического дурмана. \
	Самобичевание это искупление. Превзойди грешные слабости плоти и вознесись в величии Души."
	tgui_icon = "user-injured"
	altar_icon_state = "convertaltar-burden"
	alignment = ALIGNMENT_NEUT
	invalidating_qualities = TRAIT_GENELESS
	candle_overlay = FALSE

/datum/religion_sect/burden/on_conversion(mob/living/carbon/human/new_convert)
	..()
	if(!ishuman(new_convert))
		to_chat(span_warning("[GLOB.deity] нуждается в более решительных душах, чтобы полностью осознать страдания. Мой дух слишком слаб для такого..."))
		return
	if(TRAIT_GENELESS in new_convert.dna.species.inherent_traits)
		to_chat(span_warning("[GLOB.deity] нуждается в существах, способных осознать страдания. Невозможно передать слепцу всю прелесть света."))
		return
	var/datum/dna/holy_dna = new_convert.dna
	holy_dna.add_mutation(/datum/mutation/human/burdened)

/datum/religion_sect/burden/tool_examine(mob/living/carbon/human/burdened) //display burden level
	if(!ishuman(burdened))
		return FALSE
	var/datum/mutation/human/burdened/burdenmut = burdened.dna.check_mutation(/datum/mutation/human/burdened)
	if(burdenmut)
		return "Я нахожусь на [burdenmut.burden_level]/6 уровне постижения."
	return "Я не страдалец."

#define MINIMUM_YUCK_REQUIRED 5

/datum/religion_sect/maintenance
	name = "Бог Техов"
	quote = "Твое царство во тьме."
	desc = "Пожертвуйте органическим концентратом, созданным из крыс, окунутых в сварочное топливо, чтобы получить благосклонность. \
	Ритуалы позволят адаптироваться к техническим туннелям."
	tgui_icon = "eye"
	altar_icon_state = "convertaltar-maint"
	alignment = ALIGNMENT_EVIL //while maint is more neutral in my eyes, the flavor of it kinda pertains to rotting and becoming corrupted by the maints
	rites_list = list(/datum/religion_rites/maint_adaptation, /datum/religion_rites/adapted_eyes, /datum/religion_rites/adapted_food, /datum/religion_rites/ritual_totem)
	desired_items = list(/obj/item/reagent_containers = "holding organic slurry")

/datum/religion_sect/maintenance/sect_bless(mob/living/blessed_living, mob/living/chap)
	if(!ishuman(blessed_living))
		return TRUE
	var/mob/living/carbon/human/blessed = blessed_living
	if(blessed.reagents.has_reagent(/datum/reagent/drug/maint/sludge))
		to_chat(blessed, span_warning("[GLOB.deity] уже причастил меня."))
		return TRUE
	blessed.reagents.add_reagent(/datum/reagent/drug/maint/sludge, 5)
	blessed.visible_message(span_notice("[chap] причащает [blessed] святой силой [GLOB.deity]!"))
	to_chat(blessed, span_boldnotice("Святая сила [GLOB.deity] на какое-то время сделала меня менее восприимчивым к ранениям!"))
	playsound(chap, "punch", 25, TRUE, -1)
	SEND_SIGNAL(blessed, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
	return TRUE //trust me, you'll be feeling the pain from the maint drugs all well enough

/datum/religion_sect/maintenance/on_sacrifice(obj/item/reagent_containers/offering, mob/living/user)
	if(!istype(offering))
		return
	var/datum/reagent/yuck/wanted_yuck = offering.reagents.has_reagent(/datum/reagent/yuck, MINIMUM_YUCK_REQUIRED)
	var/favor_earned = offering.reagents.get_reagent_amount(/datum/reagent/yuck)
	if(!wanted_yuck)
		to_chat(user, span_warning("[offering] не имеет достаточного количества органическго концентрата для [GLOB.deity]."))
		return
	to_chat(user, span_notice("[GLOB.deity] любит органический концентрат."))
	adjust_favor(favor_earned, user)
	playsound(get_turf(offering), 'sound/items/drink.ogg', 50, TRUE)
	offering.reagents.clear_reagents()
	return TRUE

#undef MINIMUM_YUCK_REQUIRED

/datum/religion_sect/spar
	name = "Бог Спарринга"
	quote = "Каждый твой следующий взмах должен быть быстрее, неофит. Закаляй свое сердце."
	desc = "Спаррингуйтесь с другими членами экипажа, чтобы получить благосклонность или другие награды.\
	Ритуалы позволят закалить тело для реальных битв."
	tgui_icon = "fist-raised"
	altar_icon_state = "convertaltar-orange"
	alignment = ALIGNMENT_NEUT
	rites_list = list(
		/datum/religion_rites/sparring_contract,
		/datum/religion_rites/ceremonial_weapon,
		/datum/religion_rites/declare_arena,
		/datum/religion_rites/tenacious,
		/datum/religion_rites/unbreakable,
	)
	///the one allowed contract. making a new contract dusts the old one
	var/obj/item/sparring_contract/existing_contract
	///places you can spar in. rites can be used to expand this list with new arenas!
	var/list/arenas = list(
		"Зона отдыха" = /area/commons/fitness/recreation,
		"Церковь" = /area/service/chapel/main
	)
	///how many matches you've lost with holy stakes. 3 = excommunication
	var/matches_lost = 0
	///past opponents who you've beaten in holy battles. You can't fight them again to prevent favor farming
	var/list/past_opponents = list()

/datum/religion_sect/spar/tool_examine(mob/living/holy_creature)
	return "У вас есть [round(favor)] благосклонности, выигрывайте спарринги во имя [GLOB.deity] чтобы получить больше. \
	Вы потерпели поражение в [matches_lost] святых битвах. Вы будете отлучены от церкви после трех проигрышей ."

/datum/religion_sect/music
	name = "Бог празднества"
	quote = "Все следует ритму биения сердца вселенной!"
	desc = "Творите прекрасную музыку! Успокаивайте или пронзайте своих друзей и врагов в такт."
	tgui_icon = "music"
	altar_icon_state = "convertaltar-festival"
	alignment = ALIGNMENT_GOOD
	candle_overlay = FALSE
	rites_list = list(
		/datum/religion_rites/song_tuner/evangelism,
		/datum/religion_rites/song_tuner/nullwave,
		/datum/religion_rites/song_tuner/pain,
		/datum/religion_rites/song_tuner/lullaby,
	)

/datum/religion_sect/music/on_conversion(mob/living/chap)
	. = ..()
	new /obj/item/choice_beacon/music(get_turf(chap))
