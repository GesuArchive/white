/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

// The default UI style is the first one in the list
GLOBAL_LIST_INIT(available_ui_styles, list(
	"Oxide" = 'icons/hud/screen_oxide.dmi',
	"Rexide" = 'icons/hud/screen_rexide.dmi',
	"Glory" = 'icons/hud/screen_glory.dmi',
	"Cyberspess" = 'icons/hud/screen_cyberspess.dmi',
	"Tetramon" = 'icons/hud/screen_tetramon.dmi',
	"Bassboosted" = 'icons/hud/screen_bassboosted.dmi',
	"Midnight" = 'icons/hud/screen_midnight.dmi',
	"Retro" = 'icons/hud/screen_retro.dmi',
	"Plasmafire" = 'icons/hud/screen_plasmafire.dmi',
	"Slimecore" = 'icons/hud/screen_slimecore.dmi',
	"Operative" = 'icons/hud/screen_operative.dmi',
	"Clockwork" = 'icons/hud/screen_clockwork.dmi',
	"Glass" = 'icons/hud/screen_glass.dmi',
	"Trasen-Knox" = 'icons/hud/screen_trasenknox.dmi',
	"Syndiekats" = 'icons/hud/screen_syndiekats.dmi',
	"Neoscreen" = 'icons/hud/neoscreen.dmi'
))

/proc/ui_style2icon(ui_style)
	return GLOB.available_ui_styles[ui_style] || GLOB.available_ui_styles[GLOB.available_ui_styles["Neoscreen"]]

/datum/hud
	var/mob/mymob

	var/hud_shown = TRUE //Used for the HUD toggle (F12)
	var/hud_version = HUD_STYLE_STANDARD //Current displayed version of the HUD
	var/inventory_shown = FALSE //Equipped item inventory
	var/hotkey_ui_hidden = FALSE //This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/atom/movable/screen/ling/chems/lingchemdisplay
	var/atom/movable/screen/ling/sting/lingstingdisplay

	var/atom/movable/screen/bloodsucker/blood_counter/blood_display
	var/atom/movable/screen/bloodsucker/rank_counter/vamprank_display
	var/atom/movable/screen/bloodsucker/sunlight_counter/sunlight_display

	var/atom/movable/screen/ammo_counter

	var/atom/movable/screen/blobpwrdisplay

	var/atom/movable/screen/keeper_magic_display

	var/atom/movable/screen/alien_plasma_display
	var/atom/movable/screen/alien_queen_finder

	var/atom/movable/screen/combo/combo_display

	var/atom/movable/screen/fixeye/fixeye

	var/atom/movable/screen/action_intent
	var/atom/movable/screen/zone_sel/zone_select
	var/atom/movable/screen/pull_icon
	var/atom/movable/screen/rest_icon
	var/atom/movable/screen/throw_icon
	var/atom/movable/screen/module_store_icon

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/atom/movable/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)
	/// Screen objects that never exit view.
	var/list/always_visible_inventory = list()
	var/list/inv_slots[SLOTS_AMT] // /atom/movable/screen/inventory objects, ordered by their slot ID.
	var/list/hand_slots // /atom/movable/screen/inventory/hand objects, assoc list of "[held_index]" = object

	/// Assoc list of key => "plane master groups"
	/// This is normally just the main window, but it'll occasionally contain things like spyglasses windows
	var/list/datum/plane_master_group/master_groups = list()
	///Assoc list of controller groups, associated with key string group name with value of the plane master controller ref
	var/list/atom/movable/plane_master_controller/plane_master_controllers = list()

	/// Think of multiz as a stack of z levels. Each index in that stack has its own group of plane masters
	/// This variable is the plane offset our mob/client is currently "on"
	/// We use it to track what we should show/not show
	/// Goes from 0 to the max (z level stack size - 1)
	var/current_plane_offset = 0

	/// If this client is being shown atmos debug overlays or not
	var/atmos_debug_overlays = FALSE

	var/atom/movable/screen/movable/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = FALSE

	var/datum/action_group/listed/listed_actions
	var/list/floating_actions

	var/atom/movable/screen/weather

	var/atom/movable/screen/healths
	var/atom/movable/screen/stamina
	var/atom/movable/screen/healthdoll
	var/atom/movable/screen/tooltip/tooltip
	var/atom/movable/screen/timelimit/timelimit
	var/atom/movable/screen/wanted/wanted_lvl
	var/atom/movable/screen/spacesuit
	var/atom/movable/screen/station_height/station_height
	var/atom/movable/screen/station_height_bg/station_height_bg
	var/atom/movable/screen/typer/typer

	var/atom/movable/screen/human/equip/equip_hud

	// subtypes can override this to force a specific UI style
	var/ui_style
	var/retro_hud = FALSE

