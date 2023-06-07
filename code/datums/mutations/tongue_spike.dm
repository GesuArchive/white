/datum/mutation/human/tongue_spike
	name = "Языковой шип"
	desc = "Позволяет произвести мгновенную коварную атаку, выстрелив в оппонента скрывающимся в вашем рту острым шипом."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя весьма острым на язык.")
	instability = 20
	power_path = /datum/action/cooldown/spell/tongue_spike

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/tongue_spike
	name = "Выстрел шипом"
	desc = "Выстреливает языковым шипом строго <b>в направлении вашего взгляда</b>. Спустя некоторое время шип можно вырастить заново."
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "spike"

	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_HUMAN

	/// The type-path to what projectile we spawn to throw at someone.
	var/spike_path = /obj/item/hardened_spike

/datum/action/cooldown/spell/tongue_spike/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/tongue_spike/cast(mob/living/carbon/cast_on)
	. = ..()
/*
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice("Концентрируюсь, но ничего не выходит."))
		return

	var/obj/item/organ/tongue/to_fire = locate() in cast_on.internal_organs
	if(!to_fire)
		to_chat(cast_on, span_notice("Языка нет!"))
		return

	to_fire.Remove(cast_on, special = TRUE)
	var/obj/item/hardened_spike/spike = new spike_path(get_turf(cast_on), cast_on)
	to_fire.forceMove(spike)
	spike.throw_at(get_edge_target_turf(cast_on, cast_on.dir), 14, 4, cast_on)
*/
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
//	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
//		return
	var/obj/item/organ/tongue/tongue
	for(var/org in C.internal_organs)
		if(istype(org, /obj/item/organ/tongue))
			tongue = org
			break

	if(!tongue)
		if(!do_after(C, 30, C))
			return
		var/obj/item/organ/tongue/new_tongue = new()
		to_chat(C, span_notice("Формирую во рту новый шип!"))
		playsound(C,'sound/surgery/organ1.ogg', 50, TRUE)
		new_tongue.Insert(C)
		C.adjust_nutrition(-10)
		C.hydration = C.hydration - 10
		C.blood_volume = C.blood_volume - 10
		return

	tongue.Remove(C, special = TRUE)
	var/obj/item/hardened_spike/spike = new spike_path(get_turf(C), C)
	tongue.forceMove(spike)
	spike.throw_at(get_edge_target_turf(C,C.dir), 14, 4, C)
	playsound(C,'white/Feline/sounds/tongue_spike.ogg', 50, TRUE)

/obj/item/hardened_spike
	name = "языковой шип"
	desc = "Твердая биомасса в форме шипа. Очень острая!"
	icon_state = "tonguespike"
	force = 2
	throwforce = 15 //15 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math
	throw_speed = 4
	embedding = list(
		"embedded_pain_multiplier" = 4,
		"embed_chance" = 100,
		"embedded_fall_chance" = 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
	)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	hitsound = 'sound/weapons/stab1.ogg'
	custom_materials = list(/datum/material/biomass = 500)
	/// What mob "fired" our tongue
	var/datum/weakref/fired_by_ref
	/// if we missed our target
	var/missed = TRUE

/obj/item/hardened_spike/Initialize(mapload, mob/living/carbon/source)
	. = ..()
	src.fired_by_ref = WEAKREF(source)
	addtimer(CALLBACK(src, PROC_REF(check_embedded)), 5 SECONDS)

/obj/item/hardened_spike/proc/check_embedded()
	if(missed)
		unembedded()

/obj/item/hardened_spike/embedded(atom/target)
	if(isbodypart(target))
		missed = FALSE

/obj/item/hardened_spike/unembedded()
	visible_message(span_warning("[capitalize(src.name)] трескается и ломается, превращаясь в обычный кусок плоти!"))
	for(var/obj/tongue as anything in contents)
		tongue.forceMove(get_turf(src))

	qdel(src)

/datum/mutation/human/tongue_spike/chem
	name = "Химический шип"
	desc = "Позволяет выстрелить в оппонента собственным языком, после чего перенести все химические препараты из вашей крови в цель."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя очень токсичным на язык.")
	locked = TRUE
	power_path = /datum/action/cooldown/spell/tongue_spike/chem
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/tongue_spike/chem
	name = "Выстрел хим-шипом"
	desc = "Выстреливает шип в направлении вашего взгляда, нанося очень слабый урон. Пока шип в теле жертвы вы можете передать ей все химикаты находящиеся в вашей крови."
	button_icon_state = "spikechem"

	spike_path = /obj/item/hardened_spike/chem

/obj/item/hardened_spike/chem
	name = "химический шип"
	desc = "Твердая биомасса в форме шипа. Кажется она полая внутри."
	icon_state = "tonguespikechem"
	throwforce = 2 //2 + 2 (WEIGHT_CLASS_SMALL) * 0 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math again but very low or smthin
	embedding = list(
		"embedded_pain_multiplier" = 0,
		"embed_chance" = 100,
		"embedded_fall_chance" = 0,
		"embedded_pain_chance" = 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,  //never hurts once it's in you
	)
	/// Whether the tongue's already embedded in a target once before
	var/embedded_once_alread = FALSE

/obj/item/hardened_spike/chem/embedded(mob/living/carbon/human/embedded_mob)
	if(embedded_once_alread)
		return
	embedded_once_alread = TRUE

	var/mob/living/carbon/fired_by = fired_by_ref?.resolve()
	if(!fired_by)
		return

	var/datum/action/send_chems/chem_action = new(src)
	chem_action.transfered_ref = WEAKREF(embedded_mob)
	chem_action.Grant(fired_by)

	to_chat(fired_by, span_notice("Связь установлена! Используйте \"Передачу химикатов\" для перемещения их из вашей крови в тело жертвы!"))

/obj/item/hardened_spike/chem/unembedded()
	var/mob/living/carbon/fired_by = fired_by_ref?.resolve()
	if(fired_by)
		to_chat(fired_by, span_warning("Связь потеряна!"))
		var/datum/action/send_chems/chem_action = locate() in fired_by.actions
		QDEL_NULL(chem_action)

	return ..()

/datum/action/send_chems
	name = "Передача химикатов"
	desc = "Перемещает все реагенты из вашей крови в тело жертвы."
	background_icon_state = "bg_spell"
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "spikechemswap"
	check_flags = AB_CHECK_CONSCIOUS

	/// Weakref to the mob target that we transfer chemicals to on activation
	var/datum/weakref/transfered_ref

/datum/action/send_chems/New(Target)
	. = ..()
	if(!istype(target, /obj/item/hardened_spike/chem))
		qdel(src)

/datum/action/send_chems/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner) || !owner.reagents)
		return FALSE
	var/mob/living/carbon/human/transferer = owner
	var/mob/living/carbon/human/transfered = transfered_ref?.resolve()
	if(!ishuman(transfered))
		return FALSE

	to_chat(transfered, span_warning("Что-то укололо меня!"))
	transferer.reagents.trans_to(transfered, transferer.reagents.total_volume, 1, 1, 0, transfered_by = transferer)

	var/obj/item/hardened_spike/chem/chem_spike = target
	var/obj/item/bodypart/spike_location = chem_spike.check_embedded()

	//this is where it would deal damage, if it transfers chems it removes itself so no damage
	chem_spike.forceMove(get_turf(spike_location))
	chem_spike.visible_message(span_notice("[chem_spike] выпал из [spike_location]!"))
	return TRUE
