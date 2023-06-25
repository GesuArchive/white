/obj/item/organ/tongue
	name = "язык"
	desc = "Мышца из плоти, в основном используется для того чтобы врать."
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb_continuous = list("лижет", "нализывает", "шлёпает", "французит", "язычит")
	attack_verb_simple = list("лижет", "нализывает", "шлёпает", "французит", "язычит")
	var/list/languages_possible
	var/say_mod = null

	/// Whether the owner of this tongue can taste anything. Being set to FALSE will mean no taste feedback will be provided.
	var/sense_of_taste = TRUE

	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/xoxol,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/arab,
		/datum/language/vampiric
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.UnregisterSignal(M, COMSIG_MOB_SAY)

	/* This could be slightly simpler, by making the removal of the
	* NO_TONGUE_TRAIT conditional on the tongue's `sense_of_taste`, but
	* then you can distinguish between ageusia from no tongue, and
	* ageusia from having a non-tasting tongue.
	*/
	REMOVE_TRAIT(M, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)
	if(!sense_of_taste)
		ADD_TRAIT(M, TRAIT_AGEUSIA, ORGAN_TRAIT)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.RegisterSignal(M, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon, handle_tongueless_speech))
	REMOVE_TRAIT(M, TRAIT_AGEUSIA, ORGAN_TRAIT)
	// Carbons by default start with NO_TONGUE_TRAIT caused TRAIT_AGEUSIA
	ADD_TRAIT(M, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)

/obj/item/organ/tongue/could_speak_language(language)
	return is_type_in_typecache(language, languages_possible)

/obj/item/organ/tongue/lizard
	name = "раздвоенный язык"
	desc = "Тонкая и длинная мышца, обычно такая есть у чешуйчатых рас. Так же выполняет роль носа."
	icon_state = "tonguelizard"
	say_mod = "шипит"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	modifies_speech = TRUE

