/datum/action/cooldown/spell/pointed/mind_transfer
	name = "Обмен разумами"
	desc = "Позволяет вам обменяться телами с разумным гуманоидом находящимся рядом."
	button_icon_state = "mindswap"
	ranged_mousepointer = 'icons/effects/mouse_pointers/mindswap_target.dmi'

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 60 SECONDS
	cooldown_reduction_per_rank =  10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_MIND|SPELL_CASTABLE_AS_BRAIN
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND

	invocation = "GIN'YU CAPAN"
	invocation_type = INVOCATION_WHISPER

	active_msg = "Я готовлюсь поменяться телами с целью..."
	deactive_msg = "Я рассеиваю попытку обмена мыслями."
	cast_range = 1

	/// If TRUE, we cannot mindswap into mobs with minds if they do not currently have a key / player.
	var/target_requires_key = TRUE
	/// For how long is the caster stunned for after the spell
	var/unconscious_amount_caster = 40 SECONDS
	/// For how long is the victim stunned for after the spell
	var/unconscious_amount_victim = 40 SECONDS
	/// List of mobs we cannot mindswap into.
	var/static/list/mob/living/blacklisted_mobs = typecacheof(list(
		/mob/living/brain,
		/mob/living/silicon/pai,
		/mob/living/simple_animal/hostile/imp/slaughter,
		/mob/living/simple_animal/hostile/megafauna,
	))

/datum/action/cooldown/spell/pointed/mind_transfer/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(owner))
		return FALSE
	if(owner.suiciding)
		if(feedback)
			to_chat(owner, span_warning("Я убиваю себя этим! Я не могу достаточно сконцентрироваться, чтобы сделать это!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/mind_transfer/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	if(!isliving(cast_on))
		to_chat(owner, span_warning("Я могу обмениваться разумом только с живым существом!"))
		return FALSE
	if(is_type_in_typecache(cast_on, blacklisted_mobs))
		to_chat(owner, span_warning("Это существо слишком [pick("могущественное", "странное", "загадочное", "отвратительное")] для контроля!"))
		return FALSE
	if(isguardian(cast_on))
		var/mob/living/simple_animal/hostile/guardian/stand = cast_on
		if(stand.summoner && stand.summoner == owner)
			to_chat(owner, span_warning("Обмен разумами с моим собственным защитником просто вернул бы меня в свою собственную голову!"))
			return FALSE

	var/mob/living/living_target = cast_on
	if(living_target.stat == DEAD)
		to_chat(owner, span_warning("Я не хочу быть мертвым!"))
		return FALSE
	if(!living_target.mind)
		to_chat(owner, span_warning("[living_target.p_theyve(TRUE)] похоже в этом теле нет и искры разума, обмениваться там не с чем!"))
		return FALSE
	if(!living_target.key && target_requires_key)
		to_chat(owner, span_warning("[living_target.p_theyve(TRUE)] похоже [living_target.p_s()] не имеет разума! \
			Даже магия не может повлиять на пустой разум [living_target.p_their()]."))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/mind_transfer/cast(mob/living/cast_on)
	. = ..()
	swap_minds(owner, cast_on)

/datum/action/cooldown/spell/pointed/mind_transfer/proc/swap_minds(mob/living/caster, mob/living/cast_on)

	var/mob/living/to_swap = cast_on
	if(isguardian(cast_on))
		var/mob/living/simple_animal/hostile/guardian/stand = cast_on
		if(stand.summoner)
			to_swap = stand.summoner

	var/datum/mind/mind_to_swap = to_swap.mind
	if(to_swap.can_block_magic(antimagic_flags) \
		|| mind_to_swap.has_antag_datum(/datum/antagonist/wizard) \
		|| mind_to_swap.has_antag_datum(/datum/antagonist/cult) \
		|| mind_to_swap.has_antag_datum(/datum/antagonist/changeling) \
		|| mind_to_swap.has_antag_datum(/datum/antagonist/rev) \
		|| mind_to_swap.key?[1] == "@" \
	)
		to_chat(caster, span_warning("Разум [to_swap.p_their(TRUE)] сопротивляется моим чарам!"))
		return FALSE

	// MIND TRANSFER BEGIN

	var/datum/mind/caster_mind = caster.mind
	var/datum/mind/to_swap_mind = to_swap.mind

	var/to_swap_key = to_swap.key

	caster_mind.transfer_to(to_swap)
	to_swap_mind.transfer_to(caster)

	// Just in case the swappee's key wasn't grabbed by transfer_to...
	if(to_swap_key)
		caster.key = to_swap_key

	// MIND TRANSFER END

	// Now we knock both mobs out for a time.
	caster.Unconscious(unconscious_amount_caster)
	to_swap.Unconscious(unconscious_amount_victim)

	// Only the caster and victim hear the sounds,
	// that way no one knows for sure if the swap happened
	SEND_SOUND(caster, sound('sound/magic/mandswap.ogg'))
	SEND_SOUND(to_swap, sound('sound/magic/mandswap.ogg'))

	return TRUE
