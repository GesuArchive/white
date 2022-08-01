///prototype for rites that tune a song.
/datum/religion_rites/song_tuner
	name = "Tune Song"
	desc = "this is a prototype."
	ritual_length = 10 SECONDS
	favor_cost = 10
	///if repeats count as continuations instead of a song's end, TRUE
	var/repeats_okay = TRUE
	///personal message sent to the chaplain as feedback for their chosen song
	var/song_invocation_message = "beep borp you forgot to fill in a variable report to git hub"
	///visible message sent to indicate a song will have special properties
	var/song_start_message
	///particle effect of playing this tune
	var/particles_path = /particles/musical_notes
	///what the instrument will glow when playing
	var/glow_color = "#000000"

/datum/religion_rites/song_tuner/invoke_effect(mob/living/user, obj/structure/altar_of_gods/altar)
	. = ..()
	to_chat(user, span_notice(song_invocation_message))
	user.AddComponent(/datum/component/smooth_tunes, src, repeats_okay, particles_path, glow_color)

/**
 * Perform the song effect.
 *
 * Arguments:
 * * song_player - parent of the smooth_tunes component. This is limited to the compatible items of said component, which currently includes mobs and objects so we'll have to type appropriately.
 * * song_datum - Datum song being played
 */
/datum/religion_rites/song_tuner/proc/song_effect(atom/song_player, datum/song/song_datum)
	return

/**
 * When the song is long enough, it will have a special effect when it ends.
 *
 * If you want something that ALWAYS goes off regardless of song length, affix it to the Destroy proc. The rite is destroyed when smooth tunes is done.
 *
 * Arguments:
 * * song_player - parent of the smooth_tunes component. This is limited to the compatible items of said component, which currently includes mobs and objects so we'll have to type appropriately.
 * * song_datum - Datum song being played
 */
/datum/religion_rites/song_tuner/proc/finish_effect(atom/song_player, datum/song/song_datum)
	return

/datum/religion_rites/song_tuner/evangelism
	name = "евангелический гимн"
	desc = "Распространяет слово вашего Бога, вы получаете благосклонность за каждого слушателя. В конце песни вы благословляете всех слушателей, поднимая им настроение."
	particles_path = /particles/musical_notes/holy
	song_invocation_message = "Подготавливаю священную песню!"
	song_start_message = span_notice("Эта музыка звучит благословенно!")
	glow_color = "#FEFFE0"
	favor_cost = 0

/datum/religion_rites/song_tuner/evangelism/song_effect(atom/song_player, datum/song/song_datum)
	if(!song_datum || !GLOB.religious_sect)
		return
	for(var/mob/living/carbon/human/listener in song_datum.hearing_mobs)
		if(listener == song_player || listener.anti_magic_check(TRUE, TRUE))
			continue
		if(listener.mind?.holy_role)
			continue
		if(!listener.ckey) //good requirement to have for favor, trust me
			continue
		GLOB.religious_sect.adjust_favor(0.2)

/datum/religion_rites/song_tuner/evangelism/finish_effect(atom/song_player, datum/song/song_datum)
	for(var/mob/living/carbon/human/listener in song_datum.hearing_mobs)
		SEND_SIGNAL(listener, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)

/datum/religion_rites/song_tuner/nullwave
	name = "антимагическое вибрато"
	desc = "Спойте тихую песню, защищая тех, кто слушает от волшебства."
	particles_path = /particles/musical_notes/nullwave
	song_invocation_message = "Подготавливаю антимагическую песню!"
	song_start_message = span_nicegreen("Слушая эту музыку, чувствую себя защищенным!")
	glow_color = "#a9a9b8"
	repeats_okay = FALSE

/datum/religion_rites/song_tuner/nullwave/song_effect(atom/song_player, datum/song/song_datum)
	if(!song_datum)
		return
	for(var/mob/living/listener in song_datum.hearing_mobs)
		if(listener.anti_magic_check(TRUE, TRUE))
			continue
		listener.apply_status_effect(/datum/status_effect/antimagic, 2 MINUTES)

/datum/religion_rites/song_tuner/pain
	name = "убийственный аккорд"
	desc = "Спойте резкую песню, разрезая окружающих. В конце песни ты вскроешь вены всех слушателей."
	particles_path = /particles/musical_notes/harm
	song_invocation_message = "Подготавливаю болезненную песню!"
	song_start_message = span_danger("Эта музыка режет меня, как нож масло!")
	glow_color = "#FF4460"
	repeats_okay = FALSE

/datum/religion_rites/song_tuner/pain/song_effect(atom/song_player, datum/song/song_datum)
	if(!song_datum)
		return
	for(var/mob/living/listener in song_datum.hearing_mobs)
		if(listener.anti_magic_check(TRUE, TRUE))
			continue
		var/pain_juice = 1
		if(listener.mind?.holy_role)
			pain_juice *= 0.5
		listener.adjustBruteLoss(pain_juice)

/datum/religion_rites/song_tuner/pain/finish_effect(atom/song_player, datum/song/song_datum)
	for(var/mob/living/carbon/human/listener in song_datum.hearing_mobs)
		if(listener.anti_magic_check(TRUE, TRUE))
			continue
		var/obj/item/bodypart/sliced_limb = pick(listener.bodyparts)
		sliced_limb.force_wound_upwards(/datum/wound/slash/moderate/many_cuts)

/datum/religion_rites/song_tuner/lullaby
	name = "духовная колыбельная"
	desc = "Спойте колыбельную, утомляя окружающих, замедляя их. В конце песни вы вынудите людей, которые достаточно устали, заснуть."
	particles_path = /particles/musical_notes/sleepy
	song_invocation_message = "Подготавливаю сонливую песню!"
	song_start_message = span_warning("Эта музыка... такая спокойная... хочется спать...")
	favor_cost = 40 //actually really strong
	glow_color = "#83F6FF"
	repeats_okay = FALSE
	///assoc list of weakrefs to who heard the song, for the finishing effect to look at.
	var/list/listener_counter = list()

/datum/religion_rites/song_tuner/lullaby/Destroy()
	listener_counter.Cut()
	return ..()

/datum/religion_rites/song_tuner/lullaby/song_effect(atom/song_player, datum/song/song_datum)
	if(!song_datum)
		return
	for(var/mob/living/listener in song_datum.hearing_mobs)
		if(listener.anti_magic_check(TRUE, TRUE))
			continue
		if(listener.mind?.holy_role)
			continue
		if(prob(20))
			to_chat(listener, span_warning(pick("Музыка усыпляет меня...", "Музыка вынуждает меня заснуть на мгновение.", "Вы пытаетесь сосредоточиться на бодрствовании и не слушать песню.")))
			listener.emote("yawn")
		listener.blur_eyes(2)

/datum/religion_rites/song_tuner/lullaby/finish_effect(atom/song_player, datum/song/song_datum)
	for(var/mob/living/carbon/human/listener in song_datum.hearing_mobs)
		if(listener.anti_magic_check(TRUE, TRUE))
			continue
		to_chat(listener, span_danger("Вау, конец этой песни был... довольно...z-z-z"))//#ZА МИР!!!
		listener.AdjustSleeping(5 SECONDS)

