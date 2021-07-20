/datum/ai_behavior/carbon_ballistic_reload
	var/ballistic_target_key
	var/reloading_hand = LEFT_HANDS

	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/ballistic/B

/datum/ai_behavior/carbon_ballistic_reload/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	carbon_pawn = controller.pawn
	B = controller.blackboard[ballistic_target_key]

	carbon_pawn.swap_hand(reloading_hand)

	if(istype(B.magazine, /obj/item/ammo_box/magazine/internal))
		var/obj/item/ammo_box/magazine/internal/intmag = B.magazine
		if(intmag.multiload)
			for(var/obj/item/ammo_box/box in (carbon_pawn.contents | view(1, carbon_pawn)))
				if(!box.stored_ammo.len || box.ammo_type != intmag.ammo_type)
					continue
				if(do_reloading(box))
					finish_action(controller, TRUE)
					return

		var/found_live_casing = FALSE
		for(var/obj/item/ammo_casing/casing in (carbon_pawn.contents | view(1, carbon_pawn)))
			if(!casing.BB || casing.type != intmag.ammo_type)
				continue
			found_live_casing = TRUE
			do_reloading(casing)

		finish_action(controller, found_live_casing)
		return
	else
		var/obj/item/ammo_box/magazine/newmag
		var/last_ammo_count = 0
		for(var/obj/item/ammo_box/magazine/mag in (carbon_pawn.contents | view(1, carbon_pawn)))
			if(mag.type != B.mag_type)
				continue
			var/cur_count = mag.ammo_count(FALSE)
			if(cur_count > last_ammo_count)
				last_ammo_count = cur_count
				newmag = mag
		if(!newmag)
			finish_action(controller, FALSE)
			return
		B.eject_magazine(carbon_pawn)
		if(do_reloading(newmag))
			finish_action(controller, TRUE)
			return
	finish_action(controller, FALSE)
	return

/datum/ai_behavior/carbon_ballistic_reload/proc/do_reloading(obj/item/reloading_item)
	if(istype(B, /obj/item/gun/ballistic/rifle) && !B.bolt_locked)
		B.attack_self(carbon_pawn)
	if(carbon_pawn.dropItemToGround(carbon_pawn.get_item_for_held_index(reloading_hand)))
		carbon_pawn.put_in_hand(reloading_item, reloading_hand, FALSE, FALSE)
		B.attackby(reloading_item, carbon_pawn)
		return TRUE
	return FALSE

/datum/ai_behavior/carbon_ballistic_reload/finish_action(datum/ai_controller/controller, success)
	. = ..()
	if(success)
		if(B.bolt_type == BOLT_TYPE_STANDARD)
			B.attack_self(carbon_pawn)

	controller.blackboard[ballistic_target_key] = null

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_energy_charger_reload
	var/energy_target_key
	var/charger_target_key
	var/gun_hand = LEFT_HANDS

	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/energy/E

/datum/ai_behavior/carbon_energy_charger_reload/perform(delta_time, datum/ai_controller/controller)
	. = ..()

/datum/ai_behavior/carbon_energy_charger_reload/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
