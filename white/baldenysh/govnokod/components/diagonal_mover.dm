/datum/component/diagonal_mover
	var/atom/old_old_loc
	var/atom/old_loc

/datum/component/diagonal_mover/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/diagonal_mover/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE, .proc/update_locations)
	RegisterSignal(parent, "movable_moved_fucking_4real_now", .proc/check_for_diagonal)

/datum/component/diagonal_mover/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE)
	UnregisterSignal(parent, "movable_moved_fucking_4real_now")

/datum/component/diagonal_mover/proc/update_locations(newloc)
	var/atom/movable/M = parent
	old_old_loc = old_loc
	old_loc = M.loc

/datum/component/diagonal_mover/proc/check_for_diagonal()
	var/atom/movable/M = parent
	if(old_old_loc && get_dist(old_old_loc, M.loc) == 1)
		M.setDir(get_dir(old_old_loc, M.loc))
