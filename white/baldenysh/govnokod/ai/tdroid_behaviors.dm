/datum/ai_behavior/move_to_target/tdroid
	required_distance = 2

/datum/ai_behavior/pull/tdroid
	pull_target_key = BB_TDROID_FOLLOW_TARGET

/datum/ai_behavior/carbon_pickup/tdroid
	item_target_key = BB_TDROID_INTERACTION_TARGET

/datum/ai_behavior/carbon_shooting/tdroid
	shoot_target_key  = BB_TDROID_INTERACTION_TARGET

/datum/ai_behavior/carbon_shooting/tdroid/eliminate
	required_stat = DEAD

/datum/ai_behavior/carbon_ballistic_reload/tdroid
	ballistic_target_key  = BB_TDROID_INTERACTION_TARGET
