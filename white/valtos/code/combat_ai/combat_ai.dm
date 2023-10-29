/datum/ai_controller/combat_ai
	blackboard = list(
		BB_COMBAT_AI_ANGRY_GAY = TRUE,
		BB_COMBAT_AI_ENEMIES = list(),
		BB_COMBAT_AI_CURRENT_TARGET = null,
		BB_COMBAT_AI_WEAPON_TARGET = null,
		BB_COMBAT_AI_WEAPON_BL = list(),
		BB_COMBAT_AI_WOUNDED = FALSE,
		BB_COMBAT_AI_STUPIDITY = 0,
		BB_COMBAT_AI_SUICIDE_BOMBER = FALSE
	)
	movement_delay = 0.5 SECONDS

/datum/ai_controller/combat_ai/TryPossessPawn(atom/new_pawn)
	if(!ishuman(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_PAW, PROC_REF(on_attack_paw))
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, PROC_REF(on_startpulling))
	RegisterSignal(new_pawn, COMSIG_LIVING_TRY_SYRINGE, PROC_REF(on_try_syringe))
	RegisterSignal(new_pawn, COMSIG_ATOM_HULK_ATTACK, PROC_REF(on_attack_hulk))
	RegisterSignal(new_pawn, COMSIG_CARBON_CUFF_ATTEMPTED, PROC_REF(on_attempt_cuff))
	return ..() //Run parent at end

/datum/ai_controller/combat_ai/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_LIVING_START_PULL,\
	COMSIG_LIVING_TRY_SYRINGE, COMSIG_ATOM_HULK_ATTACK, COMSIG_CARBON_CUFF_ATTEMPTED))
	return ..() //Run parent at end

/datum/ai_controller/combat_ai/able_to_run()
	var/mob/living/living_pawn = pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return FALSE
	return ..()

/datum/ai_controller/combat_ai/SelectBehaviors(delta_time)
	current_behaviors = list()
	var/mob/living/living_pawn = pawn

	if(SHOULD_RESIST(living_pawn) && DT_PROB(80, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/resist)
		return

	var/list/enemies = blackboard[BB_COMBAT_AI_ENEMIES]

	if(HAS_TRAIT(pawn, TRAIT_PACIFISM))
		return

	if(living_pawn.stat != CONSCIOUS)
		living_pawn.SetSleeping(60 SECONDS)
		return

	if(length(enemies) || blackboard[BB_COMBAT_AI_ANGRY_GAY])

		var/mob/living/selected_enemy

		for(var/mob/living/possible_enemy in view(9, living_pawn))
			if(possible_enemy == living_pawn || (!blackboard[BB_COMBAT_AI_ANGRY_GAY] || HAS_AI_CONTROLLER_TYPE(possible_enemy, /datum/ai_controller/combat_ai)))
				continue

			selected_enemy = possible_enemy
			break
		if(selected_enemy)
			if(!selected_enemy.stat)
				if(living_pawn.health < 15)
					blackboard[BB_COMBAT_AI_CURRENT_TARGET] = selected_enemy
					current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_flee)
					return

				blackboard[BB_COMBAT_AI_CURRENT_TARGET] = selected_enemy
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_try_kill)
				return
			else
				blackboard[BB_COMBAT_AI_CURRENT_TARGET] = null
				return

/datum/ai_controller/combat_ai/proc/TryFindWeapon()
	var/mob/living/living_pawn = pawn

	if(locate(/obj/item/gun/ballistic) in living_pawn.held_items)
		return TRUE

	var/obj/item/gun/ballistic/W = locate(/obj/item/gun/ballistic) in living_pawn.contents

	if(locate(/obj/item/gun/ballistic) in living_pawn.contents)
		living_pawn.swap_hand(RIGHT_HANDS)
		if(!living_pawn.put_in_r_hand(W))
			living_pawn.dropItemToGround(living_pawn.get_item_for_held_index(RIGHT_HANDS), force = TRUE)
			return FALSE
		return TRUE

	W = locate(/obj/item/gun/ballistic) in oview(10, living_pawn)

	if(W && W.trigger_guard == TRIGGER_GUARD_NORMAL && W.pin && W.get_ammo(TRUE) && !blackboard[BB_COMBAT_AI_WEAPON_BL][W])
		blackboard[BB_COMBAT_AI_WEAPON_TARGET] = W
		current_movement_target = W
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_equip/ground)
		return TRUE
	else
		var/mob/living/carbon/human/H = locate(/mob/living/carbon/human/) in oview(5, living_pawn)
		if(H)
			W = locate(/obj/item/gun/ballistic) in H.contents
			if(W && W.trigger_guard == TRIGGER_GUARD_NORMAL && W.pin && W.get_ammo(TRUE) && !blackboard[BB_COMBAT_AI_WEAPON_BL][W])
				blackboard[BB_COMBAT_AI_WEAPON_TARGET] = W
				current_movement_target = W
				current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/combat_ai_equip/maradeur)
				return TRUE

