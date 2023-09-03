/**
 * Delete a mob
 *
 * Removes mob from the following global lists
 * * GLOB.mob_list
 * * GLOB.dead_mob_list
 * * GLOB.alive_mob_list
 * * GLOB.all_clockwork_mobs
 * * GLOB.mob_directory
 *
 * Unsets the focus var
 *
 * Clears alerts for this mob
 *
 * Resets all the observers perspectives to the tile this mob is on
 *
 * qdels any client colours in place on this mob
 *
 * Clears any refs to the mob inside its current location
 *
 * Ghostizes the client attached to this mob
 *
 * If our mind still exists, clear its current var to prevent harddels
 *
 * Parent call
 */
/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	remove_from_mob_list()
	remove_from_dead_mob_list()
	remove_from_alive_mob_list()
	remove_from_mob_suicide_list()
	focus = null
	if(length(progressbars))
		stack_trace("[src] destroyed with elements in its progressbars list")
		progressbars = null
	for (var/alert in alerts)
		clear_alert(alert, TRUE)
	if(observers?.len)
		for(var/mob/dead/observe as anything in observers)
			observe.reset_perspective(null)
	qdel(hud_used)
	QDEL_LIST(client_colours)
	ghostize() //False, since we're deleting it currently
	if(mind?.current == src) //Let's just be safe yeah? This will occasionally be cleared, but not always. Can't do it with ghostize without changing behavior
		mind.set_current(null)
	return ..()


/**
 * Intialize a mob
 *
 * Sends global signal COMSIG_GLOB_MOB_CREATED
 *
 * Adds to global lists
 * * GLOB.mob_list
 * * GLOB.mob_directory (by tag)
 * * GLOB.dead_mob_list - if mob is dead
 * * GLOB.alive_mob_list - if the mob is alive
 *
 * Other stuff:
 * * Sets the mob focus to itself
 * * Generates huds
 * * If there are any global alternate apperances apply them to this mob
 * * set a random nutrition level
 * * Intialize the movespeed of the mob
 */
/mob/Initialize(mapload)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_CREATED, src)
	add_to_mob_list()
	if(stat == DEAD)
		add_to_dead_mob_list()
	else
		add_to_alive_mob_list()
	set_focus(src)
	prepare_huds()
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)
	set_nutrition(rand(NUTRITION_LEVEL_START_MIN, NUTRITION_LEVEL_START_MAX))
	hydration = rand(HYDRATION_LEVEL_START_MIN, HYDRATION_LEVEL_START_MAX)
	. = ..()
	update_config_movespeed()
	initialize_actionspeed()
	update_movespeed(TRUE)
	become_hearing_sensitive()

/**
 * Generate the tag for this mob
 *
 * This is simply "mob_"+ a global incrementing counter that goes up for every mob
 */
/mob/GenerateTag()
	tag = "mob_[next_mob_id++]"

/**
 * set every hud image in the given category active so other people with the given hud can see it.
 * Arguments:
 * * hud_category - the index in our active_hud_list corresponding to an image now being shown.
 * * update_huds - if FALSE we will just put the hud_category into active_hud_list without actually updating the atom_hud datums subscribed to it
 * * exclusive_hud - if given a reference to an atom_hud, will just update that hud instead of all global ones attached to that category.
 * This is because some atom_hud subtypes arent supposed to work via global categories, updating normally would affect all of these which we dont want.
 */
/atom/proc/set_hud_image_active(hud_category, update_huds = TRUE, datum/atom_hud/exclusive_hud)
	if(!istext(hud_category) || !hud_list?[hud_category] || active_hud_list?[hud_category])
		return FALSE

	LAZYSET(active_hud_list, hud_category, hud_list[hud_category])

	if(!update_huds)
		return TRUE

	if(exclusive_hud)
		exclusive_hud.add_single_hud_category_on_atom(src, hud_category)
	else
		for(var/datum/atom_hud/hud_to_update as anything in GLOB.huds_by_category[hud_category])
			hud_to_update.add_single_hud_category_on_atom(src, hud_category)

	return TRUE

///sets every hud image in the given category inactive so no one can see it
/atom/proc/set_hud_image_inactive(hud_category, update_huds = TRUE, datum/atom_hud/exclusive_hud)
	if(!istext(hud_category))
		return FALSE

	LAZYREMOVE(active_hud_list, hud_category)

	if(!update_huds)
		return TRUE

	if(exclusive_hud)
		exclusive_hud.remove_single_hud_category_on_atom(src, hud_category)
	else
		for(var/datum/atom_hud/hud_to_update as anything in GLOB.huds_by_category[hud_category])
			hud_to_update.remove_single_hud_category_on_atom(src, hud_category)

	return TRUE

/**
 * Prepare the huds for this atom
 *
 * Goes through hud_possible list and adds the images to the hud_list variable (if not already cached)
 */
/atom/proc/prepare_huds()
	if(hud_list) // I choose to be lienient about people calling this proc more then once
		return
	hud_list = list()
	for(var/hud in hud_possible)
		var/hint = hud_possible[hud]
		if(hint == HUD_LIST_LIST)
			hud_list[hud] = list()

		else
			var/image/I = image('icons/mob/hud.dmi', src, "")
			I.appearance_flags = RESET_COLOR|RESET_TRANSFORM
			hud_list[hud] = I
		set_hud_image_active(hud, update_huds = FALSE) //by default everything is active. but dont add it to huds to keep control.

/**
 * Some kind of debug verb that gives atmosphere environment details
 */
/mob/proc/Cell()
	set category = "Адм"
	set hidden = TRUE

	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()

	var/t =	span_notice("Координаты: [x],[y] \n")
	t +=	span_danger("Температура: [environment.return_temperature()] \n")
	for(var/id in environment.get_gases())
		if(environment.get_moles(id))
			t+=span_notice("[GLOB.meta_gas_info[id][META_GAS_NAME]]: [environment.get_moles(id)] \n")

	to_chat(usr, t)

/**
 * Return the desc of this mob for a photo
 */
/mob/proc/get_photo_description(obj/item/camera/camera)
	return "э... что это?"

/**
 * Show a message to this mob (visual or audible)
 */
/mob/proc/show_message(msg, type, alt_msg, alt_type, avoid_highlighting = FALSE)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	if(!client)
		return

	msg = copytext_char(msg, 1, MAX_MESSAGE_LEN)

	if(type)
		if(type & MSG_VISUAL && is_blind() )//Vision related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type

		if(type & MSG_AUDIBLE && !can_hear())//Hearing related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type
				if(type & MSG_VISUAL && is_blind())
					return
	// voice muffling
	if(stat == UNCONSCIOUS || stat == HARD_CRIT)
		if(type & MSG_AUDIBLE) //audio
			to_chat(src, "<I>... кто-то что-то говорит ...</I>")
		return
	to_chat(src, msg, avoid_highlighting = avoid_highlighting)