/datum/hud/New(mob/owner)
	mymob = owner

	if(mymob?.client?.prefs?.retro_hud && !isovermind(owner)) // ебал костылём
		retro_hud = TRUE
		add_multiz_buttons(owner)
		INVOKE_ASYNC(mymob?.client, .client/verb/fit_viewport)

	if (!ui_style)
		// will fall back to the default if any of these are null
		ui_style = ui_style2icon(owner?.client?.prefs?.UI_style)

	hand_slots = list()

	var/datum/plane_master_group/main/main_group = new(PLANE_GROUP_MAIN)
	main_group.attach_to(src)

	tooltip = new /atom/movable/screen/tooltip()
	tooltip?.hud = src
	if (owner?.client?.prefs?.w_toggles & TOOLTIP_USER_POS)
		tooltip?.screen_loc = "BOTTOM+2,LEFT"
	infodisplay += tooltip

	if(SSviolence.active)
		timelimit = new /atom/movable/screen/timelimit()
		timelimit?.hud = src
		infodisplay += timelimit

	for(var/mytype in subtypesof(/atom/movable/plane_master_controller))
		var/atom/movable/plane_master_controller/controller_instance = new mytype(null, src)
		plane_master_controllers[controller_instance.name] = controller_instance

	owner.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/see_through_darkness)

	AddComponent(/datum/component/zparallax, owner.client)
	RegisterSignal(SSmapping, COMSIG_PLANE_OFFSET_INCREASE, PROC_REF(on_plane_increase))
	RegisterSignal(mymob, COMSIG_MOB_LOGIN, PROC_REF(client_refresh))
	RegisterSignal(mymob, COMSIG_MOB_LOGOUT, PROC_REF(clear_client))
	RegisterSignal(mymob, COMSIG_MOB_SIGHT_CHANGE, PROC_REF(update_sightflags))
	update_sightflags(mymob, mymob.sight, NONE)

	if(!isnewplayer(mymob) && !retro_hud)

		add_multiz_buttons(owner)

		var/atom/movable/screen/side_background
		var/atom/movable/screen/side_background_thing
		var/atom/movable/screen/bottom_background

		side_background = new /atom/movable/screen/side_background()
		side_background.hud = src
		infodisplay += side_background

		bottom_background = new /atom/movable/screen/bottom_background()
		bottom_background.hud = src
		infodisplay += bottom_background

		side_background_thing = new /atom/movable/screen/side_background/thing()
		side_background_thing.hud = src
		infodisplay += side_background_thing

/datum/hud/proc/client_refresh(datum/source)
	RegisterSignal(mymob.client, COMSIG_CLIENT_SET_EYE, PROC_REF(on_eye_change))
	on_eye_change(null, null, mymob.client.eye)

/datum/hud/proc/clear_client(datum/source)
	if(mymob.canon_client)
		UnregisterSignal(mymob.canon_client, COMSIG_CLIENT_SET_EYE)

/datum/hud/proc/on_eye_change(datum/source, atom/old_eye, atom/new_eye)
	SIGNAL_HANDLER
	if(old_eye)
		UnregisterSignal(old_eye, COMSIG_MOVABLE_Z_CHANGED)
	if(new_eye)
		// By the time logout runs, the client's eye has already changed
		// There's just no log of the old eye, so we need to override
		// :sadkirby:
		RegisterSignal(new_eye, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(eye_z_changed), override = TRUE)
	eye_z_changed(new_eye)

