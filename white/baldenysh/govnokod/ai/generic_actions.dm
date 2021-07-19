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

//////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_shooting
	var/shoot_target_key
	var/gun_hand = RIGHT_HANDS
	var/required_stat = UNCONSCIOUS
	var/rapid_burst_shots = 3
	var/action_time = 3

	var/mob/living/target
	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/G

/datum/ai_behavior/carbon_shooting/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	target = controller.blackboard[shoot_target_key]
	carbon_pawn = controller.pawn
	G = carbon_pawn.held_items[gun_hand]

	if(!target || target.stat >= required_stat)
		finish_action(controller, TRUE)
		return
	if(!G || !G.can_shoot())
		finish_action(controller, FALSE)
		return

	for(var/i = 1 to rapid_burst_shots)
		spawn(i*action_time+1)
			perform_a_little_bit_of_trolling(carbon_pawn, target, G)

	finish_action(controller, TRUE)

/datum/ai_behavior/carbon_shooting/proc/perform_a_little_bit_of_trolling(mob/living/shooter, mob/living/target, obj/item/gun/G)
	if(!target|| QDELETED(target) || target.stat >= required_stat)
		return
	if(!G || QDELETED(G) || !G.can_shoot())
		return
	shooter.face_atom(target)
	G.afterattack(target, shooter)
	if(istype(G, /obj/item/gun/ballistic/rifle))
		var/obj/item/gun/ballistic/rifle/R = G
		spawn(action_time/3)
			R.rack()
			var/obj/item/ammo_box/magazine/internal/intmag = locate(/obj/item/ammo_box/magazine/internal) in R.contents
			if(intmag.ammo_count(FALSE))
				spawn(action_time/3)
					R.rack()

/datum/ai_behavior/carbon_shooting/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.blackboard[shoot_target_key] = null

//////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_ballistic_reload
	var/ballistic_target_key
	var/reloading_hand = LEFT_HANDS

	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/ballistic/B

/datum/ai_behavior/carbon_ballistic_reload/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	carbon_pawn = controller.pawn
	B = controller.blackboard[ballistic_target_key]

	if(B.bolt_type == BOLT_TYPE_STANDARD && !B.bolt_locked)
		B.attack_self(carbon_pawn)
	carbon_pawn.swap_hand(reloading_hand)

	if(istype(B.magazine, /obj/item/ammo_box/magazine/internal))
		var/obj/item/ammo_box/magazine/internal/intmag = B.magazine
		if(intmag.multiload)
			for(var/obj/item/ammo_box/box in (carbon_pawn.contents | view(1, carbon_pawn)))
				if(!box.stored_ammo.len || box.ammo_type != intmag.ammo_type)
					continue
				if(carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(reloading_hand)))
					carbon_pawn.put_in_hand(box, reloading_hand, FALSE, FALSE)
					B.attackby(box, carbon_pawn)
					carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(reloading_hand))
					finish_action(controller, TRUE)
					return

		var/found_live_casing = FALSE
		for(var/obj/item/ammo_casing/casing in (carbon_pawn.contents | view(1, carbon_pawn)))
			if(!casing.BB || casing.type != intmag.ammo_type)
				continue
			found_live_casing = TRUE
			if(carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(reloading_hand)))
				carbon_pawn.put_in_hand(casing, reloading_hand, FALSE, FALSE)
				B.attackby(casing, carbon_pawn)

		finish_action(controller, found_live_casing)
		return
	else
		var/obj/item/ammo_box/magazine/newmag
		var/last_ammo_count = 0
		for(var/obj/item/ammo_box/magazine/mag in (carbon_pawn.contents | view(1, carbon_pawn)))
			if(mag.type != B.mag_type)
				continue
			var/cur_count = mag.ammo_count(FALSE)
			if(cur_count > last_ammo_count)
				last_ammo_count = cur_count
				newmag = mag
		if(!newmag)
			finish_action(controller, FALSE)
			return

		B.eject_magazine(carbon_pawn)
		if(carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(reloading_hand)))
			carbon_pawn.put_in_hand(newmag, reloading_hand, FALSE, FALSE)
			B.insert_magazine(carbon_pawn, newmag)
			finish_action(controller, TRUE)
			return
	finish_action(controller, FALSE)
	return

/datum/ai_behavior/carbon_ballistic_reload/finish_action(datum/ai_controller/controller, success)
	. = ..()
	/*
	if(success)
		if(B.bolt_type == BOLT_TYPE_STANDARD && !B.chambered)
			B.attack_self(carbon_pawn)
	*/

	if(B.bolt_type == BOLT_TYPE_STANDARD && B.bolt_locked)
		B.attack_self(carbon_pawn)

	controller.blackboard[ballistic_target_key] = null
