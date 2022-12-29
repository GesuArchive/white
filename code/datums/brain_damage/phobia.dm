/datum/brain_trauma/mild/phobia
	name = "Фобия"
	desc = "Пациент чего-то беспричинно боится."
	scan_desc = "<b>фобии</b>"
	gain_text = span_warning("You start finding default values very unnerving...")
	lose_text = span_notice("You no longer feel afraid of default values.")
	var/phobia_type
	var/phobia_ru
	/// Cooldown for proximity checks so we don't spam a range 7 view every two seconds.
	COOLDOWN_DECLARE(check_cooldown)
	/// Cooldown for freakouts to prevent permastunning.
	COOLDOWN_DECLARE(scare_cooldown)

	var/regex/trigger_regex
	//instead of cycling every atom, only cycle the relevant types
	var/list/trigger_mobs
	var/list/trigger_objs //also checked in mob equipment
	var/list/trigger_turfs
	var/list/trigger_species
	var/list/trigger_persons

/datum/brain_trauma/mild/phobia/New(new_phobia_type, specific_person = null)
	if(new_phobia_type)
		phobia_type = new_phobia_type

	if(specific_person)
		phobia_type = "ptsd"
		gain_text = span_warning("Кто-то меня до чёртиков пугает...")
		lose_text = span_notice("Да кого вообще волнует [specific_person]?!")
		scan_desc += " \"[phobia_ru]\""
		var/list/names = splittext_char(specific_person, " ")
		var/words_match = ""
		for(var/word in names)
			words_match += "[REGEX_QUOTE(word)]|"
		words_match = copytext_char(words_match, 1, -1)
		trigger_regex = regex("(\\b|\\A)([words_match])('?s*)(\\b|\\|)", "ig")
		for(var/mob/M in GLOB.mob_list)
			if(M.real_name == specific_person)
				trigger_persons = list(M)
		return ..()

	if(!phobia_type)
		phobia_type = pick(SStraumas.phobia_types)

	gain_text = span_warning("[capitalize(phobia_ru)] меня пугают...")
	lose_text = span_notice("Да кого вообще волнуют [phobia_ru]?!")
	scan_desc += " \"[phobia_ru]\""
	trigger_regex = SStraumas.phobia_regexes[phobia_type]
	trigger_mobs = SStraumas.phobia_mobs[phobia_type]
	trigger_objs = SStraumas.phobia_objs[phobia_type]
	trigger_turfs = SStraumas.phobia_turfs[phobia_type]
	trigger_species = SStraumas.phobia_species[phobia_type]
	..()

/datum/brain_trauma/mild/phobia/on_life(delta_time, times_fired)
	..()
	if(HAS_TRAIT(owner, TRAIT_FEARLESS))
		return
	if(owner.is_blind())
		return

	if(!COOLDOWN_FINISHED(src, check_cooldown) || !COOLDOWN_FINISHED(src, scare_cooldown))
		return

	COOLDOWN_START(src, check_cooldown, 5 SECONDS)
	var/list/seen_atoms = view(7, owner)
	if(LAZYLEN(trigger_objs))
		for(var/obj/O in seen_atoms)
			if(is_type_in_typecache(O, trigger_objs) || (phobia_type == "blood" && GET_ATOM_BLOOD_DNA_LENGTH(O)))
				freak_out(O)
				return
		for(var/mob/living/carbon/human/HU in seen_atoms) //check equipment for trigger items
			for(var/X in HU.get_all_slots() | HU.held_items)
				var/obj/I = X
				if(!QDELETED(I) && (is_type_in_typecache(I, trigger_objs) || (phobia_type == "blood" && GET_ATOM_BLOOD_DNA_LENGTH(I))))
					freak_out(I)
					return

	if(LAZYLEN(trigger_turfs))
		for(var/turf/T in seen_atoms)
			if(is_type_in_typecache(T, trigger_turfs))
				freak_out(T)
				return

	seen_atoms -= owner //make sure they aren't afraid of themselves.
	if(LAZYLEN(trigger_mobs) || LAZYLEN(trigger_species) || LAZYLEN(trigger_persons))
		for(var/mob/M in seen_atoms)
			if(is_type_in_typecache(M, trigger_mobs))
				freak_out(M)
				return

			else if(LAZYLEN(trigger_persons) && (M in trigger_persons))
				freak_out(M)
				return

			else if(ishuman(M)) //check their species
				var/mob/living/carbon/human/H = M
				if(LAZYLEN(trigger_species) && H.dna && H.dna.species && is_type_in_typecache(H.dna.species, trigger_species))
					freak_out(H)
					return