// поведение

/datum/ai_controller/combat_ai/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn

	if(!isturf(living_pawn.loc) || living_pawn.pulledby || length(living_pawn.buckled_mobs))
		return

	if(!TryFindWeapon() && (living_pawn.mobility_flags & MOBILITY_MOVE))
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	else if(DT_PROB(5, delta_time))
		INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/mob, emote), pick("cough", "yawn", "sigh"))

/datum/ai_controller/combat_ai/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force && I.damtype != STAMINA)
		retaliate(user)

/datum/ai_controller/combat_ai/proc/on_attack_hand(datum/source, mob/living/L)
	SIGNAL_HANDLER
	if(L.a_intent == INTENT_HARM && prob(95))
		retaliate(L)
	else if(L.a_intent == INTENT_DISARM && prob(40))
		retaliate(L)

/datum/ai_controller/combat_ai/proc/on_attack_paw(datum/source, mob/living/L)
	SIGNAL_HANDLER
	if(L.a_intent == INTENT_HARM && prob(95))
		retaliate(L)
	else if(L.a_intent == INTENT_DISARM && prob(40))
		retaliate(L)

/datum/ai_controller/combat_ai/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj, /obj/projectile/beam)||istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				retaliate(Proj.firer)

/datum/ai_controller/combat_ai/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		if(I.throwforce < living_pawn.health && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)

/datum/ai_controller/combat_ai/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && prob(25))
		retaliate(living_pawn.pulledby)
		return TRUE

/datum/ai_controller/combat_ai/proc/on_try_syringe(datum/source, mob/user)
	SIGNAL_HANDLER
	if(prob(95))
		retaliate(user)

/datum/ai_controller/combat_ai/proc/on_attack_hulk(datum/source, mob/user)
	SIGNAL_HANDLER
	retaliate(user)

/datum/ai_controller/combat_ai/proc/on_attempt_cuff(datum/source, mob/user)
	SIGNAL_HANDLER
	if(prob(95))
		retaliate(user)

/datum/ai_controller/combat_ai/proc/retaliate(mob/living/L)
	var/list/enemies = blackboard[BB_COMBAT_AI_ENEMIES]
	enemies[L] += 20

/datum/ai_behavior/combat_ai_equip
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/combat_ai_equip/finish_action(datum/ai_controller/controller, success)
	. = ..()

	if(!success)
		var/list/item_blacklist = controller.blackboard[BB_COMBAT_AI_WEAPON_BL]
		var/obj/item/target = controller.blackboard[BB_COMBAT_AI_WEAPON_TARGET]

		item_blacklist[target] = TRUE

	controller.blackboard[BB_COMBAT_AI_WEAPON_TARGET] = null

/datum/ai_behavior/combat_ai_equip/proc/equip_item(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	var/obj/item/target = controller.blackboard[BB_COMBAT_AI_WEAPON_TARGET]

	if(!target)
		finish_action(controller, FALSE)
		return

	if(target.anchored)
		finish_action(controller, FALSE)
	else
		living_pawn.put_in_r_hand(target)
		living_pawn.swap_hand(RIGHT_HANDS)
		finish_action(controller, TRUE)
	return

/datum/ai_behavior/combat_ai_equip/ground
	required_distance = 0

/datum/ai_behavior/combat_ai_equip/ground/perform(delta_time, datum/ai_controller/controller)
	equip_item(controller)

/datum/ai_behavior/combat_ai_equip/maradeur

/datum/ai_behavior/combat_ai_equip/maradeur/perform(delta_time, datum/ai_controller/controller)
	maradeur_item(controller)

/datum/ai_behavior/combat_ai_equip/maradeur/proc/maradeur_item(datum/ai_controller/controller)
	var/obj/item/gun/ballistic/target = controller.blackboard[BB_COMBAT_AI_WEAPON_TARGET]
	var/mob/living/victim = target.loc
	var/mob/living/living_pawn = controller.pawn

	var/success = FALSE
	for(var/obj/item/gun/ballistic/I in victim.contents)
		if(I == target && victim.stat != CONSCIOUS)
			if(victim.temporarilyRemoveItemFromInventory(target))
				if(!QDELETED(target) && !equip_item(controller))
					target.forceMove(living_pawn.drop_location())
					living_pawn.say("Поживимся...")
					success = TRUE
					break

	finish_action(controller, success)

/datum/ai_behavior/combat_ai_equip/maradeur/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.blackboard[BB_COMBAT_AI_WEAPON_TARGET] = null



/datum/ai_behavior/combat_ai_flee

/datum/ai_behavior/combat_ai_flee/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.health >= 30)
		finish_action(controller, TRUE)

	var/mob/living/target = null

	for(var/mob/living/L in view(living_pawn, 9))
		if(controller.blackboard[BB_COMBAT_AI_ENEMIES][L] && L.stat == CONSCIOUS)
			target = L
			break

	if(target)
		SSmove_manager.move_away(living_pawn, target, 9, 7)
	else
		finish_action(controller, TRUE)



