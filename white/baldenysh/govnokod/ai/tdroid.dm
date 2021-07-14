//опять анеме порево щитпостинг приколы на полтора человека

#define TDROID_MODES 					list("offensive", "defensive", "passive")
#define TDROID_SIMPLE_AGRESSION_SIGNALS list(
						COMSIG_ATOM_ATTACK_HAND,
						COMSIG_ATOM_ATTACK_PAW,
						COMSIG_LIVING_TRY_SYRINGE,
						COMSIG_ATOM_HULK_ATTACK,
						COMSIG_CARBON_CUFF_ATTEMPTED
						)

#define BB_TDROID 						""
#define BB_TDROID_COMMANDER				"BB_tdroid_commander"
#define BB_TDROID_COMMANDER_LAST_POS	"BB_tdroid_commander_last_pos"
#define BB_TDROID_SQUAD_MEMBERS			"BB_tdroid_squad_ai_list"
#define BB_TDROID_CURRENT_WEAPONS		"BB_tdroid_weapons_list"
#define BB_TDROID_MODE 					"BB_tdroid_mode"
#define BB_TDROID_ENEMIES			 	"BB_tdroid_enemies_list"
#define BB_TDROID_CURRENT_TARGET 		"BB_tdroid_target"


/datum/ai_controller/tdroid
	blackboard = list(
						BB_TDROID_COMMANDER 			= null,
						BB_TDROID_COMMANDER_LAST_POS 	= null,
						BB_TDROID_SQUAD_MEMBERS 		= list(),
						BB_TDROID_CURRENT_WEAPONS 		= list("ranged" = null, "melee" = null),
						BB_TDROID_MODE 					= "defensive",
						BB_TDROID_ENEMIES 				= list(),
						BB_TDROID_CURRENT_TARGET 		= null
	)

/datum/ai_controller/tdroid/TryPossessPawn(atom/new_pawn)
	if(!ishuman(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, .proc/on_hitby)
	RegisterSignal(new_pawn, COMSIG_MOVABLE_CROSSED, .proc/on_Crossed)
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, .proc/on_startpulling)

	RegisterSignal(new_pawn, TDROID_SIMPLE_AGRESSION_SIGNALS, .proc/on_simple_agression)

	return ..()

/datum/ai_controller/tdroid/UnpossessPawn(destroy)
	UnregisterCommander()
	UnregisterSignal(pawn, list(
								COMSIG_PARENT_ATTACKBY,
								COMSIG_ATOM_BULLET_ACT,
								COMSIG_ATOM_HITBY,
								COMSIG_MOVABLE_CROSSED,
								COMSIG_LIVING_START_PULL
	))
	UnregisterSignal(pawn, TDROID_SIMPLE_AGRESSION_SIGNALS)

	return ..()

//////////////////////////////////////////////////проки

/datum/ai_controller/tdroid/proc/RegisterCommander(mob/living/commander)
	if(!commander)
		return
	blackboard[BB_TDROID_COMMANDER] = commander
	RegisterSignal(commander, COMSIG_MOB_POINTED, .proc/on_commander_pointed)
	RegisterSignal(commander, COMSIG_MOVABLE_MOVED, .proc/on_commander_moved)

/datum/ai_controller/tdroid/proc/UnregisterCommander()
	var/mob/living/commander = blackboard[BB_TDROID_COMMANDER]
	if(!commander)
		return
	UnregisterSignal(commander, list(
								COMSIG_MOB_POINTED,
								COMSIG_MOVABLE_MOVED
	))

/datum/ai_controller/tdroid/proc/JoinSquad(list/squad) // потом небось фиксить придеца непомню как ссылки все ети работают
	blackboard[BB_TDROID_SQUAD_MEMBERS] = squad

/datum/ai_controller/tdroid/proc/LeaveSquad()
	blackboard[BB_TDROID_SQUAD_MEMBERS] = list()

/datum/ai_controller/tdroid/proc/AddToSquad(datum/ai_controller/tdroid/AI)
	blackboard[BB_TDROID_SQUAD_MEMBERS].Add(AI)

