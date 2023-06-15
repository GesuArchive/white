/atom/movable/screen/movable/action_button
	var/datum/action/linked_action
	var/datum/hud/our_hud
	var/actiontooltipstyle = ""
	screen_loc = null

	/// The icon state of our active overlay, used to prevent re-applying identical overlays
	var/active_overlay_icon_state
	/// The icon state of our active underlay, used to prevent re-applying identical underlays
	var/active_underlay_icon_state
	/// The overlay we have overtop our button
	var/mutable_appearance/button_overlay

	/// Where we are currently placed on the hud. SCRN_OBJ_DEFAULT asks the linked action what it thinks
	var/location = SCRN_OBJ_DEFAULT
	/// A unique bitflag, combined with the name of our linked action this lets us persistently remember any user changes to our position
	var/id
	/// A weakref of the last thing we hovered over
	/// God I hate how dragging works
	var/datum/weakref/last_hovored_ref

/atom/movable/screen/movable/action_button/Destroy()
	if(our_hud)
		var/mob/viewer = our_hud.mymob
		our_hud.hide_action(src)
		viewer?.client?.screen -= src
		linked_action.viewers -= our_hud
		viewer.update_action_buttons()
		our_hud = null
	linked_action = null
	return ..()

/atom/movable/screen/movable/action_button/proc/can_use(mob/user)
	if(isobserver(user))
		var/mob/dead/observer/dead_mob = user
		if(dead_mob.observetarget) // Observers can only click on action buttons if they're not observing something
			return FALSE

	if(linked_action)
		if(linked_action.viewers[user.hud_used])
			return TRUE
		return FALSE

	return TRUE

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if (!can_use(usr))
		return FALSE

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		var/datum/hud/our_hud = usr.hud_used
		our_hud.position_action(src, SCRN_OBJ_DEFAULT)
		return TRUE
	if(usr.next_click > world.time)
		return
	usr.next_click = world.time + 1
	var/trigger_flags
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		trigger_flags |= TRIGGER_SECONDARY_ACTION
	linked_action.Trigger(trigger_flags = trigger_flags)
	return TRUE

// Entered and Exited won't fire while you're dragging something, because you're still "holding" it
// Very much byond logic, but I want nice behavior, so we fake it with drag
/atom/movable/screen/movable/action_button/MouseDrag(atom/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!can_use(usr))
		return
	if(IS_WEAKREF_OF(over_object, last_hovored_ref))
		return
	var/atom/old_object
	if(last_hovored_ref)
		old_object = last_hovored_ref?.resolve()
	else // If there's no current ref, we assume it was us. We also treat this as our "first go" location
		old_object = src
		var/datum/hud/our_hud = usr.hud_used
		our_hud?.generate_landings(src)

	if(old_object)
		old_object.MouseExited(over_location, over_control, params)

	last_hovored_ref = WEAKREF(over_object)
	over_object.MouseEntered(over_location, over_control, params)

/atom/movable/screen/movable/action_button/MouseEntered(location, control, params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr, src, params, title = name, content = desc, theme = actiontooltipstyle)

/atom/movable/screen/movable/action_button/MouseExited(location, control, params)
	closeToolTip(usr)
	return ..()

/atom/movable/screen/movable/action_button/MouseDrop(over_object)
	last_hovored_ref = null
	if(!can_use(usr))
		return
	var/datum/hud/our_hud = usr.hud_used
	if(over_object == src)
		our_hud.hide_landings()
		return
	if(istype(over_object, /atom/movable/screen/action_landing))
		var/atom/movable/screen/action_landing/reserve = over_object
		reserve.hit_by(src)
		our_hud.hide_landings()
		save_position()
		return

	our_hud.hide_landings()
	if(istype(over_object, /atom/movable/screen/movable/action_button))
		var/atom/movable/screen/movable/action_button/button = over_object
		our_hud.position_action_relative(src, button)
		save_position()
		return
	. = ..()
	our_hud.position_action(src, screen_loc)
	save_position()

/atom/movable/screen/movable/action_button/proc/save_position()
	var/mob/user = our_hud.mymob
	if(!user?.client)
		return
	var/position_info = ""
	switch(location)
		if(SCRN_OBJ_FLOATING)
			position_info = screen_loc
		if(SCRN_OBJ_IN_LIST)
			position_info = SCRN_OBJ_IN_LIST

	user.client.prefs.action_buttons_screen_locs["[name]_[id]"] = position_info

/atom/movable/screen/movable/action_button/proc/load_position()
	var/mob/user = our_hud.mymob
	if(!user)
		return
	var/position_info = user.client?.prefs?.action_buttons_screen_locs["[name]_[id]"] || SCRN_OBJ_DEFAULT
	user.hud_used.position_action(src, position_info)

