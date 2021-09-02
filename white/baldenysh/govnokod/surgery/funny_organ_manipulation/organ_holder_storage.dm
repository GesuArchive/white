/datum/component/storage/concrete/organ_holder
	max_items = 14
	max_w_class = WEIGHT_CLASS_SMALL
	max_combined_w_class = 50
	rustle_sound = FALSE
	silent = TRUE
	var/list/last_zone_lookers = list()

/datum/component/storage/concrete/organ_holder/canreach_react(datum/source, list/next)
	. = ..()
	var/atom/A = parent
	if(ismob(A.loc))
		next += A.loc

/datum/component/storage/concrete/organ_holder/show_to(mob/M, zone)
	if(!M.client)
		return FALSE
	if(!zone)
		zone = last_zone_lookers[M]
	else
		last_zone_lookers[M] = zone
	var/atom/movable/organ_holder/real_location = real_location()
	if(M.active_storage != src && (M.stat == CONSCIOUS))
		for(var/obj/item/I in real_location)
			if(I.on_found(M))
				return FALSE
	if(M.active_storage)
		M.active_storage.hide_from(M)
	var/list/zonecontents = real_location.GetZoneContents(zone)
	orient2hud(zonecontents)
	M.client.screen |= boxes
	M.client.screen |= closer
	M.client.screen |= zonecontents
	M.set_active_storage(src)
	LAZYOR(is_using, M)
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/mob_deleted)
	return TRUE

/datum/component/storage/organ_holder/orient2hud(list/zonecontents)
	//var/atom/movable/organ_holder/real_location = real_location()
	var/adjusted_contents = zonecontents.len

	var/columns = clamp(max_items, 1, screen_max_columns)
	var/rows = clamp(CEILING(adjusted_contents / columns, 1), 1, screen_max_rows)
	orient_objs_from_list(rows, columns, zonecontents)

/datum/component/storage/organ_holder/proc/orient_objs_from_list(rows, cols, list/obj_list)
	boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+cols-1]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	var/cx = screen_start_x
	var/cy = screen_start_y
	for(var/obj/O in obj_list)
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
