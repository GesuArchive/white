/mob/living/simple_animal/xaxi
	name = "oma-oma"
	desc = "ninininininini"
	icon = 'white/valtos/icons/dz-031.dmi'
	icon_state = "taj"
	icon_living = "taj"
	maxHealth = INFINITY
	health = INFINITY
	var/namethings = list(
		"åр", "и", "гåр", "сек", "мо", "фф", "ок", "гй", "ø", "гå", "ла", "ле",
		"лит", "ыгг", "ван", "дåр", "нæ", "мøт", "идд", "хво", "я", "пå", "хан",
		"сå", "åн", "дет", "атт", "нå", "гö", "бра", "инт", "тыц", "ом", "нäр",
		"твå", "мå", "даг", "сйä", "вии", "вуо", "еил", "тун", "кäыт", "тэ", "вä",
		"хеи", "хуо", "суо", "ää", "тен", "я", "хеу", "сту", "ухр", "кöн", "ве", "хöн"
	)
	var/list/sounds = list()

/mob/living/simple_animal/xaxi/emote(act, m_type, message, intentional)
	return FALSE

/mob/living/simple_animal/xaxi/Initialize()
	. = ..()
	name = "[capitalize(pick(namethings))]-[capitalize(pick(namethings))]"
	overlay_fullscreen("noise", /atom/movable/screen/fullscreen/noisescreen)
	add_client_colour(/datum/client_colour/ohfuckrection)

/mob/living/simple_animal/xaxi/Login()
	. = ..()

	to_chat(src, "<h1 class='alert'>Центральное Командование</h1>")
	to_chat(src, "<span class='alert'>Последние нотки мышления начинают покидать мой разум. Это конечная.</span>")

	spawn(1 SECONDS)
		for(var/V in client.verbs)
			remove_verb(client, V)
		SEND_SOUND(src, sound('white/valtos/sounds/xeno.ogg', repeat = TRUE, wait = 0, volume = 50))

/mob/living/simple_animal/xaxi/Life()
	..()
	if(!src || !client || !hud_used || !hud_used?.plane_masters)
		return
	var/list/screens = list(hud_used.plane_masters["[FLOOR_PLANE]"], hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[LIGHTING_PLANE]"], hud_used.plane_masters["[CAMERA_STATIC_PLANE ]"], hud_used.plane_masters["[PLANE_SPACE_PARALLAX]"], hud_used.plane_masters["[PLANE_SPACE]"])
	if(prob(5))
		blur_eyes(1)
		SEND_SOUND(client, sound("white/valtos/sounds/halun/halun[rand(1,19)].ogg"))
	if(prob(1))
		for(var/atom/movable/screen/plane_master/whole_screen in screens)
			if(prob(50))
				var/rotation = max(min(round(60/4), 20),125)
				animate(whole_screen, color = color_matrix_rotate_hue(rand(0, 360)), transform = turn(matrix(), rand(1,rotation)), time = 15, easing = CIRCULAR_EASING)
				animate(transform = turn(matrix(), -rotation), time = 10, easing = BACK_EASING)
			else
				whole_screen.filters += filter(type="wave", x=20*rand() - 20, y=20*rand() - 20, size=rand()*0.1, offset=rand()*0.5, flags = WAVE_BOUNDED)
				animate(whole_screen, transform = matrix()*2, time = 40, easing = BOUNCE_EASING)
				addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 120)
			addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 60)
	if(client)
		sounds = client.SoundQuery()
		for(var/sound/S in sounds)
			if(S.len <= 3)
				S.environment = 23
				S.volume = rand(25,100)
				S.frequency = rand(10000,70000)
				SEND_SOUND(client, S)
				sounds = list()

/mob/living/simple_animal/xaxi/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

	if(!client)
		return

	speaker = prob(50) ? "???" : capitalize(pick(namethings))

	raw_message = unintelligize(reverse_text(raw_message))

	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)

	show_message(message, MSG_AUDIBLE, message, message, avoid_highlighting = speaker == src)
	return message

/mob/living/simple_animal/xaxi/show_message(msg, type, alt_msg, alt_type, avoid_highlighting)
	if(!client)
		return

	to_chat(src, unintelligize(reverse_text(msg)), avoid_highlighting = avoid_highlighting)

/datum/smite/givexeno
	name = "Xeno (ПИЗДЕЦ ДО КОНЦА РАУНДА)"

/datum/smite/givexeno/effect(client/user, mob/living/target)
	. = ..()
	var/mob/living/simple_animal/xaxi/new_xaxi = new /mob/living/simple_animal/xaxi(target.loc)
	if(target.ckey in GLOB.anonists_deb)
		new_xaxi.key = user.key
		qdel(user)
	else
		new_xaxi.key = target.key
		qdel(target)
