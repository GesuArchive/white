/mob/living/simple_animal/xaxi
	name = "oma-oma"
	desc = "Прикольно."
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
	var/roleplay_progress = 0

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
	to_chat(src, span_alert("Последние нотки мышления начинают покидать мой разум. Это конечная."))

	for(var/V in verbs)
		remove_verb(src, V)
	for(var/V in client.verbs)
		remove_verb(client, V)
	SEND_SOUND(src, sound('white/valtos/sounds/xeno.ogg', repeat = TRUE, wait = 0, volume = 50))
	roleplay_progress = 0
	add_verb(src, /mob/living/simple_animal/xaxi/verb/roleplay)

/mob/living/simple_animal/xaxi/Life()
	..()
	if(!src || !client || !hud_used || !hud_used?.plane_masters)
		return
	var/list/screens = list(hud_used.plane_masters["[FLOOR_PLANE]"], hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[LIGHTING_PLANE]"], hud_used.plane_masters["[CAMERA_STATIC_PLANE ]"], hud_used.plane_masters["[PLANE_SPACE_PARALLAX]"], hud_used.plane_masters["[PLANE_SPACE]"])
	if(prob(5))
		blur_eyes(1)
		SEND_SOUND(client, sound("white/valtos/sounds/halun/halun[rand(1,19)].ogg"))
		step(src, pick(GLOB.cardinals))
	if(prob(10))
		for(var/atom/movable/screen/plane_master/whole_screen in screens)
			whole_screen.filters += filter(type="wave", x=20*rand() - 20, y=20*rand() - 20, size=rand()*0.1, offset=rand()*0.5, flags = WAVE_BOUNDED)
			animate(whole_screen, transform = matrix()*rand(1, 3), time = 400, easing = BOUNCE_EASING)
			addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 1200)
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
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	show_message(message, MSG_AUDIBLE, message, null, avoid_highlighting = speaker == src)
	return message


/mob/living/simple_animal/xaxi/show_message(msg, type, alt_msg, alt_type, avoid_highlighting)
	if(!client)
		return

	to_chat(src, readable_corrupted_text(reverse_text(msg)), avoid_highlighting = avoid_highlighting)

	if(prob(50))
		SEND_SOUND(src, sound("white/valtos/sounds/halun/halun[rand(1,19)].ogg"))

/mob/living/simple_animal/xaxi/verb/roleplay()
	set category = "ROLEPLAY"
	set name = "RP"
	set desc = "Really Prank"

	roleplay_progress++

	to_chat(src, span_notice("Прогресс отыгрыша ролевой ролеплейной игры: \[[roleplay_progress]/100\]"))
	visible_message("<b>[src.name]</b> [pick("мило булькает", "машет хвостиком", "улыбается", "радостно смотрит куда-то")].", null, null)

	remove_verb(src, /mob/living/simple_animal/xaxi/verb/roleplay)

	spawn(5 SECONDS)
		add_verb(src, /mob/living/simple_animal/xaxi/verb/roleplay)

	if(roleplay_progress == 100)
		qdel(src)

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
