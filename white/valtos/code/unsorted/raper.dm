/datum/ai_controller/raper
	blackboard = list(BB_RAPER_AGRESSIVE = FALSE,\
					  BB_RAPER_ENEMIES = list(),\
					  BB_RAPER_CURRENT_ATTACK_TARGET = null,\
					  BB_RAPER_CURRENT_ATTACK_TARGET)

/datum/ai_controller/raper/TryPossessPawn(atom/new_pawn)
	if(!isliving(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_PAW, .proc/on_attack_paw)
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSSED, .proc/on_Crossed)
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, .proc/on_startpulling)
	RegisterSignal(new_pawn, COMSIG_LIVING_TRY_SYRINGE, .proc/on_try_syringe)
	RegisterSignal(new_pawn, COMSIG_ATOM_HULK_ATTACK, .proc/on_attack_hulk)
	RegisterSignal(new_pawn, COMSIG_CARBON_CUFF_ATTEMPTED, .proc/on_attempt_cuff)
	blackboard[BB_RAPER_AGRESSIVE] = TRUE //Angry cunt
	return ..() //Run parent at end

/datum/ai_controller/raper/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_MOVABLE_CROSSED, COMSIG_LIVING_START_PULL,\
	COMSIG_LIVING_TRY_SYRINGE, COMSIG_ATOM_HULK_ATTACK, COMSIG_CARBON_CUFF_ATTEMPTED))
	return ..() //Run parent at end

/datum/ai_controller/raper/able_to_run()
	var/mob/living/living_pawn = pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return FALSE
	return ..()

/datum/ai_controller/raper/SelectBehaviors(delta_time)
	current_behaviors = list()
	var/mob/living/living_pawn = pawn

	if(SHOULD_RESIST(living_pawn) && DT_PROB(MONKEY_RESIST_PROB, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/resist) //BRO IM ON FUCKING FIRE BRO
		return //IM NOT DOING ANYTHING ELSE BUT EXTUINGISH MYSELF, GOOD GOD HAVE MERCY.

	var/list/enemies = blackboard[BB_RAPER_ENEMIES]

	if(HAS_TRAIT(pawn, TRAIT_PACIFISM)) //Not a pacifist? lets try some combat behavior.
		return

	if(length(enemies) || blackboard[BB_RAPER_AGRESSIVE]) //We have enemies or are pissed

		var/mob/living/selected_enemy

		for(var/mob/living/possible_enemy in view(MONKEY_ENEMY_VISION, living_pawn))
			if(possible_enemy == living_pawn || (!enemies[possible_enemy] && (!blackboard[BB_RAPER_AGRESSIVE] || HAS_AI_CONTROLLER_TYPE(possible_enemy, /datum/ai_controller/raper)))) //Are they an enemy? (And do we even care?)
				continue

			selected_enemy = possible_enemy
			break
		if(selected_enemy)
			if(!selected_enemy.stat && !(HAS_TRAIT(selected_enemy, TRAIT_IMMOBILIZED)) && !(HAS_TRAIT(selected_enemy, TRAIT_FLOORED)) && !(HAS_TRAIT(selected_enemy, TRAIT_HANDS_BLOCKED))) //He's up, get him!
				blackboard[BB_RAPER_CURRENT_ATTACK_TARGET] = selected_enemy
				current_movement_target = selected_enemy
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/battle_screech/raper)
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/battle_shout/raper)
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/raper_attack_mob)
				return //Focus on this
			else //He's down, can we fuck him?
				blackboard[BB_RAPER_CURRENT_ATTACK_TARGET] = selected_enemy
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/fuck_mob)
				return

