/datum/ai_behavior/pull
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	var/pull_target_key

/datum/ai_behavior/pull/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/atom/movable/pull_target = controller.blackboard[pull_target_key]
	if(!pull_target)
		return
	controller.current_movement_target = pull_target
	if(!ismovable(controller.pawn))
		return
	var/atom/movable/movable_pawn = controller.pawn
	if(movable_pawn.Adjacent(pull_target))
		if(movable_pawn.start_pulling(pull_target))
			finish_action(controller, TRUE)
			return
		finish_action(controller, FALSE)
