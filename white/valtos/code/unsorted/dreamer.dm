/datum/component/dreamer
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/prob_variability = 23
	var/animation_intensity = 7
	var/turf_plane = FLOOR_PLANE
	var/speak_probability = 5

	var/mob/living/carbon/human/our_dreamer
	var/list/fucked_turfs = list()

/datum/component/dreamer/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)
	our_dreamer = parent

/datum/component/dreamer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_SAY, .proc/handle_speech)
	return

/datum/component/dreamer/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	return

/datum/component/dreamer/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/dreamer/process(delta_time)

	var/list/fuckfloorlist = list()

	for(var/turf/T in RANGE_TURFS(15, our_dreamer))
		if(!prob(prob_variability))
			continue
		if(T in fucked_turfs)
			continue
		if(isgroundlessturf(T))
			continue
		var/image/I = image(icon = T.icon, icon_state = T.icon_state, loc = T)

		I.alpha = rand(200, 255)
		I.plane = turf_plane

		var/matrix/M = matrix()
		M.Translate(0, rand(-animation_intensity, animation_intensity))

		animate(I, transform = M, time = rand(animation_intensity * 2, animation_intensity * 4), loop = -1, easing = SINE_EASING)
		animate(transform = null, time = rand(animation_intensity * 2, animation_intensity * 4), easing = SINE_EASING)

		fucked_turfs += T
		fuckfloorlist += I

	if(prob(speak_probability))
		speak_from_above()

	if(our_dreamer?.client)
		our_dreamer.client.images |= fuckfloorlist

/datum/component/dreamer/proc/handle_speech(mob/speaker, speech_args)
	SIGNAL_HANDLER

	if(speaker == our_dreamer || prob(25))
		speak_from_above(speech_args[SPEECH_MESSAGE])
		if(prob(50))
			SEND_SOUND(our_dreamer, 'white/hule/SFX/rjach.ogg')

/datum/component/dreamer/proc/speak_from_above(what_we_should_say)

	if(!what_we_should_say)
		what_we_should_say = pick("Это всё не настоящее", "Ты не настоящий", "Умри", \
								"Действуй", "Я тебя ненавижу", "Ебанутый", "Остановись", \
								"У тебя мало времени", "Убей", "Убийца", "Ты настоящий", \
								"Это всё настоящее", "[pick_list_replacements(HAL_LINES_FILE, "conversation")]", \
								"[pick_list_replacements(HAL_LINES_FILE, "help")]", \
								"[pick_list_replacements(HAL_LINES_FILE, "accusations")]", \
								"[pick_list_replacements(HAL_LINES_FILE, "advice")]")
	if(prob(25))
		what_we_should_say = uppertext(what_we_should_say)
	else if(prob(5))
		what_we_should_say = slur(what_we_should_say)
	else if(prob(5))
		what_we_should_say = Gibberish(what_we_should_say)
	else if(prob(1))
		what_we_should_say = ddlc_text(what_we_should_say)

	what_we_should_say = capitalize(what_we_should_say)

	if(prob(25))
		what_we_should_say = "[what_we_should_say]! [what_we_should_say]! [what_we_should_say]!"

	for(var/i in 1 to rand(1, 3))
		var/atom/A = pick(view(6, our_dreamer))
		var/image/speech_overlay = image('icons/mob/talk.dmi', src, "default2", FLY_LAYER)
		INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, speech_overlay, list(our_dreamer?.client), 30)
		our_dreamer.Hear(what_we_should_say, A, our_dreamer.get_random_understood_language(), what_we_should_say)

	SEND_SOUND(our_dreamer, pick(RANDOM_DREAMER_SOUNDS))
