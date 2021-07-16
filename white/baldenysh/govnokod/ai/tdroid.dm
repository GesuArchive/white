//опять анеме порево щитпостинг приколы на полтора человека

#define TDROID_MODES 					list("offensive", "defensive", "passive")
#define TDROID_SIMPLE_AGRESSION_SIGNALS list(\
						COMSIG_ATOM_ATTACK_HAND,\
						COMSIG_ATOM_ATTACK_PAW,\
						COMSIG_LIVING_TRY_SYRINGE,\
						COMSIG_ATOM_HULK_ATTACK,\
						COMSIG_CARBON_CUFF_ATTEMPTED\
						)

#define BB_TDROID 							""
#define BB_TDROID_COMMANDER					"BB_tdroid_commander"
#define BB_TDROID_DIRECT_ORDER_MODE			"BB_tdroid_direct_order"
#define BB_TDROID_SQUAD_MEMBERS				"BB_tdroid_squad_members_list"
#define BB_TDROID_CURRENT_WEAPONS			"BB_tdroid_weapons_list"
#define BB_TDROID_ENEMIES			 		"BB_tdroid_enemies_list"
#define BB_TDROID_ATTACK_TARGET 			"BB_tdroid_attack_target"
#define BB_TDROID_FOLLOW_TARGET 			"BB_tdroid_follow_target"

/datum/ai_controller/tdroid
	movement_delay = 0.4 SECONDS
	//ai_movement = /datum/ai_movement/jps
	ai_movement = /datum/ai_movement/basic_avoidance
	blackboard = list(\
						BB_TDROID_COMMANDER 				= null,\
						BB_TDROID_DIRECT_ORDER_MODE 		= FALSE,\
						BB_TDROID_SQUAD_MEMBERS 			= list(),\
						BB_TDROID_CURRENT_WEAPONS 			= list("ranged" = null, "melee" = null),\
						BB_TDROID_ENEMIES 					= list(),\
						BB_TDROID_ATTACK_TARGET 			= null,\
						BB_TDROID_FOLLOW_TARGET				= null\
	)

/datum/ai_controller/tdroid/TryPossessPawn(atom/new_pawn)
	if(!ishuman(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOVABLE_MOVED, .proc/on_moved)

	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, .proc/on_startpulling)
	RegisterSignal(new_pawn, TDROID_SIMPLE_AGRESSION_SIGNALS, .proc/on_simple_agression)

	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, .proc/update_movespeed)

	movement_delay = living_pawn.cached_multiplicative_slowdown

	return ..()

