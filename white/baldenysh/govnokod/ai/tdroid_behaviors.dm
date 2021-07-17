/datum/ai_behavior/move_to_target/tdroid
	required_distance = 2

/datum/ai_behavior/pull/tdroid
	pull_target_key = BB_TDROID_FOLLOW_TARGET

/////////////////////////////////////////эквип

/datum/ai_behavior/carbon_pickup/tdroid
	item_target_key = BB_TDROID_FOLLOW_TARGET

/////////////////////////////////////////грифенк
/*
/datum/ai_behavior/tdroid_try_shoot
	//behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM
	var/required_stat = 3

/datum/ai_behavior/tdroid_try_shoot/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_TDROID_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn
	var/datum/ai_controller/tdroid/TC = controller

	if(!target || target.stat >=  required_stat)
		finish_action(controller, TRUE)
		return
	if(!TC.CanInteract())
		finish_action(controller, FALSE)
		return
	if(TC.TryArmGun())
		var/obj/item/gun/G = living_pawn.held_items[RIGHT_HANDS]

		return
	else if(TC.TryFindGun())
		finish_action(controller, FALSE)
		return

/datum/ai_behavior/tdroid_try_shoot/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[BB_TDROID_ATTACK_TARGET] = null

/datum/ai_behavior/tdroid_try_shoot/proc/do_a_little_bit_of_trolling(mob/living/living_pawn, mob/living/target, obj/item/gun)
	if(living_pawn.next_move > world.time)
		return
	living_pawn.changeNext_move(CLICK_CD_RAPID)
*/
