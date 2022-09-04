/datum/mutation/human/antenna
	name = "Антенна"
	desc = "Из головы носителя вырастает радиоантенна. Это позволяет ему общаться на базовых радиочастотах даже без внешней гарнитуры."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Чувствую как из мое головы вырастает антенна.</span>"
	text_lose_indication = "<span class='notice'>Антенна вновь скрывается в голове.</span>"
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
	text_gain_indication = "<span class='notice'>Я слышу отзвуки чужих мыслей...</span>"
	text_lose_indication = "<span class='notice'>Эхо чужих мыслей ушло...</span>"
	power_path = /datum/action/cooldown/spell/pointed/mindread
	instability = 40
	difficulty = 8
	locked = TRUE

/datum/action/cooldown/spell/pointed/mindread
	name = "Чтение мыслей"
	desc = "Прочитать последние мысли цели."
	button_icon_state = "mindread"
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	ranged_mousepointer = 'icons/effects/mouse_pointers/mindswap_target.dmi'

/datum/action/cooldown/spell/pointed/mindread/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/living_cast_on = cast_on
	if(!living_cast_on.mind)
		to_chat(owner, "<span class='warning'>[cast_on] не имеет разума!</span>")
		return FALSE
	if(living_cast_on.stat == DEAD)
		to_chat(owner, "<span class='warning'>[cast_on] мёртв!</span>")
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/mindread/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		to_chat(owner, "<span class='warning'>Пытаюсь настроиться на волну чужих мыслей, однако передо моим ментальным взором встает непреодолимая стена из фольги. Я не смогу ее преодолеть...</span>")
		return

	if(cast_on == owner)
		to_chat(owner, "<span class='warning'>Вторгаюсь в свой разум... Да, это мой разум.</span>")
		return

	to_chat(owner, "<span class='boldnotice'>Вторгаюсь в разум [cast_on]...</span>")
	if(prob(20))
		// chance to alert the read-ee
		to_chat(cast_on, "<span class='danger'>Чувствую кого то постороннего в своей голове.</span>")

	var/list/recent_speech = list()
	var/list/say_log = list()
	var/log_source = cast_on.logging
	//this whole loop puts the read-ee's say logs into say_log in an easy to access way
	for(var/log_type in log_source)
		var/nlog_type = text2num(log_type)
		if(nlog_type & LOG_SAY)
			var/list/reversed = log_source[log_type]
			if(islist(reversed))
				say_log = reverse_range(reversed.Copy())
				break

	for(var/spoken_memory in say_log)
		//up to 3 random lines of speech, favoring more recent speech
		if(length(recent_speech) >= 3)
			break
		if(prob(50))
			continue
		// log messages with tags like telepathy are displayed like "(Telepathy to Ckey/(target)) "greetings"""
		// by splitting the text by using a " delimiter, we can grab JUST the greetings part
		recent_speech[spoken_memory] = splittext(say_log[spoken_memory], "\"", 1, 0, TRUE)[3]

	if(length(recent_speech))
		to_chat(owner, "<span class='boldnotice'>Мне удалось уловить несколько последних мыслей...</span>")
		for(var/spoken_memory in recent_speech)
			to_chat(owner, "<span class='notice'>[recent_speech[spoken_memory]]</span>")

	if(iscarbon(cast_on))
		var/mob/living/carbon/carbon_cast_on = cast_on
		to_chat(owner, "<span class='boldnotice'>Его намерения [carbon_cast_on.a_intent]...</span>")
		to_chat(owner, "<span class='boldnotice'>Под личностью [carbon_cast_on.ru_ego()] скрывается разум [carbon_cast_on.mind.name].</span>")

/datum/mutation/human/mindreader/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))

/datum/mutation/human/mindreader/get_visual_indicator()
	return visual_indicators[type][1]
