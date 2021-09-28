/datum/element/organ_holder_organ //супер крутой аниме нейминг коворкинг смешной
	var/image/connected_organ_underlay

/datum/element/organ_holder_organ/Attach(atom/target)
	. = ..()
	if(!isorgan(target))
		return ELEMENT_INCOMPATIBLE
	if(!connected_organ_underlay)
		connected_organ_underlay = mutable_appearance(icon = 'white/baldenysh/icons/obj/organs.dmi', icon_state = "connected_organ_underlay")
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_underlays) //похуй тупа паебать
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/handle_examine)
	RegisterSignal(target, COMSIG_ATOM_TOOL_ACT(TOOL_SCALPEL), .proc/scalpel_act)
	RegisterSignal(target, COMSIG_ATOM_TOOL_ACT(TOOL_HEMOSTAT), .proc/hemostat_act)
	RegisterSignal(target, COMSIG_ATOM_ATTACK_HAND, .proc/hand_interaction)
	target.update_icon(UPDATE_OVERLAYS)

/datum/element/organ_holder_organ/Detach(atom/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_OVERLAYS)
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(source, COMSIG_ATOM_TOOL_ACT(TOOL_SCALPEL))
	UnregisterSignal(source, COMSIG_ATOM_TOOL_ACT(TOOL_HEMOSTAT))
	UnregisterSignal(source, COMSIG_ATOM_ATTACK_HAND)
	source.underlays.Cut()

/datum/element/organ_holder_organ/proc/handle_examine(obj/item/organ/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	if(source.owner)
		examine_text += span_notice("\n[capitalize(source.name)] можно отрезать <b>скальпелем</b> или вырвать руками.")
	else
		examine_text += span_notice("\n[capitalize(source.name)] можно пришить используя <b>зажим</b>.")

/datum/element/organ_holder_organ/proc/apply_underlays(obj/item/organ/source, list/overlays)
	SIGNAL_HANDLER
	source.underlays.Cut()
	if(source.owner)
		source.underlays |= connected_organ_underlay

/datum/element/organ_holder_organ/proc/hand_interaction(obj/item/organ/source, mob/living/living_user, modifiers)
	SIGNAL_HANDLER
	var/mob/living/carbon/owner = source.owner
	if(owner)
		if(istype(living_user) && living_user.a_intent == INTENT_HARM)
			INVOKE_ASYNC(src, .proc/rip, source, living_user, owner)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/organ_holder_organ/proc/scalpel_act(obj/item/organ/source, mob/user, obj/item/item)
	SIGNAL_HANDLER
	var/mob/living/carbon/owner = source.owner
	if(owner)
		INVOKE_ASYNC(src, .proc/cut_off, source, user, owner)

/datum/element/organ_holder_organ/proc/hemostat_act(obj/item/organ/source, mob/user, obj/item/item)
	SIGNAL_HANDLER
	if(!source.owner && iscarbon(source.loc.loc))
		INVOKE_ASYNC(src, .proc/connect, source, user, source.loc.loc)

/datum/element/organ_holder_organ/proc/cut_off(obj/item/organ/source, mob/user, mob/living/carbon/owner)
	to_chat(user, span_notice("Начинаю отрезать [source]."))
	if(do_after(user, 5, ))
		user.visible_message(span_notice("[user] успешно отрезает [source]!"), span_notice("Удалось отрезать [source]!"))
		source.Remove(owner)
		source.update_icon(UPDATE_OVERLAYS)

/datum/element/organ_holder_organ/proc/connect(obj/item/organ/source, mob/user, mob/living/carbon/owner)
	to_chat(user, span_notice("Начинаю пришивать [source]."))
	if(do_after(user, 5, source.loc.loc))
		user.visible_message(span_notice("[user] успешно пришивает [source]!"), span_notice("Удалось пришить [source]!"))
		source.Insert(owner)
		source.update_icon(UPDATE_OVERLAYS)

/datum/element/organ_holder_organ/proc/rip(obj/item/organ/source, mob/user, mob/living/carbon/owner)
	user.visible_message(span_danger("[user] пытается вырвать [source]!"), span_danger("Начинаю вырывать [source]!"))
	if(do_after(user, 10 SECONDS, source.loc.loc))
		user.visible_message(span_danger("[user] вырывает [source]!"), span_danger("Вырываю [source]!"))
		source.Remove(owner)
		source.forceMove(get_turf(owner))
		if(iscarbon(user))
			user.put_in_hands(source)
		source.underlays.Cut()
