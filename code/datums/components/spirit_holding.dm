/**
 * spirit holding component; for items to have spirits inside of them for "advice"
 *
 * Used for the possessed blade and fantasy affixes
 */
/datum/component/spirit_holding
	///bool on if this component is currently polling for observers to inhabit the item
	var/attempting_awakening = FALSE
	///mob contained in the item.
	var/mob/living/simple_animal/shade/bound_spirit

/datum/component/spirit_holding/Initialize(mapload)
	if(!ismovable(parent)) //you may apply this to mobs, i take no responsibility for how that works out
		return COMPONENT_INCOMPATIBLE

/datum/component/spirit_holding/Destroy(force, silent)
	. = ..()
	if(bound_spirit)
		QDEL_NULL(bound_spirit)

/datum/component/spirit_holding/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/on_attack_self)
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, .proc/on_destroy)

/datum/component/spirit_holding/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_ATTACK_SELF, COMSIG_PARENT_QDELETING))

///signal fired on examining the parent
/datum/component/spirit_holding/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!bound_spirit)
		examine_list += "<span class='notice'>\n[parent] sleeps. Use [parent] in your hands to attempt to awaken it.</span>"
		return
	examine_list += "<span class='notice'>\n[parent] is alive.</span>"

///signal fired on self attacking parent
/datum/component/spirit_holding/proc/on_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, .proc/attempt_spirit_awaken, user)

/**
 * attempt_spirit_awaken: called from on_attack_self, polls ghosts to possess the item in the form
 * of a mob sitting inside the item itself
 *
 * Arguments:
 * * awakener: user who interacted with the blade
 */
/datum/component/spirit_holding/proc/attempt_spirit_awaken(mob/awakener)
	if(attempting_awakening)
		to_chat(awakener, "<span class='warning'>You are already trying to awaken [parent]!</span>")
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		to_chat(awakener, "<span class='warning'>Anomalous otherworldly energies block you from awakening [parent]!</span>")
		return

	attempting_awakening = TRUE
	to_chat(awakener, "<span class='notice'>You attempt to wake the spirit of [parent]...</span>")

	var/list/candidates = poll_ghost_candidates("Do you want to play as the spirit of [awakener.real_name]'s blade?", ROLE_PAI, FALSE, 100, POLL_IGNORE_POSSESSED_BLADE)
	if(!LAZYLEN(candidates))
		to_chat(awakener, "<span class='warning'>[parent] is dormant. Maybe you can try again later.</span>")
		attempting_awakening = FALSE
		return

	var/mob/dead/observer/chosen_spirit = pick(candidates)
	bound_spirit = new(parent)
	bound_spirit.ckey = chosen_spirit.ckey
	bound_spirit.fully_replace_character_name(null, "The spirit of [parent]")
	bound_spirit.status_flags |= GODMODE
	bound_spirit.copy_languages(awakener, LANGUAGE_MASTER) //Make sure the sword can understand and communicate with the awakener.
	bound_spirit.update_atom_languages()
	bound_spirit.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue
	var/input = sanitize_name(stripped_input(bound_spirit, "What are you named?", ,"", MAX_NAME_LEN))
	if(parent && input)
		parent = input
		bound_spirit.fully_replace_character_name(null, "The spirit of [input]")

	//prevents awakening it again + new signals for a now-possessed item
	attempting_awakening = FALSE
	UnregisterSignal(parent, COMSIG_ITEM_ATTACK_SELF)
	RegisterSignal(parent, COMSIG_ATOM_RELAYMOVE, .proc/block_buckle_message)
	RegisterSignal(parent, COMSIG_BIBLE_SMACKED, .proc/on_bible_smacked)

///signal fired from a mob moving inside the parent
/datum/component/spirit_holding/proc/block_buckle_message(datum/source, mob/living/user, direction)
	SIGNAL_HANDLER
	return COMSIG_BLOCK_RELAYMOVE

/datum/component/spirit_holding/proc/on_bible_smacked(datum/source, mob/living/user, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, .proc/attempt_exorcism, user)

/**
 * attempt_exorcism: called from on_bible_smacked, takes time and if successful
 * resets the item to a pre-possessed state
 *
 * Arguments:
 * * exorcist: user who is attempting to remove the spirit
 */
/datum/component/spirit_holding/proc/attempt_exorcism(mob/exorcist)
	var/atom/movable/exorcised_movable = parent
	to_chat(exorcist, "<span class='notice'>You begin to exorcise [parent]...</span>")
	playsound(src,'sound/hallucinations/veryfar_noise.ogg',40,TRUE)
	if(!do_after(exorcist, 4 SECONDS, target = exorcised_movable))
		return
	playsound(src,'sound/effects/pray_chaplain.ogg',60,TRUE)
	UnregisterSignal(exorcised_movable, list(COMSIG_ATOM_RELAYMOVE, COMSIG_BIBLE_SMACKED))
	RegisterSignal(exorcised_movable, COMSIG_ITEM_ATTACK_SELF, .proc/on_attack_self)
	to_chat(bound_spirit, "<span class='userdanger'>You were exorcised!</span>")
	QDEL_NULL(bound_spirit)
	exorcised_movable.name = initial(exorcised_movable.name)
	exorcist.visible_message("<span class='notice'>[exorcist] exorcises [exorcised_movable]!</span>", \
						"<span class='notice'>You successfully exorcise [exorcised_movable]!</span>")
	return COMSIG_END_BIBLE_CHAIN

///signal fired from parent being destroyed
/datum/component/spirit_holding/proc/on_destroy(datum/source)
	SIGNAL_HANDLER
	to_chat(bound_spirit, "<span class='userdanger'>You were destroyed!</span>")
	QDEL_NULL(bound_spirit)