/**
 * Generate a visible message from this atom
 *
 * Show a message to all player mobs who sees this atom
 *
 * Show a message to the src mob (if the src is a mob)
 *
 * Use for atoms performing visible actions
 *
 * message is output to anyone who can see, e.g. `"The [src] does something!"`
 *
 * Vars:
 * * self_message (optional) is what the src mob sees e.g. "You do something!"
 * * blind_message (optional) is what blind people will hear e.g. "You hear something!"
 * * vision_distance (optional) define how many tiles away the message can be seen.
 * * ignored_mob (optional) doesn't show any message to a given mob if TRUE.
 */
/atom/proc/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, visible_message_flags = NONE)
	var/turf/T = get_turf(src)
	if(!T)
		return

	if(!islist(ignored_mobs))
		ignored_mobs = list(ignored_mobs)
	var/list/hearers = get_hearers_in_view(vision_distance, src) //caches the hearers and then removes ignored mobs.
	hearers -= ignored_mobs

	if(self_message)
		hearers -= src

	var/raw_msg = message
	if(visible_message_flags & EMOTE_MESSAGE)
		message = span_emote("<b>[capitalize(src)]</b> [message]")

	for(var/mob/M in hearers)
		if(!M.client)
			continue

		if((visible_message_flags & SPAM_MESSAGE) && !(M.client.prefs.chat_toggles & CHAT_SPAM))
			continue

		//This entire if/else chain could be in two lines but isn't for readibilties sake.
		var/msg = message
		var/msg_type = MSG_VISUAL

		if(M.see_invisible < invisibility)//if src is invisible to M
			msg = blind_message
			msg_type = MSG_AUDIBLE
		else if(T != loc && T != src) //if src is inside something and not a turf.
			msg = blind_message
			msg_type = MSG_AUDIBLE
		else if(M.lighting_alpha > LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE && T.is_softly_lit() && !in_range(T,M)) //if it is too dark, unless we're right next to them.
			msg = blind_message
			msg_type = MSG_AUDIBLE
		if(!msg)
			continue

		if(visible_message_flags & EMOTE_MESSAGE && runechat_prefs_check(M, visible_message_flags) && !M.is_blind())
			M.create_chat_message(src, raw_message = raw_msg, runechat_flags = visible_message_flags)

		M.show_message(msg, msg_type, blind_message, MSG_AUDIBLE)


///Adds the functionality to self_message.
/mob/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, visible_message_flags = NONE)
	. = ..()
	if(self_message)
		if((visible_message_flags & SPAM_MESSAGE) && !(client?.prefs?.chat_toggles & CHAT_SPAM))
			return
		show_message(self_message, MSG_VISUAL, blind_message, MSG_AUDIBLE)

/**
 * Show a message to all mobs in earshot of this atom
 *
 * Use for objects performing audible actions
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 */
/atom/proc/audible_message(message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, self_message, audible_message_flags = NONE)
	var/list/hearers = get_hearers_in_view(hearing_distance, src)
	if(self_message)
		hearers -= src
	var/raw_msg = message
	if(audible_message_flags & EMOTE_MESSAGE)
		message = span_emote("<b>[capitalize(src)]</b> [message]")
	for(var/mob/M in hearers)
		if(audible_message_flags & EMOTE_MESSAGE && runechat_prefs_check(M, audible_message_flags) && M.can_hear())
			M.create_chat_message(src, raw_message = raw_msg, runechat_flags = audible_message_flags)
		M.show_message(message, MSG_AUDIBLE, deaf_message, MSG_VISUAL)

/**
 * Show a message to all mobs in earshot of this one
 *
 * This would be for audible actions by the src mob
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * self_message (optional) is what the src mob hears.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 */
/mob/audible_message(message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, self_message, audible_message_flags = NONE)
	. = ..()
	if(self_message)
		show_message(self_message, MSG_AUDIBLE, deaf_message, MSG_VISUAL)


///Returns the client runechat visible messages preference according to the message type.
/atom/proc/runechat_prefs_check(mob/target, visible_message_flags = NONE)
	if(!target.client?.prefs.chat_on_map || !target.client.prefs.see_chat_non_mob)
		return FALSE
	if(visible_message_flags & EMOTE_MESSAGE && !target.client.prefs.see_rc_emotes)
		return FALSE
	return TRUE

/mob/runechat_prefs_check(mob/target, visible_message_flags = NONE)
	if(!target.client?.prefs.chat_on_map)
		return FALSE
	if(visible_message_flags & EMOTE_MESSAGE && !target.client.prefs.see_rc_emotes)
		return FALSE
	return TRUE


///Get the item on the mob in the storage slot identified by the id passed in
/mob/proc/get_item_by_slot(slot_id)
	return null

/// Gets what slot the item on the mob is held in.
/// Returns null if the item isn't in any slots on our mob.
/// Does not check if the passed item is null, which may result in unexpected outcoms.
/mob/proc/get_slot_by_item(obj/item/looking_for)
	if(looking_for in held_items)
		return ITEM_SLOT_HANDS

	return null

///Is the mob incapacitated
/mob/proc/incapacitated(flags)
	return

/**
 * This proc is called whenever someone clicks an inventory ui slot.
 *
 * Mostly tries to put the item into the slot if possible, or call attack hand
 * on the item in the slot if the users active hand is empty
 */
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_held_item()

	if(istype(W))
		if(equip_to_slot_if_possible(W, slot,0,0,0))
			return TRUE

	if(!W)
		// Activate the item
		var/obj/item/I = get_item_by_slot(slot)
		if(istype(I))
			I.attack_hand(src)

	return FALSE

/**
 * Try to equip an item to a slot on the mob
 *
 * This is a SAFE proc. Use this instead of equip_to_slot()!
 *
 * set qdel_on_fail to have it delete W if it fails to equip
 *
 * set disable_warning to disable the 'you are unable to equip that' warning.
 *
 * unset redraw_mob to prevent the mob icons from being redrawn at the end.
 *
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, qdel_on_fail = FALSE, disable_warning = FALSE, redraw_mob = TRUE, bypass_equip_delay_self = FALSE, initial = FALSE)
	if(!istype(W))
		return FALSE
	if(!W.mob_can_equip(src, null, slot, disable_warning, bypass_equip_delay_self))
		if(qdel_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, span_warning("Не могу себя снарядить этим!"))
		return FALSE
	equip_to_slot(W, slot, initial, redraw_mob) //This proc should not ever fail.
	return TRUE

/**
 * Actually equips an item to a slot (UNSAFE)
 *
 * This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on
 * whether you can or can't equip need to be done before! Use mob_can_equip() for that task.
 *
 *In most cases you will want to use equip_to_slot_if_possible()
 */
/mob/proc/equip_to_slot(obj/item/W, slot)
	return

