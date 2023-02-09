/obj/item/plate
	name = "тарелка"
	desc = "На неё можно положить еду. Хорошо подходит для поднятия настроения, ведь вам не приходится есть с пола."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "plate"
	w_class = WEIGHT_CLASS_BULKY //No backpack.
	///How many things fit on this plate?
	var/max_items = 8
	///The offset from side to side the food items can have on the plate
	var/max_x_offset = 4
	///The max height offset the food can reach on the plate
	var/max_height_offset = 5
	///Offset of where the click is calculated from, due to how food is positioned in their DMIs.
	var/placement_offset = -12


/obj/item/plate/attackby(obj/item/I, mob/user, params)
	if(!IS_EDIBLE(I))
		to_chat(user, span_notice("[src] для еды и только для еды!"))
		return
	if(contents.len >= max_items)
		to_chat(user, span_notice("[src] полная!"))
		return
	var/list/modifiers = params2list(params)
	//Center the icon where the user clicked.
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return
	if(user.transferItemToLoc(I, src, silent = FALSE))
		I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -max_x_offset, max_x_offset)
		I.pixel_y = min(text2num(LAZYACCESS(modifiers, ICON_Y)) + placement_offset, max_height_offset)
		to_chat(user, span_notice("Положил [I] на [src]."))
		AddToPlate(I, user)
	else
		return ..()

/obj/item/plate/pre_attack(atom/A, mob/living/user, params)
	if(!iscarbon(A))
		return
	if(!contents.len)
		return
	var/obj/item/object_to_eat = contents[1]
	A.attackby(object_to_eat, user)
	return TRUE //No normal attack

///This proc adds the food to viscontents and makes sure it can deregister if this changes.
/obj/item/plate/proc/AddToPlate(obj/item/item_to_plate)
	vis_contents += item_to_plate
	item_to_plate.flags_1 |= IS_ONTOP_1
	item_to_plate.vis_flags |= VIS_INHERIT_PLANE
	RegisterSignal(item_to_plate, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_plate, COMSIG_PARENT_QDELETING, PROC_REF(ItemMoved))
	// We gotta offset ourselves via pixel_w/z, so we don't end up z fighting with the plane
	item_to_plate.pixel_w = item_to_plate.pixel_x
	item_to_plate.pixel_z = item_to_plate.pixel_y
	item_to_plate.pixel_x = 0
	item_to_plate.pixel_y = 0
	update_icon()

///This proc cleans up any signals on the item when it is removed from a plate, and ensures it has the correct state again.
/obj/item/plate/proc/ItemRemovedFromPlate(obj/item/removed_item)
	removed_item.flags_1 &= ~IS_ONTOP_1
	removed_item.vis_flags &= ~VIS_INHERIT_PLANE
	vis_contents -= removed_item
	UnregisterSignal(removed_item, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	// Resettt
	removed_item.pixel_x = removed_item.pixel_w
	removed_item.pixel_y = removed_item.pixel_z
	removed_item.pixel_w = 0
	removed_item.pixel_z = 0

///This proc is called by signals that remove the food from the plate.
/obj/item/plate/proc/ItemMoved(obj/item/moved_item, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromPlate(moved_item)