/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("с+", "g")
	var/static/regex/lizard_hiSS = new("С+", "g")
	var/static/regex/lizard_kss = new("ш+", "g")
	var/static/regex/lizard_kSS = new("Ш+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace_char(message, "ссс")
		message = lizard_hiSS.Replace_char(message, "ССС")
		message = lizard_kss.Replace_char(message, "шшш")
		message = lizard_kSS.Replace_char(message, "ШШШ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/lizard/silver
	name = "silver tongue"
	desc = "A genetic branch of the high society Silver Scales that gives them their silverizing properties. To them, it is everything, and society traitors have their tongue forcibly revoked. Oddly enough, it itself is just blue."
	icon_state = "silvertongue"
	actions_types = list(/datum/action/item_action/organ_action/statue)

/datum/action/item_action/organ_action/statue
	name = "Become Statue"
	desc = "Become an elegant silver statue. Its durability and yours are directly tied together, so make sure you're careful."
	COOLDOWN_DECLARE(ability_cooldown)

	var/obj/structure/statue/custom/statue

/datum/action/item_action/organ_action/statue/New(Target)
	. = ..()
	statue = new
	RegisterSignal(statue, COMSIG_PARENT_QDELETING, PROC_REF(statue_destroyed))

/datum/action/item_action/organ_action/statue/Destroy()
	UnregisterSignal(statue, COMSIG_PARENT_QDELETING)
	QDEL_NULL(statue)
	. = ..()

/datum/action/item_action/organ_action/statue/Trigger(trigger_flags)
	. = ..()
	if(!iscarbon(owner))
		to_chat(owner, span_warning("Your body rejects the powers of the tongue!"))
		return
	var/mob/living/carbon/becoming_statue = owner
	if(becoming_statue.health < 1)
		to_chat(becoming_statue, span_danger("You are too weak to become a statue!"))
		return
	if(!COOLDOWN_FINISHED(src, ability_cooldown))
		to_chat(becoming_statue, span_warning("You just used the ability, wait a little bit!"))
		return
	var/is_statue = becoming_statue.loc == statue
	to_chat(becoming_statue, span_notice("You begin to [is_statue ? "break free from the statue" : "make a glorious pose as you become a statue"]!"))
	if(!do_after(becoming_statue, (is_statue ? 5 : 30), target = get_turf(becoming_statue)))
		to_chat(becoming_statue, span_warning("Your transformation is interrupted!"))
		COOLDOWN_START(src, ability_cooldown, 3 SECONDS)
		return
	COOLDOWN_START(src, ability_cooldown, 10 SECONDS)

	if(statue.name == initial(statue.name)) //statue has not been set up
		statue.name = "statue of [becoming_statue.real_name]"
		statue.desc = "statue depicting [becoming_statue.real_name]"
		statue.set_custom_materials(list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT*5))

	if(is_statue)
		statue.visible_message(span_danger("[statue] becomes animated!"))
		becoming_statue.forceMove(get_turf(statue))
		statue.moveToNullspace()
		UnregisterSignal(becoming_statue, COMSIG_MOVABLE_MOVED)
	else
		becoming_statue.visible_message(span_notice("[becoming_statue] hardens into a silver statue.") , span_notice("You have become a silver statue!"))
		statue.set_visuals(becoming_statue.appearance)
		statue.forceMove(get_turf(becoming_statue))
		becoming_statue.forceMove(statue)
		statue.obj_integrity = becoming_statue.health
		RegisterSignal(becoming_statue, COMSIG_MOVABLE_MOVED, PROC_REF(human_left_statue))

	//somehow they used an exploit/teleportation to leave statue, lets clean up
/datum/action/item_action/organ_action/statue/proc/human_left_statue(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER

	statue.moveToNullspace()
	UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)

/datum/action/item_action/organ_action/statue/proc/statue_destroyed(datum/source)
	to_chat(owner, span_userdanger("Your existence as a living creature snaps as your statue form crumbles!"))
	if(iscarbon(owner))
		//drop everything, just in case
		var/mob/living/carbon/dying_carbon = owner
		for(var/obj/item/dropped in dying_carbon)
			if(!dying_carbon.dropItemToGround(dropped))
				qdel(dropped)
	qdel(owner)

/obj/item/organ/tongue/fly
	name = "хоботок"
	desc = "Страшная мясная трубка, кажется через неё питаются."
	icon_state = "tonguefly"
	say_mod = "жужжит"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE
	var/static/list/languages_possible_fly = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/buzzwords
	))

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("з+", "g")
	var/static/regex/fly_buZZ = new("З+", "g")
	var/static/regex/fly_buss = new("с+", "g")
	var/static/regex/fly_buSS = new("С+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace_char(message, "ззз")
		message = fly_buZZ.Replace_char(message, "ЗЗЗ")
		message = fly_buss.Replace(message, "з")
		message = fly_buSS.Replace(message, "З")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_fly

/obj/item/organ/tongue/abductor
	name = "суперязыковая матрица"
	desc = "Таинственная структура, которая позволяет мгновенно общаться с другими пользователями. Довольно интересная вещь, только есть не удобно."
	icon_state = "tongueayylmao"
	say_mod = "тараторит"
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, span_notice("[capitalize(src.name)] уже настроен на твой канал."))

	H.visible_message(span_notice("[H] держит [src] в руках и сосредотачивается на мгновение") , span_notice("Ты пытаешься модифицировать связи [src]."))
	if(do_after(H, delay=15, target=src))
		to_chat(H, span_notice("Ты настраиваешь [src] на свои канал."))
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || HAS_TRAIT(M.mind, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += "<hr><span class='notice'>Он не подключен к кораблю.</span>"
		else
			. += "<hr><span class='notice'>Он подключен к [mothership].</span>"

/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args)
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = source
	var/rendered = span_abductor("<b>[user.real_name]:</b> [message]")
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/abductor/T = H.get_organ_slot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		if(mothership == T.mothership)
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/zombie
	name = "гнилой язык"
	desc = "Благодаря разложению и тому факту, что он тут просто лежит вы задумываетесь о том, может ли язык выглядеть еще менее сексуально."
	icon_state = "tonguezombie"
	say_mod = "мычит"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, -3) == "..."))//3 == length("...")
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("МОЗГИ", "Мозги", "Мооозгиииии", "МОООЗГИИИИИ")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/zombie/mutant
	name = "гнилой язык"
	desc = "Этот орган просто выглядит как язык. На самом деле это сложный продукт направленных мутаций, котороый позволяет этим существам общаться друг с другом."
	icon_state = "tonguezombie"
	say_mod = "мычит"
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/mutant/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = source
	var/rendered = "<font color=\"#4b5320\"><b>\[Zombie hivemind\] [user.real_name]</b> [message]</font>"
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/zombie/mutant/T = H.get_organ_slot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		else
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/alien
	name = "язык чужого"
	desc = "По мнению ведущих ксенобиологов, эволюционное преимущество от второго рта в том \"что это выглядит круто\"."
	icon_state = "tonguexeno"
	say_mod = "шипит"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/monkey))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	playsound(owner, "hiss", 25, TRUE, TRUE)

/obj/item/organ/tongue/bone
	name = "костяной \"язык\""
	desc = "Выяснилось, что скелеты используют вместо языка скрежет своих зубов, отсюда и постоянное дребезжание."
	icon_state = "tonguebone"
	say_mod = "костлявит"
	attack_verb_continuous = list("кусает", "прокусывает", "откусывает", "шутит", "костирует")
	attack_verb_simple = list("кусает", "прокусывает", "откусывает", "шутит", "костирует")
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")
	var/static/list/languages_possible_skeleton = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/calcic
	))