/datum/hud/proc/update_sightflags(datum/source, new_sight, old_sight)
	// If neither the old and new flags can see turfs but not objects, don't transform the turfs
	// This is to ensure parallax works when you can't see holder objects
	if(should_sight_scale(new_sight) == should_sight_scale(old_sight))
		return

	for(var/group_key as anything in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.transform_lower_turfs(src, current_plane_offset)

/datum/hud/proc/should_use_scale()
	return should_sight_scale(mymob.sight)

/datum/hud/proc/should_sight_scale(sight_flags)
	return (sight_flags & (SEE_TURFS | SEE_OBJS)) != SEE_TURFS

/datum/hud/proc/eye_z_changed(atom/eye)
	SIGNAL_HANDLER
	var/turf/eye_turf = get_turf(eye)
	var/new_offset = GET_TURF_PLANE_OFFSET(eye_turf)
	if(current_plane_offset == new_offset)
		return
	var/old_offset = current_plane_offset
	current_plane_offset = new_offset

	SEND_SIGNAL(src, COMSIG_HUD_OFFSET_CHANGED, old_offset, new_offset)
	if(should_use_scale())
		for(var/group_key as anything in master_groups)
			var/datum/plane_master_group/group = master_groups[group_key]
			group.transform_lower_turfs(src, new_offset)

/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null

	QDEL_NULL(listed_actions)
	QDEL_LIST(floating_actions)
	QDEL_NULL(module_store_icon)
	QDEL_LIST(static_inventory)
	QDEL_NULL(fixeye)

	inv_slots.Cut()
	action_intent = null
	zone_select = null
	pull_icon = null
	rest_icon = null
	hand_slots.Cut()

	QDEL_LIST(toggleable_inventory)
	QDEL_LIST(hotkeybuttons)
	throw_icon = null
	QDEL_LIST(infodisplay)

	weather = null
	healths = null
	stamina = null
	healthdoll = null
	wanted_lvl = null
	spacesuit = null
	lingchemdisplay = null
	lingstingdisplay = null
	blobpwrdisplay = null
	keeper_magic_display = null
	alien_plasma_display = null
	alien_queen_finder = null
	combo_display = null

	QDEL_LIST_ASSOC_VAL(master_groups)
	QDEL_LIST_ASSOC_VAL(plane_master_controllers)
	QDEL_LIST(always_visible_inventory)
	mymob = null

	return ..()

/datum/hud/proc/on_plane_increase(datum/source, old_max_offset, new_max_offset)
	SIGNAL_HANDLER
	build_plane_groups(old_max_offset + 1, new_max_offset)

/// Creates the required plane masters to fill out new z layers (because each "level" of multiz gets its own plane master set)
/datum/hud/proc/build_plane_groups(starting_offset, ending_offset)
	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.build_plane_masters(starting_offset, ending_offset)

/// Returns the plane master that matches the input plane from the passed in group
/datum/hud/proc/get_plane_master(plane, group_key = PLANE_GROUP_MAIN)
	var/plane_key = "[plane]"
	var/datum/plane_master_group/group = master_groups[group_key]
	return group?.plane_masters[plane_key]

/// Returns a list of all plane masters that match the input true plane, drawn from the passed in group (ignores z layer offsets)
/datum/hud/proc/get_true_plane_masters(true_plane, group_key = PLANE_GROUP_MAIN)
	var/list/atom/movable/screen/plane_master/masters = list()
	for(var/plane in TRUE_PLANE_TO_OFFSETS(true_plane))
		masters += get_plane_master(plane, group_key)
	return masters

/// Returns all the planes belonging to the passed in group key
/datum/hud/proc/get_planes_from(group_key)
	var/datum/plane_master_group/group = master_groups[group_key]
	return group.plane_masters

/// Returns the corresponding plane group datum if one exists
/datum/hud/proc/get_plane_group(key)
	return master_groups[key]

/mob/proc/create_mob_hud()
	if(!client || hud_used)
		return
	set_hud_used(new hud_type(src))
	update_sight()
	SEND_SIGNAL(src, COMSIG_MOB_HUD_CREATED)

/mob/proc/set_hud_used(datum/hud/new_hud)
	hud_used = new_hud
	new_hud.build_action_groups()

/**
 * Shows this hud's hud to some mob
 *
 * Arguments
 * * version - denotes which style should be displayed. blank or 0 means "next version"
 * * viewmob - what mob to show the hud to. Can be this hud's mob, can be another mob, can be null (will use this hud's mob if so)
 */
/datum/hud/proc/show_hud(version = 0, mob/viewmob)
	if(!ismob(mymob))
		return FALSE
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return FALSE

	// This code is the absolute fucking worst, I want it to go die in a fire
	// Seriously, why
	screenmob.client.clear_screen()
	screenmob.client.apply_clickcatcher()

	var/display_hud_version = version
	if(!display_hud_version) //If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS) //If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1
	if(!retro_hud)
		screenmob.hud_used.inventory_shown = TRUE
		display_hud_version = HUD_STYLE_STANDARD

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD) //Default HUD
			hud_shown = TRUE //Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen += static_inventory
			if(toggleable_inventory.len && screenmob.hud_used && screenmob.hud_used.inventory_shown)
				screenmob.client.screen += toggleable_inventory
			if(hotkeybuttons.len && !hotkey_ui_hidden)
				screenmob.client.screen += hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay
			if(always_visible_inventory.len)
				screenmob.client.screen += always_visible_inventory

		if(HUD_STYLE_REDUCED) //Reduced HUD
			hud_shown = FALSE //Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay
			if(always_visible_inventory.len)
				screenmob.client.screen += always_visible_inventory

			//These ones are a part of 'static_inventory', 'toggleable_inventory' or 'hotkeybuttons' but we want them to stay
			for(var/h in hand_slots)
				var/atom/movable/screen/hand = hand_slots[h]
				if(hand)
					screenmob.client.screen += hand

		if(HUD_STYLE_NOHUD) //No HUD
			hud_shown = FALSE //Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen -= infodisplay
			if(always_visible_inventory.len)
				screenmob.client.screen += always_visible_inventory

	hud_version = display_hud_version
	persistent_inventory_update(screenmob)
	// Gives all of the actions the screenmob owes to their hud
	screenmob.update_action_buttons(TRUE)
	// Handles alerts - the things on the right side of the screen
	reorganize_alerts(screenmob)
	screenmob.reload_fullscreen()
	update_parallax_pref(screenmob)

	// ensure observers get an accurate and up-to-date view
	if (!viewmob)
		plane_masters_update()
		for(var/M in mymob.observers)
			show_hud(hud_version, M)
	else if (viewmob.hud_used)
		viewmob.hud_used.plane_masters_update()
		viewmob.show_other_mob_action_buttons(mymob)

	INVOKE_ASYNC(screenmob?.client, .client/verb/fit_viewport)

	SEND_SIGNAL(screenmob, COMSIG_MOB_HUD_REFRESHED, src)
	return TRUE

