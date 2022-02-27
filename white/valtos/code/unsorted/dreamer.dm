// max value for nuke terminal is 99999, here some crutch applied
GLOBAL_LIST_INIT(dreamer_clues, list("[uppertext(random_string(4, GLOB.alphabet))]" = rand(1, 24995), "[uppertext(random_string(4, GLOB.alphabet))]" = rand(1, 25000), "[uppertext(random_string(4, GLOB.alphabet))]" = rand(1, 25000), "[uppertext(random_string(4, GLOB.alphabet))]" = rand(1, 25000)))

/datum/component/dreamer
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/prob_variability = 5
	var/animation_intensity = 7
	var/turf_plane
	var/speak_probability = 7
	var/hall_attack_probability = 1
	var/turf_loop_duration = 3

	var/grip = 4

	var/known_clues = list()

	var/datum/martial_art/dreamer/dream_mart

	var/mob/living/carbon/human/our_dreamer

/datum/component/dreamer/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)
	our_dreamer = parent

	if(!our_dreamer?.client)
		stack_trace("DREAMER ADDED IN MOB WITHOUT CLIENT!")

	our_dreamer.sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC

	make_weirds()

	dream_mart = new(null)
	dream_mart.teach(our_dreamer)

/datum/component/dreamer/proc/make_weirds()
	SIGNAL_HANDLER

	var/client/C = our_dreamer.client

	if(C.prefs.toggles & SOUND_SHIP_AMBIENCE)
		C.prefs.toggles ^= SOUND_SHIP_AMBIENCE

	if(our_dreamer?.client?.prefs.toggles & SOUND_JUKEBOX)
		C.prefs.toggles ^= SOUND_JUKEBOX

	if(our_dreamer?.client?.prefs.toggles & SOUND_AMBIENCE)
		C.prefs.toggles ^= SOUND_AMBIENCE

	DIRECT_OUTPUT(our_dreamer, sound(null))
	C?.tgui_panel?.stop_music()

	SEND_SOUND(our_dreamer, sound('white/valtos/sounds/lifeweb/dreamer_is_still_asleep.ogg', repeat = TRUE, wait = 0, volume = 75, channel = CHANNEL_BUZZ))

	if(our_dreamer?.hud_used)
		our_dreamer.hud_used.update_parallax_pref(our_dreamer, 1)

/datum/component/dreamer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_SAY, .proc/handle_speech)
	RegisterSignal(parent, COMSIG_MOB_LOGIN, .proc/make_weirds)
	ADD_TRAIT(parent, TRAIT_STUNRESISTANCE, "dreamer")
	ADD_TRAIT(parent, TRAIT_SLEEPIMMUNE,    "dreamer")
	return

/datum/component/dreamer/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	UnregisterSignal(parent, COMSIG_MOB_LOGIN)
	REMOVE_TRAIT(parent, TRAIT_STUNRESISTANCE, "dreamer")
	REMOVE_TRAIT(parent, TRAIT_SLEEPIMMUNE,    "dreamer")
	return

/datum/component/dreamer/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/dreamer/process(delta_time)

	var/list/fuckfloorlist = list()

	for(var/turf/T in RANGE_TURFS(15, our_dreamer))
		if(!prob(prob_variability))
			continue
		if(isgroundlessturf(T))
			continue
		var/image/I = image(icon = T.icon, icon_state = T.icon_state, loc = T)

		I.alpha = rand(200, 255)
		I.copy_overlays(T)
		I.plane = turf_plane ? turf_plane : T.plane

		var/matrix/M = matrix()
		M.Translate(0, rand(-animation_intensity, animation_intensity))

		var/ttd = rand(animation_intensity * 2, animation_intensity * 4)

		animate(I, transform = M, time = ttd, loop = rand(1, turf_loop_duration), easing = SINE_EASING)
		animate(transform = null, time = ttd, easing = SINE_EASING)

		fuckfloorlist += I

		QDEL_IN(I, ttd)

	update_grip()

	our_dreamer.heal_overall_damage(5, 5, 5)
	our_dreamer.setOxyLoss(0)
	our_dreamer.setToxLoss(0)
	our_dreamer.blood_volume = BLOOD_VOLUME_NORMAL

	if(our_dreamer.handcuffed)
		var/obj/O = our_dreamer.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
		if(istype(O))
			our_dreamer.clear_cuffs(O, TRUE)
			playsound(get_turf(our_dreamer), 'sound/effects/grillehit.ogg', 80, 1, -1)

	if(prob(speak_probability))
		speak_from_above()

	if(prob(hall_attack_probability))
		attack_us_with_hallucination()

	if(our_dreamer?.client)
		our_dreamer.client.images |= fuckfloorlist

