/datum/mutation/human/telepathy
	name = "Телепатия"
	desc = "Редкая мутация, которая позволяет пользователю телепатически общаться с другими."
	quality = POSITIVE
	text_gain_indication = span_notice("Я слышу свой голос, эхом отдающийся в моей собственный голове!")
	text_lose_indication = span_notice("Эхо моего голоса исчезло...")
	difficulty = 12
	power = /obj/effect/proc_holder/spell/targeted/telepathy
	instability = 10
	energy_coeff = 1


/datum/mutation/human/olfaction
	name = "Сверхчувствительное обоняние"
	desc = "Изменяет обонятельные рецепторы подопытного, усиливая их чувствительность до уровня сравнимого с охотничьими гончими."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = span_notice("Запахи стали определяться намного четче...")
	text_lose_indication = span_notice("Я больше не чувствую всей палитры запахов.")
	power = /obj/effect/proc_holder/spell/targeted/olfaction
	instability = 15
	synchronizer_coeff = 1
	var/reek = 200

/datum/mutation/human/olfaction/modify()
	if(power)
		var/obj/effect/proc_holder/spell/targeted/olfaction/S = power
		S.sensitivity = GET_MUTATION_SYNCHRONIZER(src)

/obj/effect/proc_holder/spell/targeted/olfaction
	name = "Запомнить запах"
	desc = "Вы запоминаете запах предмета, который вы держите в руках, чтобы отследить его владельца. Если ваши руки пусты, то вы встанете на след запаха, который запомнили."
	charge_max = 100
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	action_icon_state = "nose"
	var/mob/living/carbon/tracking_target
	var/list/mob/living/carbon/possible = list()
	var/sensitivity = 1

/obj/effect/proc_holder/spell/targeted/olfaction/cast(list/targets, mob/living/user = usr)
	//can we sniff? is there miasma in the air?
	var/datum/gas_mixture/air = user.loc.return_air()

	if(air.get_moles(GAS_MIASMA) > 2)
		user.adjust_disgust(sensitivity * 45)
		to_chat(user, span_warning("УЖАСНАЯ ВОНЬ! Слишком отвратительный запах для моего чувствительного носа! Надо убраться отсюда подальше!"))
		return

	var/atom/sniffed = user.get_active_held_item()
	if(sniffed)
		var/old_target = tracking_target
		possible = list()
		var/list/prints = sniffed.return_fingerprints()
		if(prints)
			for(var/mob/living/carbon/C in GLOB.carbon_list)
				if(prints[md5(C.dna.uni_identity)])
					possible |= C
		if(!length(possible))
			to_chat(user,span_warning("Стараюсь учуять хоть что-то, но не могу уловить никаких запахов на [sniffed]..."))
			return
		tracking_target = input(user, "Выберите запах для отслеживания.", "Scent Tracking") as null|anything in sortNames(possible)
		if(!tracking_target)
			if(!old_target)
				to_chat(user,span_warning("Решаю не запоминать никаких запахов. Вместо этого замечаю свой собственный нос боковым зрением. Это напоминает мне день, когда я сконцентрировался на контроле своего дыхания и не мог остановиться потому что боялся задохнуться. Это был ужасный день."))
				return
			tracking_target = old_target
			on_the_trail(user)
			return
		to_chat(user,span_notice("Улавливаю запах [tracking_target]. Охота началась!"))
		on_the_trail(user)
		return

	if(!tracking_target)
		to_chat(user,span_warning("У меня нет ничего, что можно было бы понюхать, и я не чую ничего, что можно было бы отследить. Вместо этого нюхаю кожу на своей руке, она немного соленая."))
		return

	on_the_trail(user)