/**
 * Equip an item to the slot or delete
 *
 * This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to
 * equip people when the round starts and when events happen and such.
 *
 * Also bypasses equip delay checks, since the mob isn't actually putting it on.
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/mob/proc/equip_to_slot_or_del(obj/item/W, slot, initial = FALSE)
	return equip_to_slot_if_possible(W, slot, TRUE, TRUE, FALSE, TRUE, initial)

/**
 * Auto equip the passed in item the appropriate slot based on equipment priority
 *
 * puts the item "W" into an appropriate slot in a human's inventory
 *
 * returns 0 if it cannot, 1 if successful
 */
/mob/proc/equip_to_appropriate_slot(obj/item/W, qdel_on_fail = FALSE, bypass_equip_delay_self = FALSE)
	if(!istype(W))
		return FALSE
	var/slot_priority = W.slot_equipment_priority

	if(!slot_priority)
		slot_priority = list( \
			ITEM_SLOT_BACK, ITEM_SLOT_ID,\
			ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
			ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
			ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
			ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
			ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
			ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
			ITEM_SLOT_DEX_STORAGE\
		)

	for(var/slot in slot_priority)
		if(equip_to_slot_if_possible(W, slot, FALSE, TRUE, TRUE, bypass_equip_delay_self, FALSE)) //qdel_on_fail = FALSE; disable_warning = TRUE; redraw_mob = TRUE;
			return TRUE

	if(qdel_on_fail)
		qdel(W)
	return FALSE
/**
 * Reset the attached clients perspective (viewpoint)
 *
 * reset_perspective(null) set eye to common default : mob on turf, loc otherwise
 * reset_perspective(thing) set the eye to the thing (if it's equal to current default reset to mob perspective)
 */
/mob/proc/reset_perspective(atom/new_eye)
	SHOULD_CALL_PARENT(TRUE)
	if(!client)
		return

	if(new_eye)
		if(ismovable(new_eye))
			//Set the new eye unless it's us
			if(new_eye != src)
				client.perspective = EYE_PERSPECTIVE
				client.set_eye(new_eye)
			else
				client.set_eye(client.mob)
				client.perspective = MOB_PERSPECTIVE

		else if(isturf(new_eye))
			//Set to the turf unless it's our current turf
			if(new_eye != loc)
				client.perspective = EYE_PERSPECTIVE
				client.set_eye(new_eye)
			else
				client.set_eye(client.mob)
				client.perspective = MOB_PERSPECTIVE
		else
			return TRUE //no setting eye to stupid things like areas or whatever
	else
		//Reset to common defaults: mob if on turf, otherwise current loc
		if(isturf(loc))
			client.set_eye(client.mob)
			client.perspective = MOB_PERSPECTIVE
		else
			client.perspective = EYE_PERSPECTIVE
			client.set_eye(loc)
	/// Signal sent after the eye has been successfully updated, with the client existing.
	SEND_SIGNAL(src, COMSIG_MOB_RESET_PERSPECTIVE)
	return TRUE

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/A as mob|obj|turf in view()) //It used to be oview(12), but I can't really say why
	set name = "Осмотреть"
	set category = null

	if(isturf(A) && !(sight & SEE_TURFS) && !(A in view(client ? client.view : world.view, src)))
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return

	if(is_blind() && !blind_examine_check(A)) //blind people see things differently (through touch)
		return

	face_atom(A)
	var/list/result
	if(client)
		LAZYINITLIST(client.recent_examines)
		if(isnull(client.recent_examines[A]) || client.recent_examines[A] < world.time)
			result = A.examine(src)
			client.recent_examines[A] = world.time + EXAMINE_MORE_TIME // set the value to when the examine cooldown ends
			RegisterSignal(A, COMSIG_PARENT_QDELETING, PROC_REF(clear_from_recent_examines), override=TRUE) // to flush the value if deleted early
			addtimer(CALLBACK(src, PROC_REF(clear_from_recent_examines), A), EXAMINE_MORE_TIME)
			handle_eye_contact(A)
		else
			result = A.examine_more(src)
	else
		result = A.examine(src) // if a tree is examined but no client is there to see it, did the tree ever really exist?

	if(result)
		to_chat(src, "<div class='examine_block'>[result.Join()]</div>")
	SEND_SIGNAL(src, COMSIG_MOB_EXAMINATE, A)


/mob/proc/blind_examine_check(atom/examined_thing)
	return TRUE //The non-living will always succeed at this check.


/mob/living/blind_examine_check(atom/examined_thing)
	//need to be next to something and awake
	if(!Adjacent(examined_thing) || incapacitated())
		to_chat(src, span_warning("Здесь что-то есть, но я не вижу этого!"))
		return FALSE

	//you can examine things you're holding directly, but you can't examine other things if your hands are full
	/// the item in our active hand
	var/active_item = get_active_held_item()
	if(active_item && active_item != examined_thing)
		to_chat(src, span_warning("Мне нужна свободная рука для правильного осмотра!"))
		return FALSE

	//you can only initiate exaimines if you have a hand, it's not disabled, and only as many examines as you have hands
	/// our active hand, to check if it's disabled/detatched
	var/obj/item/bodypart/active_hand = has_active_hand()? get_active_hand() : null
	if(!active_hand || active_hand.bodypart_disabled || LAZYLEN(do_afters) >= usable_hands)
		to_chat(src, span_warning("Мне нужна свободная рука для правильного осмотра!"))
		return FALSE

	//you can only queue up one examine on something at a time
	if(DOING_INTERACTION_WITH_TARGET(src, examined_thing))
		return FALSE

	to_chat(src, span_notice("Начинаю осматривать что-то..."))
	visible_message(span_notice("[name] щупает [examined_thing.name]..."))

	/// how long it takes for the blind person to find the thing they're examining
	var/examine_delay_length = rand(1 SECONDS, 2 SECONDS)
	if(client?.recent_examines && client?.recent_examines[examined_thing]) //easier to find things we just touched
		examine_delay_length = 0.33 SECONDS
	else if(isobj(examined_thing))
		examine_delay_length *= 1.5
	else if(ismob(examined_thing) && examined_thing != src)
		examine_delay_length *= 2

	if(examine_delay_length > 0 && !do_after(src, examine_delay_length, target = examined_thing))
		to_chat(src, span_notice("Начинаю осматривать что-то... ДА КАК ОН НАЗВАЛ МОЮ МАТЬ?!"))
		return FALSE

	//now we touch the thing we're examining
	/// our current intent, so we can go back to it after touching
	var/previous_intent = a_intent
	a_intent = INTENT_HELP
	INVOKE_ASYNC(examined_thing, /atom/proc/attack_hand, src)
	a_intent = previous_intent
	return TRUE