/datum/ai_controller/tdroid/UnpossessPawn(destroy)
	UnregisterCommander()
	UnregisterSignal(pawn, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(pawn, list(\
								COMSIG_PARENT_ATTACKBY,\
								COMSIG_ATOM_BULLET_ACT,\
								COMSIG_ATOM_HITBY,\
								COMSIG_LIVING_START_PULL\
	))
	UnregisterSignal(pawn, TDROID_SIMPLE_AGRESSION_SIGNALS)

	RegisterSignal(pawn, COMSIG_MOB_MOVESPEED_UPDATED)

	return ..()

//////////////////////////////////////////////////проки

/datum/ai_controller/tdroid/proc/RegisterCommander(mob/living/commander)
	if(!commander)
		return
	blackboard[BB_TDROID_COMMANDER] = commander
	RegisterSignal(commander, COMSIG_MOB_POINTED, .proc/on_commander_pointed)
	RegisterSignal(commander, COMSIG_MOVABLE_MOVED, .proc/on_commander_moved)

	RegisterSignal(commander, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(commander, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(commander, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(commander, COMSIG_LIVING_START_PULL, .proc/on_startpulling)
	RegisterSignal(commander, TDROID_SIMPLE_AGRESSION_SIGNALS, .proc/on_simple_agression)

/datum/ai_controller/tdroid/proc/UnregisterCommander()
	var/mob/living/commander = blackboard[BB_TDROID_COMMANDER]
	if(!commander)
		return
	UnregisterSignal(commander, list(\
								COMSIG_MOB_POINTED,\
								COMSIG_MOVABLE_MOVED\
	))

	UnregisterSignal(commander, list(\
								COMSIG_PARENT_ATTACKBY,\
								COMSIG_ATOM_BULLET_ACT,\
								COMSIG_ATOM_HITBY,\
								COMSIG_LIVING_START_PULL\
	))
	UnregisterSignal(commander, TDROID_SIMPLE_AGRESSION_SIGNALS)

/////////////////////////////////отряды

/*
/datum/ai_controller/tdroid/proc/JoinSquad(list/squad)
	blackboard[BB_TDROID_SQUAD_MEMBERS] = squad

/datum/ai_controller/tdroid/proc/LeaveSquad()
	blackboard[BB_TDROID_SQUAD_MEMBERS] = null

/datum/ai_controller/tdroid/proc/AddToSquad(datum/ai_controller/tdroid/AI)
	blackboard[BB_TDROID_SQUAD_MEMBERS].Add(AI)

/datum/ai_controller/tdroid/proc/RemoveFromSquad(datum/ai_controller/tdroid/AI)
	blackboard[BB_TDROID_SQUAD_MEMBERS].Remove(AI)


/datum/ai_controller/tdroid/proc/GetNearestSquadMember()
	for(var/datum/ai_controller/AI in blackboard[BB_TDROID_SQUAD_MEMBERS])
		if(!AI.pawn)
			continue

*/
/datum/ai_controller/tdroid/proc/GenSquad(range = 5)
	var/list/cur_members = blackboard[BB_TDROID_SQUAD_MEMBERS]
	if(cur_members && cur_members.len)
		return
	var/list/new_squad_members = list()
	for(var/mob/living/L in range(range, pawn))
		if(L.ai_controller && istype(L.ai_controller, type))
			if(L.ai_controller.blackboard[BB_TDROID_COMMANDER] == blackboard[BB_TDROID_COMMANDER])
				new_squad_members.Add(L.ai_controller)

	for(var/datum/ai_controller/tdroid/T in new_squad_members)
		T.blackboard[BB_TDROID_SQUAD_MEMBERS] = new_squad_members
	return new_squad_members


/////////////////////////////////чеки

/datum/ai_controller/tdroid/proc/IsSquadMember(mob/M)
	for(var/datum/ai_controller/AI in blackboard[BB_TDROID_SQUAD_MEMBERS])
		if(AI?.pawn == M)
			return TRUE
	return FALSE

/datum/ai_controller/tdroid/proc/IsCommander(atom/A)
	var/mob/living/commander = blackboard[BB_TDROID_COMMANDER]
	if(commander && A == commander)
		return TRUE
	return FALSE

/datum/ai_controller/tdroid/proc/CanSeeAtom(atom/A)
	if(A && (pawn in viewers(13, A)))
		return TRUE
	return FALSE

/datum/ai_controller/tdroid/proc/CanSeeCommander()
	return CanSeeAtom(blackboard[BB_TDROID_COMMANDER])

/datum/ai_controller/tdroid/proc/CanMove()
	var/mob/living/living_pawn = pawn
	return !(HAS_TRAIT(living_pawn, TRAIT_INCAPACITATED) || IS_IN_STASIS(living_pawn) || living_pawn.stat > 1)

/datum/ai_controller/tdroid/proc/CanInteract()
	var/mob/living/living_pawn = pawn
	return !(!CanMove() || HAS_TRAIT(living_pawn, TRAIT_HANDS_BLOCKED) || living_pawn.stat)

/////////////////////////////////хз

/datum/ai_controller/tdroid/proc/TryArmWeapon(type)

/datum/ai_controller/tdroid/proc/ArmWeapon(type)

/datum/ai_controller/tdroid/proc/TryFindWeapon(type)

/datum/ai_controller/tdroid/proc/InitiateReset()
	var/mob/living/living_pawn = pawn
	blackboard[BB_TDROID_ENEMIES] = list()
	blackboard[BB_TDROID_FOLLOW_TARGET] = null
	living_pawn.Paralyze(1)

/datum/ai_controller/tdroid/proc/StateOrder(order)
	var/mob/living/living_pawn = pawn
	if(isnum(order))
		if(order != 0)
			order = "[order]"
		else
			order = "java.lang.NullPointerException at com.tacticalcore.order.ExecuteOrder.main(ExecuteOrder.java:419)"
	living_pawn.say("Директива [order]")

/datum/ai_controller/tdroid/proc/AgressionReact(mob/agressor, severity = 25)
	if(IsCommander(agressor) || IsSquadMember(agressor))
		return
	var/list/enemies = blackboard[BB_TDROID_ENEMIES]
	enemies[agressor] += severity

/datum/ai_controller/tdroid/proc/FriendlyPullReact(mob/puller)
	return

//////////////////////////////////////////////////сигналы

/datum/ai_controller/tdroid/proc/on_commander_pointed(datum/source, atom/A)
	var/mob/living/commander = source
	var/mob/living/living_pawn = pawn
	if(!CanSeeCommander())
		return

	if(!blackboard[BB_TDROID_DIRECT_ORDER_MODE])
		if(A == commander)
			switch(commander.a_intent)
				if(INTENT_DISARM)
					InitiateReset()
					GenSquad()
					StateOrder(9)

		else if(A == pawn)
			switch(commander.a_intent)
				if(INTENT_DISARM)
					InitiateReset()
					StateOrder(9)

				if(INTENT_GRAB)
					blackboard[BB_TDROID_DIRECT_ORDER_MODE] = TRUE
					commander.examine(living_pawn)

		else if(isliving(A))
			var/mob/living/L = A
			if(IsSquadMember(L))
				return
			switch(commander.a_intent)
			//	if(INTENT_DISARM)
			//		AgressionReact(L, 30)
			//		StateOrder(28)
				if(INTENT_HARM)
					AgressionReact(L, 60)
					StateOrder(56)
		return

	if(!blackboard[BB_TDROID_DIRECT_ORDER_MODE])
		return
	blackboard[BB_TDROID_DIRECT_ORDER_MODE] = FALSE

	switch(commander.a_intent)
		if(INTENT_HELP)

		if(INTENT_GRAB)
			if(IsCommander(A))
				blackboard[BB_TDROID_FOLLOW_TARGET] = null
				StateOrder(72)
				return
			if(IsSquadMember(A))
				blackboard[BB_TDROID_FOLLOW_TARGET] = A
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/pull/tdroid)
				StateOrder(2)
				return
			blackboard[BB_TDROID_FOLLOW_TARGET] = A
			StateOrder(73)
			return

	StateOrder(0)


/datum/ai_controller/tdroid/proc/on_commander_moved(datum/source, atom/A)
	SIGNAL_HANDLER

/datum/ai_controller/tdroid/proc/on_moved(datum/source, atom/A)
	SIGNAL_HANDLER



/////////////////////////////////сигналы реакции

/datum/ai_controller/tdroid/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force)
		AgressionReact(user, I.force*2)

/datum/ai_controller/tdroid/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj, /obj/projectile/beam)||istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				AgressionReact(Proj.firer, Proj.damage*3)

/datum/ai_controller/tdroid/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		if(I.throwforce < living_pawn.health && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			AgressionReact(H, I.throwforce*2)

/datum/ai_controller/tdroid/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!isliving(living_pawn.pulledby))
		return TRUE
	var/mob/living/living_puller = living_pawn.pulledby
	if(IsCommander(living_puller) || IsSquadMember(living_puller))
		FriendlyPullReact(living_puller)
		return TRUE
	if(CanMove())
		AgressionReact(living_puller)
		return TRUE

/datum/ai_controller/tdroid/proc/on_simple_agression(datum/source, mob/agressor)
	SIGNAL_HANDLER
	AgressionReact(agressor)

/datum/ai_controller/tdroid/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown

//////////////////////////////////////////////////ИИ фегня

/datum/ai_controller/tdroid/able_to_run()
	if(!CanMove())
		return FALSE
	return ..()

/datum/ai_controller/tdroid/SelectBehaviors(delta_time)
	current_behaviors = list()
	var/mob/living/living_pawn = pawn

	if(SHOULD_RESIST(living_pawn) && DT_PROB(50, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/resist)
		return

	if(!blackboard[BB_TDROID_FOLLOW_TARGET])
		blackboard[BB_TDROID_FOLLOW_TARGET] = blackboard[BB_TDROID_COMMANDER]

	if(CanSeeAtom(blackboard[BB_TDROID_FOLLOW_TARGET]))
		current_movement_target = blackboard[BB_TDROID_FOLLOW_TARGET]
	else
		current_movement_target = null

	if(!living_pawn.pulling || !living_pawn.pulledby)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/move_to_target/tdroid)




	if(HAS_TRAIT(pawn, TRAIT_PACIFISM))
		return

	//var/list/enemies = blackboard[BB_COMBAT_AI_ENEMIES]
	/*
	if(enemies && enemies.len)
		var/list/mob/living/alive_enemies = list()
		for(var/mob/living/L in enemies)
			if(!L.stat)
				alive_enemies.Add(L)

		var/mob/living/selected_enemy = pickweight(alive_enemies & view(9, living_pawn))

		if(selected_enemy)
			if()
			/*
			if(living_pawn.health < 30)
				blackboard[BB_TDROID_ATTACK_TARGET] = selected_enemy
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_flee)
			*/

			blackboard[BB_TDROID_ATTACK_TARGET] = selected_enemy
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_try_kill)
	*/

///datum/ai_controller/tdroid/PerformIdleBehavior(delta_time)
//	return

//////////////////////////////////////////////////поведения

/datum/ai_behavior/move_to_target/tdroid
	required_distance = 2

/datum/ai_behavior/pull/tdroid
	pull_target_key = BB_TDROID_FOLLOW_TARGET

/////////////////////////////////грифонинг

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

//////////////////////////////////////////////////амонгас
/mob/living/carbon/human/tdroid_debug
	ai_controller = /datum/ai_controller/tdroid

/mob/living/carbon/human/tdroid_debug/Initialize()
	. = ..()
	var/datum/ai_controller/tdroid/CTRL = ai_controller
	for(var/mob/living/L in range(1))
		if(L.client)
			CTRL.RegisterCommander(L)
			return

