GLOBAL_LIST_INIT(department_radio_prefixes, list(":", "."))

GLOBAL_LIST_INIT(department_radio_keys, list(
	// Location
	MODE_KEY_R_HAND = MODE_R_HAND,
	MODE_KEY_L_HAND = MODE_L_HAND,
	MODE_KEY_INTERCOM = MODE_INTERCOM,

	// Department
	MODE_KEY_DEPARTMENT = MODE_DEPARTMENT,
	RADIO_KEY_COMMAND = RADIO_CHANNEL_COMMAND,
	RADIO_KEY_SCIENCE = RADIO_CHANNEL_SCIENCE,
	RADIO_KEY_MEDICAL = RADIO_CHANNEL_MEDICAL,
	RADIO_KEY_ENGINEERING = RADIO_CHANNEL_ENGINEERING,
	RADIO_KEY_SECURITY = RADIO_CHANNEL_SECURITY,
	RADIO_KEY_SUPPLY = RADIO_CHANNEL_SUPPLY,
	RADIO_KEY_EXPLORATION = RADIO_CHANNEL_EXPLORATION,
	RADIO_KEY_SERVICE = RADIO_CHANNEL_SERVICE,

	// Faction
	RADIO_KEY_SYNDICATE = RADIO_CHANNEL_SYNDICATE,
	RADIO_KEY_CENTCOM = RADIO_CHANNEL_CENTCOM,
	RADIO_KEY_FACTION = RADIO_CHANNEL_FACTION,
	RADIO_KEY_YOHEI = RADIO_CHANNEL_YOHEI,

	// Admin
	MODE_KEY_ADMIN = MODE_ADMIN,
	MODE_KEY_DEADMIN = MODE_DEADMIN,

	// Misc
	RADIO_KEY_AI_PRIVATE = RADIO_CHANNEL_AI_PRIVATE, // AI Upload channel


	//kinda localization -- rastaf0
	//same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	// Location
	"к" = MODE_R_HAND,
	"д" = MODE_L_HAND,
	"ш" = MODE_INTERCOM,

	// Department
	"р" = MODE_DEPARTMENT,
	"с" = RADIO_CHANNEL_COMMAND,
	"т" = RADIO_CHANNEL_SCIENCE,
	"ь" = RADIO_CHANNEL_MEDICAL,
	"у" = RADIO_CHANNEL_ENGINEERING,
	"ы" = RADIO_CHANNEL_SECURITY,
	"г" = RADIO_CHANNEL_SUPPLY,
	"м" = RADIO_CHANNEL_SERVICE,
	"й" = RADIO_CHANNEL_EXPLORATION,

	// Faction
	"е" = RADIO_CHANNEL_SYNDICATE,
	"н" = RADIO_CHANNEL_CENTCOM,

	// Admin
	"з" = MODE_ADMIN,
	"в" = MODE_DEADMIN,

	// Misc
	"щ" = RADIO_CHANNEL_AI_PRIVATE
))

/**
 * Whitelist of saymodes or radio extensions that can be spoken through even if not fully conscious.
 * Associated values are their maximum allowed mob stats.
 */
GLOBAL_LIST_INIT(message_modes_stat_limits, list(
	MODE_INTERCOM = HARD_CRIT,
	MODE_ALIEN = HARD_CRIT,
	MODE_CHANGELING = HARD_CRIT,
	MODE_BINARY = HARD_CRIT, //extra stat check on human/binarycheck()
	MODE_MONKEY = HARD_CRIT,
	MODE_MAFIA = HARD_CRIT
))

/mob/living/proc/Ellipsis(original_msg, chance = 50, keep_words)
	if(chance <= 0)
		return "..."
	if(chance >= 100)
		return original_msg

	var/list/words = splittext(original_msg," ")
	var/list/new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
			if(!keep_words)
				continue
		new_words += w

	new_msg = jointext(new_words," ")

	return new_msg