/mob/proc/clear_from_recent_examines(atom/A)
	SIGNAL_HANDLER

	if(!client)
		return
	UnregisterSignal(A, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(client.recent_examines, A)

/**
 * handle_eye_contact() is called when we examine() something. If we examine an alive mob with a mind who has examined us in the last second within 5 tiles, we make eye contact!
 *
 * Note that if either party has their face obscured, the other won't get the notice about the eye contact
 * Also note that examine_more() doesn't proc this or extend the timer, just because it's simpler this way and doesn't lose much.
 *	The nice part about relying on examining is that we don't bother checking visibility, because we already know they were both visible to each other within the last second, and the one who triggers it is currently seeing them
 */
/mob/proc/handle_eye_contact(mob/living/examined_mob)
	return

/mob/living/handle_eye_contact(mob/living/examined_mob)
	if(!istype(examined_mob) || src == examined_mob || examined_mob.stat >= UNCONSCIOUS || !client || !examined_mob.client?.recent_examines || !(src in examined_mob.client.recent_examines))
		return

	if(get_dist(src, examined_mob) > EYE_CONTACT_RANGE)
		return

	// check to see if their face is blocked or, if not, a signal blocks it
	if(examined_mob.is_face_visible() && SEND_SIGNAL(src, COMSIG_MOB_EYECONTACT, examined_mob, TRUE) != COMSIG_BLOCK_EYECONTACT)
		var/msg = span_smallnotice("[capitalize(examined_mob.name)] смотрит прямо на меня.")
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), src, msg), 3) // so the examine signal has time to fire and this will print after

	if(is_face_visible() && SEND_SIGNAL(examined_mob, COMSIG_MOB_EYECONTACT, src, FALSE) != COMSIG_BLOCK_EYECONTACT)
		var/msg = span_smallnotice("[capitalize(src.name)] смотрит прямо на меня.")
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), examined_mob, msg), 3)

/**
 * Called by using Activate Held Object with an empty hand/limb
 *
 * Does nothing by default. The intended use is to allow limbs to call their
 * own attack_self procs. It is up to the individual mob to override this
 * parent and actually use it.
 */
/mob/proc/limb_attack_self()
	return

///Can this mob resist (default FALSE)
/mob/proc/can_resist()
	return FALSE		//overridden in living.dm

///Spin this mob around it's central axis
/mob/proc/spin(spintime, speed)
	set waitfor = 0
	var/D = dir
	if((spintime < 1)||(speed < 1)||!spintime||!speed)
		return

	flags_1 |= IS_SPINNING_1
	while(spintime >= speed)
		sleep(speed)
		switch(D)
			if(NORTH)
				D = EAST
			if(SOUTH)
				D = WEST
			if(EAST)
				D = SOUTH
			if(WEST)
				D = NORTH
		setDir(D)
		spintime -= speed
	flags_1 &= ~IS_SPINNING_1

///Update the pulling hud icon
/mob/proc/update_pull_hud_icon()
	hud_used?.pull_icon?.update_icon()

///Update the resting hud icon
/mob/proc/update_rest_hud_icon()
	hud_used?.rest_icon?.update_icon()

/**
 * Verb to activate the object in your held hand
 *
 * Calls attack self on the item and updates the inventory hud for hands
 */
/mob/verb/mode()
	set name = "Использовать предмет в руке"
	set category = null
	set src = usr

	if(ismecha(loc))
		return

	if(incapacitated())
		return

	var/obj/item/I = get_active_held_item()
	if(I)
		I.attack_self(src)
		update_inv_hands()
		return

	limb_attack_self()


/**
 * Get the notes of this mob
 *
 * This actually gets the mind datums notes
 */
/mob/verb/memory()
	set name = "📘 Заметки"
	set category = "IC"
	set desc = "View your character's notes memory."
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "По какой-то причине у вас нет данных разума, поэтому вы не можете смотреть свои записи, если они у вас были.")

/**
 * Add a note to the mind datum
 */
/mob/verb/add_memory_wrapper(msg as message)
	set name = "📘 Добавить заметку"
	set category = "IC"

	msg = input("", "Добавить заметку") as null|message
	if(msg)
		add_memory(msg)

/mob/verb/add_memory(msg as message)
	set name = "📘 Добавить заметку"
	set hidden = 1
	if(mind)
		if (world.time < memory_throttle_time)
			return
		memory_throttle_time = world.time + 5 SECONDS
		msg = copytext_char(msg, 1, MAX_MESSAGE_LEN)
		msg = sanitize(msg)

		mind.store_memory(msg)
	else
		to_chat(src, "По какой-то причине у вас нет данных разума, поэтому вы не можете добавить к нему ещё записи.")

/**
 * Allows you to respawn, abandoning your current mob
 *
 * This sends you back to the lobby creating a new dead mob
 *
 * Only works if flag/norespawn is allowed in config
 */
/mob/verb/abandon_mob()
	set name = "❗ Переродиться"
	set category = "OOC"

	var/pd = text2num(GLOB.donators_list["phoenix"]?[client?.ckey])

	if(pd <= 0 && (CONFIG_GET(flag/norespawn) && (!check_rights_for(usr.client, R_ADMIN) || tgui_alert(usr, "Хуй сосал?", "Respawn", list("Да", "Нет")) != "Да")))
		return

	if(!COOLDOWN_FINISHED(client, respawn_delay))
		to_chat(usr, span_boldnotice("Перерождение будет доступно через [DisplayTimeText(COOLDOWN_TIMELEFT(client, respawn_delay))]."))
		return

	if((stat != DEAD || !( SSticker )))
		to_chat(usr, span_boldnotice("Живу!"))
		return

	if(pd)
		GLOB.donators_list["phoenix"][client.ckey]--
		to_chat(usr, span_boldnotice("Использован Феникс! Осталось [GLOB.donators_list["phoenix"][client.ckey]] зарядов."))

	log_game("[key_name(usr)] used abandon mob.")

	to_chat(usr, span_boldnotice("Поменяй имя или я приду к тебе ночью и вырву твою печень!"))

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	client.screen += client.void_right
	client.screen += client.void_bottom
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key


/**
 * Sometimes helps if the user is stuck in another perspective or camera
 */
/mob/verb/cancel_camera()
	set name = "❗ Выйти из режима камеры"
	set category = "OOC"
	reset_perspective(null)
	unset_machine()

//suppress the .click/dblclick macros so people can't use them to identify the location of items or aimbot
/mob/verb/DisClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".click"
	set hidden = TRUE
	set category = null
	return

/mob/verb/DisDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".dblclick"
	set hidden = TRUE
	set category = null
	return
/**
 * Topic call back for any mob
 *
 * * Unset machines if "mach_close" sent
 * * refresh the inventory of machines in range if "refresh" sent
 * * handles the strip panel equip and unequip as well if "item" sent
 */
