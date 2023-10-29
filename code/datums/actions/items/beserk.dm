
/datum/action/item_action/berserk_mode
	name = "Берсерк"
	desc = "Увеличьте свое передвижение и скорость ближнего боя, а также свою защиту в ближнем бою на короткое время."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "berserk_mode"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

/datum/action/item_action/berserk_mode/Trigger(trigger_flags)
	if(istype(target, /obj/item/clothing/head/helmet/space/hardsuit/berserker))
		var/obj/item/clothing/head/helmet/space/hardsuit/berserker/berzerk = target
		if(berzerk.berserk_active)
			to_chat(owner, span_warning("Я УЖЕ В ЯРОСТИ!"))
			return
		if(berzerk.berserk_charge < 100)
			to_chat(owner, span_warning("Не хватает заряда."))
			return
		berzerk.berserk_mode(owner)
		return
	return ..()