/datum/hud/proc/plane_masters_update()
	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		// Plane masters are always shown to OUR mob, never to observers
		group.refresh_hud()

/datum/hud/human/show_hud(version = 0,mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	hidden_inventory_update(screenmob)

/datum/hud/robot/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!.)
		return
	update_robot_modules_display()

/datum/hud/proc/hidden_inventory_update()
	return

/datum/hud/proc/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return

/datum/hud/proc/update_ui_style(new_ui_style)
	// do nothing if overridden by a subtype or already on that style
	if (initial(ui_style) || ui_style == new_ui_style)
		return

	if(!retro_hud)
		new_ui_style = GLOB.available_ui_styles["Neoscreen"]

	for(var/atom/item in static_inventory + toggleable_inventory + hotkeybuttons + infodisplay + always_visible_inventory + inv_slots)
		if (item.icon == ui_style)
			item.icon = new_ui_style

	ui_style = new_ui_style
	build_hand_slots(TRUE)

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = TRUE

	if(hud_used && client)
		hud_used.show_hud() //Shows the next hud preset
		to_chat(usr, span_info("Switched HUD mode. Press F12 to toggle."))
	else
		to_chat(usr, span_warning("This mob type does not use a HUD."))


//(re)builds the hand ui slots, throwing away old ones
//not really worth jugglying existing ones so we just scrap+rebuild
//9/10 this is only called once per mob and only for 2 hands
/datum/hud/proc/build_hand_slots(not_bottom = FALSE)
	for(var/h in hand_slots)
		var/atom/movable/screen/inventory/hand/H = hand_slots[h]
		if(H)
			static_inventory -= H
	hand_slots = list()
	var/atom/movable/screen/inventory/hand/hand_box
	for(var/i in 1 to mymob.held_items.len)
		hand_box = new /atom/movable/screen/inventory/hand()
		hand_box.name = mymob.get_held_index_name(i)
		hand_box.icon = ui_style
		hand_box.icon_state = "hand_[mymob.held_index_to_dir(i)]"
		hand_box.screen_loc = ui_hand_position(i, not_bottom)
		hand_box.held_index = i
		hand_slots["[i]"] = hand_box
		hand_box.hud = src
		static_inventory += hand_box
		hand_box.update_appearance()

	var/i = 1
	for(var/atom/movable/screen/swap_hand/SH in static_inventory)
		SH.screen_loc = ui_swaphand_position(mymob, !(i % 2) ? 2 : 1, not_bottom)
		i++
	for(var/atom/movable/screen/human/equip/E in static_inventory)
		E.screen_loc = ui_equip_position(mymob, not_bottom)

	if(ismob(mymob) && mymob.hud_used == src)
		show_hud(hud_version)