/datum/component/dreamer/proc/update_grip()
	switch(grip)
		if(4)
			dream_mart.block_chance = 0
			if(our_dreamer?.dna?.species)
				our_dreamer.dna.species.armor = 5
				our_dreamer.dna.species.brutemod = 0.9
				our_dreamer.dna.species.burnmod = 0.9
				our_dreamer.dna.species.heatmod = 0.9
				our_dreamer.dna.species.coldmod = 0.9
				our_dreamer.dna.species.stunmod = 0.9
				our_dreamer.dna.species.siemens_coeff = 0.9
				our_dreamer.dna.species.punchdamagelow = 10
				our_dreamer.dna.species.punchdamagehigh = 15
		if(3)
			prob_variability = 7
			animation_intensity = 10
			speak_probability = 10
			hall_attack_probability = 2
			turf_loop_duration = 4
			dream_mart.block_chance = 25
			if(our_dreamer?.dna?.species)
				our_dreamer.dna.species.armor = 25
				our_dreamer.dna.species.brutemod = 0.5
				our_dreamer.dna.species.burnmod = 0.5
				our_dreamer.dna.species.heatmod = 0.5
				our_dreamer.dna.species.coldmod = 0.5
				our_dreamer.dna.species.stunmod = 0.5
				our_dreamer.dna.species.siemens_coeff = 0.5
				our_dreamer.dna.species.punchdamagelow = 25
				our_dreamer.dna.species.punchdamagehigh = 35
		if(2)
			prob_variability = 10
			animation_intensity = 15
			speak_probability = 15
			hall_attack_probability = 3
			turf_loop_duration = 5
			dream_mart.block_chance = 50
			if(our_dreamer?.dna?.species)
				our_dreamer.dna.species.armor = 50
				our_dreamer.dna.species.brutemod = 0.3
				our_dreamer.dna.species.burnmod = 0.3
				our_dreamer.dna.species.heatmod = 0.3
				our_dreamer.dna.species.coldmod = 0.3
				our_dreamer.dna.species.stunmod = 0.3
				our_dreamer.dna.species.siemens_coeff = 0.3
				our_dreamer.dna.species.punchdamagelow = 50
				our_dreamer.dna.species.punchdamagehigh = 75
		if(1)
			prob_variability = 15
			animation_intensity = 20
			speak_probability = 20
			hall_attack_probability = 4
			turf_loop_duration = 6
			dream_mart.block_chance = 75
			our_dreamer.next_move_modifier = 0.5
			if(our_dreamer?.dna?.species)
				our_dreamer.dna.species.armor = 75
				our_dreamer.dna.species.brutemod = 0.1
				our_dreamer.dna.species.burnmod = 0.1
				our_dreamer.dna.species.heatmod = 0.1
				our_dreamer.dna.species.coldmod = 0.1
				our_dreamer.dna.species.stunmod = 0.1
				our_dreamer.dna.species.siemens_coeff = 0.1
				our_dreamer.dna.species.punchdamagelow = 100
				our_dreamer.dna.species.punchdamagehigh = 200
		if(0 to -INFINITY)
			prob_variability = 20
			animation_intensity = 25
			speak_probability = 25
			hall_attack_probability = 10
			turf_loop_duration = 10
			dream_mart.block_chance = 100
			our_dreamer.next_move_modifier = 0
			if(our_dreamer?.dna?.species)
				our_dreamer.dna.species.armor = 999
				our_dreamer.dna.species.brutemod = 0.1
				our_dreamer.dna.species.burnmod = 0.1
				our_dreamer.dna.species.heatmod = 0.1
				our_dreamer.dna.species.coldmod = 0.1
				our_dreamer.dna.species.stunmod = 0.1
				our_dreamer.dna.species.siemens_coeff = 0.1
				our_dreamer.dna.species.punchdamagelow = 999
				our_dreamer.dna.species.punchdamagehigh = 999

/datum/component/dreamer/proc/handle_speech(mob/speaker, speech_args)
	SIGNAL_HANDLER

	if(speaker == our_dreamer || prob(25))
		var/tmp_msg = speech_args[SPEECH_MESSAGE]
		spawn(rand(10, 50))
			speak_from_above(tmp_msg)
		spawn(rand(10, 50))
			if(prob(25))
				SEND_SOUND(our_dreamer, sound(pick('white/valtos/sounds/lifeweb/hall_appear1.ogg',\
											'white/valtos/sounds/lifeweb/hall_appear2.ogg',\
											'white/valtos/sounds/lifeweb/hall_appear3.ogg',\
											'white/valtos/sounds/lifeweb/hall_appear4.ogg')))

