/datum/ai_behavior/carbon_shooting
	var/shoot_target_key
	var/gun_hand = RIGHT_HANDS
	var/required_stat = UNCONSCIOUS
	var/double_shot = TRUE //тик контроллера раз в две децисекунды, значит пострелять можно два раза за тик

	var/mob/living/target
	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/G

/datum/ai_behavior/carbon_shooting/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	target = controller.blackboard[shoot_target_key]
	carbon_pawn = controller.pawn
	G = carbon_pawn.held_items[gun_hand]

	carbon_pawn.swap_hand(gun_hand)

	if(!target || target.stat >= required_stat)
		finish_action(controller, FALSE)
		return
	if(!G)
		finish_action(controller, FALSE)
		return
	if(!G.can_shoot())
		if(istype(G, /obj/item/gun/ballistic))
			var/obj/item/gun/ballistic/B = G
			if(B.bolt_locked)
				B.attack_self(carbon_pawn)
				if(!G.can_shoot())
					finish_action(controller, FALSE)
					return
		else
			finish_action(controller, FALSE)
			return

	if(G.chambered && G.chambered.harmful == FALSE && target.getStaminaLoss() > 100)
		finish_action(controller, FALSE)
		return

	if(G.weapon_weight == WEAPON_HEAVY)
		carbon_pawn.dropItemToGround(carbon_pawn.get_inactive_held_item())

	execute_a_little_bit_of_trolling(carbon_pawn, target, G)
	if(double_shot && istype(G, /obj/item/gun/ballistic/automatic))
		spawn(1)
			execute_a_little_bit_of_trolling(carbon_pawn, target, G)

	finish_action(controller, TRUE)

/datum/ai_behavior/carbon_shooting/proc/execute_a_little_bit_of_trolling(mob/living/shooter, mob/living/target, obj/item/gun/G)
	if(!target|| QDELETED(target) || target.stat >= required_stat)
		return
	if(!G || QDELETED(G) || !G.can_shoot())
		return
	shooter.face_atom(target)
	G.afterattack(target, shooter)

	if(istype(G, /obj/item/gun/ballistic/rifle))
		spawn(1)
			G.attack_self(shooter)

/datum/ai_behavior/carbon_shooting/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.blackboard[shoot_target_key] = null

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_cqc

/datum/ai_behavior/carbon_cqc/perform(delta_time, datum/ai_controller/controller)
	. = ..()

/datum/ai_behavior/carbon_cqc/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