/mob/living/say(message, bubble_type,list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(sanitize)
		message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message || message == "")
		return

	var/list/message_mods = list()
	var/original_message = message
	message = get_message_mods(message, message_mods)
	var/datum/saymode/saymode = SSradio.saymodes[message_mods[RADIO_KEY]]

	if(!message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_ADMIN)
		client?.cmd_admin_say(message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_DEADMIN)
		client?.dsay(message)
		return

	// dead is the only state you can never emote
	if(stat != DEAD && check_emote(original_message, forced))
		return

	// Checks if the saymode or channel extension can be used even if not totally conscious.
	var/say_radio_or_mode = saymode || message_mods[RADIO_EXTENSION]
	if(say_radio_or_mode)
		var/mob_stat_limit = GLOB.message_modes_stat_limits[say_radio_or_mode]
		if(stat > (isnull(mob_stat_limit) ? CONSCIOUS : mob_stat_limit))
			saymode = null
			message_mods -= RADIO_EXTENSION

	switch(stat)
		if(SOFT_CRIT)
			message_mods[WHISPER_MODE] = MODE_WHISPER
		if(UNCONSCIOUS)
			return
		if(HARD_CRIT)
			if(!message_mods[WHISPER_MODE])
				return
		if(DEAD)
			say_dead(original_message)
			return

	if(client && SSlag_switch.measures[SLOWMODE_SAY] && !HAS_TRAIT(src, TRAIT_BYPASS_MEASURES) && !forced && src == usr)
		if(!COOLDOWN_FINISHED(client, say_slowmode))
			to_chat(src, span_warning("Сообщение не было отправлено из-за ограничений. Подождите [SSlag_switch.slowmode_cooldown/10] секунд перед отправкой нового.\n\"[message]\""))
			return
		COOLDOWN_START(client, say_slowmode, SSlag_switch.slowmode_cooldown)

	if(!can_speak_basic(original_message, ignore_spam, forced))
		return

	language = message_mods[LANGUAGE_EXTENSION]

	if(!language)
		language = get_selected_language()
	var/mob/living/carbon/human/H = src
	if(!can_speak_vocal(message) && !message_mods[MODE_CHANGELING])
		if (HAS_TRAIT(src, TRAIT_SIGN_LANG) && H.mind.miming)
			to_chat(src, span_warning("Не могу петь!"))
			return
		else
			to_chat(src, span_warning("Не могу говорить!"))
			return

	var/message_range = 7

	var/succumbed = FALSE

	if(message_mods[WHISPER_MODE] == MODE_WHISPER)
		message_range = 1
		log_talk(message, LOG_WHISPER)
		if(stat == HARD_CRIT)
			var/health_diff = round(-HEALTH_THRESHOLD_DEAD + health)
			// If we cut our message short, abruptly end it with a-..
			var/message_len = length_char(message)
			message = copytext_char(message, 1, health_diff) + "[message_len > health_diff ? "-.." : "..."]"
			message = Ellipsis(message, 10, 1)
			last_words = message
			message_mods[WHISPER_MODE] = MODE_WHISPER_CRIT
			succumbed = TRUE
	else
		log_talk(message, LOG_SAY, forced_by=forced)

	message = treat_message(message) // unfortunately we still need this
	var/sigreturn = SEND_SIGNAL(src, COMSIG_MOB_SAY, args)
	if (sigreturn & COMPONENT_UPPERCASE_SPEECH)
		message = uppertext(message)
	if(!message)
		return

	spans |= speech_span

	if(language)
		var/datum/language/L = GLOB.language_datum_instances[language]
		spans |= L.spans

	if(message_mods[MODE_SING])
		var/randomnote = pick("\u2669", "\u266A", "\u266B")
		message = "[randomnote] [message] [randomnote]"
		spans |= SPAN_SINGING

	//This is before anything that sends say a radio message, and after all important message type modifications, so you can scumb in alien chat or something
	if(saymode && !saymode.handle_message(src, message, language))
		return
	var/radio_message = message
	if(message_mods[WHISPER_MODE])
		// radios don't pick up whispers very well
		radio_message = stars(radio_message)
		spans |= SPAN_ITALICS
	var/radio_return = radio(radio_message, message_mods, spans, language)
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1
	if(radio_return & NOPASS)
		return 1

	//No screams in space, unless you're next to someone.
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if(pressure < ONE_ATMOSPHERE*0.4) //Thin air, let's italicise the message
			spans |= SPAN_ITALICS

	send_speech(message, message_range, src, bubble_type, spans, language, message_mods)

	if(succumbed)
		succumb(1)
		to_chat(src, compose_message(src, language, message, , spans, message_mods))

	return 1

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)
	if(!client)
		return

	var/deaf_message
	var/deaf_type

	if(HAS_TRAIT(speaker, TRAIT_SIGN_LANG)) //Checks if speaker is using sign language
		deaf_message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
		if(speaker != src)
			if(!radio_freq) //I'm about 90% sure there's a way to make this less cluttered
				deaf_type = 1
		else
			deaf_type = 2

		// Create map text prior to modifying message for goonchat, sign lang edition
		if (client?.prefs.chat_on_map && !(stat == UNCONSCIOUS || stat == HARD_CRIT || is_blind(src)) && (client.prefs.see_chat_non_mob || ismob(speaker)))
			create_chat_message(speaker, message_language, raw_message, spans)

		if(is_blind(src))
			return FALSE

		message = deaf_message

		show_message(message, MSG_VISUAL, deaf_message, deaf_type, avoid_highlighting = speaker == src)
		return message

	if(speaker != src)
		if(!radio_freq) //These checks have to be seperate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "<span class='name'>[capitalize(speaker.name)]</span> [speaker.verb_say] что-то, но не могу понять что."
			deaf_type = 1
	else
		deaf_message = span_notice("Не слышу себя!")
		deaf_type = 2 // Since you should be able to hear yourself without looking

	// Create map text prior to modifying message for goonchat
	if (client?.prefs.chat_on_map && !(stat == UNCONSCIOUS || stat == HARD_CRIT) && (ismob(speaker) || client.prefs.see_chat_non_mob || ismob(speaker)) && can_hear())
		create_chat_message(speaker, message_language, raw_message, spans)

	// Recompose message for AI hrefs, language incomprehension.
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)

	show_message(message, MSG_AUDIBLE, deaf_message, deaf_type, avoid_highlighting = speaker == src)
	return message

