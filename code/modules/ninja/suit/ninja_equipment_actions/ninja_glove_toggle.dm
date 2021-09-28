/datum/action/item_action/toggle_glove
	name = "Toggle interaction"
	desc = "Переключение между обычным взаимодействием и режимом слива."
	button_icon_state = "s-ninjan"
	icon_icon = 'icons/obj/clothing/gloves.dmi'

/**
 * Proc called to toggle the ninja glove's special abilities.
 *
 * Used to toggle whether or not the ninja glove's abilities will activate on touch.
 */
/obj/item/clothing/gloves/space_ninja/proc/toggledrain()
	var/mob/living/carbon/human/ninja = loc
	to_chat(ninja, span_notice("[candrain?"disable":"enable"] особое взаимодействие."))
	candrain=!candrain
