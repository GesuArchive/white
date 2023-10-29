
/datum/action/item_action/cult_dagger
	name = "Создать кровавую руну"
	desc = "Используйте ритуальный кинжал, чтобы создать мощную кровавую руну"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"
	default_button_position = "6:157,4:-2"

/datum/action/item_action/cult_dagger/Grant(mob/grant_to)
	if(!IS_CULTIST(grant_to))
		Remove(owner)
		return

	return ..()

/datum/action/item_action/cult_dagger/Trigger(trigger_flags)
	for(var/obj/item/held_item as anything in owner.held_items) // In case we were already holding a dagger
		if(istype(held_item, /obj/item/melee/cultblade/dagger))
			held_item.attack_self(owner)
			return
	var/obj/item/target_item = target
	if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(target_item)
		owner.put_in_hands(target_item)
		target_item.attack_self(owner)
		return

	if(!isliving(owner))
		to_chat(owner, span_warning("Мне не хватает необходимой жизненной силы для этого действия."))
		return

	var/mob/living/living_owner = owner
	if (living_owner.usable_hands <= 0)
		to_chat(living_owner, span_warning("Как я буду делать это без рук?"))
	else
		to_chat(living_owner, span_warning("Мои руки заняты!"))