/datum/ai_behavior/combat_ai_try_kill
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/combat_ai_try_kill/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_COMBAT_AI_CURRENT_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat != CONSCIOUS)
		finish_action(controller, TRUE)

	if(controller.blackboard[BB_COMBAT_AI_STUPIDITY] > 15) // dumb shit retard
		controller.blackboard[BB_COMBAT_AI_STUPIDITY] = 0
		living_pawn.say("НАВЕРНОЕ ВЕТЕР ГУЛЯЕТ!!!")
		finish_action(controller, TRUE)
		return

	if(!IS_DEAD_OR_INCAP(living_pawn))
		if(living_pawn.Adjacent(target) && isturf(target.loc))
			if (locate(/obj/item/gun/ballistic) in living_pawn.held_items)
				living_pawn.a_intent = INTENT_HELP
				try_attack(controller, target, delta_time)
			else
				living_pawn.a_intent = INTENT_HARM
				try_attack(controller, target, delta_time)
		else if (target in oview(9, living_pawn))
			if (locate(/obj/item/gun/ballistic) in living_pawn.held_items)
				living_pawn.a_intent = INTENT_HELP
				controller.current_movement_target = null
				try_attack(controller, target, delta_time)
			else
				controller.current_movement_target = target

/datum/ai_behavior/combat_ai_try_kill/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.blackboard[BB_COMBAT_AI_CURRENT_TARGET] = null


/datum/ai_behavior/combat_ai_try_kill/proc/try_attack(datum/ai_controller/combat_ai/controller, mob/living/target, delta_time)

	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	var/able_to_hit = TRUE

	for(var/turf/T in get_line(living_pawn, target))
		if(isclosedturf(T))
			able_to_hit = FALSE
			break
		for(var/obj/O in T)
			if(O.density)
				if(istype(O, /obj/structure/deployable_barricade) || istype(O, /obj/structure/barricade) || istype(O, /obj/structure/grille))
					continue
				able_to_hit = FALSE
				break

	if(!able_to_hit)
		controller.current_movement_target = target
		return

	controller.current_movement_target = null

	living_pawn.changeNext_move(CLICK_CD_RAPID)

	var/obj/item/gun/ballistic/weapon = locate(/obj/item/gun/ballistic) in living_pawn.held_items

	living_pawn.face_atom(target)

	if(weapon)
		if(!weapon?.chambered?.loaded_projectile)
			controller.blackboard[BB_COMBAT_AI_STUPIDITY]++
			weapon.attack_self(living_pawn)
			if(!weapon.magazine)
				try_to_reload(controller, weapon)
			else if (istype(weapon, /obj/item/gun/ballistic/shotgun) && !length(weapon.magazine.ammo_count(FALSE)))
				try_to_reload(controller, weapon, weapon.magazine)
			return
		controller.blackboard[BB_COMBAT_AI_STUPIDITY] = 0
		weapon.process_fire(target, living_pawn)
	else
		living_pawn.UnarmedAttack(target)
		controller.TryFindWeapon()

	return

