/datum/component/antishruman
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/list/protected_ckeys = list("valtosss")

/datum/component/antishruman/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/antishruman/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_CLICKON, PROC_REF(handle_click))

/datum/component/antishruman/proc/handle_click(mob/user, atom/A, params)
	SIGNAL_HANDLER
	if(!ismob(A))
		return

	var/mob/M = A

	if(!(M.ckey in protected_ckeys))
		return

	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/antishruman/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CLICKON)