/mob/Topic(href, href_list)
	var/mob/user = usr

	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(user != src)
		if(href_list["item"] && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
			var/slot = text2num(href_list["item"])
			var/hand_index = text2num(href_list["hand_index"])
			var/obj/item/what
			if(hand_index)
				what = get_item_for_held_index(hand_index)
				slot = list(slot,hand_index)
			else
				what = get_item_by_slot(slot)
			if(what)
				if(!(what.item_flags & ABSTRACT))
					user.stripPanelUnequip(what,src,slot)
			else
				user.stripPanelEquip(what,src,slot)

// The src mob is trying to strip an item from someone
// Defined in living.dm
/mob/proc/stripPanelUnequip(obj/item/what, mob/who)
	return

// The src mob пытается place an item on someone
// Defined in living.dm
/mob/proc/stripPanelEquip(obj/item/what, mob/who)
	return

/**
 * Controls if a mouse drop succeeds (return null if it doesnt)
 */
/mob/MouseDrop(mob/M)
	. = ..()
	if(M != usr)
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
	if(isAI(M))
		return

///Is the mob muzzled (default false)
/mob/proc/is_muzzled()
	return FALSE

/// Adds this list to the output to the stat browser
/mob/proc/get_status_tab_items()
	. = list()
	SEND_SIGNAL(src, COMSIG_MOB_GET_STATUS_TAB_ITEMS, .)

/**
 * Convert a list of spells into a displyable list for the statpanel
 *
 * Shows charge and other important info
 */
/mob/proc/get_actions_for_statpanel()
	var/list/data = list()
	for(var/datum/action/cooldown/action in actions)
		var/list/action_data = action.set_statpanel_format()
		if(!length(action_data))
			return

		data += list(list(
			// the panel the action gets displayed to
			// in the future, this could probably be replaced with subtabs (a la admin tabs)
			action_data[PANEL_DISPLAY_PANEL],
			// the status of the action, - cooldown, charges, whatever
			action_data[PANEL_DISPLAY_STATUS],
			// the name of the action
			action_data[PANEL_DISPLAY_NAME],
			// a ref to the action button of this action for this mob
			// it's a ref to the button specifically, instead of the action itself,
			// because statpanel href calls click(), which the action button (not the action itself) handles
			REF(action.viewers[hud_used]),
		))

	return data

#define MOB_FACE_DIRECTION_DELAY 1

// facing verbs
/**
 * Returns true if a mob can turn to face things
 *
 * Conditions:
 * * client.last_turn > world.time
 * * not dead or unconcious
 * * not anchored
 * * no transform not set
 * * we are not restrained
 */
/mob/proc/canface()
	if(world.time < client.last_turn)
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	if(anchored)
		return FALSE
	if(notransform)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return FALSE
	return TRUE

///Checks mobility move as well as parent checks
/mob/living/canface()
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE
	return ..()

/mob/dead/observer/canface()
	return TRUE

///Hidden verb to turn east
/mob/verb/eastface()
	set hidden = TRUE
	if(!canface())
		return FALSE
	setDir(EAST)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn west
/mob/verb/westface()
	set hidden = TRUE
	if(!canface())
		return FALSE
	setDir(WEST)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn north
/mob/verb/northface()
	set hidden = TRUE
	if(!canface())
		return FALSE
	setDir(NORTH)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn south
/mob/verb/southface()
	set hidden = TRUE
	if(!canface())
		return FALSE
	setDir(SOUTH)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

/mob/proc/swap_hand()
	var/obj/item/held_item = get_active_held_item()
	if(SEND_SIGNAL(src, COMSIG_MOB_SWAP_HANDS, held_item) & COMPONENT_BLOCK_SWAP)
		to_chat(src, span_warning("Другая рука слишком занята тем, чтобы держать [held_item]."))
		return FALSE
	SSspd.check_action(client, SPD_FAST_HANDS)
	return TRUE

/mob/proc/activate_hand(selhand)
	return

/mob/proc/assess_threat(judgement_criteria, lasercolor = "", datum/callback/weaponcheck=null) //For sec bot threat assessment
	return 0

///Get the ghost of this mob (from the mind)
/mob/proc/get_ghost(even_if_they_cant_reenter, ghosts_with_clients)
	if(mind)
		return mind.get_ghost(even_if_they_cant_reenter, ghosts_with_clients)

///Force get the ghost from the mind
/mob/proc/grab_ghost(force)
	if(mind)
		return mind.grab_ghost(force = force)

///Notify a ghost that it's body is being cloned
/mob/proc/notify_ghost_cloning(message = "Кто-то пытается меня откачать. Стоит войти в тело!", sound = 'sound/effects/genetics.ogg', atom/source = null, flashwindow)
	var/mob/dead/observer/ghost = get_ghost()
	if(ghost)
		ghost.notify_cloning(message, sound, source, flashwindow)
		return ghost

/**
 * Checks to see if the mob can cast normal magic spells.
 *
 * args:
 * * magic_flags (optional) A bitfield with the type of magic being cast (see flags at: /datum/component/anti_magic)
**/
/mob/proc/can_cast_magic(magic_flags = MAGIC_RESISTANCE)
	if(magic_flags == NONE) // magic with the NONE flag can always be cast
		return TRUE

	var/restrict_magic_flags = SEND_SIGNAL(src, COMSIG_MOB_RESTRICT_MAGIC, magic_flags)
	return restrict_magic_flags == NONE

/**
 * Checks to see if the mob can block magic
 *
 * args:
 * * casted_magic_flags (optional) A bitfield with the types of magic resistance being checked (see flags at: /datum/component/anti_magic)
 * * charge_cost (optional) The cost of charge to block a spell that will be subtracted from the protection used
**/
/mob/proc/can_block_magic(casted_magic_flags = NONE, charge_cost = 1)
	if(casted_magic_flags == NONE) // magic with the NONE flag is immune to blocking
		return FALSE

	var/is_magic_blocked = anti_magic_check()

	if(casted_magic_flags && HAS_TRAIT(src, TRAIT_ANTIMAGIC))
		is_magic_blocked = TRUE
	if(HAS_TRAIT(src, TRAIT_HOLY))
		is_magic_blocked = TRUE

	return is_magic_blocked

///Return any anti magic atom on this mob that matches the magic type
/mob/proc/anti_magic_check(magic = TRUE, holy = FALSE, tinfoil = FALSE, chargecost = 1, self = FALSE)
	if(!magic && !holy && !tinfoil)
		return
	var/list/protection_sources = list()
	if(SEND_SIGNAL(src, COMSIG_MOB_RECEIVE_MAGIC, src, magic, holy, tinfoil, chargecost, self, protection_sources) & COMPONENT_BLOCK_MAGIC)
		if(protection_sources.len)
			return pick(protection_sources)
		else
			return src
	if((magic && HAS_TRAIT(src, TRAIT_ANTIMAGIC)) || (holy && HAS_TRAIT(src, TRAIT_HOLY)))
		return src



/**
 * Buckle a living mob to this mob. Also turns you to face the other mob
 *
 * You can buckle on mobs if you're next to them since most are dense
 */
/mob/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE, buckle_mob_flags= NONE)
	if(M.buckled)
		return FALSE
	var/turf/T = get_turf(src)
	if(M.loc != T)
		var/old_density = density
		density = FALSE // Hacky and doesn't use set_density()
		var/can_step = step_towards(M, T)
		density = old_density // Avoid changing density directly in normal circumstances, without the setter.
		if(!can_step)
			return FALSE
	return ..()

