/mob/living/silicon/ai/say(message, bubble_type,list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(parent && istype(parent) && parent.stat != DEAD) //If there is a defined "parent" AI, it is actually an AI, and it is alive, anything the AI tries to say is said by the parent instead.
		parent.say(message, language)
		return
	..(message)

/mob/living/silicon/robot/shell/compose_track_href(atom/movable/speaker, namepart)
	var/mob/M = speaker.GetSource()
	if(M)
		return "<a href='?src=[REF(src)];track=[html_encode(namepart)]'>"
	return ""

/mob/living/silicon/robot/shell/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	//Also includes the </a> for AI hrefs, for convenience.
	return "[radio_freq ? " (" + speaker.GetJob() + ")" : ""]" + "[speaker.GetSource() ? "</a>" : ""]"

/mob/living/silicon/ai/compose_track_href(atom/movable/speaker, namepart)
	var/mob/M = speaker.GetSource()
	if(M)
		return "<a href='?src=[REF(src)];track=[html_encode(namepart)]'>"
	return ""

/mob/living/silicon/ai/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	//Also includes the </a> for AI hrefs, for convenience.
	return "[radio_freq ? " (" + speaker.GetJob() + ")" : ""]" + "[speaker.GetSource() ? "</a>" : ""]"

/mob/living/silicon/ai/IsVocal()
	return !CONFIG_GET(flag/silent_ai)

/mob/living/silicon/ai/radio(message, list/message_mods = list(), list/spans, language)
	if(incapacitated())
		return FALSE
	if(!radio_enabled) //AI cannot speak if radio is disabled (via intellicard) or depowered.
		to_chat(src, span_danger("Радио-трансмиттер отключён!"))
		return FALSE
	..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(message, language)
	message = trim(message)

	if (!message)
		return

	var/obj/machinery/holopad/T = current
	if(istype(T) && T.masters[src])//If there is a hologram and its master is the user.
		var/turf/padturf = get_turf(T)
		var/padloc
		if(padturf)
			padloc = AREACOORD(padturf)
		else
			padloc = "(UNKNOWN)"
		src.log_talk(message, LOG_SAY, tag="HOLOPAD in [padloc]")
		send_speech(message, 7, T, MODE_ROBOT, message_language = language)
		to_chat(src, "<i><span class='game say'>Голопад передаёт, <span class='name'>[real_name]</span> <span class='message robot'>\"[message]\"</span></span></i>")
	else
		to_chat(src, span_alert("Нет подключенных голопадов."))


// Make sure that the code compiles with AI_VOX undefined
#ifdef AI_VOX
#define VOX_DELAY 600
/mob/living/silicon/ai/verb/announcement_help()

	set name = "Announcement Help"
	set desc = "Display a list of vocal words to announce to the crew."
	set category = "AI Commands"

	if(incapacitated())
		return

	var/dat = {"
	<font class='bad'>ВНИМАНИЕ:</font> Неправильное использование системы оповещения может привести к тому, что вы получите по ебалу.<BR><BR>
	Тут можно найти список слов что можно ввести в кнопке 'Announcement', которые затем вербально произнесутся всем на том же уровне где находитесь и вы.<BR>
	<UL><LI>Вы также можете нажать на слово, чтобы его ПРОСЛУШАТЬ.</LI>
	<LI>Вы можете произнести только 30 слов за каждое объявление.</LI>
	<LI>Не используйте знаки препинания, как если бы вы делали это обычно. Если вы хотите сделать паузу, то вы можете использовать точки и запятые разделив их пробелами, например: 'Alpha . Test , Bravo'.</LI>
	<LI>Цифры вводятся в буквенном виде, например: eight, sixty и т.д. </LI>
	<LI>Звуковые эффекты начинаются с 's' перед самим словом, например: scensor</LI>
	<LI>Для поиска слов в списке воспользуйтесь Ctrl+F.</LI></UL><HR>
	"}

	var/index = 0
	for(var/word in GLOB.vox_sounds)
		index++
		dat += "<A href='?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
		if(index != GLOB.vox_sounds.len)
			dat += " / "

	var/datum/browser/popup = new(src, "announce_help", "Announcement Help", 500, 400)
	popup.set_content(dat)
	popup.open()


/mob/living/silicon/ai/proc/announcement()
	var/static/announcing_vox = 0 // Stores the time of the last announcement
	if(announcing_vox > world.time)
		to_chat(src, span_notice("Пожалуйста подождите [DisplayTimeText(announcing_vox - world.time)]."))
		return

	var/message = tgui_input_text(src, "Помощь по вводу можно найти в кнопке 'Announcement Help'", "Звуковое оповещение", src.last_announcement)

	if(!message || announcing_vox > world.time)
		return

	last_announcement = message

	if(incapacitated())
		return

	if(control_disabled)
		to_chat(src, span_warning("Беспроводной интерфейс отключён, взаимодействие с системой оповещения невозможно."))
		return

	var/list/words = splittext(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	for(var/word in words)
		word = lowertext(trim(word))
		if(!word)
			words -= word
			continue
		if(!GLOB.vox_sounds[word])
			incorrect_words += word

	if(incorrect_words.len)
		to_chat(src, span_notice("Этих слов нет в системе оповещения: [english_list(incorrect_words)]."))
		return

	announcing_vox = world.time + VOX_DELAY

	log_game("[key_name(src)] made a vocal announcement with the following message: [message].")
	log_talk(message, LOG_SAY, tag="VOX Announcement")
	say(";[message]", forced = "VOX Announcement")

	for(var/word in words)
		play_vox_word(word, src.z, null)


/proc/play_vox_word(word, z_level, mob/only_listener)

	word = lowertext(word)

	if(GLOB.vox_sounds[word])

		var/sound_file = GLOB.vox_sounds[word]
		var/sound/voice = sound(sound_file, wait = 1, channel = CHANNEL_VOX)
		voice.status = SOUND_STREAM

	// If there is no single listener, broadcast to everyone in the same z level
		if(!only_listener)
			// Play voice for all mobs in the z level
			for(var/mob/M in GLOB.player_list)
				if(M.can_hear() && (M.client.prefs.toggles & SOUND_ANNOUNCEMENTS))
					var/turf/T = get_turf(M)
					if(T.z == z_level)
						SEND_SOUND(M, voice)
		else
			SEND_SOUND(only_listener, voice)
		return TRUE
	return FALSE

#undef VOX_DELAY
#endif
