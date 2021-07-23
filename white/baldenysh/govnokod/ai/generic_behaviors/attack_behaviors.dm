/datum/ai_behavior/carbon_shooting
	var/shoot_target_key

	var/gun_hand = RIGHT_HANDS //мб вместо этой хуйни просто пустую руку выбирать, но тогда придется и перезарядку переделывать
	var/required_stat = UNCONSCIOUS
	var/double_shot = TRUE

/datum/ai_behavior/carbon_shooting/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/atom/shooting_target = controller.blackboard[shoot_target_key]
	var/mob/living/carbon/carbon_pawn = controller.pawn
	var/obj/item/gun/pawns_gun = carbon_pawn.held_items[gun_hand]

	carbon_pawn.swap_hand(gun_hand)

	if(!shooting_target)
		finish_action(controller, FALSE)
		return
	if(!pawns_gun || !(pawns_gun in carbon_pawn.held_items))
		finish_action(controller, FALSE)
		return
	if(!pawns_gun.can_shoot())
		if(istype(pawns_gun, /obj/item/gun/ballistic))
			var/obj/item/gun/ballistic/B = pawns_gun
			if(B.bolt_locked)
				B.attack_self(carbon_pawn)
				if(!B.can_shoot())
					finish_action(controller, FALSE)
					return
		else
			finish_action(controller, FALSE)
			return

	if(isliving(shooting_target))
		var/mob/living/living_target = shooting_target
		if(living_target.stat >= required_stat)
			finish_action(controller, FALSE)
			return
		if(pawns_gun.chambered && pawns_gun.chambered.harmful == FALSE && living_target.getStaminaLoss() > 100)
			finish_action(controller, FALSE)
			return

	if(pawns_gun.weapon_weight == WEAPON_HEAVY)
		carbon_pawn.dropItemToGround(carbon_pawn.get_inactive_held_item())

	execute_a_little_bit_of_trolling(carbon_pawn, shooting_target, pawns_gun)
	if(double_shot && istype(pawns_gun, /obj/item/gun/ballistic/automatic))
		spawn(1)
			execute_a_little_bit_of_trolling(carbon_pawn, shooting_target, pawns_gun)

	//finish_action(controller, TRUE)

/datum/ai_behavior/carbon_shooting/proc/execute_a_little_bit_of_trolling(mob/living/shooter, atom/target, obj/item/gun/shooters_gun)
	if(!target|| QDELETED(target))
		return
	if(!shooters_gun || QDELETED(shooters_gun) || !shooters_gun.can_shoot())
		return
	shooter.face_atom(target)
	shooters_gun.afterattack(target, shooter)

	if(istype(shooters_gun, /obj/item/gun/ballistic/rifle))
		spawn(1)
			shooters_gun.attack_self(shooter)

/datum/ai_behavior/carbon_shooting/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.blackboard[shoot_target_key] = null

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_unarmed
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

	var/target_key

	var/unarmed_hand = RIGHT_HANDS
	var/required_stat = SOFT_CRIT

/datum/ai_behavior/carbon_unarmed/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_target = controller.blackboard[target_key]
	var/mob/living/carbon/carbon_pawn = controller.pawn

	if(carbon_pawn.next_move > world.time)
		return
	carbon_pawn.changeNext_move(CLICK_CD_MELEE)

	if(!living_target || living_target.stat >= required_stat)
		finish_action(controller, FALSE)
		return

	if(get_dist(carbon_pawn, living_target) > 1 || carbon_pawn.z != living_target.z)
		finish_action(controller, FALSE)
		return

	if(carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(unarmed_hand)))
		make_the_amogusu_momento(carbon_pawn, living_target)
	finish_action(controller, TRUE)

/datum/ai_behavior/carbon_unarmed/proc/make_the_amogusu_momento(mob/living/carbon/carbon_pawn, mob/living/target)
	if(should_disarm(carbon_pawn, target))
		carbon_pawn.a_intent = INTENT_DISARM
		carbon_pawn.UnarmedAttack(target)

	if(should_grab(carbon_pawn, target))
		carbon_pawn.a_intent = INTENT_GRAB
		carbon_pawn.UnarmedAttack(target)

	carbon_pawn.a_intent = INTENT_HARM
	carbon_pawn.UnarmedAttack(target)

/datum/ai_behavior/carbon_unarmed/proc/should_disarm(mob/living/carbon/carbon_pawn, mob/living/target)
	var/turf/T = get_step(target, get_dir(carbon_pawn, target))
	for(var/atom/A in T)
		if(A.density)
			return TRUE
	return FALSE

/datum/ai_behavior/carbon_unarmed/proc/should_grab(mob/living/carbon/carbon_pawn, mob/living/target)
	return target.body_position == LYING_DOWN

/datum/ai_behavior/carbon_unarmed/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[target_key] = null
////////////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_unarmed/cqc/make_the_amogusu_momento(mob/living/carbon/attacker, mob/living/target)