///Call back post buckle to a mob to offset your visual height
/mob/post_buckle_mob(mob/living/M)
	var/height = M.get_mob_buckling_height(src)
	M.pixel_y = initial(M.pixel_y) + height
	if(M.layer <= layer) //make sure they stay above our current layer
		M.layer = layer + 0.1
///Call back post unbuckle from a mob, (reset your visual height here)
/mob/post_unbuckle_mob(mob/living/M)
	M.layer = initial(M.layer)
	M.pixel_y = initial(M.pixel_y)

///returns the height in pixel the mob should have when buckled to another mob.
/mob/proc/get_mob_buckling_height(mob/seat)
	if(isliving(seat))
		var/mob/living/L = seat
		if(L.mob_size <= MOB_SIZE_SMALL) //being on top of a small mob doesn't put you very high.
			return 0
	return 9

///Can the mob interact() with an atom?
/mob/proc/can_interact_with(atom/A, treat_mob_as_adjacent)
	if(isAdminGhostAI(src))
		return TRUE
	//Return early. we do not need to check that we are on adjacent turfs (i.e we are inside a closet)
	if (treat_mob_as_adjacent && src == A.loc)
		return TRUE
	if (Adjacent(A))
		return TRUE
	var/datum/dna/mob_dna = has_dna()
	if(mob_dna?.check_mutation(TK) && tkMaxRangeCheck(src, A))
		return TRUE
	return FALSE

///Can the mob use Topic to interact with machines
/mob/proc/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE, need_hands = FALSE, floor_okay=FALSE)
	return

///Can this mob use storage
/mob/proc/canUseStorage()
	return FALSE
/**
 * Check if the other mob has any factions the same as us
 *
 * If exact match is set, then all our factions must match exactly
 */
/mob/proc/faction_check_mob(mob/target, exact_match)
	if(exact_match) //if we need an exact match, we need to do some bullfuckery.
		var/list/faction_src = faction.Copy()
		var/list/faction_target = target.faction.Copy()
		if(!("[REF(src)]" in faction_target)) //if they don't have our ref faction, remove it from our factions list.
			faction_src -= "[REF(src)]" //if we don't do this, we'll never have an exact match.
		if(!("[REF(target)]" in faction_src))
			faction_target -= "[REF(target)]" //same thing here.
		return faction_check(faction_src, faction_target, TRUE)
	return faction_check(faction, target.faction, FALSE)
/*
 * Compare two lists of factions, returning true if any match
 *
 * If exact match is passed through we only return true if both faction lists match equally
 */
/proc/faction_check(list/faction_A, list/faction_B, exact_match)
	var/list/match_list
	if(exact_match)
		match_list = faction_A&faction_B //only items in both lists
		var/length = LAZYLEN(match_list)
		if(length)
			return (length == LAZYLEN(faction_A)) //if they're not the same len(gth) or we don't have a len, then this isn't an exact match.
	else
		match_list = faction_A&faction_B
		return LAZYLEN(match_list)
	return FALSE


/**
 * Fully update the name of a mob
 *
 * This will update a mob's name, real_name, mind.name, GLOB.data_core records, pda, id and traitor text
 *
 * Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
 */
/mob/proc/fully_replace_character_name(oldname, newname)
	if(!newname)
		log_message("[src] failed name change from [oldname] as no new name was specified", LOG_OWNERSHIP)
		return FALSE
	if(oldname == newname)
		log_message("[src] failed name change as the new name was the same as the old one: [oldname]", LOG_OWNERSHIP)
		return FALSE
	if(!istext(newname) && !isnull(newname))
		stack_trace("[src] attempted to change its name from [oldname] to the non string value [newname]")
		return FALSE

	log_message("[src] name changed from [oldname] to [newname]", LOG_OWNERSHIP)

	log_played_names(ckey, newname)

	real_name = newname
	name = newname
	if(mind)
		mind.name = newname
		if(mind.key)
			log_played_names(mind.key,newname) //Just in case the mind is unsynced at the moment.

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		replace_records_name(oldname,newname)

		//update our pda and id if we have them on our person
		replace_identification_name(oldname,newname)

		for(var/datum/mind/T in SSticker.minds)
			for(var/datum/objective/obj in T.get_all_objectives())
				// Only update if this player is a target
				if(obj.target && obj.target.current && obj.target.current.real_name == name)
					obj.update_explanation_text()
	return TRUE

///Updates GLOB.data_core records with new name , see mob/living/carbon/human
/mob/proc/replace_records_name(oldname,newname)
	return

///update the ID name of this mob
/mob/proc/replace_identification_name(oldname,newname)
	var/list/searching = get_all_contents()
	var/search_id = 1
	var/search_pda = 1

	for(var/A in searching)
		if( search_id && istype(A, /obj/item/card/id) )
			var/obj/item/card/id/ID = A
			if(ID.registered_name == oldname)
				ID.registered_name = newname
				ID.update_label()
				ID.update_icon()
				if(ID.registered_account?.account_holder == oldname)
					ID.registered_account.account_holder = newname
				if(!search_pda)
					break
				search_id = 0

		else if( search_pda && istype(A, /obj/item/modular_computer/tablet/pda) )
			var/obj/item/modular_computer/tablet/pda/PDA = A
			if(PDA.saved_identification == oldname)
				PDA.saved_identification = newname
				PDA.UpdateDisplay()
				if(!search_id)
					break
				search_pda = 0

/mob/proc/update_stat()
	return

/mob/proc/update_health_hud()
	return

/// Changes the stamina HUD based on new information
/mob/proc/update_stamina_hud()
	return

///Update the lighting plane and sight of this mob (sends COMSIG_MOB_UPDATE_SIGHT)
/mob/proc/update_sight()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_SIGHT)
	sync_lighting_plane_alpha()

///Set the lighting plane hud alpha to the mobs lighting_alpha var
/mob/proc/sync_lighting_plane_alpha()
	if(!hud_used)
		return
	for(var/atom/movable/screen/plane_master/rendering_plate/lighting/light_plane in hud_used.get_true_plane_masters(RENDER_PLANE_LIGHTING))
		light_plane.set_alpha(lighting_alpha)