/obj/effect/proc_holder/spell/targeted/olfaction/proc/on_the_trail(mob/living/user)
	if(!tracking_target)
		to_chat(user,span_warning("ТЕХНИЧЕСКАЯ ОШИБКА, сообщите в кодербас. Носитель не идет по следу, но зафиксирован как идущий по следу."))
		return
	if(tracking_target == user)
		to_chat(user,span_warning("Чую след ведущий прямо к... ну да прямо ко мне..."))
		return
	if(usr.z < tracking_target.z)
		to_chat(user,span_warning("След тянется куда-то далеко-далеко в необозримые дали, вы не чувствуете присутствия вашей цели на обозримом горизонте."))
		return
	else if(usr.z > tracking_target.z)
		to_chat(user,span_warning("След тянется куда-то далеко-далеко в необозримые дали, вы не чувствуете присутствия вашей цели на обозримом горизонте."))
		return
	var/direction_text = "[dir2ru_text(get_dir(usr, tracking_target))]"
	if(direction_text)
		to_chat(user,span_notice("Улавливаю запах [tracking_target]. След ведет на <b>[direction_text].</b>"))

/datum/mutation/human/firebreath
	name = "Огненное Дыхание"
	desc = "Древняя мутация которая позволяет ящерам выдыхать струю пламени."
	quality = POSITIVE
	difficulty = 12
	locked = TRUE
	text_gain_indication = span_notice("Моя глотка горит адским пламенем!")
	text_lose_indication = span_notice("Пожар в горле потух.")
	power = /obj/effect/proc_holder/spell/aimed/firebreath
	instability = 30
	energy_coeff = 1
	power_coeff = 1

/datum/mutation/human/firebreath/modify()
	if(power)
		var/obj/effect/proc_holder/spell/aimed/firebreath/S = power
		S.strength = GET_MUTATION_POWER(src)

/obj/effect/proc_holder/spell/aimed/firebreath
	name = "Огненное дыхание"
	desc = "Сила дарованная Великим Ящером!"
	school = SCHOOL_EVOCATION
	charge_max = 600
	clothes_req = FALSE
	range = 20
	projectile_type = /obj/projectile/magic/aoe/fireball/firebreath
	base_icon_state = "fireball"
	action_icon_state = "fireball0"
	sound = 'sound/magic/demon_dies.ogg' //horrifying lizard noises
	active_msg = "Концентрирую пламя на кончике языка."
	deactive_msg = "Приглушаю пламя."
	var/strength = 1

/obj/effect/proc_holder/spell/aimed/firebreath/before_cast(list/targets)
	. = ..()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.is_mouth_covered())
			C.adjust_fire_stacks(2)
			C.ignite_mob()
			to_chat(C,span_warning("Гори!"))
			return FALSE

/obj/effect/proc_holder/spell/aimed/firebreath/ready_projectile(obj/projectile/P, atom/target, mob/user, iteration)
	if(!istype(P, /obj/projectile/magic/aoe/fireball))
		return
	var/obj/projectile/magic/aoe/fireball/F = P
	switch(strength)
		if(1 to 3)
			F.exp_light = strength-1
		if(4 to INFINITY)
			F.exp_heavy = strength-3
	F.exp_fire += strength

/obj/projectile/magic/aoe/fireball/firebreath
	name = "огненное дыхание"
	exp_heavy = 0
	exp_light = 0
	exp_flash = 0
	exp_fire= 4

/datum/mutation/human/void
	name = "Слияние с пустотой"
	desc = "Редкий геном, способный преодолеть законы эвклидового пространства и укрыть носителя за завесой мрачной и холодной пустоты мертвого космоса."
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = span_notice("Я ощущаю невероятную взгляд чего-то древнего и бесконечно огромного.")
	instability = 30
	power = /obj/effect/proc_holder/spell/self/void
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/void/on_life(delta_time, times_fired)
	if(!isturf(owner.loc))
		return
	if(DT_PROB((0.25+((100-dna.stability)/40)) * GET_MUTATION_SYNCHRONIZER(src), delta_time)) //very rare, but enough to annoy you hopefully. +0.5 probability for every 10 points lost in stability
		new /obj/effect/immortality_talisman/void(get_turf(owner), owner)