/datum/brain_trauma/mild/phobia/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || !COOLDOWN_FINISHED(src, scare_cooldown)) //words can't trigger you if you can't hear them *taps head*
		return
	if(HAS_TRAIT(owner, TRAIT_FEARLESS))
		return
	if(!owner.has_language(hearing_args[HEARING_LANGUAGE])) //can't be triggered if you don't know the language
		return
	if(trigger_regex.Find(hearing_args[HEARING_RAW_MESSAGE]) != 0)
		addtimer(CALLBACK(src, PROC_REF(freak_out), null, trigger_regex.group[2]), 10) //to react AFTER the chat message
		hearing_args[HEARING_RAW_MESSAGE] = trigger_regex.Replace_char(hearing_args[HEARING_RAW_MESSAGE], "<span class='phobia'>$2</span>$3")

/datum/brain_trauma/mild/phobia/handle_speech(datum/source, list/speech_args)
	if(HAS_TRAIT(owner, TRAIT_FEARLESS))
		return
	if(trigger_regex.Find(speech_args[SPEECH_MESSAGE]) != 0)
		to_chat(owner, span_warning("ОЧЕНЬ СТРАШНО СКАЗАТЬ СЛОВО \"<span class='phobia'>[uppertext(trigger_regex.group[2])]</span>\"!"))
		speech_args[SPEECH_MESSAGE] = ""

/datum/brain_trauma/mild/phobia/proc/freak_out(atom/reason, trigger_word)
	COOLDOWN_START(src, scare_cooldown, 12 SECONDS)
	if(owner.stat == DEAD)
		return
	var/message = pick("пугает меня до костей", "заставляет меня дрожать", "пугает меня", "заставляет меня паниковать", "бросает меня в холодный пот")
	if(reason)
		to_chat(owner, span_userdanger("[capitalize(reason.name)] [message]!"))
	else if(trigger_word)
		to_chat(owner, span_userdanger("\"[capitalize(trigger_word)]\" [message]!"))
	else
		to_chat(owner, span_userdanger("Что-то [message]!"))
	var/reaction = rand(1,4)
	switch(reaction)
		if(1)
			to_chat(owner, span_warning("Ох!"))
			owner.Stun(70)
			owner.Jitter(8)
		if(2)
			owner.emote("agony")
			owner.Jitter(5)
			owner.say("ААААААА!!", forced = "phobia")
			if(reason)
				owner.pointed(reason)
		if(3)
			to_chat(owner, span_warning("Какой ужас!"))
			owner.Jitter(5)
			owner.blind_eyes(10)
		if(4)
			owner.dizziness += 10
			owner.add_confusion(10)
			owner.Jitter(10)
			owner.stuttering += 10

// Defined phobia types for badminry, not included in the RNG trauma pool to avoid diluting.

/datum/brain_trauma/mild/phobia/spiders
	phobia_type = "spiders"
	phobia_ru = "пауков"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/space
	phobia_type = "space"
	phobia_ru = "космоса"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/security
	phobia_type = "security"
	phobia_ru = "охранников"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/clowns
	phobia_type = "clowns"
	phobia_ru = "клоунов"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/greytide
	phobia_type = "greytide"
	phobia_ru = "ассистентов"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/lizards
	phobia_type = "lizards"
	phobia_ru = "ящеров"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/skeletons
	phobia_type = "skeletons"
	phobia_ru = "скелетов"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/snakes
	phobia_type = "snakes"
	phobia_ru = "змей"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/robots
	phobia_type = "robots"
	phobia_ru = "роботов"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/doctors
	phobia_type = "doctors"
	phobia_ru = "врачей"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/authority
	phobia_type = "authority"
	phobia_ru = "глав"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/supernatural
	phobia_type = "the supernatural"
	phobia_ru = "сверхъестественных вещей"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/aliens
	phobia_type = "aliens"
	phobia_ru = "пришельцев"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/strangers
	phobia_type = "strangers"
	phobia_ru = "незнакомцев"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/birds
	phobia_type = "birds"
	phobia_ru = "птиц"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/falling
	phobia_type = "falling"
	phobia_ru = "на падения"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/anime
	phobia_type = "anime"
	phobia_ru = "анимешников"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/conspiracies
	phobia_type = "conspiracies"
	phobia_ru = "конспирации"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/insects
	phobia_type = "insects"
	phobia_ru = "насекомых"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/blood
	phobia_type = "blood"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/ptsdr
	phobia_type = "ptsd"
	phobia_ru = "ПТСР"
	random_gain = FALSE
