/// Checks for RIGHT_CLICK in modifiers and runs attack_hand_secondary if so. Returns TRUE if normal chain blocked
/mob/living/proc/right_click_attack_chain(atom/target, list/modifiers)
	if (!LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	var/secondary_result = target.attack_hand_secondary(src, modifiers)

	if (secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
		return TRUE

	//white
	else if(isobj(target))
		target.AltClick(src)
		return TRUE

	else if (secondary_result != SECONDARY_ATTACK_CALL_NORMAL)
		CRASH("attack_hand_secondary did not return a SECONDARY_ATTACK_* define.")

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		if(src == A)
			check_self_for_injuries()
		return
	if(!has_active_hand()) //can't attack without a hand.
		var/obj/item/bodypart/check_arm = get_active_hand()
		if(check_arm?.bodypart_disabled)
			to_chat(src, span_warning("Моя [check_arm.name] слишком сильно повреждена! Надо бы поскорее починить её или хотя бы перевязать!"))
			return

		to_chat(src, span_notice("Смотрю на свою руку и вздыхаю."))
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity_flag && istype(G) && G.Touch(A,1,modifiers))
		return
	//This signal is needed to prevent gloves of the north star + hulk.
	if(SEND_SIGNAL(src, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, A, proximity_flag, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return
	SEND_SIGNAL(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, A, proximity_flag, modifiers)

	if(!right_click_attack_chain(A, modifiers) && !dna?.species?.spec_unarmedattack(src, A, modifiers)) //Because species like monkeys dont use attack hand
		A.attack_hand(src, modifiers)



/// Return TRUE to cancel other attack hand effects that respect it. Modifiers is the assoc list for click info such as if it was a right click.
/atom/proc/attack_hand(mob/user, list/modifiers)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)

/// When the user uses their hand on an item while holding right-click
/// Returns a SECONDARY_ATTACK_* value.
/atom/proc/attack_hand_secondary(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND_SECONDARY, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CALL_NORMAL

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(isAdminGhostAI(user)) //admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user, require_adjacent_turf = TRUE)
	if(!user.can_interact_with(src, interaction_flags_atom & INTERACT_ATOM_ALLOW_USER_LOCATION))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("У меня не хватает ловкости для этого!"))
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED))
		var/ignore_flags = NONE
		if(interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED)
			ignore_flags |= IGNORE_RESTRAINTS
		if(!(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB))
			ignore_flags |= IGNORE_GRAB

		if(user.incapacitated(ignore_flags))
			return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	//Check if both user and atom are at the same location
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		SEND_SIGNAL(src, COMSIG_ATOM_UI_INTERACT, user)
		return ui_interact(user)
	return FALSE


/mob/living/carbon/human/RangedAttack(atom/A, modifiers)
	. = ..()
	if(.)
		return
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0,modifiers)) // for magic gloves
			return TRUE

	if(isturf(A) && get_dist(src,A) <= 1)
		Move_Pulled(A)
		return TRUE

/mob/living/carbon/human/ranged_secondary_attack(atom/target, modifiers)
	. = ..()
	if(. || !has_active_hand() || stat)
		return

	if((!ismob(target) && !iscameraobj(target)) || get_dist(src, target) >= 8)
		return

	var/mob/target_mob = target
	var/target_message

	switch(a_intent)
		if(INTENT_HELP)
			visible_message(span_notice("<b>[capitalize(src)]</b> машет рукой <b>[target]</b>."), span_notice("Машу рукой <b>[target]</b>."), span_notice("Машу кому-то рукой."), ignored_mobs = target)
			target_message = "машет мне рукой"
		if(INTENT_DISARM)
			visible_message(span_notice("<b>[capitalize(src)]</b> просит жестом <b>[target]</b> отойти."), span_notice("Прошу жестом <b>[target]</b> отойти."), span_notice("Прошу жестом кого-то отойти."), ignored_mobs = target)
			target_message = "просит меня отойти"
		if(INTENT_GRAB)
			visible_message(span_notice("<b>[capitalize(src)]</b> подманивает пальчиком <b>[target]</b>."), span_notice("Подманиваю пальчиком <b>[target]</b>."), span_notice("Подманиваю пальчиком кого-то."), ignored_mobs = target)
			target_message = "подманивает меня пальчиком"
		if(INTENT_HARM)
			visible_message(span_warning("<b>[capitalize(src)]</b> угрожает кулаком <b>[target]</b>!"), span_warning("Угрожаю кулаком <b>[target]</b>!"), span_warning("Угрожаю кому-то кулаком!"), ignored_mobs = target)
			target_message = "угрожает мне кулаком"
	changeNext_move(1 SECONDS)

	SEND_SIGNAL(target, COMSIG_ATOM_FRIENDLY_WAVED, a_intent)

	if(!istype(target_mob))
		return TRUE

	if(a_intent == INTENT_HARM)
		to_chat(target, span_danger("<b>[capitalize(src)]</b> [target_message]!"))
	else
		to_chat(target, span_notice("<b>[capitalize(src)]</b> [target_message]."))

	if(target_mob?.client?.prefs.chat_on_map)
		target_mob.create_chat_message(src, raw_message = target_message, runechat_flags = EMOTE_MESSAGE)

	return TRUE

/*
	Animals & All Unspecified
*/

// If the UnarmedAttack chain is blocked
#define LIVING_UNARMED_ATTACK_BLOCKED(target_atom) (HAS_TRAIT(src, TRAIT_HANDS_BLOCKED) \
	|| SEND_SIGNAL(src, COMSIG_LIVING_UNARMED_ATTACK, target_atom, proximity_flag, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)

/mob/living/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	attack_target.attack_animal(src, modifiers)

/atom/proc/attack_animal(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

/atom/proc/attack_basic_mob(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_BASIC_MOB, user)

///Attacked by monkey
/atom/proc/attack_paw(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_PAW, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE


/*
	Aliens
	Defaults to same as monkey in most places
*/
/mob/living/carbon/alien/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	attack_target.attack_alien(src, modifiers)

/atom/proc/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	attack_paw(user, modifiers)
	return


// Babby aliens
/mob/living/carbon/alien/larva/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	attack_target.attack_larva(src)

/atom/proc/attack_larva(mob/user)
	return


/*
	Slimes
	Nothing happening here
*/
/mob/living/simple_animal/slime/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	if(isturf(attack_target))
		return ..()
	attack_target.attack_slime(src)

/atom/proc/attack_slime(mob/user)
	return


/*
	Drones
*/
/mob/living/simple_animal/drone/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	attack_target.attack_drone(src, modifiers)

/// Defaults to attack_hand or attack_hand_secondary. Override it when you don't want drones to do same stuff as humans.
/atom/proc/attack_drone(mob/living/simple_animal/drone/user, list/modifiers)
	if(!user.right_click_attack_chain(src, modifiers))
		attack_hand(user, modifiers)


/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)//Stops runtimes due to attack_animal being the default
	return


/*
	pAI
*/

/mob/living/silicon/pai/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)//Stops runtimes due to attack_animal being the default
	return


/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	if(dextrous && (isitem(attack_target)/* || !combat_mode9*/))
		attack_target.attack_hand(src, modifiers)
		update_inv_hands()
	else
		return ..()


/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LIVING_UNARMED_ATTACK_BLOCKED(attack_target))
		return
	GiveTarget(attack_target)
	if(dextrous && (isitem(attack_target)/* || !combat_mode*/))
		..()
	else
		AttackingTarget(attack_target)

#undef LIVING_UNARMED_ATTACK_BLOCKED

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn()
	return