/datum/ai_behavior/combat_ai_try_kill/proc/try_to_reload(datum/ai_controller/controller, obj/item/gun/ballistic/weapon, obj/item/ammo_box/magazine/internal_mag)
	var/mob/living/carbon/living_pawn = controller.pawn

	var/obj/item/reload_thing = locate(weapon.mag_type) in living_pawn?.back?.contents

	if(internal_mag && !reload_thing)
		reload_thing = locate(internal_mag.ammo_type) in living_pawn?.back?.contents
		if(!reload_thing)
			for(var/obj/item/I in living_pawn?.back)
				if(locate(internal_mag.ammo_type) in I)
					reload_thing = I
					break

	if(!reload_thing)
		living_pawn.say("Боеприпасы закончились. Перехожу в рукопашную!")
		living_pawn.dropItemToGround(living_pawn.get_item_for_held_index(LEFT_HANDS), force = TRUE)
		living_pawn.dropItemToGround(living_pawn.get_item_for_held_index(RIGHT_HANDS), force = TRUE)
		finish_action(controller, TRUE)
		return

	if(istype(reload_thing, /obj/item/ammo_box))
		var/obj/item/ammo_box/mag = reload_thing
		if(!mag.ammo_count(FALSE))
			living_pawn.say("Магазин пустой.")
			living_pawn.dropItemToGround(living_pawn.get_item_for_held_index(LEFT_HANDS), force = TRUE)
			return

	living_pawn.put_in_l_hand(reload_thing)
	living_pawn.say("Перезаряжаюсь!")
	living_pawn.swap_hand(LEFT_HANDS)
	if(internal_mag && !internal_mag.multiload)
		for(var/i in 1 to internal_mag.max_ammo)
			weapon.attackby(reload_thing, living_pawn)
	else
		weapon.attackby(reload_thing, living_pawn)
	living_pawn.dropItemToGround(living_pawn.get_item_for_held_index(LEFT_HANDS), force = TRUE)
	living_pawn.swap_hand(RIGHT_HANDS)
	weapon.attack_self(living_pawn)
	return

/mob/living/carbon/human/combat_ai
	ai_controller = /datum/ai_controller/combat_ai

/mob/living/carbon/human/combat_ai/Initialize(mapload)
	. = ..()
	setMaxHealth(50)

/mob/living/carbon/human/combat_ai/sniper/Initialize(mapload)
	. = ..()
	equipOutfit(pick(typesof(/datum/outfit/combat_ai/sniper)))

/mob/living/carbon/human/combat_ai/smg/Initialize(mapload)
	. = ..()
	equipOutfit(pick(typesof(/datum/outfit/combat_ai/smg)))

/mob/living/carbon/human/combat_ai/pistol/Initialize(mapload)
	. = ..()
	equipOutfit(pick(typesof(/datum/outfit/combat_ai/pistol)))

/mob/living/carbon/human/combat_ai/magnum/Initialize(mapload)
	. = ..()
	equipOutfit(pick(typesof(/datum/outfit/combat_ai/magnum)))

/mob/living/carbon/human/combat_ai/shotgun/Initialize(mapload)
	. = ..()
	equipOutfit(pick(typesof(/datum/outfit/combat_ai/shotgun)))

/datum/outfit/combat_ai
	name = "Combat AI: Standard .22"

	r_hand = /obj/item/gun/ballistic/automatic/fallout/marksman/service/police22
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/alt/hecu
	suit = /obj/item/clothing/suit/armor/vest/hecu
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/away/old/sec
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(/obj/item/ammo_box/magazine/fallout/r22=6)

/datum/outfit/combat_ai/sniper
	name = "Combat AI: Sniper"

	r_hand = /obj/item/gun/ballistic/automatic/fallout/marksman/sniper
	backpack_contents = list(/obj/item/ammo_box/magazine/fallout/r308=6)

/datum/outfit/combat_ai/smg
	name = "Combat AI: SMG"

	r_hand = /obj/item/gun/ballistic/automatic/mp5
	backpack_contents = list(/obj/item/ammo_box/magazine/mp5=6)

/datum/outfit/combat_ai/pistol
	name = "Combat AI: Pistol"

	r_hand = /obj/item/gun/ballistic/automatic/pistol/tanner
	backpack_contents = list(/obj/item/ammo_box/magazine/m10mm=6)

/datum/outfit/combat_ai/magnum
	name = "Combat AI: Magnum"

	r_hand = /obj/item/gun/ballistic/revolver/fallout/rev44
	backpack_contents = list(/obj/item/ammo_box/fallout/rev44=6)

/datum/outfit/combat_ai/shotgun
	name = "Combat AI: Shotgun"

	r_hand = /obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks
	backpack_contents = list(/obj/item/ammo_box/fallout/sks=6)


//nigger