///Update the mouse pointer of the attached client in this mob
/mob/proc/update_mouse_pointer()
	if(!client)
		return
	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	if(examine_cursor_icon && client.keys_held["Shift"]) //mouse shit is hardcoded, make this non hard-coded once we make mouse modifiers bindable
		client.mouse_pointer_icon = examine_cursor_icon
	if(istype(loc, /obj/vehicle/sealed))
		var/obj/vehicle/sealed/E = loc
		if(E.mouse_pointer)
			client.mouse_pointer_icon = E.mouse_pointer
	if(client.mouse_override_icon)
		client.mouse_pointer_icon = client.mouse_override_icon


/// This mob is abile to read books
/mob/proc/is_literate()
	return FALSE

/**
 * Proc that returns TRUE if the mob can write using the writing_instrument, FALSE otherwise.
 *
 * This proc a side effect, outputting a message to the mob's chat with a reason if it returns FALSE.
 */
/mob/proc/can_write(obj/item/writing_instrument)
	if(!istype(writing_instrument))
		to_chat(src, span_warning("You can't write with the [writing_instrument]!"))
		return FALSE

	if(!is_literate())
		to_chat(src, span_warning("You try to write, but don't know how to spell anything!"))
		return FALSE

	if(!has_light_nearby() && !has_nightvision())
		to_chat(src, span_warning("It's too dark in here to write anything!"))
		return FALSE
/*
	var/pen_info = writing_instrument.get_writing_implement_details()
	if(!pen_info || (pen_info["interaction_mode"] != MODE_WRITING))
		to_chat(src, span_warning("You can't write with the [writing_instrument]!"))
		return FALSE
*/
	if(has_gravity())
		return TRUE

	var/obj/item/pen/pen = writing_instrument

	if(istype(pen)) // pen.requires_gravity - вы че там совсем отбитые нахуй
		to_chat(src, span_warning("You try to write, but the [writing_instrument] doesn't work in zero gravity!"))
		return FALSE

	return TRUE

/**
 * Can this mob see in the dark
 *
 * This checks all traits, glasses, and robotic eyeball implants to see if the mob can see in the dark
 * this does NOT check if the mob is missing it's eyeballs. Also see_in_dark is a BYOND mob var (that defaults to 2)
**/
/mob/proc/has_nightvision()
	return HAS_TRAIT(src, TRAIT_NIGHT_VISION)

/// Is this mob affected by nearsight
/mob/proc/is_nearsighted()
	return HAS_TRAIT(src, TRAIT_NEARSIGHT)

/**
 * Checks if there is enough light where the mob is located
 *
 * Args:
 *  light_amount (optional) - A decimal amount between 1.0 through 0.0 (default is 0.2)
**/
/mob/proc/has_light_nearby(light_amount = LIGHTING_TILE_IS_DARK)
	var/turf/mob_location = get_turf(src)
	return mob_location.get_lumcount() > light_amount

/// Can this mob read (is literate and not blind)
/mob/proc/can_read(atom/viewed_atom, reading_check_flags = (READING_CHECK_LITERACY|READING_CHECK_LIGHT), silent = FALSE)
	if((reading_check_flags & READING_CHECK_LITERACY) && !is_literate())
		if(!silent)
			to_chat(src, span_warning("Пытаюсь прочитать [viewed_atom], но внезапно понимаю, что не умею читать."))
		return FALSE

	if((reading_check_flags & READING_CHECK_LIGHT) && !has_light_nearby() && !has_nightvision())
		if(!silent)
			to_chat(src, span_warning("Слишком темно для чтения!"))
		return FALSE

	return TRUE

/**
 * Get the mob VV dropdown extras
 */
/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_GIB, "Gib")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_SPELL, "Give Spell")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_SPELL, "Remove Spell")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_DISEASE, "Give Disease")
	VV_DROPDOWN_OPTION(VV_HK_GODMODE, "Toggle Godmode")
	VV_DROPDOWN_OPTION(VV_HK_DROP_ALL, "Drop Everything")
	VV_DROPDOWN_OPTION(VV_HK_REGEN_ICONS, "Regenerate Icons")
	VV_DROPDOWN_OPTION(VV_HK_PLAYER_PANEL, "Show player panel")
	VV_DROPDOWN_OPTION(VV_HK_BUILDMODE, "Toggle Buildmode")
	VV_DROPDOWN_OPTION(VV_HK_DIRECT_CONTROL, "Assume Direct Control")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_DIRECT_CONTROL, "Give Direct Control")
	VV_DROPDOWN_OPTION(VV_HK_OFFER_GHOSTS, "Offer Control to Ghosts")
	VV_DROPDOWN_OPTION(VV_HK_VIEW_PLANES, "View/Edit Planes")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_REGEN_ICONS])
		if(!check_rights(NONE))
			return
		regenerate_icons()
	if(href_list[VV_HK_PLAYER_PANEL])
		if(!check_rights(NONE))
			return
		usr.client.holder.show_player_panel(src)
	if(href_list[VV_HK_GODMODE])
		if(!check_rights(R_ADMIN))
			return
		usr.client.cmd_admin_godmode(src)
	if(href_list[VV_HK_GIVE_SPELL])
		if(!check_rights(NONE))
			return
		usr.client.give_spell(src)
	if(href_list[VV_HK_REMOVE_SPELL])
		if(!check_rights(NONE))
			return
		usr.client.remove_spell(src)
	if(href_list[VV_HK_GIVE_DISEASE])
		if(!check_rights(NONE))
			return
		usr.client.give_disease(src)
	if(href_list[VV_HK_GIB])
		if(!check_rights(R_FUN))
			return
		usr.client.cmd_admin_gib(src)
	if(href_list[VV_HK_BUILDMODE])
		if(!check_rights(R_BUILD))
			return
		togglebuildmode(src)
	if(href_list[VV_HK_DROP_ALL])
		if(!check_rights(NONE))
			return
		usr.client.cmd_admin_drop_everything(src)
	if(href_list[VV_HK_DIRECT_CONTROL])
		if(!check_rights(NONE))
			return
		usr.client.cmd_assume_direct_control(src)
	if(href_list[VV_HK_GIVE_DIRECT_CONTROL])
		if(!check_rights(NONE))
			return
		usr.client.cmd_give_direct_control(src)
	if(href_list[VV_HK_OFFER_GHOSTS])
		if(!check_rights(NONE))
			return
		offer_control(src)
	if(href_list[VV_HK_VIEW_PLANES])
		if(!check_rights(R_DEBUG))
			return
		usr.client.edit_plane_masters(src)

/**
 * extra var handling for the logging var
 */
/mob/vv_get_var(var_name)
	switch(var_name)
		if("logging")
			return debug_variable(var_name, logging, 0, src, FALSE)
	. = ..()

/mob/vv_auto_rename(new_name)
	//Do not do parent's actions, as we *usually* do this differently.
	fully_replace_character_name(real_name, new_name)