/obj/item/organ/tongue/bone/Initialize(mapload)
	. = ..()
	phomeme_type = pick(phomeme_types)
	languages_possible = languages_possible_skeleton

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "плазменная кость \"языка\""
	desc = "Как и у скелетов, плазмалюди используют вместо языка скрежет зубов чтобы общаться."
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "синтезатор голоса"
	desc = "Синтезатор голоса используемый для взаимодействия с органическими формами жизни."
	status = ORGAN_ROBOTIC
	organ_flags = NONE
	icon_state = "tonguerobot"
	say_mod = "констатирует"
	attack_verb_continuous = list("бипает", "бупает")
	attack_verb_simple = list("бипает", "бупает")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/tongue/robot/can_speak_language(language)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "радула"
	color = "#96DB00" // TODO proper sprite, rather than recoloured pink tongue
	desc = "A minutely toothed, chitious ribbon, which as a side effect, makes all snails talk IINNCCRREEDDIIBBLLYY SSLLOOWWLLYY."
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length_char(message))
		if(findtext_char("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/ethereal
	name = "электрический разрядник"
	desc = "Сложный эфирный орган, способный синтезировать речь с помощью электрических разрядов."
	icon_state = "electrotongue"
	say_mod = "искрит"
	attack_verb_continuous = list("шокирует", "жалит", "ебошит током")
	attack_verb_simple = list("шокирует", "жалит", "ебошит током")
	sense_of_taste = FALSE
	var/static/list/languages_possible_ethereal = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/voltaic
	))

/obj/item/organ/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_ethereal

//Sign Language Tongue - yep, that's how you speak sign language.
/obj/item/organ/tongue/tied
	name = "завязанный язык"
	desc = "Вот бы у кого-то был меч, чтобы разрубить этот узел. Если ты видишь это, то что-то неправильно запрогано."
	say_mod = "поёт"
	icon_state = "tonguetied"
	modifies_speech = TRUE
	organ_flags = ORGAN_UNREMOVABLE
	// The tonal indicator shown when we finish sending a message. If it's empty, none appears.
	var/tonal_indicator = null
	// The timerid for our tonal indicator
	var/tonal_timerid

/obj/item/organ/tongue/tied/Insert(mob/living/carbon/signer)
	. = ..()
	signer.verb_ask = "воспевает"
	signer.verb_exclaim = "напевает"
	signer.verb_whisper = "поёт"
	signer.verb_sing = "ритмично поёт"
	signer.verb_yell = "эмпатично поёт"
	signer.bubble_icon = "signlang"
	ADD_TRAIT(signer, TRAIT_SIGN_LANG, "tongue")
	REMOVE_TRAIT(signer, TRAIT_MUTE, "tongue")
	RegisterSignal(signer, COMSIG_MOVABLE_USING_RADIO, PROC_REF(on_use_radio))

/obj/item/organ/tongue/tied/Remove(mob/living/carbon/speaker, special = 0)
	..()
	speaker.verb_ask = initial(speaker.verb_ask)
	speaker.verb_exclaim = initial(speaker.verb_exclaim)
	speaker.verb_whisper = initial(speaker.verb_whisper)
	speaker.verb_sing = initial(speaker.verb_sing)
	speaker.verb_yell = initial(speaker.verb_yell)
	speaker.bubble_icon = initial(speaker.bubble_icon)
	REMOVE_TRAIT(speaker, TRAIT_SIGN_LANG, "tongue") //People who are Ahealed get "cured" of their sign language-having ways. If I knew how to make the tied tongue persist through aheals, I'd do that.
	UnregisterSignal(speaker, COMSIG_MOVABLE_USING_RADIO)

/obj/item/organ/tongue/tied/handle_speech(datum/source, list/speech_args)
	// The message we send instead of our normal one
	var/new_message
	// The original message
	var/message = speech_args[SPEECH_MESSAGE]
	// Is there a !
	var/exclamation_found = findtext(message, "!")
	// Is there a ?
	var/question_found = findtext(message, "?")
	new_message = message
	if(exclamation_found)
		new_message = replacetext(new_message, "!", ".")
	if(question_found)
		new_message = replacetext(new_message, "?", ".")
	speech_args[SPEECH_MESSAGE] = new_message

	if(question_found) // Prioritize questions
		tonal_indicator = mutable_appearance('icons/mob/talk.dmi', "signlang1", TYPING_LAYER, src, SOUND_EFFECT_VISUAL_PLANE)
		owner.visible_message(span_notice("[owner] опускает брови."))
	else if(exclamation_found)
		tonal_indicator = mutable_appearance('icons/mob/talk.dmi', "signlang2", TYPING_LAYER, src, SOUND_EFFECT_VISUAL_PLANE)
		owner.visible_message(span_notice("[owner] поднимает брови."))
	if(!isnull(tonal_indicator) && owner?.client.typing_indicators)
		owner.add_overlay(tonal_indicator)
		tonal_timerid = addtimer(CALLBACK(src, PROC_REF(remove_tonal_indicator)), 2.5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else // If we're not gonna use it, just be sure we get rid of it
		tonal_indicator = null

/obj/item/organ/tongue/tied/proc/remove_tonal_indicator()
	if(isnull(tonal_indicator))
		return
	owner.cut_overlay(tonal_indicator)
	tonal_indicator = null

/// Signal proc for [COMSIG_MOVABLE_USING_RADIO] that disallows us from speaking on comms if we don't have the special trait
/// Being unable to sign, or having our message be starred out, is handled by the above two signal procs.
/obj/item/organ/tongue/tied/proc/on_use_radio(atom/movable/source, obj/item/radio/radio)
	SIGNAL_HANDLER

	return HAS_TRAIT(source, TRAIT_CAN_SIGN_ON_COMMS) ? NONE : COMPONENT_CANNOT_USE_RADIO
