/datum/action/item_action/set_internals
	name = "Подача воздуха"
	default_button_position = SCRN_OBJ_INSERT_FIRST

/datum/action/item_action/set_internals/is_action_active(atom/movable/screen/movable/action_button/current_button)
	var/mob/living/carbon/carbon_owner = owner
	return istype(carbon_owner) && target == carbon_owner.internal
