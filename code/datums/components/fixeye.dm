//Separates fixeye into it's own thing instead of tacking it on combat mode
/datum/component/fixeye
	var/fixeye_flags
	var/facedir
	var/hud_loc
	var/atom/movable/screen/fixeye/hud_icon

//Does stuff
/datum/component/fixeye/Initialize(hud_loc = UI_FIXEYE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.hud_loc = hud_loc

/datum/component/fixeye/Destroy(force, silent)
	. = ..()
	QDEL_NULL(hud_icon)

/datum/component/fixeye/RegisterWithParent()
	var/mob/living/source = parent
	RegisterSignal(source, COMSIG_FIXEYE_TOGGLE, PROC_REF(user_toggle_fixeye))
	RegisterSignal(source, COMSIG_FIXEYE_DISABLE, PROC_REF(safe_disable_fixeye))
	RegisterSignal(source, COMSIG_FIXEYE_ENABLE, PROC_REF(safe_enable_fixeye))
	RegisterSignal(source, COMSIG_FIXEYE_LOCK, PROC_REF(lock_fixeye))
	RegisterSignal(source, COMSIG_FIXEYE_UNLOCK, PROC_REF(unlock_fixeye))
	RegisterSignal(source, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(source, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	RegisterSignal(source, COMSIG_MOB_HUD_CREATED, PROC_REF(on_mob_hud_created))
	RegisterSignal(source, COMSIG_FIXEYE_CHECK, PROC_REF(check_flags))
	if(source.client)
		on_mob_hud_created(source)

/datum/component/fixeye/UnregisterFromParent()
	var/mob/source = parent
	UnregisterSignal(source, list(COMSIG_FIXEYE_TOGGLE, COMSIG_FIXEYE_DISABLE, COMSIG_FIXEYE_ENABLE, COMSIG_FIXEYE_LOCK, COMSIG_FIXEYE_UNLOCK, COMSIG_FIXEYE_CHECK))
	UnregisterSignal(source, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_HUD_CREATED))
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	source.client?.screen -= hud_icon
	source.hud_used?.fixeye = null
	source.hud_used?.infodisplay -= hud_icon
	QDEL_NULL(hud_icon)

///Creates the hud screen object.
/datum/component/fixeye/proc/on_mob_hud_created(mob/source)
	SIGNAL_HANDLER

	hud_icon = new
	hud_icon.hud = source.hud_used
	hud_icon.screen_loc = hud_loc
	source.hud_used?.fixeye = hud_icon
	hud_icon?.screen_loc = source.hud_used?.retro_hud ? UI_FIXEYE_RETRO : UI_FIXEYE
	if(source.hud_used?.retro_hud)
		hud_icon?.icon = 'icons/hud/screen_gen.dmi'
	source.hud_used?.infodisplay += hud_icon
	hud_icon.update_appearance()
	source.client?.screen |= hud_icon

//Toggles intentionally between on and off
/datum/component/fixeye/proc/user_toggle_fixeye(mob/living/source, silent = FALSE, forced = FALSE)
	SIGNAL_HANDLER

	if(CHECK_BITFIELD(fixeye_flags, FIXEYE_TOGGLED))
		safe_disable_fixeye(source, silent, forced)
	else if(source.stat == CONSCIOUS)
		safe_enable_fixeye(source, silent, forced)

//Lock fixeye on/off
/datum/component/fixeye/proc/lock_fixeye(mob/living/source)
	SIGNAL_HANDLER

	fixeye_flags |= FIXEYE_LOCKED
	return TRUE

//Unlock fixeye
/datum/component/fixeye/proc/unlock_fixeye(mob/living/source)
	SIGNAL_HANDLER

	fixeye_flags &= ~FIXEYE_LOCKED
	return TRUE

//Intentionally toggling on
/datum/component/fixeye/proc/safe_enable_fixeye(mob/living/source, silent = FALSE, forced = FALSE)
	SIGNAL_HANDLER

	if(CHECK_BITFIELD(fixeye_flags, FIXEYE_TOGGLED) && CHECK_BITFIELD(fixeye_flags, FIXEYE_ACTIVE))
		return TRUE
	else if(!forced && CHECK_BITFIELD(fixeye_flags, FIXEYE_LOCKED))
		return TRUE
	fixeye_flags |= FIXEYE_TOGGLED
	enable_fixeye(source, silent, forced)
	return TRUE

//Handles toggling on itself
/datum/component/fixeye/proc/enable_fixeye(mob/living/source, silent = TRUE, forced = TRUE)
	if(CHECK_BITFIELD(fixeye_flags, FIXEYE_ACTIVE))
		return
	fixeye_flags |= FIXEYE_ACTIVE
	fixeye_flags &= ~FIXEYE_INACTIVE
	SEND_SIGNAL(source, COMSIG_LIVING_FIXEYE_ENABLED, silent, forced)
	facedir = source.dir
	RegisterSignal(source, COMSIG_ATOM_PRE_DIR_CHANGE, PROC_REF(on_dir_change))
	RegisterSignal(source, COMSIG_MOB_CLIENT_MOVED, PROC_REF(on_client_move))
	RegisterSignal(source, COMSIG_MOB_CLICKON, PROC_REF(on_clickon))
	if(hud_icon)
		hud_icon.fixed_eye = TRUE
		hud_icon.update_appearance()

//Intentionally toggling off
/datum/component/fixeye/proc/safe_disable_fixeye(mob/living/source, silent = FALSE, forced = FALSE)
	SIGNAL_HANDLER

	if(!CHECK_BITFIELD(fixeye_flags, FIXEYE_TOGGLED) && !CHECK_BITFIELD(fixeye_flags, FIXEYE_ACTIVE))
		return TRUE
	else if(!forced && CHECK_BITFIELD(fixeye_flags, FIXEYE_LOCKED))
		return TRUE
	fixeye_flags &= ~FIXEYE_TOGGLED
	disable_fixeye(source, silent, forced)
	return TRUE

//Handles toggling off itself
/datum/component/fixeye/proc/disable_fixeye(mob/living/source, silent = TRUE, forced = TRUE)
	if(CHECK_BITFIELD(fixeye_flags, FIXEYE_INACTIVE))
		return
	fixeye_flags &= ~FIXEYE_ACTIVE
	fixeye_flags |= FIXEYE_INACTIVE
	facedir = null
	SEND_SIGNAL(source, COMSIG_LIVING_FIXEYE_DISABLED, silent, forced)
	UnregisterSignal(source, list(COMSIG_ATOM_PRE_DIR_CHANGE, COMSIG_MOB_CLIENT_MOVED, COMSIG_MOB_CLICKON))
	if(hud_icon)
		hud_icon.fixed_eye = FALSE
		hud_icon.update_appearance()

//Returns a field of flags that are contained in both the second arg and our bitfield variable.
/datum/component/fixeye/proc/check_flags(mob/living/source, flags)
	SIGNAL_HANDLER

	return CHECK_BITFIELD(fixeye_flags, flags)

//Disables fixeye upon death.
/datum/component/fixeye/proc/on_death(mob/living/source)
	SIGNAL_HANDLER

	safe_disable_fixeye(source)

//Disables fixeye upon logout
/datum/component/fixeye/proc/on_logout(mob/living/source)
	SIGNAL_HANDLER

	safe_disable_fixeye(source)

//Added movement delay if moving backward
/datum/component/fixeye/proc/on_client_move(mob/living/source, client/client, direction, newloc, oldloc, added_delay)
	SIGNAL_HANDLER

	if(oldloc != newloc && (direction & REVERSE_DIR(source.dir)))
		client.move_delay += added_delay*0.75

//Keep that fucking face right onwards
/datum/component/fixeye/proc/on_dir_change(mob/living/source, dir, newdir)
	SIGNAL_HANDLER

	//fixeye is essentially disabled while alt is held
	if(!CHECK_BITFIELD(fixeye_flags, FIXEYE_LOCKED) && source.client?.keys_held["Alt"])
		return

	return COMPONENT_NO_DIR_CHANGE

//Handles dir change when clicking
/datum/component/fixeye/proc/on_clickon(mob/living/source, atom/A, params)
	SIGNAL_HANDLER

	if(CHECK_BITFIELD(fixeye_flags, FIXEYE_LOCKED))
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, ALT_CLICK))
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		return

	if(istype(A, /atom/movable/screen))
		return
	else if(isitem(A))
		var/obj/item/item_atom = A
		if(item_atom.item_flags & IN_INVENTORY)
			return

	//This is stupid but it works
	UnregisterSignal(source, COMSIG_ATOM_PRE_DIR_CHANGE)
	var/new_dir = get_dir(source, A)
	if(!(new_dir in GLOB.cardinals))
		switch(new_dir)
			if(NORTHEAST)
				new_dir = NORTH
			if(NORTHWEST)
				new_dir = WEST
			if(SOUTHWEST)
				new_dir = SOUTH
			if(SOUTHEAST)
				new_dir = EAST
			else
				new_dir = NORTH
	source.setDir(new_dir)
	RegisterSignal(source, COMSIG_ATOM_PRE_DIR_CHANGE, PROC_REF(on_dir_change))
