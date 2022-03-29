/datum/mutation/human/antenna
	name = "Антенна"
	desc = "Из головы носителя вырастает радиоантенна. Это позволяет ему общаться на базовых радиочастотах даже без внешней гарнитуры."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую как из мое головы вырастает антенна.")
	text_lose_indication = span_notice("Антенна вновь скрывается в голове.")
	instability = 5
	difficulty = 8
	var/datum/weakref/radio_weakref

/obj/item/implant/radio/antenna
	name = "радиочувствительный орган"
	desc = "Орган который позволяет носителю общаться на базовых радиочастотах даже без внешней гарнитуры."
	icon = 'icons/obj/radio.dmi'//maybe make a unique sprite later. not important
	icon_state = "walkietalkie"

/obj/item/implant/radio/antenna/Initialize(mapload)
	. = ..()
	radio.name = "органическая антенна"

/datum/mutation/human/antenna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	var/obj/item/implant/radio/antenna/linked_radio = new(owner)
	linked_radio.implant(owner, null, TRUE, TRUE)
	radio_weakref = WEAKREF(linked_radio)

/datum/mutation/human/antenna/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	var/obj/item/implant/radio/antenna/linked_radio = radio_weakref.resolve()
	if(linked_radio)
		QDEL_NULL(linked_radio)

/datum/mutation/human/antenna/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))//-MUTATIONS_LAYER+1

/datum/mutation/human/antenna/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/mindreader
	name = "Чтение мыслей"
	desc = "Носитель получает способность читать последние мысли цели, а так же определять его истинную суть."
	quality = POSITIVE
	text_gain_indication = span_notice("Я слышу отзвуки чужих мыслей...")
	text_lose_indication = span_notice("Эхо чужих мыслей ушло...")
	power = /obj/effect/proc_holder/spell/targeted/mindread
	instability = 40
	difficulty = 8
	locked = TRUE

/obj/effect/proc_holder/spell/targeted/mindread
	name = "Чтение мыслей"
	desc = "Прочитать последние мысли цели."
	charge_max = 50
	range = 7
	clothes_req = FALSE
	action_icon_state = "mindread"

/obj/effect/proc_holder/spell/targeted/mindread/cast(list/targets, mob/living/carbon/human/user = usr)
	for(var/mob/living/M in targets)
		if(usr.anti_magic_check(FALSE, FALSE, TRUE, 0) || M.anti_magic_check(FALSE, FALSE, TRUE, 0))
			to_chat(usr, span_warning("Пытаюсь настроиться на волну чужих мыслей, однако передо моим ментальным взором встает непреодолимая стена из фольги. Я не смогу ее преодолеть..."))
			return
		if(M.stat == DEAD)
			to_chat(user, span_boldnotice("[M] мертв! Это довольно неприятно ковыряться в голове покойника..."))
			return
		if(M.mind)
			to_chat(user, span_boldnotice("Вторгаюсь в разум [M]..."))
			if(prob(20))
				to_chat(M, span_danger("Чувствую кого то постороннего в своей голове."))//chance to alert the read-ee
				to_chat(user, span_danger("Меня обнаружили!"))
			var/list/recent_speech = list()
			var/list/say_log = list()
			var/log_source = M.logging
			for(var/log_type in log_source)//this whole loop puts the read-ee's say logs into say_log in an easy to access way
				var/nlog_type = text2num(log_type)
				if(nlog_type & LOG_SAY)
					var/list/reversed = log_source[log_type]
					if(islist(reversed))
						say_log = reverseRange(reversed.Copy())
						break
			if(LAZYLEN(say_log))
				for(var/spoken_memory in say_log)
					if(recent_speech.len >= 3)//up to 3 random lines of speech, favoring more recent speech
						break
					if(prob(50))
						recent_speech[spoken_memory] = say_log[spoken_memory]
			if(recent_speech.len)
				to_chat(user, span_boldnotice("Мне удалось уловить несколько последних мыслей..."))
				for(var/spoken_memory in recent_speech)
					to_chat(user, span_notice("[recent_speech[spoken_memory]]"))
			if(iscarbon(M))
				var/mob/living/carbon/human/H = M
				to_chat(user, span_boldnotice("Его намерения [H.a_intent]..."))
				if(H.mind)
					to_chat(user, span_boldnotice("Под личностью [H.ru_ego()] скрывается разум [H.mind.name]."))
		else
			to_chat(user, span_warning("Я не чувствую искры сознания в разуме [M]!"))

/datum/mutation/human/mindreader/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))

/datum/mutation/human/mindreader/get_visual_indicator()
	return visual_indicators[type][1]
