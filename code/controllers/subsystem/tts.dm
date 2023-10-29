SUBSYSTEM_DEF(tts)
	name = "Text To Speech"
	wait = 0.05 SECONDS
	priority = FIRE_PRIORITY_TTS
	init_order = INIT_ORDER_TTS
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	/// Queued HTTP requests that have yet to be sent. TTS requests are handled as lists rather than datums.
	var/datum/heap/queued_http_messages

	/// An associative list of mobs mapped to a list of their own /datum/tts_request_target
	var/list/queued_tts_messages = list()

	/// TTS audio files that are being processed on when to be played.
	var/list/current_processing_tts_messages = list()

	/// HTTP requests currently in progress but not being processed yet
	var/list/in_process_http_messages = list()

	/// HTTP requests that are being processed to see if they've been finished
	var/list/current_processing_http_messages = list()

	/// Whether TTS is enabled or not
	var/tts_enabled = TRUE

	/// TTS messages won't play if requests took longer than this duration of time.
	var/message_timeout = 7 SECONDS

	/// The max concurrent http requests that can be made at one time. Used to prevent 1 server from overloading the tts server
	var/max_concurrent_requests = 4

	/// Used to calculate the average time it takes for a tts message to be received from the http server
	/// For tts messages which time out, it won't keep tracking the tts message and will just assume that the message took
	/// 7 seconds (or whatever the value of message_timeout is) to receive back a response.
	var/average_tts_messages_time = 0

	/// Used for caching
	var/current_date = "NULL"

/datum/controller/subsystem/tts/vv_edit_var(var_name, var_value)
	// tts being enabled depends on whether it actually exists
	if(NAMEOF(src, tts_enabled) == var_name)
		return FALSE
	return ..()

/datum/controller/subsystem/tts/stat_entry(msg)
	msg = "Active:[length(in_process_http_messages)]|Standby:[length(queued_http_messages.L)]|Avg:[average_tts_messages_time]"
	return ..()

/proc/cmp_word_length_asc(datum/tts_request/a, datum/tts_request/b)
	return length(b.message) - length(a.message)

/datum/controller/subsystem/tts/Initialize()

	queued_http_messages = new /datum/heap(GLOBAL_PROC_REF(cmp_word_length_asc))

	current_date = time2text(world.timeofday, "YYYY/MM/DD")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/tts/proc/play_tts(target, list/listeners, sound/audio, datum/language/language, range = 7, volume_offset = 0, freq, is_radio = FALSE)
	var/turf/turf_source = get_turf(target)
	if(!turf_source)
		return

	var/channel = open_sound_channel_for_tts()
	for(var/mob/listening_mob in listeners | SSmobs.dead_players_by_zlevel[turf_source.z])//observers always hear through walls
		var/sound_volume = ((listening_mob == target)? 30 : 45) + volume_offset
		var/datum/language_holder/holder = listening_mob.get_language_holder()
		var/audio_to_use = audio
		if(!holder.has_language(language, spoken = FALSE))
			continue
		if(get_dist(listening_mob, turf_source) <= range)
			listening_mob.playsound_local(
				turf_source,
				vol = sound_volume,
				falloff_exponent = SOUND_FALLOFF_EXPONENT,
				channel = channel,
				pressure_affected = TRUE,
				sound_to_use = audio_to_use,
				max_distance = SOUND_RANGE,
				falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
				distance_multiplier = 1,
				use_reverb = TRUE,
				frequency = freq,
				vary = freq ? TRUE : FALSE
			)
		else if (is_radio)
			listening_mob.playsound_local(
				null,
				vol = 30,
				channel = channel,
				sound_to_use = audio_to_use,
				frequency = freq,
				vary = freq ? TRUE : FALSE
			)

// Need to wait for all HTTP requests to complete here because of a rustg crash bug that causes crashes when dd restarts whilst HTTP requests are ongoing.
/datum/controller/subsystem/tts/Shutdown()
	tts_enabled = FALSE
	for(var/datum/tts_request/data in in_process_http_messages)
		var/datum/http_request/request = data.request
		UNTIL(request.is_complete())

