/datum/ai_behavior/move_to_target/tdroid
	required_distance = 2

/datum/ai_behavior/pull/tdroid
	pull_target_key = BB_TDROID_FOLLOW_TARGET

/datum/ai_behavior/tdroid_equip
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/tdroid_try_kill
	//behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/tdroid_try_kill/perform(delta_time, datum/ai_controller/controller)
	. = ..()

/datum/ai_behavior/tdroid_try_kill/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()

/datum/ai_behavior/tdroid_try_ko
	//behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/tdroid_try_ko/perform(delta_time, datum/ai_controller/controller)
	. = ..()

/datum/ai_behavior/tdroid_try_ko/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
