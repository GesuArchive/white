///Telekinesis lets you interact with objects from range, and gives you a light blue halo around your head.
/datum/mutation/human/telekinesis
	name = "Телекинез"
	desc = "Мутация, позволяющая владельцу перемещать предметы силой мысли."
	quality = POSITIVE
	difficulty = 18
	text_gain_indication = span_notice("Хм, у меня такое ощущение что я могу дотянуться до чего угодно!")
	limb_req = BODY_ZONE_HEAD
	instability = 30

/datum/mutation/human/telekinesis/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "telekinesishead", -MUTATIONS_LAYER))

/datum/mutation/human/telekinesis/on_acquiring(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	RegisterSignal(H, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_ranged_attack))

/datum/mutation/human/telekinesis/on_losing(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	UnregisterSignal(H, COMSIG_MOB_ATTACK_RANGED)

/datum/mutation/human/telekinesis/get_visual_indicator()
	return visual_indicators[type][1]

///Triggers on COMSIG_MOB_ATTACK_RANGED. Usually handles stuff like picking up items at range.
/datum/mutation/human/telekinesis/proc/on_ranged_attack(mob/source, atom/target)
	SIGNAL_HANDLER
	return target.attack_tk(source)
