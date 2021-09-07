//отвечает за то штоб нельзя было трогать пограничную хрень типа виндура или файрлока када между ней и трогателем непроходимый объект
//если на примерах - работает как can_be_reached у окон
//необходимо отключать INTERACT_ATOM_ATTACK_HAND в interaction_flags_atom чтоб работало как надо, может отключение вообще в элемент напрямую впилить...
/datum/element/border_reach_check
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	//отвечает за перекидывание действия с заблоченной пограничной хрени на блокирующий атом
	var/blocker_interact = FALSE
	var/list/tools_signals = list(TOOL_CROWBAR, TOOL_WRENCH)

/datum/element/border_reach_check/Attach(datum/target, should_blocker_interact, tools_signals_override)
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	blocker_interact = should_blocker_interact
	if(tools_signals_override)
		tools_signals = tools_signals_override
	RegisterSignal(target, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
	RegisterSignal(target, COMSIG_ATOM_ATTACK_PAW, .proc/on_attack_paw)
	RegisterSignal(target, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	for(var/tool_type in tools_signals)
		RegisterSignal(target, COMSIG_ATOM_TOOL_ACT(tool_type), .proc/on_tool_act)
	return ..()

/datum/element/border_reach_check/Detach(atom/source)
	UnregisterSignal(source, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_PAW))
	for(var/tool_type in tools_signals)
		UnregisterSignal(source, COMSIG_ATOM_TOOL_ACT(tool_type))
	return ..()

/datum/element/border_reach_check/proc/on_attack_hand(atom/source, mob/user)
	SIGNAL_HANDLER
	var/obj/blocker = get_reach_blocker(source, user)
	if(!blocker)
		return
	if(blocker_interact)
		INVOKE_ASYNC(blocker, /atom.proc/attack_hand, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/border_reach_check/proc/on_attack_paw(atom/source, mob/user)
	SIGNAL_HANDLER
	var/obj/blocker = get_reach_blocker(source, user)
	if(!blocker)
		return
	if(blocker_interact)
		INVOKE_ASYNC(blocker, /atom.proc/attack_paw, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/border_reach_check/proc/on_attackby(atom/source, obj/item/W, mob/user, params)
	SIGNAL_HANDLER
	var/obj/blocker = get_reach_blocker(source, user)
	if(!blocker)
		return
	if(blocker_interact)
		INVOKE_ASYNC(blocker, /atom.proc/attackby, W, user, params)
	return COMPONENT_NO_AFTERATTACK

/datum/element/border_reach_check/proc/on_tool_act(atom/source, mob/living/user, obj/item/I, tool_type)
	SIGNAL_HANDLER
	var/obj/blocker = get_reach_blocker(source, user)
	if(!blocker)
		return
	if(blocker_interact)
		INVOKE_ASYNC(blocker, /atom.proc/tool_act, user, I, tool_type)
	return COMPONENT_BLOCK_TOOL_ATTACK

/datum/element/border_reach_check/proc/get_reach_blocker(atom/border_atom, mob/user)
	var/checking_dir = get_dir(user, border_atom)
	if(!(checking_dir & border_atom.dir))
		return
	checking_dir = REVERSE_DIR(checking_dir)
	for(var/obj/blocker in sortList(border_atom.loc.contents, /proc/cmp_atom_layer_dsc))
		if(blocker == border_atom)
			continue
		if(!blocker.CanPass(user, checking_dir))
			return blocker

/proc/cmp_atom_layer_dsc(atom/A,atom/B)
	if(A.plane != B.plane)
		return B.plane - A.plane
	else
		return B.layer - A.layer