/obj/effect/proc_holder/spell/self/void
	name = "Зов пустоты" //magic the gathering joke here
	desc = "Редкий геном, способный преодолеть законы эвклидового пространства и укрыть носителя за завесой мрачной и холодной пустоты мертвого космоса. Пустота непредсказуема и иногда сама может посетить вас..."
	school = SCHOOL_EVOCATION
	clothes_req = FALSE
	charge_max = 600
	invocation = "Есть только пустота..."
	invocation_type = INVOCATION_SHOUT
	action_icon_state = "void_magnet"

/obj/effect/proc_holder/spell/self/void/can_cast(mob/user = usr)
	. = ..()
	if(!isturf(user.loc))
		return FALSE

/obj/effect/proc_holder/spell/self/void/cast(list/targets, mob/user = usr)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(user), user)


/datum/mutation/human/tongue_spike
	name = "Языковой шип"
	desc = "Позволяет произвести мгновенную коварную атаку, выстрелив в оппонента собственным языком."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя весьма острым на язык.")
	instability = 15
	power = /obj/effect/proc_holder/spell/self/tongue_spike

	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/tongue_spike
	name = "Выстрел шипом"
	desc = "Выстреливает языковым шипом в направлении вашего взгляда."
	clothes_req = FALSE
	human_req = TRUE
	charge_max = 100
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "spike"
	var/spike_path = /obj/item/hardened_spike

/obj/effect/proc_holder/spell/self/tongue_spike/cast(list/targets, mob/user = usr)
	if(!iscarbon(user))
		return

	var/mob/living/carbon/C = user
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return
	var/obj/item/organ/tongue/tongue
	for(var/org in C.internal_organs)
		if(istype(org, /obj/item/organ/tongue))
			tongue = org
			break

	if(!tongue)
		to_chat(C, span_notice("У меня нет языка!"))
		return

	tongue.Remove(C, special = TRUE)
	var/obj/item/hardened_spike/spike = new spike_path(get_turf(C), C)
	tongue.forceMove(spike)
	spike.throw_at(get_edge_target_turf(C,C.dir), 14, 4, C)

/obj/item/hardened_spike
	name = "языковой шип"
	desc = "Твердая биомасса в форме шипа. Очень острая!"
	icon_state = "tonguespike"
	force = 2
	throwforce = 15 //15 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math
	throw_speed = 4
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	custom_materials = list(/datum/material/biomass = 500)
	var/mob/living/carbon/human/fired_by
	/// if we missed our target
	var/missed = TRUE

/obj/item/hardened_spike/Initialize(mapload, firedby)
	. = ..()
	fired_by = firedby
	addtimer(CALLBACK(src, .proc/checkembedded), 5 SECONDS)

/obj/item/hardened_spike/proc/checkembedded()
	if(missed)
		unembedded()

/obj/item/hardened_spike/embedded(atom/target)
	if(isbodypart(target))
		missed = FALSE

/obj/item/hardened_spike/unembedded()
	var/turf/T = get_turf(src)
	visible_message(span_warning("[capitalize(src.name)] трескается и ломается, превращаясь в обычный кусок плоти!"))
	for(var/i in contents)
		var/obj/o = i
		o.forceMove(T)
	qdel(src)

/datum/mutation/human/tongue_spike/chem
	name = "Химический шип"
	desc = "Позволяет выстрелить в оппонента собственным языком, после чего перенести все химические препараты из вашей крови в цель."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя очень токсичным на язык.")
	instability = 15
	locked = TRUE
	power = /obj/effect/proc_holder/spell/self/tongue_spike/chem
	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/tongue_spike/chem
	name = "Выстрел хим-шипом"
	desc = "Выстреливает шип в направлении вашего взгляда, нанося очень слабый урон. Пока шип в теле жертвы вы можете передать ей все химикаты находящиеся в вашей крови."
	action_icon_state = "spikechem"
	spike_path = /obj/item/hardened_spike/chem

