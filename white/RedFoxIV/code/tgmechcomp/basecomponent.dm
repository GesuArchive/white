//ass blast goonstation

/obj/item/mechcomp
	name = "base MechComp component"
	desc = "Holds the basic functionality for the MechComp components. Does nothing, and you should not be seeing this."
	icon = 'white/RedFoxIV/icons/obj/mechcomp.dmi'

	var/last_anchored_by

	var/datum/component/mechanics_holder/compdatum

	/**
	 * A crutch to use the goon mechcomp sprites, because goon iconstate
	 * format for mechcomp is [compname] for unanchored and u[compname] for anchored components.
	 *
	 * Avoid editing it in runtime as it should (?) not change from the "initial" value.
	 * Override update_icon_state and call update_icon instead.
	 **/
	var/part_icon_state = "generic"

	///Icon state for when the component is active. If you do not have a sprite for this, keep it null.
	var/active_icon_state = null

	///if the component has a smaller sprite for when it's anchored to the floor.
	var/has_anchored_icon_state = FALSE

	///If the current component is active, i.e. performing some work.
	var/active = FALSE

	///cringe
	var/deactivatecb = CALLBACK()

	/**
	 * If only a single instance of a component is allowed to be anchored onto a tile.part_icon_state =
	 * Also resets it's own pixel_x and pixel_y vars when anchored so that it stays centered.part_icon_state =
	 **/
	var/only_one_per_tile = FALSE

	/**
	 * Set this to the same value as initial part_icon_state, or else the icon in right-click menu
	 * will break. For runtime updates, use update_icon_state("comp_ass") instead.
	 **/
	icon_state = "fixme"


/**
 * Another part to the gooncode crutch adaptation.
 * Use it to actually change icon_state, instead of accessing icon_state or part_icon_state directly.
 **/
/obj/item/mechcomp/update_icon_state()
	. = ..()
	icon_state = "[src.anchored && src.has_anchored_icon_state ? "u" : ""][!isnull(active_icon_state) && active ? "[active_icon_state]" : "[part_icon_state]"]"


/obj/item/mechcomp/Initialize()
	. = ..()
	update_icon()

/obj/item/mechcomp/ComponentInitialize()
	. = ..()
	compdatum = AddComponent(/datum/component/mechanics_holder)


/**
 * Called when a user clicks the component with an empty hand.
 * Moved to a separate proc for easier handling of active/inactive states.
 **/
/obj/item/mechcomp/proc/interact_by_hand(mob/user)
	return


/**
 * Called when a user clicks the component with an item while not on harm intent.
 * Moved to a separate proc for easier handling of active/inactive states.
 **/
/obj/item/mechcomp/proc/interact_by_item(obj/item/I, mob/user)
	return


/**
 * please no touch, use interact_by_hand instead!
 **/
/obj/item/mechcomp/attack_hand(mob/user)
	. = ..()
	if(anchored)
		interact_by_hand(user)

/**
 * please no touch, use interact_by_item instead!
 **/
/obj/item/mechcomp/attackby(obj/item/I, mob/living/user, params)
	//can't attack an /obj/item/ anyway, so might as well use harm intent for this stuff.
	if(user.a_intent == INTENT_HARM)
		. = ..() //also calls the COMSIG_PARENT_ATTACKBY, so the component handles the multitool stuff by itself.
		//i want to fucking die btw
		//this should probably be moved to another proc.
		if(I.tool_behaviour == TOOL_WRENCH)


			if(anchored && can_unanchor(user))
				unanchor(user)
			else if(!anchored && can_anchor(user))
				anchor(user)
		return

	//shouldn't get to this point if the user's intent is harm
	//this way stuff like item scanners can accept all items (like a fucking wrench) on the first 3 intents
	//AND still be wrenched (bypassing the scan) if on harm intent.
	if(anchored)
		interact_by_item(I, user)


///Returns true if anchoring is allowed, returns false if not.
/obj/item/mechcomp/proc/can_anchor(mob/living/user)
	if(only_one_per_tile)
		for(var/obj/item/mechcomp/i in get_turf(src))
			if(istype(i, src) && i.anchored)
				to_chat(user, "<span class='alert'>Cannot wrench two [src.name]s in one place! Pick a different spot for this one!</span>")
				return FALSE
		src.pixel_x = 0
		src.pixel_y = 0
	return TRUE

///Returns true if unanchoring is allowed, returns false if not.
/obj/item/mechcomp/proc/can_unanchor(mob/living/user)
	if (length(compdatum.connected_incoming) || length(compdatum.connected_outgoing))
		to_chat(user, "<span class='alert'>The locking bolts of [src.name] are locked in and do not budge! Disconnect all first!</span>")
		return FALSE
	//just in case we /somehow/ fucked up with the check
	SEND_SIGNAL(src, COMSIG_MECHCOMP_RM_ALL_CONNECTIONS)
	return TRUE

///handles the anchoring of component.
/obj/item/mechcomp/proc/anchor(mob/living/user)
	anchored = TRUE
	last_anchored_by = user
	playsound(src, 'sound/items/ratchet.ogg', 100, TRUE)
	user.visible_message("<span class='notice'>[user] прикручивает [src.name].</span>", \
		"<span class='notice'>Я прикручиваю [src.name] к полу.</span>")
	update_icon()

///handles the unanchoring of component.
/obj/item/mechcomp/proc/unanchor(mob/living/user)
	anchored = FALSE
	playsound(src, 'sound/items/ratchet.ogg', 100, TRUE)
	user.visible_message("<span class='notice'>[user] откручивает [src.name].</span>", \
		"<span class='notice'>Я откручиваю [src.name] от пола.</span>")
	update_icon()


//feels like a good idea to include these
/obj/item/mechcomp/Destroy()
	SEND_SIGNAL(src, COMSIG_MECHCOMP_RM_ALL_CONNECTIONS)
	. = ..()

/obj/item/mechcomp/proc/log_action(action)
	log_mechcomp("[initial(src.name)] at x=[src.x] y=[src.y] z=[src.z]: [action]. Last IO edit [last_io_edit()], last config edit: [last_config_edit()]")

/obj/item/mechcomp/proc/last_config_edit()
	//return list("user" = compdatum.last_edited_configs_by["user"], "action" = compdatum.last_edited_configs_by["action"])
	var/mob/user = compdatum.last_edited_configs_by["user"]
	return  "by [user?.ckey], [compdatum.last_edited_configs_by["action"]]"

/obj/item/mechcomp/proc/last_io_edit()
	//return list("user" = compdatum.last_edited_inputs_by["user"], "action" = compdatum.last_edited_inputs_by["action"])
	var/mob/user = compdatum.last_edited_configs_by["user"]
	return  "by [user?.ckey], [compdatum.last_edited_inputs_by["action"]]"

/**
 * Change the active var to TRUE and current icon to active_icon_state, it it's not null.area
 * If you want your mechcomp component to have a mandatory cooldown between activations, use a
 * if(active)
 *		return
 * construction in the beginning of your interact proc or signal handling proc.
 * The visual controls whether or not to apply active_icon_state. passing FALSE to it will result
 * in applying only cooldown without any sprite changes.
 **/
/obj/item/mechcomp/proc/activate_for(var/time, visual = TRUE)
	active = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/_deactivate), time)

/**internal, for callback stuff. Override if you want to do something when the cooldown from "activate_for()" ends.
 * You could also call it directly if you want to reset the cooldown sooner, just don't forget to call deltimer().
 **/
/obj/item/mechcomp/proc/_deactivate()
	active = FALSE
	update_icon()