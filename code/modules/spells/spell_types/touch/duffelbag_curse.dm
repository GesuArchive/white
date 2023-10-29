
/datum/action/cooldown/spell/touch/duffelbag
	name = "Проклятый мешок"
	desc = "Заклинание, которое вызывает демона вещевого мешка на цель, который замедляет их и медленно съедает."
	button_icon_state = "duffelbag_curse"
	sound = 'sound/magic/mm_hit.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 6 SECONDS
	cooldown_reduction_per_rank = 1 SECONDS

	invocation = "HU'SWCH H'ANS!!"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	hand_path = /obj/item/melee/touch_attack/duffelbag

/datum/action/cooldown/spell/touch/duffelbag/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(!iscarbon(victim))
		return FALSE

	var/mob/living/carbon/duffel_victim = victim
	var/static/list/elaborate_backstory = list(
		"теориях о происхождении космических войн",
		"военных подвигах",
		"корпоративных связях",
		"воспоминаниях о жизни в колонии",
		"антипровительственных митингах",
		"воспоминаниях о воспитании на космической ферме",
		"приятных воспоминания с моим приятелем Валерой",
	)
	if(duffel_victim.can_block_magic(antimagic_flags))
		to_chat(caster, span_warning("Заклинание, похоже, не повлияло на [duffel_victim]!"))
		to_chat(duffel_victim, span_warning("Мне действительно не хочется сегодня говорить о своих [pick(elaborate_backstory)] с совершенно незнакомыми людьми."))
		return TRUE

	// To get it started, stun and knockdown the person being hit
	duffel_victim.flash_act()
	duffel_victim.Immobilize(5 SECONDS)
	duffel_victim.apply_damage(80, STAMINA)
	duffel_victim.Knockdown(5 SECONDS)

	// If someone's already cursed, don't try to give them another
	if(HAS_TRAIT(duffel_victim, TRAIT_DUFFEL_CURSE_PROOF))
		to_chat(caster, span_warning("Бремя вещевого мешка [duffel_victim] становится слишком тяжелым, и он падает на пол!"))
		to_chat(duffel_victim, span_warning("Вес этого мешка становится непосильным!"))
		return TRUE

	// However if they're uncursed, they're fresh for getting a cursed bag
	var/obj/item/storage/backpack/duffelbag/cursed/conjured_duffel = new get_turf(victim)
	duffel_victim.visible_message(
		span_danger("Рычащий вещевой мешок появляется на [duffel_victim]!"),
		span_danger("Я чувствую, что что-то привязывается ко мне, и появляется сильное желание обсудить мысли о моих [pick(elaborate_backstory)] в конце концов!"),
	)

	// This duffelbag is now cuuuurrrsseed! Equip it on them
	ADD_TRAIT(conjured_duffel, TRAIT_DUFFEL_CURSE_PROOF, CURSED_ITEM_TRAIT(conjured_duffel.name))
	conjured_duffel.pickup(duffel_victim)
	conjured_duffel.forceMove(duffel_victim)

	// Put it on their back first
	if(duffel_victim.dropItemToGround(duffel_victim.back))
		duffel_victim.equip_to_slot_if_possible(conjured_duffel, ITEM_SLOT_BACK, TRUE, TRUE)
		return TRUE

	// If the back equip failed, put it in their hands first
	if(duffel_victim.put_in_hands(conjured_duffel))
		return TRUE

	// If they had no empty hands, try to put it in their inactive hand first
	duffel_victim.dropItemToGround(duffel_victim.get_inactive_held_item())
	if(duffel_victim.put_in_hands(conjured_duffel))
		return TRUE

	// If their inactive hand couldn't be emptied or found, put it in their active hand
	duffel_victim.dropItemToGround(duffel_victim.get_active_held_item())
	if(duffel_victim.put_in_hands(conjured_duffel))
		return TRUE

	// Well, we failed to give them the duffel bag,
	// but technically we still stunned them so that's something
	return TRUE

/obj/item/melee/touch_attack/duffelbag
	name = "обременяющее прикосновение"
	desc = "Сегодня отличный день чтобы скинуть все свои проблемы на чужую спину..."
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