/atom/movable/screen/movable/action_button/proc/dump_save()
	var/mob/user = our_hud.mymob
	if(!user?.client)
		return
	user.client.prefs.action_buttons_screen_locs -= "[name]_[id]"

/**
 * This is a silly proc used in hud code code to determine what icon and icon state we should be using
 * for hud elements (such as action buttons) that don't have their own icon and icon state set.
 *
 * It returns a list, which is pretty much just a struct of info
 */
/datum/hud/proc/get_action_buttons_icons()
	. = list()
	.["bg_icon"] = ui_style
	.["bg_state"] = "template"
	.["bg_state_active"] = "template_active"

/**
 * Updates all action buttons this mob has.
 *
 * Arguments:
 * * update_flags - Which flags of the action should we update
 * * force - Force buttons update even if the given button icon state has not changed
 */
/mob/proc/update_mob_action_buttons(update_flags = ALL, force = FALSE)
	for(var/datum/action/current_action as anything in actions)
		current_action.build_all_button_icons(update_flags, force)

/**
 * This proc handles adding all of the mob's actions to their screen
 *
 * If you just need to update existing buttons, use [/mob/proc/update_mob_action_buttons]!
 *
 * Arguments:
 * * update_flags - reload_screen - bool, if TRUE, this proc will add the button to the screen of the passed mob as well
 */
/mob/proc/update_action_buttons(reload_screen = FALSE)
	if(!hud_used || !client)
		return

	if(hud_used.hud_shown != HUD_STYLE_STANDARD)
		return

	for(var/datum/action/action as anything in actions)
		var/atom/movable/screen/movable/action_button/button = action.viewers[hud_used]
		action.build_all_button_icons()
		if(reload_screen)
			client.screen += button

	if(reload_screen)
		hud_used.update_our_owner()

/**
 * Show (most) of the another mob's action buttons to this mob
 *
 * Used for observers viewing another mob's screen
 */
/mob/proc/show_other_mob_action_buttons(mob/take_from)
	if(!hud_used || !client)
		return

	for(var/datum/action/action as anything in take_from.actions)
		if(!action.show_to_observers)
			continue
		action.GiveAction(src)
	RegisterSignal(take_from, COMSIG_MOB_GRANTED_ACTION, PROC_REF(on_observing_action_granted))
	RegisterSignal(take_from, COMSIG_MOB_REMOVED_ACTION, PROC_REF(on_observing_action_removed))

/**
 * Hide another mob's action buttons from this mob
 *
 * Used for observers viewing another mob's screen
 */
/mob/proc/hide_other_mob_action_buttons(mob/take_from)
	for(var/datum/action/action as anything in take_from.actions)
		action.HideFrom(src)
	UnregisterSignal(take_from, list(COMSIG_MOB_GRANTED_ACTION, COMSIG_MOB_REMOVED_ACTION))

/// Signal proc for [COMSIG_MOB_GRANTED_ACTION] - If we're viewing another mob's action buttons,
/// we need to update with any newly added buttons granted to the mob.
/mob/proc/on_observing_action_granted(mob/living/source, datum/action/action)
	SIGNAL_HANDLER

	if(!action.show_to_observers)
		return
	action.GiveAction(src)

/// Signal proc for [COMSIG_MOB_REMOVED_ACTION] - If we're viewing another mob's action buttons,
/// we need to update with any removed buttons from the mob.
/mob/proc/on_observing_action_removed(mob/living/source, datum/action/action)
	SIGNAL_HANDLER

	action.HideFrom(src)

/// Exists so you have a place to put your buttons when you move them around
/atom/movable/screen/action_landing
	name = "ПРОСТРАНСТВО КНОПОК"
	desc = "<b>Перемещай</b> кнопки сюда, <br>чтобы добавить их в группу"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "reserved"
	// We want our whole 32x32 space to be clickable, so dropping's forgiving
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/datum/action_group/owner

/atom/movable/screen/action_landing/Destroy()
	if(owner)
		owner.landing = null
		owner?.owner?.mymob?.client?.screen -= src
		owner.refresh_actions()
		owner = null
	return ..()

/atom/movable/screen/action_landing/proc/set_owner(datum/action_group/owner)
	src.owner = owner
	refresh_owner()

/atom/movable/screen/action_landing/proc/refresh_owner()
	var/datum/hud/our_hud = owner.owner
	var/mob/viewer = our_hud.mymob
	if(viewer.client)
		viewer.client.screen |= src

	//var/list/settings = our_hud.get_action_buttons_icons()
	//icon = settings["bg_icon"]

/// Reacts to having a button dropped on it
/atom/movable/screen/action_landing/proc/hit_by(atom/movable/screen/movable/action_button/button)
	var/datum/hud/our_hud = owner.owner
	our_hud.position_action(button, owner.location)
