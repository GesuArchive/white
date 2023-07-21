/obj/item/organ/ears
	name = "уши"
	icon_state = "ears"
	desc = "Ухо состоит из трех частей. Внутренний, средний и внешний. Обычно должна быть видна только одна из этих частей."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("Слышу лёгкий звон в ушах.")
	now_failing = span_warning("Ничего не слышу!")
	now_fixed = span_info("Шум снова медленно начинает наполнять мои уши.")
	low_threshold_cleared = span_info("Звон в ушах утих.")

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

/obj/item/organ/ears/on_life(delta_time, times_fired)
	// only inform when things got worse, needs to happen before we heal
	if((damage > low_threshold && prev_damage < low_threshold) || (damage > high_threshold && prev_damage < high_threshold))
		to_chat(owner, span_warning("Звон в ушах становится громче, на мгновение заглушая любые внешние шумы."))

	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here. Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return

	if((damage < maxHealth) && (organ_flags & ORGAN_FAILING))	//ear damage can be repaired from the failing condition
		organ_flags &= ~ORGAN_FAILING

	if((organ_flags & ORGAN_FAILING))
		deaf = max(deaf, 1) // if we're failing we always have at least 1 deaf stack (and thus deafness)
	else // only clear deaf stacks if we're not failing
		deaf = max(deaf - (0.5 * delta_time), 0)
		if((damage > low_threshold) && DT_PROB(damage / 60, delta_time))
			adjustEarDamage(0, 4)
			SEND_SOUND(owner, sound('sound/weapons/flash_ring.ogg'))

	if(deaf)
		ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)
	else
		REMOVE_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)

/obj/item/organ/ears/proc/adjustEarDamage(ddmg, ddeaf)
	damage = max(damage + (ddmg*damage_multiplier), 0)
	deaf = max(deaf + (ddeaf*damage_multiplier), 0)

/obj/item/organ/ears/invincible
	damage_multiplier = 0

/obj/item/organ/ears/cat
	name = "котоушки"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	damage_multiplier = 2

/obj/item/organ/ears/cat
	name = "лисоушки"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "fox"
	damage_multiplier = 2

/obj/item/organ/ears/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		color = H.hair_color
		H.dna.features["ears"] = H.dna.species.mutant_bodyparts["ears"] = "Cat"
		H.update_body()

/obj/item/organ/ears/cat/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		color = H.hair_color
		H.dna.features["ears"] = "None"
		H.dna.species.mutant_bodyparts -= "ears"
		H.update_body()

/obj/item/organ/ears/penguin
	name = "уши пингвина"
	desc = "Источник счастливых ног пингвина."

/obj/item/organ/ears/penguin/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(istype(H))
		to_chat(H, span_notice("Похоже я теряю умение балансировать на ногах!"))
		H.AddElement(/datum/element/waddling)

/obj/item/organ/ears/penguin/Remove(mob/living/carbon/human/H,  special = 0)
	. = ..()
	if(istype(H))
		to_chat(H, span_notice("Кажется меня больше не шатает."))
		H.RemoveElement(/datum/element/waddling)

/obj/item/organ/ears/bronze
	name = "оловянные уши"
	desc = "Крепкие уши латунного голема."
	damage_multiplier = 0.1 //STRONK
	bang_protect = 1 //Fear me weaklings.

/obj/item/organ/ears/cybernetic
	name = "кибернетические уши"
	icon_state = "ears-c"
	desc = "Основной кибернетический орган, имитирующий работу ушей."
	damage_multiplier = 0.9
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/ears/cybernetic/upgraded
	name = "продвинутые кибернетические уши"
	icon_state = "ears-c-u"
	desc = "Усовершенствованное кибернетическое ухо, превосходящее по характеристикам обычные уши."
	damage_multiplier = 0.5

/obj/item/organ/ears/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	damage += 40/severity
