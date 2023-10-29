/datum/mutation/human/olfaction
	name = "Сверхчувствительное обоняние"
	desc = "Изменяет обонятельные рецепторы подопытного, усиливая их чувствительность до уровня сравнимого с охотничьими гончими."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = span_notice("Запахи стали определяться намного четче...")
	text_lose_indication = span_notice("Я больше не чувствую всей палитры запахов.")
	power_path = /datum/action/cooldown/spell/olfaction
	instability = 10
	synchronizer_coeff = 1

/datum/mutation/human/olfaction/modify()
	. = ..()
	var/datum/action/cooldown/spell/olfaction/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.sensitivity = GET_MUTATION_SYNCHRONIZER(src)

/datum/action/cooldown/spell/olfaction
	name = "Запомнить запах"
	desc = "Вы запоминаете запах предмета, который вы держите в руках, чтобы отследить его владельца. Если ваши руки пусты, то вы встанете на след запаха, который запомнили."
	button_icon_state = "nose"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

	/// Weakref to the mob we're tracking
	var/datum/weakref/tracking_ref
	/// Our nose's sensitivity
	var/sensitivity = 1

/datum/action/cooldown/spell/olfaction/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE

	var/mob/living/living_cast_on = cast_on
	if(ishuman(living_cast_on) && !living_cast_on.get_bodypart(BODY_ZONE_HEAD))
		to_chat(owner, span_warning("Носа нет!"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/olfaction/cast(mob/living/cast_on)
	. = ..()
	// Can we sniff? is there miasma in the air?
	var/datum/gas_mixture/air = cast_on.loc.return_air()
	var/list/cached_gases = air.gases

	if(cached_gases[/datum/gas/miasma])
		cast_on.adjust_disgust(sensitivity * 45)
		to_chat(cast_on, span_warning("УЖАСНАЯ ВОНЬ! Слишком отвратительный запах для моего чувствительного носа! Надо убраться отсюда подальше!"))
		return

	var/atom/sniffed = cast_on.get_active_held_item()
	if(sniffed)
		pick_up_target(cast_on, sniffed)
	else
		follow_target(cast_on)

/// Attempt to pick up a new target based on the fingerprints on [sniffed].
/datum/action/cooldown/spell/olfaction/proc/pick_up_target(mob/living/caster, atom/sniffed)
	var/mob/living/carbon/old_target = tracking_ref?.resolve()
	var/list/possibles = list()
	var/list/prints = GET_ATOM_FINGERPRINTS(sniffed)
	if(prints)
		for(var/mob/living/carbon/to_check as anything in GLOB.carbon_list)
			if(prints[md5(to_check.dna?.unique_identity)])
				possibles |= to_check

	// There are no finger prints on the atom, so nothing to track
	if(!length(possibles))
		to_chat(caster, span_warning("Стараюсь учуять хоть что-то, но не могу уловить никаких запахов на [sniffed]..."))
		return

	var/mob/living/carbon/new_target = tgui_input_list(caster, "Выберите запах для отслеживания", "Scent Tracking", sort_names(possibles))
	if(QDELETED(src) || QDELETED(caster))
		return

	if(QDELETED(new_target))
		// We don't have a new target OR an old target
		if(QDELETED(old_target))
			to_chat(caster, span_warning("Решаю не запоминать никаких запахов. Вместо этого замечаю свой собственный нос боковым зрением. Это напоминает мне день, когда я сконцентрировался на контроле своего дыхания и не мог остановиться потому что боялся задохнуться. Это был ужасный день."))
			tracking_ref = null

		// We don't have a new target, but we have an old target to fall back on
		else
			to_chat(caster, span_notice("Улавливаю запах [old_target]. Охота началась."))
			on_the_trail(caster)
		return

	// We have a new target to track
	to_chat(caster, span_notice("Улавливаю запах [new_target]. Охота началась."))
	tracking_ref = WEAKREF(new_target)
	on_the_trail(caster)

/// Attempt to follow our current tracking target.
/datum/action/cooldown/spell/olfaction/proc/follow_target(mob/living/caster)
	var/mob/living/carbon/current_target = tracking_ref?.resolve()
	// Either our weakref failed to resolve (our target's gone),
	// or we never had a target in the first place
	if(QDELETED(current_target))
		to_chat(caster, span_warning("У меня нет ничего, что можно было бы понюхать, и я не чую ничего, что можно было бы отследить. Вместо этого нюхаю кожу на своей руке, она немного соленая."))
		tracking_ref = null
		return

	on_the_trail(caster)

/// Actually go through and give the user a hint of the direction our target is.
/datum/action/cooldown/spell/olfaction/proc/on_the_trail(mob/living/caster)
	var/mob/living/carbon/current_target = tracking_ref?.resolve()
	if(!current_target)
		to_chat(caster, span_warning("ТЕХНИЧЕСКАЯ ОШИБКА, сообщите в кодербас. Носитель не идет по следу, но зафиксирован как идущий по следу."))
		stack_trace("[type] - on_the_trail was called when no tracking target was set.")
		tracking_ref = null
		return

	if(current_target == caster)
		to_chat(caster, span_warning("Чую след ведущий прямо к... ну да прямо ко мне..."))
		return

	if(caster.z < current_target.z)
		to_chat(caster, span_warning("След тянется куда-то далеко-далеко в необозримые дали, вы не чувствуете присутствия вашей цели на обозримом горизонте."))
		return

	else if(caster.z > current_target.z)
		to_chat(caster, span_warning("След тянется куда-то далеко-далеко в необозримые дали, вы не чувствуете присутствия вашей цели на обозримом горизонте."))
		return

	var/direction_text = span_bold("[dir2ru_text(get_dir(caster, current_target))]")
	if(direction_text)
		to_chat(caster, span_notice("Улавливаю запах [current_target]. След ведет на <b>[direction_text].</b>"))