/datum/ai_controller/tdroid/proc/RemoveFromSquad(datum/ai_controller/tdroid/AI)
	blackboard[BB_TDROID_SQUAD_MEMBERS].Remove(AI)

/*
/datum/ai_controller/tdroid/proc/GetNearestSquadMember()
	for(var/datum/ai_controller/AI in blackboard[BB_TDROID_SQUAD_MEMBERS])
		if(!AI.pawn)
			continue



/datum/ai_controller/tdroid/proc/ChooseTarget()
*/
/datum/ai_controller/tdroid/proc/TryArmWeapon(type)

/datum/ai_controller/tdroid/proc/ArmWeapon(type)

/datum/ai_controller/tdroid/proc/TryFindWeapon(type)

/datum/ai_controller/tdroid/proc/TryPickUpItem(obj/item)

/datum/ai_controller/tdroid/proc/TryStore(obj/item)

/datum/ai_controller/tdroid/proc/MoveTo(turf/new_loc)

/datum/ai_controller/tdroid/proc/IsCommanderOrSquadMember(mob/M)
	if(M == commander)
		return TRUE
	for(var/datum/ai_controller/AI in blackboard[BB_TDROID_SQUAD_MEMBERS])
		if(AI?.pawn == M)
			return TRUE
	return FALSE

/datum/ai_controller/tdroid/proc/AgressionReact(mob/agressor, severity = 25)
	if(IsCommanderOrSquadMember(agressor))
		return
	var/list/enemies = blackboard[BB_TDROID_ENEMIES]
	enemies[agressor] += severity

/datum/ai_controller/tdroid/proc/FriendlyPullReact(mob/puller)
	return

//////////////////////////////////////////////////сигналы

/datum/ai_controller/tdroid/proc/on_commander_pointed(datum/source, atom/A)
	SIGNAL_HANDLER
	var/mob/living/commander = source
	if(!(src in viewers(Center=commander)))
		return
	if(isliving(A))
		var/mob/living/L = A
		switch(commander.a_intent)
			if(INTENT_HELP)
			if(INTENT_DISARM)
			if(INTENT_GRAB)
			if(INTENT_HARM)
				AgressionReact(L, 100)
	else if(isitem(A))
		switch(commander.a_intent)
			if(INTENT_HELP)
			if(INTENT_DISARM)
			if(INTENT_GRAB)
			if(INTENT_HARM)
	else if(isobj(A))
		switch(commander.a_intent)
			if(INTENT_HELP)
			if(INTENT_DISARM)
			if(INTENT_GRAB)
			if(INTENT_HARM)
	else if(isturf(A))
		switch(commander.a_intent)
			if(INTENT_HELP)
			if(INTENT_DISARM)
			if(INTENT_GRAB)
			if(INTENT_HARM)

/datum/ai_controller/tdroid/proc/on_commander_moved(datum/source, atom/A)
	SIGNAL_HANDLER

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

/datum/ai_controller/tdroid/proc/on_Crossed(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return TRUE
	var/mob/living/L = AM
	if(IsCommanderOrSquadMember(L))
		return TRUE
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn))
		L.knockOver(living_pawn)
		return

/datum/ai_controller/tdroid/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!isliving(living_pawn.pulledby))
		return TRUE
	var/mob/living/living_puller = living_pawn.pulledby
	if(IsCommanderOrSquadMember(living_puller))
		FriendlyPullReact(living_puller)
		return TRUE
	if(!IS_DEAD_OR_INCAP(living_pawn))
		AgressionReact(living_puller)
		return TRUE

/datum/ai_controller/tdroid/proc/on_simple_agression(datum/source, mob/agressor)
	SIGNAL_HANDLER
	AgressionReact(agressor)

//////////////////////////////////////////////////ИИ фегня

/datum/ai_controller/tdroid/SelectBehaviors(delta_time)

/datum/ai_controller/tdroid/PerformIdleBehavior(delta_time)

/datum/ai_controller/tdroid/able_to_run()
	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		return FALSE
	return ..()