///Show the language menu for this mob
/mob/verb/open_language_menu()
	set name = "Мои языки"
	set category = "IC"
	set category = null

	var/datum/language_holder/H = get_language_holder()
	H.open_language_menu(usr)

///Adjust the nutrition of a mob
/mob/proc/adjust_nutrition(change) //Honestly FUCK the oldcoders for putting nutrition on /mob someone else can move it up because holy hell I'd have to fix SO many typechecks
	nutrition = max(0, nutrition + change)

///Force set the mob nutrition
/mob/proc/set_nutrition(change) //Seriously fuck you oldcoders.
	nutrition = max(0, change)

/mob/proc/update_equipment_speed_mods()
	var/speedies = equipped_speed_mods()
	if(!speedies)
		remove_movespeed_modifier(/datum/movespeed_modifier/equipment_speedmod)
	else
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/equipment_speedmod, multiplicative_slowdown = speedies)

/// Gets the combined speed modification of all worn items
/// Except base mob type doesnt really wear items
/mob/proc/equipped_speed_mods()
	for(var/obj/item/I in held_items)
		if(I.item_flags & SLOWS_WHILE_IN_HAND)
			. += I.slowdown

/mob/proc/set_stat(new_stat)
	if(new_stat == stat)
		return
	SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, new_stat)
	. = stat
	stat = new_stat


/mob/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, control_object))
			var/obj/O = var_value
			if(!istype(O) || (O.obj_flags & DANGEROUS_POSSESSION))
				return FALSE
		if(NAMEOF(src, machine))
			set_machine(var_value)
			. =  TRUE
		if(NAMEOF(src, focus))
			set_focus(var_value)
			. =  TRUE
		if(NAMEOF(src, nutrition))
			set_nutrition(var_value)
			. =  TRUE
		if(NAMEOF(src, stat))
			set_stat(var_value)
			. =  TRUE
		if(NAMEOF(src, dizziness))
			set_dizziness(var_value)
			. =  TRUE
		if(NAMEOF(src, eye_blind))
			set_blindness(var_value)
			. =  TRUE
		if(NAMEOF(src, eye_blurry))
			set_blurriness(var_value)
			. =  TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	var/slowdown_edit = (var_name == NAMEOF(src, cached_multiplicative_slowdown))
	var/diff
	if(slowdown_edit && isnum(cached_multiplicative_slowdown) && isnum(var_value))
		remove_movespeed_modifier(/datum/movespeed_modifier/admin_varedit)
		diff = var_value - cached_multiplicative_slowdown

	. = ..()

	if(. && slowdown_edit && isnum(diff))
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/admin_varedit, multiplicative_slowdown = diff)

/mob/proc/set_active_storage(new_active_storage)
	if(active_storage)
		UnregisterSignal(active_storage, COMSIG_PARENT_QDELETING)
	active_storage = new_active_storage
	if(active_storage)
		RegisterSignal(active_storage, COMSIG_PARENT_QDELETING, PROC_REF(active_storage_deleted))

/mob/proc/active_storage_deleted(datum/source)
	SIGNAL_HANDLER
	set_active_storage(null)

/// Cleanup proc that's called when a mob loses a client, either through client destroy or logout
/// Logout happens post client del, so we can't just copypaste this there. This keeps things clean and consistent
/mob/proc/become_uncliented()
	if(!canon_client)
		return

	for(var/foo in canon_client.player_details.post_logout_callbacks)
		var/datum/callback/CB = foo
		CB.Invoke()

	if(canon_client?.movingmob)
		LAZYREMOVE(canon_client.movingmob.client_mobs_in_contents, src)
		canon_client.movingmob = null

	clear_important_client_contents()
	canon_client = null

///Clears the client in contents list of our current "eye". Prevents hard deletes
/mob/proc/clear_client_in_contents()
	if(client?.movingmob) //In the case the client was transferred to another mob and not deleted.
		client.movingmob.client_mobs_in_contents -= src
		UNSETEMPTY(client.movingmob.client_mobs_in_contents)
		client.movingmob = null

/mob/proc/look_into_distance(atom/A, params)
	if(!client)
		to_chat(src, span_warning("Не могу."))
		return
	if(HAS_TRAIT_FROM(src, TRAIT_LOOKING_INTO_DISTANCE, "verb"))
		unperform_zoom(A, params)
	else
		perform_zoom(A, params)
		visible_message(span_notice("<b>[src]</b> смотрит в даль."), span_notice("Смотрю в даль."))

/mob/proc/perform_zoom(atom/A, params, silent = FALSE)
	if(!client)
		return
	ADD_TRAIT(src, TRAIT_LOOKING_INTO_DISTANCE, "verb")
	SEND_SIGNAL(src, COMSIG_FIXEYE_UNLOCK)
	SEND_SIGNAL(src, COMSIG_FIXEYE_ENABLE, TRUE, TRUE)
	SEND_SIGNAL(src, COMSIG_FIXEYE_LOCK)
	RegisterSignal(src, COMSIG_MOB_LOGOUT, PROC_REF(kill_zoom), override = TRUE)
	//var/distance = min(get_dist(src, A), 7)
	var/distance = 7
	var/direction = get_approx_dir(get_angle(src, A))
	dir = direction & (EAST | WEST)
	if(!dir)
		dir = direction & (NORTH | SOUTH)
	var/x_offset = 0
	var/y_offset = 0
	if(direction & NORTH)
		y_offset = distance * world.icon_size
	if(direction & SOUTH)
		y_offset = -distance * world.icon_size
	if(direction & EAST)
		x_offset = distance * world.icon_size
	if(direction & WEST)
		x_offset = -distance * world.icon_size
	animate(client, pixel_x = pixel_x + x_offset, pixel_y = pixel_y + y_offset, time = 7, easing = SINE_EASING)

/mob/proc/unperform_zoom(atom/A, params, silent = FALSE)
	REMOVE_TRAIT(src, TRAIT_LOOKING_INTO_DISTANCE, "verb")
	SEND_SIGNAL(src, COMSIG_FIXEYE_UNLOCK)
	SEND_SIGNAL(src, COMSIG_FIXEYE_DISABLE, TRUE, TRUE)
	UnregisterSignal(src, COMSIG_MOB_LOGOUT)
	if(client)
		animate(client, pixel_x = initial(client.pixel_x), pixel_y = initial(client.pixel_y), time = 7, easing = SINE_EASING)

/mob/proc/kill_zoom(mob/living/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(unperform_zoom))

/mob/verb/view_changelog()
	set hidden = TRUE

	if(!client)
		return

	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog(src)

	if(GLOB.changelog_hash && client.prefs.lastchangelog != GLOB.changelog_hash)
		client.prefs.lastchangelog = GLOB.changelog_hash
		client.prefs.save_preferences()

	GLOB.changelog_tgui.ui_interact(src)
