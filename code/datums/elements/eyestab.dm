#define CLUMSY_ATTACK_SELF_CHANCE 50
#define EYESTAB_BLEEDING_THRESHOLD 10

/// An element that lets you stab people in the eyes when targeting them
/datum/element/eyestab
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

	/// The amount of damage to do per eyestab
	var/damage = 7

/datum/element/eyestab/Attach(datum/target, damage)
	. = ..()

	if (!isitem(target))
		return ELEMENT_INCOMPATIBLE

	if (!isnull(damage))
		src.damage = damage

	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_item_attack))

/datum/element/eyestab/Detach(datum/source, ...)
	. = ..()

	UnregisterSignal(source, COMSIG_ITEM_ATTACK)

/datum/element/eyestab/proc/on_item_attack(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if (user.zone_selected == BODY_ZONE_PRECISE_EYES)
		if (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(CLUMSY_ATTACK_SELF_CHANCE))
			target = user

		perform_eyestab(source, target, user)

		return COMPONENT_SKIP_ATTACK

/datum/element/eyestab/proc/perform_eyestab(obj/item/item, mob/living/target, mob/living/user)
	var/obj/item/bodypart/target_limb = target.get_bodypart(BODY_ZONE_HEAD)


	if (HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("Не могу позволить себе проткнуть глаз человеку! Это навредит ему!"))
		return

	if (ishuman(target) && isnull(target_limb))
		return

	if (target.is_eyes_covered())
		to_chat(user, span_warning("You failed to stab [target.p_their()] eyes, you need to remove [target.p_their()] eye protection first!"))
		return

	if (isalien(target))
		to_chat(user, span_warning("You cannot locate any eyes on this creature!"))
		return

	if (isbrain(target))
		to_chat(user, span_warning("You cannot locate any organic eyes on this brain!"))
		return

	item.add_fingerprint(user)

	playsound(item, item.hitsound, 30, TRUE, -1)

	user.do_attack_animation(target)

	if (target == user)
		user.visible_message(
			span_danger("[user] протыкает свой глаз с помощью [item]!"),
			span_userdanger("Протыкаю себе глаз с помощью [item]!"),
		)
	else
		target.visible_message(
			span_danger("[user] протыкает глаз [target] с помощью [item]!"),
			span_userdanger("[user] протыкает ваш глаз с помощью [item]!"),
		)

	if (target_limb)
		target.apply_damage(damage, BRUTE, target_limb)
	else
		target.take_bodypart_damage(damage)

	SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "eye_stab", /datum/mood_event/eye_stab)

	log_combat(user, target, "attacked (eyestabbed)", "[item.name]")

	var/obj/item/organ/eyes/eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	if (!eyes)
		return

	target.adjust_blurriness(3)
	eyes.applyOrganDamage(rand(2,4))

	if(eyes.damage < EYESTAB_BLEEDING_THRESHOLD)
		return

	target.adjust_blurriness(15)
	if (target.stat != DEAD)
		to_chat(target, span_danger("Мои глаза начинают обильно кровоточить!"))

	if (!target.is_blind() && !HAS_TRAIT(target, TRAIT_NEARSIGHT))
		to_chat(target, span_danger("Мое зрение ухудшилось!"))

	target.become_nearsighted(EYE_DAMAGE)

	if (prob(50))
		if (target.stat != DEAD && target.drop_all_held_items())
			to_chat(target, span_danger("Роняю то, что держу в руках, и хватаюсь за глаза!"))
		target.adjust_blurriness(10)
		target.Unconscious(20)
		target.Paralyze(40)

	if (prob(eyes.damage - EYESTAB_BLEEDING_THRESHOLD + 1))
		target.become_blind(EYE_DAMAGE)
		to_chat(target, span_danger("Я ОСЛЕП!"))

#undef CLUMSY_ATTACK_SELF_CHANCE
#undef EYESTAB_BLEEDING_THRESHOLD
