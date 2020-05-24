/obj/item/clothing/glasses/monocle/map
	name = "amplification lens"
	var/ui_x = 350
	var/ui_y = 350
	//desc = "Такой красивый окуляр!"

	//спижжено с консоли камер
	var/map_name
	var/const/default_map_size = 15
	var/obj/screen/map_view/cam_screen
	var/obj/screen/plane_master/lighting/cam_plane_master
	var/obj/screen/background/cam_background

	var/map_range = 12

/obj/item/clothing/glasses/monocle/map/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == ITEM_SLOT_EYES)
		ui_interact(user)
		START_PROCESSING(SSfastprocess, src)

/obj/item/clothing/glasses/monocle/map/interact(mob/user)
	return FALSE

/obj/item/clothing/glasses/monocle/map/Initialize()
	. = ..()
	map_name = "monocle_[REF(src)]_map"

	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_plane_master = new
	cam_plane_master.name = "plane_master"
	cam_plane_master.assigned_map = map_name
	cam_plane_master.del_on_map_removal = FALSE
	cam_plane_master.screen_loc = "[map_name]:CENTER"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

/obj/item/clothing/glasses/monocle/map/Destroy()
	STOP_PROCESSING(SSfastprocess, src)

	qdel(cam_screen)
	qdel(cam_plane_master)
	qdel(cam_background)
	return ..()

/obj/item/clothing/glasses/monocle/map/process()
	if(!iscarbon(loc))
		return PROCESS_KILL
	var/mob/living/carbon/C = loc
	ui_interact(C)
	if(C.glasses != src)
		return PROCESS_KILL

/obj/item/clothing/glasses/monocle/map/ui_interact(\
		mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
		datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		user.client.register_map_obj(cam_screen)
		user.client.register_map_obj(cam_plane_master)
		user.client.register_map_obj(cam_background)

		ui = new(user, src, ui_key, "MapWindow", name, ui_x, ui_y, master_ui, state)
		ui.open()

	var/list/visible_turfs = list()
	for(var/turf/T in view(map_range, user))
		visible_turfs += T

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

/obj/item/clothing/glasses/monocle/map/ui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	return data

/obj/item/clothing/glasses/monocle/map/ui_close(mob/user)
	if(user && user.client)
		user.client.clear_map(map_name)

/obj/item/clothing/glasses/monocle/map/ui_status(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.glasses != src)
			. = UI_CLOSE