//When idle just kinda fuck around.
/datum/ai_controller/raper/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn

	if(DT_PROB(25, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		step(living_pawn, pick(GLOB.cardinals))
	else if(DT_PROB(5, delta_time))
		INVOKE_ASYNC(living_pawn, /mob.proc/emote, pick("moan"))
	else if(DT_PROB(1, delta_time))
		INVOKE_ASYNC(living_pawn, /mob.proc/emote, pick("moan","spin","flip"))

///Reactive events to being hit
/datum/ai_controller/raper/proc/retaliate(mob/living/L)
	var/list/enemies = blackboard[BB_RAPER_ENEMIES]
	enemies[L] += MONKEY_HATRED_AMOUNT

/datum/ai_controller/raper/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force && I.damtype != STAMINA)
		retaliate(user)

/datum/ai_controller/raper/proc/on_attack_hand(datum/source, mob/living/L)
	SIGNAL_HANDLER
	if(L.a_intent == INTENT_GRAB && prob(MONKEY_RETALIATE_HARM_PROB))
		retaliate(L)
	else if(L.a_intent == INTENT_DISARM && prob(MONKEY_RETALIATE_DISARM_PROB))
		retaliate(L)

/datum/ai_controller/raper/proc/on_attack_paw(datum/source, mob/living/L)
	SIGNAL_HANDLER
	if(L.a_intent == INTENT_HARM && prob(MONKEY_RETALIATE_HARM_PROB))
		retaliate(L)
	else if(L.a_intent == INTENT_DISARM && prob(MONKEY_RETALIATE_DISARM_PROB))
		retaliate(L)

/datum/ai_controller/raper/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj , /obj/projectile/beam)||istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				retaliate(Proj.firer)

/datum/ai_controller/raper/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		if(I.throwforce < living_pawn.health && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)

/datum/ai_controller/raper/proc/on_Crossed(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && ismob(AM))
		var/mob/living/in_the_way_mob = AM
		in_the_way_mob.knockOver(living_pawn)
		return

/datum/ai_controller/raper/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && prob(MONKEY_PULL_AGGRO_PROB)) // nuh uh you don't pull me!
		retaliate(living_pawn.pulledby)
		return TRUE

/datum/ai_controller/raper/proc/on_try_syringe(datum/source, mob/user)
	SIGNAL_HANDLER
	// chance of monkey retaliation
	if(prob(MONKEY_SYRINGE_RETALIATION_PROB))
		retaliate(user)

/datum/ai_controller/raper/proc/on_attack_hulk(datum/source, mob/user)
	SIGNAL_HANDLER
	retaliate(user)

/datum/ai_controller/raper/proc/on_attempt_cuff(datum/source, mob/user)
	SIGNAL_HANDLER
	// chance of monkey retaliation
	if(prob(MONKEY_CUFF_RETALIATION_PROB))
		retaliate(user)

/datum/ai_behavior/battle_screech/raper
	screeches = list("scream", "moan")

/datum/ai_behavior/battle_shout/raper
	shouts = list("СЕЙЧАС ТЕБЕ БУДЕТ ПРИЯТНО!!!", "ИДИ СЮДА, СЛАДЕНЬКИЙ!!!", "ОХ-ОХ-ОХ, Я СЕЙЧАС ОБКОНЧАЮСЬ!!!", "ТЕБЕ ЭТО ОБЯЗАТЕЛЬНО ПОНРАВИТСЯ!!!")

/datum/ai_behavior/raper_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM //performs to increase frustration

/datum/ai_behavior/raper_attack_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat != CONSCIOUS || HAS_TRAIT(target, TRAIT_IMMOBILIZED) || HAS_TRAIT(target, TRAIT_FLOORED) || HAS_TRAIT(target, TRAIT_HANDS_BLOCKED))
		finish_action(controller, TRUE) //Target == owned

	if(living_pawn.Adjacent(target) && isturf(target.loc) && !IS_DEAD_OR_INCAP(living_pawn))	// if right next to perp
		// check if target has a weapon
		var/obj/item/W
		for(var/obj/item/I in target.held_items)
			if(!(I.item_flags & ABSTRACT))
				W = I
				break

		// if the target has a weapon, chance to disarm them
		if(W && DT_PROB(MONKEY_ATTACK_DISARM_PROB, delta_time))
			living_pawn.a_intent = INTENT_DISARM
			raper_attack(controller, target, delta_time)
		else
			living_pawn.a_intent = INTENT_GRAB
			raper_attack(controller, target, delta_time)