/datum/hud/proc/update_locked_slots()
	return

/datum/hud/proc/position_action(atom/movable/screen/movable/action_button/button, position)
	// This is kinda a hack, I'm sorry.
	// Basically, FLOATING is never a valid position to pass into this proc. It exists as a generic marker for manually positioned buttons
	// Not as a position to target
	if(position == SCRN_OBJ_FLOATING)
		return
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(position)
		if(SCRN_OBJ_DEFAULT) // Reset to the default
			button.dump_save() // Nuke any existing saves
			position_action(button, button.linked_action.default_button_position)
			return
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button)
		if(SCRN_OBJ_INSERT_FIRST)
			listed_actions.insert_action(button, index = 1)
			position = SCRN_OBJ_IN_LIST
		else // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			button.screen_loc = position
			position = SCRN_OBJ_FLOATING

	button.location = position

/datum/hud/proc/position_action_relative(atom/movable/screen/movable/action_button/button, atom/movable/screen/movable/action_button/relative_to)
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(relative_to.location)
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button, listed_actions.index_of(relative_to))
		if(SCRN_OBJ_FLOATING) // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			var/client/our_client = mymob.client
			if(!our_client)
				position_action(button, button.linked_action.default_button_position)
				return
			button.screen_loc = get_valid_screen_location(relative_to.screen_loc, world.icon_size, our_client.view_size.getView()) // Asks for a location adjacent to our button that won't overflow the map

	button.location = relative_to.location

/// Removes the passed in action from its current position on the screen
/datum/hud/proc/hide_action(atom/movable/screen/movable/action_button/button)
	switch(button.location)
		if(SCRN_OBJ_DEFAULT) // Invalid
			CRASH("We just tried to hide an action buttion that somehow has the default position as its location, you done fucked up")
		if(SCRN_OBJ_FLOATING)
			floating_actions -= button
		if(SCRN_OBJ_IN_LIST)
			listed_actions.remove_action(button)
	button.screen_loc = null

/// Generates visual landings for all groups that the button is not a memeber of
/datum/hud/proc/generate_landings(atom/movable/screen/movable/action_button/button)
	listed_actions.generate_landing()

/// Clears all currently visible landings
/datum/hud/proc/hide_landings()
	listed_actions.clear_landing()

// Updates any existing "owned" visuals, ensures they continue to be visible
/datum/hud/proc/update_our_owner()
	listed_actions.update_landing()

/// Generates and fills new action groups with our mob's current actions
/datum/hud/proc/build_action_groups()
	listed_actions = new(src)
	floating_actions = list()
	for(var/datum/action/action as anything in mymob.actions)
		var/atom/movable/screen/movable/action_button/button = action.viewers[src]
		if(!button)
			action.ShowTo(mymob)
		else
			position_action(button, button.location)

