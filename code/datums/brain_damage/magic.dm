//Magical traumas, caused by spells and curses.
//Blurs the line between the victim's imagination and reality
//Unlike regular traumas this can affect the victim's body and surroundings

/datum/brain_trauma/magic
	resilience = TRAUMA_RESILIENCE_LOBOTOMY

/datum/brain_trauma/magic/lumiphobia
	name = "Светочувствительность"
	desc = "Пациент имеет необъяснимую неблагоприятную реакцию на свет."
	scan_desc = "<b>лёгкой светочувствительности</b>"
	gain_text = span_warning("Чувствую тягу к темноте.")
	lose_text = span_notice("Свет больше не беспокоит меня.")
	/// Cooldown to prevent warning spam
	COOLDOWN_DECLARE(damage_warning_cooldown)
	var/next_damage_warning = 0

/datum/brain_trauma/magic/lumiphobia/on_life(delta_time, times_fired)
	..()
	var/turf/T = owner.loc
	if(!istype(T))
		return

	if(T.get_lumcount() <= SHADOW_SPECIES_LIGHT_THRESHOLD) //if there's enough light, start dying
		return

	if(COOLDOWN_FINISHED(src, damage_warning_cooldown))
		to_chat(owner, span_warning("<b>Свет обжигает меня!</b>"))
		COOLDOWN_START(src, damage_warning_cooldown, 10 SECONDS)
	owner.take_overall_damage(0, 1.5 * delta_time)

/datum/brain_trauma/magic/poltergeist
	name = "Полтергейст"
	desc = "Пациент, кажется, подвергается нападению со стороны невидимого объекта."
	scan_desc = "<b>паранормальной активности</b>"
	gain_text = span_warning("Чувствую ненавистное присутствие рядом со мной.")
	lose_text = span_notice("Чувствую, что ненавистное присутствие исчезает.")

/datum/brain_trauma/magic/poltergeist/on_life(delta_time, times_fired)
	..()
	if(!DT_PROB(2, delta_time))
		return

	var/most_violent = -1 //So it can pick up items with 0 throwforce if there's nothing else
	var/obj/item/throwing
	for(var/obj/item/I in view(5, get_turf(owner)))
		if(I.anchored)
			continue
		if(I.throwforce > most_violent)
			most_violent = I.throwforce
			throwing = I
	if(throwing)
		throwing.throw_at(owner, 8, 2)

/datum/brain_trauma/magic/antimagic
	name = "Нулификация"
	desc = "Пациент совершенно инертен к магическим силам."
	scan_desc = "<b>нулификации</b>"
	gain_text = span_notice("Понимаю, что магия не может быть реальной.")
	lose_text = span_notice("Понимаю, что магия может быть реальной.")

/datum/brain_trauma/magic/antimagic/on_gain()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/magic/antimagic/on_lose()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/magic/stalker
	name = "Преследующий призрак"
	desc = "Пациент преследуется фантомом, который видит только он."
	scan_desc = "<b>экстрасенсорной паранойи</b>"
	gain_text = span_warning("Чувствую, что что-то хочет меня убить...")
	lose_text = span_notice("Больше не чувствую глаза на спине.")
	var/obj/effect/hallucination/simple/stalker_phantom/stalker
	var/close_stalker = FALSE //For heartbeat

/datum/brain_trauma/magic/stalker/on_gain()
	create_stalker()
	..()

/datum/brain_trauma/magic/stalker/proc/create_stalker()
	var/turf/stalker_source = locate(owner.x + pick(-12, 12), owner.y + pick(-12, 12), owner.z) //random corner
	stalker = new(stalker_source, owner)

/datum/brain_trauma/magic/stalker/on_lose()
	QDEL_NULL(stalker)
	..()

/datum/brain_trauma/magic/stalker/on_life(delta_time, times_fired)
	// Dead and unconscious people are not interesting to the psychic stalker.
	if(owner.stat != CONSCIOUS)
		return

	// Not even nullspace will keep it at bay.
	if(!stalker || !stalker.loc || stalker.z != owner.z)
		qdel(stalker)
		create_stalker()

	if(get_dist(owner, stalker) <= 1)
		playsound(owner, 'sound/magic/demon_attack1.ogg', 50)
		owner.visible_message(span_warning("[owner] разрывают невидимые когти!") , span_userdanger("Призрачные когти разрывают моё тело на части!"))
		owner.take_bodypart_damage(rand(20, 45), wound_bonus=CANT_WOUND)
	else if(DT_PROB(30, delta_time))
		stalker.forceMove(get_step_towards(stalker, owner))
	if(get_dist(owner, stalker) <= 8)
		if(!close_stalker)
			var/sound/slowbeat = sound('sound/health/slowbeat.ogg', repeat = TRUE)
			owner.playsound_local(owner, slowbeat, 40, 0, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
			close_stalker = TRUE
	else
		if(close_stalker)
			owner.stop_sound_channel(CHANNEL_HEARTBEAT)
			close_stalker = FALSE
	..()

/obj/effect/hallucination/simple/stalker_phantom
	name = "???"
	desc = "Оно приближается..."
	image_icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	image_state = "curseblob"