/datum/component/dreamer/proc/attack_us_with_hallucination()

	to_chat(our_dreamer, span_holoparasite(pick("ДАВАЙ ПОТАНЦУЕМ?!", "НЕ МЕШАЙ!", "ТЫ НЕ НУЖЕН!", "УХОДИ!", "У ТЕБЯ НЕТ ВРЕМЕНИ!", "СДАЙСЯ!", "ТЫ ЭТОГО НЕ ЗАСЛУЖИВАЕШЬ!")))

	var/turf/hall_source = locate(our_dreamer.x + pick(-12, 12), our_dreamer.y + pick(-12, 12), our_dreamer.z)
	new /obj/effect/hallucination/simple/xeno(hall_source, our_dreamer)

/datum/component/dreamer/proc/speak_from_above(what_we_should_say)

	if(!what_we_should_say)
		what_we_should_say = pick("Это всё не настоящее", "Ты не настоящий", "Умри", \
								"Действуй", "Я тебя ненавижу", "Ебанутый", "Остановись", \
								"У тебя мало времени", "Убей", "Убийца", "Ты настоящий", \
								"Консоли хранят в себе много тайн", "Введи сумму всех чисел в терминал с циферблатом", "В сердце того, кто видел шедевр, есть ключ", "Покажи им свои шедевры", \
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
		var/list/tlist = list()

		for(var/obj/O in view(6, our_dreamer))
			if(!isobj(O))
				continue
			tlist += O

		var/atom/A = pick(tlist)

		var/image/speech_overlay = image('icons/mob/talk.dmi', A, "default2", FLY_LAYER)
		spawn(rand(10, 50))
			INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, speech_overlay, list(our_dreamer?.client), 30)
			our_dreamer.Hear(what_we_should_say, A, our_dreamer.get_random_understood_language(), what_we_should_say)

	if(prob(23))
		spawn(rand(10, 50))
			SEND_SOUND(our_dreamer, pick(RANDOM_DREAMER_SOUNDS))

/datum/martial_art/dreamer
	name = "Dreamer Willpower"
	id = MARTIALART_DREAMER
	smashes_tables = TRUE
	block_chance = 0

/datum/martial_art/dreamer/disarm_act(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	var/atk_verb = pick("лупит", "пинает", "вмазывает")
	D.visible_message(span_danger("<b>[A]</b> [atk_verb] <b>[D]</b> с НЕВЕРОЯТНОЙ СИЛОЙ!"), \
					span_userdanger("<b>[A]</b> [atk_verb] меня с НЕВЕРОЯТНОЙ СИЛОЙ!"), \
					span_hear("Слышу звук разрывающейся плоти!") , null, A)
	to_chat(A, span_danger("Пинаю свинью <b>[D]</b>!"))
	if(block_chance >= 25)
		D.apply_damage(rand(5, 10), A.get_attack_type())
	var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
	playsound(get_turf(D), 'sound/effects/tableheadsmash.ogg', 50, TRUE, -1)
	D.throw_at(throwtarget, rand(1, 3), 2, A, FALSE)
	if(block_chance >= 50)
		D.Paralyze(rand(10, 30))
	if(atk_verb)
		log_combat(A, D, "[atk_verb] (Dreamer Willpower)")
	return TRUE

/datum/martial_art/dreamer/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	. = ..()
	if(!isturf(A.loc) || !prob(block_chance))
		return BULLET_ACT_HIT
	else
		A.visible_message(span_danger("<b>[A]</b> игнорирует попадание [P.name]!"), span_userdanger("Отвергаю существование [P.name]!"))
		qdel(P)
		return BULLET_ACT_BLOCK

/datum/antagonist/dreamer
	name = "Dreamer"
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = FALSE
	show_in_antagpanel = TRUE
	roundend_category = "Dreamer"
	antagpanel_category = "Dreamer"
	greentext_reward = 100
	var/objective_text = "В последнее время меня часто посещают ВИДЕНИЯ, о другом МИРЕ, о ДРУГОЙ жизни. Я сделаю ВСЁ, чтобы узнать ПРАВДУ, чтобы вернуться в ПОДЛИННЫЙ мир."

/datum/antagonist/dreamer/proc/forge_objectives()
	var/datum/objective/survive/survive = new
	survive.owner = owner
	survive.reward = -99
	objectives += survive

	var/datum/objective/limited/limit = new
	limit.set_time(2 HOURS)
	limit.owner = owner
	limit.reward = -1
	objectives += limit

/datum/antagonist/dreamer/on_gain()
	forge_objectives()
	owner.special_role = "Dreamer"
	owner.AddComponent(/datum/component/dreamer)
	. = ..()

/datum/antagonist/dreamer/greet()
	to_chat(owner.current, objective_text)
	antag_memory += objective_text
	. = ..()