#define SHIFT_DATA_ARRAY(tts_message_queue, target, data) \
	popleft(##data); \
	if(length(##data) == 0) { \
		##tts_message_queue -= ##target; \
	};

#define TTS_ARBRITRARY_DELAY "arbritrary delay"

/datum/controller/subsystem/tts/fire(resumed)
	if(!tts_enabled)
		flags |= SS_NO_FIRE
		return

	if(!resumed)
		while(length(in_process_http_messages) < max_concurrent_requests && length(queued_http_messages.L) > 0)
			var/datum/tts_request/entry = queued_http_messages.pop()
			var/timeout = entry.start_time + message_timeout
			if(timeout < world.time)
				entry.timed_out = TRUE
				continue
			entry.start_requests()
			in_process_http_messages += entry
		current_processing_http_messages = in_process_http_messages.Copy()
		current_processing_tts_messages = queued_tts_messages.Copy()

	// For speed
	var/list/processing_messages = current_processing_http_messages
	while(processing_messages.len)
		var/datum/tts_request/current_request = processing_messages[processing_messages.len]
		processing_messages.len--
		if(!current_request.requests_completed())
			continue

		var/datum/http_response/response = current_request.get_primary_response()
		in_process_http_messages -= current_request
		average_tts_messages_time = MC_AVERAGE(average_tts_messages_time, world.time - current_request.start_time)
		var/identifier = current_request.identifier
		if(current_request.requests_errored())
			current_request.timed_out = TRUE
			continue
		current_request.audio_length = text2num(response.headers["audio-length"]) * 10
		if(!current_request.audio_length)
			current_request.audio_length = 0
		current_request.audio_file = "tmp/tts/[current_date]/[identifier].ogg"
		// Don't need the request anymore so we can deallocate it
		current_request.request = null
		if(MC_TICK_CHECK)
			return

	var/list/processing_tts_messages = current_processing_tts_messages
	while(processing_tts_messages.len)
		if(MC_TICK_CHECK)
			return

		var/datum/tts_target = processing_tts_messages[processing_tts_messages.len]
		var/list/data = processing_tts_messages[tts_target]
		processing_tts_messages.len--
		if(QDELETED(tts_target))
			queued_tts_messages -= tts_target
			continue

		var/datum/tts_request/current_target = data[1]
		// This determines when we start the timer to time out.
		// This is so that the TTS message doesn't get timed out if it's waiting
		// on another TTS message to finish playing their audio.

		// For example, if a TTS message plays for more than 7 seconds, which is our current timeout limit,
		// then the next TTS message would be unable to play.
		var/timeout_start = current_target.when_to_play
		if(!timeout_start)
			// In the normal case, we just set timeout to start_time as it means we aren't waiting on
			// a TTS message to finish playing
			timeout_start = current_target.start_time

		var/timeout = timeout_start + message_timeout
		// Here, we check if the request has timed out or not.
		// If current_target.timed_out is set to TRUE, it means the request failed in some way
		// and there is no TTS audio file to play.
		if(timeout < world.time || current_target.timed_out)
			SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
			continue

		if(current_target.audio_file)
			if(current_target.audio_file == TTS_ARBRITRARY_DELAY)
				if(current_target.when_to_play < world.time)
					SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
				continue
			var/sound/audio_file
			if(current_target.local)
				audio_file = new(current_target.audio_file)
				SEND_SOUND(current_target.target, audio_file)
				SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
			else if(current_target.when_to_play < world.time)
				audio_file = new(current_target.audio_file)
				play_tts(tts_target, current_target.listeners, audio_file, current_target.language, current_target.message_range, current_target.volume_offset, current_target.freq, current_target.is_radio)
				if(length(data) != 1)
					var/datum/tts_request/next_target = data[2]
					next_target.when_to_play = world.time + current_target.audio_length
				else
					// So that if the audio file is already playing whilst a new file comes in,
					// it won't play in the middle of the audio file.
					var/datum/tts_request/arbritrary_delay = new()
					arbritrary_delay.when_to_play = world.time + current_target.audio_length
					arbritrary_delay.audio_file = TTS_ARBRITRARY_DELAY
					queued_tts_messages[tts_target] += arbritrary_delay
				SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)


#undef TTS_ARBRITRARY_DELAY

/datum/controller/subsystem/tts/proc/queue_tts_message(datum/target, message, datum/language/language, speaker, list/listeners, local = FALSE, message_range = 7, volume_offset = 0, freq = 0, effect = null)
	if(!tts_enabled)
		return

	// TGS updates can clear out the tmp folder, so we need to create the folder again if it no longer exists.
	if(!fexists("tmp/tts/[current_date]/init.txt"))
		rustg_file_write("rustg HTTP requests can't write to folders that don't exist, so we need to make it exist.", "tmp/tts/[current_date]/init.txt")

	var/shell_scrubbed_input = copytext_char(message, 1, 140)
	var/identifier = "[sha1(speaker + effect + shell_scrubbed_input)]"
	if(!(speaker in GLOB.tts_voices))
		return

	var/datum/http_request/request = new()
	var/file_name = "tmp/tts/[current_date]/[identifier].ogg"
	if(fexists(file_name))
		var/sound/audio_file = new(file_name)
		play_tts(target, listeners, audio_file, language, message_range, volume_offset, freq, (effect == "radio"))
		return

	request.prepare(RUSTG_HTTP_METHOD_GET, "http://tts.ss14.su:2386/?speaker=[speaker]&effect=[effect]&text=[shell_scrubbed_input]&ext=ogg", null, null, file_name)
	var/datum/tts_request/current_request = new /datum/tts_request(identifier, request, shell_scrubbed_input, target, local, language, message_range, volume_offset, listeners, freq, is_radio = (effect == "radio"))
	var/list/player_queued_tts_messages = queued_tts_messages[target]
	if(!player_queued_tts_messages)
		player_queued_tts_messages = list()
		queued_tts_messages[target] = player_queued_tts_messages
	player_queued_tts_messages += current_request
	if(length(in_process_http_messages) < max_concurrent_requests)
		current_request.start_requests()
		in_process_http_messages += current_request
	else
		queued_http_messages.insert(current_request)

/// A struct containing information on an individual player or mob who has made a TTS request
/datum/tts_request
	/// The mob to play this TTS message on
	var/mob/target
	/// The people who are going to hear this TTS message
	/// Does nothing if local is set to TRUE
	var/list/listeners
	/// The HTTP request of this message
	var/datum/http_request/request
	/// The language to limit this TTS message to
	var/datum/language/language
	/// The message itself
	var/message
	/// The message identifier
	var/identifier
	/// The volume offset to play this TTS at.
	var/volume_offset = 0
	/// Whether this TTS message should be sent to the target only or not.
	var/local = FALSE
	/// The message range to play this TTS message
	var/message_range = 7
	/// The time at which this request was started
	var/start_time

	/// The audio file of this tts request.
	var/sound/audio_file
	/// The audio length of this tts request.
	var/audio_length
	/// When the audio file should play at the minimum
	var/when_to_play = 0
	/// Whether this request was timed out or not
	var/timed_out = FALSE
	/// Частота
	var/freq
	/// Это радио?
	var/is_radio


/datum/tts_request/New(identifier, datum/http_request/request, message, target, local, datum/language/language, message_range, volume_offset, list/listeners, freq, is_radio)
	. = ..()
	src.identifier = identifier
	src.request = request
	src.message = message
	src.language = language
	src.target = target
	src.local = local
	src.message_range = message_range
	src.volume_offset = volume_offset
	src.listeners = listeners
	src.freq = freq
	src.is_radio = is_radio
	start_time = world.time

/datum/tts_request/proc/start_requests()
	request.begin_async()

/datum/tts_request/proc/get_primary_response()
	return request.into_response()

/datum/tts_request/proc/requests_errored()
	var/datum/http_response/response = request.into_response()
	return response.errored

/datum/tts_request/proc/requests_completed()
	return request.is_complete()
