/datum/action/item_action/vortex_recall
	name = "Вихревой отзыв"
	desc = "В любое время вызовите себя и всех, кто находится поблизости, на настроенный маяк иерофанта.<br>Если маяк все еще прикреплен, отсоедините его."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_recall"

/datum/action/item_action/vortex_recall/IsAvailable(feedback = FALSE)
	var/area/current_area = get_area(target)
	if(!current_area || current_area.area_flags & NOTELEPORT)
		return FALSE
	if(istype(target, /obj/item/hierophant_club))
		var/obj/item/hierophant_club/teleport_stick = target
		if(teleport_stick.teleporting)
			return FALSE
	return ..()