/datum/ai_behavior/raper_attack_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET] = null

/// attack using a held weapon otherwise bite the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/raper_attack_mob/proc/raper_attack(datum/ai_controller/controller, mob/living/target, delta_time)

	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	living_pawn.changeNext_move(CLICK_CD_MELEE) //We play fair

	var/obj/item/weapon = living_pawn.held_items.len ? pick(living_pawn.held_items) : null

	living_pawn.face_atom(target)

	living_pawn.a_intent = INTENT_GRAB
	target.grabbedby(living_pawn)
	target.grippedby(living_pawn)

	// attack with weapon if we have one
	if(weapon)
		weapon.melee_attack_chain(living_pawn, target)
	else
		target.attack_hand(living_pawn)

	// no de-aggro
	if(controller.blackboard[BB_RAPER_AGRESSIVE])
		return

	if(DT_PROB(MONKEY_HATRED_REDUCTION_PROB, delta_time))
		controller.blackboard[BB_RAPER_ENEMIES][target]--

	// if we are not angry at our target, go back to idle
	if(controller.blackboard[BB_RAPER_ENEMIES][target] <= 0)
		var/list/enemies = controller.blackboard[BB_RAPER_ENEMIES]
		enemies.Remove(target)
		if(controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET] == target)
			finish_action(controller, TRUE)

/datum/ai_behavior/fuck_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM //performs to increase frustration

/datum/ai_behavior/fuck_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn
	if(!controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET])
		controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET] = null
		controller.blackboard[BB_RAPER_FUCKING] = FALSE
	else if (living_pawn.Adjacent(target))
		living_pawn.do_sex(target, pick("do_throatfuck", "do_anal"))
		INVOKE_ASYNC(src, .proc/try_fuck_mob, controller) //put him in!
	else
		living_pawn.forceMove(get_turf(target))
		living_pawn.do_sex(target, pick("do_throatfuck", "do_anal"))
		controller.current_movement_target = target

/datum/ai_behavior/fuck_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	if(controller.blackboard[BB_RAPER_FUCKING])
		return

	var/mob/living/target = controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	controller.current_movement_target = target

	if(target.pulledby != living_pawn && !HAS_AI_CONTROLLER_TYPE(target.pulledby, /datum/ai_controller/raper)) //Dont steal from my fellow monkeys.
		if(living_pawn.Adjacent(target) && isturf(target.loc))
			living_pawn.a_intent = INTENT_GRAB
			target.grabbedby(living_pawn)
			target.grippedby(living_pawn)
		return //Do the rest next turn

	controller.current_movement_target = target

	if(living_pawn.Adjacent(target))
		living_pawn.forceMove(get_turf(target))
		INVOKE_ASYNC(src, .proc/try_fuck_mob, controller) //put him in!
	else //This means we might be getting pissed!
		return

/datum/ai_behavior/fuck_mob/proc/try_fuck_mob(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_RAPER_CURRENT_ATTACK_TARGET]

	controller.blackboard[BB_RAPER_FUCKING] = TRUE

	if(target)
		for(var/obj/item/W in target)
			if(istype(W, /obj/item/restraints))
				continue
			target.dropItemToGround(W)
		living_pawn.do_sex(target, pick("do_throatfuck", "do_anal"))
	finish_action(controller, TRUE)

/mob/living/carbon/human/rapist
	ai_controller = /datum/ai_controller/raper

/mob/living/carbon/human/rapist/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_STUNIMMUNE, "sosi")
	ADD_TRAIT(src, TRAIT_STRONG_GRABBER, "sosi")
