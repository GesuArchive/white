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

//////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_pickup
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	var/item_target_key
	var/pickup_hand = LEFT_HANDS
	var/should_equip_after = TRUE

/datum/ai_behavior/carbon_pickup/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/carbon/carbon_pawn = controller.pawn
	var/obj/item/I = controller.blackboard[item_target_key]

	if(get_dist(carbon_pawn, I) > 1)
		controller.current_movement_target = I
		return

	if(iscarbon(I.loc))
		if(!try_take_off(I, carbon_pawn))
			finish_action(controller, FALSE)
			return

	if(get_dist(carbon_pawn, I) > 1) // пох пока так
		controller.current_movement_target = I
		return

	if(isturf(I.loc))
		if(!try_pickup_item(I, carbon_pawn))
			finish_action(controller, FALSE)
			return
	if(should_equip_after && I.loc == carbon_pawn)
		I.equip_to_best_slot(carbon_pawn)
	finish_action(controller, TRUE)

/datum/ai_behavior/carbon_pickup/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.blackboard[item_target_key] = null

/datum/ai_behavior/carbon_pickup/proc/try_pickup_item(obj/item/target, mob/living/carbon/pawn)
	if(!target || target.anchored)
		return FALSE
	pawn.swap_hand(pickup_hand)
	if(!pawn.dropItemToGround(pawn.get_item_for_held_index(pickup_hand)))
		return FALSE
	target.attack_hand(pawn)
	return TRUE

/datum/ai_behavior/carbon_pickup/proc/try_take_off(obj/item/target, mob/living/carbon/pawn)
	var/mob/living/carbon/C = target.loc
	for(var/obj/item/I in C.contents)
		if(I != target)
			continue
		if(!target.canStrip(pawn, C))
			return FALSE
		if(!do_mob(pawn, C, target.strip_delay, interaction_key = REF(target)))
			return FALSE
		target.doStrip(pawn, C)
		return TRUE
	return FALSE
