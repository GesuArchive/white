/// How many life ticks are required for the nightmare's heart to revive the nightmare.
#define HEART_RESPAWN_THRESHHOLD 40
/// A special flag value used to make a nightmare heart not grant a light eater. Appears to be unused.
#define HEART_SPECIAL_SHADOWIFY 2


/obj/item/organ/brain/nightmare
	name = "черная масса"
	desc = "Сочащийся черным дегтем комок плоти, извлеченный из головы Кошмара."
	icon_state = "brain-x-d"
	var/datum/action/cooldown/spell/jaunt/shadow_walk/our_jaunt

/obj/item/organ/brain/nightmare/Insert(mob/living/carbon/M, special = FALSE)
	. = ..()
	if(M.dna.species.id != "nightmare")
		M.set_species(/datum/species/shadow/nightmare)
		visible_message(span_warning("[M] thrashes as [src] takes root in [M.p_their()] body!"))

	our_jaunt = new(M)
	our_jaunt.Grant(M)

/obj/item/organ/brain/nightmare/Remove(mob/living/carbon/M, special = FALSE)
	QDEL_NULL(our_jaunt)
	return ..()

/obj/item/organ/heart/nightmare
	name = "Сердце тьмы"
	desc = "Чужеродный орган, который извивается и корчится под воздействием света."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "demon_heart-on"
	color = "#1C1C1C"
	decay_factor = 0
	/// How many life ticks in the dark the owner has been dead for. Used for nightmare respawns.
	var/respawn_progress = 0
	/// The armblade granted to the host of this heart.
	var/obj/item/light_eater/blade

/obj/item/organ/heart/nightmare/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/item/organ/heart/nightmare/attack(mob/M, mob/living/carbon/user, obj/target)
	if(M != user)
		return ..()
	user.visible_message(
		span_warning("[user] подносит [src] ко рту [user.p_their()] и вгрызается в него зубами [user.p_their()]!") ,
		span_danger("[src] кажется неестественно холодным в моих руках. Ты подносишь [src] к своему рту и пожираешь его!")
	)
	playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)

	user.visible_message(
		span_warning("Кровь извергается из руки [user], когда формируется меч!") ,
		span_userdanger("У меня кровь стынет в жилах от зрелища, как моя рука неестественно искажается и перестраивается, формируя гротескный меч из плоти и костей!")
	)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)

/obj/item/organ/heart/nightmare/Insert(mob/living/carbon/M, special = FALSE)
	. = ..()
	if(special != HEART_SPECIAL_SHADOWIFY)
		blade = new/obj/item/light_eater
		M.put_in_hands(blade)

/obj/item/organ/heart/nightmare/Remove(mob/living/carbon/M, special = FALSE)
	respawn_progress = 0
	if(blade && special != HEART_SPECIAL_SHADOWIFY)
		M.visible_message(span_warning("<b>[capitalize(blade)]</b> распадается!"))
		QDEL_NULL(blade)
	return ..()

/obj/item/organ/heart/nightmare/Stop()
	return 0

/obj/item/organ/heart/nightmare/on_death()
	if(!owner)
		return
	var/turf/T = get_turf(owner)
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			respawn_progress++
			playsound(owner, 'sound/effects/singlebeat.ogg', 40, TRUE)
	if(respawn_progress < HEART_RESPAWN_THRESHHOLD)
		return

	owner.revive(full_heal = TRUE, admin_revive = FALSE)
	if(!(owner.dna.species.id == "shadow" || owner.dna.species.id == "nightmare"))
		var/mob/living/carbon/old_owner = owner
		Remove(owner, HEART_SPECIAL_SHADOWIFY)
		old_owner.set_species(/datum/species/shadow)
		Insert(old_owner, HEART_SPECIAL_SHADOWIFY)
		to_chat(owner, span_userdanger("Я чувствую, что тени обволакивают меня, они проникают в моё сердце и оно снова начинает биться! Тьма вернулась в этот мир!"))
		SEND_SOUND(owner, sound('sound/effects/ghost.ogg'))
	owner.visible_message(span_warning("[owner] поднимается на ноги!"))
	playsound(owner, 'sound/hallucinations/far_noise.ogg', 50, TRUE)
	respawn_progress = 0

/obj/item/organ/heart/nightmare/get_availability(datum/species/S)
	if(istype(S,/datum/species/shadow/nightmare))
		return TRUE
	return ..()

#undef HEART_SPECIAL_SHADOWIFY
#undef HEART_RESPAWN_THRESHHOLD