/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, list/message_mods = list())
	var/eavesdrop_range = 0
	if(message_mods[WHISPER_MODE]) //If we're whispering
		eavesdrop_range = EAVESDROP_EXTRA_RANGE
	var/list/listening = get_hearers_in_view(message_range+eavesdrop_range, source)
	var/list/the_dead = list()
	if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
		var/mob/living/carbon/mute = src
		if(istype(mute))
			var/empty_indexes = get_empty_held_indexes() //How many hands the player has empty
			if(length(empty_indexes) == 1 || !mute.get_bodypart(BODY_ZONE_L_ARM) || !mute.get_bodypart(BODY_ZONE_R_ARM))
				message = stars(message)
			if(length(empty_indexes) == 0 || (length(empty_indexes) < 2 && (!mute.get_bodypart(BODY_ZONE_L_ARM) || !mute.get_bodypart(BODY_ZONE_R_ARM))))//All existing hands full, can't sign
				mute.visible_message("tries to sign, but can't with [src.ru_ego()] hands full!</span.?>", visible_message_flags = EMOTE_MESSAGE)
				return FALSE
			if(!mute.get_bodypart(BODY_ZONE_L_ARM) && !mute.get_bodypart(BODY_ZONE_R_ARM))//Can't sign with no arms!
				to_chat(src, "<span class='warning'>You can't sign with no hands!</span.?>")
				return FALSE
			if(mute.handcuffed)//Can't sign when your hands are cuffed, but can at least make a visual effort to
				mute.visible_message("tries to sign, but can't with [src.ru_ego()] hands bound!</span.?>", visible_message_flags = EMOTE_MESSAGE)
				return FALSE
			if(HAS_TRAIT(mute, TRAIT_HANDS_BLOCKED) || HAS_TRAIT(mute, TRAIT_EMOTEMUTE))
				to_chat(src, "<span class='warning'>You can't sign at the moment!</span.?>")
				return FALSE
	if(client) //client is so that ghosts don't have to listen to mice
		for(var/_M in GLOB.player_list)
			var/mob/M = _M
			if(QDELETED(M))	//Some times nulls and deleteds stay in this list. This is a workaround to prevent ic chat breaking for everyone when they do.
				continue	//Remove if underlying cause (likely byond issue) is fixed. See TG PR #49004.
			if(M.stat != DEAD) //not dead, not important
				continue
			if(M.z != z || get_dist(M, src) > 7) //they're out of range of normal hearing
				if(eavesdrop_range)
					if(!(M.client.prefs?.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
						continue
				else if(!(M.client.prefs?.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
					continue
			listening |= M
			the_dead[M] = TRUE

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(src, message_language, eavesdropping, , spans, message_mods)

	var/rendered = compose_message(src, message_language, message, , spans, message_mods)
	var/list/listened = list()
	for(var/atom/movable/listening_movable as anything in listening)
		if(!listening_movable)
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue
		if(eavesdrop_range && get_dist(source, listening_movable) > message_range && !(the_dead[listening_movable]))
			listening_movable.Hear(eavesrendered, src, message_language, eavesdropping, , spans, message_mods)
		else
			listening_movable.Hear(rendered, src, message_language, message, , spans, message_mods)
		listened += listening_movable
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	var/found_client = FALSE
	for(var/mob/M in listening)
		if(M.client || (SSlag_switch.measures[DISABLE_RUNECHAT] && !HAS_TRAIT(src, TRAIT_BYPASS_MEASURES)))
			speech_bubble_recipients.Add(M.client)
			found_client = TRUE

	if(found_client && !HAS_TRAIT(src, TRAIT_SIGN_LANG) && !message_mods[MODE_HEADSET])
		var/frequency = 0
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			frequency = 32000 - (H.age * 200)
			if(H.skin_tone in list("african1", "african2"))
				frequency *= 0.75

			if(HAS_TRAIT(src, TRAIT_CLUMSY) || isfelinid(src))
				frequency *= 1.25

		last_freq = frequency

		if(voice != "sentrybot" && (issilicon(src) || isandroid(src) || is_ipc(src)))
			voice = pick("sentrybot", "glados_alt", "adventure_core_alt", "space_core_alt", "fact_core_alt", "turret_floor")

		INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), src, html_decode(message), message_language, voice, listened, message_range = message_range, freq = frequency)

	var/image/say_popup = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
	SET_PLANE_EXPLICIT(say_popup, ABOVE_GAME_PLANE, src)
	say_popup.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), say_popup, speech_bubble_recipients, 3 SECONDS)
	LAZYADD(update_on_z, say_popup)
	addtimer(CALLBACK(src, PROC_REF(clear_saypopup), say_popup), 3.5 SECONDS)

