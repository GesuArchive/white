//ass blast goonstation

/obj/item/mechcomp
	name = "base MechComp component"
	desc = "Holds the basic functionality for the MechComp components. Does nothing, and you should not be seeing this."
	icon = 'white/RedFoxIV/icons/obj/mechcomp.dmi'


	/**
	 * A crutch to use the goon mechcomp sprites, because goon iconstate 
	 * format for mechcomp is [compname] for unanchored and u[compname] for anchored components.
	 * 
	 * Avoid editing it in runtime as it should (?) hold the "initial" value at all times. Use update_icon_state instead,
	 * it also handles all the logic regarding anchored/unanchored sprites.
	 **/
	var/part_icon_state = "generic"
	/**
	 * if the component has a smaller sprite for when it's anchored to the floor.
	 **/ 
	var/has_compact_icon_state = FALSE
	/**
	 * icon state for when the component is active.
	 * Currently unused. Too bad!
	 **/
	var/active_icon_state

	/**
	 * If the current component is active, i.e. performing some work.
	 **/
	var/active = FALSE


	/**
	 * DO NOT FUCKING TOUCH THIS REEEE! use update_icon_state("compname") instead.
	 * Yes, even if you want your component to chance icon when it's active. 
	 **/
	icon_state = null

/**
 * Another part to the gooncode crutch adaptation. 
 * Use it to actually change icon_state, instead of accessing icon_state or part_icon_state directly.
 **/
/obj/item/mechcomp/update_icon_state(var/part_icon_state)
	. = ..()
	icon_state = "[src.anchored && src.has_compact_icon_state ? "u" : ""][part_icon_state]"


/obj/item/mechcomp/Initialize()
	. = ..()
	update_icon_state(part_icon_state)

/obj/item/mechcomp/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/mechanics_holder)


/**
 * Called when a user clicks the component with an empty hand.
 * Moved to a separate proc for easier handling of active/inactive states.
 * ---DO NOT FUCKING FORGET to set active var to FALSE before returning.
 **/
/obj/item/mechcomp/proc/interact_by_hand(mob/user)
	active = FALSE
	return


/**
 * Called when a user clicks the component with an item while not on harm intent.
 * Moved to a separate proc for easier handling of active/inactive states.
 * ---DO NOT FUCKING FORGET to set active var to FALSE before returning.
 **/
/obj/item/mechcomp/proc/interact_by_item(mob/user)
	active = FALSE
	return


/**
 * If you don't care for preventing activation whilre your component before your component stops being active 
 * AND you really hate the activate_by_hand proc, you can override this one, i guess. ¯\_(ツ)_/¯
 * Not recommended for consistency's sake just throw a ..() or active = FALSE at the very beginning of the interact_by_hand.
 **/
/obj/item/mechcomp/attack_hand(mob/user)
	. = ..()
	if(!active)
		active = TRUE
		interact_by_hand(user)

/**
 * If you don't care for preventing activation whilre your component before your component stops being active 
 * AND you really hate the activate_by_item proc, you can override this one too, i guess. ¯\_(ツ)_/¯
 * Still not recommended for consistency's sake - just throw a ..() or active = FALSE at the very beginning of the interact_by_item.
 **/
/obj/item/mechcomp/attackby(obj/item/I, mob/living/user, params)
	//can't attack an /obj/item/ anyway, so might as well use harm intent for this stuff.
	if(user.a_intent == INTENT_HARM)
		. = ..() //also calls the COMSIG_PARENT_ATTACKBY, so the component handles the multitool stuff by itself.
		//i want to fucking die btw
		//this should probably be moved to another proc.
		if(I.tool_behaviour == TOOL_WRENCH)
			I.play_tool_sound(src, 100)
			set_anchored(!anchored)
			user.visible_message("<span class='notice'>[user] [anchored ? "прикручивает" : "откручивает"] [src.name].</span>", \
				"<span class='notice'>Я [anchored ? "прикручиваю [src.name] к полу" : "откручиваю [src.name] от пола"].</span>")
			update_icon_state(part_icon_state)

		return
	
	//should no go through if the user's intent is harm
	//this way stuff like item scanners can accept all items (like a fucking wrench) on the first 3 intents
	//AND still be wrenched (bypassing the scan) if on harm intent.
	if(!active)
		active = TRUE
		interact_by_item(I, user)


///no touchy
/obj/item/mechcomp/MouseDrop_T(atom/_drop, mob/living/user)
	. = ..()

	if(!istype(_drop,/obj/item/mechcomp))
		return
	
	var/obj/item/mechcomp/drop = _drop
	if(!(src.anchored && drop.anchored))
		return

	SEND_SIGNAL(src,_COMSIG_MECHCOMP_DROPCONNECT, drop, user)


/**
 * here lies fancy radial menu stuff, that i wanted to use but didn't get to because signals in mechcomp don't actually have types like "strings" and "numbers".
 * R.I.P.
**/

/*
/obj/item/mechcomp/MouseDrop(atom/_over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!istype(over, /obj/item/mechcomp))
		return
	/*
	if(!isliving(usr))
		return
	var/mob/living/user = usr
	*/
	if(user.held_items[user.active_hand_index].tool_behaviour != TOOL_MULTITOOL)
		return
	
	var/obj/item/mechcomp/over = _over
	for(input in input_types)
		input_icons += list(input) = image(icon = input[1], icon_state = "[input[1] ? input[1] : "unknown"]")
	var/input_choice = show_radial_menu(user, src, list/choices, tooltips = TRUE)
	to_chat(user, "<span class='notice'>Подключаю вход \"[input_choice[2]]\" [src.name]...</span>")

	for(output in over.output_types)
		input_icons += list(input[2]) = image(icon = output[1], icon_state = "[output[1] ? output[1] : "unknown"]")
	var/output_choice = show_radial_menu(user, over, list/choices, tooltips = TRUE)
	to_chat(user, "<span class='notice'>...к выходу \"[output_choice[2]]\" [over.name].</span>")
*/