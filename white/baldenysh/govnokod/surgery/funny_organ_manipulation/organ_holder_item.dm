/datum/element/organ_holder_item
	var/image/connected_organ_underlay

/datum/element/organ_holder_item/Attach(atom/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	if(!connected_organ_underlay)
		connected_organ_underlay = mutable_appearance(icon = 'white/baldenysh/icons/obj/organs.dmi', icon_state = "connected_organ_underlay")
	RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_underlays) //похуй тупа паебать
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/handle_examine)
	target.update_icon(UPDATE_OVERLAYS)

/datum/element/organ_holder_item/Detach(atom/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_OVERLAYS)
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)
	source.update_icon(UPDATE_OVERLAYS)

/datum/element/organ_holder_item/proc/handle_examine(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	if(isorgan(source))
		var/obj/item/organ/O = source
		if(O.owner)
			examine_text += span_notice("\n[source] можно отрезать <i>скальпелем</i> или вырвать руками.")
		else
			examine_text += span_notice("\n[source] можно пришить исользуя <i>хирургический зажим</i>.")

/datum/element/organ_holder_item/proc/apply_underlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER
	if(isorgan(parent_atom))
		var/obj/item/organ/O = parent_atom
		O.underlays.Cut()
		if(O.owner)
			O.underlays |= connected_organ_underlay