/mob/living/proc/clear_saypopup(image/say_popup)
	LAZYREMOVE(update_on_z, say_popup)

/mob/proc/binarycheck()
	return FALSE

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return TRUE

/mob/living/proc/can_speak_basic(message, ignore_spam = FALSE, forced = FALSE) //Check BEFORE handling of xeno and ling channels
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_danger("You cannot speak in IC (muted)."))
			return FALSE
		if(!(ignore_spam || forced) && client.handle_spam_prevention(message,MUTE_IC))
			return FALSE

	return TRUE

/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	var/mob/living/carbon/human/H = src
	if(HAS_TRAIT(src, TRAIT_MUTE))
		return (HAS_TRAIT(src, TRAIT_SIGN_LANG) && !H.mind.miming) //Makes sure mimes can't speak using sign language

	if(is_muzzled())
		return (HAS_TRAIT(src, TRAIT_SIGN_LANG) && !H.mind.miming)

	if(!IsVocal())
		return (HAS_TRAIT(src, TRAIT_SIGN_LANG) && !H.mind.miming)

	return TRUE



/mob/living/proc/treat_message(message)

	if(lisp)
		message = lisp(message, lisp)

	if(HAS_TRAIT(src, TRAIT_UNINTELLIGIBLE_SPEECH))
		message = unintelligize(message)

	if(HAS_TRAIT(src, TRAIT_NEGRO))
		message = negrish(message)

	if(HAS_TRAIT(src, TRAIT_ASIAT))
		message = asiatish(message)

	if(isfelinid(src))
		message = owoish(message)

	if(derpspeech)
		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message)

	if(fucking_anime_girl_noises_oh_nya)
		message = ddlc_text(message)

	if(hydration <= HYDRATION_LEVEL_DEHYDRATED)
		message = thirstymessage(message)

	if(cultslurring && slurring)
		message = cultslur(message)

	else if(slurring)
		message = slur(message)

	if(client?.prefs?.disabled_autocap)
		message = message
	else
		message = capitalize(message)

	return message

/mob/living/proc/radio(message, list/message_mods = list(), list/spans, language)
	var/obj/item/implant/radio/imp = locate() in src
	if(imp?.radio.is_on())
		if(message_mods[MODE_HEADSET])
			imp.radio.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
		if(message_mods[RADIO_EXTENSION] == MODE_DEPARTMENT || (message_mods[RADIO_EXTENSION] in imp.radio.channels))
			imp.radio.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
	switch(message_mods[RADIO_EXTENSION])
		if(MODE_R_HAND)
			for(var/obj/item/r_hand in get_held_items_for_side(RIGHT_HANDS, all = TRUE))
				if (r_hand)
					return r_hand.talk_into(src, message, , spans, language, message_mods)
				return ITALICS | REDUCE_RANGE
		if(MODE_L_HAND)
			for(var/obj/item/l_hand in get_held_items_for_side(LEFT_HANDS, all = TRUE))
				if (l_hand)
					return l_hand.talk_into(src, message, , spans, language, message_mods)
				return ITALICS | REDUCE_RANGE

		if(MODE_INTERCOM)
			for (var/obj/item/radio/intercom/I in view(MODE_RANGE_INTERCOM, null))
				I.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE

	return 0

/mob/living/say_mod(input, list/message_mods = list())
	if(message_mods[WHISPER_MODE] == MODE_WHISPER)
		. = verb_whisper
	else if(message_mods[WHISPER_MODE] == MODE_WHISPER_CRIT)
		. = "[verb_whisper] на последнем дыхании"
	else if(message_mods[MODE_SING])
		. = verb_sing
	else if(stuttering)
		if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
			. = "резво поёт"
		else
			. = "заикается"
	else if(derpspeech)
		if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
			. = "баянит невнятно"
		else
			. = "тараторит"
	else
		. = ..()

/mob/living/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	say("#[message]", bubble_type, spans, sanitize, language, ignore_spam, forced)

/mob/living/get_language_holder(get_minds = TRUE)
	if(get_minds && mind)
		return mind.get_language_holder()
	. = ..()
