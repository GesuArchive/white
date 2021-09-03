/datum/component/storage/concrete/multicompartment
	var/list/last_compartment_interactions = list()
	var/list/compartments = list()

/datum/component/storage/concrete/multicompartment/proc/init_compartment(name, max_items, max_w_class, max_combined_w_class)
	compartments[name] = list()
	compartments[name]["contents"] = list()
	compartments[name]["max_items"] = max_items
	compartments[name]["max_w_class"] = max_w_class
	//compartments[name]["max_combined_w_class"] = max_combined_w_class

/datum/component/storage/concrete/multicompartment/proc/try_insert_into_compartment(obj/item/I, compartment_name)
	if(!can_be_inserted(I, FALSE, null, compartment_name))
		return FALSE
	if(!handle_item_insertion(I, FALSE, null, null, compartment_name))
		return FALSE
	return TRUE

/datum/component/storage/concrete/multicompartment/can_be_inserted(obj/item/I, stop_messages, mob/M, compartment_name)
	if(!compartment_name && M && last_compartment_interactions[M])
		compartment_name = last_compartment_interactions[M]
	var/list/current_compartment = compartments[compartment_name]
	if(!current_compartment)
		return FALSE
	if(length(current_compartment["contents"]) + 1 > current_compartment["max_items"])
		return FALSE
	if(current_compartment["max_w_class"] < I.w_class)
		return FALSE
	return ..()

/datum/component/storage/concrete/multicompartment/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/M, datum/component/storage/remote, compartment_name)
	if(!compartment_name && M && last_compartment_interactions[M])
		compartment_name = last_compartment_interactions[M]
	if(!compartments[compartment_name])
		return FALSE
	. = ..()
	LAZYADD(compartments[compartment_name]["contents"], I)

/datum/component/storage/concrete/multicompartment/remove_from_storage(atom/movable/AM, atom/new_location)
	. = ..()
	for(var/compartment_name in compartments)
		if(AM in compartments[compartment_name]["contents"])
			LAZYREMOVE(compartments[compartment_name]["contents"], AM)
			break

/datum/component/storage/concrete/multicompartment/show_to(mob/M, compartment_name)
	if(!M.client)
		return FALSE
	if(!compartment_name)
		compartment_name = last_compartment_interactions[M]
		if(!compartment_name)
			return FALSE
	else
		last_compartment_interactions[M] = compartment_name
	if(!compartments[compartment_name])
		return FALSE
	var/list/current_compartmnet = compartments[compartment_name]["contents"]
	var/atom/real_location = real_location()
	if(M.active_storage != src && (M.stat == CONSCIOUS))
		for(var/obj/item/I in real_location)
			if(I.on_found(M))
				return FALSE
	if(M.active_storage)
		M.active_storage.hide_from(M)
	var/list/compartment_contents = real_location.contents & current_compartmnet
	orient2hud_multi(compartment_contents)
	M.client.screen |= boxes
	M.client.screen |= closer
	M.client.screen |= compartment_contents
	M.set_active_storage(src)
	LAZYOR(is_using, M)
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/mob_deleted)
	return TRUE

/datum/component/storage/concrete/multicompartment/proc/orient2hud_multi(list/current_compartmnet)
	var/adjusted_contents = current_compartmnet.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_numerical_stacking)
		numbered_contents = _process_numerical_display()
		adjusted_contents = numbered_contents.len

	var/columns = clamp(max_items, 1, screen_max_columns)
	var/rows = clamp(CEILING(adjusted_contents / columns, 1), 1, screen_max_rows)
	orient_objs_multi(rows, columns, numbered_contents, current_compartmnet)

/datum/component/storage/concrete/multicompartment/proc/orient_objs_multi(rows, cols, list/obj/item/numerical_display_contents, list/current_compartmnet)
	boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+cols-1]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	var/cx = screen_start_x
	var/cy = screen_start_y
	if(islist(numerical_display_contents))
		for(var/type in numerical_display_contents)
			var/datum/numbered_display/ND = numerical_display_contents[type]
			ND.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			ND.sample_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			ND.sample_object.maptext = MAPTEXT("<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>")
			ND.sample_object.plane = ABOVE_HUD_PLANE
			cx++
			if(cx - screen_start_x >= cols)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break
	else
		for(var/obj/O in current_compartmnet)
			if(QDELETED(O))
				continue
			O.mouse_opacity = MOUSE_OPACITY_OPAQUE //This is here so storage items that spawn with contents correctly have the "click around item to equip"
			O.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			O.maptext = ""
			O.plane = ABOVE_HUD_PLANE
			cx++
			if(cx - screen_start_x >= cols)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break
	closer.screen_loc = "[screen_start_x + cols]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y]"
