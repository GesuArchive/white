/datum/ai_behavior/carbon_ballistic_reload
	var/ballistic_target_key
	var/reloading_hand = LEFT_HANDS

	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/ballistic/B

/datum/ai_behavior/carbon_ballistic_reload/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	carbon_pawn = controller.pawn
	B = controller.blackboard[ballistic_target_key]
	if(!B)
		finish_action(controller, FALSE)
		return

	carbon_pawn.swap_hand(reloading_hand)
	var/list/atom/accessible_atoms = carbon_pawn.get_contents() | view(1, carbon_pawn)
	for(var/obj/item/ammo_box/box in accessible_atoms)
		accessible_atoms |= box.stored_ammo

	if(B.internal_magazine)
		var/obj/item/ammo_box/magazine/internal/intmag = B.magazine
		if(intmag.multiload)
			for(var/obj/item/ammo_box/box in accessible_atoms)
				if(!box.stored_ammo.len || box.ammo_type != intmag.ammo_type)
					continue
				finish_action(controller, do_reloading(box))
				return

		finish_action(controller, try_load_casings(intmag, accessible_atoms))
		return
	else
		var/obj/item/ammo_box/magazine/newmag
		var/last_ammo_count = 0
		for(var/obj/item/ammo_box/magazine/mag in accessible_atoms)
			if(mag.type != B.mag_type)
				continue
			var/cur_count = mag.ammo_count(FALSE)
			if(cur_count > last_ammo_count)
				last_ammo_count = cur_count
				newmag = mag

		B.eject_magazine(carbon_pawn)
		if(newmag)
			finish_action(controller, do_reloading(newmag))
			return
		else
			var/obj/item/ammo_box/magazine/oldmag = locate(B.mag_type) in view(0, carbon_pawn)
			if(try_load_casings(oldmag, accessible_atoms))
				finish_action(controller, do_reloading(oldmag))
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

/datum/ai_behavior/carbon_ballistic_reload/proc/try_load_casings(obj/item/ammo_box/magazine/mag, list/atom/possible_casings)
	var/found_live_casing = FALSE
	for(var/obj/item/ammo_casing/casing in possible_casings)
		if(casing.type != mag.ammo_type || !casing.loaded_projectile)
			continue
		found_live_casing = TRUE
		do_reloading(casing)
	return found_live_casing

/datum/ai_behavior/carbon_ballistic_reload/finish_action(datum/ai_controller/controller, success)
	. = ..()
	if(success)
		if(B.bolt_type == BOLT_TYPE_STANDARD)
			B.attack_self(carbon_pawn)

	controller.blackboard[ballistic_target_key] = null

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/ai_behavior/carbon_energy_recharger_reload
	var/energy_target_key
	var/charger_target_key
	var/gun_hand = LEFT_HANDS

	var/mob/living/carbon/carbon_pawn
	var/obj/item/gun/energy/E

/datum/ai_behavior/carbon_energy_recharger_reload/perform(delta_time, datum/ai_controller/controller)
	. = ..()

/datum/ai_behavior/carbon_energy_recharger_reload/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