/obj/item/hardened_spike/chem
	name = "химический шип"
	desc = "Твердая биомасса в форме шипа. Кажется она полая внутри."
	icon_state = "tonguespikechem"
	throwforce = 2 //2 + 2 (WEIGHT_CLASS_SMALL) * 0 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math again but very low or smthin
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_pain_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE) //never hurts once it's in you
	var/been_places = FALSE
	var/datum/action/innate/send_chems/chems

/obj/item/hardened_spike/chem/embedded(mob/living/carbon/human/embedded_mob)
	if(been_places)
		return
	been_places = TRUE
	chems = new
	chems.transfered = embedded_mob
	chems.spikey = src
	to_chat(fired_by, span_notice("Связь установлена! Используйте \"Передачу химикатов\" для перемещения их из вашей крови в тело жертвы!"))
	chems.Grant(fired_by)

/obj/item/hardened_spike/chem/unembedded()
	to_chat(fired_by, span_warning("Связь потеряна!"))
	QDEL_NULL(chems)
	..()

/datum/action/innate/send_chems
	icon_icon = 'icons/mob/actions/actions_genetic.dmi'
	background_icon_state = "bg_spell"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "spikechemswap"
	name = "Передача химикатов"
	desc = "Перемещает все реагенты из вашей крови в тело жертвы."
	var/obj/item/hardened_spike/chem/spikey
	var/mob/living/carbon/human/transfered

/datum/action/innate/send_chems/Activate()
	if(!ishuman(transfered) || !ishuman(owner))
		return
	var/mob/living/carbon/human/transferer = owner

	to_chat(transfered, span_warning("Что-то укололо меня!"))
	transferer.reagents.trans_to(transfered, transferer.reagents.total_volume, 1, 1, 0, transfered_by = transferer)

	var/obj/item/bodypart/L = spikey.checkembedded()

	//this is where it would deal damage, if it transfers chems it removes itself so no damage
	spikey.forceMove(get_turf(L))
	transfered.visible_message(span_notice("[spikey] выпал из [transfered]!"))

//spider webs
/datum/mutation/human/webbing
	name = "Паутиновые железы"
	desc = "Позволяет носителю создавать паутину и беспрепятственно двигаться через нее."
	quality = POSITIVE
	text_gain_indication = span_notice("На запястьях появились странные железы, и из них тянется тонкая белесая нить.")
	instability = 15
	power = /obj/effect/proc_holder/spell/self/lay_genetic_web

/obj/effect/proc_holder/spell/self/lay_genetic_web
	name = "Создание паутины"
	desc = "Хорошее средство для самозащиты, замедляет потенциальных недоброжелателей, но не препятствует вашему движению."
	clothes_req = FALSE
	human_req = FALSE
	charge_max = 4 SECONDS //the same time to lay a web
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "lay_web"

/obj/effect/proc_holder/spell/self/lay_genetic_web/cast(list/targets, mob/user = usr)
	var/failed = FALSE
	if(!isturf(user.loc))
		to_chat(user, span_warning("Здесь сплести паутину не выйдет!"))
		failed = TRUE
	var/turf/T = get_turf(user)
	var/obj/structure/spider/stickyweb/genetic/W = locate() in T
	if(W)
		to_chat(user, span_warning("Тут уже есть паутина!"))
		failed = TRUE
	if(failed)
		revert_cast(user)
		return FALSE

	user.visible_message(span_notice("[user] начинает выделять липкую субстанцию из своих запястий.") ,span_notice("Начинаю плетение паутины..."))
	if(!do_after(user, 4 SECONDS, target = T))
		to_chat(user, span_warning("Мне помешали!"))
		return
	else
		new /obj/structure/spider/stickyweb/genetic(T, user)