/datum/action_group
	/// The hud we're owned by
	var/datum/hud/owner
	/// The actions we're managing
	var/list/atom/movable/screen/movable/action_button/actions
	/// Max amount of buttons we can have per row
	/// Indexes at 1
	var/column_max = 0
	/// How far "ahead" of the first row we start. Lets us "scroll" our rows
	/// Indexes at 1
	var/row_offset = 0
	/// How many rows of actions we can have at max before we just stop hiding
	/// Indexes at 1
	var/max_rows = INFINITY
	/// The screen location we go by
	var/location
	/// Our landing screen object
	var/atom/movable/screen/action_landing/landing

/datum/action_group/New(datum/hud/owner)
	..()
	actions = list()
	src.owner = owner

/datum/action_group/Destroy()
	owner = null
	QDEL_NULL(landing)
	QDEL_LIST(actions)
	return ..()

/datum/action_group/proc/insert_action(atom/movable/screen/action, index)
	if(action in actions)
		if(actions[index] == action)
			return
		actions -= action // Don't dupe, come on
	if(!index)
		index = length(actions) + 1
	index = min(length(actions) + 1, index)
	actions.Insert(index, action)
	refresh_actions()

/datum/action_group/proc/remove_action(atom/movable/screen/action)
	actions -= action
	refresh_actions()

/datum/action_group/proc/refresh_actions()

	// We don't use size() here because landings are not canon
	var/total_rows = ROUND_UP(length(actions) / column_max)
	total_rows -= max_rows // Lets get the amount of rows we're off from our max
	row_offset = clamp(row_offset, 0, total_rows) // You're not allowed to offset so far that we have a row of blank space

	var/button_number = 0
	for(var/atom/movable/screen/button as anything in actions)
		var/postion = ButtonNumberToScreenCoords(button_number )
		button.screen_loc = postion
		button_number++

	if(landing)
		var/postion = ButtonNumberToScreenCoords(button_number, landing = TRUE) // Need a good way to count buttons off screen, but allow this to display in the right place if it's being placed with no concern for dropdown
		landing.screen_loc = postion
		button_number++

/// Accepts a number represeting our position in the group, indexes at 0 to make the math nicer
/datum/action_group/proc/ButtonNumberToScreenCoords(number, landing = FALSE)
	var/row = round(number / column_max)
	row -= row_offset

	if(row < 0)
		return null

	if(row > max_rows - 1)
		row = max_rows
		number = row * column_max

	return "WEST+[(number - column_max * row)]:4,NORTH-[row]:-4"

/// Returns the amount of objects we're storing at the moment
/datum/action_group/proc/size()
	var/amount = length(actions)
	if(landing)
		amount += 1
	return amount

/datum/action_group/proc/index_of(atom/movable/screen/get_location)
	return actions.Find(get_location)

/// Generates a landing object that can be dropped on to join this group
/datum/action_group/proc/generate_landing()
	if(landing)
		return
	landing = new()
	landing.set_owner(src)
	refresh_actions()

/// Clears any landing objects we may currently have
/datum/action_group/proc/clear_landing()
	QDEL_NULL(landing)

/datum/action_group/proc/update_landing()
	if(!landing)
		return
	landing.refresh_owner()

/datum/action_group/proc/scroll(amount)
	row_offset += amount
	refresh_actions()

/datum/action_group/listed
	column_max = 16
	location = SCRN_OBJ_IN_LIST

/client/proc/debug_hud_icon()
	set name = "Debug Hud Icon"
	set category = "Дбг.Интерфейс"

	if(!check_rights(R_DEBUG))
		return

	var/datum/hud/our_hud = mob.hud_used
	var/list/all_the_huds = our_hud.infodisplay + our_hud.static_inventory + our_hud.toggleable_inventory + our_hud.hotkeybuttons
	var/icon/new_icon = input("New Hud Icon?", "Balls") as null|icon

	var/list/icon_list = list()

	for(var/atom/movable/screen/S in all_the_huds)
		icon_list |= S.icon

	var/right_icon = tgui_input_list(usr, "balls", "pens", icon_list)

	for(var/atom/movable/screen/S in all_the_huds)
		if(S.icon == right_icon)
			S.icon = new_icon
